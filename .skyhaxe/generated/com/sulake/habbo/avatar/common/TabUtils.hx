package com.sulake.habbo.avatar.common
;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;

     class TabUtils 
    {


        public static function setElementImage(k:IStaticBitmapWrapperWindow, _arg_2:Bool)
        {
            var _local_3= ASCompat.stringReplace(k.assetUri, "_on", "");
            k.assetUri = (_arg_2 ? _local_3 : (_local_3 + "_on"));
        }

	public function new() {}
    }

