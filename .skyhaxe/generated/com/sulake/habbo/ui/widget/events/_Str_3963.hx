package com.sulake.habbo.ui.widget.events
;
     class _Str_3963 extends RoomWidgetUpdateEvent 
    {
        public static inline final RWSUE_SETTINGS= "RWSUE_SETTINGS";

        var _Str_9898:Float = Math.NaN;
        var _Str_2909:Float = Math.NaN;
        var _Str_2933:Float = Math.NaN;

        public function new(k:String, _arg_2:Float, _arg_3:Float, _arg_4:Float, _arg_5:Bool=false, _arg_6:Bool=false)
        {
            super(k, _arg_5, _arg_6);
            this._Str_9898 = _arg_4;
            this._Str_2909 = _arg_3;
            this._Str_2933 = _arg_2;
        }

        public var _Str_16610(get,never):Float;
public function  get__Str_16610():Float
        {
            return this._Str_9898;
        }

        public var furniVolume(get,never):Float;
public function  get_furniVolume():Float
        {
            return this._Str_2909;
        }

        public var traxVolume(get,never):Float;
public function  get_traxVolume():Float
        {
            return this._Str_2933;
        }
    }

