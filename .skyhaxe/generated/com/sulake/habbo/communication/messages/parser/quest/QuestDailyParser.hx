package com.sulake.habbo.communication.messages.parser.quest
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.quest.QuestMessageData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class QuestDailyParser implements IMessageParser 
    {
        var _quest:QuestMessageData;
        var _Str_5292:Int = 0;
        var _Str_5541:Int = 0;


        public function flush():Bool
        {
            this._quest = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_2= k.readBoolean();
            if (_local_2)
            {
                this._quest = new QuestMessageData(k);
                this._Str_5292 = k.readInteger();
                this._Str_5541 = k.readInteger();
            }
            return true;
        }

        public var quest(get,never):QuestMessageData;
public function  get_quest():QuestMessageData
        {
            return this._quest;
        }

        public var _Str_20037(get,never):Int;
public function  get__Str_20037():Int
        {
            return this._Str_5292;
        }

        public var _Str_19915(get,never):Int;
public function  get__Str_19915():Int
        {
            return this._Str_5541;
        }

	public function new() {}
    }

