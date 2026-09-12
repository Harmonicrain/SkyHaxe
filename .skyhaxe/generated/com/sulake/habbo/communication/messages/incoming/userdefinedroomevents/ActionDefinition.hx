package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ActionDefinition extends Triggerable
    {
        var _delayInPulses:Int = 0;

        public function new(k:IMessageDataWrapper)
        {
            super(k);
        }

        override function readDefinitionSpecifics(k:IMessageDataWrapper)
        {
            this._delayInPulses = k.readInteger();
        }

        public var type(get,never):Int;
public function  get_type():Int
        {
            return this.code;
        }

        
        public var delayInPulses(get,set):Int;
public function  get_delayInPulses():Int
        {
            return this._delayInPulses;
        }
public function  set_delayInPulses(k:Int):Int        {
            return this._delayInPulses = k;
        }

        // Wired 2.0 dropped conflicting-trigger warnings; kept empty for the
        // controller's length checks.
        public var conflictingTriggers(get,never):Array<ASAny>;
public function  get_conflictingTriggers():Array<ASAny>
        {
            return [];
        }
    }

