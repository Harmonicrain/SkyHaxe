package com.sulake.habbo.ui.widget.avatarinfo
;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUserInfoUpdateEvent;

     class AvatarInfoData 
    {
        var _isIgnored:Bool = false;
        var _canTrade:Bool = false;
        var _canTradeReason:Int = 0;
        var _canBeKicked:Bool = false;
        var _canBeBanned:Bool = false;
        var _canBeMuted:Bool = false;
        var _canBeAskedAsFriend:Bool = false;
        var _amIOwner:Bool = false;
        var _amIAnyRoomController:Bool = false;
        var _respectLeft:Int = 0;
        var _isOwnUser:Bool = false;
        var _allowNameChange:Bool = false;
        var _isGuildRoom:Bool = false;
        var _carryItemType:Int = 0;
        var _myRoomControllerLevel:Int = 0;
        var _targetRoomControllerLevel:Int = 0;
        var _isFriend:Bool = false;
        var _isAmbassador:Bool = false;


        
        public var isIgnored(get,set):Bool;
public function  get_isIgnored():Bool
        {
            return this._isIgnored;
        }

        
        public var canTrade(get,set):Bool;
public function  get_canTrade():Bool
        {
            return this._canTrade;
        }

        
        public var canTradeReason(get,set):Int;
public function  get_canTradeReason():Int
        {
            return this._canTradeReason;
        }

        
        public var canBeKicked(get,set):Bool;
public function  get_canBeKicked():Bool
        {
            return this._canBeKicked;
        }

        
        public var canBeBanned(get,set):Bool;
public function  get_canBeBanned():Bool
        {
            return this._canBeBanned;
        }

        
        public var canBeAskedForAFriend(get,set):Bool;
public function  get_canBeAskedForAFriend():Bool
        {
            return this._canBeAskedAsFriend;
        }

        
        public var amIOwner(get,set):Bool;
public function  get_amIOwner():Bool
        {
            return this._amIOwner;
        }

        
        public var amIAnyRoomController(get,set):Bool;
public function  get_amIAnyRoomController():Bool
        {
            return this._amIAnyRoomController;
        }

        
        public var petRespectLeft(get,set):Int;
public function  get_petRespectLeft():Int
        {
            return this._respectLeft;
        }

        
        public var isOwnUser(get,set):Bool;
public function  get_isOwnUser():Bool
        {
            return this._isOwnUser;
        }

        
        public var allowNameChange(get,set):Bool;
public function  get_allowNameChange():Bool
        {
            return this._allowNameChange;
        }

        
        public var isGuildRoom(get,set):Bool;
public function  get_isGuildRoom():Bool
        {
            return this._isGuildRoom;
        }

        
        public var carryItemType(get,set):Int;
public function  get_carryItemType():Int
        {
            return this._carryItemType;
        }

        
        public var myRoomControllerLevel(get,set):Int;
public function  get_myRoomControllerLevel():Int
        {
            return this._myRoomControllerLevel;
        }

        
        public var targetRoomControllerLevel(get,set):Int;
public function  get_targetRoomControllerLevel():Int
        {
            return this._targetRoomControllerLevel;
        }
public function  set_isIgnored(k:Bool):Bool        {
            return this._isIgnored = k;
        }
public function  set_canTrade(k:Bool):Bool        {
            return this._canTrade = k;
        }
public function  set_canTradeReason(k:Int):Int        {
            return this._canTradeReason = k;
        }
public function  set_canBeKicked(k:Bool):Bool        {
            return this._canBeKicked = k;
        }
public function  set_canBeBanned(k:Bool):Bool        {
            return this._canBeBanned = k;
        }

        
        public var canBeMuted(get,set):Bool;
public function  get_canBeMuted():Bool
        {
            return this._canBeMuted;
        }
public function  set_canBeMuted(k:Bool):Bool        {
            return this._canBeMuted = k;
        }
public function  set_canBeAskedForAFriend(k:Bool):Bool        {
            return this._canBeAskedAsFriend = k;
        }
public function  set_amIOwner(k:Bool):Bool        {
            return this._amIOwner = k;
        }
public function  set_amIAnyRoomController(k:Bool):Bool        {
            return this._amIAnyRoomController = k;
        }
public function  set_petRespectLeft(k:Int):Int        {
            return this._respectLeft = k;
        }
public function  set_isOwnUser(k:Bool):Bool        {
            return this._isOwnUser = k;
        }
public function  set_allowNameChange(k:Bool):Bool        {
            return this._allowNameChange = k;
        }
public function  set_isGuildRoom(k:Bool):Bool        {
            return this._isGuildRoom = k;
        }
public function  set_carryItemType(k:Int):Int        {
            return this._carryItemType = k;
        }
public function  set_myRoomControllerLevel(k:Int):Int        {
            return this._myRoomControllerLevel = k;
        }
public function  set_targetRoomControllerLevel(k:Int):Int        {
            return this._targetRoomControllerLevel = k;
        }

        public var isFriend(get,never):Bool;
public function  get_isFriend():Bool
        {
            return this._isFriend;
        }

        public var isAmbassador(get,never):Bool;
public function  get_isAmbassador():Bool
        {
            return this._isAmbassador;
        }

        public function populate(k:RoomWidgetUserInfoUpdateEvent)
        {
            this._amIAnyRoomController = k.amIAnyRoomController;
            this._myRoomControllerLevel = k.myRoomControllerLevel;
            this._amIOwner = k.amIOwner;
            this._canBeAskedAsFriend = k.canBeAskedAsFriend;
            this._canBeKicked = k.canBeKicked;
            this._canBeBanned = k.canBeBanned;
            this._canBeMuted = k.canBeMuted;
            this._canTrade = k.canTrade;
            this._canTradeReason = k.canTradeReason;
            this._isIgnored = k.isIgnored;
            this._respectLeft = k.respectLeft;
            this._isOwnUser = (k.type == RoomWidgetUserInfoUpdateEvent.OWN_USER);
            this._allowNameChange = k.allowNameChange;
            this._isGuildRoom = k.isGuildRoom;
            this._targetRoomControllerLevel = k.targetRoomControllerLevel;
            this._carryItemType = k.carryItem;
            this._isFriend = k.isFriend;
            this._isAmbassador = k.amIAnAmbassador;
        }
public function new(){}
    }

