package com.sulake.habbo.friendlist.domain
;
    import com.sulake.habbo.communication.messages.incoming.friendlist.HabboSearchResultData;

     class AvatarSearchResults 
    {
        var _deps:_Str_8493;
        var _friends:Array<ASAny>;
        var _others:Array<ASAny>;
        var _sentRequests:ASDictionary<ASAny,ASAny>;

        public function new(k:_Str_8493)
        {
            this._sentRequests = new ASDictionary<ASAny,ASAny>();
            this._deps = k;
        }

        public function _Str_21135(k:Int):HabboSearchResultData
        {
            var _local_2:HabboSearchResultData = null;
            var _local_3:HabboSearchResultData = null;
            final _iter_ = this._friends; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.avatarId == k)
                {
                    return _local_2;
                }
            }
            final _iter_ = this._others; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                if (_local_3.avatarId == k)
                {
                    return _local_3;
                }
            }
            return null;
        }

        public function _Str_22668(k:Array<ASAny>, _arg_2:Array<ASAny>)
        {
            this._friends = k;
            this._others = _arg_2;
            this._deps.view._Str_3836();
        }

        public var friends(get,never):Array<ASAny>;
public function  get_friends():Array<ASAny>
        {
            return this._friends;
        }

        public var others(get,never):Array<ASAny>;
public function  get_others():Array<ASAny>
        {
            return this._others;
        }

        public function setFriendRequestSent(k:Int)
        {
            this._sentRequests[k] = "yes";
        }

        public function isRequestFriend(k:Int):Bool
        {
            return !(this._sentRequests[k] == null);
        }
    }

