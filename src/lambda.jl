#=
Copyright (c) 2015, Intel Corporation
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
- Redistributions of source code must retain the above copyright notice,
  this list of conditions and the following disclaimer.
- Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
THE POSSIBILITY OF SUCH DAMAGE.
=#

module LambdaHandling

import ..DebugMsg
DebugMsg.init()

using CompilerTools
using CompilerTools.AstWalker
using Core.Inference: to_tuple_type

import Base.show

export SymGen, SymNodeGen, SymAllGen, SymAll
export VarDef, LambdaInfo
export getDesc, getType, getVarDef, isInputParameter, isLocalVariable, isEscapingVariable, isLocalGenSym
export addLocalVariable, addEscapingVariable, addGenSym
export lambdaExprToLambdaInfo, lambdaInfoToLambdaExpr, getBody, getReturnType
export getRefParams, updateAssignedDesc, lambdaTypeinf, replaceExprWithDict, replaceExprWithDict!
export ISCAPTURED, ISASSIGNED, ISASSIGNEDBYINNERFUNCTION, ISCONST, ISASSIGNEDONCE 

# Possible values of VarDef descriptor that can be OR'ed together.
const ISCAPTURED = 1
const ISASSIGNED = 2
const ISASSIGNEDBYINNERFUNCTION = 4
const ISCONST = 8
const ISASSIGNEDONCE = 16

@doc """
Type aliases for different unions of Symbol, SymbolNode, and GenSym.
"""
typealias SymGen     Union{Symbol, GenSym}
typealias SymNodeGen Union{SymbolNode, GenSym}
typealias SymAllGen  Union{Symbol, SymbolNode, GenSym}
typealias SymAll     Union{Symbol, SymbolNode}

@doc """
Represents the triple stored in a lambda's args[2][1].
The triple is 1) the Symbol of an input parameter or local variable, 2) the type of that Symbol, and 3) a descriptor for that symbol.
The descriptor can be 0 if the variable is an input parameter, 1 if it is captured, 2 if it is assigned within the function, 4 if
it is assigned by an inner function, 8 if it is const, and 16 if it is assigned to statically only once by the function.
"""
type VarDef
  name :: Symbol
  typ
  desc :: Int64

  function VarDef(n, t, d)
    new(n, t, d)
  end
end

@doc """
An internal format for storing a lambda expression's args[1] and args[2].
The input parameters are stored as a Set since they must be unique and it makes for faster searching.
The VarDefs are stored as a dictionary from symbol to VarDef since type lookups are reasonably frequent and need to be fast.
The GenSym part (args[2][3]) is stored as an array since GenSym's are indexed.
Captured_outer_vars and static_parameter_names are stored as arrays for now since we don't expect them to be changed much.
"""
type LambdaInfo
  input_params  :: Array{Any,1}
  var_defs      :: Dict{Symbol,VarDef}
  gen_sym_typs  :: Array{Any,1}
  escaping_defs :: Dict{Symbol,VarDef}
  static_parameter_names :: Array{Any,1}
  return_type

  function LambdaInfo()
    new(Any[], Dict{Symbol,VarDef}(), Any[], Dict{Symbol,VarDef}(), Any[], nothing)
  end
end

@doc """
Pretty print a LambdaInfo.
"""
function show(io :: IO, li :: LambdaInfo)
  println(io, "Inputs = ", li.input_params)
  if !isempty(li.static_parameter_names)
    println(io, "Static Parameter Names = ", li.static_parameter_names)
  end
  if li.return_type != nothing
    println(io, "Return type = ", li.return_type)
  end
  if !isempty(li.var_defs)
    println(io, "VarDefs")
    for i in li.var_defs
      println(io, "    ", i[2])
    end
  end
  if !isempty(li.gen_sym_typs)
    println(io, "GenSym")
    for i = 1:length(li.gen_sym_typs)
      println(io, "    ", i-1, " => ", li.gen_sym_typs[i])
    end
  end
  if !isempty(li.escaping_defs)
    println(io, "EscapingDefs")
    for i in li.escaping_defs
      println(io, "    ", i[2])
    end
  end
end

