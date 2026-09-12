package com.sulake.habbo.communication.messages.parser.navigator
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class NavigatorSettingsMessageParser implements IMessageParser
    {
        var _Str_7066:Int = 0;
        var _roomIdToEnter:Int = 0;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._Str_7066 = k.readInteger();
            this._roomIdToEnter = k.readInteger();
            return true;
        }

        public var homeRoomId(get,never):Int;
public function  get_homeRoomId():Int
        {
            return this._Str_7066;
        }

        public var _Str_17213(get,never):Int;
public function  get__Str_17213():Int
        {
            return this._roomIdToEnter;
        }

	public function new() {}
    }

