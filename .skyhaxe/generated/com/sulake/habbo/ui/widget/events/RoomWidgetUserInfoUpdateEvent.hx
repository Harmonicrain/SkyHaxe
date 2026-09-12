package com.sulake.habbo.ui.widget.events
;
     class RoomWidgetUserInfoUpdateEvent extends RoomWidgetUpdateEvent
    {
        public static inline final OWN_USER= "RWUIUE_OWN_USER";
        public static inline final BOT= "RWUIUE_BOT";
        public static inline final PEER= "RWUIUE_PEER";
        public static inline final TRADE_REASON_OK= 0;
        public static inline final TRADE_REASON_SHUTDOWN= 2;
        public static inline final TRADE_REASON_NO_TRADINGROOM= 3;
        public static inline final DEFAULT_BOT_BADGE_ID= "BOT";

        var _name:String = "";
        var _motto:String = "";
        var _activityPoints:Int = 0;
        var _id:Int = 0;
        var _xp:Int = 0;
        var _userType:Int = 0;
        var _figure:String = "";
        var _badges:Array<ASAny>;
        var _groupId:Int = 0;
        var _groupName:String = "";
        var _groupBadgeId:String = "";
        var _carryItem:Int = 0;
        var _userRoomId:Int = 0;
        var _isSpectatorMode:Bool = false;
        var _realName:String = "";
        var _allowNameChange:Bool = false;
        var _amIOwner:Bool = false;
        var _amIAnyRoomController:Bool = false;
        var _myRoomControllerLevel:Int = 0;
        var _canBeAskedAsFriend:Bool = false;
        var _canBeKicked:Bool = false;
        var _canBeBanned:Bool = false;
        var _canBeMuted:Bool = false;
        var _respectLeft:Int = 0;
        var _isIgnored:Bool = false;
        var _isGuildRoom:Bool = false;
        var _canTrade:Bool = false;
        var _canTradeReason:Int = 0;
        var _targetRoomControllerLevel:Int = 0;
        var _isFriend:Bool = false;
        var _isAmbassador:Bool = false;

        public function new(k:String, _arg_2:Bool=false, _arg_3:Bool=false)
        {
            this._badges = [];
            super(k, _arg_2, _arg_3);
        }

        
        public var name(get,set):String;
public function  set_name(k:String):String        {
            return this._name = k;
        }
public function  get_name():String
        {
            return this._name;
        }

        
        public var motto(get,set):String;
public function  set_motto(k:String):String        {
            return this._motto = k;
        }
public function  get_motto():String
        {
            return this._motto;
        }

        
        public var activityPoints(get,set):Int;
public function  set_activityPoints(k:Int):Int        {
            return this._activityPoints = k;
        }
public function  get_activityPoints():Int
        {
            return this._activityPoints;
        }

        
        public var id(get,set):Int;
public function  set_id(k:Int):Int        {
            return this._id = k;
        }
public function  get_id():Int
        {
            return this._id;
        }

        
        public var xp(get,set):Int;
public function  set_xp(k:Int):Int        {
            return this._xp = k;
        }
public function  get_xp():Int
        {
            return this._xp;
        }

        
        public var userType(get,set):Int;
public function  set_userType(k:Int):Int        {
            return this._userType = k;
        }
public function  get_userType():Int
        {
            return this._userType;
        }

        
        public var figure(get,set):String;
public function  set_figure(k:String):String        {
            return this._figure = k;
        }
public function  get_figure():String
        {
            return this._figure;
        }

        
        public var badges(get,set):Array<ASAny>;
public function  set_badges(k:Array<ASAny>):Array<ASAny>        {
            return this._badges = k;
        }
public function  get_badges():Array<ASAny>
        {
            return this._badges;
        }

        
        public var groupId(get,set):Int;
public function  set_groupId(k:Int):Int        {
            return this._groupId = k;
        }
public function  get_groupId():Int
        {
            return this._groupId;
        }

        
        public var groupName(get,set):String;
public function  set_groupName(k:String):String        {
            return this._groupName = k;
        }
public function  get_groupName():String
        {
            return this._groupName;
        }

        
        public var groupBadgeId(get,set):String;
public function  set_groupBadgeId(k:String):String        {
            return this._groupBadgeId = k;
        }
public function  get_groupBadgeId():String
        {
            return this._groupBadgeId;
        }

        
        public var canBeAskedAsFriend(get,set):Bool;
public function  set_canBeAskedAsFriend(k:Bool):Bool        {
            return this._canBeAskedAsFriend = k;
        }
public function  get_canBeAskedAsFriend():Bool
        {
            return this._canBeAskedAsFriend;
        }

        
        public var respectLeft(get,set):Int;
public function  set_respectLeft(k:Int):Int        {
            return this._respectLeft = k;
        }
public function  get_respectLeft():Int
        {
            return this._respectLeft;
        }

        
        public var isIgnored(get,set):Bool;
public function  set_isIgnored(k:Bool):Bool        {
            return this._isIgnored = k;
        }
public function  get_isIgnored():Bool
        {
            return this._isIgnored;
        }

        
        public var amIOwner(get,set):Bool;
public function  set_amIOwner(k:Bool):Bool        {
            return this._amIOwner = k;
        }
public function  get_amIOwner():Bool
        {
            return this._amIOwner;
        }

        
        public var isGuildRoom(get,set):Bool;
public function  set_isGuildRoom(k:Bool):Bool        {
            return this._isGuildRoom = k;
        }
public function  get_isGuildRoom():Bool
        {
            return this._isGuildRoom;
        }

        
        public var myRoomControllerLevel(get,set):Int;
public function  set_myRoomControllerLevel(k:Int):Int        {
            return this._myRoomControllerLevel = k;
        }
public function  get_myRoomControllerLevel():Int
        {
            return this._myRoomControllerLevel;
        }

        
        public var amIAnyRoomController(get,set):Bool;
public function  set_amIAnyRoomController(k:Bool):Bool        {
            return this._amIAnyRoomController = k;
        }
public function  get_amIAnyRoomController():Bool
        {
            return this._amIAnyRoomController;
        }

        
        public var canTrade(get,set):Bool;
public function  set_canTrade(k:Bool):Bool        {
            return this._canTrade = k;
        }
public function  get_canTrade():Bool
        {
            return this._canTrade;
        }

        
        public var canTradeReason(get,set):Int;
public function  set_canTradeReason(k:Int):Int        {
            return this._canTradeReason = k;
        }
public function  get_canTradeReason():Int
        {
            return this._canTradeReason;
        }

        
        public var canBeKicked(get,set):Bool;
public function  set_canBeKicked(k:Bool):Bool        {
            return this._canBeKicked = k;
        }
public function  get_canBeKicked():Bool
        {
            return this._canBeKicked;
        }

        
        public var canBeBanned(get,set):Bool;
public function  set_canBeBanned(k:Bool):Bool        {
            return this._canBeBanned = k;
        }
public function  get_canBeBanned():Bool
        {
            return this._canBeBanned;
        }

        
        public var canBeMuted(get,set):Bool;
public function  get_canBeMuted():Bool
        {
            return this._canBeMuted;
        }
public function  set_canBeMuted(k:Bool):Bool        {
            return this._canBeMuted = k;
        }

        
        public var targetRoomControllerLevel(get,set):Int;
public function  set_targetRoomControllerLevel(k:Int):Int        {
            return this._targetRoomControllerLevel = k;
        }
public function  get_targetRoomControllerLevel():Int
        {
            return this._targetRoomControllerLevel;
        }

        
        public var carryItem(get,set):Int;
public function  set_carryItem(k:Int):Int        {
            return this._carryItem = k;
        }
public function  get_carryItem():Int
        {
            return this._carryItem;
        }

        
        public var userRoomId(get,set):Int;
public function  set_userRoomId(k:Int):Int        {
            return this._userRoomId = k;
        }
public function  get_userRoomId():Int
        {
            return this._userRoomId;
        }

        
        public var isSpectatorMode(get,set):Bool;
public function  set_isSpectatorMode(k:Bool):Bool        {
            return this._isSpectatorMode = k;
        }
public function  get_isSpectatorMode():Bool
        {
            return this._isSpectatorMode;
        }

        
        public var realName(get,set):String;
public function  set_realName(k:String):String        {
            return this._realName = k;
        }
public function  get_realName():String
        {
            return this._realName;
        }

        
        public var allowNameChange(get,set):Bool;
public function  set_allowNameChange(k:Bool):Bool        {
            return this._allowNameChange = k;
        }
public function  get_allowNameChange():Bool
        {
            return this._allowNameChange;
        }

        
        public var isFriend(get,set):Bool;
public function  get_isFriend():Bool
        {
            return this._isFriend;
        }
public function  set_isFriend(k:Bool):Bool        {
            return this._isFriend = k;
        }

        
        public var amIAnAmbassador(get,set):Bool;
public function  get_amIAnAmbassador():Bool
        {
            return this._isAmbassador;
        }
public function  set_amIAnAmbassador(k:Bool):Bool        {
            return this._isAmbassador = k;
        }
    }

