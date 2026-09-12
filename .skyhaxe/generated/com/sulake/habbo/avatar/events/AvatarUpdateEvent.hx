package com.sulake.habbo.avatar.events
;
    import flash.events.Event;

     class AvatarUpdateEvent extends Event 
    {
        public static inline final AVATAR_FIGURE_UPDATED= "AVATAR_FIGURE_UPDATED";

        var _figure:String;

        public function new(_figure:String, bubbles:Bool=false, cancelable:Bool=false)
        {
            super(AVATAR_FIGURE_UPDATED, bubbles, cancelable);
            this._figure = _figure;
        }

        public var figure(get,never):String;
public function  get_figure():String
        {
            return this._figure;
        }
    }

