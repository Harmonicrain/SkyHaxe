package com.sulake.room.renderer.cache
;
    import com.sulake.room.renderer.utils.ExtendedBitmapData;

     class BitmapDataCacheItem 
    {
        var _bitmapData:ExtendedBitmapData = null;
        var _name:String = "";
        var _memUsage:Int = 0;

        public function new(k:ExtendedBitmapData, _arg_2:String)
        {
            this._bitmapData = k;
            this._name = _arg_2;
            if (k != null)
            {
                k._Str_9215();
                this._memUsage = ((this._bitmapData.width * this._bitmapData.height) * 4);
            }
        }

        
        public var bitmapData(get,set):ExtendedBitmapData;
public function  get_bitmapData():ExtendedBitmapData
        {
            return this._bitmapData;
        }

        public var _Str_16106(get,never):Int;
public function  get__Str_16106():Int
        {
            return this._memUsage;
        }

        public var useCount(get,never):Int;
public function  get_useCount():Int
        {
            if (this._bitmapData == null)
            {
                return 0;
            }
            return this._bitmapData.referenceCount;
        }

        public var name(get,never):String;
public function  get_name():String
        {
            return this._name;
        }
public function  set_bitmapData(k:ExtendedBitmapData):ExtendedBitmapData        {
            if (this._bitmapData != null)
            {
                this._bitmapData.dispose();
            }
            this._bitmapData = k;
            if (this._bitmapData != null)
            {
                this._bitmapData._Str_9215();
                this._memUsage = ((this._bitmapData.width * this._bitmapData.height) * 4);
            }
            else
            {
                this._memUsage = 0;
            }
return k;
        }

        public function dispose()
        {
            if (this._bitmapData != null)
            {
                this._bitmapData.dispose();
                this._bitmapData = null;
            }
            this._memUsage = 0;
        }
    }

