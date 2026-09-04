package com.sulake.habbo.communication.messages.parser.handshake
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class DisconnectReasonParser implements IMessageParser
    {
        var _reason:Int = 0;

        public function new()
        {
            this._reason = -1;
        }

        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            if (k.bytesAvailable != 0)
            {
                this._reason = k.readInteger();
            }
            return true;
        }

        public var reason(get,never):Int;
function  get_reason():Int
        {
            return this._reason;
        }
    }

