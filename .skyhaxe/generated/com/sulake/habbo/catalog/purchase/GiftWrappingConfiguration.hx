package com.sulake.habbo.catalog.purchase
;
    import com.sulake.habbo.communication.messages.incoming.catalog.GiftWrappingConfigurationEvent;

     class GiftWrappingConfiguration 
    {
        var _isEnabled:Bool = false;
        var _price:Int = 0;
        var _stuffTypes:Array<ASAny>;
        var _boxTypes:Array<ASAny>;
        var _ribbonTypes:Array<ASAny>;
        var _defaultStuffTypes:Array<ASAny>;

        public function new(k:GiftWrappingConfigurationEvent)
        {
            if (k == null)
            {
                return;
            }
            var _local_2= k.getParser();
            if (_local_2 == null)
            {
                return;
            }
            this._isEnabled = _local_2.isWrappingEnabled;
            this._price = _local_2.wrappingPrice;
            this._stuffTypes = _local_2.stuffTypes;
            this._boxTypes = _local_2.boxTypes;
            this._ribbonTypes = _local_2.ribbonTypes;
            this._defaultStuffTypes = _local_2.defaultStuffTypes;
        }

        public var isEnabled(get,never):Bool;
public function  get_isEnabled():Bool
        {
            return this._isEnabled;
        }

        public var price(get,never):Int;
public function  get_price():Int
        {
            return this._price;
        }

        public var stuffTypes(get,never):Array<ASAny>;
public function  get_stuffTypes():Array<ASAny>
        {
            return this._stuffTypes;
        }

        public var boxTypes(get,never):Array<ASAny>;
public function  get_boxTypes():Array<ASAny>
        {
            return this._boxTypes;
        }

        public var ribbonTypes(get,never):Array<ASAny>;
public function  get_ribbonTypes():Array<ASAny>
        {
            return this._ribbonTypes;
        }

        public var defaultStuffTypes(get,never):Array<ASAny>;
public function  get_defaultStuffTypes():Array<ASAny>
        {
            return this._defaultStuffTypes;
        }
    }

