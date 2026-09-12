package com.sulake.habbo.friendlist.domain
;
    import com.sulake.habbo.friendlist.Util;

     class _Str_9210 
    {
        var _Str_3339:_Str_8742;
        var _requests:Array<ASAny>;
        var _limit:Int = 0;
        var _Str_20540:Int = 0;

        public function new(k:_Str_8742, _arg_2:Int, _arg_3:Int)
        {
            this._requests = new Array<ASAny>();
            this._Str_3339 = k;
            this._limit = _arg_2;
            this._Str_20540 = _arg_3;
        }

        public function _Str_20199(k:Bool)
        {
            var _local_3:FriendRequest = null;
            var _local_4:FriendRequest = null;
            var _local_2= new Array<ASAny>();
            final _iter_ = this._requests; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                if (((!k) || (!(_local_3.state == FriendRequest._Str_5035))))
                {
                    _local_2.push(_local_3);
                }
            }
            if (checkNullIteratee(_local_2)) for (_tmp_ in _local_2)
            {
_local_4  = _tmp_;
                Util.remove(this._requests, _local_4);
                if (this._Str_3339.view != null)
                {
                    this._Str_3339.view._Str_7667(_local_4);
                }
                _local_4.dispose();
            }
            this._Str_6988();
        }

        public function _Str_25626(k:Int)
        {
            var _local_2= this._Str_24640(k);
            if (_local_2 == null)
            {
                Logger.log([(("Failed to accept friend request from " + Std.string(k)) + ", error retrieving the friendrequest.")]);
                return;
            }
            _local_2.state = FriendRequest._Str_15312;
            this._Str_3339.view._Str_6657(_local_2);
        }

        public function _Str_8472(k:FriendRequest)
        {
            this._requests.push(k);
        }

        public function _Str_24807(k:FriendRequest)
        {
            this._requests.push(k);
            this._Str_3339.view._Str_8472(k);
        }

        public function _Str_19101(k:Int):FriendRequest
        {
            var _local_2:FriendRequest = null;
            final _iter_ = this._requests; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.requestId == k)
                {
                    return _local_2;
                }
            }
            return null;
        }

        public function _Str_24640(k:Int):FriendRequest
        {
            var _local_2:FriendRequest = null;
            final _iter_ = this._requests; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.requesterUserId == k)
                {
                    return _local_2;
                }
            }
            return null;
        }

        public function _Str_6988()
        {
            var _local_2:FriendRequest = null;
            var k= true;
            final _iter_ = this._requests; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                k = (!k);
                this._Str_3339.view._Str_6988(_local_2, k);
            }
        }

        public function _Str_19367():Int
        {
            var _local_2:FriendRequest = null;
            var k = 0;
            final _iter_ = this.requests; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.state == FriendRequest._Str_5035)
                {
                    k++;
                }
            }
            return k;
        }

        public var requests(get,never):Array<ASAny>;
public function  get_requests():Array<ASAny>
        {
            return this._requests;
        }

        
        public var limit(get,set):Int;
public function  get_limit():Int
        {
            return this._limit;
        }

        public var _Str_17940(get,never):Int;
public function  get__Str_17940():Int
        {
            return this._Str_20540;
        }
public function  set_limit(k:Int):Int        {
            return this._limit = k;
        }
    }

