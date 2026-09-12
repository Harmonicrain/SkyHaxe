package com.sulake.habbo.communication.messages.parser.inventory.bots
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class BotReceivedMessageParser implements IMessageParser
    {
        var _Str_10056:Bool = false;
        var _item:BotData;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._Str_10056 = k.readBoolean();
            this._item = new BotData(k);
            return true;
        }

        public var _Str_20732(get,never):Bool;
public function  get__Str_20732():Bool
        {
            return this._Str_10056;
        }

        public var item(get,never):BotData;
public function  get_item():BotData
        {
            return this._item;
        }

	public function new() {}
    }

