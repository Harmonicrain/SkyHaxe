package com.sulake.habbo.communication.messages.parser.users
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ScrSendUserInfoMessageParser implements IMessageParser
    {
        public static inline final RESPONSE_TYPE_LOGIN= 1;
        public static inline final RESPONSE_TYPE_PURCHASE= 2;
        public static inline final RESPONSE_TYPE_DISCOUNT_AVAILABLE= 3;
        public static inline final RESPONSE_TYPE_CITIZENSHIP_DISCOUNT= 4;

        var _productName:String;
        var _daysToPeriodEnd:Int = 0;
        var _memberPeriods:Int = 0;
        var _periodsSubscribedAhead:Int = 0;
        var _responseType:Int = 0;
        var _hasEverBeenMember:Bool = false;
        var _isVIP:Bool = false;
        var _pastClubDays:Int = 0;
        var _pastVipDays:Int = 0;
        var _minutesUntilExpiration:Int = 0;
        var _minutesSinceLastModified:Int = 0;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._productName = k.readString();
            this._daysToPeriodEnd = k.readInteger();
            this._memberPeriods = k.readInteger();
            this._periodsSubscribedAhead = k.readInteger();
            this._responseType = k.readInteger();
            this._hasEverBeenMember = k.readBoolean();
            this._isVIP = k.readBoolean();
            this._pastClubDays = k.readInteger();
            this._pastVipDays = k.readInteger();
            this._minutesUntilExpiration = k.readInteger();
            if (k.bytesAvailable != 0)
            {
                this._minutesSinceLastModified = k.readInteger();
            }
            return true;
        }

        public var productName(get,never):String;
function  get_productName():String
        {
            return this._productName;
        }

        public var daysToPeriodEnd(get,never):Int;
function  get_daysToPeriodEnd():Int
        {
            return this._daysToPeriodEnd;
        }

        public var memberPeriods(get,never):Int;
function  get_memberPeriods():Int
        {
            return this._memberPeriods;
        }

        public var periodsSubscribedAhead(get,never):Int;
function  get_periodsSubscribedAhead():Int
        {
            return this._periodsSubscribedAhead;
        }

        public var responseType(get,never):Int;
function  get_responseType():Int
        {
            return this._responseType;
        }

        public var hasEverBeenMember(get,never):Bool;
function  get_hasEverBeenMember():Bool
        {
            return this._hasEverBeenMember;
        }

        public var isVIP(get,never):Bool;
function  get_isVIP():Bool
        {
            return this._isVIP;
        }

        public var pastClubDays(get,never):Int;
function  get_pastClubDays():Int
        {
            return this._pastClubDays;
        }

        public var pastVipDays(get,never):Int;
function  get_pastVipDays():Int
        {
            return this._pastVipDays;
        }

        public var minutesUntilExpiration(get,never):Int;
function  get_minutesUntilExpiration():Int
        {
            return this._minutesUntilExpiration;
        }

        public var minutesSinceLastModified(get,never):Int;
function  get_minutesSinceLastModified():Int
        {
            return this._minutesSinceLastModified;
        }

	public function new() {}
    }

