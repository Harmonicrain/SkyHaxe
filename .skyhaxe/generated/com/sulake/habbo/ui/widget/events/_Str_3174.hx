package com.sulake.habbo.ui.widget.events
;
    import flash.geom.Rectangle;
    import flash.geom.Point;

     class _Str_3174 extends RoomWidgetUpdateEvent 
    {
        public static inline final RWULUE_USER_LOCATION_UPDATE= "RWULUE_USER_LOCATION_UPDATE";

        var _userId:Int = 0;
        var _rectangle:Rectangle;
        var _Str_20775:Point;

        public function new(k:Int, _arg_2:Rectangle, _arg_3:Point, _arg_4:Bool=false, _arg_5:Bool=false)
        {
            super(RWULUE_USER_LOCATION_UPDATE, _arg_4, _arg_5);
            this._userId = k;
            this._rectangle = _arg_2;
            this._Str_20775 = _arg_3;
        }

        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return this._userId;
        }

        public var rectangle(get,never):Rectangle;
public function  get_rectangle():Rectangle
        {
            return this._rectangle;
        }

        public var _Str_9337(get,never):Point;
public function  get__Str_9337():Point
        {
            return this._Str_20775;
        }
    }

