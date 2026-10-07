package com.sulake.habbo.ui.widget.doorbell
;
    import com.sulake.habbo.ui.widget.RoomWidgetBase;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.ui.widget.events.RoomWidgetDoorbellEvent;
    import flash.events.IEventDispatcher;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetLetUserInMessage;

     class DoorbellWidget extends RoomWidgetBase
    {
        static inline final MAX_USERS_ON_DOORBELL_LIST= 50;

        var _users:Array<ASAny>;
        var _view:DoorbellView;

        public function new(k:IRoomWidgetHandler, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary, _arg_4:IHabboLocalizationManager)
        {
            super(k, _arg_2, _arg_3, _arg_4);
            this._view = new DoorbellView(this);
            this._users = [];
        }

        override public function  get_mainWindow():IWindow
        {
            return this._view.mainWindow;
        }

        public var users(get,never):Array<ASAny>;
public function  get_users():Array<ASAny>
        {
            return this._users;
        }

        override public function dispose()
        {
            if (disposed)
            {
                return;
            }
            if (this._view != null)
            {
                this._view.dispose();
                this._view = null;
            }
            this._users = null;
            super.dispose();
        }

        override public function registerUpdateEvents(k:IEventDispatcher)
        {
            if (k == null)
            {
                return;
            }
            k.addEventListener(RoomWidgetDoorbellEvent.RWDE_RINGING, this.onDoorbellRinging);
            k.addEventListener(RoomWidgetDoorbellEvent.REJECTED, this.onDoorbellHandled);
            k.addEventListener(RoomWidgetDoorbellEvent.RWDE_ACCEPTED, this.onDoorbellHandled);
            super.registerUpdateEvents(k);
        }

        override public function unregisterUpdateEvents(k:IEventDispatcher)
        {
            if (k == null)
            {
                return;
            }
            k.removeEventListener(RoomWidgetDoorbellEvent.RWDE_RINGING, this.onDoorbellRinging);
            k.removeEventListener(RoomWidgetDoorbellEvent.REJECTED, this.onDoorbellHandled);
            k.removeEventListener(RoomWidgetDoorbellEvent.RWDE_ACCEPTED, this.onDoorbellHandled);
        }

        function onDoorbellRinging(k:RoomWidgetDoorbellEvent)
        {
            this.addUser(k.userName);
        }

        function onDoorbellHandled(k:RoomWidgetDoorbellEvent)
        {
            this.removeUser(k.userName);
        }

        public function addUser(k:String)
        {
            if (this._users.indexOf(k) != -1)
            {
                return;
            }
            if (this._users.length >= MAX_USERS_ON_DOORBELL_LIST)
            {
                this.deny(k);
                return;
            }
            this._users.push(k);
            this._view.update();
        }

        public function removeUser(k:String)
        {
            var _local_2= this._users.indexOf(k);
            if (_local_2 == -1)
            {
                return;
            }
            this._users.splice(_local_2, 1);
            this._view.update();
        }

        public function accept(k:String)
        {
            var _local_2= new RoomWidgetLetUserInMessage(k, true);
            messageListener.processWidgetMessage(_local_2);
            this.removeUser(k);
        }

        public function deny(k:String)
        {
            var _local_2= new RoomWidgetLetUserInMessage(k, false);
            messageListener.processWidgetMessage(_local_2);
            this.removeUser(k);
        }

        public function denyAll()
        {
            while (this._users.length > 0)
            {
                this.deny(this._users[0]);
            }
        }
    }

