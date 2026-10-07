package com.sulake.core.assets
;
    import com.sulake.core.runtime.IDisposable;

     interface IAsset extends IDisposable 
    {
        var url(get,never):String;
        var content(get,never):ASObject;
        var declaration(get,never):AssetTypeDeclaration;
        function setUnknownContent(unknown:ASObject):Void;
        function setFromOtherAsset(asset:IAsset):Void;
        function setParamsDesc(xml:com.sulake.core.utils.xml.XMLList):Void;
    }

