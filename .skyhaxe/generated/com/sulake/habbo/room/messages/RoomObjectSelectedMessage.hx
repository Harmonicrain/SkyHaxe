package com.sulake.habbo.room.messages
;
     class RoomObjectSelectedMessage extends RoomObjectUpdateStateMessage 
    {
        var _selected:Bool = false;

        public function new(k:Bool)
        {
            super();
            this._selected = k;
        }

        public var selected(get,never):Bool;
public function  get_selected():Bool
        {
            return this._selected;
        }
    }

