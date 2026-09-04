package com.sulake.habbo.communication.messages.parser.room.furniture
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class OpenPetPackageResultMessageParser implements IMessageParser
    {
        var _objectId:Int = 0;
        var _nameValidationStatus:Int = 0;
        var _nameValidationInfo:String = null;


        public var objectId(get,never):Int;
function  get_objectId():Int
        {
            return this._objectId;
        }

        public var nameValidationStatus(get,never):Int;
function  get_nameValidationStatus():Int
        {
            return this._nameValidationStatus;
        }

        public var nameValidationInfo(get,never):String;
function  get_nameValidationInfo():String
        {
            return this._nameValidationInfo;
        }

        public function flush():Bool
        {
            this._objectId = 0;
            this._nameValidationStatus = 0;
            this._nameValidationInfo = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            if (k == null)
            {
                return false;
            }
            this._objectId = k.readInteger();
            this._nameValidationStatus = k.readInteger();
            this._nameValidationInfo = k.readString();
            return true;
        }

	public function new() {}
    }

