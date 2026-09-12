package ax3.filters;

/** Routes Flash runtime APIs that do not exist on HTML5 through ASCompat. */
class PlatformApi extends AbstractFilter {
    override function processExpr(e:TExpr):TExpr {
        switch e.kind {
            case TEBinop({kind: TEField({kind: TOExplicit(_, loader = {type: TTInst(cls)})}, "parameters", _)}, OpAssign(_), value)
                    if ((cls.name == "LoaderInfo" && cls.parentModule.parentPack.name == "flash.display")
                        || (cls.name == "LoaderContext" && cls.parentModule.parentPack.name == "flash.system")):
                var method = mkBuiltin("ASCompat.setLoaderParameters", TTFunction, removeLeadingTrivia(e));
                return mkCall(method, [processExpr(loader), processExpr(value)], value.type)
                    .with(expectedType = e.expectedType);
            case _:
        }
        e = mapExpr(processExpr, e);
        return switch e.kind {
            case TECall({kind: TEField({kind: TOExplicit(_, target), type: TTInst(c)}, "writeBytes", _)}, args)
                    if (c.name == "ByteArray" && args.args.length > 0
                        && args.args[0].expr.type.match(TTInst({name: "ByteArray"}))):
                var forwarded = [{expr: target, comma: commaWithSpace}];
                for (arg in args.args) forwarded.push(arg);
                e.with(kind = TECall(mkBuiltin("ASCompat.byteArrayWriteBytes", TTFunction),
                    args.with(args = forwarded)), type = TTVoid);

            case TECall({kind: TEField({type: TTStatic(c)}, "parse", _)}, args)
                    if (c.name == "Date"):
                e.with(kind = TECall(mkBuiltin("ASCompat.dateParse", TTFunction), args), type = TTNumber);

            case TEField({kind: TOExplicit(_, loader = {type: TTInst(cls)})}, "parameters", fieldToken)
                    if ((cls.name == "LoaderInfo" && cls.parentModule.parentPack.name == "flash.display")
                        || (cls.name == "LoaderContext" && cls.parentModule.parentPack.name == "flash.system")):
                var method = mkBuiltin("ASCompat.loaderParameters",
                    TTFun([loader.type], TTObject(TTAny)), fieldToken.leadTrivia, fieldToken.trailTrivia);
                mkCall(method, [loader], TTObject(TTAny)).with(expectedType = e.expectedType);

            case TEField({kind: TOExplicit(_, owner = {type: TTClass})}, fieldName, fieldToken):
                var method = mkBuiltin("ASCompat.classProperty", TTFunction,
                    fieldToken.leadTrivia, fieldToken.trailTrivia);
                var name = mk(TELiteral(TLString(new Token(fieldToken.pos, TkStringDouble,
                    '"' + fieldName + '"', [], []))), TTString, TTString);
                mkCall(method, [owner, name], TTAny).with(expectedType = e.expectedType);

            case TECall({kind: TEField({type: TTStatic({name: "System", parentModule: {parentPack: {name: "flash.system"}}})},
                    "pauseForGCIfCollectionImminent", fieldToken)}, args):
                var method = mkBuiltin("ASCompat.pauseForGCIfCollectionImminent",
                    TTFun([TTNumber], TTVoid), fieldToken.leadTrivia, fieldToken.trailTrivia);
                e.with(kind = TECall(method, args));

            case TECall({kind: TEField({kind: TOExplicit(_, date = {type: TTInst({name: "Date", parentModule: {parentPack: {name: ""}}})})},
                    methodName = ("toLocaleString" | "toLocaleDateString"), fieldToken)}, args = {args: []}):
                var compatName = methodName == "toLocaleDateString" ? "dateToLocaleDateString" : "dateToLocaleString";
                var method = mkBuiltin("ASCompat." + compatName,
                    TTFun([date.type], TTString), fieldToken.leadTrivia, fieldToken.trailTrivia);
                e.with(kind = TECall(method, args.with(args = [{expr: date, comma: null}])));

            case TEField({type: TTStatic(cls)}, fieldName, fieldToken)
                    if (cls.parentModule.parentPack.name == "flash.display"
                        && (cls.name == "StageScaleMode" || cls.name == "StageDisplayState")):
                var value = switch [cls.name, fieldName] {
                    case ["StageScaleMode", "EXACT_FIT"]: "exactFit";
                    case ["StageScaleMode", "NO_BORDER"]: "noBorder";
                    case ["StageScaleMode", "NO_SCALE"]: "noScale";
                    case ["StageScaleMode", "SHOW_ALL"]: "showAll";
                    case ["StageDisplayState", "FULL_SCREEN"]: "fullScreen";
                    case ["StageDisplayState", "FULL_SCREEN_INTERACTIVE"]: "fullScreenInteractive";
                    case ["StageDisplayState", "NORMAL"]: "normal";
                    case _: null;
                };
                if (value == null) e else mk(TELiteral(TLString(new Token(fieldToken.pos,
                    TkStringDouble, '"' + value + '"', fieldToken.leadTrivia, fieldToken.trailTrivia))),
                    TTString, e.expectedType);

            case TECall({kind: TEField({kind: TOExplicit(_, sound = {type: TTInst({name: "Sound", parentModule: {parentPack: {name: "flash.media"}}})})},
                    "extract", fieldToken)}, args):
                var method = mkBuiltin("ASCompat.extractSound", TTFunction,
                    fieldToken.leadTrivia, fieldToken.trailTrivia);
                var forwarded = [{expr: sound, comma: args.args.length == 0 ? null : commaWithSpace}];
                for (arg in args.args) forwarded.push(arg);
                e.with(kind = TECall(method, args.with(args = forwarded)), type = TTNumber);

            // AS3 String.fromCharCode converts each argument with ToUint16, so an out-of-range
            // code wraps rather than failing. Haxe compiles its own String.fromCharCode to
            // String.fromCodePoint on JS, which throws RangeError on exactly those values, and
            // HabboCommunicationManager.getKeyValue builds its obfuscated property names from a
            // counter that runs down through zero. Only the single-argument form is rewritten:
            // the one variadic site in the client goes through `fromCharCode.apply`, which is a
            // different expression shape and is left for its own measurement.
            case TECall({kind: TEField({kind: TOExplicit(_, {kind: TEBuiltin(builtinToken, "String")})},
                    "fromCharCode", fieldToken)}, args) if (args.args.length == 1):
                var method = mkBuiltin("ASCompat.stringFromCharCode", TTFunction,
                    builtinToken.leadTrivia, fieldToken.trailTrivia);
                e.with(kind = TECall(method, args), type = TTString);

            case _:
                e;
        }
    }
}
