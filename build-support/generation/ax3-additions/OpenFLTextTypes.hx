package ax3.filters;

/** Type-only differences between Flash text APIs and their OpenFL declarations. */
class OpenFLTextTypes extends AbstractFilter {
    override function processExpr(e:TExpr):TExpr {
        switch e.kind {
            case TEBinop({kind: TEField({kind: TOExplicit(_, format), type: TTInst(c)}, "display", _)},
                    OpAssign(_), value)
                    if (c.name == "TextFormat"):
                return mkCall(mkBuiltin("ASCompat.setTextFormatDisplay", TTFunction),
                    [processExpr(format), processExpr(value)], value.type).with(expectedType = e.expectedType);
            case _:
        }
        e = mapExpr(processExpr, e);
        return switch e.kind {
            case TEField({kind: TOExplicit(_, format), type: TTInst(c)}, "display", _)
                    if (c.name == "TextFormat"):
                mkCall(mkBuiltin("ASCompat.textFormatDisplay", TTFunction), [format], TTAny)
                    .with(expectedType = e.expectedType);
            case TENew(_, TNType({type: TTInst(c)}), args)
                    if (c.name == "TextFormat"
                        && args != null && args.args.length >= 3):
                // Flash's colour is uint/Object; OpenFL exposes Null<Int>. Preserve the
                // same 32-bit bits through the existing AS3 integer coercion.
                args.args[2].expr = args.args[2].expr.with(expectedType = TTInt);
                e;
            case TECall({kind: TEField({kind: TOExplicit(_, receiver), type: TTInst(c)}, "hasGlyphs", _)}, args)
                    if (c.name == "Font" && c.parentModule.parentPack.name == "flash.text"):
                mkCall(mkBuiltin("com.sulake.core.window.text.TruffleText.fontHasGlyphs", TTFun([TTAny, TTString], TTBoolean)),
                    [receiver, args.args[0].expr], TTBoolean).with(expectedType = e.expectedType);
            case TEBinop(target = {kind: TEField({type: TTInst(c)}, "leading", _)},
                    op = OpAssign(_), value = {type: TTNumber})
                    if (c.name == "TextFormat" && c.parentModule.parentPack.name == "flash.text"):
                // Flash documents leading as integer pixels despite exposing Object. Only
                // numeric expressions are coerced; null continues to mean unspecified.
                e.with(kind = TEBinop(target, op, value.with(expectedType = TTInt)));
            case TESwitch(s) if (s.subj.type == TTString):
                for (branch in s.cases) branch.values = [for (value in branch.values) switch value.kind {
                    case TEField({type: TTStatic(c)}, name, _)
                            if (c.name == "TextFieldAutoSize" && c.parentModule.parentPack.name == "flash.text"
                                && ["CENTER", "LEFT", "NONE", "RIGHT"].indexOf(name) >= 0):
                        // AS3 exports string constants; OpenFL uses an Int-backed abstract.
                        mk(TELiteral(TLString(new Token(0, TkStringDouble, haxe.Json.stringify(name.toLowerCase()),
                            removeLeadingTrivia(value), removeTrailingTrivia(value)))), TTString, TTString);
                    case _: value;
                }];
                e;
            case _: e;
        }
    }
}
