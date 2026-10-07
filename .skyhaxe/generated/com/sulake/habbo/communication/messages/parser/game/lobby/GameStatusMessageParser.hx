package com.sulake.habbo.communication.messages.parser.game.lobby
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class GameStatusMessageParser implements IMessageParser 
    {
        static inline final OK= 0;
        static inline final MAINTENANCE= 1;

        var _gameTypeId:Int = 0;
        var _status:Int = 0;


        public var gameTypeId(get,never):Int;
public function  get_gameTypeId():Int
        {
            return this._gameTypeId;
        }

        public var isOk(get,never):Bool;
public function  get_isOk():Bool
        {
            return this._status == OK;
        }

        public var isInMaintenance(get,never):Bool;
public function  get_isInMaintenance():Bool
        {
            return this._status == MAINTENANCE;
        }

        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._gameTypeId = k.readInteger();
            this._status = k.readInteger();
            return true;
        }

	public function new() {}
    }

