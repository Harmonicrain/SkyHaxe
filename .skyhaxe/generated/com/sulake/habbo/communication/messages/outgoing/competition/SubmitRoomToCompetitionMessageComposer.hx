package com.sulake.habbo.communication.messages.outgoing.competition
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class SubmitRoomToCompetitionMessageComposer implements IMessageComposer
    {
        public static inline final CONFIRM_LEVEL_NOT_ACCEPTED= 0;
        public static inline final CONFIRM_LEVEL_NOT_SUBMITTED= 1;
        public static inline final CONFIRM_LEVEL_NOT_CONFIRMED= 2;
        public static inline final CONFIRM_LEVEL_COMMIT= 3;

        var _data:Array<ASAny>;

        public function new(k:String, _arg_2:Int)
        {
            this._data = [];
            this._data.push(k);
            this._data.push(_arg_2);
        }

        public function getMessageArray():Array<ASAny>
        {
            return this._data;
        }

        public function dispose()
        {
            this._data = null;
        }
    }

