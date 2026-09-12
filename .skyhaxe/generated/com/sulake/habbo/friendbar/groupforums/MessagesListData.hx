package com.sulake.habbo.friendbar.groupforums
;
    import com.sulake.habbo.communication.messages.parser.groupforums.MessageData;

     class MessagesListData 
    {
        var _threadId:Int = 0;
        var _startIndex:Int = 0;
        var _totalMessages:Int = 0;
        var _messages:Array<ASAny>;
        var _messagesById:ASDictionary<ASAny,ASAny>;

        public function new(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Array<ASAny>)        {
            var _local_6:MessageData = null;
            this._threadId = k;
            this._startIndex = _arg_3;
            this._totalMessages = _arg_2;
            this._messages = _arg_4;
            this._messagesById = new ASDictionary<ASAny,ASAny>();
            var _local_5 = 0;
            while (_local_5 < _arg_4.length)
            {
                _local_6 = _arg_4[_local_5];
                this._messagesById[_local_6.messageId] = _local_6;
                _local_5++;
            }
        }

        public var threadId(get,never):Int;
public function  get_threadId():Int
        {
            return this._threadId;
        }

        public var startIndex(get,never):Int;
public function  get_startIndex():Int
        {
            return this._startIndex;
        }

        public var _Str_8598(get,never):Int;
public function  get__Str_8598():Int
        {
            return this._totalMessages;
        }

        public var messages(get,never):Array<ASAny>;
public function  get_messages():Array<ASAny>
        {
            return this._messages;
        }

        public var _Str_22993(get,never):ASDictionary<ASAny,ASAny>;
public function  get__Str_22993():ASDictionary<ASAny,ASAny>
        {
            return this._messagesById;
        }

        public var size(get,never):Int;
public function  get_size():Int
        {
            return this._messages.length;
        }
    }

