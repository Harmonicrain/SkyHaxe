package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.trade
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.habbo.communication.messages.incoming.inventory.trading.ItemDataStructure;

    /** The two-sided item block embedded in July's Wired Trade update. */
     class WiredTradingItems
    {
        static inline final MAX_ITEMS= 1500;

        var _firstUserID:Int = 0;
        var _firstUserItemArray:Array<ASAny>;
        var _firstUserNumItems:Int = 0;
        var _firstUserNumCredits:Int = 0;
        var _secondUserID:Int = 0;
        var _secondUserItemArray:Array<ASAny>;
        var _secondUserNumItems:Int = 0;
        var _secondUserNumCredits:Int = 0;

        public function parse(data:IMessageDataWrapper):Bool
        {
            this._firstUserID = data.readInteger();
            this._firstUserItemArray = [];
            if (!this.parseItemData(data, this._firstUserItemArray)) { return false; }
            this._firstUserNumItems = data.readInteger();
            this._firstUserNumCredits = data.readInteger();
            this._secondUserID = data.readInteger();
            this._secondUserItemArray = [];
            if (!this.parseItemData(data, this._secondUserItemArray)) { return false; }
            this._secondUserNumItems = data.readInteger();
            this._secondUserNumCredits = data.readInteger();
            return this._firstUserNumItems >= 0 && this._firstUserNumItems <= MAX_ITEMS
                && this._secondUserNumItems >= 0 && this._secondUserNumItems <= MAX_ITEMS
                && this._firstUserNumCredits >= 0 && this._secondUserNumCredits >= 0;
        }

        public function flush()
        {
            this._firstUserID = -1;
            this._firstUserItemArray = null;
            this._firstUserNumItems = 0;
            this._firstUserNumCredits = 0;
            this._secondUserID = -1;
            this._secondUserItemArray = null;
            this._secondUserNumItems = 0;
            this._secondUserNumCredits = 0;
        }

        function parseItemData(data:IMessageDataWrapper, items:Array<ASAny>):Bool
        {
            var count= data.readInteger();
            if (count < 0 || count > MAX_ITEMS) { return false; }
            try
            {
                while (count-- > 0)
                {
                    items.push(new ItemDataStructure(data));
                }
            }
            catch (error:ASError)
            {
                items.resize(0);
                return false;
            }
            return true;
        }

        public var firstUserID(get,never):Int;
function  get_firstUserID():Int { return this._firstUserID; }
        public var firstUserItemArray(get,never):Array<ASAny>;
function  get_firstUserItemArray():Array<ASAny> { return this._firstUserItemArray; }
        public var firstUserNumItems(get,never):Int;
function  get_firstUserNumItems():Int { return this._firstUserNumItems; }
        public var firstUserNumCredits(get,never):Int;
function  get_firstUserNumCredits():Int { return this._firstUserNumCredits; }
        public var secondUserID(get,never):Int;
function  get_secondUserID():Int { return this._secondUserID; }
        public var secondUserItemArray(get,never):Array<ASAny>;
function  get_secondUserItemArray():Array<ASAny> { return this._secondUserItemArray; }
        public var secondUserNumItems(get,never):Int;
function  get_secondUserNumItems():Int { return this._secondUserNumItems; }
        public var secondUserNumCredits(get,never):Int;
function  get_secondUserNumCredits():Int { return this._secondUserNumCredits; }
public function new(){}
    }

