package com.sulake.habbo.communication.messages.parser.inventory.trading
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.habbo.communication.messages.incoming.inventory.trading.ItemDataStructure;

     class TradingItemListParser implements IMessageParser 
    {
        var _firstUserID:Int = 0;
        var _firstUserItemArray:Array<ASAny>;
        var _firstUserNumItems:Int = 0;
        var _firstUserNumCredits:Int = 0;
        var _secondUserID:Int = 0;
        var _secondUserItemArray:Array<ASAny>;
        var _secondUserNumItems:Int = 0;
        var _secondUserNumCredits:Int = 0;


        public var firstUserID(get,never):Int;
function  get_firstUserID():Int
        {
            return this._firstUserID;
        }

        public var firstUserItemArray(get,never):Array<ASAny>;
function  get_firstUserItemArray():Array<ASAny>
        {
            return this._firstUserItemArray;
        }

        public var firstUserNumItems(get,never):Int;
function  get_firstUserNumItems():Int
        {
            return this._firstUserNumItems;
        }

        public var firstUserNumCredits(get,never):Int;
function  get_firstUserNumCredits():Int
        {
            return this._firstUserNumCredits;
        }

        public var secondUserID(get,never):Int;
function  get_secondUserID():Int
        {
            return this._secondUserID;
        }

        public var secondUserItemArray(get,never):Array<ASAny>;
function  get_secondUserItemArray():Array<ASAny>
        {
            return this._secondUserItemArray;
        }

        public var secondUserNumItems(get,never):Int;
function  get_secondUserNumItems():Int
        {
            return this._secondUserNumItems;
        }

        public var secondUserNumCredits(get,never):Int;
function  get_secondUserNumCredits():Int
        {
            return this._secondUserNumCredits;
        }

        public function flush():Bool
        {
            this._firstUserID = -1;
            this._firstUserItemArray = null;
            this._firstUserNumItems = 0;
            this._firstUserNumCredits = 0;
            this._secondUserID = -1;
            this._secondUserItemArray = null;
            this._secondUserNumItems = 0;
            this._secondUserNumCredits = 0;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._firstUserID = k.readInteger();
            this._firstUserItemArray = new Array<ASAny>();
            if (!this.parseItemData(k, this._firstUserItemArray))
            {
                return false;
            }
            this._firstUserNumItems = k.readInteger();
            this._firstUserNumCredits = k.readInteger();
            this._secondUserID = k.readInteger();
            this._secondUserItemArray = new Array<ASAny>();
            if (!this.parseItemData(k, this._secondUserItemArray))
            {
                return false;
            }
            this._secondUserNumItems = k.readInteger();
            this._secondUserNumCredits = k.readInteger();
            return true;
        }

        function parseItemData(k:IMessageDataWrapper, _arg_2:Array<ASAny>):Bool
        {
            var _local_3:Int;
            _local_3 = k.readInteger();
            while (_local_3 > 0)
            {
                _arg_2.push(new ItemDataStructure(k));
                _local_3--;
            }
            return true;
        }

	public function new() {}
    }

