package com.sulake.core.assets;

import com.sulake.core.utils.xml.XMLList;
import haxe.io.Bytes;
import openfl.media.Sound;
import openfl.utils.ByteArray;

/**
 * The `sound/mp3` asset type, holding an OpenFL `Sound` built from a SWF DefineSound character.
 *
 * Flash got this for free: `[Embed(source="x.mp3")]` produced a class extending `Sound`, and the
 * player's own MP3 decoder was behind it. On HTML5 nothing constructs a `Sound` on its own, so the
 * MP3 frames `SwfSound` already extracts have to be handed to one explicitly.
 *
 * Why this file exists at all: the converted `HabboSoundManagerFlash10.playSound` reads
 * `assets.getAssetByName(name).content` and assigns `volume` on the result *without a null check* --
 * faithfully, because the AS3 does the same and Flash always had the asset. With no sound adapter
 * the content was null, so every message-send, respect, purchase and camera-shutter threw a
 * TypeError, and because that throw escapes into `WindowContext.update` it also aborted the rest of
 * the window-context update pass. A missing asset type was costing unrelated UI work.
 *
 * Content is prepared lazily. `AudioBuffer.fromBytes` base64-encodes the whole MP3 into a data URL
 * for Howler, which is not work worth doing at boot for the eight or nine samples a session may
 * never play. `ILazyAsset` is the same contract `BitmapDataAsset` uses for the same reason.
 */
class SoundAsset implements ILazyAsset {
    public var url(get, never):Null<String>;
    public var content(get, never):Dynamic;
    public var declaration(get, never):Null<AssetTypeDeclaration>;
    public var disposed(get, never):Bool;

    private var _disposed = false;
    private var _declaration:Null<AssetTypeDeclaration>;
    private var _url:Null<String>;
    private var _unknown:Dynamic;
    private var _sound:Null<Sound>;
    /** Borrowed content belongs to the asset it came from, and must not be closed here. */
    private var _ownsSound = true;

    public function new(declaration:AssetTypeDeclaration, ?url:String) {
        _declaration = declaration;
        _url = url;
    }

    private inline function get_url():Null<String> return _url;
    private inline function get_declaration():Null<AssetTypeDeclaration> return _declaration;
    private inline function get_disposed():Bool return _disposed;

    private function get_content():Dynamic {
        if (_sound == null) prepareLazyContent();
        return _sound;
    }

    public function setUnknownContent(unknown:Dynamic):Void {
        releaseCurrentSound();
        _unknown = unknown;
        _sound = null;
        _ownsSound = true;
    }

    /**
     * Accept every shape the asset pipeline can deliver.
     *
     * `Bytes` is what the SWF reader produces and the ordinary path here. The `Sound` and `Class`
     * cases exist because the original `[Embed]` contract delivered one or the other, and the
     * converted `AssetLibrary` still routes both; refusing them would make this adapter narrower
     * than the type it stands in for, which is how the seam gaps in this port keep starting.
     */
    public function prepareLazyContent():Void {
        if (_unknown == null || _sound != null) return;
        var value:Dynamic = _unknown;

        if (Std.isOfType(value, Class)) value = Type.createInstance(cast value, []);

        if (Std.isOfType(value, Sound)) {
            _sound = cast value;
            _unknown = null;
            return;
        }
        if (Std.isOfType(value, SoundAsset)) {
            var source:SoundAsset = cast value;
            source.prepareLazyContent();
            borrowFrom(source);
            return;
        }
        if (Std.isOfType(value, Bytes)) {
            _sound = fromMp3(cast(value, Bytes));
            _unknown = null;
            return;
        }
        if (Std.isOfType(value, ByteArray)) {
            _sound = fromMp3((cast value : ByteArray));
            _unknown = null;
            return;
        }
        throw new haxe.Exception("Failed to convert content to SoundAsset");
    }

    /**
     * Build a `Sound` from raw MP3 frames.
     *
     * `loadCompressedDataFromByteArray` reaches `AudioBuffer.fromBytes`, which on HTML5 wraps the
     * bytes in a Howler source and sniffs the codec from the frame header -- so the DefineSound
     * rate/channel fields are not needed here, and are deliberately not second-guessed. The call
     * dispatches `IOErrorEvent` rather than throwing when the bytes are not decodable, so the
     * failure is turned back into an exception for the caller that already handles one.
     */
    private static function fromMp3(mp3:Bytes):Sound {
        if (mp3 == null || mp3.length == 0) throw new haxe.Exception("SoundAsset received empty MP3 data");
        var sound = new Sound();
        var failed = false;
        var onError = function(_) failed = true;
        sound.addEventListener(openfl.events.IOErrorEvent.IO_ERROR, onError);
        sound.loadCompressedDataFromByteArray(ByteArray.fromBytes(mp3), mp3.length);
        sound.removeEventListener(openfl.events.IOErrorEvent.IO_ERROR, onError);
        if (failed) throw new haxe.Exception("SoundAsset could not decode " + mp3.length + " bytes of MP3");
        return sound;
    }

    private function borrowFrom(source:SoundAsset):Void {
        _sound = cast source.content;
        _unknown = null;
        _ownsSound = false;
    }

    public function setFromOtherAsset(asset:IAsset):Void {
        if (!Std.isOfType(asset, SoundAsset)) {
            throw new haxe.Exception("Provided asset should be of type SoundAsset!");
        }
        releaseCurrentSound();
        borrowFrom(cast asset);
    }

    /** Sounds carry no manifest parameters; bitmaps' offset/region/flip have no analogue here. */
    public function setParamsDesc(xml:XMLList):Void {}

    private function releaseCurrentSound():Void {
        if (_sound != null && _ownsSound) {
            // close() detaches the Howler source. A borrowed sound is still owned by the asset it
            // came from, so closing it here would silence that one too.
            try _sound.close() catch (_:Dynamic) {}
        }
        _sound = null;
    }

    public function dispose():Void {
        if (_disposed) return;
        releaseCurrentSound();
        _unknown = null;
        _declaration = null;
        _url = null;
        _disposed = true;
    }
}
