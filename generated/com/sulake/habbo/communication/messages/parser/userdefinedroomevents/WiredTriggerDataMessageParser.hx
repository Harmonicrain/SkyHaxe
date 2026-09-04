package com.sulake.habbo.communication.messages.parser.userdefinedroomevents
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.TriggerDefinition;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class WiredTriggerDataMessageParser implements IMessageParser 
    {
        var _Str_4948:TriggerDefinition;


        public function flush():Bool
        {
            this._Str_4948 = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._Str_4948 = new TriggerDefinition(k);
            return true;
        }

        public var _Str_10812(get,never):TriggerDefinition;
function  get__Str_10812():TriggerDefinition
        {
            return this._Str_4948;
        }

	public function new() {}
    }

