package com.sulake.habbo.utils
;
    import flash.display.BitmapData;
    import flash.display.LoaderInfo;
    import flash.external.ExternalInterface;
    import flash.net.URLRequest;

     class HabboWebTools
    {
        public static inline final ADVERTISEMENT= "advertisement";
        public static inline final OPENLINK= "openlink";
        public static inline final OPENROOM= "openroom";
        static inline final AVATAR_ASSET_DIAGNOSTIC_LIMIT= 40;
        static var _isSpaWeb:Bool = false;
        static var _avatarAssetDiagnostics:Array<ASAny> = [];
        public static var rootLoaderInfo:LoaderInfo;
        public static var airParameters:ASObject;
        public static var isAirApplication:Bool = false;
        public static var isAirDesktop:Bool = false;
        public static var isAirMobile:Bool = false;
        public static var showAirLoginBackgroundCallback:ASFunction;
        public static var hideAirLoginBackgroundCallback:ASFunction;
        public static var renderAirLoginBackgroundCallback:ASFunction;
        public static var setAirLoadingScreenVisibleCallback:ASFunction;
        public static var reloadAirClientCallback:ASFunction;
        public static var returnToAirLoginCallback:ASFunction;
        public static var showAirLoginErrorCallback:ASFunction;
        public static var showAirErrorCallback:ASFunction;
        public static var setAirWindowTitleCallback:ASFunction;
        public static var airDebugLogCallback:ASFunction;
        public static var enterHomeRoomOnNextAirAuth:Bool = false;
        public static var airLoginScreenVisible:Bool = false;
        public static var airLoginAttemptActive:Bool = false;
        public static var airLoginErrorShown:Bool = false;
        public static var lastAirBanMessage:String;

        public static var isSpaWeb(never,set):Bool;
public static function  set_isSpaWeb(isSpaWeb:Bool):Bool        {
            return _isSpaWeb = isSpaWeb;
        }

        public static function logEventLog(data:String)
        {
            try
            {
                if (ExternalInterface.available)
                {
                    ExternalInterface.call("FlashExternalInterface.logEventLog", [data]);
                }
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                Logger.log(["External interface not working, failed to log event log."]);
            }
 }        }

        public static function getParameter(key:String, fallbackLoaderInfo:LoaderInfo=null):String
        {
            var normalizedKey= new compat.RegExp("[_]", "g").replace(key, ".");
            if (airParameters != null)
            {
                if (ASCompat.getDynamicProperty(airParameters, key)!= null)
                {
                    return ASCompat.toString(ASCompat.getDynamicProperty(airParameters, key));
                }
                if (ASCompat.getDynamicProperty(airParameters, normalizedKey)!= null)
                {
                    return ASCompat.toString(ASCompat.getDynamicProperty(airParameters, normalizedKey));
                }
            }
            if (((rootLoaderInfo != null) && (ASCompat.getDynamicProperty(ASCompat.loaderParameters(rootLoaderInfo), key)!= null)))
            {
                return ASCompat.toString(ASCompat.getDynamicProperty(ASCompat.loaderParameters(rootLoaderInfo), key));
            }
            if (((rootLoaderInfo != null) && (ASCompat.getDynamicProperty(ASCompat.loaderParameters(rootLoaderInfo), normalizedKey)!= null)))
            {
                return ASCompat.toString(ASCompat.getDynamicProperty(ASCompat.loaderParameters(rootLoaderInfo), normalizedKey));
            }
            if (((fallbackLoaderInfo != null) && (ASCompat.getDynamicProperty(ASCompat.loaderParameters(fallbackLoaderInfo), key)!= null)))
            {
                return ASCompat.toString(ASCompat.getDynamicProperty(ASCompat.loaderParameters(fallbackLoaderInfo), key));
            }
            if (((fallbackLoaderInfo != null) && (ASCompat.getDynamicProperty(ASCompat.loaderParameters(fallbackLoaderInfo), normalizedKey)!= null)))
            {
                return ASCompat.toString(ASCompat.getDynamicProperty(ASCompat.loaderParameters(fallbackLoaderInfo), normalizedKey));
            }
            return null;
        }

        public static function getParameterMap(fallbackLoaderInfo:LoaderInfo=null):ASObject
        {
var key:String  = null;            var key:String = null;
            var parameters:ASObject = {};
            if (fallbackLoaderInfo != null)
            {
                final _iter_:ASObject = ASCompat.loaderParameters(fallbackLoaderInfo); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.___keys())
                {
key = _tmp_;
ASCompat.setDynamicProperty(                    parameters, key, ASCompat.getDynamicProperty(ASCompat.loaderParameters(fallbackLoaderInfo), key));
                }
            }
            else if (rootLoaderInfo != null)
            {
                final _iter_:ASObject = ASCompat.loaderParameters(rootLoaderInfo); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.___keys())
                {
key = _tmp_;
ASCompat.setDynamicProperty(                    parameters, key, ASCompat.getDynamicProperty(ASCompat.loaderParameters(rootLoaderInfo), key));
                }
            }
            if (airParameters != null)
            {
                final _iter_:ASObject = airParameters; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.___keys())
                {
key = _tmp_;
ASCompat.setDynamicProperty(                    parameters, key, ASCompat.getDynamicProperty(airParameters, key));
                }
            }
            return parameters;
        }

        public static function showAirLoginBackground()
        {
            airLoginScreenVisible = true;
            if (showAirLoginBackgroundCallback != null)
            {
                showAirLoginBackgroundCallback();
            }
        }

        public static function hideAirLoginBackground()
        {
            airLoginScreenVisible = false;
            if (hideAirLoginBackgroundCallback != null)
            {
                hideAirLoginBackgroundCallback();
            }
        }

        public static function renderAirLoginBackground(target:BitmapData):Bool
        {
            if (renderAirLoginBackgroundCallback == null)
            {
                return false;
            }
            return ASCompat.toBool(renderAirLoginBackgroundCallback(target));
        }

        public static function setAirLoadingScreenVisible(visible:Bool)
        {
            if (setAirLoadingScreenVisibleCallback != null)
            {
                setAirLoadingScreenVisibleCallback(visible);
            }
        }

        public static function returnToAirLogin()
        {
            if (reloadAirClientCallback != null)
            {
                ASCompat.setTimeout(reloadAirClientCallback, 1);
                return;
            }
            if (returnToAirLoginCallback != null)
            {
                returnToAirLoginCallback();
            }
        }

        public static function showAirLoginError(message:String)
        {
            airLoginAttemptActive = false;
            airLoginErrorShown = true;
            airDebug("LOGIN ERROR: " + message);
            if (showAirLoginErrorCallback != null)
            {
                showAirLoginErrorCallback(message);
            }
            if (showAirErrorCallback != null)
            {
                showAirErrorCallback("Could not connect to the hotel server", message, "Check that the emulator/server is running and that connection.info.host / connection.info.port in config.ini are correct.");
            }
        }

        public static function airDebug(message:String)
        {
            if (airDebugLogCallback != null)
            {
                airDebugLogCallback(message);
            }
        }

        public static function recordAvatarAssetDiagnostic(state:String, libraryName:String, url:String=null, details:String=null)
        {
            var message= "state=" + state + " lib=" + libraryName;
            if (url != null && url.length > 0)
            {
                message += " url=" + url;
            }
            if (details != null && details.length > 0)
            {
                message += " " + details;
            }
            _avatarAssetDiagnostics.push(message);
            while (_avatarAssetDiagnostics.length > AVATAR_ASSET_DIAGNOSTIC_LIMIT)
            {
                _avatarAssetDiagnostics.shift();
            }
        }

        public static function getAvatarAssetDiagnostics():String
        {
            return _avatarAssetDiagnostics.join(" || ");
        }

        public static function showAirError(title:String, message:String, details:String=null)
        {
            airDebug("ERROR: " + title + " - " + message + ((details != null && details.length > 0) ? (" | " + details) : ""));
            if (showAirErrorCallback != null)
            {
                showAirErrorCallback(title, message, details);
            }
        }

        public static function rememberAirBanMessage(message:String)
        {
            lastAirBanMessage = message;
            airDebug("BAN MESSAGE: " + ((message != null && message.length > 0) ? message : "(empty)"));
        }

        public static function setAirWindowTitleForUser(userName:String)
        {
            if (setAirWindowTitleCallback != null)
            {
                setAirWindowTitleCallback(userName);
            }
        }

        public static function openWebPage(url:String, targetWindow:String="")
        {
            var strUserAgent:String = null;
            if (((targetWindow == null) || (targetWindow == "")))
            {
                targetWindow = ADVERTISEMENT;
            }
            var req= new URLRequest(url);
            if (!ExternalInterface.available)
            {
                flash.Lib.getURL(req, targetWindow);
            }
            else
            {
                try
                {
                    strUserAgent = ASCompat.toString(ExternalInterface.call("function() {return navigator.userAgent;}")).toLowerCase();
                    if (strUserAgent.indexOf("firefox") >= 0)
                    {
                        ExternalInterface.call("window.open", [req.url, targetWindow]);
                    }
                    else
                    {
                        if (strUserAgent.indexOf("msie") >= 0)
                        {
                            ExternalInterface.call((((("function setWMWindow() {window.open('" + req.url) + "', '") + targetWindow) + "');}"));
                        }
                        else
                        {
                            flash.Lib.getURL(req, targetWindow);
                        }
                    }
                }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                 {
                    Logger.log(["External interface not working, failed to open web page."]);
                }
 }            }
        }

        public static function openPage(pageUrl:String)
        {
            try
            {
                if (ExternalInterface.available)
                {
                    ExternalInterface.call("FlashExternalInterface.openPage", [pageUrl]);
                }
                else
                {
                    Logger.log(["External interface not available, openPage failed."]);
                }
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                Logger.log([("Failed to open web page " + pageUrl)]);
            }
 }        }

        public static function sendHeartBeat()
        {
            try
            {
                if (ExternalInterface.available)
                {
                    ExternalInterface.call("FlashExternalInterface.heartBeat");
                }
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
            }
 }        }

        public static function openWebPageAndMinimizeClient(pageUrl:String)
        {
            try
            {
                if (ExternalInterface.available)
                {
                    if (_isSpaWeb)
                    {
                        openPage(pageUrl);
                    }
                    else
                    {
                        ExternalInterface.call("FlashExternalInterface.openWebPageAndMinimizeClient", [pageUrl]);
                    }
                }
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                Logger.log([("Failed to open web page " + pageUrl)]);
            }
 }        }

        public static function closeWebPageAndRestoreClient()
        {
            try
            {
                if (ExternalInterface.available)
                {
                    ExternalInterface.call("FlashExternalInterface.closeWebPageAndRestoreClient");
                }
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                Logger.log(["Failed to close web page and restore client!"]);
            }
 }        }

        public static function openHabblet(name:String, param:String=null)
        {
            try
            {
                if (ExternalInterface.available)
                {
                    ExternalInterface.call("FlashExternalInterface.openHabblet", [name, param]);
                }
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                Logger.log([("Failed to open Habblet " + name)]);
            }
 }        }

        public static function closeHabblet(name:String, param:String=null)
        {
            try
            {
                if (ExternalInterface.available)
                {
                    ExternalInterface.call("FlashExternalInterface.closeHabblet", [name, param]);
                }
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                Logger.log([("Failed to close Habblet " + name)]);
            }
 }        }

        public static function send(reasonCode:Int, reasonString:String)
        {
            try
            {
                if (ExternalInterface.available)
                {
                    ExternalInterface.call("FlashExternalInterface.disconnect", [reasonCode, reasonString]);
                }
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                Logger.log(["Failed to close send "]);
            }
 }        }

        public static function showGame(gameUrl:String)
        {
            try
            {
                if (ExternalInterface.available)
                {
                    ExternalInterface.call("FlashExternalGameInterface.showGame", [gameUrl]);
                }
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                Logger.log([("Failed to open game: " + e)]);
            }
 }        }

        public static function hideGame()
        {
            try
            {
                if (ExternalInterface.available)
                {
                    ExternalInterface.call("FlashExternalGameInterface.hideGame");
                }
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                Logger.log(["Failed to hide game"]);
            }
 }        }

        public static function navigateToURL(k:String, _arg_2:String=null)
        {
            var _local_3= new URLRequest(k);
            flash.Lib.getURL(_local_3, _arg_2);
        }

        public static function open(url:String)
        {
            try
            {
                if (ExternalInterface.available)
                {
                    ExternalInterface.call("FlashExternalInterface.openExternalLink", [ASCompat.escape(url)]);
                }
                else
                {
                    Logger.log([("External interface not available. Could not request to open: " + url)]);
                }
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                Logger.log([("External interface not working. Could not request to open: " + url)]);
            }
 }        }

        public static function roomVisited(roomId:Int)
        {
            try
            {
                if (ExternalInterface.available)
                {
                    ExternalInterface.call("FlashExternalInterface.roomVisited", [roomId]);
                }
                else
                {
                    Logger.log(["External interface not available. Could not store last room visit."]);
                }
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                Logger.log(["External interface not working. Could not store last room visit."]);
            }
 }        }

        public static function openMinimail(target:String)
        {
            try
            {
                if (ExternalInterface.available)
                {
                    if (_isSpaWeb)
                    {
                        ExternalInterface.call("FlashExternalInterface.openMinimail", [target]);
                    }
                    else
                    {
                        openHabblet("minimail", target);
                    }
                }
                else
                {
                    Logger.log(["External interface not available. Could not open minimail."]);
                }
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                Logger.log(["External interface not working. Could not open minimail."]);
            }
 }        }

        public static function openNews()
        {
            try
            {
                if (ExternalInterface.available)
                {
                    if (_isSpaWeb)
                    {
                        ExternalInterface.call("FlashExternalInterface.openNews");
                    }
                    else
                    {
                        openHabblet("news");
                    }
                }
                else
                {
                    Logger.log(["External interface not available. Could not open news."]);
                }
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                Logger.log(["External interface not working. Could not open news."]);
            }
 }        }

        public static function closeNews()
        {
            try
            {
                if (ExternalInterface.available)
                {
                    if (_isSpaWeb)
                    {
                        ExternalInterface.call("FlashExternalInterface.closeNews");
                    }
                    else
                    {
                        closeHabblet("news");
                    }
                }
                else
                {
                    Logger.log(["External interface not available. Could not close news."]);
                }
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                Logger.log(["External interface not working. Could not close news."]);
            }
 }        }

        public static function openAvatars()
        {
            try
            {
                if (ExternalInterface.available)
                {
                    if (_isSpaWeb)
                    {
                        ExternalInterface.call("FlashExternalInterface.openAvatars");
                    }
                    else
                    {
                        openHabblet("avatars");
                    }
                }
                else
                {
                    Logger.log(["External interface not available. Could not open avatars."]);
                }
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                Logger.log(["External interface not working. Could not open avatars."]);
            }
 }        }

        public static function openRoomEnterAd()
        {
            try
            {
                if (ExternalInterface.available)
                {
                    if (_isSpaWeb)
                    {
                        ExternalInterface.call("FlashExternalInterface.openRoomEnterAd");
                    }
                    else
                    {
                        openHabblet("roomenterad", "");
                    }
                }
                else
                {
                    Logger.log(["External interface not available. Could not open roomenterad."]);
                }
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                Logger.log(["External interface not working. Could not open roomenterad."]);
            }
 }        }

        public static function updateFigure(figure:String)
        {
            try
            {
                if (ExternalInterface.available)
                {
                    if (_isSpaWeb)
                    {
                        ExternalInterface.call("FlashExternalInterface.updateFigure", [figure]);
                    }
                }
                else
                {
                    Logger.log(["External interface not available. Could not update figure."]);
                }
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                Logger.log(["External interface not working. Could not update figure."]);
            }
 }        }

	public function new() {}
    }

