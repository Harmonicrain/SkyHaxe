package com.sulake.habbo.communication.messages.parser.friendlist
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class NewConsoleMessageMessageParser implements IMessageParser
    {
        var _senderId:Int = 0;
        var _messageText:String;
        var _Str_12466:Int = 0;
        var _extraData:String;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._senderId = k.readInteger();
            this._messageText = k.readString();
            this._Str_12466 = k.readInteger();
            if (k.bytesAvailable != 0)
            {
                this._extraData = k.readString();
            }
            return true;
        }

        public var senderId(get,never):Int;
function  get_senderId():Int
        {
            return this._senderId;
        }

        public var messageText(get,never):String;
function  get_messageText():String
        {
            return this._messageText;
        }

        public var _Str_17201(get,never):Int;
function  get__Str_17201():Int
        {
            return this._Str_12466;
        }

        public var extraData(get,never):String;
function  get_extraData():String
        {
            return this._extraData;
        }

	public function new() {}
    }

