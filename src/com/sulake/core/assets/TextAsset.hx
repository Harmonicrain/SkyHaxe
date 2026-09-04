package com.sulake.core.assets;

import com.sulake.core.utils.xml.XMLList;
import openfl.utils.ByteArray;
import openfl.utils.ByteArray.ByteArrayData;

class TextAsset implements IAsset {
    public var url(get, never):Null<String>;
    public var content(get, never):Dynamic;
    public var declaration(get, never):Null<AssetTypeDeclaration>;
    public var disposed(get, never):Bool;

    private var _disposed = false;
    private var _content:Null<String> = "";
    private var _declaration:Null<AssetTypeDeclaration>;
    private var _url:Null<String>;

    public function new(declaration:AssetTypeDeclaration, ?url:String) {
        _declaration = declaration;
        _url = url;
    }

    private inline function get_url():Null<String> return _url;
    private inline function get_content():Dynamic return _content;
    private inline function get_declaration():Null<AssetTypeDeclaration> return _declaration;
    private inline function get_disposed():Bool return _disposed;

    public function dispose():Void {
        if (_disposed) return;
        _disposed = true;
        _content = null;
        _declaration = null;
        _url = null;
    }

    public function setUnknownContent(unknown:Dynamic):Void {
        if (Std.isOfType(unknown, String)) {
            _content = cast unknown;
            return;
        }
        if (Std.isOfType(unknown, ByteArrayData)) {
            var data:ByteArray = cast unknown;
            _content = data.readUTFBytes(data.length);
            return;
        }
        if (Std.isOfType(unknown, Class)) {
            var instance = Type.createInstance(cast unknown, []);
            if (!Std.isOfType(instance, ByteArrayData)) {
                throw new haxe.Exception("Embedded TextAsset class did not create a ByteArray");
            }
            var data:ByteArray = cast instance;
            _content = data.readUTFBytes(data.length);
            return;
        }
        if (Std.isOfType(unknown, TextAsset)) {
            _content = (cast unknown : TextAsset)._content;
            return;
        }
        _content = unknown == null ? "" : Std.string(unknown);
    }

    public function setFromOtherAsset(asset:IAsset):Void {
        if (!Std.isOfType(asset, TextAsset)) {
            throw new haxe.Exception("Provided asset is not of type TextAsset!");
        }
        _content = (cast asset : TextAsset)._content;
    }

    public function setParamsDesc(xml:XMLList):Void {}
}
