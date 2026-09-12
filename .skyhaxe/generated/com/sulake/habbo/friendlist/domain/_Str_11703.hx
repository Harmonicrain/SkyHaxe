package com.sulake.habbo.friendlist.domain
;
    import com.sulake.habbo.friendlist.HabboFriendList;

     class _Str_11703 implements _Str_8679 
    {
        var _habboFriendList:HabboFriendList;

        public function new(k:HabboFriendList)
        {
            this._habboFriendList = k;
        }

        public function _Str_15196():HabboFriendList
        {
            return this._habboFriendList;
        }

        public function _Str_23212():Int
        {
            return this._habboFriendList.view.mainWindow.height;
        }
    }

