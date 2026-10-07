package com.sulake.habbo.communication.messages.parser.game.lobby
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class GameInviteMessageParser implements IMessageParser 
    {
        var _gameTypeId:Int = 0;
        var _inviterId:Int = 0;


        public var gameTypeId(get,never):Int;
public function  get_gameTypeId():Int
        {
            return this._gameTypeId;
        }

        public var inviterId(get,never):Int;
public function  get_inviterId():Int
        {
            return this._inviterId;
        }

        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._gameTypeId = k.readInteger();
            this._inviterId = k.readInteger();
            return true;
        }

	public function new() {}
    }

