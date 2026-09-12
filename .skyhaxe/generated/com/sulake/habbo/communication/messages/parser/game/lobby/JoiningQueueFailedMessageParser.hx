package com.sulake.habbo.communication.messages.parser.game.lobby
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class JoiningQueueFailedMessageParser implements IMessageParser 
    {
        public static inline final DUPLICATE_MACHINEID= 1;

        var _gameTypeId:Int = 0;
        var _reason:Int = 0;


        public var gameTypeId(get,never):Int;
public function  get_gameTypeId():Int
        {
            return this._gameTypeId;
        }

        public var reason(get,never):Int;
public function  get_reason():Int
        {
            return this._reason;
        }

        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._gameTypeId = k.readInteger();
            this._reason = k.readInteger();
            return true;
        }

	public function new() {}
    }

