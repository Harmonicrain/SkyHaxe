package com.sulake.habbo.communication.messages.parser.users
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

     class PurchasableChatStyleChangedMessageParser implements IMessageParser
    {
        var _styleId:Int = 0;
        var _owned:Bool = false;

        public var styleId(get,never):Int;
public function  get_styleId():Int
        {
            return this._styleId;
        }

        public var owned(get,never):Bool;
public function  get_owned():Bool
        {
            return this._owned;
        }

        public function flush():Bool
        {
            this._styleId = 0;
            this._owned = false;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._styleId = k.readInteger();
            this._owned = k.readBoolean();
            return true;
        }

	public function new() {}
    }

