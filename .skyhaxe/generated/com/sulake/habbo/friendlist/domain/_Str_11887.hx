package com.sulake.habbo.friendlist.domain
;
    import com.sulake.habbo.friendlist.HabboFriendList;
    import com.sulake.habbo.friendlist._Str_2777;
    import com.sulake.habbo.friendlist._Str_4097;

     class _Str_11887 implements _Str_8742 
    {
        var _habboFriendList:HabboFriendList;

        public function new(k:HabboFriendList)
        {
            this._habboFriendList = k;
        }

        public var view(get,never):_Str_4097;
public function  get_view():_Str_4097
        {
            return ASCompat.reinterpretAs(this._habboFriendList.tabs._Str_4403(_Str_2777._Str_3798)._Str_4621 , _Str_4097);
        }
    }

