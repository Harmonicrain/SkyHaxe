package com.sulake.habbo.communication.messages.parser.userdefinedroomevents
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.AddonDefinition;

     class WiredAddonDataMessageParser implements IMessageParser
    {
        var _definition:AddonDefinition;

        public function flush():Bool
        {
            this._definition = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_2= k.bytesAvailable;
            if (!WiredDefinitionParserValidator.canParse(k))
            {
                return false;
            }
            try
            {
                this._definition = new AddonDefinition(k);
            }
            catch (error:ASError)
            {
                this._definition = null;
                return false;
            }
            if (!WiredDefinitionParserValidator.isComplete(k, this._definition, _local_2))
            {
                this._definition = null;
                return false;
            }
            return true;
        }

        public var definition(get,never):AddonDefinition;
function  get_definition():AddonDefinition
        {
            return this._definition;
        }

	public function new() {}
    }

