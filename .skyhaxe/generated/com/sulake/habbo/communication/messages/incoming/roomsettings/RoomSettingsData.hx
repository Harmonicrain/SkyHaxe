package com.sulake.habbo.communication.messages.incoming.roomsettings
;

     class RoomSettingsData 
    {
        public static inline final DOORMODE_OPEN= 0;
        public static inline final DOORMODE_CLOSED= 1;
        public static inline final DOORMODE_PASSWORD= 2;
        public static inline final DOORMODE_INVISIBLE= 3;
        public static inline final DOORMODE_NOOBS_ONLY= 4;
        public static inline final TRADEMODE_NOT_ALLOWED= 0;
        public static inline final TRADEMODE_WITH_CONTROLLER= 1;
        public static inline final TRADEMODE_ALLOWED= 2;

        var _roomId:Int = 0;
        var _name:String;
        var _description:String;
        var _doorMode:Int = 0;
        var _categoryId:Int = 0;
        var _maximumVisitors:Int = 0;
        var _maximumVisitorsLimit:Int = 0;
        var _tags:Array<ASAny>;
        var _tradeMode:Int = 0;
        var _allowPets:Bool = false;
        var _allowFoodConsume:Bool = false;
        var _allowWalkThrough:Bool = false;
        var _hideWalls:Bool = false;
        var _wallThickness:Int = 0;
        var _floorThickness:Int = 0;
        var _controllersById:ASDictionary<ASAny,ASAny>;
        var _controllerList:Array<ASAny>;
        var _highlightedUserId:Int = 0;
        var _bannedUsersById:ASDictionary<ASAny,ASAny>;
        var _bannedUsersList:Array<ASAny>;
        var _roomModerationSettings:RoomModerationSettings;
        var _chatSettings:RoomChatSettings;
        var _allowNavigatorDynamicCats:Bool = false;


        public static function _Str_26097(k:Int):String
        {
            switch (k)
            {
                case DOORMODE_OPEN:
                    return "${navigator.door.mode.open}";
                case DOORMODE_CLOSED:
                    return "${navigator.door.mode.closed}";
                case DOORMODE_PASSWORD:
                    return "${navigator.door.mode.password}";
                case DOORMODE_INVISIBLE:
                    return "${navigator.door.mode.invisible}";
                case DOORMODE_NOOBS_ONLY:
                    return "${navigator.door.mode.noobs_only}";
            }
            return "";
        }


        
        public var tradeMode(get,set):Int;
public function  get_tradeMode():Int
        {
            return this._tradeMode;
        }
public function  set_tradeMode(k:Int):Int        {
            return this._tradeMode = k;
        }

        
        public var allowPets(get,set):Bool;
public function  get_allowPets():Bool
        {
            return this._allowPets;
        }
public function  set_allowPets(k:Bool):Bool        {
            return this._allowPets = k;
        }

        
        public var allowFoodConsume(get,set):Bool;
public function  get_allowFoodConsume():Bool
        {
            return this._allowFoodConsume;
        }
public function  set_allowFoodConsume(k:Bool):Bool        {
            return this._allowFoodConsume = k;
        }

        
        public var allowWalkThrough(get,set):Bool;
public function  get_allowWalkThrough():Bool
        {
            return this._allowWalkThrough;
        }
public function  set_allowWalkThrough(k:Bool):Bool        {
            return this._allowWalkThrough = k;
        }

        
        public var hideWalls(get,set):Bool;
public function  get_hideWalls():Bool
        {
            return this._hideWalls;
        }
public function  set_hideWalls(k:Bool):Bool        {
            return this._hideWalls = k;
        }

        
        public var wallThickness(get,set):Int;
public function  get_wallThickness():Int
        {
            return this._wallThickness;
        }
public function  set_wallThickness(k:Int):Int        {
            return this._wallThickness = k;
        }

        
        public var floorThickness(get,set):Int;
public function  get_floorThickness():Int
        {
            return this._floorThickness;
        }
public function  set_floorThickness(k:Int):Int        {
            return this._floorThickness = k;
        }

        
        public var roomId(get,set):Int;
public function  get_roomId():Int
        {
            return this._roomId;
        }
public function  set_roomId(k:Int):Int        {
            return this._roomId = k;
        }

        
        public var name(get,set):String;
public function  get_name():String
        {
            return this._name;
        }
public function  set_name(k:String):String        {
            return this._name = k;
        }

        
        public var description(get,set):String;
public function  get_description():String
        {
            return this._description;
        }
public function  set_description(k:String):String        {
            return this._description = k;
        }

        
        public var doorMode(get,set):Int;
public function  get_doorMode():Int
        {
            return this._doorMode;
        }
public function  set_doorMode(k:Int):Int        {
            return this._doorMode = k;
        }

        
        public var categoryId(get,set):Int;
public function  get_categoryId():Int
        {
            return this._categoryId;
        }
public function  set_categoryId(k:Int):Int        {
            return this._categoryId = k;
        }

        
        public var maximumVisitors(get,set):Int;
public function  get_maximumVisitors():Int
        {
            return this._maximumVisitors;
        }
public function  set_maximumVisitors(k:Int):Int        {
            return this._maximumVisitors = k;
        }

        
        public var _Str_13128(get,set):Int;
public function  get__Str_13128():Int
        {
            return this._maximumVisitorsLimit;
        }
public function  set__Str_13128(k:Int):Int        {
            return this._maximumVisitorsLimit = k;
        }

        
        public var tags(get,set):Array<ASAny>;
public function  get_tags():Array<ASAny>
        {
            return this._tags;
        }
public function  set_tags(k:Array<ASAny>):Array<ASAny>        {
            return this._tags = k;
        }

        public function _Str_17474(k:Int, _arg_2:FlatControllerData)
        {
            if (this._controllersById != null)
            {
                this._controllersById[k] = _arg_2;
                this._controllerList = null;
                this._highlightedUserId = k;
            }
        }

        
        public var roomModerationSettings(get,set):RoomModerationSettings;
public function  get_roomModerationSettings():RoomModerationSettings
        {
            return this._roomModerationSettings;
        }
public function  set_roomModerationSettings(k:RoomModerationSettings):RoomModerationSettings        {
            return this._roomModerationSettings = k;
        }

        
        public var _Str_13003(get,set):ASDictionary<ASAny,ASAny>;
public function  get__Str_13003():ASDictionary<ASAny,ASAny>
        {
            return this._controllersById;
        }
public function  set__Str_13003(k:ASDictionary<ASAny,ASAny>):ASDictionary<ASAny,ASAny>        {
            return this._controllersById = k;
        }

        public var controllerList(get,never):Array<ASAny>;
public function  get_controllerList():Array<ASAny>
        {
var k:String  = null;            var k:String = null;
            var _local_2 = 0;
            var _local_3:FlatControllerData = null;
            if (this._controllerList == null)
            {
                this._controllerList = new Array<ASAny>();
                final _iter_ = this._controllersById; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
                {
k = _tmp_;
                    _local_2 = ASCompat.toInt(k);
                    _local_3 = this._controllersById[_local_2];
                    if (_local_3 != null)
                    {
                        this._controllerList.push(_local_3);
                    }
                }
                ASCompat.ASArray.sortOn(this._controllerList, "userName", ASCompat.ASArray.CASEINSENSITIVE);
            }
            return this._controllerList;
        }

        public var highlightedUserId(get,never):Int;
public function  get_highlightedUserId():Int
        {
            return this._highlightedUserId;
        }

        public function _Str_22019(k:Int, _arg_2:BannedUserData)
        {
            if (this._bannedUsersById == null)
            {
                this._bannedUsersById = new ASDictionary<ASAny,ASAny>();
            }
            else
            {
                this._bannedUsersList = null;
            }
            this._bannedUsersById[k] = _arg_2;
        }

        public var bannedUsersById(get,never):ASDictionary<ASAny,ASAny>;
public function  get_bannedUsersById():ASDictionary<ASAny,ASAny>
        {
            return this._bannedUsersById;
        }

        public var bannedUsersList(get,never):Array<ASAny>;
public function  get_bannedUsersList():Array<ASAny>
        {
            var k:BannedUserData = null;
            if (this._bannedUsersList == null)
            {
                this._bannedUsersList = new Array<ASAny>();
                final _iter_ = this._bannedUsersById; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
k  = _tmp_;
                    this._bannedUsersList.push(k);
                }
                ASCompat.ASArray.sortOn(this._bannedUsersList, "userName", ASCompat.ASArray.CASEINSENSITIVE);
            }
            return this._bannedUsersList;
        }

        
        public var chatSettings(get,set):RoomChatSettings;
public function  get_chatSettings():RoomChatSettings
        {
            return this._chatSettings;
        }
public function  set_chatSettings(k:RoomChatSettings):RoomChatSettings        {
            return this._chatSettings = k;
        }

        
        public var _Str_17884(get,set):Bool;
public function  get__Str_17884():Bool
        {
            return this._allowNavigatorDynamicCats;
        }
public function  set__Str_17884(k:Bool):Bool        {
            return this._allowNavigatorDynamicCats = k;
        }
public function new(){}
    }

