package com.sulake.habbo.friendlist.domain
;
    import com.sulake.habbo.friendlist.HabboFriendList;
    import com.sulake.habbo.friendlist._Str_2777;
    import com.sulake.habbo.friendlist._Str_6567;
    import com.sulake.habbo.messenger.IHabboMessenger;
    import com.sulake.habbo.notifications.IHabboNotifications;

     class _Str_10966 implements _Str_9454 
    {
        var _habboFriendList:HabboFriendList;

        public function new(k:HabboFriendList)
        {
            this._habboFriendList = k;
        }

        public var view(get,never):_Str_6567;
public function  get_view():_Str_6567
        {
            return ASCompat.reinterpretAs(this._habboFriendList.tabs._Str_4403(_Str_2777._Str_4113)._Str_4621 , _Str_6567);
        }

        public var messenger(get,never):IHabboMessenger;
public function  get_messenger():IHabboMessenger
        {
            return this._habboFriendList.messenger;
        }

        public var notifications(get,never):IHabboNotifications;
public function  get_notifications():IHabboNotifications
        {
            return this._habboFriendList.notifications;
        }
    }

