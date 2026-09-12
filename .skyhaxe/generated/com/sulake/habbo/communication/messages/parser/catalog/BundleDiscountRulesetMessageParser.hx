package com.sulake.habbo.communication.messages.parser.catalog
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.catalog.BundleDiscountRuleset;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class BundleDiscountRulesetMessageParser implements IMessageParser
    {
        var _bundleDiscountRuleset:BundleDiscountRuleset;


        public var bundleDiscountRuleset(get,never):BundleDiscountRuleset;
public function  get_bundleDiscountRuleset():BundleDiscountRuleset
        {
            return this._bundleDiscountRuleset;
        }

        public function flush():Bool
        {
            this._bundleDiscountRuleset = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._bundleDiscountRuleset = new BundleDiscountRuleset(k);
            return true;
        }

	public function new() {}
    }

