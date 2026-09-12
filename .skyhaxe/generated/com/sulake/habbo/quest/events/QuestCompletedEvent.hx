package com.sulake.habbo.quest.events
;
    import flash.events.Event;
    import com.sulake.habbo.communication.messages.incoming.quest.QuestMessageData;

     class QuestCompletedEvent extends Event 
    {
        public static inline final QCE_SEASONAL= "qce_seasonal";

        var _questData:QuestMessageData;

        public function new(k:String, _arg_2:QuestMessageData, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            super(k, _arg_3, _arg_4);
            this._questData = _arg_2;
        }

        public var _Str_8257(get,never):QuestMessageData;
public function  get__Str_8257():QuestMessageData
        {
            return this._questData;
        }
    }

