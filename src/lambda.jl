module LambdaHandling

import Base.show

export VarDef, LambdaInfo
export getType, getVarDef, isInputParameter, isLocalVariable, isLocalGenSym
export addLocalVariable, addEscapingVariable, addGenSym
export lambdaExprToLambdaInfo, lambdaInfoToLambdaExpr
export getRefParams, updateAssignedDesc, lambdaTypeinf
export ISCAPTURED, ISASSIGNED, ISASSIGNEDBYINNERFUNCTION, ISCONST, ISASSIGNEDONCE 


# This controls the debug print level.  0 prints nothing.  3 print everything.
DEBUG_LVL=0

@doc """
Control how much debugging output is generated by this module.  
Takes one Int argument where: 0 prints nothing. 
Increasing values print more debugging output up to a maximum of debug level 3.
"""
function set_debug_level(x)
    global DEBUG_LVL = x
end

@doc """
Calls print to print a message if the incoming debug level is greater than or equal to the level specified in set_debug_level().
First argument: the detail level of the debugging information.  Higher numbers for higher detail.
Second+ arguments: the message to print if the debug level is satisfied.
"""
function dprint(level,msgs...)
    if(DEBUG_LVL >= level)
        print(msgs...)
    end
end

@doc """
Calls println to print a message if the incoming debug level is greater than or equal to the level specified in set_debug_level().
First argument: the detail level of the debugging information.  Higher numbers for higher detail.
Second+ arguments: the message to print if the debug level is satisfied.
"""
function dprintln(level,msgs...)
    if(DEBUG_LVL >= level)
        println(msgs...)
    end
end

# Possible values of VarDef descriptor that can be OR'ed together.
const ISCAPTURED = 1
const ISASSIGNED = 2
const ISASSIGNEDBYINNERFUNCTION = 4
const ISCONST = 8
const ISASSIGNEDONCE = 16

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
  input_params  :: Set{Symbol}
  var_defs      :: Dict{Symbol,VarDef}
  gen_syms      :: Array{Any,1}
  escaping_defs :: Dict{Symbol,VarDef}
  static_parameter_names :: Array{Any,1}

  function LambdaInfo()
    new(Set{Symbol}(), Dict{Symbol,VarDef}(), Any[], Dict{Symbol,VarDef}(), Any[])
  end
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
function getType(x, li :: LambdaInfo)
  if typeof(x) == Symbol
    return li.var_defs[x].typ
  elseif typeof(x) == GenSym
    return li.gen_syms[x.id + 1]
  else
    throw(string("getType called with neither Symbol or GenSym input.  Instead the input type was ", typeof(x)))
  end
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
Returns true if the Symbol in "s" is an escaping variable in LambdaInfo in "li".
"""
function isEscapingVariable(s :: Symbol, li :: LambdaInfo)
  return haskey(li.escaping_defs, s) && !isInputParameter(s, li)
end

@doc """
Returns true if the GenSym in "s" is a GenSym in LambdaInfo in "li".
"""
function isLocalGenSym(s :: GenSym, li :: LambdaInfo)
  return s.id >= 0 && s.id < size(li.gen_syms, 1)
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
  assert(!isInputParameter(s, li))
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
Add a new GenSym to the LambdaInfo in "li" with the given type in "typ".
Returns the new GenSym.
"""
function addGenSym(typ, li :: LambdaInfo)
  push!(li.gen_syms, typ)
  return GenSym(length(li.gen_syms) - 1) 
end

@doc """
Add a local variable to the function corresponding to LambdaInfo in "li" with name (as String), type and descriptor.
Returns true if variable already existed and was updated, false otherwise.
"""
function addLocalVar(name :: String, typ, desc :: Int64, li :: LambdaInfo)
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
Convert the lambda expression's args[1] from array of any to Set of Symbol to be stored in LambdaInfo.
We make sure that each element of the array is indeed a Symbol.
"""
function createVarSet(x :: Array{Any,1})
  ret = Set{Symbol}()
  for i = 1:length(x)
    assert(typeof(x[i]) == Symbol)
    push!(ret, x[i])
  end
  return ret
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
Merge "inner" lambdaInfo into "outer".
"""
function mergeLambdaInfo(outer :: LambdaInfo, inner :: LambdaInfo)
  for i in inner.var_defs
    if !in(outer.var_defs, i[1])
      outer.var_defs[i[1]] = i[2] 
    end
  end
end

@doc """
Convert a lambda expression into our internal storage format, LambdaInfo.
The input is asserted to be an expression whose head is :lambda.
"""
function lambdaExprToLambdaInfo(lambda :: Expr)
  assert(lambda.head == :lambda)
  assert(length(lambda.args) == 3)

  ret = LambdaInfo()
  # Convert array of input parameters in lambda.args[1] into a searchable Set.
  ret.input_params = createVarSet(lambda.args[1]) 
  # We call the second part of the lambda metadata.
  meta = lambda.args[2]
  dprintln(1,"meta = ", meta)
  # Create a searchable dictionary mapping symbols to their VarDef information.
  ret.var_defs = createVarDict(meta[1])
  ret.escaping_defs = createVarDict(meta[2])
  if !isa(meta[3], Array) 
    ret.gen_syms = Any[]
  else
    ret.gen_syms = meta[3]
  end
  ret.static_parameter_names = meta[4]

  return ret
end

@doc """
Force type inference on a LambdaStaticData object.
Return both the inferred AST that is to a "code_typed(Function, (type,...))" call, 
and the inferred return type of the input method.
"""
function lambdaTypeinf(lambda :: LambdaStaticData, typs :: Type)
  (tree, ty) = Core.Inference.typeinf(lambda, typs, Core.svec())
  lambda.ast = tree
  return Base.uncompressed_ast(lambda), ty
end

@doc """
Convert the set of Symbols corresponding to the input parameters back to an array for inclusion in a new lambda expression.
"""
function setToArray(x :: Set{Symbol})
  ret = Any[]
  for s in x
    push!(ret, s)
  end
  return ret
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
  push!(ret, lambdaInfo.gen_syms)
  push!(ret, lambdaInfo.static_parameter_names)

  return ret
end

@doc """
Convert our internal storage format, LambdaInfo, back into a lambda expression.
This takes a LambdaInfo and a body as input parameters.
This body can be a body expression or you can pass "nothing" if you want but then you will probably need to set the body in args[3] manually by yourself.
"""
function lambdaInfoToLambdaExpr(lambdaInfo :: LambdaInfo, body)
  return Expr(:lambda, setToArray(lambdaInfo.input_params), createMeta(lambdaInfo), body)
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
