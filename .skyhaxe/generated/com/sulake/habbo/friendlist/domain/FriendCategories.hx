package com.sulake.habbo.friendlist.domain
;
    import com.sulake.habbo.communication.messages.parser.friendlist.FriendListUpdateMessageParser;
    import com.sulake.habbo.communication.messages.incoming.friendlist.FriendParser;
    import com.sulake.habbo.communication.messages.incoming.friendlist.FriendListUpdateEvent;
    import com.sulake.core.utils.ErrorReportStorage;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.friendlist.FriendCategoryData;
    import com.sulake.habbo.friendlist.Util;
    import com.sulake.habbo.friendlist._Str_6567;
    import com.sulake.habbo.communication.messages.incoming.friendlist.*;
    import com.sulake.habbo.communication.messages.parser.friendlist.*;

     class FriendCategories 
    {
        var _deps:_Str_9454;
        var _categories:Array<ASAny>;
        var _friendsById:ASDictionary<ASAny,ASAny>;

        public function new(k:_Str_9454)
        {
            this._categories = new Array<ASAny>();
            this._friendsById = new ASDictionary<ASAny,ASAny>();
            this._deps = k;
        }

        public function _Str_11247(k:Friend):FriendCategory
        {
            var _local_2= (k.online ? k.categoryId : FriendCategory._Str_7666);
            var _local_3= this._Str_5067(_local_2);
            if (_local_3 != null)
            {
                _local_3._Str_11247(k);
                this._friendsById[k.id] = k;
                return _local_3;
            }
            Logger.log([(((("No category " + Std.string(_local_2)) + " found for friend ") + Std.string(k.id)) + ". Ignoring")]);
            return null;
        }

        public function _Str_8217():Array<ASAny>
        {
            var _local_2:FriendCategory = null;
            var k= new Array<ASAny>();
            final _iter_ = this._categories; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                _local_2._Str_8217(k);
            }
            return k;
        }

        public function _Str_23393():Friend
        {
            var k= this._Str_8217();
            return (k.length == 1) ? k[0] : null;
        }

        public function _Str_22560():ASDictionary<ASAny,ASAny>
        {
            return this._friendsById;
        }

        public function getFriendCount(k:Bool, _arg_2:Bool=false):Int
        {
            var _local_4:FriendCategory = null;
            var _local_3 = 0;
            final _iter_ = this._categories; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_4  = _tmp_;
                _local_3 = (_local_3 + _local_4.getFriendCount(k, _arg_2));
            }
            return _local_3;
        }

        public function _Str_17858():Array<ASAny>
        {
            return this._categories;
        }

        public function _Str_15664(k:FriendCategory)
        {
            this._categories.push(k);
        }

        public function _Str_13534(k:Int):Friend
        {
            return this._friendsById[k];
        }

        public function _Str_5067(k:Int):FriendCategory
        {
            var _local_2:FriendCategory = null;
            final _iter_ = this._categories; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.id == k)
                {
                    return _local_2;
                }
            }
            return null;
        }

        public function onFriendListUpdate(event:IMessageEvent)
        {
            var status = 0;
            var p:FriendListUpdateMessageParser = null;
            var removedFriendId = 0;
            var updatedFriend:FriendParser = null;
            var addedFriend:FriendParser = null;
            var currentlyOnline = false;
            var wasSelected = false;
            var friend:Friend = null;
            Logger.log(["Received friend list update"]);
            status = 0;
            try
            {
                p = Std.downcast(event , FriendListUpdateEvent).getParser();
                status = 1;
                this._Str_22561(p.cats);
                status = 2;
                final _iter_ = p.removedFriendIds; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
removedFriendId  = ASCompat.toInt(_tmp_);
                    this._Str_8793(removedFriendId, true);
                }
                status = 3;
                final _iter_ = p.updatedFriends; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
updatedFriend  = _tmp_;
                    Logger.log([((((((("Got UPDATE: " + Std.string(updatedFriend.id)) + ", ") + Std.string(updatedFriend.online)) + ", ") + updatedFriend.name) + ", ") + Std.string(updatedFriend.followingAllowed))]);
                    this._deps.messenger.setFollowingAllowed(updatedFriend.id, (updatedFriend.followingAllowed && updatedFriend.online));
                    currentlyOnline = this._Str_25874(updatedFriend.id);
                    if ((currentlyOnline && (!updatedFriend.online)))
                    {
                        this._deps.messenger.setOnlineStatus(updatedFriend.id, updatedFriend.online);
                    }
                    if (((!currentlyOnline) && updatedFriend.online))
                    {
                        this._deps.messenger.setOnlineStatus(updatedFriend.id, updatedFriend.online);
                        this._deps.view._Str_9276();
                    }
                    wasSelected = this._Str_8793(updatedFriend.id, true);
                    friend = new Friend(updatedFriend);
                    friend.selected = wasSelected;
                    this._Str_11247(friend);
                }
                status = 4;
                final _iter_ = p.addedFriends; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
