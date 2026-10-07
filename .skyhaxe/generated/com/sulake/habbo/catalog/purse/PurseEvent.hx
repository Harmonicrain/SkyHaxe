package com.sulake.habbo.catalog.purse
;
    import flash.events.Event;

     class PurseEvent extends Event 
    {
        public static inline final CATALOG_PURSE_CREDIT_BALANCE= "catalog_purse_credit_balance";
        public static inline final CATALOG_PURSE_ACTIVITY_POINT_BALANCE= "catalog_purse_activity_point_balance";

        var _balance:Int = 0;
        var _activityPointType:Int = 0;

        public function new(k:String, balance:Int, activityPointType:Int, _arg_4:Bool=false, _arg_5:Bool=false)
        {
            super(k, _arg_4, _arg_5);
            this._balance = balance;
            this._activityPointType = activityPointType;
        }

        public var balance(get,never):Int;
public function  get_balance():Int
        {
            return this._balance;
        }

        public var activityPointType(get,never):Int;
public function  get_activityPointType():Int
        {
            return this._activityPointType;
        }
    }

