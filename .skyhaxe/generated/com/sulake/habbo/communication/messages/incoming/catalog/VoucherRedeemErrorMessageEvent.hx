package com.sulake.habbo.communication.messages.incoming.catalog
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.catalog.VoucherRedeemErrorMessageParser;

     class VoucherRedeemErrorMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, VoucherRedeemErrorMessageParser);
        }

        public var errorCode(get,never):String;
public function  get_errorCode():String
        {
            return Std.downcast(_parser , VoucherRedeemErrorMessageParser).errorCode;
        }
    }

