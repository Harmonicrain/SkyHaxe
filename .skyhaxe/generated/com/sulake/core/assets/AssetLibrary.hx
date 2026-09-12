package com.sulake.core.assets
;
    import com.sulake.core.runtime.events.EventDispatcherWrapper;
    import com.sulake.core.utils.LibraryLoader;
    import deng.fzip.FZip;
    import com.sulake.core.assets.loaders.BinaryFileLoader;
    import com.sulake.core.assets.loaders.BitmapFileLoader;
    import com.sulake.core.assets.loaders.ZipFileLoader;
    import com.sulake.core.assets.loaders.TextFileLoader;
    import com.sulake.core.assets.loaders.SoundFileLoader;
    import deng.fzip.FZipFile;
    import flash.system.System;
    import flash.events.Event;
    import com.sulake.core.utils.LibraryLoaderEvent;
    import flash.utils.ByteArray;
    import com.sulake.core.assets.loaders.IAssetLoader;
    import com.sulake.core.assets.loaders.AssetLoaderEvent;
    import flash.net.URLRequest;
    import flash.events.ProgressEvent;
    import Globals.flash_utils_getQualifiedClassName as getQualifiedClassName;
    import com.sulake.core.assets.loaders.*;

     class AssetLibrary extends EventDispatcherWrapper implements IAssetLibrary 
    {
        public static inline final ASSET_LIBRARY_READY= "AssetLibraryReady";
        public static inline final ASSET_LIBRARY_LOADED= "AssetLibraryLoaded";
        public static inline final ASSET_LIBRARY_UNLOADED= "AssetLibraryUnloaded";
        public static inline final ASSET_LIBRARY_LOAD_ERROR= "AssetLibraryLoadError";
        static inline final NAME= "name";
        static inline final ASSET= "asset";
        static inline final PARAM= "param";
        static inline final TYPE= "mimeType";
        static inline final LIB= "library";
        static inline final REF= "ref";
        static var _sharedListOfTypesByMime:ASDictionary<ASAny,ASAny>;
        static var _lazyAssetProcessor:LazyAssetProcessor = new LazyAssetProcessor();
        static inline final USE_LAZY_ASSET_PROCESSOR= false;
        static var _numAssetLibraryInstances:UInt = 0;
        static var _assetLibraryRefArray:Array<ASAny> = new Array();

        var _name:String;
        var _file:String;
        var _manifest:com.sulake.core.utils.xml.XML;
        var _isReady:Bool = false;
        var _numAssets:UInt = 0;
        var _loader:LibraryLoader;
        var _resource:Class<Dynamic>;
        var _zipLoader:FZip;
        var _loadedClasses:ASDictionary<ASAny,ASAny>;
        var _loadedAssets:ASDictionary<ASAny,ASAny>;
        var _prepareAssets:Bool = true;
        var _assetLoaderStructs:ASDictionary<ASAny,ASAny>;
        var _assetNameArray:Array<ASAny>;
        var _localListOfTypesByMime:ASDictionary<ASAny,ASAny>;

        public function new(name:String, manifest:com.sulake.core.utils.xml.XML=null)
        {
            super();
            this._name = name;
            this._manifest = manifest;
            this._numAssets = 0;
            this._assetNameArray = new Array<ASAny>();
            if (_sharedListOfTypesByMime == null)
            {
                _sharedListOfTypesByMime = new ASDictionary<ASAny,ASAny>(false);
                this.registerAssetTypeDeclaration(new AssetTypeDeclaration("application/octet-stream", UnknownAsset, BinaryFileLoader));
                this.registerAssetTypeDeclaration(new AssetTypeDeclaration("application/x-shockwave-flash", DisplayAsset, BitmapFileLoader, ["swf"]));
                this.registerAssetTypeDeclaration(new AssetTypeDeclaration("application/x-font-truetype", TypeFaceAsset, BinaryFileLoader, ["ttf", "otf"]));
                this.registerAssetTypeDeclaration(new AssetTypeDeclaration("application/zip", UnknownAsset, ZipFileLoader, ["zip"]));
                this.registerAssetTypeDeclaration(new AssetTypeDeclaration("text/xml", XmlAsset, TextFileLoader, ["xml"]));
                this.registerAssetTypeDeclaration(new AssetTypeDeclaration("text/html", XmlAsset, TextFileLoader, ["htm", "html"]));
                this.registerAssetTypeDeclaration(new AssetTypeDeclaration("text/plain", TextAsset, TextFileLoader, ["txt"]));
                this.registerAssetTypeDeclaration(new AssetTypeDeclaration("image/jpeg", BitmapDataAsset, BitmapFileLoader, ["jpg", "jpeg"]));
                this.registerAssetTypeDeclaration(new AssetTypeDeclaration("image/gif", BitmapDataAsset, BitmapFileLoader, ["gif"]));
                this.registerAssetTypeDeclaration(new AssetTypeDeclaration("image/png", BitmapDataAsset, BitmapFileLoader, ["png"]));
                this.registerAssetTypeDeclaration(new AssetTypeDeclaration("image/tiff", BitmapDataAsset, BitmapFileLoader, ["tif", "tiff"]));
                this.registerAssetTypeDeclaration(new AssetTypeDeclaration("sound/mp3", SoundAsset, SoundFileLoader, ["mp3"]));
            }
            _numAssetLibraryInstances++;
            this._localListOfTypesByMime = new ASDictionary<ASAny,ASAny>(false);
            this._assetLoaderStructs = new ASDictionary<ASAny,ASAny>(false);
            this._loadedClasses = new ASDictionary<ASAny,ASAny>(false);
            this._loadedAssets = new ASDictionary<ASAny,ASAny>(false);
            _assetLibraryRefArray.push(this);
        }

        public static var numAssetLibraryInstances(get,never):UInt;
public static function  get_numAssetLibraryInstances():UInt
        {
            return _numAssetLibraryInstances;
        }

        public static var assetLibraryRefArray(get,never):Array<ASAny>;
public static function  get_assetLibraryRefArray():Array<ASAny>
        {
            return _assetLibraryRefArray;
        }

        static function fetchLibraryContents(k:AssetLibrary, _arg_2:com.sulake.core.utils.xml.XML, _arg_3:Class<Dynamic>, _arg_4:FZip=null):Bool
        {
            var _local_6:com.sulake.core.utils.xml.XMLList = null;
            var _local_7:com.sulake.core.utils.xml.XML = null;
            var _local_8:String = null;
            var _local_9:String = null;
            var _local_10:AssetTypeDeclaration = null;
            var _local_11:IAsset = null;
            var _local_12:com.sulake.core.utils.xml.XMLList = null;
            var _local_13 = 0;
            var _local_14:AssetTypeDeclaration = null;
            var _local_16:String = null;
            var _local_17:FZipFile = null;
            if (((_arg_3 == null) && (_arg_4 == null)))
            {
                throw new ASError((("Library " + k._file) + " doesn't contain valid resource class!"));
            }
            var _local_5= _arg_2.child(LIB);
            if (_local_5 == null)
            {
                throw (cast("Provided manifest doesn't contain library node!", ASError));
            }
            var _local_15:String = null;
            _local_6 = _local_5.at(0).child("assets");
            if (_local_6 != null)
            {
                _local_6 = _local_6.child(ASSET);
                _local_13 = _local_6.length();
                if (checkNullIteratee(_local_6)) for (_tmp_ in _local_6)
                {
_local_7  = _tmp_;
                    _local_8 = ASCompat.xmlListToString(_local_7.attribute(NAME));
                    _local_9 = ASCompat.xmlListToString(_local_7.attribute(TYPE));
                    if (_local_9 == _local_15)
                    {
                        _local_10 = _local_14;
                    }
                    else
                    {
                        _local_10 = k.getAssetTypeDeclarationByMimeType(_local_9);
                        _local_15 = _local_9;
                        _local_14 = _local_10;
                    }
                    if (_local_10 != null)
                    {
                        _local_11 = ASCompat.dynamicAs(Type.createInstance(_local_10.assetClass, [_local_10]) , IAsset);
                        if (((!(_arg_4 == null)) && (_arg_4._Str_1455() > 0)))
                        {
                            _local_16 = ".png";
                            if (Std.is(_local_11 , BitmapDataAsset))
                            {
                                _local_16 = ".png";
                            }
                            if (Std.is(_local_11 , XmlAsset))
                            {
                                _local_16 = ".xml";
                            }
                            _local_17 = _arg_4._Str_1843((_local_8 + _local_16));
                            if (_local_17 != null)
                            {
                                _local_11.setUnknownContent(_local_17.content);
                            }
                        }
                        else
                        {
                            _local_11.setUnknownContent((_arg_3 : ASAny)[_local_8]);
                        }
                        _local_12 = _local_7.child(PARAM);
                        if (_local_12.length() != 0)
                        {
                            _local_11.setParamsDesc(_local_12);
                        }
                        k.setAsset(_local_8, _local_11);
                    }
                }
            }
            _local_6 = _local_5.at(0).child("aliases");
            if (_local_6 != null)
            {
                _local_6 = _local_6.child(ASSET);
                if (checkNullIteratee(_local_6)) for (_tmp_ in _local_6)
                {
_local_7  = _tmp_;
                    _local_8 = ASCompat.xmlListToString(_local_7.attribute(NAME));
                    _local_9 = ASCompat.xmlListToString(_local_7.attribute(TYPE));
                    if (_local_9 == _local_15)
                    {
                        _local_10 = _local_14;
                    }
                    else
                    {
                        _local_10 = k.getAssetTypeDeclarationByMimeType(_local_9);
                        _local_15 = _local_9;
                        _local_14 = _local_10;
                    }
                    if (_local_10 != null)
                    {
                        _local_11 = ASCompat.dynamicAs(Type.createInstance(_local_10.assetClass, [_local_10]) , IAsset);
                        _local_11.setUnknownContent(k.getAssetByName(ASCompat.xmlListToString(_local_7.attribute(REF))).content);
                        _local_12 = _local_7.child(PARAM);
                        if (_local_12.length() != 0)
                        {
                            _local_11.setParamsDesc(_local_12);
                        }
                        k.setAsset(_local_8, _local_11);
                    }
                }
            }
            return true;
        }


        public var url(get,never):String;
public function  get_url():String
        {
            return this._file;
        }

        public var name(get,never):String;
public function  get_name():String
        {
            return this._name;
        }

        public var isReady(get,never):Bool;
public function  get_isReady():Bool
        {
            return this._isReady;
        }

        public var manifest(get,never):com.sulake.core.utils.xml.XML;
public function  get_manifest():com.sulake.core.utils.xml.XML
        {
            return (this._manifest != null) ? this._manifest : (this._manifest = new com.sulake.core.utils.xml.XML());
        }

        public var numAssets(get,never):UInt;
public function  get_numAssets():UInt
        {
            return this._numAssets;
        }

        public var nameArray(get,never):Array<ASAny>;
public function  get_nameArray():Array<ASAny>
        {
            return this._assetNameArray;
        }

        override public function dispose()
        {
            if (!disposed)
            {
                this.unload();
                super.dispose();
                _assetLibraryRefArray.splice(_assetLibraryRefArray.indexOf(this), 1);
                _numAssetLibraryInstances--;
                this._assetLoaderStructs = null;
                this._loadedClasses = null;
                this._loadedAssets = null;
                this._assetNameArray = null;
                System.disposeXML(this._manifest);
                this._manifest = null;
                this._numAssets = 0;
                this._isReady = false;
                this._name = null;
            }
        }

        public function loadFromFile(libraryLoader:LibraryLoader, prepareAssets:Bool=true)
        {
            if (((this._file == libraryLoader.url) && this._isReady))
            {
                if (((!this._prepareAssets) && prepareAssets))
                {
                    AssetLibrary.fetchLibraryContents(this, this._manifest, this._resource);
                }
                this._prepareAssets = prepareAssets;
                dispatchEvent(new Event(AssetLibrary.ASSET_LIBRARY_READY));
            }
            else
            {
                if (((this._loader == null) || this._loader.disposed))
                {
                    this._loader = libraryLoader;
                    this._loader.addEventListener(LibraryLoaderEvent.LIBRARY_LOADER_EVENT_COMPLETE, this.libraryLoadedHandler);
                    this._loader.addEventListener(LibraryLoaderEvent.LIBRARY_LOADER_EVENT_ERROR, this.loadErrorHandler);
                }
                this._prepareAssets = prepareAssets;
                this._file = this._loader.url;
            }
        }

        public function loadFromResource(xml:com.sulake.core.utils.xml.XML, type:Class<Dynamic>):Bool
        {
            return AssetLibrary.fetchLibraryContents(this, xml, type);
        }

        public function unload()
        {
var name:String  = null, loaderStruct:AssetLoaderStruct  = null, asset:IAsset  = null;            final _iter_ = this._assetLoaderStructs; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
            {
name = _tmp_;
loaderStruct= this._assetLoaderStructs[name];
                loaderStruct.assetLoader.dispose();
                this._assetLoaderStructs.remove(name);
            }
            final _iter_ = this._loadedAssets; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
            {
name = _tmp_;
asset= this._loadedAssets[name];
                asset.dispose();
                this._loadedAssets.remove(name);
            }
            final _iter_ = this._loadedClasses; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
            {
name = _tmp_;
                this._loadedClasses.remove(name);
            }
            if (this._loader != null)
            {
                this._loader.dispose();
                this._loader = null;
            }
            this._numAssets = 0;
            this._isReady = false;
            this._file = null;
            dispatchEvent(new Event(AssetLibrary.ASSET_LIBRARY_UNLOADED));
        }

        public function getClass(name:String):Class<Dynamic>
        {
            var result:Class<Dynamic> = this._loadedClasses[name];
            if (result != null)
            {
                return result;
            }
            if (this._loader != null)
            {
                if (this._loader.hasDefinition(name))
                {
                    result = this._loader.getDefinition(name) ;
                    if (result != null)
                    {
                        this._loadedClasses[name] = result;
                        return result;
                    }
                }
            }
            return null;
        }

        public function loadAssetFromFile(name:String, urlRequest:URLRequest, type:String=null, _arg_4:String=null, _arg_5:Int=-1, _arg_6:Int=-1):AssetLoaderStruct
        {
            var typeDeclaration:AssetTypeDeclaration = null;
            if (this.getAssetByName(name) != null)
            {
                throw new ASError((("Asset with name " + name) + " already exists!"));
            }
            var loaderStruct:AssetLoaderStruct = this._assetLoaderStructs[urlRequest.url];
            if (loaderStruct != null)
            {
                if (loaderStruct.assetName == name)
                {
                    return loaderStruct;
                }
            }
            if (type == null)
            {
                typeDeclaration = this.solveAssetTypeDeclarationFromUrl(urlRequest.url);
                if (typeDeclaration == null)
                {
                    throw new ASError((("Couldn't solve asset type for file " + urlRequest.url) + "!"));
                }
            }
            else
            {
                typeDeclaration = this.getAssetTypeDeclarationByMimeType(type, true);
                if (typeDeclaration == null)
                {
					Habbo.trackLoginStep(("Asset type declaration for mime type " + type) + "not found!");
                    throw new ASError((("Asset type declaration for mime type " + type) + "not found!"));
                }
            }
            var content:com.sulake.core.utils.ByteArray = null;
            var loader:IAssetLoader = Type.createInstance(typeDeclaration.loaderClass, [typeDeclaration.mimeType, urlRequest, _arg_4, _arg_5, content, _arg_6]);
            if (loader == null)
            {
				Habbo.trackLoginStep(("Invalid file loader class defined for mime type " + type) + "!");
                throw new ASError((("Invalid file loader class defined for mime type " + type) + "!"));
            }
            loader.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTCOMPLETE, this.assetLoadEventHandler);
            loader.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTERROR, this.assetLoadEventHandler);
            loader.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTUNLOAD, this.assetLoadEventHandler);
            loader.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTPROGRESS, this.assetLoadEventHandler);
            loader.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTSTATUS, this.assetLoadEventHandler);
            loader.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTOPEN, this.assetLoadEventHandler);
            loaderStruct = new AssetLoaderStruct(name, loader);
            this._assetLoaderStructs[urlRequest.url] = loaderStruct;
            return loaderStruct;
        }

        function assetLoadEventHandler(event:AssetLoaderEvent)
        {
var loader:IAssetLoader = null, type:String = null, decl:AssetTypeDeclaration = null, asset:IAsset = null, remove = false, struct:AssetLoaderStruct  = null;			try
			{
loader;
type;
decl;
asset;
remove;
				if (event.target == null)
				{
					Habbo.trackLoginStep("Asset Library: AssetLoaderEvent.target is null!");
				}
				loader = ASCompat.dynamicAs(event.target , IAssetLoader);
				if (loader == null)
				{
					Habbo.trackLoginStep("Asset Library: Failed to downcast object to asset loader!");
					throw new ASError("Failed to downcast object to asset loader!");
				}
struct= this._assetLoaderStructs[loader.url];
				if (struct == null)
				{
					Habbo.trackLoginStep("Asset Library: Asset loader structure was lost! " + ((loader != null) ? loader.url : ""));
					throw new ASError(("Asset loader structure was lost! " + ((loader != null) ? loader.url : "")));
				}
				switch (event.type)
				{
					case AssetLoaderEvent.ASSETLOADEREVENTCOMPLETE:
						type = loader.mimeType;
						decl = this.getAssetTypeDeclarationByMimeType(type);
						remove = true;
						if (decl != null)
						{
							asset = Type.createInstance(decl.assetClass, [decl, loader.url]);
							try
							{
								asset.setUnknownContent(loader.content);
							if (this._loadedAssets[struct.assetName] == null)
							{
								this._numAssets++;
								this._assetNameArray.push(struct.assetName);
							}
							this._loadedAssets[struct.assetName] = asset;
							}
catch (__as3Caught:Dynamic) { var error:ASError = ASError.caught(__as3Caught); 							{
								Habbo.trackLoginStep("AssetLibary: Error loading context" + error.message + "|" + error.getStackTrace());
								asset.dispose();
								event = new AssetLoaderEvent(AssetLoaderEvent.ASSETLOADEREVENTERROR, event.status);
							}
 }						}
						else
						{
							event = new AssetLoaderEvent(AssetLoaderEvent.ASSETLOADEREVENTERROR, event.status);
						}
						
					case AssetLoaderEvent.ASSETLOADEREVENTERROR:
						remove = true;
						
				}
				struct.dispatchEvent(new AssetLoaderEvent(event.type, event.status));
				if (remove)
				{
					try
					{
					if (((!_disposed) && (loader != null)))
					{
						this._assetLoaderStructs.remove(loader.url);
					}
					if (struct != null)
					{
						struct.dispose();
					}
					}
catch (__as3Caught:Dynamic) { var error:ASError = ASError.caught(__as3Caught); 					{
						Habbo.trackLoginStep("AssetLibrary: Error disposing" + error.message + "|" + error.getStackTrace());
					}
 }				}
			}
catch (__as3Caught:Dynamic) { var error:ASError = ASError.caught(__as3Caught); 			{
				Habbo.trackLoginStep("Failed to load " + event.toString() + "|" + event.target + "|" + Std.string(event.status))
;			}
 }        }

        public function getAssetByName(name:String):IAsset
        {
            var asset:IAsset = this._loadedAssets[name];
            if (asset != null)
            {
                return asset;
            }
            if (this._prepareAssets)
            {
                if (((this._resource != null) && (!((this._resource : ASAny)[name] == null))))
                {
                    return this.fetchAssetFromResource(name);
                }
                return null;
            }
            return this.fetchAssetFromResource(name);
        }

        public function getAssetByIndex(index:UInt):IAsset
        {
            return (index < (this._assetNameArray.length : UInt)) ? this.getAssetByName(this._assetNameArray[ASCompat.toInt(index)]) : null;
        }

        public function getAssetByContent(content:ASObject):IAsset
        {
var key:String  = null, asset:IAsset  = null;            final _iter_ = this._loadedAssets; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
            {
key = _tmp_;
asset= this._loadedAssets[key];
                if (asset.content == content)
                {
                    return asset;
                }
            }
            return null;
        }

        public function getAssetIndex(asset:IAsset):Int
        {
var key:String  = null;            final _iter_ = this._loadedAssets; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
            {
key = _tmp_;
                if (this._loadedAssets[key] == asset)
                {
                    return this._assetNameArray.indexOf(key);
                }
            }
            return -1;
        }

        public function hasAsset(k:String):Bool
        {
            return (!(this._loadedAssets[k] == null)) || ((this._resource != null) ? (!((this._resource : ASAny)[k] == null)) : false);
        }

        public function setAsset(name:String, asset:IAsset, _arg_3:Bool=true):Bool
        {
            var _local_4:ASAny = (this._loadedAssets[name] == null);
            if (((_arg_3 || ASCompat.toBool(_local_4)) && (asset != null)))
            {
                if (_local_4)
                {
                    this._numAssets++;
                    this._assetNameArray.push(name);
                }
                this._loadedAssets[name] = asset;
                if (USE_LAZY_ASSET_PROCESSOR)
                {
                    if (Std.is(asset , ILazyAsset))
                    {
                        _lazyAssetProcessor.push(Std.downcast(asset , ILazyAsset));
                    }
                }
                return true;
            }
            return false;
        }

        public function createAsset(name:String, type:AssetTypeDeclaration):IAsset
        {
            if ((this.hasAsset(name) || (!(type != null))))
            {
                return null;
            }
            var asset:IAsset = Type.createInstance(type.assetClass, [type]);
            if (!this.setAsset(name, asset))
            {
                asset.dispose();
                asset = null;
            }
            return asset;
        }

        public function removeAsset(asset:IAsset):IAsset
        {
var key:String  = null;            if (asset != null)
            {
                final _iter_ = this._loadedAssets; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
                {
key = _tmp_;
                    if (this._loadedAssets[key] == asset)
                    {
                        this._assetNameArray.splice(this._assetNameArray.indexOf(key), 1);
                        this._loadedAssets.remove(key);
                        this._numAssets--;
                        return asset;
                    }
                }
            }
            return null;
        }

        public function registerAssetTypeDeclaration(type:AssetTypeDeclaration, shared:Bool=true):Bool
        {
            if (shared)
            {
                if (_sharedListOfTypesByMime.exists(type.mimeType))
                {
					Habbo.trackLoginStep("Asset Library: Asset type " + type.mimeType + " already registered!");
                    throw new ASError((("Asset type " + type.mimeType) + " already registered!"));
                }
                _sharedListOfTypesByMime[type.mimeType] = type;
            }
            else
            {
                if (this._localListOfTypesByMime.exists(type.mimeType))
                {
					Habbo.trackLoginStep("Asset Library: Asset type " + type.mimeType + " already registered!");
                    throw new ASError((("Asset type " + type.mimeType) + " already registered!"));
                }
                this._localListOfTypesByMime[type.mimeType] = type;
            }
            return true;
        }

        public function getAssetTypeDeclarationByMimeType(type:String, shared:Bool=true):AssetTypeDeclaration
        {
var typeDeclaration:AssetTypeDeclaration  = null;            if (shared)
            {
typeDeclaration= cast(_sharedListOfTypesByMime[type], AssetTypeDeclaration);
                if (typeDeclaration != null)
                {
                    return typeDeclaration;
                }
            }
            return cast(this._localListOfTypesByMime[type], AssetTypeDeclaration);
        }

        public function getAssetTypeDeclarationByClass(typeClass:Class<Dynamic>, shared:Bool=true):AssetTypeDeclaration
        {
var type:String  = null;            var typeDeclaration:AssetTypeDeclaration = null;
            var type:String = null;
            if (shared)
            {
                final _iter_ = _sharedListOfTypesByMime; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
                {
type = _tmp_;
                    typeDeclaration = cast(_sharedListOfTypesByMime[type], AssetTypeDeclaration);
                    if (typeDeclaration != null)
                    {
                        if (typeDeclaration.assetClass == typeClass)
                        {
                            return typeDeclaration;
                        }
                    }
                }
            }
            final _iter_ = this._localListOfTypesByMime; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
            {
type = _tmp_;
                typeDeclaration = cast(this._localListOfTypesByMime[type], AssetTypeDeclaration);
                if (typeDeclaration != null)
                {
                    if (typeDeclaration.assetClass == typeClass)
                    {
                        return typeDeclaration;
                    }
                }
            }
			
            return null;
        }

        public function getAssetTypeDeclarationByFileName(fileName:String, shared:Bool=true):AssetTypeDeclaration
        {
var type:String  = null;            var typeDeclaration:AssetTypeDeclaration = null;
            var type:String = null;
            var name= fileName.substr((fileName.lastIndexOf(".") + 1), fileName.length);
            if (name.indexOf("?") != 0)
            {
                name = name.substr(0, (name.indexOf("?") - 1));
            }
            if (shared)
            {
                final _iter_ = _sharedListOfTypesByMime; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
                {
type = _tmp_;
                    typeDeclaration = cast(_sharedListOfTypesByMime[type], AssetTypeDeclaration);
                    if (typeDeclaration != null)
                    {
                        if (typeDeclaration.fileTypes.indexOf(name) != 0)
                        {
                            return typeDeclaration;
                        }
                    }
                }
            }
            final _iter_ = this._localListOfTypesByMime; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
            {
type = _tmp_;
                typeDeclaration = cast(this._localListOfTypesByMime[type], AssetTypeDeclaration);
                if (typeDeclaration != null)
                {
                    if (typeDeclaration.fileTypes.indexOf(name) != 0)
                    {
                        return typeDeclaration;
                    }
                }
            }
            return null;
        }

        function libraryLoadedHandler(event:LibraryLoaderEvent)
        {
            var loader= ASCompat.dynamicAs(event.target , LibraryLoader);
            if (loader.manifest == null)
            {
				Habbo.trackLoginStep("loader.manifest was null, which would have caused error 1009 anyway. See HL-22347.");
                throw new ASError("loader.manifest was null, which would have caused error 1009 anyway. See HL-22347.");
            }
            this._manifest = loader.manifest.copy();
            this._resource = loader.resource;
            this._zipLoader = loader.zipLoader;
            this._file = loader.url;
            if (this._prepareAssets)
            {
                AssetLibrary.fetchLibraryContents(this, this._manifest, this._resource, this._zipLoader);
            }
            this._isReady = true;
            dispatchEvent(new Event(AssetLibrary.ASSET_LIBRARY_LOADED));
            dispatchEvent(new Event(AssetLibrary.ASSET_LIBRARY_READY));
            if (this._prepareAssets)
            {
                this._loader.removeEventListener(LibraryLoaderEvent.LIBRARY_LOADER_EVENT_COMPLETE, this.libraryLoadedHandler);
                this._loader.removeEventListener(LibraryLoaderEvent.LIBRARY_LOADER_EVENT_ERROR, this.loadErrorHandler);
                this._loader.addEventListener(LibraryLoader.LIBRARY_LOADER_FINALIZE, this.finalizeLoaderEventHandler);
                this._loader = null;
                this._resource = null;
            }
        }

        function finalizeLoaderEventHandler(event:Event)
        {
            var loader= ASCompat.dynamicAs(event.target , LibraryLoader);
            if (((loader != null) && (!loader.disposed)))
            {
                if (!loader.hasEventListener(LibraryLoaderEvent.LIBRARY_LOADER_EVENT_COMPLETE))
                {
                    loader.removeEventListener(LibraryLoader.LIBRARY_LOADER_FINALIZE, this.finalizeLoaderEventHandler);
                    loader.dispose();
                }
            }
        }

        function onLoadProgress(event:ProgressEvent)
        {
            dispatchEvent(event.clone());
        }

        function loadErrorHandler(event:LibraryLoaderEvent)
        {
            this._isReady = false;
            var loader= ASCompat.dynamicAs(event.target , LibraryLoader);
            //var _local_3:String = ((loader) ? loader.name : "unknown");
            dispatchEvent(new Event(AssetLibrary.ASSET_LIBRARY_LOAD_ERROR));
			Habbo.trackLoginStep("AssetLibrary:loadErrorHandler: " + this._name + ": " + event.target);
            this._loader = null;
        }

        function solveAssetTypeDeclarationFromUrl(url:String):AssetTypeDeclaration
        {
var type:String  = null;            var fileTypes:Array<ASAny> = null;
            var index = 0;
            index = url.indexOf("?", 0);
            if (index > 0)
            {
                url = url.substring(0, index);
            }
            index = url.lastIndexOf(".");
            if (index == -1)
            {
                return null;
            }
            url = url.substring((index + 1), url.length);
			var typeDeclaration:AssetTypeDeclaration = null;
            final _iter_ = this._localListOfTypesByMime; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
            {
type = _tmp_;
                typeDeclaration = this._localListOfTypesByMime[type];
                fileTypes = typeDeclaration.fileTypes;
                if (fileTypes != null)
                {
                    if (fileTypes.indexOf(url, 0) > -1)
                    {
                        return typeDeclaration;
                    }
                }
            }
            final _iter_ = _sharedListOfTypesByMime; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
            {
type = _tmp_;
                typeDeclaration = _sharedListOfTypesByMime[type];
                fileTypes = typeDeclaration.fileTypes;
                if (fileTypes != null)
                {
                    if (fileTypes.indexOf(url, 0) > -1)
                    {
                        return typeDeclaration;
                    }
                }
            }
            return null;
        }

        function fetchAssetFromResource(name:String):IAsset
        {
var                     i = 0, xml:com.sulake.core.utils.xml.XML  = null, typeDeclaration:AssetTypeDeclaration  = null, asset:IAsset  = null, childNodes:com.sulake.core.utils.xml.XMLList  = null;            if (this._resource == null)
            {
                return null;
            }
            var manifest= this._manifest.child(LIB);
            if (manifest == null)
            {
               Habbo.trackLoginStep("Asset Library: Provided manifest doesn't contain library node!");
               throw new ASError("Provided manifest doesn't contain library node!");
            }
            if (manifest.length() == 0)
            {
                return null;
            }
            manifest = manifest.at(0).child("assets");
            if (manifest != null)
            {
                manifest = manifest.child(ASSET);
                if (manifest != null)
                {
                    i;while (i < manifest.length())
                    {
xml= manifest.at(i);
                        if (((xml.attribute(NAME) != null) && (xml.attribute(NAME).toString() == name)))
                        {
typeDeclaration= this.getAssetTypeDeclarationByMimeType(ASCompat.xmlListToString(xml.attribute(TYPE)));
                            if (typeDeclaration == null)
                            {
								Habbo.trackLoginStep("Asset Library: Failed to extract asset " + name + " from Library " + this._file + "!");
                                throw new ASError((((("Failed to extract asset " + name) + " from Library ") + this._file) + "!"));
                            }
asset= ASCompat.dynamicAs(Type.createInstance(typeDeclaration.assetClass, [typeDeclaration]) , IAsset);
                            asset.setUnknownContent((this._resource : ASAny)[name]);
childNodes= xml.child(PARAM);
                            if (((childNodes != null) && (childNodes.length() != 0)))
                            {
                                asset.setParamsDesc(childNodes);
                            }
                            this.setAsset(name, asset);
                            return asset;
                        }
i++;
                    }
                }
            }
            return null;
        }

        public function toString():String
        {
            return (getQualifiedClassName(this) + ": ") + this._name;
        }
    }

