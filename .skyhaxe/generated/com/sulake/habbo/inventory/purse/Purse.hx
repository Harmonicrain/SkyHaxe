package com.sulake.habbo.inventory.purse
;

     class Purse 
    {
        var _isExpiring:Bool = false;
        var _isCitizenshipVipExpiring:Bool = false;
        var _clubDays:Int = 0;
        var _clubPeriods:Int = 0;
        var _clubPastPeriods:Int = 0;
        var _clubHasEverBeenMember:Bool = false;
        var _isVIP:Bool = false;
        var _minutesUntilExpiration:Int = 0;
        var _minutesSinceLastModified:Int = -1;
        var _lastUpdated:Int = 0;


        
        public var clubDays(get,set):Int;
public function  get_clubDays():Int
        {
            return this._clubDays;
        }
public function  set_clubDays(k:Int):Int        {
            this._lastUpdated = flash.Lib.getTimer();
            this._clubDays = Std.int(Math.max(0, k));
return k;
        }

        
        public var clubPeriods(get,set):Int;
public function  get_clubPeriods():Int
        {
            return this._clubPeriods;
        }
public function  set_clubPeriods(k:Int):Int        {
            this._lastUpdated = flash.Lib.getTimer();
            this._clubPeriods = Std.int(Math.max(0, k));
return k;
        }

        
        public var clubPastPeriods(get,set):Int;
public function  get_clubPastPeriods():Int
        {
            return this._clubPastPeriods;
        }
public function  set_clubPastPeriods(k:Int):Int        {
            this._lastUpdated = flash.Lib.getTimer();
            this._clubPastPeriods = Std.int(Math.max(0, k));
return k;
        }

        
        public var clubHasEverBeenMember(get,set):Bool;
public function  get_clubHasEverBeenMember():Bool
        {
            return this._clubHasEverBeenMember;
        }
public function  set_clubHasEverBeenMember(k:Bool):Bool        {
            this._lastUpdated = flash.Lib.getTimer();
            return this._clubHasEverBeenMember = k;
        }

        
        public var isVIP(get,set):Bool;
public function  get_isVIP():Bool
        {
            return this._isVIP;
        }
public function  set_isVIP(k:Bool):Bool        {
            this._lastUpdated = flash.Lib.getTimer();
            return this._isVIP = k;
        }

        
        public var minutesUntilExpiration(get,set):Int;
public function  get_minutesUntilExpiration():Int
        {
            var k= Std.int((flash.Lib.getTimer() - this._lastUpdated) / (1000 * 60));
            var _local_2= (this._minutesUntilExpiration - k);
            return (_local_2 > 0) ? _local_2 : 0;
        }
public function  set_minutesUntilExpiration(k:Int):Int        {
            this._lastUpdated = flash.Lib.getTimer();
            return this._minutesUntilExpiration = k;
        }

        
        public var clubIsExpiring(get,set):Bool;
public function  get_clubIsExpiring():Bool
        {
            return this._isExpiring;
        }
public function  set_clubIsExpiring(k:Bool):Bool        {
            return this._isExpiring = k;
        }

        
        public var citizenshipVipIsExpiring(get,set):Bool;
public function  get_citizenshipVipIsExpiring():Bool
        {
            return this._isCitizenshipVipExpiring;
        }
public function  set_citizenshipVipIsExpiring(k:Bool):Bool        {
            return this._isCitizenshipVipExpiring = k;
        }

        
        public var minutesSinceLastModified(get,set):Int;
public function  get_minutesSinceLastModified():Int
        {
            return this._minutesSinceLastModified;
        }
public function  set_minutesSinceLastModified(k:Int):Int        {
            this._lastUpdated = flash.Lib.getTimer();
            return this._minutesSinceLastModified = k;
        }
public function new(){}
    }

