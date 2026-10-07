package com.sulake.habbo.communication.messages.incoming.navigator
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.navigator.ConvertedRoomIdMessageParser;

     class ConvertedRoomIdEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, ConvertedRoomIdMessageParser);
        }

        public var _Str_17914(get,never):String;
public function  get__Str_17914():String
        {
            return Std.downcast(this._parser , ConvertedRoomIdMessageParser)._Str_17914;
        }

        public var _Str_12434(get,never):Int;
public function  get__Str_12434():Int
        {
            return Std.downcast(this._parser , ConvertedRoomIdMessageParser)._Str_12434;
        }

        public function getParser():ConvertedRoomIdMessageParser
        {
            return Std.downcast(_parser , ConvertedRoomIdMessageParser);
        }
    }

