package com.sulake.habbo.communication
;
    import com.sulake.core.runtime.events.EventDispatcherWrapper;
    import flash.net.URLRequestHeader;
    import flash.net.URLLoader;
    import flash.events.IEventDispatcher;
    import flash.net.URLRequest;
    import flash.net.URLVariables;
    import flash.net.URLRequestMethod;
    import flash.events.Event;
    import com.sulake.habbo.communication._enum.HabboWeb;
    import flash.events.SecurityErrorEvent;
    import flash.events.HTTPStatusEvent;
    import flash.events.IOErrorEvent;

     class HabboWebLogin extends EventDispatcherWrapper implements IHabboWebLogin 
    {
        static final userAgentHeader:URLRequestHeader = new URLRequestHeader("User-Agent", "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20100101 Firefox/14.0.1 FirePHP/0.7.1");

        var _loader:URLLoader;
        var _name:String;
        var _password:String;
        var _loginURL:String;
        var _securityCheckURL:String;
        var _reauthenticateURL:String;

        public function new(k:String, _arg_2:String, _arg_3:String, _arg_4:IEventDispatcher=null)
        {
            super(_arg_4);
            this._name = k;
            this._password = _arg_2;
            this._loginURL = (("https://" + _arg_3) + "/account/submit");
            this._securityCheckURL = (("https://" + _arg_3) + "/security_check");
            this._reauthenticateURL = (("https://" + _arg_3) + "/account/reauthenticate");
        }

        public function init()
        {
            this.requestCredentials();
        }

        function requestCredentials()
        {
            var k= ((("credentials.username=" + this._name) + "&credentials.password=") + this._password);
            var _local_2= new URLRequest(this._loginURL);
            _local_2.data = new URLVariables(k);
            _local_2.method = URLRequestMethod.POST;
            this._loader = new URLLoader();
            this._loader.addEventListener(Event.COMPLETE, (this.credentialsComplete : ASAny));
            this.configureListeners(this._loader);
            this._loader.load(_local_2);
        }

        function credentialsComplete(k:Event=null)
        {
            var _local_4:String = null;
            var _local_5:URLRequest = null;
            var _local_2= cast(k.target, URLLoader);
            var _local_3:String = _local_2.data;
            if (((_local_3.indexOf("Redirecting") > -1) && (!(_local_3.indexOf("/useOrCreateAvatar/") == -1))))
            {
                _local_4 = new compat.RegExp("<meta http-equiv=\"Refresh\" content=\"0;URL=(.*?)\">").exec(_local_3)[1];
                _local_5 = new URLRequest(_local_4);
                this._loader.load(_local_5);
                return;
            }
            this._loader.removeEventListener(Event.COMPLETE, (this.credentialsComplete : ASAny));
            this.removeListeners(this._loader);
            if (_local_3.indexOf("Redirecting") > -1)
            {
                this.requestSecurityCheck();
            }
            else
            {
                if (_local_3.indexOf("Habbo ~ Me") > -1)
                {
                    dispatchEvent(new Event(HabboWeb.HABBO_WEB_LOGIN_SUCCESSFUL));
                }
                else
                {
                    if (_local_3.indexOf("Habbo ~ Home") > -1)
                    {
                        dispatchEvent(new Event(HabboWeb.HABBO_WEB_LOGIN_SUCCESSFUL));
                    }
                    else
                    {
                        if (_local_3.indexOf("Habbo: Home") > -1)
                        {
                            dispatchEvent(new Event(HabboWeb.HABBO_WEB_LOGIN_SUCCESSFUL));
                        }
                        else
                        {
                            if (_local_3.indexOf("document.habboLoggedIn = true") > -1)
                            {
                                dispatchEvent(new Event(HabboWeb.HABBO_WEB_LOGIN_SUCCESSFUL));
                            }
                            else
                            {
                                Logger.log([("Login failed. Received page:\n" + _local_3)]);
                            }
                        }
                    }
                }
            }
        }

        function requestSecurityCheck()
        {
            var k= new URLRequest(this._securityCheckURL);
            this._loader = new URLLoader();
            this._loader.addEventListener(Event.COMPLETE, (this.securityCheckComplete : ASAny));
            this.configureListeners(this._loader);
            this._loader.load(k);
        }

        function securityCheckComplete(k:Event=null)
        {
            var _local_2= cast(k.target, URLLoader);
            this._loader.removeEventListener(Event.COMPLETE, (this.securityCheckComplete : ASAny));
            this.removeListeners(this._loader);
            var _local_3:String = _local_2.data;
            if (_local_3.indexOf("Redirecting") > -1)
            {
                dispatchEvent(new Event(HabboWeb.HABBO_WEB_LOGIN_SUCCESSFUL));
            }
        }

        public function requestReAuthenticate()
        {
            var k= ("page=%2Fclient&credentials.password=" + this._password);
            var _local_2= new URLRequest(this._reauthenticateURL);
            _local_2.data = new URLVariables(k);
            _local_2.method = URLRequestMethod.POST;
            this._loader = new URLLoader();
            this._loader.addEventListener(Event.COMPLETE, (this.reauthenticateComplete : ASAny));
            this.configureListeners(this._loader);
            this._loader.load(_local_2);
        }

        function reauthenticateComplete(k:Event=null)
        {
            var _local_2= cast(k.target, URLLoader);
            this._loader.removeEventListener(Event.COMPLETE, (this.reauthenticateComplete : ASAny));
            this.removeListeners(this._loader);
            var _local_3:String = _local_2.data;
            if (_local_3.indexOf("Redirecting") > -1)
            {
                dispatchEvent(new Event(HabboWeb.HABBO_WEB_LOGIN_SUCCESSFUL));
            }
        }

        function configureListeners(k:IEventDispatcher)
        {
            k.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
            k.addEventListener(HTTPStatusEvent.HTTP_STATUS, this.httpStatusHandler);
            k.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
        }

        function removeListeners(k:IEventDispatcher)
        {
            k.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
            k.removeEventListener(HTTPStatusEvent.HTTP_STATUS, this.httpStatusHandler);
            k.removeEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
        }

        function ioErrorHandler(k:IOErrorEvent)
        {
        }

        function httpStatusHandler(k:HTTPStatusEvent)
        {
        }

        function securityErrorHandler(k:SecurityErrorEvent)
        {
        }
    }

