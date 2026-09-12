package com.sulake.habbo.communication.messages.outgoing.battleball
;
     final class BattleBallKickComposer extends BattleBallComposerBase
    {
        public function new(instanceId:Int, userId:Int) { super();
this._message = [instanceId, userId]; }
    }

