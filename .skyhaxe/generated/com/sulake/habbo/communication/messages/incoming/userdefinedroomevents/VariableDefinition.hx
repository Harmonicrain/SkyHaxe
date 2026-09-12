package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class VariableDefinition extends Triggerable
    {
        public function new(k:IMessageDataWrapper)
        {
            super(k);
        }

        public var type(get,never):Int;
public function  get_type():Int
        {
            return this.code;
        }
    }