@doc """
Holds symbols and gensyms that are seen in a given AST when using the specified callback to handle non-standard Julia AST types.
"""
type CountSymbolState
  used_symbols :: Set{Symbol}
  used_gensyms :: Set{Int64}

  function CountSymbolState()
    new(Set{Symbol}(), Set{Int64}())
  end
end

@doc """
Adds symbols and gensyms to their corresponding sets in CountSymbolState when they are seen in the AST.
"""
function count_symbols(x::Symbol,
                       state::CountSymbolState,
                       top_level_number,
                       is_top_level,
                       read)
    push!(state.used_symbols, x)
    return CompilerTools.AstWalker.ASTWALK_RECURSE
end

function count_symbols(x::SymbolNode,
                       state::CountSymbolState,
                       top_level_number,
                       is_top_level,
                       read)
    push!(state.used_symbols, x.name)
    return CompilerTools.AstWalker.ASTWALK_RECURSE
end

function count_symbols(x::GenSym,
                       state::CountSymbolState,
                       top_level_number,
                       is_top_level,
                       read)
    push!(state.used_gensyms, x.id)
    return CompilerTools.AstWalker.ASTWALK_RECURSE
end

function count_symbols(x::ANY,
                       state::CountSymbolState,
                       top_level_number,
                       is_top_level,
                       read)
    return CompilerTools.AstWalker.ASTWALK_RECURSE
end

@doc """
Eliminates unused symbols from the LambdaInfo var_defs.
Takes a LambdaInfo to modify, the body to scan using AstWalk and an optional callback to AstWalk for custom AST types.
"""
function eliminateUnusedLocals!(li :: LambdaInfo, body :: Expr, AstWalkFunc = nothing)
  css = CountSymbolState()
  if AstWalkFunc == nothing
    CompilerTools.AstWalker.AstWalk(body, count_symbols, css)
  else
    AstWalkFunc(body, count_symbols, css)
  end
  dprintln(3,"css = ", css)
  for i in li.var_defs
    if in(i[1], li.input_params)
      continue
    end
    if !in(i[1], css.used_symbols)
      delete!(li.var_defs, i[1])
    end
  end

  gensymdict = Dict{SymGen,Any}()
  newgensym  = Any[]
  next_id    = 0
  for i = 0:length(li.gen_sym_typs)-1
    if in(i, css.used_gensyms)
      push!(newgensym, li.gen_sym_typs[i+1])
      gensymdict[GenSym(i)] = GenSym(next_id)
      next_id = next_id + 1
    end
  end
  dprintln(3,"gensymdict = ", gensymdict)
  dprintln(3,"newgensym = ", newgensym)
  li.gen_sym_typs = newgensym
  body = replaceExprWithDict!(body, gensymdict, AstWalkFunc)
  dprintln(3,"updated body = ", body)
  return body
end

@doc """
Add Symbol "s" as input parameter to LambdaInfo "li".
"""
function addInputParameter(vd :: VarDef, li :: LambdaInfo)
  push!(li.input_params, vd.name)
  addLocalVariable(vd, li)
end

@doc """
Add all variable in "collection" as input parameters to LambdaInfo "li".
"""
function addInputParameters(collection, li :: LambdaInfo)
  for i in collection
    addInputParameter(i, li)
  end
end

@doc """
Returns the type of a Symbol or GenSym in "x" from LambdaInfo in "li".
"""
function getType(x::Symbol, li::LambdaInfo)
    if haskey(li.var_defs, x) li.var_defs[x].typ
    elseif haskey(li.escaping_defs, x) li.escaping_defs[x].typ
    else 
        res = eval(x)
        res_typ = typeof(res)
        dprintln(3, "getType Symbol x = ", x, " eval(x) = ", res, " typeof(res) = ", res_typ)
        if res_typ == DataType
            return res_typ
        else
            throw(string("getType called with ", x, " which is not found in LambdaInfo: ", li))
        end
    end
end

function getType(x::GenSym, li::LambdaInfo)
    return li.gen_sym_typs[x.id + 1]
end

function getType(x::Union{SymbolNode,Expr}, li::LambdaInfo)
    return x.typ
end

function getType(x::Any, li::LambdaInfo)
    throw(string("getType called with neither Symbol or GenSym input.  Instead the input type was ", typeof(x)))
end

