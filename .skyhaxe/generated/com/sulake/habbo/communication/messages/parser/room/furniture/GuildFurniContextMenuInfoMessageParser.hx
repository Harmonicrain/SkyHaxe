package com.sulake.habbo.communication.messages.parser.room.furniture
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class GuildFurniContextMenuInfoMessageParser implements IMessageParser
    {
        var _objectId:Int = 0;
        var _guildId:Int = 0;
        var _Str_18836:String;
        var _Str_8815:Int = 0;
        var _Str_7536:Bool = false;
        var _Str_9506:Bool = false;


        public var objectId(get,never):Int;
public function  get_objectId():Int
        {
            return this._objectId;
        }

        public var guildId(get,never):Int;
public function  get_guildId():Int
        {
            return this._guildId;
        }

        public var _Str_24570(get,never):String;
public function  get__Str_24570():String
        {
            return this._Str_18836;
        }

        public var _Str_25076(get,never):Int;
public function  get__Str_25076():Int
        {
            return this._Str_8815;
        }

        public var _Str_24832(get,never):Bool;
public function  get__Str_24832():Bool
        {
            return this._Str_7536;
        }

        public var _Str_24908(get,never):Bool;
public function  get__Str_24908():Bool
        {
            return this._Str_9506;
        }

        public function flush():Bool
        {
            this._objectId = -1;
            this._guildId = -1;
            this._Str_18836 = "";
            this._Str_8815 = -1;
            this._Str_7536 = false;
            this._Str_9506 = false;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            if (k == null)
            {
                return false;
            }
            this._objectId = k.readInteger();
            this._guildId = k.readInteger();
            this._Str_18836 = k.readString();
            this._Str_8815 = k.readInteger();
            this._Str_7536 = k.readBoolean();
            this._Str_9506 = k.readBoolean();
            return true;
        }

	public function new() {}
    }

