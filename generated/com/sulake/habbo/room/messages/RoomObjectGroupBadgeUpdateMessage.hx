package com.sulake.habbo.room.messages
;
    import com.sulake.room.messages.RoomObjectUpdateMessage;

     class RoomObjectGroupBadgeUpdateMessage extends RoomObjectUpdateMessage 
    {
        public static inline final ROGBUM_BADGE_LOADED= "ROGBUM_BADGE_LOADED";

        var _badgeId:String;
        var _assetName:String;

        public function new(k:String, _arg_2:String)
        {
            super(null, null);
            this._badgeId = k;
            this._assetName = _arg_2;
        }

        public var badgeId(get,never):String;
function  get_badgeId():String
        {
            return this._badgeId;
        }

        public var assetName(get,never):String;
function  get_assetName():String
        {
            return this._assetName;
        }
    }

