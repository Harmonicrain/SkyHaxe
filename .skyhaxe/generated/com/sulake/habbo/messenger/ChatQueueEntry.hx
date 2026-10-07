package com.sulake.habbo.messenger
;
     class ChatQueueEntry 
    {
        var _conversationId:Int = 0;
        var _chatEntry:ChatEntry;
        var _updateIndicator:Bool = false;

        public function new(k:Int, _arg_2:ChatEntry, _arg_3:Bool)
        {
            this._conversationId = k;
            this._chatEntry = _arg_2;
            this._updateIndicator = _arg_3;
        }

        public var _Str_20358(get,never):Int;
public function  get__Str_20358():Int
        {
            return this._conversationId;
        }

        public var _Str_24552(get,never):ChatEntry;
public function  get__Str_24552():ChatEntry
        {
            return this._chatEntry;
        }

        public var _Str_24452(get,never):Bool;
public function  get__Str_24452():Bool
        {
            return this._updateIndicator;
        }
    }

