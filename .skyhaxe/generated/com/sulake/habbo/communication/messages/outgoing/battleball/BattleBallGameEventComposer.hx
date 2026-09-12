package com.sulake.habbo.communication.messages.outgoing.battleball
;
     final class BattleBallGameEventComposer extends BattleBallComposerBase
    {
        public static function move(instanceId:Int, x:Int, y:Int):BattleBallGameEventComposer
        {
            return new BattleBallGameEventComposer(instanceId, 2, [x, y]);
        }

        public static function activate(instanceId:Int, powerObjectId:Int):BattleBallGameEventComposer
        {
            return new BattleBallGameEventComposer(instanceId, 4, [powerObjectId]);
        }

        public function new(instanceId:Int, subtype:Int, values:Array<ASAny>)
        {
            super();
            this._message = ([instanceId, subtype] : Array<Dynamic>).concat(values == null ? [] : values);
        }
    }

