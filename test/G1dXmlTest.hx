import com.sulake.core.utils.xml.XML;
import com.sulake.core.utils.xml.XMLList;

class G1dXmlTest {
    private static var assertions:Int = 0;

    public static function main():Void {
        testReadContract();
        testListContract();
        testMutationAndCopy();
        testSerializationAndNamespaces();
        testFlashParseDefaults();
        trace('G1D_XML_PASS assertions=$assertions');
    }

    private static function fixture():XML {
        return new XML(
            '<manifest>\n'
            + '  <library name="core">\n'
            + '    <asset name="plain">Hello &amp; goodbye</asset>\n'
            + '    <asset name="nested"><param key="one"/><param key="two"/></asset>\n'
            + '  </library>\n'
            + '</manifest>'
        );
    }

    private static function testReadContract():Void {
        var manifest = fixture();
        equal(1, manifest.length(), "XML length is one");
        equal("manifest", manifest.name(), "element name");
        equal("manifest", manifest.localName(), "element localName");
        equal(manifest, manifest.at(0), "XML index zero returns itself");
        equal(null, manifest.at(1), "XML index above zero is absent");

        var library = manifest.child("library");
        equal(1, library.length(), "named child selection");
        equal("core", library.attribute("name").toString(), "attribute coercion");
        equal(true, library.hasOwnProperty("@name"), "attribute existence");
        equal(false, library.hasOwnProperty("@missing"), "missing attribute existence");
        equal(true, manifest.hasOwnProperty("library"), "child existence");

        var assets = library.child("asset");
        equal(2, assets.length(), "repeated child selection");
        equal("Hello & goodbye", assets.at(0).toString(), "simple-content coercion");
        equal("Hello & goodbye", assets.at(0).text().toString(), "text selection");
        equal("library", assets.at(0).parent().name(), "parent selection");
    }

    private static function testListContract():Void {
        var assets = fixture().child("library").child("asset");
        equal(2, assets.length(), "XMLList length");
        equal("plain", assets.attribute("name").at(0).toString(), "flattened attributes");
        equal("nested", assets.attribute("name").at(1).toString(), "attribute order");
        equal(2, assets.child("param").length(), "child selection flattens list members");
        equal("one", assets.child("param").attribute("key").at(0).toString(), "chained selection");

        var names:Array<String> = [];
        for (asset in assets) {
            names.push(asset.attribute("name").toString());
        }
        arrayEqual(["plain", "nested"], names, "iteration preserves document order");

        equal(1, fixture().children().length(), "ignorable parse whitespace is excluded");
        equal(2, assets.at(1).children().length(), "element children remain visible");
    }

    private static function testMutationAndCopy():Void {
        var source = fixture();
        var copy = source.copy();
        var copiedLibrary = copy.child("library").at(0);
        copiedLibrary.setAttribute("name", "copy");
        copiedLibrary.appendChild(new XML('<asset name="added">value</asset>'));

        equal("core", source.child("library").attribute("name").toString(), "copy is independent");
        equal("copy", copiedLibrary.attribute("name").toString(), "attribute mutation");
        equal(3, copiedLibrary.child("asset").length(), "appendChild adds an element");
        equal("value", copiedLibrary.child("asset").at(2).toString(), "appended simple content");

        copiedLibrary.replace("asset", new XML('<asset name="replacement">new</asset>'));
        equal(1, copiedLibrary.child("asset").length(), "replace collapses matching properties");
        equal("replacement", copiedLibrary.child("asset").attribute("name").toString(), "replace value");

        var empty = new XML();
        empty.appendChild(new XML("<root/>"));
        equal("root", empty.children().at(0).name(), "empty XML document accepts a child");
    }

    private static function testSerializationAndNamespaces():Void {
        var source = fixture();
        var serialized = source.toXMLString();
        equal(true, serialized.indexOf('<library name="core">') >= 0, "element serialization");
        equal(true, serialized.indexOf("Hello &amp; goodbye") >= 0, "text is escaped on serialization");
        equal('name="core"', source.child("library").attribute("name").toXMLString(), "attribute serialization");

        var namespaced = new XML('<root xmlns:h="urn:test"><h:item id="7"/></root>');
        var item = namespaced.child("h:item").at(0);
        equal("h:item", item.name(), "qualified name");
        equal("item", item.localName(), "qualified localName");
    }

    private static function testFlashParseDefaults():Void {
        var declared = new XML('<?xml version="1.0"?><!-- ignored --><root>left<![CDATA[ & right]]></root>');
        equal("root", declared.name(), "XML declaration is not selected as the root");
        equal(2, declared.text().length(), "PCData and CDATA are both text nodes");
        equal("left & right", declared.toString(), "CDATA participates in simple content");
        equal(2, declared.children().length(), "ignored comments and declarations stay out of children");

        equal(declared, XML.coerce(declared), "XML coercion retains node identity");
        equal(declared, XMLList.coerce(declared).at(0), "XMLList coercion wraps an existing node");

        var listCopy = fixture().child("library").child("asset").copy();
        listCopy.at(0).setAttribute("name", "changed");
        equal("changed", listCopy.at(0).attribute("name").toString(), "XMLList copy is mutable");
        equal("plain", fixture().child("library").child("asset").at(0).attribute("name").toString(), "XMLList copy is deep");
    }

    private static function arrayEqual(expected:Array<String>, actual:Array<String>, message:String):Void {
        equal(expected.length, actual.length, '$message (length)');
        for (index in 0...expected.length) {
            equal(expected[index], actual[index], '$message (index $index)');
        }
    }

    private static function equal(expected:Dynamic, actual:Dynamic, message:String):Void {
        assertions++;
        if (!same(expected, actual)) {
            throw new haxe.Exception('$message: expected ${Std.string(expected)}, got ${Std.string(actual)}');
        }
    }

    private static inline function same(left:Dynamic, right:Dynamic):Bool {
        #if js
        return js.Syntax.strictEq(left, right);
        #else
        return left == right;
        #end
    }
}
