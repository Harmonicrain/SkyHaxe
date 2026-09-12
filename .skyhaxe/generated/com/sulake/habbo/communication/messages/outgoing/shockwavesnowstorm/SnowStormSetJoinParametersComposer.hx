package com.sulake.habbo.communication.messages.outgoing.shockwavesnowstorm
;
    import com.sulake.core.communication.util.Byte;

     final class SnowStormSetJoinParametersComposer extends SnowStormComposerBase
    {
        public function new(instanceId:Int, teamId:Int)
        { super();
this._message = [instanceId, new Byte(teamId)]; }
    }

