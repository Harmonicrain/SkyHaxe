package com.sulake.habbo.room.messages
;
     class RoomObjectAvatarFlatControlUpdateMessage extends RoomObjectUpdateStateMessage 
    {
        var _isAdmin:Bool = false;
        var _rawData:String;

        public function new(rawData:String)
        {
            super();
            this._rawData = rawData;
        }

        public var isAdmin(get,never):Bool;
function  get_isAdmin():Bool
        {
            return this._isAdmin;
        }

        public var rawData(get,never):String;
function  get_rawData():String
        {
            return this._rawData;
        }
    }

