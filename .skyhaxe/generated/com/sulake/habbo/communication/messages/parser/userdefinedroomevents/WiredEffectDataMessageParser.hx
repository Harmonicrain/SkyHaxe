package com.sulake.habbo.communication.messages.parser.userdefinedroomevents
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.ActionDefinition;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class WiredEffectDataMessageParser implements IMessageParser 
    {
        var _definition:ActionDefinition;


        public function flush():Bool
        {
            this._definition = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._definition = new ActionDefinition(k);
            return true;
        }

        public var definition(get,never):ActionDefinition;
public function  get_definition():ActionDefinition
        {
            return this._definition;
        }

	public function new() {}
    }

