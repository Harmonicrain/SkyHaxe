package com.sulake.habbo.communication.messages.parser.advertisement
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class RoomAdErrorMessageParser implements IMessageParser 
    {
        var _errorCode:Int = 0;
        var _filteredText:String;


        public var errorCode(get,never):Int;
function  get_errorCode():Int
        {
            return this._errorCode;
        }

        public var filteredText(get,never):String;
function  get_filteredText():String
        {
            return this._filteredText;
        }

        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._errorCode = k.readInteger();
            this._filteredText = k.readString();
            return true;
        }

	public function new() {}
    }

