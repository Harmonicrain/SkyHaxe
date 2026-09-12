package com.sulake.core.runtime
;
    import com.sulake.core.utils.LibraryLoaderQueue;
    import flash.events.IEventDispatcher;
    import com.sulake.core.assets.AssetLibraryCollection;
    import com.sulake.core.Core;
    import flash.events.Event;
    import com.sulake.core.utils.profiler.ProfilerViewer;
    import flash.display.DisplayObjectContainer;
    import com.sulake.core.utils.PurgeTrigger;
    import com.sulake.core.utils.LibraryLoader;
    import flash.system.LoaderContext;
    import flash.system.ApplicationDomain;
    import flash.net.URLRequest;
    import com.sulake.core.utils.LibraryLoaderEvent;
    import com.sulake.core.runtime.events.LibraryProgressEvent;
    import Globals.flash_utils_getQualifiedClassName as getQualifiedClassName;
import com.sulake.core.runtime.IDisposable;
import com.sulake.core.runtime.IUpdateReceiver;
import com.sulake.core.runtime.IContext;
import flash.events.Event;
import Globals.flash_utils_getQualifiedClassName as getQualifiedClassName;

     final class CoreComponentContext extends ComponentContext implements ICore 
    {
        static inline final NUM_UPDATE_RECEIVER_LEVELS:UInt = 3;
        static inline final CONFIG_XML_NODE_ASSET_LIBRARIES= "asset-libraries";
        static inline final CONFIG_XML_NODE_ASSET_LIBRARY= "library";
        static inline final CONFIG_XML_NODE_SERVICE_LIBRARIES= "service-libraries";
        static inline final CONFIG_XML_NODE_SERVICE_LIBRARY= "library";
        static inline final CONFIG_XML_NODE_COMPONENT_LIBRARIES= "component-libraries";
        static inline final CONFIG_XML_NODE_COMPONENT_LIBRARY= "library";

        var _libraryLoaderQueue:LibraryLoaderQueue;
        var _loadingEventDelegate:IEventDispatcher;
        var _numberOfFilesInConfig:UInt = 0;
        var _frameUpdateMethod:ASFunction;
        var _profiler:Profiler;
        var _errorReporter:ICoreErrorLogger;
        var _updateReceiversByPriority:Array<ASAny>;
        var _framesSkippedByPriority:Array<ASAny>;
        var _lastUpdateTimeMs:UInt = 0;
        var _flags__com_sulake_core_runtime_CoreComponentContext/*redefined private*/:UInt = 0;
        var _hibernationLevel:Int = -1;
        var _hibernationUpdateFrequency:UInt = 0;

        public function new(displayContainer:DisplayObjectContainer, errorLogger:ICoreErrorLogger, flags:UInt)
        {
var level:UInt  = 0;            super(this, Component.COMPONENT_FLAG_CONTEXT, new AssetLibraryCollection("_core_assets"));
            this._flags__com_sulake_core_runtime_CoreComponentContext = flags;
            _debug = (((ASCompat.toInt(flags )& ASCompat.toInt(Core.CORE_SETUP_DEBUG)) : UInt) == Core.CORE_SETUP_DEBUG);
            this._updateReceiversByPriority = new Array<ASAny>();
            this._framesSkippedByPriority = new Array<ASAny>();
            _displayObjectContainer = displayContainer;
            this._errorReporter = errorLogger;
            for (_tmp_ in 0...CoreComponentContext.NUM_UPDATE_RECEIVER_LEVELS)
            {
level= _tmp_;
                this._updateReceiversByPriority.push(new Array<ASAny>());
                this._framesSkippedByPriority.push(0);
            }
            this._lastUpdateTimeMs = flash.Lib.getTimer();
            attachComponent(this, [new IIDCore()]);
            _displayObjectContainer.addEventListener(Event.ENTER_FRAME, (this.onEnterFrame : ASAny));
            switch ((ASCompat.toInt(flags )& ASCompat.toInt(Core.CORE_SETUP_FRAME_UPDATE_MASK)))
            {
                case Core.CORE_SETUP_FRAME_UPDATE_SIMPLE:
                    debug("Core; using simple frame update handler");
                    this._frameUpdateMethod = this.simpleFrameUpdateHandler;
                    return;
                case Core.CORE_SETUP_FRAME_UPDATE_COMPLEX:
                    debug("Core; using complex frame update handler");
                    this._frameUpdateMethod = this.complexFrameUpdateHandler;
                    return;
                case Core.CORE_SETUP_FRAME_UPDATE_PROFILER:
                    debug("Core; using profiler frame update handler");
                    this._frameUpdateMethod = this.profilerFrameUpdateHandler;
                    this._profiler = new Profiler(this);
                    attachComponent(this._profiler, [new IIDProfiler()]);
                    _displayObjectContainer.addChild(new ProfilerViewer(this._profiler));
                    return;
                case Core.CORE_SETUP_FRAME_UPDATE_EXPERIMENT:
                    debug("Core; using experimental frame update handler");
                    this._frameUpdateMethod = this.experimentalFrameUpdateHandler;
                    return;
                case Core.CORE_SETUP_DEBUG:
                    debug("Core; using debug frame update handler");
                    this._frameUpdateMethod = this.debugFrameUpdateHandler;
                    return;
            }
        }

        public function getNumberOfFilesPending():UInt
        {
            return this._libraryLoaderQueue.length;
        }

        public function getNumberOfFilesLoaded():UInt
        {
            return this._numberOfFilesInConfig - this.getNumberOfFilesPending();
        }

        public function initialize()
        {
            if (this.hasLockedComponents())
            {
                events.addEventListener(Component.COMPONENT_EVENT_UNLOCKED, this.unlockEventHandler__com_sulake_core_runtime_CoreComponentContext);
            }
            else
            {
                this.doInitialize();
            }
        }

        function unlockEventHandler__com_sulake_core_runtime_CoreComponentContext/*redefined private*/(k:Event)
        {
            if (!this.hasLockedComponents())
            {
                events.removeEventListener(Component.COMPONENT_EVENT_UNLOCKED, this.unlockEventHandler__com_sulake_core_runtime_CoreComponentContext);
                this.doInitialize();
            }
        }

        function doInitialize()
        {
            events.dispatchEvent(new Event(Component.COMPONENT_EVENT_RUNNING));
            PurgeTrigger.start();
        }

        public function hasLockedComponents():Bool
        {
            var k:Component = null;
            if (_components != null)
            {
                final _iter_ = _components; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
k  = _tmp_;
                    if (k.locked)
                    {
                        return true;
                    }
                }
            }
            return false;
        }

        override public function dispose()
        {
            var k:UInt = 0;
            var _local_2:Array<ASAny> = null;
            var _local_3:ASAny = null;
            var _local_4:UInt = 0;
            if (!disposed)
            {
                debug("Disposing core");
                PurgeTrigger.stop();
                try
                {
                    _local_4 = 0;
                    while (_local_4 < CoreComponentContext.NUM_UPDATE_RECEIVER_LEVELS)
                    {
                        _local_2 = ASCompat.dynamicAs(this._updateReceiversByPriority[ASCompat.toInt(_local_4)] , Array);
                        k = _local_2.length;
                        while (k-- > 0)
                        {
                            _local_3 = _local_2.pop();
                            if (Std.is(_local_3 , UpdateDelegate))
                            {
                                cast(_local_3, UpdateDelegate).dispose();
                            }
                        }
                        _local_4++;
                    }
                }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                 {
                }
 }                if (_displayObjectContainer != null)
                {
                    _displayObjectContainer.removeEventListener(Event.ENTER_FRAME, (this.onEnterFrame : ASAny));
                    _displayObjectContainer = null;
                }
                if (this._libraryLoaderQueue != null)
                {
                    this._libraryLoaderQueue.dispose();
                    this._libraryLoaderQueue = null;
                }
                super.dispose();
            }
        }

        override public function error(k:String, _arg_2:Bool, _arg_3:Int=-1, _arg_4:ASError=null)
        {
            super.error(k, _arg_2, _arg_3, _arg_4);
            this._errorReporter.logError(k, _arg_2, _arg_3, _arg_4);
            if (_arg_2)
            {
                this.dispose();
            }
        }

        public function readConfigDocument(k:com.sulake.core.utils.xml.XML, _arg_2:IEventDispatcher=null)
        {
            var _local_3:com.sulake.core.utils.xml.XML = null;
            var _local_4:com.sulake.core.utils.xml.XMLList = null;
            var _local_5:com.sulake.core.utils.xml.XML = null;
            var _local_6:String = null;
            var _local_7:LibraryLoader = null;
            var _local_8= new LoaderContext(false, ApplicationDomain.currentDomain, null);
            debug("Parsing config document");
            this._loadingEventDelegate = _arg_2;
            if (this._libraryLoaderQueue == null)
            {
                this._libraryLoaderQueue = new LibraryLoaderQueue(_debug);
            }
            _local_3 = k.child(CONFIG_XML_NODE_ASSET_LIBRARIES).at(0);
            if (_local_3 != null)
            {
                _local_4 = _local_3.child(CONFIG_XML_NODE_ASSET_LIBRARY);
                if (checkNullIteratee(_local_4)) for (_tmp_ in _local_4)
                {
_local_5  = _tmp_;
                    _local_6 = _local_5.attribute("url").toString();
                    _local_7 = new LibraryLoader(_local_8, true, _debug);
                    assets.loadFromFile(_local_7, true);
                    _local_7.load(new URLRequest(_local_6));
                    this._libraryLoaderQueue.push(_local_7);
                    _local_7.addEventListener(LibraryLoaderEvent.LIBRARY_LOADER_EVENT_COMPLETE, this.updateLoadingProcess);
                    _local_7.addEventListener(LibraryLoaderEvent.LIBRARY_LOADER_EVENT_ERROR, this.errorInLoadingProcess);
                    this._numberOfFilesInConfig++;
                }
            }
            _local_3 = k.child(CONFIG_XML_NODE_SERVICE_LIBRARIES).at(0);
            if (_local_3 != null)
            {
                _local_4 = _local_3.child(CONFIG_XML_NODE_SERVICE_LIBRARY);
                if (checkNullIteratee(_local_4)) for (_tmp_ in _local_4)
                {
_local_5  = _tmp_;
                    _local_6 = _local_5.attribute("url").toString();
                    _local_7 = new LibraryLoader(_local_8, true, _debug);
                    _local_7.load(new URLRequest(_local_6));
                    this._libraryLoaderQueue.push(_local_7);
                    _local_7.addEventListener(LibraryLoaderEvent.LIBRARY_LOADER_EVENT_COMPLETE, this.updateLoadingProcess);
                    _local_7.addEventListener(LibraryLoaderEvent.LIBRARY_LOADER_EVENT_ERROR, this.errorInLoadingProcess);
                    this._numberOfFilesInConfig++;
                }
            }
            _local_3 = k.child(CONFIG_XML_NODE_COMPONENT_LIBRARIES).at(0);
            if (_local_3 != null)
            {
                _local_4 = _local_3.child(CONFIG_XML_NODE_COMPONENT_LIBRARY);
                if (checkNullIteratee(_local_4)) for (_tmp_ in _local_4)
                {
_local_5  = _tmp_;
                    _local_6 = _local_5.attribute("url").toString();
                    _local_7 = new LibraryLoader(_local_8, true, _debug);
                    _local_7.load(new URLRequest(_local_6));
                    this._libraryLoaderQueue.push(_local_7);
                    _local_7.addEventListener(LibraryLoaderEvent.LIBRARY_LOADER_EVENT_COMPLETE, this.updateLoadingProcess);
                    _local_7.addEventListener(LibraryLoaderEvent.LIBRARY_LOADER_EVENT_ERROR, this.errorInLoadingProcess);
                    this._numberOfFilesInConfig++;
                }
            }
            if (!disposed)
            {
                this.updateLoadingProcess();
            }
        }

        function errorInLoadingProcess(k:LibraryLoaderEvent=null)
        {
            var _local_2= cast(k.target, LibraryLoader);
            this.error(((((((((('Failed to download library "' + _local_2.url) + '" HTTP status ') + Std.string(k.status)) + " bytes loaded ") + Std.string(k.bytesLoaded)) + "/") + Std.string(k.bytesTotal)) + " : ") + _local_2.getLastErrorMessage()), true, Core.ERROR_CATEGORY_DOWNLOAD_LIBRARY);
            if (!disposed)
            {
                this.updateLoadingProcess(k);
            }
        }

        function finalizeLoadingEventDelegate()
        {
            if (this._loadingEventDelegate != null)
            {
                this._loadingEventDelegate.dispatchEvent(new Event(Event.COMPLETE));
                this._loadingEventDelegate = null;
            }
        }

        function updateLoadingProgress(k:LibraryLoaderEvent=null)
        {
            var _local_2:LibraryLoader = null;
            if (this._loadingEventDelegate != null)
            {
                _local_2 = ASCompat.dynamicAs(k.target , LibraryLoader);
                this._loadingEventDelegate.dispatchEvent(new LibraryProgressEvent(_local_2.url, k.bytesLoaded, k.bytesTotal, ASCompat.toInt(_local_2.elapsedTime)));
            }
        }

        function updateLoadingProcess(k:LibraryLoaderEvent=null)
        {
            var _local_2:LibraryLoader = null;
            var _local_3:String = null;
            if (k != null)
            {
                if (((k.type == LibraryLoaderEvent.LIBRARY_LOADER_EVENT_COMPLETE) || (k.type == LibraryLoaderEvent.LIBRARY_LOADER_EVENT_ERROR)))
                {
                    _local_2 = ASCompat.dynamicAs(k.target , LibraryLoader);
                    _local_2.removeEventListener(LibraryLoaderEvent.LIBRARY_LOADER_EVENT_COMPLETE, this.updateLoadingProcess);
                    _local_2.removeEventListener(LibraryLoaderEvent.LIBRARY_LOADER_EVENT_ERROR, this.errorInLoadingProcess);
                    _local_2.removeEventListener(LibraryLoaderEvent.LIBRARY_LOADER_EVENT_PROGRESS, this.updateLoadingProgress);
                    _local_3 = _local_2.url;
                    debug(((('Loading library "' + _local_3) + '" ') + ((k.type == LibraryLoaderEvent.LIBRARY_LOADER_EVENT_COMPLETE) ? "ready" : ("failed\n" + _local_2.getLastErrorMessage()))));
                    _local_2.dispose();
                    if (!disposed)
                    {
                        if (this._loadingEventDelegate != null)
                        {
                            this._loadingEventDelegate.dispatchEvent(new LibraryProgressEvent(_local_2.url, (this._numberOfFilesInConfig - this._libraryLoaderQueue.length), this._numberOfFilesInConfig, ASCompat.toInt(_local_2.elapsedTime)));
                        }
                    }
                }
            }
            if (!disposed)
            {
                if (this._libraryLoaderQueue.length == 0)
                {
                    this.finalizeLoadingEventDelegate();
                    debug("All libraries loaded, Core is now running");
                }
            }
        }

        override public function registerUpdateReceiver(k:IUpdateReceiver, _arg_2:UInt)
        {
            this.removeUpdateReceiver(k);
            _arg_2 = ((_arg_2 >= CoreComponentContext.NUM_UPDATE_RECEIVER_LEVELS) ? (CoreComponentContext.NUM_UPDATE_RECEIVER_LEVELS - 1) : _arg_2);
            var _local_3= ASCompat.toInt((this._profiler != null) ? ASCompat.toInt(Core.CORE_SETUP_FRAME_UPDATE_PROFILER ): (ASCompat.toInt(this._flags__com_sulake_core_runtime_CoreComponentContext )& ASCompat.toInt(Core.CORE_SETUP_FRAME_UPDATE_MASK)));
            if ((_local_3 : UInt) == Core.CORE_SETUP_FRAME_UPDATE_EXPERIMENT)
            {
                this._updateReceiversByPriority[ASCompat.toInt(_arg_2)].push(new UpdateDelegate(k, this, ASCompat.toInt(_arg_2)));
            }
            else
            {
                this._updateReceiversByPriority[ASCompat.toInt(_arg_2)].push(k);
            }
        }

        override public function removeUpdateReceiver(k:IUpdateReceiver)
        {
            var _local_2 = 0;
            var _local_3:Array<ASAny> = null;
            var _local_6:UpdateDelegate = null;
            if (disposed)
            {
                return;
            }
            var _local_4= ASCompat.toInt((this._profiler != null) ? ASCompat.toInt(Core.CORE_SETUP_FRAME_UPDATE_PROFILER ): (ASCompat.toInt(this._flags__com_sulake_core_runtime_CoreComponentContext )& ASCompat.toInt(Core.CORE_SETUP_FRAME_UPDATE_MASK)));
            var _local_5:UInt = 0;
            while (_local_5 < CoreComponentContext.NUM_UPDATE_RECEIVER_LEVELS)
            {
                _local_3 = ASCompat.dynamicAs(this._updateReceiversByPriority[ASCompat.toInt(_local_5)] , Array);
                if ((_local_4 : UInt) == Core.CORE_SETUP_FRAME_UPDATE_EXPERIMENT)
                {
                    if (checkNullIteratee(_local_3)) for (_tmp_ in _local_3)
                    {
_local_6  = _tmp_;
                        if (_local_6.receiver == k)
                        {
                            _local_6.dispose();
                            return;
                        }
                    }
                }
                else
                {
                    _local_2 = _local_3.indexOf(k);
                    if (_local_2 > -1)
                    {
                        _local_3[_local_2] = null;
                        return;
                    }
                }
                _local_5++;
            }
        }

        public function hibernate(hibernationLevel:Int, duration:Int=1)
        {
            if (!this.hibernating)
            {
                PurgeTrigger.stop();
                this._hibernationLevel = hibernationLevel;
                this._hibernationUpdateFrequency = Std.int(1000 / duration);
            }
        }

        public function resume()
        {
            if (this.hibernating)
            {
                PurgeTrigger.start();
                this._hibernationLevel = -1;
            }
        }

        var hibernating(get,never):Bool;
