package com.sulake.habbo.ui.widget.events
;
     class RoomWidgetRoomQueueUpdateEvent extends RoomWidgetUpdateEvent
    {
        public static inline final RWRQUE_VISITOR_QUEUE_STATUS= "RWRQUE_VISITOR_QUEUE_STATUS";
        public static inline final RWRQUE_SPECTATOR_QUEUE_STATUS= "RWRQUE_SPECTATOR_QUEUE_STATUS";

        var _position:Int = 0;
        var _hasHabboClub:Bool = false;
        var _isActive:Bool = false;
        var _isClubQueue:Bool = false;

        public function new(k:String, _arg_2:Int, _arg_3:Bool, _arg_4:Bool, _arg_5:Bool, _arg_6:Bool=false, _arg_7:Bool=false)
        {
            super(k, _arg_6, _arg_7);
            this._position = _arg_2;
            this._hasHabboClub = _arg_3;
            this._isActive = _arg_4;
            this._isClubQueue = _arg_5;
        }

        public var position(get,never):Int;
public function  get_position():Int
        {
            return this._position;
        }

        public var hasHabboClub(get,never):Bool;
public function  get_hasHabboClub():Bool
        {
            return this._hasHabboClub;
        }

        public var isActive(get,never):Bool;
public function  get_isActive():Bool
        {
            return this._isActive;
        }

        public var isClubQueue(get,never):Bool;
public function  get_isClubQueue():Bool
        {
            return this._isClubQueue;
        }
    }

