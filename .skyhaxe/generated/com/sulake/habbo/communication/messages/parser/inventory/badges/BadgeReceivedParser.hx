package com.sulake.habbo.communication.messages.parser.inventory.badges
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class BadgeReceivedParser implements IMessageParser
    {
        var _badgeId:Int = 0;
        var _badgeCode:String;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._badgeId = k.readInteger();
            this._badgeCode = k.readString();
            return true;
        }

        public var badgeId(get,never):Int;
public function  get_badgeId():Int
        {
            return this._badgeId;
        }

        public var badgeCode(get,never):String;
public function  get_badgeCode():String
        {
            return this._badgeCode;
        }

	public function new() {}
    }

