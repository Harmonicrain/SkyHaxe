package com.sulake.habbo.communication.messages.parser.userdefinedroomevents
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.SelectorDefinition;

     class WiredSelectorDataMessageParser implements IMessageParser
    {
        var _definition:SelectorDefinition;

        public function flush():Bool
        {
            this._definition = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._definition = new SelectorDefinition(k);
            return true;
        }

        public var definition(get,never):SelectorDefinition;
public function  get_definition():SelectorDefinition
        {
            return this._definition;
        }

	public function new() {}
    }

