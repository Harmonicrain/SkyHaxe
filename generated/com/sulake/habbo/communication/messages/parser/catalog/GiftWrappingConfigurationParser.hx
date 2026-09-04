package com.sulake.habbo.communication.messages.parser.catalog
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class GiftWrappingConfigurationParser implements IMessageParser
    {
        var _wrappingEnabled:Bool = false;
        var _wrappingPrice:Int = 0;
        var _stuffTypes:Array<ASAny>;
        var _boxTypes:Array<ASAny>;
        var _ribbonTypes:Array<ASAny>;
        var _defaultStuffTypes:Array<ASAny>;


        public var isWrappingEnabled(get,never):Bool;
function  get_isWrappingEnabled():Bool
        {
            return this._wrappingEnabled;
        }

        public var wrappingPrice(get,never):Int;
function  get_wrappingPrice():Int
        {
            return this._wrappingPrice;
        }

        public var stuffTypes(get,never):Array<ASAny>;
function  get_stuffTypes():Array<ASAny>
        {
            return this._stuffTypes;
        }

        public var boxTypes(get,never):Array<ASAny>;
function  get_boxTypes():Array<ASAny>
        {
            return this._boxTypes;
        }

        public var ribbonTypes(get,never):Array<ASAny>;
function  get_ribbonTypes():Array<ASAny>
        {
            return this._ribbonTypes;
        }

        public var defaultStuffTypes(get,never):Array<ASAny>;
function  get_defaultStuffTypes():Array<ASAny>
        {
            return this._defaultStuffTypes;
        }

        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_2:Int;
            this._stuffTypes = [];
            this._boxTypes = [];
            this._ribbonTypes = [];
            this._defaultStuffTypes = [];
            this._wrappingEnabled = k.readBoolean();
            this._wrappingPrice = k.readInteger();
            var _local_3= k.readInteger();
            _local_2 = 0;
            while (_local_2 < _local_3)
            {
                this._stuffTypes.push(k.readInteger());
                _local_2++;
            }
            _local_3 = k.readInteger();
            _local_2 = 0;
            while (_local_2 < _local_3)
            {
                this._boxTypes.push(k.readInteger());
                _local_2++;
            }
            _local_3 = k.readInteger();
            _local_2 = 0;
            while (_local_2 < _local_3)
            {
                this._ribbonTypes.push(k.readInteger());
                _local_2++;
            }
            _local_3 = k.readInteger();
            _local_2 = 0;
            while (_local_2 < _local_3)
            {
                this._defaultStuffTypes.push(k.readInteger());
                _local_2++;
            }
            return true;
        }

	public function new() {}
    }

