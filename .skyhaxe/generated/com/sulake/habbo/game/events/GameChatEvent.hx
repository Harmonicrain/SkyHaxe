package com.sulake.habbo.game.events
;
    import flash.events.Event;

     class GameChatEvent extends Event 
    {
        public static inline final GCE_GAME_CHAT= "gce_game_chat";

        var _userId:Int = 0;
        var _message:String;
        var _locX:Int = 0;
        var _color:UInt = 0;
        var _figure:String;
        var _gender:String;
        var _name:String;
        var _notify:Bool = false;

        public function new(k:String, _arg_2:Int, _arg_3:String, _arg_4:Int, _arg_5:UInt, _arg_6:String, _arg_7:String, _arg_8:String, _arg_9:Bool, _arg_10:Bool=false, _arg_11:Bool=false)
        {
            super(k, _arg_10, _arg_11);
            this._userId = _arg_2;
            this._message = _arg_3;
            this._locX = _arg_4;
            this._color = _arg_5;
            this._figure = _arg_6;
            this._gender = _arg_7;
            this._name = _arg_8;
            this._notify = _arg_9;
        }

        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return this._userId;
        }

        public var message(get,never):String;
public function  get_message():String
        {
            return this._message;
        }

        public var _Str_19907(get,never):Int;
public function  get__Str_19907():Int
        {
            return this._locX;
        }

        public var color(get,never):UInt;
public function  get_color():UInt
        {
            return this._color;
        }

        public var figure(get,never):String;
public function  get_figure():String
        {
            return this._figure;
        }

        public var gender(get,never):String;
public function  get_gender():String
        {
            return this._gender;
        }

        public var name(get,never):String;
public function  get_name():String
        {
            return this._name;
        }

        public var notify(get,never):Bool;
public function  get_notify():Bool
        {
            return this._notify;
        }
    }

