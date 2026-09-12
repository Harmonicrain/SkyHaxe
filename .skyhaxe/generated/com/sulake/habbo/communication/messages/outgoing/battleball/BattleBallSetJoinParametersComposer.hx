package com.sulake.habbo.communication.messages.outgoing.battleball
;
     final class BattleBallSetJoinParametersComposer extends BattleBallComposerBase
    {
        public function new(instanceId:Int, teamId:Int) { super();
this._message = [instanceId, teamId]; }
    }

