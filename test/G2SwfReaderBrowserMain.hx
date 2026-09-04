import js.Browser;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.events.IOErrorEvent;
import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.media.SoundTransform;
import openfl.utils.ByteArray;

class G2SwfReaderBrowserMain extends Sprite {
	var status:TextField;

	public function new() {
		super();
		status = new TextField();
		status.defaultTextFormat = new TextFormat("_sans", 15, 0xE7EEF9, false);
		status.width = 900;
		status.height = 400;
		status.multiline = true;
		status.wordWrap = true;
		status.x = 18;
		status.y = 14;
		status.text = "SkyHaxe · G2 SWF reader canary\nfetching real SWFs over HTTP…";
		addChild(status);

		try {
			G2SwfReaderTest.run(onPass, fail);
		} catch (error:Dynamic) {
			fail(error);
		}
	}

	function onPass(marker:String):Void {
		var report = G2SwfReaderTest.report;
		var lines = ["SkyHaxe · G2 SWF reader canary", "", marker, ""];
		for (result in (cast report.files : Array<Dynamic>)) {
			lines.push('  ${result.file}');
			lines.push('      ${result.container}  ${result.status}  compared=${result.compared}');
		}
		lines.push("");
		lines.push('cold fetch+parse ${report.cold_fetch_parse_seconds}s   '
			+ 'warm ${report.warm_fetch_parse_seconds}s');
		lines.push("");
		lines.push("MP3 extraction passed. Click the browser playback button to close G2d.");
		status.text = lines.join("\n");

		var button = Browser.document.createButtonElement();
		button.id = "g2-play-mp3";
		button.textContent = "Play verified BattleBall MP3 canary";
		button.style.position = "fixed";
		button.style.left = "18px";
		button.style.bottom = "18px";
		button.style.padding = "10px 16px";
		button.onclick = function(_) {
			button.disabled = true;
			playMp3(marker);
		};
		Browser.document.body.appendChild(button);
	}

	function playMp3(marker:String):Void {
		var soundData = G2SwfReaderTest.playbackSound;
		if (soundData == null) {
			fail("no playback MP3 selected");
			return;
		}
		var sound = new Sound();
		sound.addEventListener(IOErrorEvent.IO_ERROR, function(_) fail("OpenFL rejected verified MP3 bytes"));
		var bytes = ByteArray.fromBytes(soundData.mp3);
		sound.loadCompressedDataFromByteArray(bytes, bytes.length);
		var channel = sound.play(0, 0, new SoundTransform(0.04));
		if (channel == null) {
			fail("OpenFL returned no SoundChannel");
			return;
		}
		waitForPlayback(channel, marker, haxe.Timer.stamp());
	}

	function waitForPlayback(channel:SoundChannel, marker:String, started:Float):Void {
		haxe.Timer.delay(function() {
			if (channel.position > 0) {
				var position = channel.position;
				channel.stop();
				var report = G2SwfReaderTest.report;
				Reflect.setField(report, "playback", {
					started: true,
					position_ms_before_stop: position,
					volume: 0.04,
					user_gesture: true
				});
				var root = Browser.document.documentElement;
				root.setAttribute("data-skyhaxe-g2-swf-reader", "pass");
				root.setAttribute("data-skyhaxe-g2-assertions", Std.string(report.assertions));
				root.setAttribute("data-skyhaxe-g2-comparisons", Std.string(report.comparisons));
				root.setAttribute("data-skyhaxe-g2-mp3-playback", "pass");
				root.setAttribute("data-skyhaxe-g2-report", haxe.Json.stringify(report));
				status.appendText('\n\nMP3 playback started (${Math.round(position)} ms observed) and stopped cleanly.');
				Browser.console.info(marker + " mp3_playback=pass");
				return;
			}
			if (haxe.Timer.stamp() - started >= 6) {
				channel.stop();
				fail("MP3 SoundChannel never advanced after trusted click");
				return;
			}
			waitForPlayback(channel, marker, started);
		}, 250);
	}

	function fail(error:Dynamic):Void {
		var text = Std.string(error);
		status.text = "G2 FAILED\n\n" + text;
		Browser.document.documentElement.setAttribute("data-skyhaxe-g2-swf-reader", "fail");
		Browser.document.documentElement.setAttribute("data-skyhaxe-g2-error", text);
		Browser.console.error("SKYHAXE_G2_SWF_READER_FAIL", error);
	}
}
