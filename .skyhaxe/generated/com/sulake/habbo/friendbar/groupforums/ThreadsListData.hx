package com.sulake.habbo.friendbar.groupforums
;
    import com.sulake.habbo.communication.messages.parser.groupforums.GuildForumThread;

     class ThreadsListData 
    {
        public static inline final PAGE_SIZE= 20;

        var _totalThreads:Int = 0;
        var _startIndex:Int = 0;
        var _threads:Array<ASAny>;
        var _threadsById:ASDictionary<ASAny,ASAny>;

        public function new(k:Int, _arg_2:Int, _arg_3:Array<ASAny>)
        {
            var _local_5:GuildForumThread = null;
            this._totalThreads = k;
            this._startIndex = _arg_2;
            this._threads = _arg_3;
            this._threadsById = new ASDictionary<ASAny,ASAny>();
            var _local_4 = 0;
            while (_local_4 < _arg_3.length)
            {
                _local_5 = _arg_3[_local_4];
                this._threadsById[_local_5.threadId] = _local_5;
                _local_4++;
            }
        }

        public var _Str_18760(get,never):Int;
public function  get__Str_18760():Int
        {
            return this._totalThreads;
        }

        public var startIndex(get,never):Int;
public function  get_startIndex():Int
        {
            return this._startIndex;
        }

        public var _Str_8372(get,never):Array<ASAny>;
public function  get__Str_8372():Array<ASAny>
        {
            return this._threads;
        }

        public var _Str_6700(get,never):ASDictionary<ASAny,ASAny>;
public function  get__Str_6700():ASDictionary<ASAny,ASAny>
        {
            return this._threadsById;
        }

        public var size(get,never):Int;
public function  get_size():Int
        {
            return this._threads.length;
        }

        public function _Str_16120(k:GuildForumThread):Bool
        {
            var _local_3:GuildForumThread = null;
            this._Str_6700[k.threadId] = k;
            var _local_2 = 0;
            while (_local_2 < this._Str_8372.length)
            {
                _local_3 = this._Str_8372[_local_2];
                if (_local_3.threadId == k.threadId)
                {
                    this._Str_8372[_local_2] = k;
                    return true;
                }
                _local_2++;
            }
            return false;
        }
    }

