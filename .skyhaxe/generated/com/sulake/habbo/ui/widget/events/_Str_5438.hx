package com.sulake.habbo.ui.widget.events
;
     class _Str_5438 extends RoomWidgetUpdateEvent 
    {
        public static inline final RWWGUE_WELCOME_GIFT_WIDGET_STATUS= "rwwgue_welcome_gift_widget_status";

        var _email:String;
        var _isVerified:Bool = false;
        var _Str_5694:Bool = false;
        var _furniId:Int = 0;
        var _Str_10840:Bool = false;

        public function new(k:Bool=false, _arg_2:Bool=false)
        {
            super(RWWGUE_WELCOME_GIFT_WIDGET_STATUS, k, _arg_2);
        }

        
        public var email(get,set):String;
public function  get_email():String
        {
            return this._email;
        }

        
        public var isVerified(get,set):Bool;
public function  get_isVerified():Bool
        {
            return this._isVerified;
        }

        
        public var _Str_17916(get,set):Bool;
public function  get__Str_17916():Bool
        {
            return this._Str_5694;
        }

        
        public var furniId(get,set):Int;
public function  get_furniId():Int
        {
            return this._furniId;
        }

        
        public var _Str_10512(get,set):Bool;
public function  get__Str_10512():Bool
        {
            return this._Str_10840;
        }
public function  set_email(k:String):String        {
            return this._email = k;
        }
public function  set_isVerified(k:Bool):Bool        {
            return this._isVerified = k;
        }
public function  set__Str_17916(k:Bool):Bool        {
            return this._Str_5694 = k;
        }
public function  set_furniId(k:Int):Int        {
            return this._furniId = k;
        }
public function  set__Str_10512(k:Bool):Bool        {
            return this._Str_10840 = k;
        }
    }

