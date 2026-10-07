package com.sulake.habbo.communication.messages.parser.game.lobby
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class AchievementResolutionCompletedMessageParser implements IMessageParser 
    {
        var _stuffCode:String;
        var _badgeCode:String;


        public function flush():Bool
        {
            this._stuffCode = "";
            this._badgeCode = "";
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._stuffCode = k.readString();
            this._badgeCode = k.readString();
            return true;
        }

        public var stuffCode(get,never):String;
public function  get_stuffCode():String
        {
            return this._stuffCode;
        }

        public var badgeCode(get,never):String;
public function  get_badgeCode():String
        {
            return this._badgeCode;
        }

	public function new() {}
    }

