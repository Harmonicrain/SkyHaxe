package com.sulake.habbo.communication.messages.incoming.crafting
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class CraftingResultMessageParser implements IMessageParser 
    {
        var _success:Bool = false;
        var _result:CraftingResultObjectParser;


        public function parse(k:IMessageDataWrapper):Bool
        {
            this._success = k.readBoolean();
            if (this._success)
            {
                this._result = new CraftingResultObjectParser(k);
            }
            return true;
        }

        public function flush():Bool
        {
            this._success = false;
            return true;
        }

        public var success(get,never):Bool;
function  get_success():Bool
        {
            return this._success;
        }

        public var result(get,never):CraftingResultObjectParser;
function  get_result():CraftingResultObjectParser
        {
            return this._result;
        }

	public function new() {}
    }

