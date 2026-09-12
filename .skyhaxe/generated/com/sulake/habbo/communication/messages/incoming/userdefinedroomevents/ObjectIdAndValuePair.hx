package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ObjectIdAndValuePair
    {
        var _objectId:Int = 0;
        var _value:Int = 0;

        public function new(k:IMessageDataWrapper)
        {
            WiredMessageDataValidator.requireBytes(k, 8, "Wired holder value");
            this._objectId = k.readInteger();
            this._value = k.readInteger();
        }

        public var objectId(get,never):Int;
public function  get_objectId():Int { return this._objectId; }
        public var value(get,never):Int;
public function  get_value():Int { return this._value; }
    }

