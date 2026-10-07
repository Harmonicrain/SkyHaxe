package com.sulake.habbo.friendlist.domain
;
    import com.sulake.habbo.friendlist.HabboFriendList;
    import com.sulake.habbo.friendlist._Str_2777;
    import com.sulake.habbo.friendlist._Str_7814;

     class _Str_10395 implements _Str_8493 
    {
        var _habboFriendList:HabboFriendList;

        public function new(k:HabboFriendList)
        {
            this._habboFriendList = k;
        }

        public var view(get,never):_Str_7814;
public function  get_view():_Str_7814
        {
            return ASCompat.reinterpretAs(this._habboFriendList.tabs._Str_4403(_Str_2777._Str_5722)._Str_4621 , _Str_7814);
        }
    }

