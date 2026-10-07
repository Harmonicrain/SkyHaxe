package com.sulake.habbo.session.events
;
    import flash.events.Event;
    import flash.display.BitmapData;

     class BadgeImageReadyEvent extends Event 
    {
        public static inline final BIRE_BADGE_IMAGE_READY= "BIRE_BADGE_IMAGE_READY";

        var _badgeId:String;
        var _image:BitmapData;

        public function new(k:String, _arg_2:BitmapData, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            super(BIRE_BADGE_IMAGE_READY, _arg_3, _arg_4);
            this._badgeId = k;
            this._image = _arg_2;
        }

        public var badgeId(get,never):String;
public function  get_badgeId():String
        {
            return this._badgeId;
        }

        public var badgeImage(get,never):BitmapData;
public function  get_badgeImage():BitmapData
        {
            return this._image;
        }
    }

