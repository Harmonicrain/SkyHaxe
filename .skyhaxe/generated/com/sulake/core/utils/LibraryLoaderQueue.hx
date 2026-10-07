package com.sulake.core.utils
;
    import com.sulake.core.runtime.events.EventDispatcherWrapper;
    import com.sulake.core.runtime.IDisposable;

     class LibraryLoaderQueue extends EventDispatcherWrapper implements IDisposable 
    {
        static inline final MAX_SIMULTANEOUS_DOWNLOADS= 4;

        var _debug:Bool = false;
        var _queue:Array<ASAny>;
        var _loaders:Array<ASAny>;

        public function new(debug:Bool=false)
        {
            this._queue = new Array<ASAny>();
            this._loaders = new Array<ASAny>();
            this._debug = debug;
            super();
        }

        public var length(get,never):Int;
public function  get_length():Int
        {
            return this._queue.length + this._loaders.length;
        }

        override public function dispose()
        {
var loader:LibraryLoader = null;            if (!disposed)
            {
loader;
                final _iter_ = this._loaders; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
loader  = _tmp_;
                    loader.dispose();
                }
                final _iter_ = this._queue; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
loader  = _tmp_;
                    loader.dispose();
                }
                this._loaders = null;
                this._queue = null;
                super.dispose();
            }
        }

        public function push(loader:LibraryLoader)
        {
            if ((((!disposed) && (!this.isUrlInQueue(loader.url))) && (!(this.findLibraryLoaderByURL(loader.url) != null))))
            {
                loader.markQueued();
                if (loader.paused)
                {
                    this._queue.push(loader);
                }
                else
                {
                    this._loaders.push(loader);
                }
                loader.addEventListener(LibraryLoaderEvent.LIBRARY_LOADER_EVENT_COMPLETE, this.libraryLoadedHandler);
                loader.addEventListener(LibraryLoaderEvent.LIBRARY_LOADER_EVENT_PROGRESS, this.loadProgressHandler);
                loader.addEventListener(LibraryLoaderEvent.LIBRARY_LOADER_EVENT_DISPOSE, this.loaderDisposeHandler);
                loader.addEventListener(LibraryLoaderEvent.LIBRARY_LOADER_EVENT_ERROR, this.loadErrorHandler);
                this.next();
            }
        }

        function next()
        {
var loader:LibraryLoader  = null;            if (!disposed)
            {
                while (((this._loaders.length < MAX_SIMULTANEOUS_DOWNLOADS) && (this._queue.length > 0)))
                {
loader= this._queue.shift();
                    this._loaders.push(loader);
                    loader.resume();
                }
            }
        }

        function libraryLoadedHandler(event:LibraryLoaderEvent)
        {
            var loader= ASCompat.dynamicAs(event.target , LibraryLoader);
            if (loader != null)
            {
                this.removeLoader(loader);
            }
            this.next();
        }

        function loadProgressHandler(event:LibraryLoaderEvent)
        {
            var _local_2= ASCompat.dynamicAs(event.target , LibraryLoader);
        }

        function loaderDisposeHandler(event:LibraryLoaderEvent)
        {
            var loader= ASCompat.dynamicAs(event.target , LibraryLoader);
            this.removeLoader(loader);
            this.next();
        }

        function loadErrorHandler(event:LibraryLoaderEvent)
        {
            var loader= ASCompat.dynamicAs(event.target , LibraryLoader);
            if (loader != null)
            {
                this.removeLoader(loader);
            }
            this.next();
        }

        function removeLoader(loader:LibraryLoader)
        {
            var index = 0;
            loader.removeEventListener(LibraryLoaderEvent.LIBRARY_LOADER_EVENT_COMPLETE, this.libraryLoadedHandler);
            loader.removeEventListener(LibraryLoaderEvent.LIBRARY_LOADER_EVENT_PROGRESS, this.loadProgressHandler);
            loader.removeEventListener(LibraryLoaderEvent.LIBRARY_LOADER_EVENT_DISPOSE, this.loaderDisposeHandler);
            loader.removeEventListener(LibraryLoaderEvent.LIBRARY_LOADER_EVENT_ERROR, this.loadErrorHandler);
            try
            {
                index = this._queue.indexOf(loader);
                if (index > -1)
                {
                    this._queue.splice(index, 1);
                }
                index = this._loaders.indexOf(loader);
                if (index > -1)
                {
                    this._loaders.splice(index, 1);
                }
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
            }
 }        }

        function isUrlInQueue(url:String, removeParameter:Bool=true):Bool
        {
var loader:LibraryLoader  = null;            if (!disposed)
            {
                if ((removeParameter && (url.indexOf("?") > -1)))
                {
                    url = url.substring(0, url.indexOf("?"));
                }
                final _iter_ = this._queue; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
loader = _tmp_;
                    if (removeParameter)
                    {
                        if (loader.url.indexOf(url) == 0)
                        {
                            return true;
                        }
                    }
                    else
                    {
                        if (loader.url == url)
                        {
                            return true;
                        }
                    }
                }
            }
            return false;
        }

        public function findLibraryLoaderByURL(url:String, removeParameter:Bool=true):LibraryLoader
        {
var loader:LibraryLoader  = null;            if (!disposed)
            {
                if ((removeParameter && (url.indexOf("?") > -1)))
                {
                    url = url.substring(0, url.indexOf("?"));
                }
                final _iter_ = this._loaders; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
loader = _tmp_;
                    if (removeParameter)
                    {
                        if (loader.url.indexOf(url) == 0)
                        {
                            return loader;
                        }
                    }
                    else
                    {
                        if (loader.url == url)
                        {
                            return loader;
                        }
                    }
                }
            }
            return null;
        }
    }
