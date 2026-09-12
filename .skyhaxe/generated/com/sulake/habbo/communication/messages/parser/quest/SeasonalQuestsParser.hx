package com.sulake.habbo.communication.messages.parser.quest
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.quest.QuestMessageData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class SeasonalQuestsParser implements IMessageParser 
    {
        var _quests:Array<ASAny>;


        public function flush():Bool
        {
            this._quests = [];
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._quests.push(new QuestMessageData(k));
                _local_3++;
            }
            return true;
        }

        public var quests(get,never):Array<ASAny>;
public function  get_quests():Array<ASAny>
        {
            return this._quests;
        }

	public function new() {}
    }

