package com.sulake.habbo.communication.messages.parser.roomsettings
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class FlatControllerRemovedMessageParser implements IMessageParser
    {
        var _flatId:Int = 0;
        var _userId:Int = 0;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._flatId = k.readInteger();
            this._userId = k.readInteger();
            return true;
        }

        public var flatId(get,never):Int;
public function  get_flatId():Int
        {
            return this._flatId;
        }

        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return this._userId;
        }

	public function new() {}
    }

