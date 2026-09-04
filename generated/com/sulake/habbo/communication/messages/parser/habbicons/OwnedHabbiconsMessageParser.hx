package com.sulake.habbo.communication.messages.parser.habbicons
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

     class OwnedHabbiconsMessageParser implements IMessageParser
    {
        var _habbicons:Array<ASAny> = [];
        var _recentHabbiconIds:Array<ASAny> = [];

        public var habbicons(get,never):Array<ASAny>;
function  get_habbicons():Array<ASAny>
        {
            return this._habbicons;
        }

        public var recentHabbiconIds(get,never):Array<ASAny>;
function  get_recentHabbiconIds():Array<ASAny>
        {
            return this._recentHabbiconIds;
        }

        public function flush():Bool
        {
            this._habbicons = [];
            this._recentHabbiconIds = [];
            return true;
        }

        public function parse(wrapper:IMessageDataWrapper):Bool
        {
            var count:Int;
            var index:Int;
            this._habbicons = [];
            this._recentHabbiconIds = [];
            count = wrapper.readInteger();
            for (index in 0...count)
            {
                this._habbicons.push(HabbiconWireParsers.readOwnedItem(wrapper));
            }
            count = wrapper.readInteger();
            for (index in 0...count)
            {
                this._recentHabbiconIds.push(wrapper.readInteger());
            }
            return true;
        }

	public function new() {}
    }

