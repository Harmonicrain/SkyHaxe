package com.sulake.habbo.communication.messages.parser.availability
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class AvailabilityStatusMessageParser implements IMessageParser
    {
        var _isOpen:Bool = false;
        var _onShutDown:Bool = false;
        var _isAuthenticHabbo:Bool = false;


        public var isOpen(get,never):Bool;
public function  get_isOpen():Bool
        {
            return this._isOpen;
        }

        public var onShutDown(get,never):Bool;
public function  get_onShutDown():Bool
        {
            return this._onShutDown;
        }

        public var isAuthenticHabbo(get,never):Bool;
public function  get_isAuthenticHabbo():Bool
        {
            return this._isAuthenticHabbo;
        }

        public function flush():Bool
        {
            this._isOpen = false;
            this._onShutDown = false;
            this._isAuthenticHabbo = false;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._isOpen = k.readBoolean();
            this._onShutDown = k.readBoolean();
            if (k.bytesAvailable != 0)
            {
                this._isAuthenticHabbo = k.readBoolean();
            }
            return true;
        }

	public function new() {}
    }

