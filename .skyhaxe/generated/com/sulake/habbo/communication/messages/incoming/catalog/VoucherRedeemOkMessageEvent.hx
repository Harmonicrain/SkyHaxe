package com.sulake.habbo.communication.messages.incoming.catalog
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.catalog.VoucherRedeemOkMessageParser;

     class VoucherRedeemOkMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, VoucherRedeemOkMessageParser);
        }

        public var productName(get,never):String;
public function  get_productName():String
        {
            return Std.downcast(_parser , VoucherRedeemOkMessageParser).productName;
        }

        public var productDescription(get,never):String;
public function  get_productDescription():String
        {
            return Std.downcast(_parser , VoucherRedeemOkMessageParser).productDescription;
        }
    }

