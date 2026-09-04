package com.sulake.habbo.communication.messages.parser.userdefinedroomevents
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.ConditionDefinition;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class WiredConditionDataMessageParser implements IMessageParser 
    {
        var _definition:ConditionDefinition;


        public function flush():Bool
        {
            this._definition = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._definition = new ConditionDefinition(k);
            return true;
        }

        public var definition(get,never):ConditionDefinition;
function  get_definition():ConditionDefinition
        {
            return this._definition;
        }

	public function new() {}
    }

