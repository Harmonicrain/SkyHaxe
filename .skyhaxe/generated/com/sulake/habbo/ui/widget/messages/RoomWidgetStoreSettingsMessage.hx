package com.sulake.habbo.ui.widget.messages
;
     class RoomWidgetStoreSettingsMessage extends RoomWidgetMessage 
    {
        public static inline final RWSSM_STORE_SETTINGS= "RWSSM_STORE_SETTINGS";
        public static inline final RWSSM_STORE_SOUND= "RWSSM_STORE_SOUND";
        public static inline final RWSSM_PREVIEW_SOUND= "RWSSM_PREVIEW_SOUND";
        public static inline final RWSSM_STORE_CHAT= "RWSSM_STORE_CHAT";

        var _traxVolume:Float = Math.NaN;
        var _furniVolume:Float = Math.NaN;
        var _genericVolume:Float = Math.NaN;
        var _forceOldChat:Bool = false;

        public function new(k:String)
        {
            super(k);
        }

        
        public var traxVolume(get,set):Float;
public function  get_traxVolume():Float
        {
            return this._traxVolume;
        }
public function  set_traxVolume(k:Float):Float        {
            return this._traxVolume = k;
        }

        
        public var furniVolume(get,set):Float;
public function  get_furniVolume():Float
        {
            return this._furniVolume;
        }
public function  set_furniVolume(k:Float):Float        {
            return this._furniVolume = k;
        }

        
        public var genericVolume(get,set):Float;
public function  get_genericVolume():Float
        {
            return this._genericVolume;
        }
public function  set_genericVolume(k:Float):Float        {
            return this._genericVolume = k;
        }

        
        public var _Str_12967(get,set):Bool;
public function  get__Str_12967():Bool
        {
            return this._forceOldChat;
        }
public function  set__Str_12967(k:Bool):Bool        {
            return this._forceOldChat = k;
        }
    }

