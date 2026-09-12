package com.sulake.habbo.communication.demo
;
    import com.sulake.core.runtime.events.EventDispatcherWrapper;
    import com.sulake.habbo.window.utils.IModalDialog;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IDropListWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.ISelectableWindow;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import flash.net.SharedObject;
    import com.sulake.core.window.events.WindowKeyboardEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.utils.Map;
    import com.sulake.core.window.components.ITextWindow;
    import flash.display.BitmapData;
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.utils.Timer;
    import com.sulake.habbo.utils.HabboWebTools;
    import com.sulake.core.window.components.*;

     class HabboLoginDemoView extends EventDispatcherWrapper 
    {
        public static inline final INITCONNECTION= "InitConnection";

        static inline final SOL_ID= "fuselogin";

        var _habboLogin:HabboCommunicationDemo;
        var _dialog:IModalDialog;
        var _window:IWindowContainer;
        var _parsedTicket:SSOTicket;
        var _firstTryUsingExistingSession:Bool = false;
        public var name:String = "";
        public var password:String = "";
        var _environmentList:IDropListWindow;
        var _defaultPropertyValues:ASDictionary<ASAny,ASAny>;
        var _userListItem:IWindow;
        var _environmentItem:IWindow;
        var _testEnvironmentIndex:Int = 0;
        var _airSubmitInFlight:Bool = false;
        var _airRetryCooldown:Timer;
        static inline final AIR_RETRY_COOLDOWN_MS= 1000;

        public function new(k:HabboCommunicationDemo)
        {
            super();
            this._habboLogin = k;
            this._defaultPropertyValues = new ASDictionary<ASAny,ASAny>();
            this._dialog = this._habboLogin.getModalXmlWindow("login_window", "");
            this._window = Std.downcast(this._dialog.rootWindow , IWindowContainer);
            this.createWindow();
        }

        override public function dispose()
        {
            super.dispose();
            this.hideAirLoginBackground();
            this._environmentList = null;
            if (this._airRetryCooldown != null)
            {
                this._airRetryCooldown.stop();
                this._airRetryCooldown.removeEventListener(TimerEvent.TIMER_COMPLETE, (this.onAirRetryCooldownComplete : ASAny));
                this._airRetryCooldown = null;
            }
            if (this._dialog != null)
            {
                this._dialog.dispose();
                this._dialog = null;
            }
            this._defaultPropertyValues = null;
        }

        public function closeLoginWindow()
        {
            this.hideAirLoginBackground();
            if (this._dialog != null)
            {
                this._dialog.dispose();
                this._dialog = null;
            }
        }

        public var useSSOTicket(get,never):Bool;
public function  get_useSSOTicket():Bool
        {
            var k= Std.downcast(this._window.findChildByName("useTicket") , ISelectableWindow);
            if (k != null)
            {
                return k.Selected;
            }
            return false;
        }

        public var useExistingSession(get,never):Bool;
public function  get_useExistingSession():Bool
        {
            if (this._firstTryUsingExistingSession)
            {
                return true;
            }
            var k= Std.downcast(this._window.findChildByName("useExistingSession") , ISelectableWindow);
            if (k != null)
            {
                return k.Selected;
            }
            return false;
        }

        function createWindow()
        {
var _airCloseButton:IWindow  = null, _air_savedSso:String  = null;            var _local_9:Array<ASAny> = null;
            var _local_10:String = null;
            var _local_11:Array<ASAny> = null;
            var _local_12 = 0;
            var _local_13 = 0;
            var _local_14:String = null;
            var _local_15:IWindowContainer = null;
            this._window.center();
            if (HabboWebTools.isAirApplication)
            {
_airCloseButton= this._window.findChildByName("header_button_close");
                if (_airCloseButton != null)
                {
                    _airCloseButton.visible = false;
                }
            }
            var k= Std.downcast(this._window.findChildByName("login_btn") , IButtonWindow);
            var _local_2= Std.downcast(this._window.findChildByName("name_field") , ITextFieldWindow);
            var _local_3= Std.downcast(this._window.findChildByName("pwd_field") , ITextFieldWindow);
            if (k != null)
            {
                k.addEventListener(WindowMouseEvent.CLICK, this.windowEventProcessor);
            }
            else
            {
                Logger.log(["Could not find the button"]);
            }
            var _local_4= SharedObject.getLocal(HabboLoginDemoView.SOL_ID, "/");
            if (_local_2 != null)
            {
                _local_2.textBackground = true;
                _local_2.textBackgroundColor = 0xFFFFFF;
                if (_local_4.data.login != null)
                {
                    _local_2.text = _local_4.data.login;
                }
                _local_2.focus();
                _local_2.setSelection(_local_2.text.length, _local_2.text.length);
                _local_2.addEventListener(WindowKeyboardEvent.WINDOW_EVENT_KEY_UP, this.windowEventProcessor);
            }
            if (_local_3 != null)
            {
                _local_3.textBackground = true;
                _local_3.textBackgroundColor = 0xFFFFFF;
                if (_local_4.data.password != null)
                {
                    _local_3.text = _local_4.data.password;
                }
                _local_3.addEventListener(WindowKeyboardEvent.WINDOW_EVENT_KEY_UP, this.windowEventProcessor);
            }
            if (HabboWebTools.isAirApplication)
            {
_air_savedSso= ASCompat.asString(_local_4.data.air_sso );
                if (_local_2 != null && _air_savedSso != null && _air_savedSso.length > 0)
                {
                    _local_2.text = _air_savedSso;
                }
            }
            var _local_5= Std.downcast(this._window.findChildByName("useTicket") , ISelectableWindow);
            if (_local_5 != null)
            {
                if (this._habboLogin.getBoolean("use.sso"))
                {
                    _local_5.select();
                }
            }
            var _local_6= Std.downcast(this._window.findChildByName("useExistingSession") , ISelectableWindow);
            if (_local_6 != null)
            {
                _local_6.unselect();
            }
            if (this._habboLogin.getBoolean("try.existing.session"))
            {
                this._firstTryUsingExistingSession = true;
                this._window.visible = false;
                this.windowEventProcessor(WindowEvent.allocate(WindowEvent.WINDOW_EVENT_OK, this._window, null, false));
            }
            var _local_7= Std.downcast(this._window.findChildByName("list") , IItemListWindow);
            if (_local_7 != null)
            {
                this._userListItem = _local_7.removeListItemAt(0);
            }
            var _local_8= Std.downcast(this._habboLogin.assets.getAssetByName("login_environment_list_item") , XmlAsset);
            if (_local_8 != null)
            {
                this._environmentItem = this._habboLogin.windowManager.buildFromXML(((_local_8.content : com.sulake.core.utils.xml.XML) ));
            }
            if ((false || false))
            {
                this._environmentList = Std.downcast(this._window.findChildByName("environment_list") , IDropListWindow);
                _local_9 = (cast this._habboLogin.getProperty("environment.list").split("/"));
                _local_10 = ((_local_4.data.environment == null) ? "d63" : _local_4.data.environment);
                _local_11 = this.getEnvironmentNames(_local_9);
                _local_12 = this._environmentList.numMenuItems;
                _local_13 = 0;
                while (_local_13 < _local_12)
                {
                    this._environmentList.removeMenuItemAt(0);
                    _local_13++;
                }
                if (checkNullIteratee(_local_11)) for (_tmp_ in _local_11)
                {
_local_14  = _tmp_;
                    _local_15 = Std.downcast(this._environmentItem.clone() , IWindowContainer);
                    _local_15.findChildByName("title").caption = _local_14;
                    this._environmentList.addMenuItem(_local_15);
                }
                this._environmentList.selection = _local_9.indexOf(_local_10);
                this._environmentList.procedure = this.dropMenuEventHandler;
                this._testEnvironmentIndex = -1;
                this.testEnvironmentAvailable(false);
            }
            this._window.center();
        }

        function testEnvironmentAvailable(k:Bool)
        {
        }

        function getEnvironmentNames(k:Array<ASAny>):Array<ASAny>
        {
            var _local_3:String = null;
            var _local_4:String = null;
            var _local_2:Array<ASAny> = [];
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_3  = _tmp_;
                _local_4 = ("connection.info.name." + _local_3);
                if (this._habboLogin.propertyExists(_local_4))
                {
                    _local_2.push(this._habboLogin.getProperty(_local_4));
                }
                else
                {
                    Logger.log([("Could not find name for environment: " + _local_3)]);
                }
            }
            return _local_2;
        }

        function dropMenuEventHandler(event:WindowEvent, target:IWindow)
        {
            var so:SharedObject = null;
            var originalKeys:Array<ASAny> = null;
            var originalKey:String = null;
            var localKey:String = null;
            if (event.type != WindowEvent.WINDOW_EVENT_SELECTED)
            {
                return;
            }
            var environments:Array<ASAny> = (cast this._habboLogin.getProperty("environment.list").split("/"));
            var index= this._environmentList.selection;
            var environment:String = environments[index];
            try
            {
                so = SharedObject.getLocal(HabboLoginDemoView.SOL_ID, "/");
                so.data.environment = environment;
                so.flush();
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                Logger.log([("Could not store environment to SharedObject: " + e)]);
            }
 }            if ((false || false))
            {
                originalKeys = [];
                originalKeys.push("connection.info.host");
                originalKeys.push("connection.info.port");
                originalKeys.push("url.prefix");
                originalKeys.push("site.url");
                originalKeys.push("flash.dynamic.download.url");
                originalKeys.push("flash.dynamic.download.name.template");
                originalKeys.push("flash.dynamic.avatar.download.configuration");
                originalKeys.push("flash.dynamic.avatar.download.url");
                if (checkNullIteratee(originalKeys)) for (_tmp_ in originalKeys)
                {
originalKey  = _tmp_;
                    if (this._defaultPropertyValues[originalKey] == null)
                    {
                        this._defaultPropertyValues[originalKey] = this._habboLogin.getProperty(originalKey);
                    }
                    localKey = ((originalKey + ".") + environment);
                    if (this._habboLogin.propertyExists(localKey))
                    {
                        this._habboLogin.setProperty(originalKey, this._habboLogin.getProperty(localKey));
                    }
                    else
                    {
                        this._habboLogin.setProperty(originalKey, this._defaultPropertyValues[originalKey]);
                        Logger.log([((("Key not defined: " + localKey) + ". Using default value: ") + this._defaultPropertyValues[originalKey])]);
                    }
                }
                this._habboLogin.communication.updateHostParameters();
            }
            this._window.findChildByName("login_btn").enable();
            event.stopPropagation();
            event.stopImmediatePropagation();
        }

        public function populateUserList(k:Map)
        {
            var _local_4:IWindow = null;
            var _local_2= Std.downcast(this._window.findChildByName("list") , IItemListWindow);
            if (_local_2 == null)
            {
                return;
            }
            this._window.findChildByName("users_info").visible = false;
            var _local_3= this._userListItem.clone();
            _local_3.procedure = this.listEventHandler;
            var _local_5 = 0;
            while ((_local_5 : UInt) < k.length)
            {
                _local_4 = _local_3.clone();
                _local_4.id = ASCompat.toInt(k.getKey(_local_5));
                _local_4.caption = k.getWithIndex(_local_5);
                _local_2.addListItem(_local_4);
                _local_5++;
            }
            _local_3.dispose();
        }

        public function displayResults(k:String)
        {
            var _local_2= Std.downcast(this._window.findChildByName("text002") , ITextWindow);
            if (_local_2 != null)
            {
                _local_2.text = k;
            }
        }

        function handleKeyUp(k:WindowKeyboardEvent)
        {
            var _local_3 = 0;
            var _local_4:String = null;
            var _local_5:String = null;
            var _local_6:ITextFieldWindow = null;
            var _local_7:ITextFieldWindow = null;
            var _local_2= k ;
            if (_local_2.ctrlKey)
            {
                _local_3 = ASCompat.toInt(_local_2.keyCode - 49);
                if (((_local_3 >= 0) && (_local_3 < 10)))
                {
                    _local_4 = this._habboLogin.getProperty((("login.user." + Std.string(_local_3)) + ".name"));
                    _local_5 = this._habboLogin.getProperty((("login.user." + Std.string(_local_3)) + ".pass"));
                    _local_6 = Std.downcast(this._window.findChildByName("name_field") , ITextFieldWindow);
                    _local_7 = Std.downcast(this._window.findChildByName("pwd_field") , ITextFieldWindow);
                    if (_local_4 != "")
                    {
                        _local_6.caption = _local_4;
                    }
                    if (_local_5 != "")
                    {
                        _local_7.caption = _local_5;
                    }
                    _local_6.setSelection(_local_6.text.length, _local_6.text.length);
                    if (_local_2.cancelable)
                    {
                        _local_2.preventDefault();
                        _local_2.preventWindowOperation();
                    }
                    k.stopImmediatePropagation();
                    k.stopPropagation();
                }
            }
        }

        function windowEventProcessor(event:WindowEvent=null, window:IWindow=null)
        {
            var so:SharedObject = null;
            var loginBtn:IWindow = null;
            if (event.type == WindowKeyboardEvent.WINDOW_EVENT_KEY_UP)
            {
                this.handleKeyUp(Std.downcast(event , WindowKeyboardEvent));
                if (Std.downcast(event , WindowKeyboardEvent).keyCode != 13)
                {
                    return;
                }
            }
            if (HabboWebTools.isAirApplication)
            {
                if (this._airSubmitInFlight)
                {
                    return;
                }
                this._airSubmitInFlight = true;
                loginBtn = this._window.findChildByName("login_btn");
                if (loginBtn != null)
                {
                    loginBtn.disable();
                }
            }
            var nameField= Std.downcast(this._window.findChildByName("name_field") , ITextFieldWindow);
            var passField= Std.downcast(this._window.findChildByName("pwd_field") , ITextFieldWindow);
            if (nameField != null)
            {
                this.name = nameField.text;
            }
            if (passField != null)
            {
                this.password = passField.text;
            }
            try
            {
                so = SharedObject.getLocal(HabboLoginDemoView.SOL_ID, "/");
                so.data.login = this.name;
                so.data.password = this.password;
                so.flush();
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                Logger.log([("Could not store developer credentials to SharedObject: " + e)]);
            }
 }            if (HabboWebTools.isAirApplication)
            {
                this._habboLogin.setSSOTicket = this.name;
                HabboWebTools.airLoginAttemptActive = true;
                HabboWebTools.airLoginErrorShown = false;
                try
                {
                    so.data.air_sso = this.name;
                    so.flush();
                }
catch (__as3Caught:Dynamic) { var e2:ASError = ASError.caught(__as3Caught);                 {
                }
 }                this.setAirLoginStatus("Connecting...");
                dispatchEvent(new Event(INITCONNECTION));
            }
            else if (this.useSSOTicket)
            {
                this.initSSOTicket(this.useExistingSession);
            }
            else
            {
                dispatchEvent(new Event(INITCONNECTION));
            }
            this._window.findChildByName("login_btn").disable();
        }

        function listEventHandler(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this._habboLogin.sendTryLogin(this.name, this.password, _arg_2.id);
        }

        function initSSOTicket(k:Bool)
        {
            if (this._parsedTicket != null)
            {
                this._parsedTicket.removeEventListener(SSOTicket.SUCCESS, this.onParsedTicketSuccess);
                this._parsedTicket.removeEventListener(SSOTicket.FAILURE, this.onParsedTicketFailure);
                this._parsedTicket = null;
            }
            var _local_2= "";
            if (this._habboLogin != null)
            {
                _local_2 = this._habboLogin.getProperty("url.prefix");
                _local_2 = ASCompat.stringReplace(_local_2, "http://", "");
                _local_2 = ASCompat.stringReplace(_local_2, "https://", "");
            }
            var _local_3= this._habboLogin.communication.habboWebLogin(this.name, this.password);
            this._parsedTicket = new SSOTicket(this._habboLogin.assets, _local_3, _local_2, k);
            this._parsedTicket.addEventListener(SSOTicket.SUCCESS, this.onParsedTicketSuccess);
            this._parsedTicket.addEventListener(SSOTicket.FAILURE, this.onParsedTicketFailure);
        }

        function onParsedTicketSuccess(k:Event)
        {
            Logger.log([("Got ticket: " + this._parsedTicket.ticket)]);
            Logger.log([("Has Facebook: " + Std.string(this._parsedTicket.isFacebookUser))]);
            if (this._parsedTicket.isFacebookUser)
            {
                this._habboLogin.setProperty("facebook.user", "1");
            }
            this._habboLogin.flashClientUrl = this._parsedTicket.flashClientUrl;
            this._habboLogin.setSSOTicket = this._parsedTicket.ticket;
            this._parsedTicket.removeEventListener(SSOTicket.SUCCESS, this.onParsedTicketSuccess);
            this._parsedTicket.removeEventListener(SSOTicket.FAILURE, this.onParsedTicketFailure);
            this._parsedTicket = null;
            dispatchEvent(new Event(INITCONNECTION));
        }

        function onParsedTicketFailure(k:Event)
        {
            Logger.log(["Could not get a ticket! "]);
            this._parsedTicket.removeEventListener(SSOTicket.SUCCESS, this.onParsedTicketSuccess);
            this._parsedTicket.removeEventListener(SSOTicket.FAILURE, this.onParsedTicketFailure);
            this._parsedTicket = null;
            if (this._firstTryUsingExistingSession)
            {
                this._firstTryUsingExistingSession = false;
                if (((this._window != null) && (!this._window.disposed)))
                {
                    this._window.visible = true;
                }
            }
        }

        public function showError(k:Int, _arg_2:Int, _arg_3:String)
        {
            this._window.findChildByName("users_info").caption = ((("Received error: " + Std.string(k)) + " regarding message: ") + Std.string(_arg_2));
            this._window.findChildByName("login_btn").enable();
        }

        public function showAirLoginError(messageKey:String)
        {
            var statusText:IWindow = null;
            if (((this._window == null) || this._window.disposed))
            {
                this._airSubmitInFlight = false;
                return;
            }
            this._window.visible = true;
            HabboWebTools.showAirLoginBackground();
            HabboWebTools.setAirLoadingScreenVisible(false);
            statusText = this._window.findChildByName("status_text");
            if (statusText != null)
            {
                statusText.caption = (messageKey == null) ? "" : messageKey;
                statusText.visible = true;
            }
            this.startAirRetryCooldown();
        }

        function startAirRetryCooldown()
        {
            if (this._airRetryCooldown != null)
            {
                this._airRetryCooldown.stop();
                this._airRetryCooldown.removeEventListener(TimerEvent.TIMER_COMPLETE, (this.onAirRetryCooldownComplete : ASAny));
                this._airRetryCooldown = null;
            }
            this._airRetryCooldown = new Timer(AIR_RETRY_COOLDOWN_MS, 1);
            this._airRetryCooldown.addEventListener(TimerEvent.TIMER_COMPLETE, (this.onAirRetryCooldownComplete : ASAny));
            this._airRetryCooldown.start();
        }

        function onAirRetryCooldownComplete(event:TimerEvent)
        {
            var loginBtn:IWindow = null;
            if (this._airRetryCooldown != null)
            {
                this._airRetryCooldown.removeEventListener(TimerEvent.TIMER_COMPLETE, (this.onAirRetryCooldownComplete : ASAny));
                this._airRetryCooldown = null;
            }
            this._airSubmitInFlight = false;
            if (((this._window == null) || this._window.disposed))
            {
                return;
            }
            loginBtn = this._window.findChildByName("login_btn");
            if (loginBtn != null)
            {
                loginBtn.enable();
            }
        }

        public function setAirLoginStatus(messageKey:String)
        {
            var statusText:IWindow = null;
            if (((this._window == null) || this._window.disposed))
            {
                return;
            }
            statusText = this._window.findChildByName("status_text");
            if (statusText != null)
            {
                statusText.caption = (messageKey == null) ? "" : messageKey;
            }
        }

        function hideAirLoginBackground()
        {
            if (!HabboWebTools.isAirApplication)
            {
                return;
            }
            HabboWebTools.hideAirLoginBackground();
            if (((this._dialog != null) && (this._dialog.background != null)))
            {
                this._dialog.background.bitmap = new BitmapData(Std.int(Math.max(1, this._dialog.background.width)), Std.int(Math.max(1, this._dialog.background.height)), false, 0);
                this._dialog.background.invalidate();
            }
        }
    }









