package ax3.filters;

class NumberToInt extends AbstractFilter {
	public static final tStdInt = TTFun([TTNumber], TTInt);

	override function processExpr(e:TExpr):TExpr {
		e = mapExpr(processExpr, e);
		return switch [e.type, e.expectedType] {
			case [TTAny, TTInt | TTUint]:
				var name = e.expectedType == TTUint ? "ASCompat.toUInt" : "ASCompat.toInt";
				var coerce = mkBuiltin(name, TTFun([TTAny], e.expectedType), removeLeadingTrivia(e));
				mkCall(coerce, [e.with(expectedType = TTAny)]);
			case [TTUint, TTInt]:
				var toInt = mkBuiltin("ASCompat.toInt", TTFun([TTAny], TTInt), removeLeadingTrivia(e));
				mkCall(toInt, [e.with(expectedType = TTAny)]);
			case [TTNumber, TTInt | TTUint]:
				var stdInt = mkBuiltin("Std.int", tStdInt, removeLeadingTrivia(e));
				mkCall(stdInt, [e.with(expectedType = TTNumber)]);
			case [TTXML | TTXMLList, TTInt | TTUint]:
				var name = e.expectedType == TTUint ? "ASCompat.toUInt" : "ASCompat.toInt";
				var coerce = mkBuiltin(name, TTFun([TTAny], e.expectedType), removeLeadingTrivia(e));
				mkCall(coerce, [e.with(expectedType = TTAny)]);
			case _:
				e;
		}
	}
}