function  get_hibernating():Bool
        {
            return this._hibernationLevel > -1;
        }

        var maxPriority(get,never):UInt;
function  get_maxPriority():UInt
        {
            return ASCompat.toUInt(this.hibernating ? (this._hibernationLevel + 1) : CoreComponentContext.NUM_UPDATE_RECEIVER_LEVELS);
        }

        function onEnterFrame(k:Event)
        {
            var _local_2:UInt = flash.Lib.getTimer();
            var _local_3= (_local_2 - this._lastUpdateTimeMs);
            if (((!this.hibernating) || (_local_3 > this._hibernationUpdateFrequency)))
            {
                this._frameUpdateMethod(_local_2, _local_3);
                this._lastUpdateTimeMs = _local_2;
            }
        }

        function simpleFrameUpdateHandler(msCurrentTime:UInt, msSinceLastUpdate:UInt)
        {
            var priority:UInt = 0;
            var receivers:Array<ASAny> = null;
            var receiver:IUpdateReceiver = null;
            var length:UInt = 0;
            var index:UInt = 0;
            priority = 0;
            while (priority < this.maxPriority)
            {
                this._framesSkippedByPriority[ASCompat.toInt(priority)] = 0;
                receivers = this._updateReceiversByPriority[ASCompat.toInt(priority)];
                index = 0;
                length = receivers.length;
                while (index != length)
                {
                    receiver = cast(receivers[ASCompat.toInt(index)], IUpdateReceiver);
                    if (((receiver == null) || receiver.disposed))
                    {
                        receivers.splice(ASCompat.toInt(index), 1);
                        length--;
                    }
                    else
                    {
                        try
                        {
                            receiver.update(msSinceLastUpdate);
                        }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                         {
                            Logger.log([e.getStackTrace()]);
                            error(((('Error in update receiver "' + getQualifiedClassName(receiver)) + '": ') + e.message + " | " + e.getStackTrace()), true, e.errorID, e);
                            return;
                        }
 }                        index++;
                    }
                }
                priority++;
            }
        }

        function complexFrameUpdateHandler(msCurrentTime:UInt, msSinceLastUpdate:UInt)
        {
            var priority:UInt = 0;
            var receivers:Array<ASAny> = null;
            var receiver:IUpdateReceiver = null;
            var length:UInt = 0;
            var index:UInt = 0;
            var skip = false;
            var t:UInt = 0;
            var proceed= true;
            var maxTimePerFrame:UInt = Std.int(1000 / _displayObjectContainer.stage.frameRate);
            priority = 0;
            while (priority < this.maxPriority)
            {
                t = flash.Lib.getTimer();
                skip = false;
                if ((t - msCurrentTime) > maxTimePerFrame)
                {
                    if (this._framesSkippedByPriority[ASCompat.toInt(priority)] < priority)
                    {
                        this._framesSkippedByPriority[ASCompat.toInt(priority)]= ASCompat.toNumber(this._framesSkippedByPriority[ASCompat.toInt(priority)])+1;
                        skip = true;
                    }
                }
                if (!skip)
                {
                    this._framesSkippedByPriority[ASCompat.toInt(priority)] = 0;
                    receivers = this._updateReceiversByPriority[ASCompat.toInt(priority)];
                    index = 0;
                    length = receivers.length;
                    while (((!(index == length)) && proceed))
                    {
                        receiver = cast(receivers[ASCompat.toInt(index)], IUpdateReceiver);
                        if (((receiver == null) || receiver.disposed))
                        {
                            receivers.splice(ASCompat.toInt(index), 1);
                            length--;
                        }
                        else
                        {
                            try
                            {
                                receiver.update(msSinceLastUpdate);
                            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                             {
                                Logger.log([e.getStackTrace()]);
                                error(((('Error in update receiver "' + getQualifiedClassName(receiver)) + '": ') + e.message  + " | " + e.getStackTrace()), true, e.errorID, e);
                                proceed = false;
                            }
 }                            index++;
                        }
                    }
                }
                priority++;
            }
        }

        function profilerFrameUpdateHandler(msCurrentTime:UInt, msSinceLastUpdate:UInt)
        {
            var priority:UInt = 0;
            var receivers:Array<ASAny> = null;
            var receiver:IUpdateReceiver = null;
            var length:UInt = 0;
            var index:UInt = 0;
            this._profiler.start();
            priority = 0;
            while (priority < this.maxPriority)
            {
                this._framesSkippedByPriority[ASCompat.toInt(priority)] = 0;
                receivers = this._updateReceiversByPriority[ASCompat.toInt(priority)];
                index = 0;
                length = receivers.length;
                while (index != length)
                {
                    receiver = cast(receivers[ASCompat.toInt(index)], IUpdateReceiver);
                    if (((receiver == null) || receiver.disposed))
                    {
                        receivers.splice(ASCompat.toInt(index), 1);
                        length--;
                    }
                    else
                    {
                        try
                        {
                            this._profiler.update(receiver, msSinceLastUpdate);
                        }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                         {
                            error(((('Error in update receiver "' + getQualifiedClassName(receiver)) + '": ') + e.message + " | " + e.getStackTrace()), true, e.errorID, e);
                            return;
                        }
 }                        index++;
                    }
                }
                priority++;
            }
            this._profiler.stop();
        }

        function experimentalFrameUpdateHandler(k:UInt, _arg_2:UInt)
        {
            var _local_4:Array<ASAny> = null;
            var _local_5 = 0;
            var _local_3 = 0;
            while ((_local_3 : UInt) < CoreComponentContext.NUM_UPDATE_RECEIVER_LEVELS)
            {
                _local_4 = this._updateReceiversByPriority[_local_3];
                _local_5 = (_local_4.length - 1);
                while (_local_5 > -1)
                {
                    if (_local_4[_local_5].disposed)
                    {
                        _local_4.splice(_local_5, 1);
                    }
                    _local_5--;
                }
                _local_3++;
            }
        }

        function debugFrameUpdateHandler(k:UInt, _arg_2:UInt)
        {
            var _local_3:UInt = 0;
            var _local_4:Array<ASAny> = null;
            var _local_5:IUpdateReceiver = null;
            var _local_6:UInt = 0;
            var _local_7:UInt = 0;
            _local_3 = 0;
            while (_local_3 < this.maxPriority)
            {
                this._framesSkippedByPriority[ASCompat.toInt(_local_3)] = 0;
                _local_4 = this._updateReceiversByPriority[ASCompat.toInt(_local_3)];
                _local_7 = 0;
                _local_6 = _local_4.length;
                while (_local_7 != _local_6)
                {
                    _local_5 = cast(_local_4[ASCompat.toInt(_local_7)], IUpdateReceiver);
                    if (((_local_5 == null) || _local_5.disposed))
                    {
                        _local_4.splice(ASCompat.toInt(_local_7), 1);
                        _local_6--;
                    }
                    else
                    {
                        _local_5.update(_arg_2);
                        _local_7++;
                    }
                }
                _local_3++;
            }
        }

        public function setProfilerMode(k:Bool)
        {
            var _local_2 = 0;
            var _local_3:Array<ASAny> = null;
            var _local_4:ASObject = null;
            var _local_5 = 0;
            if (k)
            {
                this._frameUpdateMethod = this.profilerFrameUpdateHandler;
                if (((!(this._profiler != null)) || this._profiler.disposed))
                {
                    this._profiler = new Profiler(this);
                }
                attachComponent(this._profiler, [new IIDProfiler()]);
                _local_2 = 0;
                while ((_local_2 : UInt) < CoreComponentContext.NUM_UPDATE_RECEIVER_LEVELS)
                {
                    _local_3 = this._updateReceiversByPriority[_local_2];
                    _local_5 = (_local_3.length - 1);
                    while (_local_5 > -1)
                    {
                        _local_4 = _local_3[_local_5];
                        if (Std.is(_local_4 , UpdateDelegate))
                        {
                            _local_3[_local_5] = cast(_local_4, UpdateDelegate).receiver;
                            cast(_local_4, UpdateDelegate).dispose();
                        }
                        _local_5--;
                    }
                    _local_2++;
                }
            }
            else
            {
                detachComponent(this._profiler);
                switch ((ASCompat.toInt(this._flags__com_sulake_core_runtime_CoreComponentContext )& ASCompat.toInt(Core.CORE_SETUP_FRAME_UPDATE_MASK)))
                {
                    case Core.CORE_SETUP_FRAME_UPDATE_SIMPLE:
                        this._frameUpdateMethod = this.simpleFrameUpdateHandler;
                        return;
                    case Core.CORE_SETUP_FRAME_UPDATE_COMPLEX:
                        this._frameUpdateMethod = this.complexFrameUpdateHandler;
                        return;
                    case Core.CORE_SETUP_FRAME_UPDATE_EXPERIMENT:
                        this._frameUpdateMethod = this.experimentalFrameUpdateHandler;
                        _local_2 = 0;
                        while ((_local_2 : UInt) < CoreComponentContext.NUM_UPDATE_RECEIVER_LEVELS)
                        {
                            _local_3 = this._updateReceiversByPriority[_local_2];
                            _local_5 = (_local_3.length - 1);
                            while (_local_5 > -1)
                            {
                                _local_4 = _local_3[_local_5];
                                if (Std.is(_local_4 , IUpdateReceiver))
                                {
                                    _local_3[_local_5] = new UpdateDelegate(cast(_local_4, IUpdateReceiver), this, _local_2);
                                }
                                _local_5--;
                            }
                            _local_2++;
                        }
                        return;
                    default:
                        this._frameUpdateMethod = this.debugFrameUpdateHandler;
                }
            }
        }
    }


