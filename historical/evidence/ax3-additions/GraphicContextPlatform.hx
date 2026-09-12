package ax3.filters;

/** OpenFL exposes DisplayObject.parent as a read-only field, not Flash's overridable getter.
    Keep GraphicContext's original attach/detach setter, under a non-colliding property name. */
class GraphicContextPlatform extends AbstractFilter {
    static inline final PACKAGE = "com.sulake.core.window.graphics";
    var filterType:TType;

    override public function run(tree:TypedTree) {
        var display = tree.getClassOrInterface("flash.display", "DisplayObject");
        filterType = switch display.findFieldInHierarchy("filters", false).field.kind {
            case TFGetter(a): a.fun.sig.ret.type;
            case _: throw "OpenFL filters getter contract changed";
        };
        super.run(tree);
    }

    static function isContext(c:TClassOrInterfaceDecl):Bool {
        return c.parentModule.parentPack.name == PACKAGE
            && (c.name == "GraphicContext" || c.name == "IGraphicContext");
    }

    override function processClass(c:TClassOrInterfaceDecl) {
        var getter:TClassField = null;
        if (isContext(c)) for (member in c.members) switch member {
            case TMField(field):
                switch field.kind {
                    case TFGetter(a) | TFSetter(a):
                        if (a.name == "parent") {
                            a.name = "graphicParent";
                            a.syntax.name = mkIdent(a.name);
                            if (c.name == "GraphicContext" && field.kind.match(TFSetter(_))) {
                                var resultType = a.fun.sig.args[0].type;
                                var nativeParent = mk(TEField({kind: TOImplicitThis(c), type: TTInst(c)},
                                    "parent", mkIdent("parent")), resultType, resultType);
                                var inherited = a.with(fun = {
                                    sig: a.fun.sig.with(args = [], ret = {syntax: null, type: resultType}),
                                    expr: mk(TEBlock({syntax: {openBrace: mkOpenBrace(), closeBrace: mkCloseBrace()},
                                        exprs: [{expr: mk(TEReturn(mkIdent("return", [], [whitespace]), nativeParent),
                                            TTVoid, TTVoid), semicolon: semicolonWithSpace}]}), TTVoid, TTVoid)
                                }, haxeProperty = null);
                                getter = {metadata: [], namespace: null,
                                    modifiers: [FMPublic(mkIdent("public", [newline], [whitespace]))],
                                    kind: TFGetter(inherited)};
                            }
                        } else if (a.name == "filters") {
                            a.propertyType = filterType;
                            if (field.kind.match(TFGetter(_))) a.fun.sig.ret.type = filterType;
                            else {
                                a.fun.sig.args[0].type = filterType;
                                if (a.fun.sig.args[0].v != null) a.fun.sig.args[0].v.type = filterType;
                            }
                        }
                    case _:
                }
            case _:
        };
        super.processClass(c);
        // This getter intentionally reads the native parent; don't rename its body recursively.
        if (getter != null) c.members.push(TMField(getter));
    }

    override function processExpr(e:TExpr):TExpr {
        e = mapExpr(processExpr, e);
        return switch e.kind {
            case TEBinop(target = {kind: TEField({type: TTInst(c)}, "filters", _)},
                    op = OpAssign(_), value) if (isContext(c)):
                e.with(kind = TEBinop(target.with(type = filterType), op,
                    value.with(expectedType = filterType)));
            case TEField({type: TTInst(c)}, "filters", _) if (isContext(c)):
                e.with(type = filterType);
            case TEField(obj = {type: TTInst(c)}, "parent", token) if (isContext(c)):
                e.with(kind = TEField(obj, "graphicParent", mkIdent("graphicParent", token.leadTrivia, token.trailTrivia)));
            case TEField(obj = {kind: TOExplicit(dot, receiver = {kind: TELiteral(TLSuper(token))})},
                    "mouseEnabled", name):
                e.with(kind = TEField(obj.with(kind = TOExplicit(dot,
                    receiver.with(kind = TELiteral(TLThis(mkIdent("this", token.leadTrivia, token.trailTrivia)))))),
                    "mouseEnabled", name));
            case _: e;
        }
    }
}
