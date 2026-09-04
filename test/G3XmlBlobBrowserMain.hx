import js.Browser;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;

class G3XmlBlobBrowserMain extends Sprite {
	var status:TextField;

	public function new() {
		super();
		status = new TextField();
		status.defaultTextFormat = new TextFormat("_sans", 16, 0xE7EEF9);
		status.width = 900;
		status.height = 400;
		status.x = 18;
		status.y = 18;
		status.multiline = true;
		status.text = "SkyHaxe · G3 real XML blob parity\nfetching five SWFs over HTTP…";
		addChild(status);
		G3XmlBlobTest.run(pass, fail);
	}

	function pass(marker:String):Void {
		status.text = marker + "\n\n25 real blobs · five each: assets, visualization, logic, index, manifest";
		var root = Browser.document.documentElement;
		root.setAttribute("data-skyhaxe-g3-xml-blobs", "pass");
		root.setAttribute("data-skyhaxe-g3-assertions", Std.string(G3XmlBlobTest.assertions));
		root.setAttribute("data-skyhaxe-g3-compared", Std.string(G3XmlBlobTest.compared));
		Browser.console.info(marker);
	}

	function fail(error:Dynamic):Void {
		var message = Std.string(error);
		status.text = "G3 FAILED\n\n" + message;
		Browser.document.documentElement.setAttribute("data-skyhaxe-g3-xml-blobs", "fail");
		Browser.document.documentElement.setAttribute("data-skyhaxe-g3-error", message);
		Browser.console.error("SKYHAXE_G3_XML_BLOB_FAIL", error);
	}
}
