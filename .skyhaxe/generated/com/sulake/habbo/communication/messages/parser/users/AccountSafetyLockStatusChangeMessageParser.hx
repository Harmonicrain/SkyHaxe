package com.sulake.habbo.communication.messages.parser.users
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class AccountSafetyLockStatusChangeMessageParser implements IMessageParser
    {
        public static inline final SAFETY_LOCK_STATUS_LOCKED= 0;
        public static inline final SAFETY_LOCK_STATUS_UNLOCKED= 1;

        var _status:Int = 0;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._status = k.readInteger();
            return true;
        }

        public var status(get,never):Int;
public function  get_status():Int
        {
            return this._status;
        }

	public function new() {}
    }

