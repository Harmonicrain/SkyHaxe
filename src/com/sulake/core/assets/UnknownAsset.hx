package com.sulake.core.assets;

import com.sulake.core.utils.ClassUtils;
import com.sulake.core.utils.xml.XMLList;

class UnknownAsset implements IAsset {
    public var url(get, never):Null<String>;
    public var content(get, never):Dynamic;
    public var declaration(get, never):Null<AssetTypeDeclaration>;
    public var disposed(get, never):Bool;

    private var _disposed = false;
    private var _content:Dynamic = null;
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
        _content = unknown;
    }

    public function setFromOtherAsset(asset:IAsset):Void {
        _content = asset.content;
    }

    public function setParamsDesc(xml:XMLList):Void {}

    public function toString():String {
        return '${ClassUtils.getQualifiedClassName(this)}: ${Std.string(_content)}';
    }
}
