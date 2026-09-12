package com.sulake.core.localization
;
    import com.sulake.core.runtime.Component;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.utils.Map;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;
    import flash.net.URLRequest;
    import com.sulake.core.assets.AssetLoaderStruct;
    import com.sulake.core.assets.loaders.AssetLoaderEvent;
    import com.sulake.core.assets.IAsset;
    import flash.events.Event;
    import com.sulake.core.localization._enum.LocalizationEvent;
    import com.sulake.core.utils.ErrorReportStorage;
    import com.sulake.core.Core;

     class CoreLocalizationManager extends Component implements IDisposable implements  ICoreLocalizationManager 
    {
        var _localizations:ASDictionary<ASAny,ASAny>;
        var _localizationDefinitions:Map;
        var _activeLocalizationDefinition:String;
        var _nonExistingKeysTable:Array<ASAny>;

        public function new(k:IContext, _arg_2:UInt=0, _arg_3:IAssetLibrary=null)
        {
            this._nonExistingKeysTable = [];
            super(k, _arg_2, _arg_3);
        }

        override function initComponent()
        {
            this._localizations = new ASDictionary<ASAny,ASAny>();
            this._localizationDefinitions = new Map();
        }

        override public function dispose()
        {
            this._localizations = null;
            if (this._localizationDefinitions != null)
            {
                this._localizationDefinitions.dispose();
            }
            this._localizationDefinitions = null;
            this._nonExistingKeysTable = null;
            super.dispose();
        }

        public function registerLocalizationDefinition(k:String, _arg_2:String, _arg_3:String, _arg_4:String)
        {
            var _local_5:LocalizationDefinition = this._localizationDefinitions.getValue(k);
            if (_local_5 == null)
            {
                _local_5 = new LocalizationDefinition(_arg_4, _arg_2, _arg_3);
                this._localizationDefinitions.setProperty(k, _local_5);
            }
        }

        public function activateLocalizationDefinition(k:String):Bool
        {
            var _local_2:LocalizationDefinition = this._localizationDefinitions.getValue(k);
            if (_local_2 != null)
            {
                this._activeLocalizationDefinition = k;
                this.loadLocalizationFromURL(_local_2.url);
                return true;
            }
            return false;
        }

        public function getLocalizationDefinitions():Map
        {
            return this._localizationDefinitions;
        }

        public function getLocalizationDefinition(k:String):ILocalizationDefinition
        {
            return ASCompat.dynamicAs(this._localizationDefinitions.getValue(k), ILocalizationDefinition);
        }

        public function getActiveLocalizationDefinition():ILocalizationDefinition
        {
            return this.getLocalizationDefinition(this._activeLocalizationDefinition);
        }

        public function loadLocalizationFromURL(k:String)
        {
            var _local_2= k;
            var _local_3= new URLRequest(k);
            var _local_4= assets.loadAssetFromFile(_local_2, _local_3, "text/plain");
            _local_4.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTCOMPLETE, this.onLocalizationReady);
            _local_4.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTERROR, this.onLocalizationFailed);
        }

        function onLocalizationReady(k:AssetLoaderEvent)
        {
            var _local_3:String = null;
            var _local_4:IAsset = null;
            var _local_2= ASCompat.dynamicAs(k.target , AssetLoaderStruct);
            if (_local_2 != null)
            {
                _local_3 = _local_2.assetName;
                this.parseLocalizationData(ASCompat.asString(_local_2.assetLoader.content ));
                this.events.dispatchEvent(new Event(LocalizationEvent.LOCALIZATION_EVENT_LOCALIZATION_LOADED));
                _local_4 = assets.getAssetByName(_local_3);
                if (_local_4 != null)
                {
                    assets.removeAsset(_local_4).dispose();
                }
            }
        }

        function onLocalizationFailed(k:AssetLoaderEvent)
        {
            var _local_2= ASCompat.dynamicAs(k.target , AssetLoaderStruct);
            var _local_3= new URLRequest(_local_2.assetLoader.url);
            var _local_4= assets.loadAssetFromFile(_local_2.assetLoader.url, _local_3, "text/plain");
            _local_4.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTCOMPLETE, this.onLocalizationReady);
            _local_4.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTERROR, this._Str_23319);
        }

        function _Str_23319(k:AssetLoaderEvent)
        {
            var _local_2= ASCompat.dynamicAs(k.target , AssetLoaderStruct);
            ErrorReportStorage.addDebugData("Localization name", _local_2.assetName);
            ErrorReportStorage.addDebugData("Localization url", _local_2.assetLoader.url);
            ErrorReportStorage.addDebugData("Localization error", ("Code: " + Std.string(_local_2.assetLoader.errorCode)));
            Core.error("Failed to download localization", true, Core.ERROR_CATEGORY_DOWNLOAD_LOCALIZATION);
        }

        public function hasLocalization(k:String):Bool
        {
            var _local_2= ASCompat.dynamicAs(this._localizations[k] , Localization);
            return !(_local_2 == null);
        }

        public function getLocalization(k:String, _arg_2:String=""):String
        {
            var _local_3= ASCompat.dynamicAs(this._localizations[k] , Localization);
            if (_local_3 == null)
            {
                this._nonExistingKeysTable.push(k);
                return _arg_2;
            }
            return _local_3.value;
        }

        function getRawValue(k:String, _arg_2:String=""):String
        {
            var _local_3= ASCompat.dynamicAs(this._localizations[k] , Localization);
            if (_local_3 == null)
            {
                this._nonExistingKeysTable.push(k);
                return _arg_2;
            }
            return _local_3.raw;
        }

        public function updateLocalization(k:String, _arg_2:String)
        {
            var _local_3:Localization = this._localizations[k];
            if (_local_3 == null)
            {
                _local_3 = new Localization(this, k, _arg_2);
                this._localizations[k] = _local_3;
            }
            else
            {
                _local_3.setValue(_arg_2);
            }
        }

        function updateAllListeners()
        {
            var k:Localization = null;
            final _iter_ = this._localizations; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                k.updateListeners();
            }
        }

        public function registerListener(k:String, _arg_2:ILocalizable):Bool
        {
            var _local_3:Localization = this._localizations[k];
            if (_local_3 == null)
            {
                this._nonExistingKeysTable.push(k);
                _local_3 = new Localization(this, k, k);
                this._localizations[k] = _local_3;
            }
            _local_3.registerListener(_arg_2);
            return true;
        }

        public function removeListener(k:String, _arg_2:ILocalizable):Bool
        {
            var _local_3:Localization = this._localizations[k];
            if (_local_3 != null)
            {
                _local_3.removeListener(_arg_2);
            }
            return true;
        }

        public function registerParameter(k:String, _arg_2:String, _arg_3:String, _arg_4:String="%"):String
        {
            var _local_5:Localization = this._localizations[k];
            if (_local_5 == null)
            {
                _local_5 = new Localization(this, k, k);
                this._localizations[k] = _local_5;
            }
            _local_5.registerParameter(_arg_2, _arg_3, _arg_4);
            return _local_5.value;
        }

        public function getLocalizationRaw(k:String):ILocalization
        {
            return ASCompat.dynamicAs(this._localizations[k] , ILocalization);
        }

        public function getKeys():Array<ASAny>
        {
var _local_2:String  = null;            var _local_2:String = null;
            var k= new Array<ASAny>();
            final _iter_ = this._localizations; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
            {
_local_2 = _tmp_;
                k.push(_local_2);
            }
            return k;
        }

        public function printNonExistingKeys()
        {
            var _local_2:String = null;
            var k= "";
            final _iter_ = this._nonExistingKeysTable; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                k = (k + (_local_2 + "\n"));
            }
            Logger.log([k]);
        }

        function parseLocalizationData(k:String)
        {
            if (k == null)
            {
                return;
            }
            var _local_first= this.stripLeading(k);
            if (_local_first.length > 0 && _local_first.charAt(0) == "{")
            {
                this.parseLocalizationJSON(_local_first);
            }
            else
            {
                this.parseLocalizationFlat(k);
            }
            this.updateAllListeners();
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

        function parseLocalizationJSON(k:String)
        {
            var _local_2:ASObject = null;
            try
            {
                _local_2 = haxe.Json.parse(this.stripJSONComments(k));
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                ErrorReportStorage.addDebugData("Localization parse error", e.message);
                return;
            }
 }            this.flattenAndApplyLocalization(_local_2, "");
        }

        function flattenAndApplyLocalization(k:ASObject, _arg_2:String)
        {
var _local_3:String  = null;            var _local_3:String = null;
            var _local_4:ASAny = null;
            var _local_5:String = null;
            var _local_6 = 0;
            var _local_7 = false;
            if (k == null)
            {
                return;
            }
            if (Std.is(k , Array))
            {
                _local_6 = 0;
                while (_local_6 < ((ASCompat.dynamicAs(k , Array) : Array<ASAny>)).length)
                {
                    _local_5 = (_arg_2.length > 0) ? (_arg_2 + "." + Std.string(_local_6)) : ("" + Std.string(_local_6));
                    this.flattenAndApplyLocalization(((ASCompat.dynamicAs(k , Array) : Array<ASAny>))[_local_6], _local_5);
                    _local_6++;
                }
                return;
            }
            _local_7 = false;
            if (checkNullIteratee(k)) for (_tmp_ in k.___keys())
            {
_local_3 = _tmp_;
                if (_local_3 == "$")
                {
                    _local_7 = true;
                    continue;
                }
                _local_4 = ASCompat.getDynamicProperty(k, _local_3);
                _local_5 = (_arg_2.length > 0) ? (_arg_2 + "." + _local_3) : _local_3;
                this.applyLocalizationValue(_local_4, _local_5);
            }
            if (_local_7 && _arg_2.length > 0)
            {
                this.applyLocalizationValue(ASCompat.getDynamicProperty(k, "$"), _arg_2);
            }
        }

        function applyLocalizationValue(k:ASAny, _arg_2:String)
        {
            if (k == null)
            {
                return;
            }
            if (Std.is(k , String))
            {
                if (ASCompat.asString(k ).length > 0)
                {
                    this.updateLocalization(_arg_2, ASCompat.asString(k ));
                }
            }
            else if (Std.is(k , Float) || Std.is(k , Int) || com.sulake.core.utils.ASNumericType.isUInt(k )|| Std.is(k , Bool))
            {
                this.updateLocalization(_arg_2, ASCompat.toString(k));
            }
            else
            {
                this.flattenAndApplyLocalization(k, _arg_2);
            }
        }

        function parseLocalizationFlat(k:String)
        {
            var _local_6:String = null;
            var _local_7:Array<ASAny> = null;
            var _local_8:String = null;
            var _local_9:String = null;
            var _local_2= new compat.RegExp("\\n\\r{1,}|\\n{1,}|\\r{1,}", "mg");
            var _local_3= new compat.RegExp("^\\s+|\\s+$", "g");
            var _local_4:Array<ASAny> = (cast _local_2.split(k));
            var _local_5= new compat.RegExp("\\\\n", "mg");
            if (checkNullIteratee(_local_4)) for (_tmp_ in _local_4)
            {
_local_6  = _tmp_;
                if (_local_6.charAt(0) == "#")
                {
                }
                else
                {
                    _local_7 = (cast _local_6.split("="));
                    if (_local_7[0].length > 0)
                    {
                        if (_local_7.length > 1)
                        {
                            _local_8 = _local_7.shift();
                            _local_9 = _local_7.join("=");
                            _local_8 = _local_3.replace(_local_8, "");
                            _local_9 = _local_3.replace(_local_9, "");
                            _local_9 = _local_5.replace(_local_9, "\n");
                            if (_local_9.length > 0)
                            {
                                this.updateLocalization(_local_8, _local_9);
                            }
                        }
                    }
                }
            }
        }
    }

