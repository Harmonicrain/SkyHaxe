package com.sulake.habbo.friendbar.landingview.widget
;
    import com.sulake.habbo.friendbar.landingview.interfaces.ILandingViewWidget;
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.communication.messages.incoming.handshake.UserObjectEvent;
    import com.sulake.habbo.communication.messages.incoming.room.engine.UserChangeMessageEvent;
    import com.sulake.habbo.avatar.events.AvatarUpdateEvent;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.window.widgets.IAvatarImageWidget;

     class AvatarImageWidget implements ILandingViewWidget 
    {
        var _landingView:HabboLandingView;
        var _avatarImageWidget:IWidgetWindow;
        var _userObjectEvent:UserObjectEvent;
        var _userChangeMessageEvent:UserChangeMessageEvent;

        public function new(k:HabboLandingView)
        {
            this._landingView = k;
            this._userObjectEvent = new UserObjectEvent(this.onUserObject);
            this._userChangeMessageEvent = new UserChangeMessageEvent(this.onUserChange);
            this._landingView.communicationManager.addHabboConnectionMessageEvent(this._userObjectEvent);
            this._landingView.communicationManager.addHabboConnectionMessageEvent(this._userChangeMessageEvent);
            this._landingView.avatarEditor.events.addEventListener(AvatarUpdateEvent.AVATAR_FIGURE_UPDATED, this._Str_20230);
        }

        public var container(get,never):IWindow;
public function  get_container():IWindow
        {
            return this._avatarImageWidget;
        }

        public function dispose()
        {
            if (this._userObjectEvent != null)
            {
                this._landingView.communicationManager.removeHabboConnectionMessageEvent(this._userObjectEvent);
                this._userObjectEvent = null;
            }
            if (this._userChangeMessageEvent != null)
            {
                this._landingView.communicationManager.removeHabboConnectionMessageEvent(this._userChangeMessageEvent);
                this._userChangeMessageEvent = null;
            }
            if (this._landingView != null)
            {
                this._landingView.avatarEditor.events.removeEventListener(AvatarUpdateEvent.AVATAR_FIGURE_UPDATED, this._Str_20230);
                this._landingView = null;
            }
            this._avatarImageWidget = null;
        }

        public function initialize()
        {
            this._avatarImageWidget = cast(this._landingView.getXmlWindow("avatar_image"), IWidgetWindow);
        }

        public function refresh()
        {
            this._Str_7815();
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._landingView == null;
        }

        function onUserObject(k:UserObjectEvent)
        {
            this._Str_7815(k.getParser().figure);
        }

        function onUserChange(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , UserChangeMessageEvent);
            if (_local_2 == null)
            {
                return;
            }
            if (_local_2.id == -1)
            {
                this._Str_7815(_local_2.figure);
            }
        }

        function _Str_20230(k:AvatarUpdateEvent)
        {
            this._Str_7815(k.figure);
        }

        function _Str_7815(k:String=null)
        {
            var _local_2:IAvatarImageWidget = null;
            if (((!ASCompat.stringAsBool(k)) && (this._landingView.sessionDataManager != null)))
            {
                k = this._landingView.sessionDataManager.figure;
            }
            if (this._avatarImageWidget != null)
            {
                _local_2 = Std.downcast(this._avatarImageWidget.widget , IAvatarImageWidget);
                if (_local_2 != null)
                {
                    _local_2.figure = k;
                }
            }
        }
    }

