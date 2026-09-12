package com.sulake.habbo.communication.messages.parser.quest
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class EpicPopupParser implements IMessageParser 
    {
        var _Str_18748:String;


        public function flush():Bool
        {
            this._Str_18748 = "";
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._Str_18748 = k.readString();
            return true;
        }

        public var _Str_24035(get,never):String;
public function  get__Str_24035():String
        {
            return this._Str_18748;
        }

	public function new() {}
    }

