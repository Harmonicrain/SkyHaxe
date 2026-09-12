package com.sulake.habbo.catalog.purse
;

     class Purse implements IPurse 
    {
        var _credits:Int = 0;
        var _activityPoints:ASDictionary<ASAny,ASAny>;
        var _clubDays:Int = 0;
        var _clubPeriods:Int = 0;
        var _isVIP:Bool = false;
        var _pastClubDays:Int = 0;
        var _pastVipDays:Int = 0;
        var _isExpiring:Bool = false;
        var _minutesUntilExpiration:Int = 0;
        var _minutesSinceLastModified:Int = 0;
        var _lastUpdated:Int = 0;

        public function new()
        {
            this._activityPoints = new ASDictionary<ASAny,ASAny>();
        }

        
        public var credits(get,set):Int;
public function  get_credits():Int
        {
            return this._credits;
        }
public function  set_credits(k:Int):Int        {
            this._lastUpdated = flash.Lib.getTimer();
            return this._credits = k;
        }

        
        public var clubDays(get,set):Int;
public function  get_clubDays():Int
        {
            return this._clubDays;
        }
public function  set_clubDays(k:Int):Int        {
            this._lastUpdated = flash.Lib.getTimer();
            return this._clubDays = k;
        }

        
        public var clubPeriods(get,set):Int;
public function  get_clubPeriods():Int
        {
            return this._clubPeriods;
        }
public function  set_clubPeriods(k:Int):Int        {
            this._lastUpdated = flash.Lib.getTimer();
            return this._clubPeriods = k;
        }

        public var hasClubLeft(get,never):Bool;
public function  get_hasClubLeft():Bool
        {
            return (this._clubDays > 0) || (this._clubPeriods > 0);
        }

        
        public var isVIP(get,set):Bool;
public function  get_isVIP():Bool
        {
            return this._isVIP;
        }

        
        public var isExpiring(get,set):Bool;
public function  get_isExpiring():Bool
        {
            return this._isExpiring;
        }
public function  set_isExpiring(k:Bool):Bool        {
            return this._isExpiring = k;
        }
public function  set_isVIP(k:Bool):Bool        {
            return this._isVIP = k;
        }

        
        public var pastClubDays(get,set):Int;
public function  get_pastClubDays():Int
        {
            return this._pastClubDays;
        }
public function  set_pastClubDays(k:Int):Int        {
            this._lastUpdated = flash.Lib.getTimer();
            return this._pastClubDays = k;
        }

        
        public var pastVipDays(get,set):Int;
public function  get_pastVipDays():Int
        {
            return this._pastVipDays;
        }
public function  set_pastVipDays(k:Int):Int        {
            this._lastUpdated = flash.Lib.getTimer();
            return this._pastVipDays = k;
        }

        
        public var activityPoints(get,set):ASDictionary<ASAny,ASAny>;
public function  get_activityPoints():ASDictionary<ASAny,ASAny>
        {
            return this._activityPoints;
        }
public function  set_activityPoints(k:ASDictionary<ASAny,ASAny>):ASDictionary<ASAny,ASAny>        {
            this._lastUpdated = flash.Lib.getTimer();
            return this._activityPoints = k;
        }

        public function getActivityPointsForType(k:Int):Int
        {
            return ASCompat.toInt(this._activityPoints[k]);
        }

        
        public var minutesUntilExpiration(get,set):Int;
public function  set_minutesUntilExpiration(k:Int):Int        {
            this._lastUpdated = flash.Lib.getTimer();
            return this._minutesUntilExpiration = k;
        }
public function  get_minutesUntilExpiration():Int
        {
            var k= Std.int((flash.Lib.getTimer() - this._lastUpdated) / (1000 * 60));
            var _local_2= (this._minutesUntilExpiration - k);
            return (_local_2 > 0) ? _local_2 : 0;
        }

        
        public var minutesSinceLastModified(get,set):Int;
public function  set_minutesSinceLastModified(k:Int):Int        {
            this._lastUpdated = flash.Lib.getTimer();
            return this._minutesSinceLastModified = k;
        }
public function  get_minutesSinceLastModified():Int
        {
            return this._minutesSinceLastModified;
        }

        public var _Str_26225(get,never):Int;
public function  get__Str_26225():Int
        {
            return this._lastUpdated;
        }
    }

