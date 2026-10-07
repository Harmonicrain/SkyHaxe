package com.sulake.habbo.room.messages
;
     class RoomObjectAvatarFigureUpdateMessage extends RoomObjectUpdateStateMessage 
    {
        var _figure:String;
        var _race:String;
        var _gender:String;
        var _isRiding:Bool = false;

        public function new(k:String, _arg_2:String=null, _arg_3:String=null, _arg_4:Bool=false)
        {
            super();
            this._figure = k;
            this._gender = _arg_2;
            this._race = _arg_3;
            this._isRiding = _arg_4;
        }

        public var figure(get,never):String;
public function  get_figure():String
        {
            return this._figure;
        }

        public var race(get,never):String;
public function  get_race():String
        {
            return this._race;
        }

        public var gender(get,never):String;
public function  get_gender():String
        {
            return this._gender;
        }

        public var isRiding(get,never):Bool;
public function  get_isRiding():Bool
        {
            return this._isRiding;
        }
    }

