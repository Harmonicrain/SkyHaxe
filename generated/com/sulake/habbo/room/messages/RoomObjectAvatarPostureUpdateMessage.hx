package com.sulake.habbo.room.messages
;
     class RoomObjectAvatarPostureUpdateMessage extends RoomObjectUpdateStateMessage 
    {
        var _postureType:String;
        var _parameter:String;

        public function new(k:String, _arg_2:String="")
        {
            super();
            this._postureType = k;
            this._parameter = _arg_2;
        }

        public var postureType(get,never):String;
function  get_postureType():String
        {
            return this._postureType;
        }

        public var parameter(get,never):String;
function  get_parameter():String
        {
            return this._parameter;
        }
    }

