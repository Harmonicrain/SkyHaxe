package com.sulake.habbo.quest
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.assets.IAsset;
    import com.sulake.core.runtime.Component;
    import com.sulake.core.assets.BitmapDataAsset;
    import flash.display.BitmapData;

     class TwinkleImages implements IDisposable 
    {
        static inline final _Str_17361= 6;

        var _questEngine:HabboQuestEngine;

        public function new(k:HabboQuestEngine)
        {
            this._questEngine = k;
            var _local_2= 1;
            while (_local_2 <= _Str_17361)
            {
                this._questEngine.windowManager.resourceManager.retrieveAsset(_Str_15489(_local_2), null);
                _local_2++;
            }
        }

        static function _Str_15489(k:Int):String
        {
            return ("${image.library.questing.url}ach_twinkle" + Std.string(k)) + ".png";
        }


        public function getImage(k:Int):BitmapData
        {
            var _local_2:IAsset = null;
            if (this._questEngine != null)
            {
                _local_2 = cast(this._questEngine.windowManager, Component).assets.getAssetByName(this._questEngine.interpolate(_Str_15489(k)));
                if (((!(_local_2 == null)) && Std.is(_local_2 , BitmapDataAsset)))
                {
                    return ASCompat.dynamicAs(_local_2.content , BitmapData);
                }
            }
            return null;
        }

        public function dispose()
        {
            this._questEngine = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return !(this._questEngine == null);
        }
    }

