package com.sulake.habbo.communication.messages.parser.room.engine
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

     class ConfigurationItemStatesMessageParser implements IMessageParser
    {
        var _isHanditemControlBlocked:Bool = false;
        var _chooserDisabled:Bool = false;
        var _freeFurniMovementsEnabled:Bool = false;
        var _invisibleFurni:Bool = false;

        public function flush():Bool
        {
            this._isHanditemControlBlocked = false;
            this._chooserDisabled = false;
            this._freeFurniMovementsEnabled = false;
            this._invisibleFurni = false;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            if (k == null)
            {
                return false;
            }
            this._isHanditemControlBlocked = k.readBoolean();
            if (k.bytesAvailable > 0) this._chooserDisabled = k.readBoolean();
            if (k.bytesAvailable > 0) this._freeFurniMovementsEnabled = k.readBoolean();
            this._invisibleFurni = ((k.bytesAvailable > 0) && k.readBoolean());
            return true;
        }

        public var isHanditemControlBlocked(get,never):Bool;
function  get_isHanditemControlBlocked():Bool
        {
            return this._isHanditemControlBlocked;
        }

        public var chooserDisabled(get,never):Bool;
function  get_chooserDisabled():Bool
        {
            return this._chooserDisabled;
        }

        public var freeFurniMovementsEnabled(get,never):Bool;
function  get_freeFurniMovementsEnabled():Bool
        {
            return this._freeFurniMovementsEnabled;
        }

        public var invisibleFurni(get,never):Bool;
function  get_invisibleFurni():Bool
        {
            return this._invisibleFurni;
        }

	public function new() {}
    }

