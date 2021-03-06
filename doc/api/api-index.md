# API-INDEX


## MODULE: CompilerTools.CFGs

---

## Exported

[find_bb_for_statement(top_number::Int64,  bl::CompilerTools.CFGs.CFG)](CompilerTools.CFGs.md#method__find_bb_for_statement.1)  Find the basic block that contains a given statement number.

[from_exprs(ast::Array{Any, 1},  depth,  state,  callback,  cbdata)](CompilerTools.CFGs.md#method__from_exprs.1)  Process an array of expressions.

[show(io::IO,  bb::CompilerTools.CFGs.BasicBlock)](CompilerTools.CFGs.md#method__show.1)  Overload of Base.show to pretty-print a CFGS.BasicBlock object.

[show(io::IO,  bl::CompilerTools.CFGs.CFG)](CompilerTools.CFGs.md#method__show.2)  Overload of Base.show to pretty-print a CFG object.

[show(io::IO,  tls::CompilerTools.CFGs.TopLevelStatement)](CompilerTools.CFGs.md#method__show.3)  Overload of Base.show to pretty-print a TopLevelStatement.

---

## Internal

[TypedExpr(typ,  rest...)](CompilerTools.CFGs.md#method__typedexpr.1)  Creates a typed Expr AST node.

[addStatement(top_level,  state,  ast::ANY)](CompilerTools.CFGs.md#method__addstatement.1)  Adds a top-level statement just encountered during a partial walk of the AST.

[addStatementToEndOfBlock(bl::CompilerTools.CFGs.CFG,  block,  stmt)](CompilerTools.CFGs.md#method__addstatementtoendofblock.1)  Given a CFG "bl" and a basic "block", add statement "stmt" to the end of that block.

[changeEndingLabel(bb,  after::CompilerTools.CFGs.BasicBlock,  new_bb::CompilerTools.CFGs.BasicBlock)](CompilerTools.CFGs.md#method__changeendinglabel.1)  BasicBlock bb currently is known to contain a jump to the BasicBlock after.

[compute_dfn(basic_blocks)](CompilerTools.CFGs.md#method__compute_dfn.1)  Computes the depth first numbering of the basic block graph.

[compute_dfn_internal(basic_blocks,  cur_bb,  cur_dfn,  visited,  bbs_df_order)](CompilerTools.CFGs.md#method__compute_dfn_internal.1)  The recursive heart of depth first numbering.

[compute_dominators(bl::CompilerTools.CFGs.CFG)](CompilerTools.CFGs.md#method__compute_dominators.1)  Compute the dominators of the CFG.

[compute_inverse_dominators(bl::CompilerTools.CFGs.CFG)](CompilerTools.CFGs.md#method__compute_inverse_dominators.1)  Compute the inverse dominators of the CFG.

[connect(from,  to,  fallthrough)](CompilerTools.CFGs.md#method__connect.1)  Connect the "from" input argument basic block to the "to" input argument basic block.

[connect_finish(state)](CompilerTools.CFGs.md#method__connect_finish.1)  Connect the current basic block as a fallthrough to the final invisible basic block (-2).

[createFunctionBody(bl::CompilerTools.CFGs.CFG)](CompilerTools.CFGs.md#method__createfunctionbody.1)  Create the array of statements that go in a :body Expr given a CFG "bl".

[dump_bb(bl::CompilerTools.CFGs.CFG)](CompilerTools.CFGs.md#method__dump_bb.1)  Prints a CFG "bl" with varying degrees of verbosity from debug level 2 up to 4.

[findReachable(reachable,  cur::Int64,  bbs::Dict{Int64, CompilerTools.CFGs.BasicBlock})](CompilerTools.CFGs.md#method__findreachable.1)  Process a basic block and add its successors to the set of reachable blocks

[find_top_number(top_number::Int64,  bl::CompilerTools.CFGs.CFG)](CompilerTools.CFGs.md#method__find_top_number.1)  Search for a statement with the given number in the CFG "bl".

[from_ast(ast)](CompilerTools.CFGs.md#method__from_ast.1)  The main entry point to construct a control-flow graph.

[from_expr(ast,  callback,  cbdata)](CompilerTools.CFGs.md#method__from_expr.1)  Another entry point to construct a control-flow graph but one that allows you to pass a callback and some opaque object

[from_expr(ast::LambdaStaticData,  depth,  state,  top_level,  callback,  cbdata)](CompilerTools.CFGs.md#method__from_expr.2)  The main routine that switches on all the various AST node types.

[from_goto(label,  state,  callback,  cbdata)](CompilerTools.CFGs.md#method__from_goto.1)  Process a GotoNode for CFG construction.

[from_if(args,  depth,  state,  callback,  cbdata)](CompilerTools.CFGs.md#method__from_if.1)  Process a :gotoifnot Expr not for CFG construction.

[from_label(label,  state,  callback,  cbdata)](CompilerTools.CFGs.md#method__from_label.1)  Process LabelNode for CFG construction.

[from_lambda(ast::Array{Any, 1},  depth,  state,  callback,  cbdata)](CompilerTools.CFGs.md#method__from_lambda.1)  To help construct the CFG given a lambda, we recursively process the body of the lambda.

[from_return(args,  depth,  state,  callback,  cbdata)](CompilerTools.CFGs.md#method__from_return.1)  Process a :return Expr for CFG construction.

[getBbBodyOrder(bl::CompilerTools.CFGs.CFG)](CompilerTools.CFGs.md#method__getbbbodyorder.1)  Determine a valid and reasonable order of basic blocks in which to reconstruct a :body Expr.

[getDistinctStatementNum(bl::CompilerTools.CFGs.CFG)](CompilerTools.CFGs.md#method__getdistinctstatementnum.1)  Get a possible new statement number by finding the maximum statement value in any BasicBlock in the given CFG and adding 1.

[getMaxBB(bl::CompilerTools.CFGs.CFG)](CompilerTools.CFGs.md#method__getmaxbb.1)  Returns the maximum basic block label for the given CFG.

[getMaxStatementNum(bb::CompilerTools.CFGs.BasicBlock)](CompilerTools.CFGs.md#method__getmaxstatementnum.1)  Get the maximum statement index for a given BasicBlock.

[getMinBB(bl::CompilerTools.CFGs.CFG)](CompilerTools.CFGs.md#method__getminbb.1)  Returns the minimum basic block label for the given CFG.

[insertBefore(bl::CompilerTools.CFGs.CFG,  after::Int64)](CompilerTools.CFGs.md#method__insertbefore.1)  Given a CFG in input parameter "bl" and a basic block label "after" in that CFG,

[insertBefore(bl::CompilerTools.CFGs.CFG,  after::Int64,  excludeBackEdge::Bool)](CompilerTools.CFGs.md#method__insertbefore.2)  Given a CFG in input parameter "bl" and a basic block label "after" in that CFG,

[insertBefore(bl::CompilerTools.CFGs.CFG,  after::Int64,  excludeBackEdge::Bool,  back_edge)](CompilerTools.CFGs.md#method__insertbefore.3)  Given a CFG in input parameter "bl" and a basic block label "after" in that CFG,

[insertBetween(bl::CompilerTools.CFGs.CFG,  before::Int64,  after::Int64)](CompilerTools.CFGs.md#method__insertbetween.1)  Insert a new basic block into the CFG "bl" between the basic blocks whose labels are "before" and "after".

[insertStatementAfter(bl::CompilerTools.CFGs.CFG,  block,  stmt_idx,  new_stmt)](CompilerTools.CFGs.md#method__insertstatementafter.1)  For a given CFG "bl" and a "block" in that CFG, add a new statement "new_stmt" to the basic block

[insertStatementBefore(bl::CompilerTools.CFGs.CFG,  block,  stmt_idx,  new_stmt)](CompilerTools.CFGs.md#method__insertstatementbefore.1)  For a given CFG "bl" and a "block" in that CFG, add a new statement "new_stmt" to the basic block

[insertat!(a,  value,  idx)](CompilerTools.CFGs.md#method__insertat.1)  Insert into an array "a" with a given "value" at the specified index "idx".

[not_handled(a,  b)](CompilerTools.CFGs.md#method__not_handled.1)  A default callback that handles no extra AST node types.

[removeUselessBlocks(bbs::Dict{Int64, CompilerTools.CFGs.BasicBlock})](CompilerTools.CFGs.md#method__removeuselessblocks.1)  This function simplifies the dict of basic blocks "bbs".

[replaceSucc(cur_bb::CompilerTools.CFGs.BasicBlock,  orig_succ::CompilerTools.CFGs.BasicBlock,  new_succ::CompilerTools.CFGs.BasicBlock)](CompilerTools.CFGs.md#method__replacesucc.1)  For a given basic block "cur_bb", replace one of its successors "orig_succ" with a different successor "new_succ".

[uncompressed_ast(l::LambdaStaticData)](CompilerTools.CFGs.md#method__uncompressed_ast.1)  Convert a compressed LambdaStaticData format into the uncompressed AST format.

[update_label(x::Expr,  state::CompilerTools.CFGs.UpdateLabelState,  top_level_number,  is_top_level,  read)](CompilerTools.CFGs.md#method__update_label.1)  An AstWalk callback that pattern matches GotoNode's and :gotoifnot Expr nodes and determines if the

[wrapInConditional(bl::CompilerTools.CFGs.CFG,  cond_gotoifnot::Expr,  first::Int64,  merge::Int64)](CompilerTools.CFGs.md#method__wrapinconditional.1)  Modifies the CFG to create a conditional (i.e., if statement) that wraps a certain region of the CFG whose entry block is

[wrapInConditional(bl::CompilerTools.CFGs.CFG,  cond_gotoifnot::Expr,  first::Int64,  merge::Int64,  back_edge::Union{CompilerTools.CFGs.BasicBlock, Void})](CompilerTools.CFGs.md#method__wrapinconditional.2)  Modifies the CFG to create a conditional (i.e., if statement) that wraps a certain region of the CFG whose entry block is

[CompilerTools.CFGs.BasicBlock](CompilerTools.CFGs.md#type__basicblock.1)  Data structure to hold information about one basic block in the control-flow graph.

[CompilerTools.CFGs.CFG](CompilerTools.CFGs.md#type__cfg.1)  The main data structure to hold information about the control flow graph.

[CompilerTools.CFGs.TopLevelStatement](CompilerTools.CFGs.md#type__toplevelstatement.1)  Data structure to hold the index (relative to the beginning of the body of the function) of a top-level statement

[CompilerTools.CFGs.UpdateLabelState](CompilerTools.CFGs.md#type__updatelabelstate.1)  The opaque callback data type for the update_label callback.

[CompilerTools.CFGs.expr_state](CompilerTools.CFGs.md#type__expr_state.1)  Collects information about the CFG as it is being constructed.

## MODULE: CompilerTools.ReadWriteSet

---

## Exported

[from_exprs(ast::Array{T, N})](CompilerTools.ReadWriteSet.md#method__from_exprs.1)  Walk through an array of expressions.

[from_exprs(ast::Array{T, N},  callback::Union{Function, Void},  cbdata::ANY)](CompilerTools.ReadWriteSet.md#method__from_exprs.2)  Walk through an array of expressions.

[from_exprs(ast::Array{T, N},  depth::Integer,  rws::CompilerTools.ReadWriteSet.ReadWriteSetType,  callback::Union{Function, Void},  cbdata::ANY)](CompilerTools.ReadWriteSet.md#method__from_exprs.3)  Walk through an array of expressions.

[isRead(sym::Union{GenSym, Symbol},  rws::CompilerTools.ReadWriteSet.ReadWriteSetType)](CompilerTools.ReadWriteSet.md#method__isread.1)  Return true if some symbol in "sym" is read either as a scalar or array within the computed ReadWriteSetType.

[isWritten(sym::Union{GenSym, Symbol},  rws::CompilerTools.ReadWriteSet.ReadWriteSetType)](CompilerTools.ReadWriteSet.md#method__iswritten.1)  Return true if some symbol in "sym" is written either as a scalar or array within the computed ReadWriteSetType.

[CompilerTools.ReadWriteSet.AccessSet](CompilerTools.ReadWriteSet.md#type__accessset.1)  Holds which scalars and which array are accessed and for array which index expressions are used.

[CompilerTools.ReadWriteSet.ReadWriteSetType](CompilerTools.ReadWriteSet.md#type__readwritesettype.1)  Stores which scalars and arrays are read or written in some code region.

---

## Internal

[addIndexExpr!(this_dict,  array_name,  index_expr)](CompilerTools.ReadWriteSet.md#method__addindexexpr.1)  Takes a dictionary of symbol to an array of index expression.

[from_assignment(ast::Array{Any, 1},  depth::Integer,  rws::CompilerTools.ReadWriteSet.ReadWriteSetType,  callback::Union{Function, Void},  cbdata::ANY)](CompilerTools.ReadWriteSet.md#method__from_assignment.1)  Process an assignment AST node.

[from_call(ast::Array{Any, 1},  depth::Integer,  rws::CompilerTools.ReadWriteSet.ReadWriteSetType,  callback::Union{Function, Void},  cbdata::ANY)](CompilerTools.ReadWriteSet.md#method__from_call.1)  Process :call Expr nodes to find arrayref and arrayset calls and adding the corresponding index expressions to the read and write sets respectively.

[from_coloncolon(ast::Array{T, N},  depth::Integer,  rws::CompilerTools.ReadWriteSet.ReadWriteSetType,  callback::Union{Function, Void},  cbdata::ANY)](CompilerTools.ReadWriteSet.md#method__from_coloncolon.1)  Process a :(::) AST node.

[from_expr(ast::ANY)](CompilerTools.ReadWriteSet.md#method__from_expr.1)  Walk through one AST node.

[from_expr(ast::ANY,  callback::Union{Function, Void},  cbdata::ANY)](CompilerTools.ReadWriteSet.md#method__from_expr.2)  Walk through one AST node.

[from_expr(ast::LambdaStaticData,  depth::Integer,  rws::CompilerTools.ReadWriteSet.ReadWriteSetType,  callback::Union{Function, Void},  cbdata::ANY)](CompilerTools.ReadWriteSet.md#method__from_expr.3)  The main routine that switches on all the various AST node types.

[from_lambda(ast::Expr,  depth,  rws::CompilerTools.ReadWriteSet.ReadWriteSetType,  callback::Union{Function, Void},  cbdata::ANY)](CompilerTools.ReadWriteSet.md#method__from_lambda.1)  Walk through a lambda expression.

[from_tuple(ast::Array{T, N},  depth::Integer,  rws::CompilerTools.ReadWriteSet.ReadWriteSetType,  callback::Union{Function, Void},  cbdata::ANY)](CompilerTools.ReadWriteSet.md#method__from_tuple.1)  Walk through a tuple.

[toSymGen(x::Union{GenSym, Symbol})](CompilerTools.ReadWriteSet.md#method__tosymgen.1)  In various places we need a SymGen type which is the union of Symbol and GenSym.

[tryCallback(ast::ANY,  callback::Union{Function, Void},  cbdata::ANY,  depth::Integer,  rws::CompilerTools.ReadWriteSet.ReadWriteSetType)](CompilerTools.ReadWriteSet.md#method__trycallback.1)  If an AST node is not recognized then we try the passing the node to the callback to see if 

[uncompressed_ast(l::LambdaStaticData)](CompilerTools.ReadWriteSet.md#method__uncompressed_ast.1)  Convert a compressed LambdaStaticData format into the uncompressed AST format.

## MODULE: CompilerTools.DebugMsg

---

## Exported

[init()](CompilerTools.DebugMsg.md#method__init.1)  A module using DebugMsg must call DebugMsg.init(), which expands to several local definitions

---

## Internal

[PROSPECT_DEV_MODE](CompilerTools.DebugMsg.md#global__prospect_dev_mode.1)  When this module is first loaded, we check if PROSPECT_DEV_MODE is set in environment.

## MODULE: CompilerTools.LivenessAnalysis

---

## Exported

[find_bb_for_statement(top_number::Int64,  bl::CompilerTools.LivenessAnalysis.BlockLiveness)](CompilerTools.LivenessAnalysis.md#method__find_bb_for_statement.1)  Search for a basic block containing a statement with the given top-level number in the liveness information.

[show(io::IO,  bb::CompilerTools.LivenessAnalysis.BasicBlock)](CompilerTools.LivenessAnalysis.md#method__show.1)  Overload of Base.show to pretty-print a LivenessAnalysis.BasicBlock.

[show(io::IO,  bl::CompilerTools.LivenessAnalysis.BlockLiveness)](CompilerTools.LivenessAnalysis.md#method__show.2)  Overload of Base.show to pretty-print BlockLiveness type.

[show(io::IO,  tls::CompilerTools.LivenessAnalysis.TopLevelStatement)](CompilerTools.LivenessAnalysis.md#method__show.3)  Overload of Base.show to pretty-print a LivenessAnalysis.TopLevelStatement.

[CompilerTools.LivenessAnalysis.BlockLiveness](CompilerTools.LivenessAnalysis.md#type__blockliveness.1)  The main return type from LivenessAnalysis.

---

## Internal

[TypedExpr(typ,  rest...)](CompilerTools.LivenessAnalysis.md#method__typedexpr.1)  Convenience function to create an Expr and make sure the type is filled in as well.

[addUnmodifiedParams(func,  signature::Array{DataType, 1},  unmodifieds,  state::CompilerTools.LivenessAnalysis.expr_state)](CompilerTools.LivenessAnalysis.md#method__addunmodifiedparams.1)  Add an entry the dictionary of which arguments can be modified by which functions.

[add_access(bb,  sym,  read)](CompilerTools.LivenessAnalysis.md#method__add_access.1)  Called when AST traversal finds some Symbol "sym" in a basic block "bb".

[compute_live_ranges(state::CompilerTools.LivenessAnalysis.expr_state,  dfn)](CompilerTools.LivenessAnalysis.md#method__compute_live_ranges.1)  Compute the live_in and live_out information for each basic block and statement.

[countSymbolDefs(s,  lives)](CompilerTools.LivenessAnalysis.md#method__countsymboldefs.1)  Count the number of times that the symbol in "s" is defined in all the basic blocks.

[create_unmodified_args_dict()](CompilerTools.LivenessAnalysis.md#method__create_unmodified_args_dict.1)  Convert the function_descriptions table into a dictionary that can be passed to

[def(x,  bl::CompilerTools.LivenessAnalysis.BlockLiveness)](CompilerTools.LivenessAnalysis.md#method__def.1)  Get the def information for "x" where x can be a liveness or CFG basic block or a liveness or CFG statement.

[dump_bb(bl::CompilerTools.LivenessAnalysis.BlockLiveness)](CompilerTools.LivenessAnalysis.md#method__dump_bb.1)  Dump a bunch of debugging information about BlockLiveness.

[find_top_number(top_number::Int64,  bl::CompilerTools.LivenessAnalysis.BlockLiveness)](CompilerTools.LivenessAnalysis.md#method__find_top_number.1)  Search for a statement with the given top-level number in the liveness information.

[fromCFG(live_res,  cfg::CompilerTools.CFGs.CFG,  callback::Function,  cbdata::ANY)](CompilerTools.LivenessAnalysis.md#method__fromcfg.1)  Extract liveness information from the CFG.

[from_assignment(ast::Array{Any, 1},  depth::Int64,  state::CompilerTools.LivenessAnalysis.expr_state,  callback::Function,  cbdata::ANY)](CompilerTools.LivenessAnalysis.md#method__from_assignment.1)  Walk through an assignment expression.

[from_call(ast::Array{Any, 1},  depth::Int64,  state::CompilerTools.LivenessAnalysis.expr_state,  callback::Function,  cbdata::ANY)](CompilerTools.LivenessAnalysis.md#method__from_call.1)  Walk through a call expression.

[from_expr(ast::Expr)](CompilerTools.LivenessAnalysis.md#method__from_expr.1)  This function gives you the option of calling the ENTRY point from_expr with an ast and several optional named arguments.

[from_expr(ast::Expr,  callback)](CompilerTools.LivenessAnalysis.md#method__from_expr.2)  ENTRY point to liveness analysis.

[from_expr(ast::Expr,  callback,  cbdata::ANY)](CompilerTools.LivenessAnalysis.md#method__from_expr.3)  ENTRY point to liveness analysis.

[from_expr(ast::Expr,  callback,  cbdata::ANY,  no_mod)](CompilerTools.LivenessAnalysis.md#method__from_expr.4)  ENTRY point to liveness analysis.

[from_expr(ast::LambdaStaticData,  depth::Int64,  state::CompilerTools.LivenessAnalysis.expr_state,  callback::Function,  cbdata::ANY)](CompilerTools.LivenessAnalysis.md#method__from_expr.5)  Generic routine for how to walk most AST node types.

[from_exprs(ast::Array{Any, 1},  depth::Int64,  state::CompilerTools.LivenessAnalysis.expr_state,  callback::Function,  cbdata::ANY)](CompilerTools.LivenessAnalysis.md#method__from_exprs.1)  Walk through an array of expressions.

[from_if(args,  depth::Int64,  state::CompilerTools.LivenessAnalysis.expr_state,  callback::Function,  cbdata::ANY)](CompilerTools.LivenessAnalysis.md#method__from_if.1)  Process a gotoifnot which is just a recursive processing of its first arg which is the conditional.

[from_lambda(ast::Expr,  depth::Int64,  state::CompilerTools.LivenessAnalysis.expr_state,  callback::Function,  cbdata::ANY)](CompilerTools.LivenessAnalysis.md#method__from_lambda.1)  Walk through a lambda expression.

[from_return(args,  depth::Int64,  state::CompilerTools.LivenessAnalysis.expr_state,  callback::Function,  cbdata::ANY)](CompilerTools.LivenessAnalysis.md#method__from_return.1)  Process a return Expr node which is just a recursive processing of all of its args.

[getUnmodifiedArgs(func::ANY,  args,  arg_type_tuple::Array{DataType, 1},  state::CompilerTools.LivenessAnalysis.expr_state)](CompilerTools.LivenessAnalysis.md#method__getunmodifiedargs.1)  For a given function and signature, return which parameters can be modified by the function.

[get_function_from_string(mod::AbstractString,  func::AbstractString)](CompilerTools.LivenessAnalysis.md#method__get_function_from_string.1)  Takes a module and a function both as Strings. Looks up the specified module as

[get_info_internal(x::Union{CompilerTools.LivenessAnalysis.BasicBlock, CompilerTools.LivenessAnalysis.TopLevelStatement},  bl::CompilerTools.LivenessAnalysis.BlockLiveness,  field)](CompilerTools.LivenessAnalysis.md#method__get_info_internal.1)  The live_in, live_out, def, and use routines are all effectively the same but just extract a different field name.

[isDef(x::Union{GenSym, Symbol},  live_info)](CompilerTools.LivenessAnalysis.md#method__isdef.1)  Query if the symbol in argument "x" is defined in live_info which can be a BasicBlock or TopLevelStatement.

[isPassedByRef(x,  state::CompilerTools.LivenessAnalysis.expr_state)](CompilerTools.LivenessAnalysis.md#method__ispassedbyref.1)  Returns true if a parameter is passed by reference.

[live_in(x,  bl::CompilerTools.LivenessAnalysis.BlockLiveness)](CompilerTools.LivenessAnalysis.md#method__live_in.1)  Get the live_in information for "x" where x can be a liveness or CFG basic block or a liveness or CFG statement.

[live_out(x,  bl::CompilerTools.LivenessAnalysis.BlockLiveness)](CompilerTools.LivenessAnalysis.md#method__live_out.1)  Get the live_out information for "x" where x can be a liveness or CFG basic block or a liveness or CFG statement.

[not_handled(a,  b)](CompilerTools.LivenessAnalysis.md#method__not_handled.1)  The default callback that processes no non-standard Julia AST nodes.

[recompute_live_ranges(state,  dfn)](CompilerTools.LivenessAnalysis.md#method__recompute_live_ranges.1)  Clear the live_in and live_out data corresponding to all basic blocks and statements and then recompute liveness information.

[typeOfOpr(x::ANY,  li::CompilerTools.LambdaHandling.LambdaInfo)](CompilerTools.LivenessAnalysis.md#method__typeofopr.1)  Get the type of some AST node.

[uncompressed_ast(l::LambdaStaticData)](CompilerTools.LivenessAnalysis.md#method__uncompressed_ast.1)  Convert a compressed LambdaStaticData format into the uncompressed AST format.

[use(x,  bl::CompilerTools.LivenessAnalysis.BlockLiveness)](CompilerTools.LivenessAnalysis.md#method__use.1)  Get the use information for "x" where x can be a liveness or CFG basic block or a liveness or CFG statement.

[CompilerTools.LivenessAnalysis.AccessSummary](CompilerTools.LivenessAnalysis.md#type__accesssummary.1)  Sometimes if new AST nodes are introduced then we need to ask for their def and use set as a whole

[CompilerTools.LivenessAnalysis.BasicBlock](CompilerTools.LivenessAnalysis.md#type__basicblock.1)  Liveness information for a BasicBlock.

[CompilerTools.LivenessAnalysis.TopLevelStatement](CompilerTools.LivenessAnalysis.md#type__toplevelstatement.1)  Liveness information for a TopLevelStatement in the CFG.

[CompilerTools.LivenessAnalysis.expr_state](CompilerTools.LivenessAnalysis.md#type__expr_state.1)  Holds the state during the AST traversal.

## MODULE: CompilerTools.Loops

---

## Exported

[CompilerTools.Loops.DomLoops](CompilerTools.Loops.md#type__domloops.1)  A type that holds information about which basic blocks dominate which other blocks.

[CompilerTools.Loops.Loop](CompilerTools.Loops.md#type__loop.1)  A type to hold information about a loop.

---

## Internal

[compute_dom_loops(bl::CompilerTools.CFGs.CFG)](CompilerTools.Loops.md#method__compute_dom_loops.1)  Find the loops in a CFGs.CFG in "bl".

[findLoopInvariants(l::CompilerTools.Loops.Loop,  udinfo::Dict{CompilerTools.LivenessAnalysis.BasicBlock, CompilerTools.UDChains.UDInfo},  bl::CompilerTools.LivenessAnalysis.BlockLiveness)](CompilerTools.Loops.md#method__findloopinvariants.1)  Finds those computations within a loop that are iteration invariant.

[findLoopMembers(head,  back_edge,  bbs)](CompilerTools.Loops.md#method__findloopmembers.1)  Find all the members of the loop as specified by the "head" basic block and the "back_edge" basic block.

[flm_internal(cur_bb,  members,  bbs)](CompilerTools.Loops.md#method__flm_internal.1)  Add to the "members" of the loop being accumulated given "cur_bb" which is known to be a member of the loop.

[isInLoop(dl::CompilerTools.Loops.DomLoops,  bb::Int64)](CompilerTools.Loops.md#method__isinloop.1)  Takes a DomLoops object containing loop information about the function.

## MODULE: CompilerTools.LambdaHandling

---

## Exported

[addEscapingVariable(s::Symbol,  typ,  desc::Int64,  li::CompilerTools.LambdaHandling.LambdaInfo)](CompilerTools.LambdaHandling.md#method__addescapingvariable.1)  Adds a new escaping variable with the given Symbol "s", type "typ", descriptor "desc" in LambdaInfo "li".

[addEscapingVariable(vd::CompilerTools.LambdaHandling.VarDef,  li::CompilerTools.LambdaHandling.LambdaInfo)](CompilerTools.LambdaHandling.md#method__addescapingvariable.2)  Adds a new escaping variable from a VarDef in parameter "vd" into LambdaInfo "li".

[addGenSym(typ,  li::CompilerTools.LambdaHandling.LambdaInfo)](CompilerTools.LambdaHandling.md#method__addgensym.1)  Add a new GenSym to the LambdaInfo in "li" with the given type in "typ".

[addLocalVariable(s::Symbol,  typ,  desc::Int64,  li::CompilerTools.LambdaHandling.LambdaInfo)](CompilerTools.LambdaHandling.md#method__addlocalvariable.1)  Adds a new local variable with the given Symbol "s", type "typ", descriptor "desc" in LambdaInfo "li".

[addLocalVariable(vd::CompilerTools.LambdaHandling.VarDef,  li::CompilerTools.LambdaHandling.LambdaInfo)](CompilerTools.LambdaHandling.md#method__addlocalvariable.2)  Adds a local variable from a VarDef to the given LambdaInfo.

[getBody(lambda::Expr)](CompilerTools.LambdaHandling.md#method__getbody.1)  Returns the body expression part of a lambda expression.

[getDesc(x::Symbol,  li::CompilerTools.LambdaHandling.LambdaInfo)](CompilerTools.LambdaHandling.md#method__getdesc.1)  Returns the descriptor for a local variable or input parameter "x" from LambdaInfo in "li".

[getRefParams(lambdaInfo::CompilerTools.LambdaHandling.LambdaInfo)](CompilerTools.LambdaHandling.md#method__getrefparams.1)  Returns an array of Symbols corresponding to those parameters to the method that are going to be passed by reference.

[getReturnType(li::CompilerTools.LambdaHandling.LambdaInfo)](CompilerTools.LambdaHandling.md#method__getreturntype.1)  Returns the type of the lambda as stored in LambdaInfo "li" and as extracted during lambdaExprToLambdaInfo.

[getType(x::Symbol,  li::CompilerTools.LambdaHandling.LambdaInfo)](CompilerTools.LambdaHandling.md#method__gettype.1)  Returns the type of a Symbol or GenSym in "x" from LambdaInfo in "li".

[getVarDef(s::Symbol,  li::CompilerTools.LambdaHandling.LambdaInfo)](CompilerTools.LambdaHandling.md#method__getvardef.1)  Returns the VarDef for a Symbol in LambdaInfo in "li"

[isEscapingVariable(s::Symbol,  li::CompilerTools.LambdaHandling.LambdaInfo)](CompilerTools.LambdaHandling.md#method__isescapingvariable.1)  Returns true if the Symbol in "s" is an escaping variable in LambdaInfo in "li".

[isInputParameter(s::Symbol,  li::CompilerTools.LambdaHandling.LambdaInfo)](CompilerTools.LambdaHandling.md#method__isinputparameter.1)  Returns true if the Symbol in "s" is an input parameter in LambdaInfo in "li".

[isLocalGenSym(s::GenSym,  li::CompilerTools.LambdaHandling.LambdaInfo)](CompilerTools.LambdaHandling.md#method__islocalgensym.1)  Returns true if the GenSym in "s" is a GenSym in LambdaInfo in "li".

[isLocalVariable(s::Symbol,  li::CompilerTools.LambdaHandling.LambdaInfo)](CompilerTools.LambdaHandling.md#method__islocalvariable.1)  Returns true if the Symbol in "s" is a local variable in LambdaInfo in "li".

[lambdaExprToLambdaInfo(lambda::Expr)](CompilerTools.LambdaHandling.md#method__lambdaexprtolambdainfo.1)  Convert a lambda expression into our internal storage format, LambdaInfo.

[lambdaInfoToLambdaExpr(lambdaInfo::CompilerTools.LambdaHandling.LambdaInfo,  body)](CompilerTools.LambdaHandling.md#method__lambdainfotolambdaexpr.1)  Convert our internal storage format, LambdaInfo, back into a lambda expression.

[lambdaTypeinf(lambda::LambdaStaticData,  typs::Tuple)](CompilerTools.LambdaHandling.md#method__lambdatypeinf.1)  Force type inference on a LambdaStaticData object.

[replaceExprWithDict!(expr::ANY,  dict::Dict{Union{GenSym, Symbol}, Any})](CompilerTools.LambdaHandling.md#method__replaceexprwithdict.1)  Replace the symbols in an expression "expr" with those defined in the

[replaceExprWithDict!(expr::ANY,  dict::Dict{Union{GenSym, Symbol}, Any},  AstWalkFunc)](CompilerTools.LambdaHandling.md#method__replaceexprwithdict.2)  Replace the symbols in an expression "expr" with those defined in the

[replaceExprWithDict(expr,  dict::Dict{Union{GenSym, Symbol}, Any})](CompilerTools.LambdaHandling.md#method__replaceexprwithdict.3)  Replace the symbols in an expression "expr" with those defined in the

[updateAssignedDesc(lambdaInfo::CompilerTools.LambdaHandling.LambdaInfo,  symbol_assigns::Dict{Symbol, Int64})](CompilerTools.LambdaHandling.md#method__updateassigneddesc.1)  Update the descriptor part of the VarDef dealing with whether the variable is assigned or not in the function.

[CompilerTools.LambdaHandling.LambdaInfo](CompilerTools.LambdaHandling.md#type__lambdainfo.1)  An internal format for storing a lambda expression's args[1] and args[2].

[CompilerTools.LambdaHandling.VarDef](CompilerTools.LambdaHandling.md#type__vardef.1)  Represents the triple stored in a lambda's args[2][1].

[SymGen](CompilerTools.LambdaHandling.md#typealias__symgen.1)  Type aliases for different unions of Symbol, SymbolNode, and GenSym.

---

## Internal

[addDescFlag(s::Symbol,  desc_flag::Int64,  li::CompilerTools.LambdaHandling.LambdaInfo)](CompilerTools.LambdaHandling.md#method__adddescflag.1)  Add one or more bitfields in "desc_flag" to the descriptor for a variable.

[addInputParameter(vd::CompilerTools.LambdaHandling.VarDef,  li::CompilerTools.LambdaHandling.LambdaInfo)](CompilerTools.LambdaHandling.md#method__addinputparameter.1)  Add Symbol "s" as input parameter to LambdaInfo "li".

[addInputParameters(collection,  li::CompilerTools.LambdaHandling.LambdaInfo)](CompilerTools.LambdaHandling.md#method__addinputparameters.1)  Add all variable in "collection" as input parameters to LambdaInfo "li".

[addLocalVar(name::AbstractString,  typ,  desc::Int64,  li::CompilerTools.LambdaHandling.LambdaInfo)](CompilerTools.LambdaHandling.md#method__addlocalvar.1)  Add a local variable to the function corresponding to LambdaInfo in "li" with name (as String), type and descriptor.

[addLocalVar(name::Symbol,  typ,  desc::Int64,  li::CompilerTools.LambdaHandling.LambdaInfo)](CompilerTools.LambdaHandling.md#method__addlocalvar.2)  Add a local variable to the function corresponding to LambdaInfo in "li" with name (as Symbol), type and descriptor.

[addLocalVariables(collection,  li::CompilerTools.LambdaHandling.LambdaInfo)](CompilerTools.LambdaHandling.md#method__addlocalvariables.1)  Add multiple local variables from some collection type.

[count_symbols(x::Symbol,  state::CompilerTools.LambdaHandling.CountSymbolState,  top_level_number,  is_top_level,  read)](CompilerTools.LambdaHandling.md#method__count_symbols.1)  Adds symbols and gensyms to their corresponding sets in CountSymbolState when they are seen in the AST.

[createMeta(lambdaInfo::CompilerTools.LambdaHandling.LambdaInfo)](CompilerTools.LambdaHandling.md#method__createmeta.1)  Create the args[2] part of a lambda expression given an object of our internal storage format LambdaInfo.

[createVarDict(x::Array{Any, 1})](CompilerTools.LambdaHandling.md#method__createvardict.1)  Convert the lambda expression's args[2][1] from Array{Array{Any,1},1} to a Dict{Symbol,VarDef}.

[dictToArray(x::Dict{Symbol, CompilerTools.LambdaHandling.VarDef})](CompilerTools.LambdaHandling.md#method__dicttoarray.1)  Convert the Dict{Symbol,VarDef} internal storage format from a dictionary back into an array of Any triples.

[eliminateUnusedLocals!(li::CompilerTools.LambdaHandling.LambdaInfo,  body::Expr)](CompilerTools.LambdaHandling.md#method__eliminateunusedlocals.1)  Eliminates unused symbols from the LambdaInfo var_defs.

[eliminateUnusedLocals!(li::CompilerTools.LambdaHandling.LambdaInfo,  body::Expr,  AstWalkFunc)](CompilerTools.LambdaHandling.md#method__eliminateunusedlocals.2)  Eliminates unused symbols from the LambdaInfo var_defs.

[getLocalVariables(li::CompilerTools.LambdaHandling.LambdaInfo)](CompilerTools.LambdaHandling.md#method__getlocalvariables.1)  Returns an array of Symbols for local variables.

[mergeLambdaInfo(outer::CompilerTools.LambdaHandling.LambdaInfo,  inner::CompilerTools.LambdaHandling.LambdaInfo)](CompilerTools.LambdaHandling.md#method__mergelambdainfo.1)  Merge "inner" lambdaInfo into "outer", and "outer" is changed as result.  Note

[removeLocalVar(name::Symbol,  li::CompilerTools.LambdaHandling.LambdaInfo)](CompilerTools.LambdaHandling.md#method__removelocalvar.1)  Remove a local variable from lambda "li" given the variable's "name".

[show(io::IO,  li::CompilerTools.LambdaHandling.LambdaInfo)](CompilerTools.LambdaHandling.md#method__show.1)  Pretty print a LambdaInfo.

[CompilerTools.LambdaHandling.CountSymbolState](CompilerTools.LambdaHandling.md#type__countsymbolstate.1)  Holds symbols and gensyms that are seen in a given AST when using the specified callback to handle non-standard Julia AST types.

## MODULE: CompilerTools.OptFramework

---

## Exported

[addOptPass(func,  level)](CompilerTools.OptFramework.md#method__addoptpass.1)  Same as the other addOptPass but with a pass call back function and pass level as input.

[addOptPass(pass::CompilerTools.OptFramework.OptPass)](CompilerTools.OptFramework.md#method__addoptpass.2)  Add an optimization pass. If this is going to be called multiple times then you need some external way of corrdinating the code/modules that are calling this function so that optimization passes are added in some sane order.

[@acc(ast1, ast2...)](CompilerTools.OptFramework.md#macro___acc.1)  The @acc macro comes in two forms:

[@noacc(ast)](CompilerTools.OptFramework.md#macro___noacc.1)  The macro @noacc can be used at call site to specifically run the non-accelerated copy of an accelerated function. It has no effect and gives a warning when the given function is not found to have been accelerated. We do not support nested @acc or @noacc. 

---

## Internal

[TypedExpr(typ,  rest...)](CompilerTools.OptFramework.md#method__typedexpr.1)  Creates a typed Expr AST node.

[cleanupASTLabels(ast)](CompilerTools.OptFramework.md#method__cleanupastlabels.1)  Clean up the labels in AST by renaming them, and removing duplicates.

[convertCodeToLevel(ast::ANY,  sig::ANY,  old_level,  new_level,  func)](CompilerTools.OptFramework.md#method__convertcodetolevel.1)  convert AST from "old_level" to "new_level". The input "ast" can be either Expr or Function type. In the latter case, the result AST will be obtained from this function using an matching signature "sig". The last "func" is a skeleton function that is used internally to facility such conversion.

[convert_expr(per_site_opt_set,  ast)](CompilerTools.OptFramework.md#method__convert_expr.1)  When @acc is used at a function's callsite, we use AstWalk to search for callsites via the opt_calls_insert_trampoline callback and to then insert trampolines.  That updated expression containing trampoline calls is then returned as the generated code from the @acc macro.

[convert_function(per_site_opt_set,  opt_set,  macros,  ast)](CompilerTools.OptFramework.md#method__convert_function.1)  When @acc is used at a function definition, it creates a trampoline function, when called with a specific set of signature types, will try to optimize the original function, and call it with the real arguments.  The input "ast" should be an AST of the original function at macro level, which will be   replaced by the trampoline. 

[create_label_map(x,  state::CompilerTools.OptFramework.lmstate,  top_level_number,  is_top_level,  read)](CompilerTools.OptFramework.md#method__create_label_map.1)  An AstWalk callback that collects information about labels in an AST.

[dumpLevel(level)](CompilerTools.OptFramework.md#method__dumplevel.1)  pretty print pass level number as string.

[evalPerSiteOptSet(per_site_opt_set)](CompilerTools.OptFramework.md#method__evalpersiteoptset.1)  Statically evaluate per-site optimization passes setting, and return the result.

[findOriginalFunc(mod::Module,  name::Symbol)](CompilerTools.OptFramework.md#method__findoriginalfunc.1)  Find the original (before @acc macro) function for a wrapper function in the given module. 

[findTargetFunc(mod::Module,  name::Symbol)](CompilerTools.OptFramework.md#method__findtargetfunc.1)  Find the optimizing target function (after @acc macro) for a wrapper function in the given module. 

[getCodeAtLevel(func,  sig,  level)](CompilerTools.OptFramework.md#method__getcodeatlevel.1)  Retrieve the AST of the given function "func" and signature "sig" for at the given pass "level".

[identical{T}(t::Type{T},  x::T)](CompilerTools.OptFramework.md#method__identical.1)  A hack to get around Julia's type inference. This is essentially an identity conversion,

[makeWrapperFunc(new_fname::Symbol,  real_fname::Symbol,  call_sig_args::Array{Any, 1},  per_site_opt_set)](CompilerTools.OptFramework.md#method__makewrapperfunc.1)  Define a wrapper function with the name given by "new_func" that when called will try to optimize the "real_func" function, and run it with given parameters in "call_sig_args". The input "per_site_opt_set" can be either nothing, or a quoted Expr that refers to an array of OptPass.

[opt_calls_insert_trampoline(x,  per_site_opt_set,  top_level_number,  is_top_level,  read)](CompilerTools.OptFramework.md#method__opt_calls_insert_trampoline.1)  An AstWalk callback function.

[processFuncCall(func::ANY,  call_sig_arg_tuple::ANY,  per_site_opt_set::ANY)](CompilerTools.OptFramework.md#method__processfunccall.1)  Takes a function, a signature, and a set of optimizations and applies that set of optimizations to the function,

[removeDupLabels(stmts)](CompilerTools.OptFramework.md#method__removeduplabels.1)  Sometimes update_labels creates two label nodes that are the same.

[setOptPasses(passes::Array{CompilerTools.OptFramework.OptPass, 1})](CompilerTools.OptFramework.md#method__setoptpasses.1)  Set the default set of optimization passes to apply with the @acc macro. 

[tfuncPresent(func,  tt)](CompilerTools.OptFramework.md#method__tfuncpresent.1)  Makes sure that a newly created function is correctly present in the internal Julia method table.

[update_labels(x,  state::CompilerTools.OptFramework.lmstate,  top_level_number,  is_top_level,  read)](CompilerTools.OptFramework.md#method__update_labels.1)  An AstWalk callback that applies the label map created during create_label_map AstWalk.

[CompilerTools.OptFramework.OptPass](CompilerTools.OptFramework.md#type__optpass.1)  A data structure that holds information about one high-level optimization pass to run.

[CompilerTools.OptFramework.lmstate](CompilerTools.OptFramework.md#type__lmstate.1)  The callback state variable used by create_label_map and update_labels.

[gOptFrameworkDict](CompilerTools.OptFramework.md#global__goptframeworkdict.1)  A global memo-table that maps both: the triple (function, signature, optPasses) to the trampoline function, and the trampoline function to the real function.

## MODULE: CompilerTools.AstWalker

---

## Exported

[AstWalk(ast::ANY,  callback,  cbdata::ANY)](CompilerTools.AstWalker.md#method__astwalk.1)  Entry point into the code to perform an AST walk.

---

## Internal

[from_assignment(ast::Array{Any, 1},  depth,  callback,  cbdata::ANY,  top_level_number,  read)](CompilerTools.AstWalker.md#method__from_assignment.1)  AstWalk through an assignment expression.

[from_body(ast::Array{Any, 1},  depth,  callback,  cbdata::ANY,  top_level_number,  read)](CompilerTools.AstWalker.md#method__from_body.1)  AstWalk through a function body.

[from_call(ast::Array{Any, 1},  depth,  callback,  cbdata::ANY,  top_level_number,  read)](CompilerTools.AstWalker.md#method__from_call.1)  AstWalk through a call expression.

[from_expr(ast::ANY,  depth,  callback,  cbdata::ANY,  top_level_number,  is_top_level,  read)](CompilerTools.AstWalker.md#method__from_expr.1)  The main routine that switches on all the various AST node types.

[from_exprs(ast::Array{Any, 1},  depth,  callback,  cbdata::ANY,  top_level_number,  read)](CompilerTools.AstWalker.md#method__from_exprs.1)  AstWalk through an array of expressions.

[from_lambda(ast::Array{Any, 1},  depth,  callback,  cbdata::ANY,  top_level_number,  read)](CompilerTools.AstWalker.md#method__from_lambda.1)  AstWalk through a lambda expression.

[uncompressed_ast(l::LambdaStaticData)](CompilerTools.AstWalker.md#method__uncompressed_ast.1)  Convert a compressed LambdaStaticData format into the uncompressed AST format.

## MODULE: CompilerTools.UDChains

---

## Internal

[getOrCreate(live::Dict{Symbol, Set{T}},  s::Symbol)](CompilerTools.UDChains.md#method__getorcreate.1)  Get the set of definition blocks reaching this block for a given symbol "s".

[getOrCreate(udchains::Dict{CompilerTools.LivenessAnalysis.BasicBlock, CompilerTools.UDChains.UDInfo},  bb::CompilerTools.LivenessAnalysis.BasicBlock)](CompilerTools.UDChains.md#method__getorcreate.2)  Get the UDInfo for a specified basic block "bb" or create one if it doesn't already exist.

[getUDChains(bl::CompilerTools.LivenessAnalysis.BlockLiveness)](CompilerTools.UDChains.md#method__getudchains.1)  Get the Use-Definition chains at a basic block level given LivenessAnalysis.BlockLiveness as input in "bl".

[printLabels(level,  dict)](CompilerTools.UDChains.md#method__printlabels.1)  Print a live in or live out dictionary in a nice way if the debug level is set high enough.

[printSet(level,  s)](CompilerTools.UDChains.md#method__printset.1)  Print the set part of a live in or live out dictiononary in a nice way if the debug level is set high enough.

[printUDInfo(level,  ud)](CompilerTools.UDChains.md#method__printudinfo.1)  Print UDChains in a nice way if the debug level is set high enough.

[CompilerTools.UDChains.UDInfo](CompilerTools.UDChains.md#type__udinfo.1)  Contains the UDchains for one basic block.

