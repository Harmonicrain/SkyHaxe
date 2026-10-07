package com.sulake.habbo.ui.widget.messages
;
     class RoomWidgetGetBadgeDetailsMessage extends RoomWidgetMessage 
    {
        public static inline final RWGOI_MESSAGE_GET_BADGE_DETAILS= "RWGOI_MESSAGE_GET_BADGE_DETAILS";

        var _own:Bool = false;
        var _groupId:Int = 0;

        public function new(k:Bool, _arg_2:Int)
        {
            super(RWGOI_MESSAGE_GET_BADGE_DETAILS);
            this._own = k;
            this._groupId = _arg_2;
        }

        public var own(get,never):Bool;
public function  get_own():Bool
        {
            return this._own;
        }

        public var groupId(get,never):Int;
public function  get_groupId():Int
        {
            return this._groupId;
        }
    }

