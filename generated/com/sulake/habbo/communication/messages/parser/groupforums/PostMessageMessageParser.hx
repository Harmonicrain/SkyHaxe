package com.sulake.habbo.communication.messages.parser.groupforums
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class PostMessageMessageParser implements IMessageParser
    {
        var _groupId:Int = 0;
        var _threadId:Int = 0;
        var _message:MessageData;


        public var groupId(get,never):Int;
function  get_groupId():Int
        {
            return this._groupId;
        }

        public var threadId(get,never):Int;
function  get_threadId():Int
        {
            return this._threadId;
        }

        public var message(get,never):MessageData;
function  get_message():MessageData
        {
            return this._message;
        }

        public function flush():Bool
        {
            this._groupId = -1;
            this._threadId = -1;
            this._message = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._groupId = k.readInteger();
            this._threadId = k.readInteger();
            this._message = MessageData._Str_4933(k);
            return true;
        }

	public function new() {}
    }

