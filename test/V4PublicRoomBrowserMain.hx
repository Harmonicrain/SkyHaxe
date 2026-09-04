import com.sulake.habbo.configuration.ExternalVariables;
import com.sulake.habbo.room.object.visualization.room.publicroom.PublicRoomVisualizationLoader;
import js.Browser;
import openfl.display.Sprite;
import openfl.display.StageAlign;
import openfl.display.StageScaleMode;
import openfl.text.TextField;
import openfl.text.TextFormat;

/** Browser canary for the same public-room loader used by the production login flow. */
class V4PublicRoomBrowserMain extends Sprite {
	var status:TextField;

	public function new() {
		super();
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		status = new TextField();
		status.defaultTextFormat = new TextFormat("_sans", 14, 0xFFFFFF);
		status.width = 900;
		status.height = 28;
		status.background = true;
		status.backgroundColor = 0x10131A;
		status.text = "SkyHaxe · loading real public room…";
		ExternalVariables.load("/ngh/gamedata/external_dev_vars.txt", function(variables) {
			PublicRoomVisualizationLoader.load(variables.get("flash.client.url"), "netcafe",
				Std.int(stage.stageWidth), Std.int(stage.stageHeight), function(canvas, report) {
					addChild(canvas.master);
					addChild(status);
					status.text = 'SkyHaxe · V4 ${report.roomType} · ${report.layers} authored layers';
					var root = Browser.document.documentElement;
					root.setAttribute("data-skyhaxe-v4", "pass");
					root.setAttribute("data-skyhaxe-v4-report", haxe.Json.stringify(report));
					Browser.console.info('V4_PUBLIC_ROOM_PASS type=${report.roomType} '
						+ 'layers=${report.layers} bitmaps=${report.uniqueBitmaps}');
				}, fail);
		}, fail);
	}

	function fail(error:Dynamic):Void {
		var message = Std.string(error);
		if (status.parent == null) addChild(status);
		status.text = "V4 FAILED · " + message;
		Browser.document.documentElement.setAttribute("data-skyhaxe-v4", "fail");
		Browser.document.documentElement.setAttribute("data-skyhaxe-v4-error", message);
		Browser.console.error("V4_PUBLIC_ROOM_FAILED: " + message);
	}
}
