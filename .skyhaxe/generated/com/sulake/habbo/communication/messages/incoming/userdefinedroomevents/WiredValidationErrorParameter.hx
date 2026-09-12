package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class WiredValidationErrorParameter
    {
        var _key:String;
        var _value:String;

        public function new(k:IMessageDataWrapper)
        {
            this._key = k.readString();
            this._value = k.readString();
        }

        public var key(get,never):String;
public function  get_key():String
        {
            return this._key;
        }

        public var value(get,never):String;
public function  get_value():String
        {
            return this._value;
        }
    }

