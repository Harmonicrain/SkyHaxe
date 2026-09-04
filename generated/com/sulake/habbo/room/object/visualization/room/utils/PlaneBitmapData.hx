package com.sulake.habbo.room.object.visualization.room.utils
;
    import flash.display.BitmapData;

     class PlaneBitmapData 
    {
        var _bitmap:BitmapData = null;
        var _timeStamp:Int = 0;

        public function new(k:BitmapData, _arg_2:Int)
        {
            this._bitmap = k;
            this._timeStamp = _arg_2;
        }

        public var bitmap(get,never):BitmapData;
function  get_bitmap():BitmapData
        {
            return this._bitmap;
        }

        public var timeStamp(get,never):Int;
function  get_timeStamp():Int
        {
            return this._timeStamp;
        }

        public function dispose()
        {
            this._bitmap = null;
        }
    }

