package com.sulake.habbo.communication.messages.outgoing.battleball
;
     final class BattleBallSetGameParametersComposer extends BattleBallComposerBase
    {
        public function new(name:String, mapId:Int, roundSeconds:Int, teamCount:Int,
            teamCapacity:Int, selectedTeam:Int, privateGame:Bool, powers:Array<ASAny>)
        {
            super();
            var safe= powers == null ? [] : powers.slice(0, 8);
            this._message = ([name, mapId, roundSeconds, teamCount, teamCapacity, selectedTeam, privateGame, safe.length] : Array<Dynamic>).concat(safe);
        }
    }

