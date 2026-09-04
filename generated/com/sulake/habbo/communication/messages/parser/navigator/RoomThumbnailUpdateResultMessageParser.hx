package com.sulake.habbo.communication.messages.parser.navigator
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class RoomThumbnailUpdateResultMessageParser implements IMessageParser
    {
        var _flatId:Int = 0;
        var _resultCode:Int = 0;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._flatId = k.readInteger();
            this._resultCode = k.readInteger();
            return true;
        }

        public var flatId(get,never):Int;
function  get_flatId():Int
        {
            return this._flatId;
        }

        public var resultCode(get,never):Int;
function  get_resultCode():Int
        {
            return this._resultCode;
        }

	public function new() {}
    }

