package com.sulake.habbo.communication.messages.parser.userdefinedroomevents
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

     class AllVariablesHashMessageParser implements IMessageParser
    {
        var _allVariablesHash:Int = 0;

        public function flush():Bool
        {
            this._allVariablesHash = 0;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            if (k.bytesAvailable != 4)
            {
                return false;
            }
            this._allVariablesHash = k.readInteger();
            return true;
        }

        public var allVariablesHash(get,never):Int;
function  get_allVariablesHash():Int
        {
            return this._allVariablesHash;
        }

	public function new() {}
    }