@doc """
Returns the descriptor for a local variable or input parameter "x" from LambdaInfo in "li".
"""
function getDesc(x :: Symbol, li :: LambdaInfo)
  return li.var_defs[x].desc
end

@doc """
Returns the VarDef for a Symbol in LambdaInfo in "li"
"""
function getVarDef(s :: Symbol, li :: LambdaInfo)
  return li.var_defs[s]
end

@doc """
Returns true if the Symbol in "s" is an input parameter in LambdaInfo in "li".
"""
function isInputParameter(s :: Symbol, li :: LambdaInfo)
  return in(s, li.input_params)
end

@doc """
Returns true if the Symbol in "s" is a local variable in LambdaInfo in "li".
"""
function isLocalVariable(s :: Symbol, li :: LambdaInfo)
  return haskey(li.var_defs, s) && !isInputParameter(s, li)
end

@doc """
Returns an array of Symbols for local variables.
"""
function getLocalVariables(li :: LambdaInfo)
  return setdiff(collect(keys(li.var_defs)), li.input_params)
end

@doc """
Returns true if the Symbol in "s" is an escaping variable in LambdaInfo in "li".
"""
function isEscapingVariable(s :: Symbol, li :: LambdaInfo)
  return haskey(li.escaping_defs, s) && !isInputParameter(s, li)
end

@doc """
Returns true if the GenSym in "s" is a GenSym in LambdaInfo in "li".
"""
function isLocalGenSym(s :: GenSym, li :: LambdaInfo)
  return s.id >= 0 && s.id < size(li.gen_sym_typs, 1)
end

@doc """
Add multiple local variables from some collection type.
"""
function addLocalVariables(collection, li :: LambdaInfo)
  for i in collection
    addLocalVariable(i, li)
  end
end

@doc """
Adds a local variable from a VarDef to the given LambdaInfo.
"""
function addLocalVariable(vd :: VarDef, li :: LambdaInfo)
  addLocalVariable(vd.name, vd.typ, vd.desc, li)
end

@doc """
Add one or more bitfields in "desc_flag" to the descriptor for a variable.
"""
function addDescFlag(s :: Symbol, desc_flag :: Int64, li :: LambdaInfo)
  if haskey(li.var_defs, s)
    var_def      = li.var_defs[s]
    var_def.desc = var_def.desc | desc_flag
    return true
  else
    return false
  end
end

@doc """
Adds a new local variable with the given Symbol "s", type "typ", descriptor "desc" in LambdaInfo "li".
Returns true if the variable already existed and its type and descriptor were updated, false otherwise.
"""
function addLocalVariable(s :: Symbol, typ, desc :: Int64, li :: LambdaInfo)
  # If it is already a local variable then just update its type and desc.
  if haskey(li.var_defs, s)
    var_def      = li.var_defs[s]
    dprintln(3,"addLocalVariable ", s, " already exists with type ", var_def.typ)
    var_def.typ  = typ
    var_def.desc = desc
    return true
  end

  li.var_defs[s] = VarDef(s, typ, desc)
  dprintln(3,"addLocalVariable = ", s)

  return false
end

@doc """
Adds a new escaping variable with the given Symbol "s", type "typ", descriptor "desc" in LambdaInfo "li".
Returns true if the variable already existed and its type and descriptor were updated, false otherwise.
"""
function addEscapingVariable(s :: Symbol, typ, desc :: Int64, li :: LambdaInfo)
  assert(!isInputParameter(s, li))
  # If it is already a local variable then just update its type and desc.
  if haskey(li.escaping_defs, s)
    var_def      = li.var_defs[s]
    dprintln(3,"addEscapingVariable ", s, " already exists with type ", var_def.typ)
    var_def.typ  = typ
    var_def.desc = desc
    return true
  end

  li.escaping_defs[s] = VarDef(s, typ, desc)
  dprintln(3,"addEscapingVariable = ", s)

  return false
end

@doc """
Adds a new escaping variable from a VarDef in parameter "vd" into LambdaInfo "li".
"""
function addEscapingVariable(vd :: VarDef, li :: LambdaInfo)
  addEscapingVariable(vd.name, vd.typ, vd.desc, li)
end

