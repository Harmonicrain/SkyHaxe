package ax3.filters;

import ax3.ParseTree.VarDeclKind;
import ax3.TypedTreeTools.mapExpr;
import ax3.TypedTreeTools.mk;
import ax3.TypedTreeTools.mkMergedBlock;
import ax3.TypedTreeTools.mkNullExpr;
import ax3.TypedTreeTools.mkBuiltin;
import ax3.TokenTools.whitespace;
import ax3.TokenTools.commaWithSpace;

/**
 * AS3 `var` declarations belong to the enclosing function, not the nearest
 * brace or loop. Hoist the declaration while preserving every initializer at
 * its original execution point. This must run before loop rewrites so a loop
 * variable reused after the loop remains the same TVar.
 */
class FunctionScopedVars extends AbstractFilter {
    static function defaultInit(decl:TVarDecl):TVarInit {
        var token = decl.syntax.name;
        var expr = switch decl.v.type {
            case TTBoolean:
                mk(TELiteral(TLBool(new Token(token.pos, TkIdent, "false", [], []))), TTBoolean, TTBoolean);
            case TTInt:
                mk(TELiteral(TLInt(new Token(token.pos, TkDecimalInteger, "0", [], []))), TTInt, TTInt);
            case TTUint:
                mk(TELiteral(TLInt(new Token(token.pos, TkDecimalInteger, "0", [], []))), TTUint, TTUint);
            case TTNumber:
                mkBuiltin("NaN", TTNumber);
            case _:
                mkNullExpr(decl.v.type);
        };
        return {
            equalsToken: new Token(token.pos, TkEquals, "=", [whitespace], [whitespace]),
            expr: expr
        };
    }

    override function processFunction(fun:TFunction) {
        fun.sig = processSignature(fun.sig);
        if (fun.expr == null) return;

        switch fun.expr.kind {
            case TEBlock(block):
                var hoisted:Array<TVarDecl> = [];
                var seen:Map<TVar, Bool> = new Map();

                function rewrite(e:TExpr, nested:Bool):TExpr {
                    return switch e.kind {
                        case TELocalFunction(local):
                            processFunction(local.fun);
                            e;
                        case TEVars(VVar(token), decls) if (nested):
                            var replacements:Array<TBlockExpr> = [];
                            for (decl in decls) {
                                if (!seen.exists(decl.v)) {
                                    seen[decl.v] = true;
                                    hoisted.push(decl.with(init = defaultInit(decl), comma = null));
                                }
                                if (decl.init != null) {
                                    var local = mk(TELocal(decl.syntax.name, decl.v), decl.v.type, decl.v.type);
                                    var assignment = mk(TEBinop(local, OpAssign(decl.init.equalsToken), decl.init.expr), decl.v.type, TTVoid);
                                    replacements.push({expr: assignment, semicolon: decl.comma});
                                }
                            }
                            if (replacements.length == 0) {
                                var first = decls[0];
                                mk(TELocal(first.syntax.name, first.v), first.v.type, TTVoid);
                            } else if (replacements.length == 1) {
                                replacements[0].expr;
                            } else {
                                mkMergedBlock(replacements);
                            }
                        case TEVars(kind = VVar(_), decls):
                            // AS3 initializes every function local at entry, including a
                            // declaration already written in the function's outer block.
                            // Haxe/JS does not permit a typed local to be read before definite
                            // assignment, so retain Flash's false/zero/NaN/null defaults here.
                            e.with(kind = TEVars(kind,
                                decls.map(decl -> decl.init == null ? decl.with(init = defaultInit(decl)) : decl)));
                        case _:
                            mapExpr(child -> rewrite(child, true), e);
                    }
                }

                block.exprs = [for (item in block.exprs) item.with(expr = rewrite(item.expr, false))];
                if (hoisted.length > 0) {
                    for (index in 0...(hoisted.length - 1)) hoisted[index].comma = commaWithSpace;
                    var token = switch hoisted[0].syntax.name {
                        case name: new Token(name.pos, TkIdent, "var", name.leadTrivia, [whitespace]);
                    };
                    block.exprs.unshift({
                        expr: mk(TEVars(VVar(token), hoisted), TTVoid, TTVoid),
                        semicolon: new Token(token.pos, TkSemicolon, ";", [], [])
                    });
                }
            case _:
                fun.expr = rewriteNonBlockFunction(fun.expr);
        }
    }

    function rewriteNonBlockFunction(e:TExpr):TExpr {
        return mapExpr(rewriteNonBlockFunction, e);
    }
}
