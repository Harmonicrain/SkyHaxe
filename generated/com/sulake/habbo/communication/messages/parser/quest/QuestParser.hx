package com.sulake.habbo.communication.messages.parser.quest
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.quest.QuestMessageData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class QuestParser implements IMessageParser 
    {
        var _quest:QuestMessageData;


        public function flush():Bool
        {
            this._quest = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._quest = new QuestMessageData(k);
            return true;
        }

        public var quest(get,never):QuestMessageData;
function  get_quest():QuestMessageData
        {
            return this._quest;
        }

	public function new() {}
    }