@doc """
Add a new GenSym to the LambdaInfo in "li" with the given type in "typ".
Returns the new GenSym.
"""
function addGenSym(typ, li :: LambdaInfo)
  push!(li.gen_sym_typs, typ)
  return GenSym(length(li.gen_sym_typs) - 1) 
end

@doc """
Add a local variable to the function corresponding to LambdaInfo in "li" with name (as String), type and descriptor.
Returns true if variable already existed and was updated, false otherwise.
"""
function addLocalVar(name :: AbstractString, typ, desc :: Int64, li :: LambdaInfo)
  addLocalVar(Symbol(name), typ, desc, li)
end

@doc """
Add a local variable to the function corresponding to LambdaInfo in "li" with name (as Symbol), type and descriptor.
Returns true if variable already existed and was updated, false otherwise.
"""
function addLocalVar(name :: Symbol, typ, desc :: Int64, li :: LambdaInfo)
  if haskey(li.var_defs, name)
    var_def = li.var_defs[name]
    var_def.typ  = typ
    var_def.desc = desc
    return true
  end

  li.var_defs[name] = VarDef(name, typ, desc)
  return false
end

@doc """
Remove a local variable from lambda "li" given the variable's "name".
Returns true if the variable existed and it was removed, false otherwise.
"""
function removeLocalVar(name :: Symbol, li :: LambdaInfo)
  if haskey(li.var_defs, name)
    delete!(li.var_defs, name)
    return true
  else
    return false
  end
end

@doc """
Convert the lambda expression's args[2][1] from Array{Array{Any,1},1} to a Dict{Symbol,VarDef}.
The internal triples are extracted and asserted that name and desc are of the appropriate type.
"""
function createVarDict(x :: Array{Any, 1})
  ret = Dict{Symbol,VarDef}()
  dprintln(1,"createVarDict ", x)
  for i = 1:length(x)
    dprintln(1,"x[i] = ", x[i])
    name = x[i][1]
    typ  = x[i][2]
    desc = x[i][3]
    if typeof(name) != Symbol
      dprintln(0, "name is not of type symbol ", name, " type = ", typeof(name))
    end
    if typeof(desc) != Int64
      dprintln(0, "desc is not of type Int64 ", desc, " type = ", typeof(desc))
    end
    ret[name] = VarDef(name, typ, desc)
  end
  return ret
end

@doc """
Replace the symbols in an expression "expr" with those defined in the
dictionary "dict".  Return the result expression, which may share part of the
input expression, but the input "expr" remains intact and is not modified.

Note that unlike "replaceExprWithDict!", we do not recurse down nested lambda
expressions (i.e., LambdaStaticData or DomainLambda or any other none Expr
objects are left unchanged). If such lambdas have escaping names that are to be
replaced, then the result will be wrong.
"""
function replaceExprWithDict(expr::Any, dict::Dict{SymGen, Any})
  function traverse(expr :: ANY)       # traverse expr to find the places where arrSym is refernced
    if isa(expr, Symbol) || isa(expr, GenSym)
      if haskey(dict, expr)
        return dict[expr]
      end
      return expr
    elseif isa(expr, SymbolNode)
      if haskey(dict, expr.name)
        return dict[expr.name]
      end
      return expr
    elseif isa(expr, Array)
      Any[ traverse(e) for e in expr ]
    elseif isa(expr, Expr)
      local head = expr.head
      local args = copy(expr.args)
      local typ  = expr.typ
      for i = 1:length(args)
        args[i] = traverse(args[i])
      end
      expr = Expr(expr.head, args...)
      expr.typ = typ
      return expr
    else
      expr
    end
  end
  expr=traverse(expr)
  return expr
end


