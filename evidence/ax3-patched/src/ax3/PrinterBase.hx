package ax3;

import ax3.Token;
import ax3.ParseTree;

class PrinterBase {
	final buf:StringBuf;

	public function new(?buf) {
		this.buf = if (buf != null) buf else new StringBuf();
	}

	public function toString() {
		return buf.toString();
	}

	inline function printDot(s:Token) {
		printTextWithTrivia(".", s);
	}

	inline function printComma(c:Token) {
		printTextWithTrivia(",", c);
	}

	inline function printColon(s:Token) {
		printTextWithTrivia(":", s);
	}

	inline function printSemicolon(s:Token) {
		printTextWithTrivia(";", s);
	}

	inline function printOpenBracket(s:Token) {
		printTextWithTrivia("[", s);
	}

	inline function printCloseBracket(s:Token) {
		printTextWithTrivia("]", s);
	}

	inline function printOpenBrace(s:Token) {
		printTextWithTrivia("{", s);
	}

	inline function printCloseBrace(s:Token) {
		printTextWithTrivia("}", s);
	}

	inline function printOpenParen(s:Token) {
		printTextWithTrivia("(", s);
	}

	inline function printCloseParen(s:Token) {
		printTextWithTrivia(")", s);
	}

	// Patched for M2: see evidence/m2_patch_ax3.py
	//
	// AS3 lets a package segment be named `enum`; Haxe does not, and the avatar package uses it
	// (`com.sulake.habbo.avatar.enum` holds AvatarAction, AvatarScaleType and six more, imported
	// across the whole closure). Escaping it here covers the package declaration, every import and
	// every qualified reference, because all three print through this method. Main.hx applies the
	// same escape to the output directory so the file lands where the package says it is.
	//
	// Only lowercase segments can collide: a Haxe keyword is lowercase and AS3 type names are
	// capitalized, so a class is never renamed by this.
	public static final RESERVED_PACKAGE_SEGMENTS = [
		"abstract", "break", "case", "cast", "catch", "class", "continue", "default", "do",
		"dynamic", "else", "enum", "extends", "extern", "false", "final", "for", "function", "if",
		"implements", "import", "in", "inline", "interface", "macro", "new", "null", "operator",
		"overload", "override", "package", "private", "public", "return", "static", "super",
		"switch", "this", "throw", "true", "try", "typedef", "untyped", "using", "var", "while"
	];

	public static function escapePathSegment(segment:String):String {
		return if (RESERVED_PACKAGE_SEGMENTS.indexOf(segment) != -1) "_" + segment else segment;
	}

	function printDotPath(p:DotPath) {
		printSeparated(p, t -> printTextWithTrivia(escapePathSegment(t.text), t), t -> printDot(t));
	}

	function printSeparated<T>(s:Separated<T>, f:T->Void, fsep:Token->Void) {
		f(s.first);
		for (v in s.rest) {
			fsep(v.sep);
			f(v.element);
		}
	}

	function printTextWithTrivia(text:String, triviaToken:Token) {
		printTrivia(triviaToken.leadTrivia);
		buf.add(text);
		printTrivia(triviaToken.trailTrivia);
	}

	function printTrivia(trivia:Array<Trivia>) {
		for (item in trivia) {
			buf.add(item.text);
		}
	}
}
