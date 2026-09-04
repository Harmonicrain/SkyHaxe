package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class TriggerDefinition extends Triggerable
    {
        public function new(k:IMessageDataWrapper)
        {
            super(k);
        }

        public var type(get,never):Int;
function  get_type():Int
        {
            return this.code;
        }

        // Wired 2.0 dropped conflicting-trigger/action warnings; kept empty for the
        // controller's length checks.
        public var conflictingActions(get,never):Array<ASAny>;
function  get_conflictingActions():Array<ASAny>
        {
            return [];
        }
    }

