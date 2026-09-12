package com.sulake.habbo.communication.messages.parser.moderation
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ModeratorActionResultMessageParser implements IMessageParser
    {
        var _userId:Int = 0;
        var _success:Bool = false;


        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return this._userId;
        }

        public var success(get,never):Bool;
public function  get_success():Bool
        {
            return this._success;
        }

        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._userId = k.readInteger();
            this._success = k.readBoolean();
            return true;
        }

	public function new() {}
    }

