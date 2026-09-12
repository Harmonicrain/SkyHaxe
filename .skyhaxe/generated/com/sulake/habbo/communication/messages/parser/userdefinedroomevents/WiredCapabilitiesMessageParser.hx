package com.sulake.habbo.communication.messages.parser.userdefinedroomevents
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

     class WiredCapabilitiesMessageParser implements IMessageParser
    {
        var _negotiatedRevision:Int = 0;
        var _connectionCapabilityMask:Int = 0;
        var _roomId:Int = 0;
        var _roomCapabilityMask:Int = 0;

        public function flush():Bool
        {
            this._negotiatedRevision = 0;
            this._connectionCapabilityMask = 0;
            this._roomId = 0;
            this._roomCapabilityMask = 0;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            if (k.bytesAvailable != 16)
            {
                return false;
            }
            this._negotiatedRevision = k.readInteger();
            this._connectionCapabilityMask = k.readInteger();
            this._roomId = k.readInteger();
            this._roomCapabilityMask = k.readInteger();
            return true;
        }

        public var negotiatedRevision(get,never):Int;
public function  get_negotiatedRevision():Int
        {
            return this._negotiatedRevision;
        }

        public var connectionCapabilityMask(get,never):Int;
public function  get_connectionCapabilityMask():Int
        {
            return this._connectionCapabilityMask;
        }

        public var roomId(get,never):Int;
public function  get_roomId():Int
        {
            return this._roomId;
        }

        public var roomCapabilityMask(get,never):Int;
public function  get_roomCapabilityMask():Int
        {
            return this._roomCapabilityMask;
        }

	public function new() {}
    }