addedFriend  = _tmp_;
                    Logger.log([((("Got INSERT: " + Std.string(addedFriend.id)) + ", ") + addedFriend.name)]);
                    this._Str_8793(addedFriend.id, true);
                    this._Str_11247(new Friend(addedFriend));
                }
                status = 5;
                this._deps.view._Str_3836();
                status = 6;
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                ErrorReportStorage.addDebugData("FriendCategories", (("onFriendListUpdate crashed, status = " + Std.string(status)) + "!"));
                throw e;
            }
 }        }

        function _Str_22561(k:Array<ASAny>)
        {
            var _local_2:FriendCategoryData = null;
            var _local_3:FriendCategory = null;
            var _local_4:FriendCategory = null;
            var _local_5:FriendCategory = null;
            this._Str_22708();
            this._Str_5067(FriendCategory._Str_7666).received = true;
            this._Str_5067(FriendCategory._Str_15031).received = true;
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_2  = _tmp_;
                _local_4 = this._Str_5067(_local_2.id);
                if (_local_4 != null)
                {
                    _local_4.received = true;
                    if (_local_4.name != _local_2.name)
                    {
                        _local_4.name = _local_2.name;
                    }
                }
                else
                {
                    _local_5 = new FriendCategory(_local_2.id, _local_2.name);
                    _local_5.received = true;
                    this._Str_15664(_local_5);
                }
            }
            final _iter_ = this._Str_22944(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                if (_local_3.friends.length > 0)
                {
                }
                else
                {
                    Util.remove(this._categories, _local_3);
                    _local_3.dispose();
                }
            }
        }

        function _Str_8793(k:Int, _arg_2:Bool):Bool
        {
            var _local_4:FriendCategory = null;
            var _local_5:Friend = null;
            if (_arg_2)
            {
                this._friendsById[k] = null;
            }
            var _local_3 = false;
            final _iter_ = this._categories; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_4  = _tmp_;
                _local_5 = _local_4._Str_8793(k);
                if (_local_5 != null)
                {
                    _local_3 = _local_5.selected;
                    if (_arg_2)
                    {
                        _local_5.dispose();
                    }
                }
            }
            return _local_3;
        }

        function _Str_22708()
        {
            var k:FriendCategory = null;
            final _iter_ = this._categories; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                k.received = false;
            }
        }

        function _Str_22944():Array<ASAny>
        {
            var _local_2:FriendCategory = null;
            var k= new Array<ASAny>();
            final _iter_ = this._categories; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (!_local_2.received)
                {
                    k.push(_local_2);
                }
            }
            return k;
        }

        function _Str_25874(k:Int):Bool
        {
            var _local_2= this._Str_13534(k);
            return (_local_2 == null) ? false : _local_2.online;
        }

        public function getFriendNames():Array<ASAny>
        {
            var _local_2:Friend = null;
            if (this._friendsById == null)
            {
                return [];
            }
            var k:Array<ASAny> = [];
            final _iter_ = this._friendsById; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2 != null)
                {
                    k.push(_local_2.name);
                }
            }
            return k;
        }

        public var view(get,never):_Str_6567;
public function  get_view():_Str_6567
        {
            return this._deps.view;
        }
    }

