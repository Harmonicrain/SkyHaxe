package com.sulake.habbo.communication.messages.parser.habbicons
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.catalog.habbicons.HabbiconShopItem;

     class HabbiconInfoMessageParser implements IMessageParser
    {
        var _habbicon:HabbiconShopItem;

        public var habbicon(get,never):HabbiconShopItem;
public function  get_habbicon():HabbiconShopItem
        {
            return this._habbicon;
        }

        public function flush():Bool
        {
            this._habbicon = null;
            return true;
        }

        public function parse(wrapper:IMessageDataWrapper):Bool
        {
            this._habbicon = HabbiconWireParsers.readShopItem(wrapper);
            return true;
        }

	public function new() {}
    }

