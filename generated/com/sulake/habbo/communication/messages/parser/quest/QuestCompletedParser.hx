package com.sulake.habbo.communication.messages.parser.quest
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.quest.QuestMessageData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class QuestCompletedParser implements IMessageParser 
    {
        var _Str_8460:QuestMessageData;
        var _Str_21098:Bool = false;


        public function flush():Bool
        {
            this._Str_8460 = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._Str_8460 = new QuestMessageData(k);
            this._Str_21098 = k.readBoolean();
            return true;
        }

        public var _Str_8257(get,never):QuestMessageData;
function  get__Str_8257():QuestMessageData
        {
            return this._Str_8460;
        }

        public var _Str_23243(get,never):Bool;
function  get__Str_23243():Bool
        {
            return this._Str_21098;
        }

	public function new() {}
    }

