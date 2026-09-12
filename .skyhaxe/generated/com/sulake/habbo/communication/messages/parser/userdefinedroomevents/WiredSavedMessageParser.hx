package com.sulake.habbo.communication.messages.parser.userdefinedroomevents
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class WiredSavedMessageParser implements IMessageParser 
    {


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            return true;
        }

	public function new() {}
    }

