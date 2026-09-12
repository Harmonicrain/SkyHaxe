import com.sulake.core.assets.swf.SwfBitmap;
import com.sulake.core.assets.swf.SwfCharacter.SwfCharacterKind;
import com.sulake.core.assets.swf.SwfFile;
import haxe.crypto.Sha1;
import haxe.io.Bytes;
import js.Browser;
import js.lib.Uint8Array;
import openfl.display.BitmapData;

/**
 * Pixel-identity baseline for the SWF bitmap decoder.
 *
 * `SwfBitmap` is the port's own reader, and the path every furni, room and avatar bitmap takes is
 * four full traversals of every pixel on the main thread: a pure-Haxe inflate, `decodePix24`
 * building an RGBA `Bytes`, `toBitmapData` rewriting that into a big-endian `ByteArray`, and
 * `setPixels` walking it once more. Room entry runs this for well over a hundred sheets, which is
 * where the ~1.2s stall on teleport comes from, so it is worth fusing.
 *
 * Fusing it is only safe against a recorded answer. Two details make "looks right" untrustworthy:
 * `toBitmapData` is explicitly big-endian because OpenFL follows host endianness and *"leaving it
 * implicit swaps channels and alpha on HTML5"*, and `DefineBitsLossless2` stores premultiplied
 * ARGB that `decodePix24` un-premultiplies with a rounding rule of its own. Either mistake
 * survives a screenshot and shows up later as slightly wrong colour or alpha on every furni.
 *
 * So this hashes the finished ARGB surface of every bitmap character in a fixed set of real
 * assets. It asserts nothing by itself: it prints a digest per character, and
 * `scripts/verify-swf-decode.ps1` compares that against the committed baseline. Recording the
 * answer first is the point -- the optimisation is a refactor whose whole contract is that these
 * digests do not move.
 */
class SwfBitmapDecodeTest {
    /**
     * Read-only corpus paths, served to the page by `scripts/verify-swf-decode.ps1`.
     *
     * Chosen for coverage of what the client actually loads rather than for breadth: a small
     * furni, a larger animated one, the room content shell and an avatar body library. Every
     * bitmap character in all four is `DefineBitsLossless2` format 5 -- of 504 surveyed across
     * these files, that branch is the only one that occurs -- so it is the branch the baseline
     * must pin. The other decoders (`decodeColorMapped`, `decodePix15`) stay unexercised here,
     * and any change to them is correspondingly unguarded.
     */
    static final SOURCES = [
        "corpus/easter_c18_chair.swf",
        "corpus/rainbow_ltd19_parasol.swf",
        "corpus/HabboRoomContent.swf",
        "corpus/hh_human_body.swf"
    ];

    static function main():Void {
        var results = [];
        var pending = SOURCES.length;
        var failed = false;

        for (source in SOURCES) {
            fetchBytes(source, function(bytes) {
                digestFile(source, bytes, function(result) {
                    results.push(result);
                    if (--pending == 0) report(results, failed);
                }, function(error) {
                    failed = true;
                    results.push({source: source, error: Std.string(error)});
                    if (--pending == 0) report(results, failed);
                });
            }, function(error) {
                failed = true;
                results.push({source: source, error: Std.string(error)});
                if (--pending == 0) report(results, failed);
            });
        }
    }

    static function digestFile(source:String, bytes:Bytes, complete:Dynamic->Void,
            fail:Dynamic->Void):Void {
        var settled = false;
        function failOnce(error:Dynamic):Void {
            if (settled) return;
            settled = true;
            fail(error);
        }
        SwfFile.readAsync(bytes).onComplete(function(file) {
            var characters = [];
            var bitmaps = [];
            for (name in file.exportedNames()) {
                var character = file.symbols.get(name);
                if (character == null) continue;
                switch (character.kind) {
                    case Bitmap: bitmaps.push({name: name, character: character});
                    case _:
                }
            }
            var pending = bitmaps.length;
            if (pending == 0) {
                settled = true;
                complete({source: source, characters: characters});
                return;
            }
            for (entry in bitmaps) {
                SwfBitmap.decodeBitmapAsync(entry.character).onComplete(function(bitmap) {
                    characters.push({name: entry.name, width: bitmap.width, height: bitmap.height,
                        argb: surfaceDigest(bitmap)});
                    bitmap.dispose();
                    if (--pending == 0) {
                        if (settled) return;
                        settled = true;
                        characters.sort(function(a, b) return a.name < b.name ? -1
                            : (a.name > b.name ? 1 : 0));
                        complete({source: source, characters: characters});
                    }
                }).onError(failOnce);
            }
        }).onError(failOnce);
    }

    /**
     * SHA-1 of the surface as straight ARGB bytes.
     *
     * Read back through `getPixels` rather than from the source buffer so the digest covers
     * everything the replacement must reproduce -- channel order, alpha, and whatever `setPixels`
     * did on the way in.
     */
    static function surfaceDigest(bitmap:BitmapData):String {
        var pixels = bitmap.getPixels(bitmap.rect);
        pixels.position = 0;
        var raw = Bytes.alloc(pixels.length);
        for (index in 0...pixels.length) raw.set(index, pixels.readUnsignedByte());
        return Sha1.make(raw).toHex();
    }

    static function report(results:Array<Dynamic>, failed:Bool):Void {
        results.sort(function(a, b) return a.source < b.source ? -1 : 1);
        var body = haxe.Json.stringify({ok: !failed, files: results});
        // The harness scrapes <body>, the same way the shadow gate does.
        Browser.document.body.innerText = (failed ? "SWF_DECODE_BASELINE_FAIL " : "SWF_DECODE_BASELINE ")
            + body;
    }

    static function fetchBytes(url:String, onLoaded:Bytes->Void, onError:Dynamic->Void):Void {
        Browser.window.fetch(url).then(function(response) {
            if (!response.ok) throw 'HTTP ${response.status} for $url';
            return response.arrayBuffer();
        }).then(function(buffer) {
            var array = new Uint8Array(buffer);
            var bytes = Bytes.alloc(array.length);
            for (index in 0...array.length) bytes.set(index, array[index]);
            onLoaded(bytes);
            return null;
        }).catchError(onError);
    }
}
