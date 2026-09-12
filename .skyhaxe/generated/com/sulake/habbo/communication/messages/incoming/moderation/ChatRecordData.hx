package com.sulake.habbo.communication.messages.incoming.moderation
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ChatRecordData 
    {
        public static inline final TYPE_SIMPLE= 0;
        public static inline final TYPE_ROOM_CHAT= 1;
        public static inline final TYPE_IM_SESSION= 2;
        public static inline final TYPE_DISCUSSION_THREAD= 3;
        public static inline final TYPE_DISCUSSION_MESSAGE= 4;
        public static inline final _Str_7751= 5;
        public static inline final _Str_17666= 6;

        var _recordType:Int = 0;
        var _context:ASDictionary<ASAny,ASAny>;
        var _chatlog:Array<ASAny>;

        public function new(k:IMessageDataWrapper)
        {
            var _local_6:String = null;
            var _local_7 = 0;
            this._context = new ASDictionary<ASAny,ASAny>();
            this._chatlog = new Array<ASAny>();
            this._recordType = k.readByte();
            var _local_2= k.readShort();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                _local_6 = k.readString();
                _local_7 = k.readByte();
                switch (_local_7)
                {
                    case 0:
                        this._context[_local_6] = k.readBoolean();
                        
                    case 1:
                        this._context[_local_6] = k.readInteger();
                        
                    case 2:
                        this._context[_local_6] = k.readString();
                        
                    default:
                        throw new ASError(("Unknown data type " + Std.string(_local_7)));
                }
                _local_3++;
            }
            var _local_4= k.readShort();
            var _local_5 = 0;
            while (_local_5 < _local_4)
            {
                this._chatlog.push(new ChatlineData(k));
                _local_5++;
            }
        }

        public var recordType(get,never):Int;
public function  get_recordType():Int
        {
            return this._recordType;
        }

        public var context(get,never):ASDictionary<ASAny,ASAny>;
public function  get_context():ASDictionary<ASAny,ASAny>
        {
            return this._context;
        }

        public var chatlog(get,never):Array<ASAny>;
public function  get_chatlog():Array<ASAny>
        {
            return this._chatlog;
        }

        public var roomId(get,never):Int;
public function  get_roomId():Int
        {
            return this.getInt("roomId");
        }

        public var roomName(get,never):String;
public function  get_roomName():String
        {
            return ASCompat.asString(this._context["roomName"] );
        }

        public var groupId(get,never):Int;
public function  get_groupId():Int
        {
            return this.getInt("groupId");
        }

        public var threadId(get,never):Int;
public function  get_threadId():Int
        {
            return this.getInt("threadId");
        }

        public var messageId(get,never):Int;
public function  get_messageId():Int
        {
            return this.getInt("messageId");
        }

        function getInt(k:String):Int
        {
            var _local_2:ASAny = this._context[k];
            if (_local_2 == null)
            {
                return 0;
            }
            return ASCompat.asInt(_local_2 );
        }
    }

