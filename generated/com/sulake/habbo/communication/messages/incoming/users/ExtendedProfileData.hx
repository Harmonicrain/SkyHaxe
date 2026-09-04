package com.sulake.habbo.communication.messages.incoming.users
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ExtendedProfileData 
    {
        var _userId:Int = 0;
        var _userName:String;
        var _figure:String;
        var _motto:String;
        var _creationDate:String;
        var _achievementScore:Int = 0;
        var _friendCount:Int = 0;
        var _isFriend:Bool = false;
        var _isFriendRequestSent:Bool = false;
        var _isOnline:Bool = false;
        var _guilds:Array<ASAny>;
        var _lastAccessSinceInSeconds:Int = 0;
        var _openProfileWindow:Bool = false;

        public function new(k:IMessageDataWrapper)
        {
            this._guilds = new Array<ASAny>();
            this._userId = k.readInteger();
            this._userName = k.readString();
            this._figure = k.readString();
            this._motto = k.readString();
            this._creationDate = k.readString();
            this._achievementScore = k.readInteger();
            this._friendCount = k.readInteger();
            this._isFriend = k.readBoolean();
            this._isFriendRequestSent = k.readBoolean();
            this._isOnline = k.readBoolean();
            var guildCount= k.readInteger();
            var counter = 0;
            while (counter < guildCount)
            {
                this._guilds.push(new HabboGroupEntryData(k));
                counter++;
            }
            this._lastAccessSinceInSeconds = k.readInteger();
            this._openProfileWindow = k.readBoolean();
        }

        public var userId(get,never):Int;
function  get_userId():Int
        {
            return this._userId;
        }

        public var userName(get,never):String;
function  get_userName():String
        {
            return this._userName;
        }

        public var motto(get,never):String;
function  get_motto():String
        {
            return this._motto;
        }

        public var figure(get,never):String;
function  get_figure():String
        {
            return this._figure;
        }

        public var creationDate(get,never):String;
function  get_creationDate():String
        {
            return this._creationDate;
        }

        public var activityPoints(get,never):Int;
function  get_activityPoints():Int
        {
            return this._achievementScore;
        }

        public var friendCount(get,never):Int;
function  get_friendCount():Int
        {
            return this._friendCount;
        }

        public var isFriend(get,never):Bool;
function  get_isFriend():Bool
        {
            return this._isFriend;
        }

        
        public var isRequestFriend(get,set):Bool;
function  get_isRequestFriend():Bool
        {
            return this._isFriendRequestSent;
        }

        public var online(get,never):Bool;
function  get_online():Bool
        {
            return this._isOnline;
        }

        public var guilds(get,never):Array<ASAny>;
function  get_guilds():Array<ASAny>
        {
            return this._guilds;
        }
function  set_isRequestFriend(k:Bool):Bool        {
            return this._isFriendRequestSent = k;
        }

        public var lastAccessSinceInSeconds(get,never):Int;
function  get_lastAccessSinceInSeconds():Int
        {
            return this._lastAccessSinceInSeconds;
        }

        public var openProfileWindow(get,never):Bool;
function  get_openProfileWindow():Bool
        {
            return this._openProfileWindow;
        }
    }