@doc """
Replace the symbols in an expression "expr" with those defined in the
dictionary "dict".  Return the result expression, which may share part of the
input expression, and the input "expr" may be modified inplace and shall not be used
after this call. Note that unlike "replaceExprWithDict", the traversal here is
done by ASTWalker, which has the ability to traverse non-Expr data.
"""
function replaceExprWithDict!(expr :: ANY, dict :: Dict{SymGen, Any}, AstWalkFunc = nothing)
  function update_sym(expr :: ANY, dict, top_level_number :: Int64, is_top_level :: Bool, read :: Bool)
    if isa(expr, Symbol) || isa(expr, GenSym)
      if haskey(dict, expr)
        return dict[expr]
      end
    elseif isa(expr, SymbolNode)
      if haskey(dict, expr.name)
        return dict[expr.name]
      end
    end
    return CompilerTools.AstWalker.ASTWALK_RECURSE
  end

  if expr == nothing
    return nothing
  end

  dprintln(3, "replaceExprWithDict!: ", expr, " dict = ", dict, " AstWalkFunc = ", AstWalkFunc)
  if isa(expr,Array)
    for i = 1:length(expr)
      if AstWalkFunc == nothing
        expr[i] = CompilerTools.AstWalker.AstWalk(expr[i], update_sym, dict)
      else
        expr[i] = AstWalkFunc(expr[i], update_sym, dict)
      end
    end
  else
    if AstWalkFunc == nothing
      expr = CompilerTools.AstWalker.AstWalk(expr, update_sym, dict)
    else
      expr = AstWalkFunc(expr, update_sym, dict)
    end
  end
  return expr
end

@doc """
Merge "inner" lambdaInfo into "outer", and "outer" is changed as result.  Note
that the input_params, static_parameter_names, and escaping_defs of "outer" do
not change, other fields are merged. The GenSyms in "inner" will need to adjust
their indices as a result of this merge. We return a dictionary that maps from
old GenSym to new GenSym for "inner", which can be used to adjust the body Expr
of "inner" lambda using "replaceExprWithDict" or "replaceExprWithDict!".
"""
function mergeLambdaInfo(outer :: LambdaInfo, inner :: LambdaInfo)
  dprintln(3,"outer = ", outer)
  dprintln(3,"inner = ", inner)
  for (v, d) in inner.var_defs
    if isLocalVariable(v, outer) 
      if !isInputParameter(v, inner) # skip input parameters
        dprintln(1, string("Conflicting variable ", v, " exists in both inner and outer lambda"))
      end
    else
      addLocalVariable(d, outer)
    end
  end
  outer.var_defs = merge(outer.var_defs, inner.var_defs)
  for (v, d) in inner.escaping_defs
    if !isLocalVariable(v, outer) && !isInputParameter(v, outer) && !isEscapingVariable(v, outer)
      dprintln(1, string("Variable ", v, " from inner lambda is neither parameter nor local nor escaping in outer lambda"))
    end
  end
  n = length(outer.gen_sym_typs)
  dict = Dict{SymGen, Any}()
  for i = 1:length(inner.gen_sym_typs)
    push!(outer.gen_sym_typs, inner.gen_sym_typs[i])
    old_sym = GenSym(i - 1)
    new_sym = GenSym(n + i - 1)
    dict[old_sym] = new_sym
  end
  return dict
end

@doc """
Convert a lambda expression into our internal storage format, LambdaInfo.
The input is asserted to be an expression whose head is :lambda.
"""
function lambdaExprToLambdaInfo(lambda :: Expr)
  assert(lambda.head == :lambda)
  assert(length(lambda.args) == 3)

  ret = LambdaInfo()
  # Convert array of input parameters in lambda.args[1] into an array of Symbol.
  for i = 1:length(lambda.args[1])
    one_input = lambda.args[1][i]
    oityp = typeof(one_input)
    if oityp == Symbol
      push!(ret.input_params, one_input)
    elseif oityp == Expr && one_input.head == :(::)
      push!(ret.input_params, one_input.args[1])
    else
      dprintln(0, "Converting lambda expresison to lambda info found unhandled input parameter type.  input = ", one_input, " type = ", oityp)
    end
  end

  # We call the second part of the lambda metadata.
  meta = lambda.args[2]
  dprintln(1,"meta = ", meta)
  # Create a searchable dictionary mapping symbols to their VarDef information.
  ret.var_defs = createVarDict(meta[1])
  ret.escaping_defs = createVarDict(meta[2])
  if !isa(meta[3], Array) 
    ret.gen_sym_typs = Any[]
  else
    ret.gen_sym_typs = meta[3]
  end
  ret.static_parameter_names = meta[4]

  assert(typeof(lambda.args[3]) == Expr)
  assert(lambda.args[3].head == :body)
  ret.return_type = lambda.args[3].typ

  return ret
end

