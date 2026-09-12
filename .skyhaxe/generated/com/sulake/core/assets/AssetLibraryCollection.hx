package com.sulake.core.assets
;
    import com.sulake.core.runtime.events.EventDispatcherWrapper;
    import flash.system.LoaderContext;
    import flash.system.ApplicationDomain;
    import com.sulake.core.utils.LibraryLoaderEvent;
    import com.sulake.core.utils.LibraryLoader;
    import flash.events.Event;
    import flash.net.URLRequest;

     class AssetLibraryCollection extends EventDispatcherWrapper implements IAssetLibrary 
    {
        var _assetLibraries:Vector<IAssetLibrary>;
        var _fileLoadQueue:Array<ASAny>;
        var _loaderContext:LoaderContext;
        var _binLibrary:AssetLibrary;
        var _manifest:com.sulake.core.utils.xml.XML;
        var _name:String;
        var _counter:UInt = 0;

        public function new(name:String)
        {
            super();
            this._name = name;
            this._manifest = null;
            this._assetLibraries = new Vector<IAssetLibrary>();
            this._fileLoadQueue = new Array<ASAny>();
            this._loaderContext = new LoaderContext(false, ApplicationDomain.currentDomain, null);
        }

        public var url(get,never):String;
public function  get_url():String
        {
            return "";
        }

        public var name(get,never):String;
public function  get_name():String
        {
            return this._name;
        }

        public var isReady(get,never):Bool;
public function  get_isReady():Bool
        {
            return this._fileLoadQueue.length == 0;
        }

        public var numAssets(get,never):UInt;
public function  get_numAssets():UInt
        {
            return this.getNumAssets();
        }

        public var nameArray(get,never):Array<ASAny>;
public function  get_nameArray():Array<ASAny>
        {
            return this.getAssetNameArray();
        }

        public var manifest(get,never):com.sulake.core.utils.xml.XML;
public function  get_manifest():com.sulake.core.utils.xml.XML
        {
            return (this._manifest != null) ? this._manifest : (this._manifest = new com.sulake.core.utils.xml.XML());
        }

        
        public var loaderContext(get,set):LoaderContext;
public function  get_loaderContext():LoaderContext
        {
            return this._loaderContext;
        }
public function  set_loaderContext(loaderContext:LoaderContext):LoaderContext        {
            return this._loaderContext = loaderContext;
        }

        var binLibrary(get,never):IAssetLibrary;
function  get_binLibrary():IAssetLibrary
        {
            if (this._binLibrary == null)
            {
                this._binLibrary = new AssetLibrary("bin");
                this._assetLibraries.insertAt(0, this._binLibrary);
            }
            return this._binLibrary;
        }

        public function loadFromFile(libraryLoader:LibraryLoader, prepareAssets:Bool=false)
        {
            if (this.loaderContext == null)
            {
                this.loaderContext = this._loaderContext;
            }
            var assetLibrary:IAssetLibrary = new AssetLibrary(("lib-" + Std.string(this._counter++)));
            this._fileLoadQueue.push(assetLibrary);
            assetLibrary.loadFromFile(libraryLoader, prepareAssets);
            libraryLoader.addEventListener(LibraryLoaderEvent.LIBRARY_LOADER_EVENT_COMPLETE, this.loadEventHandler);
            libraryLoader.addEventListener(LibraryLoaderEvent.LIBRARY_LOADER_EVENT_ERROR,    this.loadEventHandler);
            libraryLoader.addEventListener(LibraryLoaderEvent.LIBRARY_LOADER_EVENT_PROGRESS, this.loadEventHandler);
        }

        public function loadFromResource(xml:com.sulake.core.utils.xml.XML, type:Class<Dynamic>):Bool
        {
            return this.binLibrary.loadFromResource(xml, type);
        }

        public function unload()
        {
            while (this._fileLoadQueue.length > 0)
            {
                ASCompat.dynamicAs(this._fileLoadQueue.pop() , IAssetLibrary).dispose();
            }
            while (this._assetLibraries.length > 0)
            {
                this._assetLibraries.pop() .dispose();
            }
        }

        override public function dispose()
        {
var                 i:UInt = 0;            if (!disposed)
            {
                super.dispose();
                i;while (i < (this._assetLibraries.length : UInt))
                {
                    this._assetLibraries.pop().dispose();
i++ ;
                }
                this._binLibrary = null;
            }
        }

        function loadEventHandler(event:LibraryLoaderEvent)
        {
var libraryLoader:LibraryLoader  = null, assetLibrary:IAssetLibrary = null,                 i:UInt = 0;            if (event.type == LibraryLoaderEvent.LIBRARY_LOADER_EVENT_COMPLETE)
            {
libraryLoader= ASCompat.dynamicAs(event.target , LibraryLoader);
assetLibrary;
                i;while (i < (this._fileLoadQueue.length : UInt))
                {
                    assetLibrary = ASCompat.dynamicAs(this._fileLoadQueue[ASCompat.toInt(i)] , IAssetLibrary);
                    if (assetLibrary.url == libraryLoader.url)
                    {
                        this._fileLoadQueue.splice(ASCompat.toInt(i), 1);
                        break;
                    }
i++;
                }
                this._assetLibraries.push(assetLibrary);
                libraryLoader.removeEventListener(LibraryLoaderEvent.LIBRARY_LOADER_EVENT_COMPLETE, this.loadEventHandler);
                libraryLoader.removeEventListener(LibraryLoaderEvent.LIBRARY_LOADER_EVENT_ERROR, this.loadEventHandler);
                libraryLoader.removeEventListener(LibraryLoaderEvent.LIBRARY_LOADER_EVENT_PROGRESS, this.loadEventHandler);
                if (this._fileLoadQueue.length == 0)
                {
                    dispatchEvent(new Event(AssetLibrary.ASSET_LIBRARY_LOADED));
                }
            }
        }

        public function hasAssetLibrary(name:String):Bool
        {
var library:IAssetLibrary  = null;            final _iter_ = this._assetLibraries; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
library = _tmp_;
                if (library.name == name)
                {
                    return true;
                }
            }
            return false;
        }

        public function getAssetLibraryByName(name:String):IAssetLibrary
        {
var library:IAssetLibrary  = null;            final _iter_ = this._assetLibraries; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
library = _tmp_;
                if (library.name == name)
                {
                    return library;
                }
            }
            return null;
        }

        public function getAssetLibraryByUrl(url:String):IAssetLibrary
        {
var assetLibrary:IAssetLibrary  = null;            final _iter_ = this._assetLibraries; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
assetLibrary = _tmp_;
                if (assetLibrary.url == url)
                {
                    return assetLibrary;
                }
            }
            return null;
        }

        public function addAssetLibrary(library:IAssetLibrary)
        {
            if (this._assetLibraries.indexOf(library) == -1)
            {
                this._assetLibraries.push(library);
            }
        }

        public function loadAssetFromFile(name:String, urlRequest:URLRequest, type:String=null, _arg_4:String=null, _arg_5:Int=-1, _arg_6:Int=-1):AssetLoaderStruct
        {
            return this.binLibrary.loadAssetFromFile(name, urlRequest, type);
        }

        public function getAssetByName(k:String):IAsset
        {
var library:IAssetLibrary  = null, asset:IAsset  = null;            final _iter_ = this._assetLibraries; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
library = _tmp_;
asset= library.getAssetByName(k);
                if (asset != null)
                {
                    return asset;
                }
            }
            return null;
        }

        public function getAssetsByName(name:String):Array<ASAny>
        {
var library:IAssetLibrary  = null, asset:IAsset  = null;            var result:Array<ASAny> = [];
            final _iter_ = this._assetLibraries; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
library = _tmp_;
asset= library.getAssetByName(name);
                if (asset != null)
                {
                    result.push(asset);
                }
            }
            return result;
        }

        public function getAssetByContent(content:ASObject):IAsset
        {
var library:IAssetLibrary  = null, asset:IAsset  = null;            final _iter_ = this._assetLibraries; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
library = _tmp_;
asset= library.getAssetByContent(content);
                if (asset != null)
                {
                    return asset;
                }
            }
            return null;
        }

        public function getAssetByIndex(index:UInt):IAsset
        {
var library:IAssetLibrary  = null;            var counter:UInt = 0;
            var previousCounter:UInt = 0;
            final _iter_ = this._assetLibraries; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
library = _tmp_;
                counter = (counter + library.numAssets);
                if (counter <= index)
                {
                    return library.getAssetByIndex((index - previousCounter));
                }
                previousCounter = counter;
            }
            return null;
        }

        public function getAssetIndex(asset:IAsset):Int
        {
var library:IAssetLibrary  = null;            var counter = 0;
            var previousCounter = 0;
            final _iter_ = this._assetLibraries; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
library = _tmp_;
                previousCounter = library.getAssetIndex(asset);
                if (previousCounter != -1)
                {
                    return counter + previousCounter;
                }
                counter = ASCompat.toInt(counter + library.numAssets);
            }
            return -1;
        }

        public function hasAsset(name:String):Bool
        {
var library:IAssetLibrary  = null;            final _iter_ = this._assetLibraries; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
library = _tmp_;
                if (library.hasAsset(name))
                {
                    return true;
                }
            }
            return false;
        }

        public function setAsset(name:String, asset:IAsset, _arg_3:Bool=true):Bool
        {
            return this.binLibrary.setAsset(name, asset, _arg_3);
        }

        public function createAsset(name:String, typeDeclaration:AssetTypeDeclaration):IAsset
        {
            return this.binLibrary.createAsset(name, typeDeclaration);
        }

        public function removeAsset(asset:IAsset):IAsset
        {
            var _local_2:IAssetLibrary = null;
            final _iter_ = this._assetLibraries; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.removeAsset(asset) == asset)
                {
                    return asset;
                }
            }
            return null;
        }

        public function registerAssetTypeDeclaration(k:AssetTypeDeclaration, _arg_2:Bool=true):Bool
        {
            return this.binLibrary.registerAssetTypeDeclaration(k, _arg_2);
        }

        public function getAssetTypeDeclarationByMimeType(type:String, shared:Bool=true):AssetTypeDeclaration
        {
var library:IAssetLibrary  = null, typeDeclaration:AssetTypeDeclaration  = null;            if (shared)
            {
                return this.binLibrary.getAssetTypeDeclarationByMimeType(type, true);
            }
            final _iter_ = this._assetLibraries; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
library = _tmp_;
typeDeclaration= library.getAssetTypeDeclarationByMimeType(type, false);
                if (typeDeclaration != null)
                {
                    return typeDeclaration;
                }
            }
            return null;
        }

        public function getAssetTypeDeclarationByClass(typeClass:Class<Dynamic>, shared:Bool=true):AssetTypeDeclaration
        {
var library:IAssetLibrary  = null, typeDeclaration:AssetTypeDeclaration  = null;            if (shared)
            {
                return this.binLibrary.getAssetTypeDeclarationByClass(typeClass, true);
            }
            final _iter_ = this._assetLibraries; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
library = _tmp_;
typeDeclaration= library.getAssetTypeDeclarationByClass(typeClass, false);
                if (typeDeclaration != null)
                {
                    return typeDeclaration;
                }
            }
            return null;
        }

        public function getAssetTypeDeclarationByFileName(name:String, shared:Bool=true):AssetTypeDeclaration
        {
var library:IAssetLibrary  = null, typeDeclaration:AssetTypeDeclaration  = null;            if (shared)
            {
                return this.binLibrary.getAssetTypeDeclarationByFileName(name, true);
            }
            final _iter_ = this._assetLibraries; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
library = _tmp_;
typeDeclaration= library.getAssetTypeDeclarationByFileName(name, false);
                if (typeDeclaration != null)
                {
                    return typeDeclaration;
                }
            }
            return null;
        }

        function getNumAssets():UInt
        {
var library:IAssetLibrary  = null;            var num:UInt = 0;
            final _iter_ = this._assetLibraries; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
library = _tmp_;
                num = (num + library.numAssets);
            }
            return num;
        }

        function getAssetNameArray():Array<ASAny>
        {
var library:IAssetLibrary  = null;            var out= new Array<ASAny>();
            final _iter_ = this._assetLibraries; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
library = _tmp_;
                out = out.concat(library.nameArray);
            }
            return out;
        }

        public function getManifests():Array<ASAny>
        {
var library:IAssetLibrary  = null;            var out= new Array<ASAny>();
            final _iter_ = this._assetLibraries; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
library = _tmp_;
                out.push(library.manifest);
            }
            return out;
        }

        function buildManifest():com.sulake.core.utils.xml.XML
        {
var library:IAssetLibrary  = null;            var xml= new com.sulake.core.utils.xml.XML("<manifest><library></library></manifest>");
            var xmlList= xml.child("library");
            if (this._binLibrary != null)
            {
                this.applyManifestNodes(xmlList, this._binLibrary);
            }
            final _iter_ = this._assetLibraries; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
library = _tmp_;
                this.applyManifestNodes(xmlList, library);
            }
            return xml;
        }

        function applyManifestNodes(xmlList:com.sulake.core.utils.xml.XMLList, library:IAssetLibrary)
        {
var child:com.sulake.core.utils.xml.XML  = null, childChild:com.sulake.core.utils.xml.XML  = null, childChildren:com.sulake.core.utils.xml.XMLList  = null, subChild:com.sulake.core.utils.xml.XML  = null;            var children= library.manifest.child("library").children();
            if (checkNullIteratee(children)) for (_tmp_ in children)
            {
child = _tmp_;
childChild= xmlList.child(child.name()).at(0);
                if (childChild == null)
                {
                    xmlList.appendChild(new com.sulake.core.utils.xml.XML((("<" + child.name()) + "/>")));
                    childChild = xmlList.child(child.name()).at(0);
                }
childChildren= child.children();
                if (checkNullIteratee(childChildren)) for (_tmp_ in childChildren)
                {
subChild = _tmp_;
                    childChild.appendChild(subChild);
                }
            }
        }
    }

