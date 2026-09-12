package com.sulake.habbo.communication.messages.parser.gifts
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class PhoneCollectionStateParser implements IMessageParser 
    {
        var _phoneStatusCode:Int = 0;
        var _collectionStatusCode:Int = 0;
        var _millisecondsToAllowProcessReset:Int = 0;


        public var phoneStatusCode(get,never):Int;
public function  get_phoneStatusCode():Int
        {
            return this._phoneStatusCode;
        }

        public var collectionStatusCode(get,never):Int;
public function  get_collectionStatusCode():Int
        {
            return this._collectionStatusCode;
        }

        public var millisecondsToAllowProcessReset(get,never):Int;
public function  get_millisecondsToAllowProcessReset():Int
        {
            return this._millisecondsToAllowProcessReset;
        }

        public function flush():Bool
        {
            this._phoneStatusCode = -1;
            this._millisecondsToAllowProcessReset = -1;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._phoneStatusCode = k.readInteger();
            this._collectionStatusCode = k.readInteger();
            this._millisecondsToAllowProcessReset = k.readInteger();
            return true;
        }

	public function new() {}
    }

