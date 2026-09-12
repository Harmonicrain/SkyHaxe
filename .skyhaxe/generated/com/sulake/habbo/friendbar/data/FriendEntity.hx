package com.sulake.habbo.friendbar.data
;

     class FriendEntity implements IFriendEntity 
    {
        static var ROLLING_LOG_EVENT_ID:Int = 0;

        var _id:Int = 0;
        var _name:String;
        var _gender:Int = 0;
        var _online:Bool = false;
        var _allowFollow:Bool = false;
        var _figure:String;
        var _categoryId:Int = 0;
        var _motto:String;
        var _lastAccess:String;
        var _realName:String;
        var _notifications:Vector<IFriendNotification>;
        var _logEventId:Int = -1;

        public function new(k:Int, _arg_2:String, _arg_3:String, _arg_4:String, _arg_5:Int, _arg_6:Bool, _arg_7:Bool, _arg_8:String, _arg_9:Int, _arg_10:String)
        {
            this._id = k;
            this._name = _arg_2;
            this._realName = _arg_3;
            this._motto = _arg_4;
            this._gender = _arg_5;
            this._online = _arg_6;
            this._allowFollow = _arg_7;
            this._figure = _arg_8;
            this._categoryId = _arg_9;
            this._lastAccess = _arg_10;
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }

        
        public var name(get,set):String;
public function  get_name():String
        {
            return this._name;
        }

        
        public var gender(get,set):Int;
public function  get_gender():Int
        {
            return this._gender;
        }

        
        public var online(get,set):Bool;
public function  get_online():Bool
        {
            return this._online;
        }

        
        public var allowFollow(get,set):Bool;
public function  get_allowFollow():Bool
        {
            return this._allowFollow;
        }

        
        public var figure(get,set):String;
public function  get_figure():String
        {
            return this._figure;
        }

        
        public var categoryId(get,set):Int;
public function  get_categoryId():Int
        {
            return this._categoryId;
        }

        
        public var motto(get,set):String;
public function  get_motto():String
        {
            return this._motto;
        }

        
        public var lastAccess(get,set):String;
public function  get_lastAccess():String
        {
            return this._lastAccess;
        }

        
        public var realName(get,set):String;
public function  get_realName():String
        {
            return this._realName;
        }

        
        public var logEventId(get,set):Int;
public function  get_logEventId():Int
        {
            return this._logEventId;
        }

        public var notifications(get,never):Vector<IFriendNotification>;
public function  get_notifications():Vector<IFriendNotification>
        {
            if (this._notifications == null)
            {
                this._notifications = new Vector<IFriendNotification>();
            }
            return this._notifications;
        }
public function  set_name(k:String):String        {
            return this._name = k;
        }
public function  set_gender(k:Int):Int        {
            return this._gender = k;
        }
public function  set_online(k:Bool):Bool        {
            return this._online = k;
        }
public function  set_allowFollow(k:Bool):Bool        {
            return this._allowFollow = k;
        }
public function  set_figure(k:String):String        {
            return this._figure = k;
        }
public function  set_categoryId(k:Int):Int        {
            return this._categoryId = k;
        }
public function  set_motto(k:String):String        {
            return this._motto = k;
        }
public function  set_lastAccess(k:String):String        {
            return this._lastAccess = k;
        }
public function  set_realName(k:String):String        {
            return this._realName = k;
        }
public function  set_logEventId(k:Int):Int        {
            return this._logEventId = k;
        }

        public function getNextLogEventId():Int
        {
            return ++ROLLING_LOG_EVENT_ID;
        }
    }

