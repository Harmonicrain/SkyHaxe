package com.sulake.core.runtime
;
    import com.sulake.core.runtime.events.ILinkEventTracker;
    import com.sulake.core.utils.LibraryLoader;
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import com.sulake.core.assets.IAssetLibrary;
    import flash.events.Event;
    import com.sulake.core.runtime.events.WarningEvent;
    import com.sulake.core.runtime.events.ErrorEvent;
    import com.sulake.core.utils.LibraryLoaderEvent;
    import flash.net.URLRequest;
    import flash.system.LoaderContext;
    import com.sulake.core.Core;
    import flash.utils.ByteArray;
    import flash.system.ApplicationDomain;
    import com.sulake.core.assets.AssetLibrary;
    import com.sulake.core.runtime.exceptions.InvalidComponentException;
    import Globals.flash_utils_getQualifiedClassName as getQualifiedClassName;
    import com.sulake.core.runtime.events.UnknownEvent;

     class ComponentContext extends Component implements IContext 
    {
        var _linkEventTrackers:Vector<ILinkEventTracker>;
        var _components:Vector<Component>;
        var _queuees:Vector<ComponentInterfaceQueue>;
        var _loaders:Vector<LibraryLoader>;
        var _debug:Bool = false;
        var _displayObjectContainer:DisplayObjectContainer;
        var _configurationManager:IHabboConfigurationManager;

        public function new(k:IContext, _arg_2:UInt=0, _arg_3:IAssetLibrary=null)
        {
            this._displayObjectContainer = new Sprite();
            this._components = new Vector<Component>();
            this._queuees = new Vector<ComponentInterfaceQueue>();
            this._linkEventTrackers = new Vector<ILinkEventTracker>(0);
            super(k, (ASCompat.toInt(_arg_2 )| ASCompat.toInt(Component.COMPONENT_FLAG_CONTEXT)), _arg_3);
        }

        public var root(get,never):IContext;
public function  get_root():IContext
        {
            if (((!(context != null)) || ((context : ASAny) == (this : ASAny))))
            {
                return this;
            }
            return context.root;
        }

        public var displayObjectContainer(get,never):DisplayObjectContainer;
public function  get_displayObjectContainer():DisplayObjectContainer
        {
            return this._displayObjectContainer;
        }

        override public function purge()
        {
            var k:Component = null;
            super.purge();
            final _iter_ = this._components; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                if ((k : ASAny) != (this : ASAny))
                {
                    k.purge();
                }
            }
        }

        public function debug(k:String)
        {
            _lastDebug = k;
            if ((this._debug && (events != null)))
            {
                events.dispatchEvent(new Event(Component.COMPONENT_EVENT_DEBUG));
            }
        }

        public function getLastDebugMessage():String
        {
            return _lastDebug;
        }

        public function warning(k:String)
        {
            _lastWarning = k;
            if (events == null)
            {
            }
            else
            {
                events.dispatchEvent(new WarningEvent(Component.COMPONENT_EVENT_WARNING, k));
            }
        }

        public function getLastWarningMessage():String
        {
            return _lastWarning;
        }

        public function error(k:String, _arg_2:Bool, _arg_3:Int=-1, _arg_4:ASError=null)
        {
            _lastError = k;
            if (events == null)
            {
            }
            else
            {
				Habbo.trackLoginStep("Error in ComponentContext" + k);
                events.dispatchEvent(new ErrorEvent(Component.COMPONENT_EVENT_ERROR, k, _arg_2, _arg_3, _arg_4));
            }
        }

        public function getLastErrorMessage():String
        {
            return _lastError;
        }

        final public function loadFromFile(k:URLRequest, _arg_2:LoaderContext):LibraryLoader
        {
            var libraryLoader:LibraryLoader = null;
            if (this._loaders == null)
            {
                this._loaders = new Vector<LibraryLoader>();
            }
            final _iter_ = this._loaders; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
libraryLoader  = _tmp_;
                if (libraryLoader.url == k.url)
                {
                    return libraryLoader;
                }
            }
            libraryLoader = new LibraryLoader(_arg_2, this._debug);
            libraryLoader.addEventListener(LibraryLoaderEvent.LIBRARY_LOADER_EVENT_COMPLETE, this.loadReadyHandler, false);
            libraryLoader.addEventListener(LibraryLoaderEvent.LIBRARY_LOADER_EVENT_ERROR, this.loadErrorHandler, false);
            libraryLoader.addEventListener(LibraryLoaderEvent.LIBRARY_LOADER_EVENT_DEBUG, this.loadDebugHandler, false);
            libraryLoader.load(k);
            this._loaders.push(libraryLoader);
            return libraryLoader;
        }

        final function loadReadyHandler(k:LibraryLoaderEvent)
        {
            var _local_2= ASCompat.dynamicAs(k.target , LibraryLoader);
            this.removeLibraryLoader(_local_2);
            this.prepareComponent(_local_2.resource, Component.COMPONENT_FLAG_NULL, _local_2.domain);
        }

        function loadErrorHandler(k:LibraryLoaderEvent)
        {
            var _local_2= ASCompat.dynamicAs(k.target , LibraryLoader);
            var _local_3= _local_2.getLastErrorMessage();
            this.removeLibraryLoader(_local_2);
            this.error((((('Failed to download component resource "' + _local_2.url) + '"!') + "\r") + _local_3), true, Core.ERROR_CATEGORY_COMPONENT_RESOURCE_LOAD_ERROR);
        }

        function loadDebugHandler(k:LibraryLoaderEvent)
        {
            var _local_2= ASCompat.dynamicAs(k.target , LibraryLoader);
            var _local_3= _local_2.getLastDebugMessage();
            this.debug(_local_3);
        }

        function removeLibraryLoader(k:LibraryLoader)
        {
            k.removeEventListener(LibraryLoaderEvent.LIBRARY_LOADER_EVENT_COMPLETE, this.loadReadyHandler, false);
            k.removeEventListener(LibraryLoaderEvent.LIBRARY_LOADER_EVENT_ERROR, this.loadReadyHandler, false);
            k.dispose();
            var _local_2= this._loaders.indexOf(k);
            if (_local_2 > -1)
            {
                this._loaders.splice(_local_2, 1);
            }
        }

        public function prepareAssetLibrary(xml:com.sulake.core.utils.xml.XML, _arg_2:Class<Dynamic>):Bool
        {
            return assets.loadFromResource(xml, _arg_2);
        }

        final public function prepareComponent(resource:Class<Dynamic>, flags:UInt=0, domain:ApplicationDomain=null):IUnknown
        {
            var manifest:com.sulake.core.utils.xml.XML = null;
            var component:Component = null;
            var componentClass:Class<Dynamic> = null;
            var componentString:String = null;
            var interfaceList:com.sulake.core.utils.xml.XMLList = null;
            var iid:IID = null;
            var iidList:Array<ASAny> = null;
            var iidClass:Class<Dynamic> = null;
            var iidString:String = null;
            var item:com.sulake.core.utils.xml.XML = null;
            var version:String = null;
            var unknown:IUnknown = null;
            var source:ASObject = null;
            var bytes:com.sulake.core.utils.ByteArray = null;
            var assetList:com.sulake.core.utils.xml.XMLList = null;
            var aliasList:com.sulake.core.utils.xml.XMLList = null;
            var assetLibrary:IAssetLibrary = null;
            var assetManifest:com.sulake.core.utils.xml.XML = null;
            var j:UInt = 0;
            if (domain == null)
            {
                domain = ApplicationDomain.currentDomain;
            }
            try
            {
                source = ((resource : ASObject) ).manifest;
                if (ASCompat.isXML(source ))
                {
                    manifest = ((source : com.sulake.core.utils.xml.XML) );
                }
                else
                {
                    if (Std.is(source , Class))
                    {
                        bytes = ASCompat.asByteArray(Type.createInstance(((source : Class<Dynamic>) ), []) );
                        manifest = new com.sulake.core.utils.xml.XML(bytes.readUTFBytes(bytes.length));
                    }
                }
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
				Habbo.trackLoginStep(e.getStackTrace());
                manifest = null;
            }
 }            if (manifest == null)
            {
                return null;
            }
            var componentList= manifest.child("component");
            var i:UInt = 0;
            while (i < (componentList.length() : UInt))
            {
                item = componentList.at(i);
                version = ASCompat.xmlListToString(item.attribute("version"));
                componentString = ASCompat.xmlListToString(item.attribute("class"));
                assetList = item.child("assets");
                aliasList = item.child("aliases");
                assetLibrary = null;
                if (assetList.length() > 0)
                {
                    assetManifest = new com.sulake.core.utils.xml.XML("<manifest><library /></manifest>");
                    assetManifest.child("library").appendChild(assetList);
                    assetManifest.child("library").appendChild(aliasList);
                    assetLibrary = new AssetLibrary(("_assets@" + componentString), assetManifest);
                    assetLibrary.loadFromResource(assetManifest, resource);
                }
                componentClass = domain.getDefinition(componentString) ;
                if (componentClass == null)
                {
                    componentClass = Type.resolveClass(componentString) ;
                }
                if (componentClass == null)
                {
                    this.error((("Invalid component class " + componentString) + "!"), true, Core.ERROR_CATEGORY_PREPARE_COMPONENT);
                    return null;
                }
                component = ((assetLibrary == null) ? Type.createInstance(componentClass, [this, flags]) : Type.createInstance(componentClass, [this, flags, assetLibrary]));
                if (component != null)
                {
                    if (assetLibrary != null)
                    {
                        if (component.assets != assetLibrary)
                        {
                            assetLibrary.dispose();
                            this.error((('Component "' + componentString) + '" did not save provided asset library!'), true, Core.ERROR_CATEGORY_PREPARE_COMPONENT);
                        }
                    }
                    interfaceList = item.child("interface");
                    iidList = new Array<ASAny>();
                    j = 0;
                    while (j < (interfaceList.length() : UInt))
                    {
                        iidString = ASCompat.xmlListToString(interfaceList.at(j).attribute("iid"));
                        iidClass = domain.getDefinition(iidString) ;
                        if (iidClass == null)
                        {
                            iidClass = Type.resolveClass(iidString) ;
                        }
                        if (iidClass == null)
                        {
                            throw new InvalidComponentException(("Identifier class defined in manifest not found: " + iidString));
                        }
                        iid = Type.createInstance(iidClass, []);
                        unknown = component ;
                        Component.requiredDependencyIids(component).insert(new InterfaceStruct(iid, component));
                        iidList.push(iid);
                        j++;
                    }
                    this.attachComponent(component, iidList);
                }
                i++;
            }
            return component ;
        }

        final public function attachComponent(k:Component, _arg_2:Array<ASAny>)
        {
            var _local_3:UInt = 0;
            var _local_5:IID = null;
            var _local_6:IID = null;
            if (this._components == null)
            {
                return;
            }
            if (this._components.indexOf(k) > -1)
            {
                this.error((("Component " + k) + " already attached to context!"), false);
                return;
            }
            this._components.push(k);
            if (k.locked)
            {
                k.events.addEventListener(Component.INTERNAL_EVENT_UNLOCKED, this.unlockEventHandler);
            }
            var _local_4:UInt = _arg_2.length;
            _local_3 = 0;
            while (_local_3 < _local_4)
            {
                _local_5 = _arg_2[ASCompat.toInt(_local_3)];
                if (Component.requiredDependencyIids(k).find(_local_5) == null)
                {
                    Component.requiredDependencyIids(k).insert(new InterfaceStruct(_local_5, k));
                }
                Component.requiredDependencyIids(this).insert(new InterfaceStruct(_local_5, k));
                _local_3++;
            }
            if (!k.locked)
            {
                _local_3 = 0;
                while (_local_3 < _local_4)
                {
                    _local_6 = _arg_2[ASCompat.toInt(_local_3)];
                    if (this.hasQueueForInterface(_local_6))
                    {
                        this.announceInterfaceAvailability(_local_6, k);
                    }
                    _local_3++;
                }
            }
        }

        final public function detachComponent(k:Component)
        {
            var _local_3:InterfaceStruct = null;
            var _local_2= Component.requiredDependencyIids(this);
            var _local_4= _local_2.getIndexByImplementor(k);
            while (_local_4 > -1)
            {
                _local_3 = _local_2.remove(_local_4);
                _local_4 = _local_2.getIndexByImplementor(k);
            }
            var _local_5:UInt = 0;
            while (_local_5 < (this._components.length : UInt))
            {
                if (this._components[ASCompat.toInt(_local_5)] == k)
                {
                    this._components.splice(ASCompat.toInt(_local_5), 1);
                    k.events.removeEventListener(Component.INTERNAL_EVENT_UNLOCKED, this.unlockEventHandler);
                    return;
                }
                _local_5++;
            }
        }

        override public function queueInterface(k:IID, _arg_2:ASFunction=null):IUnknown
        {
            var _local_5:IUnknown = null;
            var _local_3= Component.requiredDependencyIids(this);
            if (_local_3 == null)
            {
                return null;
            }
            var _local_4= _local_3.getStructByInterface(k);
            if (_local_4 != null)
            {
                if ((((_local_4.unknown : ASAny) == (this : ASAny)) && (_local_4.iis == getQualifiedClassName(k))))
                {
                    return super.queueInterface(k, _arg_2);
                }
                _local_5 = _local_4.unknown.queueInterface(k, _arg_2);
                if (_local_5 != null)
                {
                    return _local_5;
                }
            }
            if (_arg_2 != null)
            {
                this.addQueueeForInterface(k, _arg_2);
                if (((context != null) && (!((context : ASAny) == (this : ASAny)))))
                {
                    context.queueInterface(k, this.announceInterfaceAvailability);
                }
            }
            return null;
        }

        final function addQueueeForInterface(k:IID, _arg_2:ASFunction)
        {
            var _local_3:ComponentInterfaceQueue = null;
            if (this.hasQueueForInterface(k))
            {
                _local_3 = this.getQueueForInterface(k);
            }
            else
            {
                _local_3 = new ComponentInterfaceQueue(k);
                this._queuees.push(_local_3);
            }
            _local_3.receivers.unshift(_arg_2);
        }

        final function hasQueueForInterface(k:IID):Bool
        {
            if (this._queuees == null)
            {
                return false;
            }
            var _local_2= getQualifiedClassName(k);
            var _local_3:UInt = this._queuees.length;
            var _local_4:UInt = 0;
            while (_local_4 < _local_3)
            {
                if (getQualifiedClassName(this._queuees[ASCompat.toInt(_local_4)].identifier) == _local_2)
                {
                    return true;
                }
                _local_4++;
            }
            return false;
        }

        final function getQueueForInterface(k:IID):ComponentInterfaceQueue
        {
            var _local_3:ComponentInterfaceQueue = null;
            var _local_2= getQualifiedClassName(k);
            var _local_4:UInt = this._queuees.length;
            var _local_5:UInt = 0;
            while (_local_5 < _local_4)
            {
                _local_3 = this._queuees[ASCompat.toInt(_local_5)];
                if (getQualifiedClassName(_local_3.identifier) == _local_2)
                {
                    return _local_3;
                }
                _local_5++;
            }
            return null;
        }

        final function announceInterfaceAvailability(iid:IID, component:Component)
        {
var unknown:IUnknown  = null;            var interfaceQueue= this.getQueueForInterface(iid);
            if (interfaceQueue == null)
            {
                return;
            }
            var receiversCount:UInt = interfaceQueue.receivers.length;
            var counter:UInt = 0;
            while (counter < receiversCount)
            {
unknown= component.queueInterface(iid);
                if (unknown == null)
                {
                    this.error((("Interface " + iid) + " still unavailable!"), true, Core.ERROR_CATEGORY_INTERFACE_AVAILABILITY);
                }
                if (interfaceQueue.receivers != null)
                {
                    interfaceQueue.receivers.pop()(iid, unknown);
                }
                counter++;
            }
        }

        override public function dispose()
        {
            var count:UInt = 0;
            var libraryLoader:LibraryLoader = null;
            if (!disposed)
            {
                super.dispose();
                if (this._components != null)
                {
                    count = this._components.length;
                    while (count-- > 0)
                    {
                        this._components.pop().dispose();
                    }
                    this._components = null;
                }
                if (this._queuees != null)
                {
                    count = this._queuees.length;
                    while (count-- > 0)
                    {
                        this._queuees.pop().dispose();
                    }
                    this._queuees = null;
                }
                if (this._loaders != null)
                {
                    count = this._loaders.length;
                    while (count-- > 0)
                    {
                        libraryLoader = this._loaders[0];
                        this.removeLibraryLoader(libraryLoader);
                        libraryLoader.dispose();
                    }
                    this._loaders = null;
                }
            }
        }

        function unlockEventHandler(event:UnknownEvent)
        {
var requiredDepdencies:Array<ASAny>  = null;            var interfaceStruct:InterfaceStruct = null;
            var component= Std.downcast(event.unknown , Component);
            if (!component.disposed)
            {
                component.events.removeEventListener(Component.INTERNAL_EVENT_UNLOCKED, this.unlockEventHandler);
            }
            if (!disposed)
            {
requiredDepdencies= [];
				Component.requiredDependencyIids(this).mapStructsByImplementor(component, requiredDepdencies);
                while ((((requiredDepdencies.length != 0) && (!component.disposed)) && (!disposed)))
                {
                    interfaceStruct = requiredDepdencies.pop();
                    this.announceInterfaceAvailability(interfaceStruct.iid, component);
                }
                this.root.events.dispatchEvent(new Event(Component.COMPONENT_EVENT_UNLOCKED));
            }
        }

        override public function toXMLString(tabCount:UInt=0):String
        {
var component:Component  = null;            var interfaceStruct:InterfaceStruct = null;
            var line= "";
            var count:UInt = 0;
            while (count < tabCount)
            {
                line = (line + "\t");
                count++;
            }
            var className= getQualifiedClassName(this);
            var xml= "";
            xml = (xml + (((line + '<context class="') + className) + '" >\n'));
            var mappedStructs:Array<ASAny> = [];
            var structCount= Component.requiredDependencyIids(this).mapStructsByImplementor(this, mappedStructs);
            var index:UInt = 0;
            while (index < structCount)
            {
                interfaceStruct = mappedStructs[ASCompat.toInt(index)];
                xml = (xml + (((((line + '\t<interface iid="') + interfaceStruct.iis) + '" refs="') + Std.string(interfaceStruct.references)) + '"/>\n'));
                index++;
            }
			final _iter_ = this._components; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
component = _tmp_;
                if ((component : ASAny) != (this : ASAny))
                {
                    xml = (xml + component.toXMLString((tabCount + 1)));
                }
            }
            xml = (xml + (line + "</context>\n"));
            return xml;
        }

        
        public var configuration(get,set):IHabboConfigurationManager;
