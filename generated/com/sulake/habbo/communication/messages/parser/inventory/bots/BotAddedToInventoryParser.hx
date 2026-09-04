package com.sulake.habbo.communication.messages.parser.inventory.bots
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class BotAddedToInventoryParser implements IMessageParser
    {
        var _item:BotData;
        var _Str_12302:Bool = false;


        public function flush():Bool
        {
            this._item = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._item = new BotData(k);
            this._Str_12302 = k.readBoolean();
            return true;
        }

        public var item(get,never):BotData;
function  get_item():BotData
        {
            return this._item;
        }

        public function _Str_19947():Bool
        {
            return this._Str_12302;
        }

	public function new() {}
    }

