package com.sulake.core.runtime
;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.runtime.events.EventDispatcherWrapper;
    import com.sulake.core.assets.AssetLibrary;
    import com.sulake.core.runtime.exceptions.InvalidComponentException;
    import Globals.flash_utils_getQualifiedClassName as getQualifiedClassName;
    import flash.events.IEventDispatcher;
    import com.sulake.core.runtime.exceptions.ComponentDisposedException;
    import flash.events.Event;
    import com.sulake.core.runtime.events.UnknownEvent;
    import com.sulake.core.runtime.exceptions.*;

     class Component implements IUnknown implements  IHabboConfigurationManager 
    {
        public static inline final COMPONENT_EVENT_RUNNING= "COMPONENT_EVENT_RUNNING";
        public static inline final COMPONENT_EVENT_DISPOSING= "COMPONENT_EVENT_DISPOSING";
        public static inline final COMPONENT_EVENT_WARNING= "COMPONENT_EVENT_WARNING";
        public static inline final COMPONENT_EVENT_ERROR= "COMPONENT_EVENT_ERROR";
        public static inline final COMPONENT_EVENT_DEBUG= "COMPONENT_EVENT_DEBUG";
        public static inline final COMPONENT_EVENT_UNLOCKED= "COMPONENT_EVENT_UNLOCKED";
        static inline final INTERNAL_EVENT_UNLOCKED= "_INTERNAL_EVENT_UNLOCKED";
        public static inline final COMPONENT_FLAG_NULL:UInt = 0;
        public static inline final COMPONENT_FLAG_DISPOSABLE:UInt = 1;
        public static inline final COMPONENT_FLAG_CONTEXT:UInt = 2;
        public static inline final COMPONENT_FLAG_INTERFACE:UInt = 4;

        var _references:UInt = 0;
        var _lastError:String = "";
        var _lastDebug:String = "";
        var _lastWarning:String = "";
        var _assets:IAssetLibrary;
        var _events:EventDispatcherWrapper;
        var _flags:UInt = 0;
        var _iids:InterfaceStructList;
        var _context:IContext = null;
        var _disposed:Bool = false;
        var _locked:Bool = false;
        var _requiredDependencyCount:Int = 1;
        var _requiredDependencyIids:Vector<String>;
        var _dependencyDisposalActions:Vector<ASFunction>;

        public function new(k:IContext, _arg_2:UInt=0, assets:IAssetLibrary=null)
        {
            var dependency:ComponentDependency;
            this._dependencyDisposalActions = new Vector<ASFunction>(0);
            this._flags = _arg_2;
            this._iids = new InterfaceStructList();
            this._events = new EventDispatcherWrapper();
            this._context = k;
            this._assets = ((assets != null) ? assets : new AssetLibrary("_internal_asset_library"));
            if (this._context == null)
            {
                throw new InvalidComponentException("IContext not provided to Component's constructor!");
            }
            if (this.dependencies.length > 0)
            {
                this.lock();
            }
            this._requiredDependencyIids = new Vector<String>(0);
            for (_tmp_ in this.dependencies)
            {
dependency  = _tmp_;
                if (dependency.isRequired)
                {
                    this._requiredDependencyIids.push(getQualifiedClassName(dependency.identifier));
                }
                this.injectDependency(dependency.identifier, dependency.dependencySetter, dependency.isRequired, dependency.eventListeners);
            }
            this.allDependenciesRequested();
        }

        public static function requiredDependencyIids(component:Component):InterfaceStructList
        {
            return component._iids;
        }


        public var locked(get,never):Bool;
function  get_locked():Bool
        {
            return this._locked;
        }

        public var disposed(get,never):Bool;
function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var context(get,never):IContext;
function  get_context():IContext
        {
            return this._context;
        }

        public var events(get,never):IEventDispatcher;
function  get_events():IEventDispatcher
        {
            return this._events;
        }

        public var assets(get,never):IAssetLibrary;
function  get_assets():IAssetLibrary
        {
            return this._assets;
        }

        function injectDependency(identifier:IID, dependencySetter:ASFunction, isRequired:Bool, eventListeners:Array<ASAny>)
        {
            if (isRequired)
            {
                this._requiredDependencyCount++;
            }
            this.queueInterface(identifier, (function (setter:ASFunction, required:Bool, listeners:Array<ASAny>, componentName:String):ASFunction
            {
                return (function (identifier:IID, unknown:IUnknown)
                {
                    var eventDispatcher:ASAny = /*undefined*/null;
                    var listener:ASAny = /*undefined*/null;
                    if (disposed)
                    {
                        return;
                    }
                    Logger.log([[[[((("Injecting " + identifier) + " into ") + componentName)]]]]);
                    if (setter != null)
                    {
                        setter(unknown);
                    }
                    if (listeners != null)
                    {
                        eventDispatcher = cast(unknown, Component).events;
                        for (_tmp_ in listeners)
                        {
listener  = _tmp_;
                            Logger.log([[[[("Adding event listener for " + listener.type)]]]]);
                            eventDispatcher.addEventListener(listener.type, listener.callback);
                        }
                    }
                    _dependencyDisposalActions.push((function (iid:IID, component:IUnknown):ASFunction
                    {
                        return (function ()
                        {
                            var k:ASAny;
                            var _local_2:ASAny;
                            Logger.log([[[[[[[[[[[[[[[[((("Releasing " + identifier) + " from ") + componentName)]]]]]]]]]]]]]]]]);
                            if (listeners != null)
                            {
                                k = cast(component, Component).events;
                                if (k != null)
                                {
                                    for (_tmp_ in listeners)
                                    {
_local_2  = _tmp_;
                                        Logger.log([[[[[[[[[[[[[[[[("Removing event listener for " + _local_2.type)]]]]]]]]]]]]]]]]);
                                        k.removeEventListener(_local_2.type, _local_2.callback);
                                    }
                                }
                            }
                            if (setter != null)
                            {
                                setter(null);
                            }
                            component.release(iid);
                        });
                    })(identifier, unknown));
                    if (required)
                    {
                        allDependenciesRequested(getQualifiedClassName(identifier));
                    }
                });
            })(dependencySetter, isRequired, eventListeners, getQualifiedClassName(this)));
        }

        function allDependenciesRequested(k:String="")
        {
            this._requiredDependencyCount--;
            if (((!(k == "")) && (this._requiredDependencyIids.indexOf(k) > -1)))
            {
                this._requiredDependencyIids.splice(this._requiredDependencyIids.indexOf(k), 1);
            }
            if (this._requiredDependencyCount == 0)
            {
                this.initComponent();
                this.unlock();
            }
        }

        var allRequiredDependenciesInjected(get,never):Bool;
function  get_allRequiredDependenciesInjected():Bool
        {
            return this._requiredDependencyCount == 0;
        }

        var dependencies(get,never):Vector<ComponentDependency>;
function  get_dependencies():Vector<ComponentDependency>
        {
            return new Vector<ComponentDependency>(0);
        }

        function initComponent()
        {
        }

        public function queueInterface(k:IID, _arg_2:ASFunction=null):IUnknown
        {
            var _local_3:InterfaceStruct = this._iids.getStructByInterface(k);
            if (_local_3 == null)
            {
                return this._context.queueInterface(k, _arg_2);
            }
            if (this._disposed)
            {
                throw new ComponentDisposedException((('Failed to queue interface trough disposed Component "' + getQualifiedClassName(this)) + '"!'));
            }
            if (this._locked)
            {
                return null;
            }
            _local_3.reserve();
            var _local_4= _local_3.unknown ;
            if (_arg_2 != null)
            {
                _arg_2(k, _local_4);
            }
            return _local_4;
        }

        public function release(k:IID):UInt
        {
            if (this._disposed)
            {
                return 0;
            }
            var _local_2:InterfaceStruct = this._iids.getStructByInterface(k);
            if (_local_2 == null)
            {
                this._lastError = (("Attempting to release unknown interface:" + k) + "!");
                throw new ASError(this._lastError);
            }
            var _local_3= _local_2.release();
            if (((this._flags & COMPONENT_FLAG_INTERFACE) != 0))
            {
                if (_local_3 == 0)
                {
                    if (this._iids.getTotalReferenceCount() == 0)
                    {
                        this._context.detachComponent(this);
                        this.dispose();
                    }
                }
            }
            return _local_3;
        }

        public function dispose()
        {
            var k:ASFunction;
            if (!this._disposed)
            {
                for (_tmp_ in this._dependencyDisposalActions)
                {
k  = _tmp_;
                    k();
                }
                this._dependencyDisposalActions = null;
                this._events.dispatchEvent(new Event(Component.COMPONENT_EVENT_DISPOSING));
                this._events = null;
                this._iids.dispose();
                this._iids = null;
                this._assets.dispose();
                this._assets = null;
                this._context = null;
                this._references = 0;
                this._disposed = true;
            }
        }

        public function purge()
        {
        }

        final function lock()
        {
            if (!this._locked)
            {
                this._locked = true;
            }
        }

        final function unlock()
        {
            if (this._locked)
            {
                this._locked = false;
                this._events.dispatchEvent(new UnknownEvent(INTERNAL_EVENT_UNLOCKED, this));
            }
        }

        public function toString():String
        {
            return ((("[component " + getQualifiedClassName(this)) + " refs: ") + this._references) + "]";
        }

        public function toXMLString(k:UInt=0):String
        {
            var _local_6:InterfaceStruct;
            var _local_2= "";
            var _local_3:UInt = 0;
            while (_local_3 < k)
            {
                _local_2 = (_local_2 + "\t");
                _local_3++;
            }
            var _local_4= getQualifiedClassName(this);
            var _local_5= "";
            _local_5 = (_local_5 + (((_local_2 + '<component class="') + _local_4) + '">\n'));
            var _local_7= this._iids.length;
            var _local_8:UInt = 0;
            while (_local_8 < _local_7)
            {
                _local_6 = this._iids.getStructByIndex(_local_8);
                _local_5 = (_local_5 + (((((_local_2 + '\t<interface iid="') + _local_6.iis) + '" refs="') + _local_6.references) + '"/>\n'));
                _local_8++;
            }
            _local_5 = (_local_5 + (_local_2 + "</component>\n"));
            return _local_5;
        }

        public function registerUpdateReceiver(k:IUpdateReceiver, _arg_2:UInt)
        {
            if (!this._disposed)
            {
                this._context.registerUpdateReceiver(k, _arg_2);
            }
        }

        public function removeUpdateReceiver(k:IUpdateReceiver)
        {
            if (!this._disposed)
            {
                this._context.removeUpdateReceiver(k);
            }
        }

        public var flags(get,never):UInt;
function  get_flags():UInt
        {
            return this._flags;
        }

        public function propertyExists(k:String):Bool
        {
            return (this._context.configuration != null) ? this._context.configuration.propertyExists(k) : false;
        }

        public function getProperty(k:String, _arg_2:ASDictionary<ASAny,ASAny>=null):String
        {
            return (this._context.configuration != null) ? this._context.configuration.getProperty(k, _arg_2) : "";
        }

        public function setProperty(k:String, _arg_2:String, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            if (this._context.configuration != null)
            {
                this._context.configuration.setProperty(k, _arg_2, _arg_3, _arg_4);
            }
        }

        public function getBoolean(k:String):Bool
        {
            return (this._context.configuration != null) ? this._context.configuration.getBoolean(k) : false;
        }

        public function getInteger(k:String, _arg_2:Int):Int
        {
            return (this._context.configuration != null) ? this._context.configuration.getInteger(k, _arg_2) : 0;
        }

        public function interpolate(k:String):String
        {
            return (this._context.configuration != null) ? this._context.configuration.interpolate(k) : "";
        }

        public function updateUrlProtocol(k:String):String
        {
            return (this._context.configuration != null) ? this._context.configuration.updateUrlProtocol(k) : "";
        }
    }

