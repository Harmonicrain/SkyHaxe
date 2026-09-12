package com.sulake.habbo.communication.demo
;
    import com.sulake.core.runtime.events.EventDispatcherWrapper;
    import flash.net.URLLoader;
    import com.sulake.habbo.communication.IHabboWebLogin;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.communication._enum.HabboWeb;
    import flash.net.URLRequest;
    import com.sulake.core.assets.AssetLoaderStruct;
    import com.sulake.core.assets.loaders.AssetLoaderEvent;
    import flash.events.Event;

     class SSOTicket extends EventDispatcherWrapper 
    {
        public static inline final SUCCESS= "success";
        public static inline final FAILURE= "failure";

        var _loader:URLLoader;
        var _clientURL:String;
        var _habboWebLogin:IHabboWebLogin;
        var _sessionId:String;
        var _ticket:String;
        var _flashClientUrl:String;
        var _assets:IAssetLibrary;
        var _isFacebookUser:Bool = false;

        public function new(k:IAssetLibrary, _arg_2:IHabboWebLogin, _arg_3:String, _arg_4:Bool=true)
        {
            super();
            this._assets = k;
            this._habboWebLogin = _arg_2;
            this._clientURL = (("http://" + _arg_3) + "/client");
            if (!_arg_4)
            {
                this._habboWebLogin.init();
                this._habboWebLogin.addEventListener(HabboWeb.HABBO_WEB_LOGIN_SUCCESSFUL, this.requestClientURL);
            }
            else
            {
                this.requestClientURL();
            }
        }

        public var ticket(get,never):String;
public function  get_ticket():String
        {
            return this._ticket;
        }

        public var isFacebookUser(get,never):Bool;
public function  get_isFacebookUser():Bool
        {
            return this._isFacebookUser;
        }

        public var flashClientUrl(get,never):String;
public function  get_flashClientUrl():String
        {
            return this._flashClientUrl;
        }

        function requestClientURL(k:Event=null)
        {
            var _local_2= this._clientURL;
            if (this._assets.hasAsset(_local_2))
            {
            }
            var _local_3= new URLRequest(this._clientURL);
            if (this._assets.hasAsset(_local_2))
            {
                this._assets.removeAsset(this._assets.getAssetByName(_local_2));
            }
            var _local_4= this._assets.loadAssetFromFile(_local_2, _local_3, "text/plain");
            _local_4.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTCOMPLETE, this.clientURLComplete);
        }

        function clientURLComplete(event:Event=null)
        {
            var facebookData:ASObject = null;
            var loaderStruct= ASCompat.dynamicAs(event.target , AssetLoaderStruct);
            if (loaderStruct == null)
            {
                return;
            }
            var data= ASCompat.asString(loaderStruct.assetLoader.content );
            if (data.indexOf('account/reauthenticate"') > -1)
            {
                this._habboWebLogin.requestReAuthenticate();
            }
            else
            {
                try
                {
                    this._ticket = new compat.RegExp("\\\"sso.ticket\\\" : \\\"(.*?)\\\"").exec(data)[1];
                    this._flashClientUrl = new compat.RegExp("\\\"flash.client.url\\\" : \\\"(.*?)\\\"").exec(data)[1];
                    facebookData = new compat.RegExp("\\\"facebook.user\\\" : \\\"(.*?)\\\"").exec(data);
                    if (facebookData)
                    {
                        this._isFacebookUser = ASCompat.toBool(facebookData[Std.string(1)]);
                    }
                    if (this._ticket.length > 0)
                    {
                        dispatchEvent(new Event(SUCCESS));
                    }
                    else
                    {
                        dispatchEvent(new Event(FAILURE));
                    }
                }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                 {
                    Logger.log([e]);
                    dispatchEvent(new Event(FAILURE));
                }
 }            }
        }
    }

