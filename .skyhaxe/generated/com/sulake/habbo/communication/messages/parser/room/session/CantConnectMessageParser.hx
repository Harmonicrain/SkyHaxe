package com.sulake.habbo.communication.messages.parser.room.session
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class CantConnectMessageParser implements IMessageParser
    {
        public static inline final REASON_FULL= 1;
        public static inline final REASON_CLOSED= 2;
        public static inline final REASON_QUEUE_ERROR= 3;
        public static inline final REASON_BANNED= 4;

        var _reason:Int = 0;
        var _parameter:String = "";


        public function flush():Bool
        {
            this._reason = 0;
            this._parameter = "";
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._reason = k.readInteger();
            if (this._reason == 3)
            {
                this._parameter = k.readString();
            }
            else
            {
                this._parameter = "";
            }
            return true;
        }

        public var reason(get,never):Int;
public function  get_reason():Int
        {
            return this._reason;
        }

        public var parameter(get,never):String;
public function  get_parameter():String
        {
            return this._parameter;
        }

	public function new() {}
    }

