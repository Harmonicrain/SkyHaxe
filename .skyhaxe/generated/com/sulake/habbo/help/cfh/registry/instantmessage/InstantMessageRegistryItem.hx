package com.sulake.habbo.help.cfh.registry.instantmessage
;
     class InstantMessageRegistryItem 
    {
        var _index:Int = 0;
        var _userId:Int = 0;
        var _username:String = "";
        var _chatText:String = "";
        var _chatTime:Date;
        var _selected:Bool = false;

        public function new(k:Int, _arg_2:Int, _arg_3:String, _arg_4:String)
        {
            this._index = k;
            this._userId = _arg_2;
            this._username = _arg_3;
            this._chatText = _arg_4;
            this._selected = false;
            this._chatTime = Date.now();
        }

        public var index(get,never):Int;
public function  get_index():Int
        {
            return this._index;
        }

        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return this._userId;
        }

        public var userName(get,never):String;
public function  get_userName():String
        {
            return this._username;
        }

        public var text(get,never):String;
public function  get_text():String
        {
            return this._chatText;
        }

        
        public var selected(get,set):Bool;
public function  get_selected():Bool
        {
            return this._selected;
        }
public function  set_selected(selected:Bool):Bool        {
            return this._selected = selected;
        }

        public var chatTime(get,never):Date;
public function  get_chatTime():Date
        {
            return this._chatTime;
        }
    }

