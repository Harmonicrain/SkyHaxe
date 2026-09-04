package com.sulake.habbo.communication.messages.parser.habbicons
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

     class HabbiconStatusChangedMessageParser implements IMessageParser
    {
        var _habbiconId:Int = 0;
        var _habbiconState:Int = 0;

        public var habbiconId(get,never):Int;
function  get_habbiconId():Int
        {
            return this._habbiconId;
        }

        public var habbiconState(get,never):Int;
function  get_habbiconState():Int
        {
            return this._habbiconState;
        }

        public function flush():Bool
        {
            this._habbiconId = 0;
            this._habbiconState = 0;
            return true;
        }

        public function parse(wrapper:IMessageDataWrapper):Bool
        {
            this._habbiconId = wrapper.readInteger();
            this._habbiconState = wrapper.readInteger();
            return true;
        }

	public function new() {}
    }

