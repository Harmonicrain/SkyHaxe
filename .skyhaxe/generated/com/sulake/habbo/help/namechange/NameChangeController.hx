package com.sulake.habbo.help.namechange
;
    import com.sulake.habbo.help.INameChangeUI;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.help.HabboHelp;
    import com.sulake.habbo.communication.messages.incoming.handshake.UserObjectEvent;
    import com.sulake.habbo.communication.messages.incoming.users.UserNameChangedMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.avatar.ChangeUserNameResultMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.avatar.CheckUserNameResultMessageEvent;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.help._enum.HabboHelpTutorialEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.outgoing.avatar.ChangeUserNameMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.avatar.CheckUserNameMessageComposer;
    import com.sulake.core.communication.messages.IMessageEvent;

     class NameChangeController implements INameChangeUI implements  IDisposable 
    {
        public static inline final TUI_NAME_VIEW= "TUI_NAME_VIEW";

        var _disposed:Bool = false;
        var _habboHelp:HabboHelp;
        var _nameChangeView:NameChangeView;
        var _ownUserName:String;
        var _ownUserId:Int = 0;

        public function new(k:HabboHelp)
        {
            this._habboHelp = k;
            this._habboHelp.communicationManager.addHabboConnectionMessageEvent(new UserObjectEvent(this.onUserObject));
            this._habboHelp.communicationManager.addHabboConnectionMessageEvent(new UserNameChangedMessageEvent(this.onUserNameChange));
            this._habboHelp.communicationManager.addHabboConnectionMessageEvent(new ChangeUserNameResultMessageEvent(this.onChangeUserNameResult));
            this._habboHelp.communicationManager.addHabboConnectionMessageEvent(new CheckUserNameResultMessageEvent(this._Str_18696));
        }

        public var help(get,never):HabboHelp;
public function  get_help():HabboHelp
        {
            return this._habboHelp;
        }

        public var assets(get,never):IAssetLibrary;
public function  get_assets():IAssetLibrary
        {
            return this._habboHelp.assets;
        }

        public var localization(get,never):IHabboLocalizationManager;
public function  get_localization():IHabboLocalizationManager
        {
            return this._habboHelp.localization;
        }

        public var myName(get,never):String;
public function  get_myName():String
        {
            return this._ownUserName;
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                this.disposeView();
                if (this._habboHelp != null)
                {
                    this._habboHelp = null;
                }
                this._disposed = true;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function showView()
        {
            if (((this._nameChangeView == null) || this._nameChangeView.disposed))
            {
                this._nameChangeView = new NameChangeView(this);
            }
            this._nameChangeView._Str_22632();
            this._Str_25860();
        }

        public function buildXmlWindow(k:String, _arg_2:UInt=1):IWindow
        {
            if (this._habboHelp.assets == null)
            {
                return null;
            }
            var _local_3= cast(this._habboHelp.assets.getAssetByName((k + "_xml")), XmlAsset);
            if (((_local_3 == null) || (this._habboHelp.windowManager == null)))
            {
                return null;
            }
            return this._habboHelp.windowManager.buildFromXML(new com.sulake.core.utils.xml.XML(_local_3.content), _arg_2);
        }

        function disposeWindow(k:WindowEvent=null)
        {
        }

        public function disposeView()
        {
            if (this._nameChangeView != null)
            {
                this._nameChangeView.dispose();
                this._nameChangeView = null;
            }
            this.disposeWindow();
        }

        public function hideView()
        {
            if (this._nameChangeView != null)
            {
                this._nameChangeView.dispose();
                this._nameChangeView = null;
            }
        }

        public function _Str_26283(k:Bool)
        {
            if (k == false)
            {
                this.disposeView();
            }
        }

        public function _Str_25860()
        {
            if (((this._habboHelp == null) || (this._habboHelp.events == null)))
            {
                return;
            }
            this._habboHelp.events.dispatchEvent(new HabboHelpTutorialEvent(HabboHelpTutorialEvent.HHTPNUFWE_AVATAR_TUTORIAL_START));
        }

        public function windowProcedure(k:WindowEvent, _arg_2:IWindow)
        {
            switch (k.type)
            {
                case WindowMouseEvent.CLICK:
                    if (_arg_2.name == "header_button_close")
                    {
                        this.disposeView();
                    }
                    return;
            }
        }

        public function changeName(k:String)
        {
            this.disposeWindow();
            this._habboHelp.sendMessage(new ChangeUserNameMessageComposer(k));
        }

        public function checkName(k:String)
        {
            this.disposeWindow();
            this._habboHelp.sendMessage(new CheckUserNameMessageComposer(k));
        }

        public function _Str_25375(name:String)
        {
            if ((((!(this._habboHelp != null)) || (!(this._habboHelp.localization != null))) || (!(this._habboHelp.windowManager != null))))
            {
                return;
            }
            this._habboHelp.localization.registerParameter("help.tutorial.name.changed", "name", name);
            this._habboHelp.windowManager.alert("${generic.notice}", "${help.tutorial.name.changed}", 0, function (k:com.sulake.habbo.window.utils.IAlertDialog, _arg_2:WindowEvent)
            {
                k.dispose();
            });
        }

        function onChangeUserNameResult(k:ChangeUserNameResultMessageEvent)
        {
            if (k == null)
            {
                return;
            }
            var _local_2= k.getParser();
            if (_local_2 == null)
            {
                return;
            }
            if (_local_2.resultCode == ChangeUserNameResultMessageEvent.NAME_OK)
            {
                this._Str_25375(_local_2.name);
                this.hideView();
            }
            else
            {
                if (this._nameChangeView != null)
                {
                    this._nameChangeView._Str_14489(_local_2.resultCode, _local_2.name, _local_2.nameSuggestions);
                }
            }
        }

        function _Str_18696(k:CheckUserNameResultMessageEvent)
        {
            if (((!(k != null)) || (!(this._nameChangeView != null))))
            {
                return;
            }
            var _local_2= k.getParser();
            if (_local_2.resultCode == ChangeUserNameResultMessageEvent.NAME_OK)
            {
                this._nameChangeView._Str_16320 = _local_2.name;
            }
            else
            {
                this._nameChangeView._Str_14489(_local_2.resultCode, _local_2.name, _local_2.nameSuggestions);
            }
        }

        function onUserObject(k:IMessageEvent)
        {
            var _local_2= cast(k, UserObjectEvent).getParser();
            this._ownUserId = _local_2.id;
            this._ownUserName = _local_2.name;
        }

        function onUserNameChange(k:IMessageEvent)
        {
            var _local_2= cast(k, UserNameChangedMessageEvent).getParser();
            if (this._ownUserId == _local_2.webId)
            {
                this._ownUserName = _local_2.newName;
            }
        }

        public var _Str_16805(get,never):String;
public function  get__Str_16805():String
        {
            return this._ownUserName;
        }

        public var _Str_6240(get,never):Int;
public function  get__Str_6240():Int
        {
            return this._ownUserId;
        }
    }

