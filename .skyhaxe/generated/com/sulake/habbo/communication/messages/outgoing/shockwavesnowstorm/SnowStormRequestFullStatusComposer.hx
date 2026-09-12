package com.sulake.habbo.communication.messages.outgoing.shockwavesnowstorm
;
    import com.sulake.core.communication.util.Byte;

     final class SnowStormRequestFullStatusComposer extends SnowStormComposerBase
    {
        public function new(instanceId:Int, sequence:Int, reason:Int)
        { super();
this._message = [instanceId, sequence, new Byte(reason)]; }
    }

