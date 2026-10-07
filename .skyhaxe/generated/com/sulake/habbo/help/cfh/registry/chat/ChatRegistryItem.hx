package com.sulake.habbo.help.cfh.registry.chat
;
     class ChatRegistryItem 
    {
        var _userId:Int = 0;
        var _userName:String = "";
        var _text:String = "";
        var _roomId:Int = 0;
        var _roomName:String = "";
        var _selected:Bool = false;
        var _index:UInt = 0;
        var _chatTime:Date;

        public function new(k:UInt, _arg_2:Int, _arg_3:String, _arg_4:Int, _arg_5:String, _arg_6:String)
        {
            this._index = k;
            this._roomId = _arg_2;
            this._roomName = _arg_3;
            this._userId = _arg_4;
            this._userName = _arg_5;
            this._text = _arg_6;
            this._selected = false;
            this._chatTime = Date.now();
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

        public var text(get,never):String;
public function  get_text():String
        {
            return this._text;
        }

        public var roomId(get,never):Int;
public function  get_roomId():Int
        {
            return this._roomId;
        }

        public var roomName(get,never):String;
public function  get_roomName():String
        {
            return this._roomName;
        }

        
        public var selected(get,set):Bool;
public function  get_selected():Bool
        {
            return this._selected;
        }
public function  set_selected(selected:Bool):Bool        {
            return this._selected = selected;
        }

        public var index(get,never):Int;
public function  get_index():Int
        {
            return ASCompat.toInt(this._index);
        }

        public var chatTime(get,never):Date;
public function  get_chatTime():Date
        {
            return this._chatTime;
        }
    }

