package com.sulake.habbo.communication.messages.parser.availability
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class MaintenanceStatusMessageParser implements IMessageParser
    {
        var _isInMaintenance:Bool = false;
        var _minutesUntilMaintenance:Int = 0;
        var _duration:Int = 15;


        public var isInMaintenance(get,never):Bool;
function  get_isInMaintenance():Bool
        {
            return this._isInMaintenance;
        }

        public var minutesUntilMaintenance(get,never):Int;
function  get_minutesUntilMaintenance():Int
        {
            return this._minutesUntilMaintenance;
        }

        public var duration(get,never):Int;
function  get_duration():Int
        {
            return this._duration;
        }

        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._isInMaintenance = k.readBoolean();
            this._minutesUntilMaintenance = k.readInteger();
            if (k.bytesAvailable != 0)
            {
                this._duration = k.readInteger();
            }
            return true;
        }

	public function new() {}
    }

