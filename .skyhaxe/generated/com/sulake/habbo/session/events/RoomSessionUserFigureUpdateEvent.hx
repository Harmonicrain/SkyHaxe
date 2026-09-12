package com.sulake.habbo.session.events
;
    import com.sulake.habbo.session.IRoomSession;

     class RoomSessionUserFigureUpdateEvent extends RoomSessionEvent 
    {
        public static inline final RSUBE_FIGURE= "RSUBE_FIGURE";

        var _userId:Int = 0;
        var _figure:String = "";
        var _gender:String = "";
        var _customInfo:String = "";
        var _achievementScore:Int = 0;

        public function new(k:IRoomSession, _arg_2:Int, _arg_3:String, _arg_4:String, _arg_5:String, _arg_6:Int, _arg_7:Bool=false, _arg_8:Bool=false)
        {
            super(RSUBE_FIGURE, k, _arg_7, _arg_8);
            this._userId = _arg_2;
            this._figure = _arg_3;
            this._gender = _arg_4;
            this._customInfo = _arg_5;
            this._achievementScore = _arg_6;
        }

        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return this._userId;
        }

        public var figure(get,never):String;
public function  get_figure():String
        {
            return this._figure;
        }

        public var gender(get,never):String;
public function  get_gender():String
        {
            return this._gender;
        }

        public var customInfo(get,never):String;
public function  get_customInfo():String
        {
            return this._customInfo;
        }

        public var activityPoints(get,never):Int;
public function  get_activityPoints():Int
        {
            return this._achievementScore;
        }
    }

