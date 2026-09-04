import com.sulake.core.assets.swf.SwfFile;
import com.sulake.core.utils.xml.XML;
import haxe.Json;
import haxe.crypto.Md5;
import haxe.crypto.Sha256;
import haxe.io.Bytes;
import js.Browser;
import js.lib.Uint8Array;
import openfl.utils.Assets;

typedef XmlMetrics = {
	var root:String;
	var elements:Int;
	var attributes:Int;
	var textNodes:Int;
	var maxDepth:Int;
	var tagCounts:Map<String, Int>;
	var canonicalMd5:String;
}

class G3XmlBlobTest {
	public static var assertions(default, null):Int = 0;
	public static var compared(default, null):Int = 0;
	public static var report(default, null):Dynamic;

	static var contract:Dynamic;
	static var onError:Dynamic->Void;
	static var categoryCounts:Map<String, Int>;

	public static function run(onDone:String->Void, onFailure:Dynamic->Void):Void {
		assertions = 0;
		compared = 0;
		onError = onFailure;
		categoryCounts = new Map();
		contract = Json.parse(Assets.getText("fixtures/g3_xml_blob_contract.json"));
		var files:Array<String> = cast contract.files;
		next(files, 0, onDone);
	}

	static function next(files:Array<String>, index:Int, onDone:String->Void):Void {
		if (index >= files.length) {
			guard(function() finish(onDone));
			return;
		}
		var relative = files[index];
		fetchBytes("/ngh/" + relative, function(raw) {
			guard(function() {
				checkFile(relative, raw);
				next(files, index + 1, onDone);
			});
		});
	}

	static function fetchBytes(url:String, done:Bytes->Void):Void {
		Browser.window.fetch(url).then(function(response) {
			if (!response.ok) throw 'HTTP ${response.status} for $url';
			return response.arrayBuffer();
		}).then(function(buffer) {
			var source = new Uint8Array(buffer);
			var bytes = Bytes.alloc(source.length);
			for (index in 0...source.length) bytes.set(index, source[index]);
			done(bytes);
			return null;
		});
	}

	static function checkFile(relative:String, raw:Bytes):Void {
		var swf = SwfFile.read(raw);
		var records:Array<Dynamic> = cast contract.records;
		for (expected in records) {
			if (expected.file != relative) continue;
			var character = swf.symbols.get(expected.symbol);
			truth(character != null, '${expected.symbol} exported');
			if (character == null) continue;
			equal(expected.bytes, character.payload.length, '${expected.symbol} raw length');
			equal(expected.raw_sha256, Sha256.make(character.payload).toHex(), '${expected.symbol} raw sha256');
			var text = character.payload.getString(0, character.payload.length);
			if (StringTools.startsWith(text, "\uFEFF")) text = text.substr(1);
			while (StringTools.endsWith(text, "\x00")) text = text.substr(0, text.length - 1);
			var metrics = measure(new XML(text));
			equal(expected.root, metrics.root, '${expected.symbol} root');
			equal(expected.elements, metrics.elements, '${expected.symbol} element count');
			equal(expected.attributes, metrics.attributes, '${expected.symbol} attribute count');
			equal(expected.text_nodes, metrics.textNodes, '${expected.symbol} text-node count');
			equal(expected.max_depth, metrics.maxDepth, '${expected.symbol} maximum depth');
			equal(expected.canonical_md5, metrics.canonicalMd5, '${expected.symbol} canonical md5');
		compareTagCounts(expected.tag_counts, metrics.tagCounts, expected.symbol);
		var count = categoryCounts.get(expected.category);
		categoryCounts.set(expected.category, count == null ? 1 : count + 1);
		compared++;
		}
	}

	static function measure(root:XML):XmlMetrics {
		var tokens:Array<String> = [];
		var tags = new Map<String, Int>();
		var metrics:XmlMetrics = {
			root: root.localName(), elements: 0, attributes: 0, textNodes: 0,
			maxDepth: 0, tagCounts: tags, canonicalMd5: ""
		};
		visit(root, 0, tokens, metrics);
		metrics.canonicalMd5 = Md5.encode(tokens.join("\n"));
		return metrics;
	}

	static function visit(node:XML, depth:Int, tokens:Array<String>, metrics:XmlMetrics):Void {
		var name = node.localName();
		metrics.elements++;
		if (depth > metrics.maxDepth) metrics.maxDepth = depth;
		var count = metrics.tagCounts.get(name);
		metrics.tagCounts.set(name, count == null ? 1 : count + 1);
		tokens.push("E:" + name);
		var attributes = [for (attribute in node.attribute("*")) attribute];
		attributes.sort(function(left, right) return Reflect.compare(left.name(), right.name()));
		for (attribute in attributes) {
			metrics.attributes++;
			tokens.push('A:${attribute.name()}=${attribute.toString()}');
		}
		for (child in node.children()) {
			if (child.localName() == null) {
				var value = StringTools.trim(child.toString());
				if (value != "") {
					metrics.textNodes++;
					tokens.push("T:" + value);
				}
			} else {
				visit(child, depth + 1, tokens, metrics);
			}
		}
		tokens.push("X:" + name);
	}

	static function compareTagCounts(expected:Dynamic, actual:Map<String, Int>, symbol:String):Void {
		var names = Reflect.fields(expected);
		equal(names.length, [for (_ in actual.keys()) 1].length, '$symbol distinct tag count');
		for (name in names) equal(Reflect.field(expected, name), actual.get(name), '$symbol tag <$name> count');
	}

	static function finish(onDone:String->Void):Void {
		equal(25, compared, "all representative XML blobs compared");
		for (category in ["assets", "visualization", "logic", "index", "manifest"])
			equal(5, categoryCounts.get(category), '$category category coverage');
		report = {assertions: assertions, compared: compared, categories: categoryCounts};
		onDone('G3_XML_BLOB_PASS assertions=$assertions compared=$compared');
	}

	static function guard(body:Void->Void):Void {
		try body() catch (error:Dynamic) onError(error);
	}

	static function truth(value:Bool, message:String):Void equal(true, value, message);
	static function equal(expected:Dynamic, actual:Dynamic, message:String):Void {
		assertions++;
		if (!js.Syntax.strictEq(expected, actual))
			throw new haxe.Exception('$message: expected ${Std.string(expected)}, got ${Std.string(actual)}');
	}
}
