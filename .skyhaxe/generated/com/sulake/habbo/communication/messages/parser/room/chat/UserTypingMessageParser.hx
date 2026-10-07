package com.sulake.habbo.communication.messages.parser.room.chat
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class UserTypingMessageParser implements IMessageParser 
    {
        var _userId:Int = 0;
        var _isTyping:Bool = false;


        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return this._userId;
        }

        public var isTyping(get,never):Bool;
public function  get_isTyping():Bool
        {
            return this._isTyping;
        }

        public function flush():Bool
        {
            this._userId = 0;
            this._isTyping = false;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            if (k == null)
            {
                return false;
            }
            this._userId = k.readInteger();
            this._isTyping = (k.readInteger() == 1);
            return true;
        }

	public function new() {}
    }

