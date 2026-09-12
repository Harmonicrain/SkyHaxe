package com.sulake.habbo.communication.messages.outgoing.shockwavesnowstorm
;
    import com.sulake.core.communication.util.Byte;

     final class SnowStormSetGameParametersComposer extends SnowStormComposerBase
    {
        public function new(name:String, mapId:Int, lengthChoice:Int,
            teamCount:Int, selectedTeam:Int)
        { super();
this._message = [name, new Byte(mapId), new Byte(lengthChoice),
            new Byte(teamCount), new Byte(selectedTeam)]; }
    }

