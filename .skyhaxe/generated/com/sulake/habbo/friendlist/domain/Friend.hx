package com.sulake.habbo.friendlist.domain
;
    import com.sulake.habbo.friendlist.IFriend;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindowContainer;
    import flash.display.BitmapData;
    import com.sulake.habbo.communication.messages.incoming.friendlist.FriendParser;

     class Friend implements IFriend implements  IDisposable 
    {
        public static final _Str_1997:Int = "F".charCodeAt(0);
        public static final _Str_1139:Int = "M".charCodeAt(0);

        var _id:Int = 0;
        var _name:String;
        var _gender:Int = 0;
        var _online:Bool = false;
        var _followingAllowed:Bool = false;
        var _figure:String;
        var _motto:String;
        var _lastAccess:String;
        var _categoryId:Int = 0;
        var _selected:Bool = false;
        var _disposed:Bool = false;
        var _view:IWindowContainer;
        var _face:BitmapData;
        var _realName:String;
        var _persistedMessageUser:Bool = false;
        var _pocketHabboUser:Bool = false;
        var _vipMember:Bool = false;
        var _relationshipStatus:Int = 0;

        public function new(k:FriendParser)
        {
            if (k == null)
            {
                return;
            }
            this._id = k.id;
            this._name = k.name;
            this._gender = k.gender;
            this._online = k.online;
            this._followingAllowed = (k.followingAllowed && k.online);
            this._figure = k.figure;
            this._motto = k.motto;
            this._lastAccess = k.lastAccess;
            this._categoryId = k.categoryId;
            this._realName = k.realName;
            this._persistedMessageUser = k.persistedMessageUser;
            this._vipMember = k.vipMember;
            this._pocketHabboUser = k.pocketHabboUser;
            this._relationshipStatus = k.relationshipStatus;
            Logger.log([((((((((((((("Creating friend: " + Std.string(this.id)) + ", ") + this.name) + ", ") + Std.string(this.gender)) + ", ") + Std.string(this.online)) + ", ") + Std.string(this.followingAllowed)) + ", ") + this.figure) + ", ") + Std.string(this.categoryId))]);
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            if (this._face != null)
            {
                this._face.dispose();
                this._face = null;
            }
            this._disposed = true;
            this._view = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        
        public var id(get,set):Int;
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

        
        public var followingAllowed(get,set):Bool;
public function  get_followingAllowed():Bool
        {
            return this._followingAllowed;
        }

        
        public var figure(get,set):String;
public function  get_figure():String
        {
            return this._figure;
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

        
        public var categoryId(get,set):Int;
public function  get_categoryId():Int
        {
            return this._categoryId;
        }

        
        public var selected(get,set):Bool;
public function  get_selected():Bool
        {
            return this._selected;
        }

        
        public var view(get,set):IWindowContainer;
public function  get_view():IWindowContainer
        {
            return this._view;
        }

        
        public var face(get,set):BitmapData;
public function  get_face():BitmapData
        {
            return this._face;
        }

        
        public var realName(get,set):String;
public function  get_realName():String
        {
            return this._realName;
        }

        
        public var persistedMessageUser(get,set):Bool;
public function  get_persistedMessageUser():Bool
        {
            return this._persistedMessageUser;
        }

        
        public var pocketHabboUser(get,set):Bool;
public function  get_pocketHabboUser():Bool
        {
            return this._pocketHabboUser;
        }

        public var relationshipStatus(get,never):Int;
public function  get_relationshipStatus():Int
        {
            return this._relationshipStatus;
        }

        
        public var vipMember(get,set):Bool;
public function  get_vipMember():Bool
        {
            return this._vipMember;
        }
public function  set_id(k:Int):Int        {
            return this._id = k;
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
public function  set_followingAllowed(k:Bool):Bool        {
            return this._followingAllowed = k;
        }
public function  set_figure(k:String):String        {
            return this._figure = k;
        }
public function  set_motto(k:String):String        {
            return this._motto = k;
        }
public function  set_lastAccess(k:String):String        {
            return this._lastAccess = k;
        }
public function  set_categoryId(k:Int):Int        {
            return this._categoryId = k;
        }
public function  set_selected(k:Bool):Bool        {
            return this._selected = k;
        }
public function  set_view(k:IWindowContainer):IWindowContainer        {
            return this._view = k;
        }
public function  set_face(k:BitmapData):BitmapData        {
            return this._face = k;
        }
public function  set_realName(k:String):String        {
            return this._realName = k;
        }
public function  set_persistedMessageUser(k:Bool):Bool        {
            return this._persistedMessageUser = k;
        }
public function  set_pocketHabboUser(k:Bool):Bool        {
            return this._pocketHabboUser = k;
        }
public function  set_vipMember(k:Bool):Bool        {
            return this._vipMember = k;
        }

        public function _Str_19416():Bool
        {
            return this._id < 0;
        }
    }

