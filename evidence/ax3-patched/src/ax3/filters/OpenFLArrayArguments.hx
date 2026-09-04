package ax3.filters;

/**
 * Supplies the element types that Haxe/OpenFL adds to APIs which AS3 declares with raw Array.
 *
 * The source correctly uses Array for filter matrices and palette maps. AS3 arrays are covariant
 * and untyped here; OpenFL's Haxe externs use Array<Float> and Array<Int>. Setting the expected
 * type makes GenHaxe emit its existing safe `(cast array)` boundary without changing the source
 * or copying these calls into generated-file patches.
 */
class OpenFLArrayArguments extends AbstractFilter {
    override function processExpr(e:TExpr):TExpr {
        e = mapExpr(processExpr, e);
        return switch e.kind {
            case TENew(keyword, obj = TNType({type: TTInst({name: "ColorMatrixFilter"})}), args)
                    if (args.args.length > 0):
                args.args[0].expr = args.args[0].expr.with(expectedType = TTArray(TTNumber));
                e.with(kind = TENew(keyword, obj, args));

            case TENew(keyword, obj = TNType({type: TTInst({name: "ConvolutionFilter"})}), args)
                    if (args.args.length > 2):
                args.args[2].expr = args.args[2].expr.with(expectedType = TTArray(TTNumber));
                e.with(kind = TENew(keyword, obj, args));

            case TECall(method = {kind: TEField(_, "paletteMap", _)}, args)
                    if (args.args.length >= 6):
                for (index in 3...args.args.length) {
                    args.args[index].expr = args.args[index].expr.with(expectedType = TTArray(TTInt));
                }
                e.with(kind = TECall(method, args));

            case _: e;
        }
    }
}
