package com.sulake.core.assets;

import com.sulake.core.runtime.IDisposable;
import com.sulake.core.utils.xml.XMLList;

interface IAsset extends IDisposable {
    public var url(get, never):Null<String>;
    public var content(get, never):Dynamic;
    public var declaration(get, never):Null<AssetTypeDeclaration>;

    public function setUnknownContent(unknown:Dynamic):Void;
    public function setFromOtherAsset(asset:IAsset):Void;
    public function setParamsDesc(xml:XMLList):Void;
}
