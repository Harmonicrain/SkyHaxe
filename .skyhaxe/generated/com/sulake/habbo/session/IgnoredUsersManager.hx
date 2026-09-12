package com.sulake.habbo.session
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.users.IgnoreResultMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.users.IgnoredUsersMessageEvent;
    import com.sulake.habbo.communication.messages.outgoing.users.GetIgnoredUsersMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.users.IgnoreUserIdMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.users.IgnoreUserMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.users.UnignoreUserMessageComposer;

     class IgnoredUsersManager implements IDisposable 
    {
        var _sessionDataManager:SessionDataManager;
        var _ignoreResultMessageEvent:IMessageEvent;
        var _ignoredUsersMessageEvent:IMessageEvent;
        var _ignoredUsers:Array<ASAny>;

        public function new(k:SessionDataManager)
        {
            this._ignoredUsers = [];
            this._sessionDataManager = k;
            if (this._sessionDataManager.communication != null)
            {
                this._ignoreResultMessageEvent = this._sessionDataManager.communication.addHabboConnectionMessageEvent(new IgnoreResultMessageEvent(this.onIgnoreResult));
                this._ignoredUsersMessageEvent = this._sessionDataManager.communication.addHabboConnectionMessageEvent(new IgnoredUsersMessageEvent(this._Str_24424));
            }
        }

        public function dispose()
        {
            if (this.disposed)
            {
                return;
            }
            if (this._sessionDataManager.communication != null)
            {
                this._sessionDataManager.communication.removeHabboConnectionMessageEvent(this._ignoreResultMessageEvent);
                this._sessionDataManager.communication.removeHabboConnectionMessageEvent(this._ignoredUsersMessageEvent);
            }
            this._ignoreResultMessageEvent = null;
            this._ignoredUsersMessageEvent = null;
            this._sessionDataManager = null;
        }

        public function initIgnoreList()
        {
            this._sessionDataManager.send(new GetIgnoredUsersMessageComposer(this._sessionDataManager.userName));
        }

        function _Str_24424(k:IgnoredUsersMessageEvent)
        {
            this._ignoredUsers = k.ignoredUsers;
        }

        function onIgnoreResult(k:IgnoreResultMessageEvent)
        {
            var _local_2= k.name;
            switch (k.result)
            {
                case 0:
                    return;
                case 1:
                    this.addUserToIgnoreList(_local_2);
                    return;
                case 2:
                    this.addUserToIgnoreList(_local_2);
                    this._ignoredUsers.shift();
                    return;
                case 3:
                    this.removeUserFromIgnoreList(_local_2);
                    return;
            }
        }

        function addUserToIgnoreList(k:String)
        {
            if (this._ignoredUsers.indexOf(k) < 0)
            {
                this._ignoredUsers.push(k);
            }
        }

        function removeUserFromIgnoreList(k:String)
        {
            var _local_2= this._ignoredUsers.indexOf(k);
            if (_local_2 >= 0)
            {
                this._ignoredUsers.splice(_local_2, 1);
            }
        }

        public function ignoreUserId(k:Int)
        {
            this._sessionDataManager.send(new IgnoreUserIdMessageComposer(k));
        }

        public function ignoreUser(k:String)
        {
            this._sessionDataManager.send(new IgnoreUserMessageComposer(k));
        }

        public function unignoreUser(k:String)
        {
            this._sessionDataManager.send(new UnignoreUserMessageComposer(k));
        }

        public function isIgnored(k:String):Bool
        {
            return this._ignoredUsers.indexOf(k) >= 0;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._sessionDataManager == null;
        }
    }

