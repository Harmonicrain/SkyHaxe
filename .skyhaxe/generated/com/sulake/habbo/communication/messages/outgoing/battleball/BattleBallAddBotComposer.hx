package com.sulake.habbo.communication.messages.outgoing.battleball
;
     final class BattleBallAddBotComposer extends BattleBallComposerBase
    {
        public function new(instanceId:Int, teamId:Int)
        {
            super();
            this._message = [instanceId, teamId];
        }
    }

