package com.sulake.habbo.session.events
;
    import flash.events.Event;
    import com.sulake.habbo.session.IRoomSession;

     class RoomSessionEvent extends Event 
    {
        public static inline final CREATED= "RSE_CREATED";
        public static inline final STARTED= "RSE_STARTED";
        public static inline final ENDED= "RSE_ENDED";
        public static inline final ROOM_DATA= "RSE_ROOM_DATA";

        var _session:IRoomSession;
        var _openLandingPage:Bool = false;

        public function new(k:String, session:IRoomSession, _arg_3:Bool=true, bubbles:Bool=false, cancellable:Bool=false)
        {
            super(k, bubbles, cancellable);
            this._session = session;
            this._openLandingPage = _arg_3;
        }

        public var session(get,never):IRoomSession;
function  get_session():IRoomSession
        {
            return this._session;
        }

        public var openLandingPage(get,never):Bool;
function  get_openLandingPage():Bool
        {
            return this._openLandingPage;
        }
    }

