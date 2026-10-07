package com.sulake.habbo.avatar.structure
;
    import com.sulake.core.runtime.events.EventDispatcherWrapper;
    import flash.net.URLRequest;
    import com.sulake.core.assets.AssetLoaderStruct;
    import com.sulake.core.assets.loaders.AssetLoaderEvent;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.Core;
    import flash.events.Event;
    import com.sulake.habbo.utils.HabboWebTools;

     class AvatarStructureDownload extends EventDispatcherWrapper 
    {
        public static inline final AVATAR_STRUCTURE_DONE= "AVATAR_STRUCTURE_DONE";

        var _dataReceiver:IFigureSetData;

        public function new(k:IAssetLibrary, _arg_2:String, _arg_3:IFigureSetData)
        {
            super();
            this._dataReceiver = _arg_3;
            if (k.hasAsset(_arg_2))
            {
                Logger.log([("[AvatarStructureDownload] reload data for url: " + _arg_2)]);
            }
            var _local_4= new URLRequest(_arg_2);
            var _local_5= k.loadAssetFromFile(_arg_2, _local_4, "text/plain");
            _local_5.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTCOMPLETE, this._Str_1943);
            _local_5.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTERROR, this.onDataComplete);
        }

        function _Str_1943(event:Event)
        {
            var data:String = null;
            var dataSet:com.sulake.core.utils.xml.XML = null;
            var loaderStruct= ASCompat.dynamicAs(event.target , AssetLoaderStruct);
            if (((loaderStruct == null) || (loaderStruct.assetLoader == null)))
            {
                return;
            }
            try
            {
                data = ASCompat.asString(loaderStruct.assetLoader.content );
                if (((data == null) || (data.length == 0)))
                {
                    Core.error((((("Could not load avatar structure, got empty data from URL " + loaderStruct.assetLoader.url) + " data length = ") + Std.string(data.length)) + "."), false, Core.ERROR_CATEGORY_DOWNLOAD_CONFIGURATION);
                }
                dataSet = new com.sulake.core.utils.xml.XML(data);
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                Logger.log([("[AvatarStructureDownload] Error: " + e.message)]);
                return;
            }
 }            if (dataSet == null)
            {
                Logger.log([(("[AvatarStructureDownload] XML error: " + loaderStruct) + " not valid XML")]);
                return;
            }
            this._dataReceiver._Str_1017(dataSet);
            dispatchEvent(new Event(AvatarStructureDownload.AVATAR_STRUCTURE_DONE));
        }

        function onDataComplete(k:Event)
        {
            var _local_2= ASCompat.dynamicAs(k.target , AssetLoaderStruct);
            var _local_3= "";
            if (((!(_local_2 == null)) && (!(_local_2.assetLoader == null))))
            {
                _local_3 = _local_2.assetLoader.url;
            }
            HabboWebTools.logEventLog(("figurepartlist download error " + _local_3));
            Core.error(("Could not load avatar structure. Failed to get data from URL " + _local_3), true, Core.ERROR_CATEGORY_DOWNLOAD_CONFIGURATION);
        }
    }

