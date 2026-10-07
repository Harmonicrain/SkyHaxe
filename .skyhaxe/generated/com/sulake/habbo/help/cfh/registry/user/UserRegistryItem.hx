package com.sulake.habbo.help.cfh.registry.user
;
     class UserRegistryItem 
    {
        var _userId:Int = 0;
        var _userName:String = "";
        var _roomName:String = "";
        var _figure:String = "";
        var _roomId:Int = 0;

        public function new(k:Int, _arg_2:String, _arg_3:String, _arg_4:Int, _arg_5:String="")
        {
            this._userId = k;
            this._userName = _arg_2;
            this._roomId = _arg_4;
            this._roomName = _arg_5;
            this._figure = _arg_3;
        }

        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return this._userId;
        }

        public var userName(get,never):String;
public function  get_userName():String
        {
            return this._userName;
        }

        
        public var roomName(get,set):String;
public function  get_roomName():String
        {
            return this._roomName;
        }
public function  set_roomName(k:String):String        {
            return this._roomName = k;
        }

        public var figure(get,never):String;
public function  get_figure():String
        {
            return this._figure;
        }

        public var roomId(get,never):Int;
public function  get_roomId():Int
        {
            return this._roomId;
        }
    }

