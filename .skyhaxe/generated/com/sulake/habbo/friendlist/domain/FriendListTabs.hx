package com.sulake.habbo.friendlist.domain
;
    import com.sulake.habbo.friendlist._Str_2777;
    import com.sulake.habbo.friendlist.FriendsView;
    import com.sulake.habbo.friendlist.FriendRequestsView;
    import com.sulake.habbo.friendlist.SearchView;
    import com.sulake.habbo.friendlist.*;

     class FriendListTabs 
    {
        var _deps:_Str_8679;
        var _tabs:Array<ASAny>;
        var _lastSelected:_Str_2740;
        var _tabContentHeight:Int = 200;
        var _lastTabContentHeight:Int = 200;
        var _windowWidth:Int = 200;

        public function new(k:_Str_8679)
        {
            this._tabs = new Array<ASAny>();
            this._deps = k;
            this._tabs.push(new _Str_2740(this._deps._Str_15196(), _Str_2777._Str_4113, new FriendsView(), "${friendlist.friends}", "friends_footer", "hdr_friends"));
            this._tabs.push(new _Str_2740(this._deps._Str_15196(), _Str_2777._Str_3798, new FriendRequestsView(), "${friendlist.tab.friendrequests}", "friend_requests_footer", "hdr_friend_requests"));
            this._tabs.push(new _Str_2740(this._deps._Str_15196(), _Str_2777._Str_5722, new SearchView(), "${generic.search}", "search_footer", "hdr_search"));
            this._Str_16257(null);
        }

        public function _Str_22082():Array<ASAny>
        {
            return this._tabs;
        }

        public function _Str_4403(k:Int):_Str_2740
        {
            var _local_2:_Str_2740 = null;
            final _iter_ = this._tabs; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.id == k)
                {
                    return _local_2;
                }
            }
            return null;
        }

        public function _Str_20836()
        {
            var k:_Str_2740 = null;
            final _iter_ = this._tabs; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                k.setSelected(false);
            }
        }

        public function _Str_14015():_Str_2740
        {
            var k:_Str_2740 = null;
            final _iter_ = this._tabs; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                if (k.selected)
                {
                    return k;
                }
            }
            return null;
        }

        public function _Str_16257(k:_Str_2740)
        {
            var _local_2= this._Str_14015();
            if (_local_2 == null)
            {
                this._tabContentHeight = this._lastTabContentHeight;
                this.setSelected(this._Str_19448(k), true);
            }
            else
            {
                if (((_local_2 == k) || (k == null)))
                {
                    this._lastTabContentHeight = this._tabContentHeight;
                    this._tabContentHeight = 0;
                    this._Str_20836();
                }
                else
                {
                    this.setSelected(this._Str_19448(k), true);
                }
            }
        }

        function setSelected(k:_Str_2740, _arg_2:Bool)
        {
            var _local_3= this._Str_14015();
            this._Str_20836();
            k.setSelected(_arg_2);
            if (_arg_2)
            {
                this._lastSelected = k;
            }
        }

        function _Str_19448(k:_Str_2740):_Str_2740
        {
            if (k != null)
            {
                return k;
            }
            if (this._lastSelected != null)
            {
                return this._lastSelected;
            }
            return this._tabs[0];
        }

        
        public var _Str_12266(get,set):Int;
public function  get__Str_12266():Int
        {
            return this._tabContentHeight;
        }

        
        public var _Str_4971(get,set):Int;
public function  get__Str_4971():Int
        {
            return this._windowWidth;
        }

        public var _Str_7233(get,never):Int;
public function  get__Str_7233():Int
        {
            return this._windowWidth - 2;
        }
public function  set__Str_12266(k:Int):Int        {
            return this._tabContentHeight = k;
        }
public function  set__Str_4971(k:Int):Int        {
            return this._windowWidth = k;
        }
    }

