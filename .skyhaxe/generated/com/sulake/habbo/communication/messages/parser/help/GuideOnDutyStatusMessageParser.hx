package com.sulake.habbo.communication.messages.parser.help
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class GuideOnDutyStatusMessageParser implements IMessageParser
    {
        var _onDuty:Bool = false;
        var _Str_21395:Int = 0;
        var _Str_20463:Int = 0;
        var _Str_20900:Int = 0;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._onDuty = k.readBoolean();
            this._Str_21395 = k.readInteger();
            this._Str_20463 = k.readInteger();
            this._Str_20900 = k.readInteger();
            return true;
        }

        public var onDuty(get,never):Bool;
public function  get_onDuty():Bool
        {
            return this._onDuty;
        }

        public var _Str_25148(get,never):Int;
public function  get__Str_25148():Int
        {
            return this._Str_20463;
        }

        public var _Str_24092(get,never):Int;
public function  get__Str_24092():Int
        {
            return this._Str_20900;
        }

        public var _Str_24740(get,never):Int;
public function  get__Str_24740():Int
        {
            return this._Str_21395;
        }

	public function new() {}
    }

