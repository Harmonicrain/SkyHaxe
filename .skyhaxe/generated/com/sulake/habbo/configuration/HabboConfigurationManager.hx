package com.sulake.habbo.configuration
;
    import com.sulake.core.runtime.Component;
    import com.sulake.core.runtime.IHabboConfigurationManager;
    import com.sulake.habbo.configuration._enum.HabboConfigurationFlags;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.runtime.ComponentDependency;
    import com.sulake.iid.IIDHabboLocalizationManager;
    import flash.events.Event;
    import flash.net.URLRequest;
    import com.sulake.core.assets.AssetLoaderStruct;
    import com.sulake.core.assets.loaders.AssetLoaderEvent;
    import com.sulake.habbo.utils.HabboWebTools;
    import com.sulake.core.Core;
    import com.sulake.core.utils.ErrorReportStorage;
    import flash.system.Security;
    import com.sulake.core.assets.TextAsset;

     class HabboConfigurationManager extends Component implements IHabboConfigurationManager 
    {
        static inline final INTERPOLATION_DEPTH_LIMIT= 3;
        static inline final REPLACE_CHAR= "%";
        static inline final SOL_ID= "fuselogin";

        var _skipExternalConfigurations:Bool = false;
        var _skipLocalizations:Bool = false;
        var _configurations:ASDictionary<ASAny,ASAny>;
        var _initialized:Bool = false;
        var _readOnlyProperties:Array<ASAny>;
        var _useHttps:Bool = false;

        public function new(k:IContext, _arg_2:UInt=0, _arg_3:IAssetLibrary=null)
        {
            this._readOnlyProperties = [];
            super(k, _arg_2, _arg_3);
            k.configuration = this;
            this._skipExternalConfigurations = ((ASCompat.toInt(_arg_2 )& ASCompat.toInt(HabboConfigurationFlags._Str_18739)) > 0);
            this._skipLocalizations = ((ASCompat.toInt(_arg_2 )& ASCompat.toInt(HabboConfigurationFlags._Str_18181)) > 0);
            this._configurations = new ASDictionary<ASAny,ASAny>();
            this.parseCommonVariables();
            this.parseLocalizationVariables();
            this.setDefaults();
            this.setupDefaultDevelopmentEnvironment();
        }

        override function  get_dependencies():Vector<ComponentDependency>
        {
            return super.dependencies.concat(Vector.ofArray([new ComponentDependency(new IIDHabboLocalizationManager(), null, false, [{
                "type":Event.COMPLETE,
                "callback":this.onLocalizationComplete
            }])]));
        }

        override function initComponent()
        {
        }

        function setupDefaultDevelopmentEnvironment()
        {
            if (this._skipExternalConfigurations)
            {
                this._initialized = true;
                events.dispatchEvent(new Event(Event.COMPLETE));
            }
            else
            {
                lock();
                if (this._skipLocalizations)
                {
                    this.initConfigurationDownload();
                }
            }
        }

        override public function dispose()
        {
            super.dispose();
        }

        override public function propertyExists(k:String):Bool
        {
            var _local_2= ASCompat.asString(this._configurations[k] );
            return !(_local_2 == null);
        }

        override public function getProperty(k:String, _arg_2:ASDictionary<ASAny,ASAny>=null):String
        {
            var _local_3= ASCompat.asString(this._configurations[k] );
            _local_3 = this.interpolate(_local_3);
            if (_local_3 == null)
            {
                return "";
            }
            if (_local_3.substr(0, 2) == "//")
            {
                _local_3 = ((this._useHttps ? "https:" : "http:") + _local_3);
            }
            _local_3 = this.updateUrlProtocol(_local_3);
            if (_arg_2 != null)
            {
                _local_3 = this.fillParams(_local_3, _arg_2);
            }
            return _local_3;
        }

        override public function setProperty(k:String, _arg_2:String, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            if (_arg_4)
            {
                if (this._configurations[k] == null)
                {
                    Logger.log([((k + "=") + _arg_2)]);
                }
            }
            if (((this._readOnlyProperties.indexOf(k) < 0) || _arg_3))
            {
                this._configurations[k] = _arg_2;
            }
            if (_arg_3)
            {
                this._readOnlyProperties.push(k);
            }
        }

        override public function getBoolean(k:String):Bool
        {
            var _local_2= ASCompat.asString(this._configurations[k] );
            if (_local_2 == null)
            {
                return false;
            }
            return (_local_2 == "1") || (_local_2.toLowerCase() == "true");
        }

        override public function getInteger(k:String, _arg_2:Int):Int
        {
            var _local_3= ASCompat.asString(this._configurations[k] );
            if (_local_3 == null)
            {
                return _arg_2;
            }
            return ASCompat.toInt(_local_3);
        }

        override public function updateUrlProtocol(k:String):String
        {
            var _local_2= k;
            if (this._useHttps)
            {
                _local_2 = ASCompat.stringReplace(k, "http://", "https://");
                _local_2 = ASCompat.stringReplace(_local_2, ":8080/", ":8443/");
            }
            return _local_2;
        }

        override public function interpolate(k:String):String
        {
            var _local_5:ASObject = null;
            var _local_6 = 0;
            var _local_7:String = null;
            if (k == null)
            {
                return null;
            }
            var _local_2= k;
            var _local_3= new compat.RegExp("\\${([^}]*)}", "g");
            var _local_4 = 0;
            while (_local_4 < INTERPOLATION_DEPTH_LIMIT)
            {
                _local_6 = 0;
                _local_7 = "";
                do 
                {
                    _local_5 = _local_3.exec(_local_2);
                    if (_local_5 == null)
                    {
                        break;
                    }
                    if (!this.propertyExists(_local_5[Std.string(1)]))
                    {
                        return null;
                    }
                    _local_7 = (_local_7 + _local_2.substring(_local_6, ASCompat.toInt(_local_5.index)));
                    _local_7 = (_local_7 + this.getProperty(_local_5[Std.string(1)]));
                    _local_6 = ASCompat.toInt(_local_5.index + _local_5[Std.string(0)].length);
                } while (true);
                _local_7 = (_local_7 + _local_2.substring(_local_6));
                if (_local_7 == _local_2)
                {
                    break;
                }
                _local_2 = _local_7;
                _local_4++;
            }
            return _local_7;
        }

        function onLocalizationComplete(k:Event)
        {
            this.initConfigurationDownload();
        }

        function initConfigurationDownload()
        {
            if (this._initialized)
            {
                return;
            }
            var k= this.getProperty("external.variables.txt");
            if (assets.hasAsset(k))
            {
            }
            var _local_2= new URLRequest(k);
            var _local_3= assets.loadAssetFromFile(k, _local_2, "text/plain");
            _local_3.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTCOMPLETE, this.onInitConfiguration);
            _local_3.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTERROR, this.onConfigurationError);
        }

        function parseConfiguration(k:String)
        {
            if (k == null || k.length == 0)
            {
                return;
            }
            var _local_first= this.stripLeading(k);
            if (_local_first.length > 0 && _local_first.charAt(0) == "{")
            {
                this.parseConfigurationJSON(_local_first);
            }
            else
            {
                this.parseConfigurationFlat(k);
            }
        }

        function stripLeading(k:String):String
        {
var _local_3:String  = null;            var _local_2= 0;
            if (k.length > 0 && k.charCodeAt(0) == 0xFEFF)
            {
                _local_2 = 1;
            }
            while (_local_2 < k.length)
            {
_local_3= k.charAt(_local_2);
                if (_local_3 == " " || _local_3 == "\t" || _local_3 == "\n" || _local_3 == "\r")
                {
                    _local_2++;
                    continue;
                }
                break;
            }
            return k.substr(_local_2);
        }

        function stripJSONComments(k:String):String
        {
            var _local_2= new compat.RegExp("\\/\\*[\\s\\S]*?\\*\\/", "g").replace(k, "");
            _local_2 = new compat.RegExp("^\\s*\\/\\/.*$", "gm").replace(_local_2, "");
            return _local_2;
        }

        function parseConfigurationJSON(k:String)
        {
            var _local_2:ASObject = null;
            try
            {
                _local_2 = haxe.Json.parse(this.stripJSONComments(k));
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                Logger.log(["ERROR: failed to parse external variables JSON: " + e.message]);
                return;
            }
 }            var _local_3= false;
            if (_local_2 != null && ASCompat.hasOwnProperty(_local_2, "_readonly"))
            {
                _local_3 = (ASCompat.getDynamicProperty(_local_2, "_readonly")== true);
                Reflect.deleteField(_local_2, "_readonly");
            }
            this.flattenAndApply(_local_2, "", _local_3);
        }

        function flattenAndApply(k:ASObject, _arg_2:String, _arg_3:Bool)
        {
var _local_4:String  = null;            var _local_4:String = null;
            var _local_5:ASAny = null;
            var _local_6:String = null;
            var _local_7 = 0;
            var _local_8 = false;
            if (k == null)
            {
                return;
            }
            if (Std.is(k , Array))
            {
                _local_7 = 0;
                while (_local_7 < ((ASCompat.dynamicAs(k , Array) : Array<ASAny>)).length)
                {
                    _local_6 = (_arg_2.length > 0) ? (_arg_2 + "." + Std.string(_local_7)) : ("" + Std.string(_local_7));
                    this.flattenAndApply(((ASCompat.dynamicAs(k , Array) : Array<ASAny>))[_local_7], _local_6, _arg_3);
                    _local_7++;
                }
                return;
            }
            _local_8 = false;
            if (checkNullIteratee(k)) for (_tmp_ in k.___keys())
            {
_local_4 = _tmp_;
                if (_local_4 == "$")
                {
                    _local_8 = true;
                    continue;
                }
                _local_5 = ASCompat.getDynamicProperty(k, _local_4);
                _local_6 = (_arg_2.length > 0) ? (_arg_2 + "." + _local_4) : _local_4;
                this.applyJSONValue(_local_5, _local_6, _arg_3);
            }
            if (_local_8 && _arg_2.length > 0)
            {
                this.applyJSONValue(ASCompat.getDynamicProperty(k, "$"), _arg_2, _arg_3);
            }
        }

        function applyJSONValue(k:ASAny, _arg_2:String, _arg_3:Bool)
        {
            if (k == null)
            {
                this.setProperty(_arg_2, "", _arg_3);
            }
            else if (Std.is(k , String))
            {
                this.setProperty(_arg_2, ASCompat.asString(k ), _arg_3);
            }
            else if (Std.is(k , Float) || Std.is(k , Int) || com.sulake.core.utils.ASNumericType.isUInt(k ))
            {
                this.setProperty(_arg_2, ASCompat.toString(k), _arg_3);
            }
            else if (Std.is(k , Bool))
            {
                this.setProperty(_arg_2, (ASCompat.asBoolean(k ) ? "true" : "false"), _arg_3);
            }
            else
            {
                this.flattenAndApply(k, _arg_2, _arg_3);
            }
        }

        function parseConfigurationFlat(k:String)
        {
            var _local_6:String = null;
            var _local_7:Array<ASAny> = null;
            var _local_8:String = null;
            var _local_9:String = null;
            var _local_2= new compat.RegExp("\\n\\r{1,}|\\n{1,}|\\r{1,}", "mg");
            var _local_3= new compat.RegExp("^\\s+|\\s+$", "g");
            var _local_4:Array<ASAny> = (cast _local_2.split(k));
            var _local_5 = false;
            if (checkNullIteratee(_local_4)) for (_tmp_ in _local_4)
            {
_local_6  = _tmp_;
                if (((_local_6.substr(0, 1) == "#") || (_local_6 == "")))
                {
                }
                else
                {
                    _local_7 = (cast _local_6.split("="));
                    if ((((_local_7.length >= 2) && (_local_7[0].length > 0)) && (_local_7[1].length > 0)))
                    {
                        _local_8 = _local_7.shift();
                        _local_9 = _local_7.join("=");
                        _local_8 = _local_3.replace(_local_8, "");
                        _local_9 = _local_3.replace(_local_9, "");
                        if (((_local_8 == "configuration.readonly") && (_local_9 == "true")))
                        {
                            _local_5 = true;
                        }
                        this.setProperty(_local_8, _local_9, _local_5);
                    }
                }
            }
        }

        function fillParams(k:String, _arg_2:ASDictionary<ASAny,ASAny>):String
        {
            var _local_4 = 0;
            var _local_5 = 0;
            var _local_6:String = null;
            var _local_7:String = null;
            var _local_3 = 0;
            while (_local_3 < 10)
            {
                _local_4 = k.indexOf(REPLACE_CHAR);
                if (_local_4 < 0)
                {
                    break;
                }
                _local_5 = k.indexOf(REPLACE_CHAR, (_local_4 + 1));
                if (_local_5 < 0)
                {
                    break;
                }
                _local_6 = k.substring((_local_4 + 1), _local_5);
                _local_7 = _arg_2[_local_6];
                k = ASCompat.stringReplace(k, (("%" + _local_6) + "%"), _local_7);
                _local_3++;
            }
            return k;
        }

        function onConfigurationError(k:Event=null)
        {
            var _local_2= Std.downcast(k , AssetLoaderEvent);
            var _local_3 = 0;
            if (_local_2 != null)
            {
                _local_3 = _local_2.status;
            }
            Logger.log([_local_2.toString()]);
            HabboWebTools.logEventLog(("external_variables download error " + Std.string(_local_3)));
            Core.error((((("Could not load external variables. Failed to load URL " + this.getProperty("external.variables.txt")) + "HTTP status ") + Std.string(_local_3)) + ". Client startup failed!"), true, Core.ERROR_CATEGORY_DOWNLOAD_EXTERNAL_VARIABLES);
        }

        function onInitConfiguration(k:Event=null)
        {
            var _local_6 = 0;
            var _local_7:URLRequest = null;
            var _local_8:AssetLoaderStruct = null;
            if (disposed)
            {
                return;
            }
            var _local_2= ASCompat.dynamicAs(k.target , AssetLoaderStruct);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= ASCompat.asString(_local_2.assetLoader.content );
            if (_local_3 != null)
            {
                this.parseConfiguration(_local_3);
            }
            var _local_4= assets.getAssetByName(_local_2.assetName);
            if (_local_4 != null)
            {
                assets.removeAsset(_local_4).dispose();
            }
            if (((_local_3 == null) || (_local_3.length == 0)))
            {
                _local_6 = ((_local_3 != null) ? _local_3.length : -1);
                Core.error((((("Could not load external variables, got empty data from URL " + this.getProperty("external.variables.txt")) + " data length = ") + Std.string(_local_6)) + ". Client startup failed!"), false, Core.ERROR_CATEGORY_DOWNLOAD_EXTERNAL_VARIABLES);
            }
            var _local_5= this.getProperty("external.override.variables.txt");
            if ((ASCompat.stringAsBool(_local_5) && (!(_local_5 == ""))))
            {
                Logger.log([("Override External Variables: " + _local_5)]);
                if (assets.hasAsset(_local_5))
                {
                }
                _local_7 = new URLRequest(_local_5);
                _local_8 = assets.loadAssetFromFile(_local_5, _local_7, "text/plain");
                _local_8.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTCOMPLETE, this._Str_23646);
                _local_8.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTERROR, this.onInitConfigurationOverride);
            }
            else
            {
                if (!this._initialized)
                {
                    this.configurationsLoaded();
                }
            }
        }

        function configurationsLoaded()
        {
            if (disposed)
            {
                return;
            }
            if (this._initialized)
            {
                return;
            }
            this._initialized = true;
            if (locked)
            {
                unlock();
            }
            events.dispatchEvent(new Event(Event.COMPLETE));
        }

        function onInitConfigurationOverride(k:Event)
        {
            if (disposed)
            {
                return;
            }
            var _local_2= Std.downcast(k , AssetLoaderEvent);
            var _local_3 = 0;
            if (_local_2 != null)
            {
                _local_3 = _local_2.status;
            }
            this.configurationsLoaded();
        }

        function _Str_23646(k:Event)
        {
            if (disposed)
            {
                return;
            }
            var _local_2= ASCompat.dynamicAs(k.target , AssetLoaderStruct);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= ASCompat.asString(_local_2.assetLoader.content );
            if (_local_3 != null)
            {
                this.parseConfiguration(_local_3);
            }
            var _local_4= assets.getAssetByName(_local_2.assetName);
            if (_local_4 != null)
            {
                assets.removeAsset(_local_4).dispose();
            }
            this.configurationsLoaded();
        }

        function setDefaults()
        {
            var _local_2:Array<ASAny> = null;
            var _local_3:String = null;
            ErrorReportStorage.addDebugData("Flashvars/host", ("Host: " + this.getProperty("connection.info.host")));
            ErrorReportStorage.addDebugData("Flashvars/port", ("Port: " + this.getProperty("connection.info.port")));
            this.setProperty("client.fatal.error.url", "${url.prefix}/flash_client_error");
            this.setProperty("game.center.error.url", "${url.prefix}/log/gameerror");
            var k= this.getProperty("flashclient.crossdomain.policy.files");
            if ((ASCompat.stringAsBool(k) && (!(k == ""))))
            {
                _local_2 = (cast k.split(","));
                if (checkNullIteratee(_local_2)) for (_tmp_ in _local_2)
                {
_local_3  = _tmp_;
                    _local_3 = ASCompat.stringReplace(_local_3, " ", "");
                    Security.loadPolicyFile(_local_3);
                }
            }
        }

        function parseDevelopmentVariables()
        {
        }

        function parseCommonVariables()
        {
            var k= Std.downcast(assets.getAssetByName("localization_configuration") , TextAsset);
            this.parseConfiguration(Std.string(k.content));
            k.dispose();
            assets.removeAsset(k);
        }

        function parseLocalizationVariables()
        {
var _local_4:String  = null;            var _local_4:String = null;
            var _local_5:String = null;
            var k= HabboWebTools.rootLoaderInfo;
            var parameters:ASObject = null;
            var flashClientUrl:String = null;
            if (k == null)
            {
                k = context.displayObjectContainer.stage.loaderInfo;
            }
            var _local_2= k.url;
            var _local_3= _local_2.lastIndexOf("/");
            _local_2 = _local_2.substring(0, (_local_3 + 1));
            flashClientUrl = HabboWebTools.getParameter("flash.client.url", k);
            if (((flashClientUrl == null) || (flashClientUrl.length == 0)))
            {
                flashClientUrl = _local_2;
            }
            this.setProperty("flash.client.url", flashClientUrl);
            this._useHttps = (flashClientUrl.substr(0, 8) == "https://");
            ErrorReportStorage.addDebugData("Parsing flashvars", "Parsing flasvars");
            parameters = HabboWebTools.getParameterMap(k);
            if (checkNullIteratee(parameters)) for (_tmp_ in parameters.___keys())
            {
_local_4 = _tmp_;
                _local_5 = ASCompat.getDynamicProperty(parameters, _local_4);
                _local_4 = new compat.RegExp("[_]", "g").replace(_local_4, ".");
                this.setProperty(_local_4, _local_5, true);
            }
        }
    }