@doc """
Returns the type of the lambda as stored in LambdaInfo "li" and as extracted during lambdaExprToLambdaInfo.
"""
function getReturnType(li :: LambdaInfo)
  return li.return_type
end

@doc """
Force type inference on a LambdaStaticData object.
Return both the inferred AST that is to a "code_typed(Function, (type,...))" call, 
and the inferred return type of the input method.
"""
function lambdaTypeinf(lambda :: LambdaStaticData, typs :: Tuple; optimize = true)
  (tree, ty) = Core.Inference.typeinf_uncached(lambda, to_tuple_type(typs), Core.svec(), optimize = optimize)
  lambda.ast = tree
  return Base.uncompressed_ast(lambda), ty
end

@doc """
Convert the Dict{Symbol,VarDef} internal storage format from a dictionary back into an array of Any triples.
"""
function dictToArray(x :: Dict{Symbol,VarDef})
  ret = Any[]
  for (k, s) in x
    push!(ret, [s.name; s.typ; s.desc])
  end
  return ret
end

@doc """
Create the args[2] part of a lambda expression given an object of our internal storage format LambdaInfo.
"""
function createMeta(lambdaInfo :: LambdaInfo)
  ret = Any[]

  push!(ret, dictToArray(lambdaInfo.var_defs))
  push!(ret, dictToArray(lambdaInfo.escaping_defs))
  push!(ret, lambdaInfo.gen_sym_typs)
  push!(ret, lambdaInfo.static_parameter_names)

  return ret
end

@doc """
Convert our internal storage format, LambdaInfo, back into a lambda expression.
This takes a LambdaInfo and a body as input parameters.
This body can be a body expression or you can pass "nothing" if you want but then you will probably need to set the body in args[3] manually by yourself.
"""
function lambdaInfoToLambdaExpr(lambdaInfo :: LambdaInfo, body)
  assert(typeof(body) == Expr)
  assert(body.head == :body)
  return Expr(:lambda, lambdaInfo.input_params, createMeta(lambdaInfo), body)
end

@doc """
Update the descriptor part of the VarDef dealing with whether the variable is assigned or not in the function.
Takes the lambdaInfo and a dictionary that maps symbols names to the number of times they are statically assigned in the function.
"""
function updateAssignedDesc(lambdaInfo :: LambdaInfo, symbol_assigns :: Dict{Symbol,Int})
  # For each VarDef
  for i in lambdaInfo.var_defs
    # If that VarDef's symbol is in the dictionary.
    if haskey(symbol_assigns, i[1])
      var_def = i[2]
      # Get how many times the symbol is assigned to.
      num_assigns = symbol_assigns[var_def.name]
      # Remove the parts of the descriptor dealing with the number of assignments.
      var_def.desc = var_def.desc & (~ (ISASSIGNED | ISASSIGNEDONCE)) 
      if num_assigns > 1
        # If more than one assignment then OR on ISASSIGNED.
        var_def.desc = var_def.desc | ISASSIGNED
      elseif num_assigns == 1
        # If exactly one assignment then OR on ISASSIGNED and ISASSIGNEDONCE
        var_def.desc = var_def.desc | ISASSIGNED | ISASSIGNEDONCE
      end
    end
  end
end

@doc """
Returns the body expression part of a lambda expression.
"""
function getBody(lambda :: Expr)
  assert(lambda.head == :lambda)
  return lambda.args[3]
end

@doc """
Returns an array of Symbols corresponding to those parameters to the method that are going to be passed by reference.
In short, isbits() types are passed by value and !isbits() types are passed by reference.
"""
function getRefParams(lambdaInfo :: LambdaInfo)
  ret = Symbol[]

  input_vars = lambdaInfo.input_params
  var_types  = lambdaInfo.var_defs

  dprintln(3,"input_vars = ", input_vars)
  dprintln(3,"var_types = ", var_types)

  for iv in input_vars
    dprintln(3,"iv = ", iv, " type = ", typeof(iv))
    if haskey(var_types, iv)
      var_def = var_types[iv] 
      if !isbits(var_def.typ)
        push!(ret, iv)
      end
    else
      throw(string("Didn't find parameter variable ", iv, " in type list."))
    end
  end

  return ret
end

end
