package ax3.filters;

/** Haxe declares one property in the base; AS3 permits the other accessor in a subclass. */
class InheritedAccessors extends AbstractFilter {
    final prepared = new Map<TClassOrInterfaceDecl, Bool>();

    override function processClass(cls:TClassOrInterfaceDecl) {
        prepare(cls);
    }

    function prepare(cls:TClassOrInterfaceDecl):Void {
        if (prepared.exists(cls) || cls.parentModule.isExtern) return;
        prepared[cls] = true;
        var parent = switch cls.kind {
            case TClass({extend: extension}) if (extension != null): extension.superClass;
            case _: return;
        };
        prepare(parent);
        if (parent.parentModule.isExtern) return; // Target-native properties need a platform mapping.
        for (member in cls.members.copy()) switch member {
            case TMField(field):
                var accessor, setter;
                switch field.kind {
                    case TFGetter(value): accessor = value; setter = false;
                    case TFSetter(value): accessor = value; setter = true;
                    case _: continue;
                }
                if (isFieldStatic(field)) continue;
                var owner = propertyOwner(parent, accessor.name);
                if (owner == null || owner.parentModule.isExtern) continue;
                if (!hasAccessor(owner, accessor.name, setter)) {
                    // This accessor was absent on base instances in AS3. Make it fail explicitly,
                    // never silently swallow a write; real subclasses override it below.
                    var label = mk(TELiteral(TLString(new Token(0, TkStringDouble,
                        haxe.Json.stringify("Accessor unavailable on base instance: " + accessor.name), [], []))),
                        TTString, TTAny);
                    var signature = accessor.fun.sig.with(args = accessor.fun.sig.args.copy());
                    var synthetic = accessor.with(
                        syntax = {functionKeyword: mkIdent("function", [newline], [whitespace]),
                                  accessorKeyword: mkIdent(setter ? "set" : "get", [], [whitespace]),
                                  name: mkIdent(accessor.name)},
                        fun = {sig: signature, expr: mk(TEBlock({
                            syntax: {openBrace: mkOpenBrace(), closeBrace: mkCloseBrace()},
                            exprs: [{expr: mk(TEThrow(mkIdent("throw", [], [whitespace]), label),
                                             TTVoid, TTVoid), semicolon: semicolonWithSpace}]
                        }), TTVoid, TTVoid)},
                        haxeProperty = null);
                    owner.members.push(TMField({metadata: [], namespace: null,
                        modifiers: [FMPublic(mkIdent("public", [newline], [whitespace]))],
                        kind: setter ? TFSetter(synthetic) : TFGetter(synthetic)}));
                }
                if (!Lambda.exists(field.modifiers, m -> m.match(FMOverride(_))))
                    field.modifiers.push(FMOverride(mkIdent("override", [], [whitespace])));
            case _:
        }
    }

    static function hasAccessor(cls:TClassOrInterfaceDecl, name:String, setter:Bool):Bool {
        for (member in cls.members) switch member {
            case TMField({kind: TFSetter(value)}) if (setter && value.name == name): return true;
            case TMField({kind: TFGetter(value)}) if (!setter && value.name == name): return true;
            case _:
        }
        return false;
    }

    static function propertyOwner(cls:TClassOrInterfaceDecl, name:String):Null<TClassOrInterfaceDecl> {
        // Use the oldest declaration so multiple generations still share one Haxe property.
        var parentOwner = switch cls.kind {
            case TClass({extend: extension}) if (extension != null): propertyOwner(extension.superClass, name);
            case _: null;
        };
        if (parentOwner != null) return parentOwner;
        return hasAccessor(cls, name, true) || hasAccessor(cls, name, false) ? cls : null;
    }
}
