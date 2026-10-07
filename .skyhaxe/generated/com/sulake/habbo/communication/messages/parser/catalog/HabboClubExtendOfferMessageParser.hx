package com.sulake.habbo.communication.messages.parser.catalog
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.catalog.ClubOfferExtendData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class HabboClubExtendOfferMessageParser implements IMessageParser
    {
        var _offer:ClubOfferExtendData;


        public function flush():Bool
        {
            this._offer = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._offer = new ClubOfferExtendData(k);
            return true;
        }

        public function offer():ClubOfferExtendData
        {
            return this._offer;
        }

	public function new() {}
    }

