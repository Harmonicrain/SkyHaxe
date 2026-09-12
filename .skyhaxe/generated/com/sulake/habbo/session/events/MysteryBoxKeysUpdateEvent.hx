package com.sulake.habbo.session.events
;
    import flash.events.Event;

     class MysteryBoxKeysUpdateEvent extends Event 
    {
        public static inline final MBKE_UPDATE= "mbke_update";

        var _boxColor:String;
        var _keyColor:String;

        public function new(k:String, _arg_2:String, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            super(MBKE_UPDATE, _arg_3, _arg_4);
            this._boxColor = k;
            this._keyColor = _arg_2;
        }

        public var boxColor(get,never):String;
public function  get_boxColor():String
        {
            return this._boxColor;
        }

        public var keyColor(get,never):String;
public function  get_keyColor():String
        {
            return this._keyColor;
        }
    }

