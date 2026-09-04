package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class VariableInfoAndValue
    {
        var _variable:WiredVariable;
        var _value:Int = 0;

        public function new(k:IMessageDataWrapper)
        {
            WiredMessageDataValidator.requireBytes(k, 29, "VariableInfoAndValue");
            this._variable = new WiredVariable(k);
            WiredMessageDataValidator.requireBytes(k, 4, "VariableInfoAndValue value");
            this._value = k.readInteger();
        }

        public var variable(get,never):WiredVariable;
function  get_variable():WiredVariable { return this._variable; }
        public var value(get,never):Int;
function  get_value():Int { return this._value; }
    }

