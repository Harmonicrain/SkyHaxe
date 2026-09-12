package com.sulake.habbo.communication.messages.outgoing.shockwavesnowstorm
;
    import com.sulake.core.communication.util.Byte;

     final class SnowStormAddBotComposer extends SnowStormComposerBase
    {
        public function new(instanceId:Int, teamId:Int)
        { super();
this._message = [instanceId, new Byte(teamId)]; }
    }

