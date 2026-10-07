package com.sulake.habbo.ui.widget.events
;
    import flash.geom.Rectangle;
    import flash.geom.Point;

     class _Str_3040 extends RoomWidgetUpdateEvent 
    {
        public static inline final RWRVUE_ROOM_VIEW_SIZE_CHANGED= "RWRVUE_ROOM_VIEW_SIZE_CHANGED";
        public static inline final RWRVUE_ROOM_VIEW_SCALE_CHANGED= "RWRVUE_ROOM_VIEW_SCALE_CHANGED";
        public static inline final RWRVUE_ROOM_VIEW_POSITION_CHANGED= "RWRVUE_ROOM_VIEW_POSITION_CHANGED";

        var _Str_18063:Rectangle;
        var _Str_17715:Point;
        var _scale:Float = 0;

        public function new(k:String, _arg_2:Rectangle=null, _arg_3:Point=null, _arg_4:Float=0, _arg_5:Bool=false, _arg_6:Bool=false)
        {
            super(k, _arg_5, _arg_6);
            this._Str_18063 = _arg_2;
            this._Str_17715 = _arg_3;
            this._scale = _arg_4;
        }

        public var rect(get,never):Rectangle;
public function  get_rect():Rectangle
        {
            if (this._Str_18063 != null)
            {
                return this._Str_18063.clone();
            }
            return null;
        }

        public var _Str_17974(get,never):Point;
public function  get__Str_17974():Point
        {
            if (this._Str_17715 != null)
            {
                return this._Str_17715.clone();
            }
            return null;
        }

        public var scale(get,never):Float;
public function  get_scale():Float
        {
            return this._scale;
        }
    }

