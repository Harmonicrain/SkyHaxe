package com.sulake.habbo.communication.messages.parser.users
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class PetSupplementedNotificationParser implements IMessageParser
    {
        var _petId:Int = 0;
        var _userId:Int = 0;
        var _supplementType:Int = 0;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._petId = k.readInteger();
            this._userId = k.readInteger();
            this._supplementType = k.readInteger();
            return true;
        }

        public var petId(get,never):Int;
public function  get_petId():Int
        {
            return this._petId;
        }

        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return this._userId;
        }

        public var supplementType(get,never):Int;
public function  get_supplementType():Int
        {
            return this._supplementType;
        }

	public function new() {}
    }

