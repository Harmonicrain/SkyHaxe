package com.sulake.habbo.room.messages
;
     class RoomObjectAvatarExpressionUpdateMessage extends RoomObjectUpdateStateMessage 
    {
        var _expressionType:Int = -1;

        public function new(k:Int=-1)
        {
            super();
            this._expressionType = k;
        }

        public var expressionType(get,never):Int;
function  get_expressionType():Int
        {
            return this._expressionType;
        }
    }

