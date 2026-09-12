package com.sulake.core.assets
;
    import com.sulake.core.runtime.IDisposable;

     interface IResourceManager extends IDisposable 
    {
        function createAsset(_arg_1:String, _arg_2:Class<Dynamic>, _arg_3:ASObject):IAsset;
        function retrieveAsset(_arg_1:String, _arg_2:IAssetReceiver):Void;
        function isSameAsset(_arg_1:String, _arg_2:String):Bool;
        function removeAsset(_arg_1:String):Void;
    }

