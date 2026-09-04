package com.sulake.habbo.communication.messages.parser.users
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

     class ChatStyleIdsMessageParser implements IMessageParser
    {
        var _styleIds:Array<ASAny>;

        public var styleIds(get,never):Array<ASAny>;
function  get_styleIds():Array<ASAny>
        {
            return this._styleIds;
        }

        public function flush():Bool
        {
            this._styleIds = [];
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_3 = 0;
            this._styleIds = [];
            var _local_2= k.readInteger();
            while (_local_3 < _local_2)
            {
                this._styleIds.push(k.readInteger());
                _local_3++;
            }
            return true;
        }

	public function new() {}
    }

