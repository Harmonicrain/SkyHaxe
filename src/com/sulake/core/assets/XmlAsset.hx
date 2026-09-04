package com.sulake.core.assets;

import com.sulake.core.utils.xml.XML;
import com.sulake.core.utils.xml.XMLList;
import openfl.utils.ByteArray;
import openfl.utils.ByteArray.ByteArrayData;

class XmlAsset implements ILazyAsset {
    public var url(get, never):Null<String>;
    public var content(get, never):Dynamic;
    public var declaration(get, never):Null<AssetTypeDeclaration>;
    public var disposed(get, never):Bool;

    private var _disposed = false;
    private var _unknown:Dynamic = null;
    private var _content:Null<XML> = null;
    private var _declaration:Null<AssetTypeDeclaration>;
    private var _url:Null<String>;

    public function new(declaration:AssetTypeDeclaration, ?url:String) {
        _declaration = declaration;
        _url = url;
    }

    private inline function get_url():Null<String> return _url;
    private function get_content():Dynamic {
        if (_content == null) prepareLazyContent();
        return _content;
    }
    private inline function get_declaration():Null<AssetTypeDeclaration> return _declaration;
    private inline function get_disposed():Bool return _disposed;

    public function dispose():Void {
        if (_disposed) return;
        _disposed = true;
        _content = null;
        _unknown = null;
        _declaration = null;
        _url = null;
    }

    public function setUnknownContent(unknown:Dynamic):Void {
        _content = null;
        _unknown = unknown;
    }

    public function prepareLazyContent():Void {
        if (Std.isOfType(_unknown, Class)) {
            var instance = Type.createInstance(cast _unknown, []);
            if (!Std.isOfType(instance, ByteArrayData)) {
                throw new haxe.Exception("Embedded XmlAsset class did not create a ByteArray");
            }
            _content = parseBytes(cast instance);
            return;
        }
        if (Std.isOfType(_unknown, ByteArrayData)) {
            _content = parseBytes(cast _unknown);
            return;
        }
        if (Std.isOfType(_unknown, String)) {
            _content = new XML(cast _unknown);
            return;
        }
        if (Std.isOfType(_unknown, XML)) {
            _content = cast _unknown;
            return;
        }
        if (Std.isOfType(_unknown, XmlAsset)) {
            _content = (cast _unknown : XmlAsset)._content;
        }
    }

    private static function parseBytes(data:ByteArray):XML {
        return new XML(data.readUTFBytes(data.length));
    }

    public function setFromOtherAsset(asset:IAsset):Void {
        if (!Std.isOfType(asset, XmlAsset)) {
            throw new haxe.Exception("Provided asset is not of type XmlAsset!");
        }
        _content = cast asset.content;
        _unknown = null;
    }

    public function setParamsDesc(xml:XMLList):Void {}

    public function toString():String {
        return 'XmlAsset _url:${Std.string(_url)} _content:${Std.string(_content)} _unknown:${Std.string(_unknown)}';
    }
}
