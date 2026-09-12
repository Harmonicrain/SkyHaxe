package com.sulake.habbo.communication.messages.outgoing.battleball
;
     final class BattleBallRemoveBotComposer extends BattleBallComposerBase
    {
        public function new(instanceId:Int, botUserId:Int)
        {
            super();
            this._message = [instanceId, botUserId];
        }
    }

