package com.sulake.habbo.communication.messages.parser.roomsettings
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class MuteAllInRoomParser implements IMessageParser
    {
        var _Str_19797:Bool = false;


        public function parse(k:IMessageDataWrapper):Bool
        {
            this._Str_19797 = k.readBoolean();
            return true;
        }

        public var _Str_20186(get,never):Bool;
public function  get__Str_20186():Bool
        {
            return this._Str_19797;
        }

        public function flush():Bool
        {
            return true;
        }

	public function new() {}
    }

