package ax3.filters;

class RewriteDelete extends AbstractFilter {
	static final tDeleteField = TTFun([TTAny, TTString], TTBoolean);

	override function processExpr(e:TExpr):TExpr {
		e = mapExpr(processExpr, e);
		return switch (e.kind) {
			case TEDelete(keyword, eobj):
				switch eobj.kind {
					case TEArrayAccess(a) | TEParens(_, {kind: TEArrayAccess(a)}, _):
						rewrite(keyword, a, eobj, e);

					case TEField({kind: TOExplicit(_, object)}, fieldName, fieldToken)
						| TEParens(_, {kind: TEField({kind: TOExplicit(_, object)}, fieldName, fieldToken)}, _):
						rewriteField(keyword, object, fieldName, fieldToken, e);

					case _:
						reportError(exprPos(eobj), "Unsupported `delete` operation");
						e;
				}
			case _:
				e;
		}
	}

	function rewriteField(deleteKeyword:Token, object:TExpr, fieldName:String, fieldToken:Token, eDelete:TExpr):TExpr {
		return switch object.type {
			case TTObject(_) | TTAny:
				var name = mk(TELiteral(TLString(new Token(0, TkStringDouble, haxe.Json.stringify(fieldName),
					fieldToken.leadTrivia, fieldToken.trailTrivia))), TTString, TTString);
				var eDeleteField = mkBuiltin("Reflect.deleteField", tDeleteField, deleteKeyword.leadTrivia);
				mkCall(eDeleteField, [object, name], TTBoolean).with(expectedType = eDelete.expectedType);

			case _:
				throwError(exprPos(object), 'Cannot delete sealed field `$fieldName` from ${object.type.getName()}');
		}
	}

	function rewrite(deleteKeyword:Token, a:TArrayAccess, eDeleteObj:TExpr, eDelete:TExpr):TExpr {
		// TODO: trivia \o/
		return switch [a.eobj.type, a.eindex.type] {
			case [TTDictionary(keyType, _), _]:
				processLeadingToken(function(t) {
					t.leadTrivia = deleteKeyword.leadTrivia.concat(t.leadTrivia);
				}, a.eobj);

				var eRemoveField = mk(TEField({kind: TOExplicit(mkDot(), a.eobj), type: a.eobj.type}, "remove", mkIdent("remove")), TTFunction, TTFunction);
				mkCall(eRemoveField, [a.eindex.with(expectedType = keyType)], TTBoolean);

			case [TTObject(_) | TTAny, _] | [_, TTString]:
				// TODO: this should actually generate (expr : ASObject).___delete that handles delection of Dictionary keys too
				// make sure the expected type is string so further filters add the cast
				var eindex = if (a.eindex.type != TTString) a.eindex.with(expectedType = TTString) else a.eindex;
				var eDeleteField = mkBuiltin("Reflect.deleteField", tDeleteField, deleteKeyword.leadTrivia);
				eDelete.with(kind = TECall(eDeleteField, {
					openParen: new Token(0, TkParenOpen, "(", a.syntax.openBracket.leadTrivia, a.syntax.openBracket.trailTrivia),
					closeParen: new Token(0, TkParenClose, ")", a.syntax.openBracket.leadTrivia, a.syntax.openBracket.trailTrivia),
					args: [{expr: a.eobj, comma: commaWithSpace}, {expr: eindex, comma: null}]
				}));

			case [TTXMLList, TTInt | TTUint]:
				reportError(deleteKeyword.pos, 'TODO: delete on XMLList');
				mkNullExpr(eDelete.expectedType);

			case [TTArray(_), TTInt | TTUint]:
				// AS3 delete removes the indexed property without compacting or shortening an Array.
				// Reflect.deleteField has the same JavaScript behavior; assigning null does not.
				var eindex = a.eindex.with(expectedType = TTString);
				var eDeleteField = mkBuiltin("Reflect.deleteField", tDeleteField, deleteKeyword.leadTrivia);
				mkCall(eDeleteField, [a.eobj, eindex], TTBoolean).with(expectedType = eDelete.expectedType);

			case _:
				throwError(exprPos(a.eindex), 'Unknown `delete` expression: index type = ${a.eindex.type.getName()}, object type = ${a.eobj.type}');
		}
	}
}
