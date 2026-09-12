package com.sulake.habbo.communication.messages.incoming.shockwavesnowstorm
;
    /** Distinguishes the Shockwave port from the later AIR SnowWar event of the same name. */
     final class ShockwaveSnowStormFullGameStatusEvent extends SnowStormMessageEvent
    {
        public function new(callback:ASFunction)
        {
            super(callback);
        }
    }

