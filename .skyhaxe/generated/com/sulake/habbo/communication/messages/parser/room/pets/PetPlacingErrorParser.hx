package com.sulake.habbo.communication.messages.parser.room.pets
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class PetPlacingErrorParser implements IMessageParser 
    {
        var _errorCode:Int = 0;


        public var errorCode(get,never):Int;
public function  get_errorCode():Int
        {
            return this._errorCode;
        }

        public function flush():Bool
        {
            this._errorCode = -1;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            if (k == null)
            {
                return false;
            }
            this._errorCode = k.readInteger();
            return true;
        }

	public function new() {}
    }

