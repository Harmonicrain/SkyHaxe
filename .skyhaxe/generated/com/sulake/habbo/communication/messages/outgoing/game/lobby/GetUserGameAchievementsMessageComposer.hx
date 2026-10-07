package com.sulake.habbo.communication.messages.outgoing.game.lobby
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class GetUserGameAchievementsMessageComposer implements IMessageComposer
    {
        var _Str_2634:Int = 0;

        public function new(k:Int)
        {
            this._Str_2634 = k;
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._Str_2634];
        }

        public function dispose()
        {
        }
    }

