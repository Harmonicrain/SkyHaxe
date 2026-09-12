package com.sulake.habbo.communication.messages.parser.groupforums
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class GuildForumThread 
    {
        var _threadId:Int = 0;
        var _authorId:Int = 0;
        var _authorName:String;
        var _creationTime:Int = 0;
        var _header:String;
        var _totalMessages:Int = 0;
        var _unreadMessagesCount:Int = 0;
        var _Str_6301:Int = 0;
        var _lastUserId:Int = 0;
        var _lastUserName:String;
        var _lastCommentTime:Int = 0;
        var _state:Int = 0;
        var _adminId:Int = 0;
        var _adminName:String;
        var _unknownInt:Int = 0;
        var _isPinned:Bool = false;
        var _isLocked:Bool = false;


        public static function parse(k:IMessageDataWrapper):GuildForumThread
        {
            var _local_2= Type.createInstance(GuildForumThread, []);
            _local_2.threadId = k.readInteger();
            _local_2.authorId = k.readInteger();
            _local_2.authorName = k.readString();
            _local_2.header = k.readString();
            _local_2.isPinned = k.readBoolean();
            _local_2.isLocked = k.readBoolean();
            _local_2.creationTime = k.readInteger();
            _local_2.totalMessages = k.readInteger();
            _local_2.unreadMessagesCount = k.readInteger();
            _local_2._Str_10610 = k.readInteger();
            _local_2.lastUserId = k.readInteger();
            _local_2.lastUserName = k.readString();
            _local_2.lastCommentTime = k.readInteger();
            _local_2.state = k.readByte();
            _local_2.adminId = k.readInteger();
            _local_2.adminName = k.readString();
            _local_2.unknownInt = k.readInteger();
            return _local_2;
        }


        
        public var unknownInt(get,set):Int;
public function  get_unknownInt():Int
        {
            return this._unknownInt;
        }
public function  set_unknownInt(k:Int):Int        {
            return this._unknownInt = k;
        }

        
        public var lastCommentTime(get,set):Int;
public function  get_lastCommentTime():Int
        {
            return this._lastCommentTime;
        }
public function  set_lastCommentTime(k:Int):Int        {
            return this._lastCommentTime = k;
        }

        
        public var threadId(get,set):Int;
public function  get_threadId():Int
        {
            return this._threadId;
        }
public function  set_threadId(k:Int):Int        {
            return this._threadId = k;
        }

        
        public var authorId(get,set):Int;
public function  get_authorId():Int
        {
            return this._authorId;
        }
public function  set_authorId(k:Int):Int        {
            return this._authorId = k;
        }

        
        public var authorName(get,set):String;
public function  get_authorName():String
        {
            return this._authorName;
        }
public function  set_authorName(k:String):String        {
            return this._authorName = k;
        }

        
        public var creationTime(get,set):Int;
public function  get_creationTime():Int
        {
            return this._creationTime;
        }
public function  set_creationTime(k:Int):Int        {
            return this._creationTime = k;
        }

        
        public var header(get,set):String;
public function  get_header():String
        {
            return this._header;
        }
public function  set_header(k:String):String        {
            return this._header = k;
        }

        
        public var _Str_10610(get,set):Int;
public function  get__Str_10610():Int
        {
            return this._Str_6301;
        }
public function  set__Str_10610(k:Int):Int        {
            return this._Str_6301 = k;
        }

        
        public var lastUserId(get,set):Int;
public function  get_lastUserId():Int
        {
            return this._lastUserId;
        }
public function  set_lastUserId(k:Int):Int        {
            return this._lastUserId = k;
        }

        
        public var lastUserName(get,set):String;
public function  get_lastUserName():String
        {
            return this._lastUserName;
        }
public function  set_lastUserName(k:String):String        {
            return this._lastUserName = k;
        }

        
        public var totalMessages(get,set):Int;
public function  get_totalMessages():Int
        {
            return this._totalMessages;
        }
public function  set_totalMessages(k:Int):Int        {
            return this._totalMessages = k;
        }

        
        public var unreadMessagesCount(get,set):Int;
public function  get_unreadMessagesCount():Int
        {
            return this._unreadMessagesCount;
        }
public function  set_unreadMessagesCount(k:Int):Int        {
            return this._unreadMessagesCount = k;
        }

        
        public var state(get,set):Int;
public function  get_state():Int
        {
            return this._state;
        }
public function  set_state(k:Int):Int        {
            return this._state = k;
        }

        
        public var adminId(get,set):Int;
public function  get_adminId():Int
        {
            return this._adminId;
        }
public function  set_adminId(k:Int):Int        {
            return this._adminId = k;
        }

        
        public var adminName(get,set):String;
public function  get_adminName():String
        {
            return this._adminName;
        }
public function  set_adminName(k:String):String        {
            return this._adminName = k;
        }

        
        public var isPinned(get,set):Bool;
public function  get_isPinned():Bool
        {
            return this._isPinned;
        }
public function  set_isPinned(k:Bool):Bool        {
            return this._isPinned = k;
        }

        
        public var isLocked(get,set):Bool;
public function  get_isLocked():Bool
        {
            return this._isLocked;
        }
public function  set_isLocked(k:Bool):Bool        {
            return this._isLocked = k;
        }

	public function new() {}
    }

