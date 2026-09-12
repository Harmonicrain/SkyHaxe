package com.sulake.habbo.ui.widget.camera
;
    import flash.display.BitmapData;

     class CameraSlotData 
    {
        public var image:BitmapData;
        var _date:Date;
        public var isEmpty:Bool = false;


        public function _Str_16123(k:Date)
        {
            this._date = k;
        }

        public var _Str_26241(get,never):String;
public function  get__Str_26241():String
        {
            var k= ((((((((Std.string(this._date.getDate()) + "/") + Std.string(this._date.getMonth() + 1)) + "/") + Std.string(this._date.getFullYear())) + " ") + Std.string(this._date.getHours())) + ":") + this._Str_23907(Std.int(this._date.getMinutes())));
            return k;
        }

        function _Str_23907(k:Int):String
        {
            var _local_2= Std.string(k);
            if (_local_2.length == 1)
            {
                _local_2 = ("0" + _local_2);
            }
            return _local_2;
        }

        public function _Str_26320():Int
        {
            return Std.int(this._date.getTime());
        }
public function new(){}
    }

