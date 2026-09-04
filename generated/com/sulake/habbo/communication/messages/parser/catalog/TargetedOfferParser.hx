package com.sulake.habbo.communication.messages.parser.catalog
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.catalog.TargetedOfferData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class TargetedOfferParser implements IMessageParser
    {
        var _data:TargetedOfferData;


        public function flush():Bool
        {
            this._data = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._data = new TargetedOfferData().parse(k);
            return true;
        }

        public var data(get,never):TargetedOfferData;
function  get_data():TargetedOfferData
        {
            return this._data;
        }

	public function new() {}
    }

