package com.sulake.habbo.communication.messages.outgoing.battleball
;
     final class BattleBallLeaveComposer extends BattleBallComposerBase
    {
        public function new(instanceId:Int) { super();
this._message = [instanceId]; }
    }

