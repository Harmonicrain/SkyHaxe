package com.sulake.habbo.navigator.roomsettings
;
    import com.sulake.habbo.communication.messages.incoming.friendlist.FriendParser;
    import com.sulake.habbo.communication.messages.incoming.friendlist.FriendListFragmentMessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.friendlist.FriendListUpdateEvent;

     class FriendList 
    {
        var _namesById:ASDictionary<ASAny,ASAny>;
        var _list:Array<ASAny>;

        public function new()
        {
            this._namesById = new ASDictionary<ASAny,ASAny>();
        }

        public function onFriendsListFragment(k:IMessageEvent)
        {
            var _local_3:FriendParser = null;
            var _local_2= Std.downcast(k , FriendListFragmentMessageEvent).getParser();
            if (_local_2 == null)
            {
                return;
            }
            final _iter_ = _local_2.friendFragment; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                this._namesById[_local_3.id] = _local_3.name;
            }
        }

        public function onFriendListUpdate(k:IMessageEvent)
        {
            var _local_3 = 0;
            var _local_4:FriendParser = null;
            var _local_2= Std.downcast(k , FriendListUpdateEvent).getParser();
            final _iter_ = _local_2.removedFriendIds; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = ASCompat.toInt(_tmp_);
                this._namesById[_local_3] = null;
            }
            final _iter_ = _local_2.addedFriends; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_4  = _tmp_;
                this._namesById[_local_4.id] = _local_4.name;
            }
            this._list = (((_local_2.removedFriendIds.length > 0) || (_local_2.addedFriends.length > 0)) ? null : this._list);
        }

        public var list(get,never):Array<ASAny>;
public function  get_list():Array<ASAny>
        {
var k:String  = null;            var k:String = null;
            var _local_2 = 0;
            var _local_3:String = null;
            if (this._list == null)
            {
                this._list = new Array<ASAny>();
                final _iter_ = this._namesById; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
                {
k = _tmp_;
                    _local_2 = ASCompat.toInt(k);
                    _local_3 = this._namesById[_local_2];
                    if (_local_3 != null)
                    {
                        this._list.push(new FriendEntryData(_local_2, _local_3));
                    }
                }
                ASCompat.ASArray.sortOn(this._list, "userName", ASCompat.ASArray.CASEINSENSITIVE);
            }
            return this._list;
        }
    }