public function  set_configuration(k:IHabboConfigurationManager):IHabboConfigurationManager        {
            return this._configurationManager = k;
        }
public function  get_configuration():IHabboConfigurationManager
        {
            return this._configurationManager;
        }

        public function addLinkEventTracker(k:ILinkEventTracker)
        {
            if (this._linkEventTrackers.indexOf(k) < 0)
            {
                this._linkEventTrackers.push(k);
            }
        }

        public function removeLinkEventTracker(k:ILinkEventTracker)
        {
            var _local_2= this._linkEventTrackers.indexOf(k);
            if (_local_2 > -1)
            {
                this._linkEventTrackers.splice(_local_2, 1);
            }
        }

        public function createLinkEvent(k:String)
        {
            var _local_2:ILinkEventTracker = null;
            final _iter_ = this._linkEventTrackers; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.linkPattern.length > 0)
                {
                    if (k.substr(0, _local_2.linkPattern.length) == _local_2.linkPattern)
                    {
                        _local_2.linkReceived(k);
                    }
                }
                else
                {
                    _local_2.linkReceived(k);
                }
            }
        }

        public var linkEventTrackers(get,never):Vector<ILinkEventTracker>;
public function  get_linkEventTrackers():Vector<ILinkEventTracker>
        {
            return this._linkEventTrackers;
        }
    }