private class UpdateDelegate implements IDisposable 
{

    var _receiver:IUpdateReceiver;
    var _context:IContext;
    var _priority:Int = 0;
    var _lastUpdateTimeMs:UInt = 0;
    var _framesSkipped:UInt = 0;

    public function new(receiver:IUpdateReceiver, context:IContext, priority:Int)
    {
        if (((context != null) && (receiver != null)))
        {
            this._receiver = receiver;
            this._context = context;
            this._priority = priority;
            context.displayObjectContainer.stage.addEventListener(((this._priority == 0) ? Event.EXIT_FRAME : Event.ENTER_FRAME), (this.onFrameUpdate : ASAny));
            this._lastUpdateTimeMs = flash.Lib.getTimer();
        }
    }

    public var priority(get,never):Int;
public function  get_priority():Int
    {
        return this._priority;
    }

    public var receiver(get,never):IUpdateReceiver;
public function  get_receiver():IUpdateReceiver
    {
        return this._receiver;
    }

    public var disposed(get,never):Bool;
public function  get_disposed():Bool
    {
        return (this._receiver != null) ? this._receiver.disposed : true;
    }

    public function dispose()
    {
        if (this._receiver != null)
        {
            this._receiver = null;
            this._context.displayObjectContainer.stage.removeEventListener(((this._priority == 0) ? Event.EXIT_FRAME : Event.ENTER_FRAME), (this.onFrameUpdate : ASAny));
            this._context = null;
        }
    }

    function onFrameUpdate(_mbslot_1:Event)
    {
        var _mbslot_2:UInt = 0;
        var _mbslot_3:UInt = 0;
        if (!this.disposed)
        {
            _mbslot_2 = flash.Lib.getTimer();
            _mbslot_3 = (_mbslot_2 - this._lastUpdateTimeMs);
            this._lastUpdateTimeMs = _mbslot_2;
            if (((this._priority > 0) && (this._framesSkipped < (this._priority : UInt))))
            {
                if (_mbslot_3 > (1000 / this._context.displayObjectContainer.stage.frameRate))
                {
                    this._framesSkipped++;
                    return;
                }
            }
            this._framesSkipped = 0;
            try
            {
                this._receiver.update(_mbslot_3);
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                _context.error(((('Error in update receiver "' + getQualifiedClassName(_receiver)) + '": ') + e.message + " | " + e.getStackTrace()), true, e.errorID, e);
            }
 }        }
    }


}
