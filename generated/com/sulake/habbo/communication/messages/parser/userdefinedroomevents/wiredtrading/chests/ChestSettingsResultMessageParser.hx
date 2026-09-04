package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.chests
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

     class ChestSettingsResultMessageParser implements IMessageParser
    {
        var _chestId:Int = 0;
        var _notificationPreferences:Bool = false;
        public function flush():Bool
        {
            this._chestId = 0; this._notificationPreferences = false; return true;
        }
        public function parse(data:IMessageDataWrapper):Bool
        {
            if (data.bytesAvailable != 5) { return false; }
            this._chestId = data.readInteger();
            this._notificationPreferences = data.readBoolean();
            return true;
        }
        public var chestId(get,never):Int;
function  get_chestId():Int { return this._chestId; }
        public var isNotificationPreferences(get,never):Bool;
function  get_isNotificationPreferences():Bool
        {
            return this._notificationPreferences;
        }

	public function new() {}
    }

