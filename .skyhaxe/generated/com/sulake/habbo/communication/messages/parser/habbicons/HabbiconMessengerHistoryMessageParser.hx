package com.sulake.habbo.communication.messages.parser.habbicons
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

     class HabbiconMessengerHistoryMessageParser implements IMessageParser
    {
        var _chatId:Int = 0;
        var _entries:Array<ASAny>;

        public function flush():Bool
        {
            this._chatId = 0;
            this._entries = [];
            return true;
        }

        public function parse(wrapper:IMessageDataWrapper):Bool
        {
            var count = 0;
            var index = 0;
            this._chatId = wrapper.readInteger();
            this._entries = [];
            count = wrapper.readInteger();
            index = 0;
            while (index < count)
            {
                this._entries.push(new HabbiconMessengerHistoryEntry(wrapper));
                index++;
            }
            return true;
        }

        public var chatId(get,never):Int;
public function  get_chatId():Int
        {
            return this._chatId;
        }

        public var entries(get,never):Array<ASAny>;
public function  get_entries():Array<ASAny>
        {
            return this._entries;
        }

	public function new() {}
    }

