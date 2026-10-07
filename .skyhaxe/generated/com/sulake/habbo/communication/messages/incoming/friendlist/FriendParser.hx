package com.sulake.habbo.communication.messages.incoming.friendlist
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class FriendParser 
    {
        var _id:Int = 0;
        var _name:String;
        var _gender:Int = 0;
        var _online:Bool = false;
        var _followingAllowed:Bool = false;
        var _figure:String;
        var _categoryId:Int = 0;
        var _motto:String;
        var _lastAccess:String;
        var _realName:String;
        var _facebookId:String;
        var _persistedMessageUser:Bool = false;
        var _vipMember:Bool = false;
        var _pocketHabboUser:Bool = false;
        var _relationshipStatus:Int = 0;

        public function new(k:IMessageDataWrapper)
        {
            this._id = k.readInteger();
            this._name = k.readString();
            this._gender = k.readInteger();
            this._online = k.readBoolean();
            this._followingAllowed = k.readBoolean();
            this._figure = k.readString();
            this._categoryId = k.readInteger();
            this._motto = k.readString();
            this._realName = k.readString();
            this._facebookId = k.readString();
            this._persistedMessageUser = k.readBoolean();
            this._vipMember = k.readBoolean();
            this._pocketHabboUser = k.readBoolean();
            this._relationshipStatus = k.readShort();
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }

        public var name(get,never):String;
public function  get_name():String
        {
            return this._name;
        }

        public var gender(get,never):Int;
public function  get_gender():Int
        {
            return this._gender;
        }

        public var online(get,never):Bool;
public function  get_online():Bool
        {
            return this._online;
        }

        public var followingAllowed(get,never):Bool;
public function  get_followingAllowed():Bool
        {
            return this._followingAllowed;
        }

        public var figure(get,never):String;
public function  get_figure():String
        {
            return this._figure;
        }

        public var categoryId(get,never):Int;
public function  get_categoryId():Int
        {
            return this._categoryId;
        }

        public var motto(get,never):String;
public function  get_motto():String
        {
            return this._motto;
        }

        public var lastAccess(get,never):String;
public function  get_lastAccess():String
        {
            return this._lastAccess;
        }

        public var realName(get,never):String;
public function  get_realName():String
        {
            return this._realName;
        }

        public var facebookId(get,never):String;
public function  get_facebookId():String
        {
            return this._facebookId;
        }

        public var persistedMessageUser(get,never):Bool;
public function  get_persistedMessageUser():Bool
        {
            return this._persistedMessageUser;
        }

        public var vipMember(get,never):Bool;
public function  get_vipMember():Bool
        {
            return this._vipMember;
        }

        public var pocketHabboUser(get,never):Bool;
public function  get_pocketHabboUser():Bool
        {
            return this._pocketHabboUser;
        }

        public var relationshipStatus(get,never):Int;
public function  get_relationshipStatus():Int
        {
            return this._relationshipStatus;
        }
    }

