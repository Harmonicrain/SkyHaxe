package com.sulake.core.utils
;
    import flash.events.Event;

     class LibraryLoaderEvent extends Event 
    {
        public static inline final LIBRARY_LOADER_EVENT_COMPLETE= "LIBRARY_LOADER_EVENT_COMPLETE";
        public static inline final LIBRARY_LOADER_EVENT_PROGRESS= "LIBRARY_LOADER_EVENT_PROGRESS";
        public static inline final LIBRARY_LOADER_EVENT_UNLOAD= "LIBRARY_LOADER_EVENT_UNLOAD";
        public static inline final LIBRARY_LOADER_EVENT_STATUS= "LIBRARY_LOADER_EVENT_STATUS";
        public static inline final LIBRARY_LOADER_EVENT_ERROR= "LIBRARY_LOADER_EVENT_ERROR";
        public static inline final LIBRARY_LOADER_EVENT_DEBUG= "LIBRARY_LOADER_EVENT_DEBUG";
        public static inline final LIBRARY_LOADER_EVENT_DISPOSE= "LIBRARY_LOADER_EVENT_DISPOSE";

        var _status:Int = 0;
        var _bytesTotal:UInt = 0;
        var _bytesLoaded:UInt = 0;
        var _elapsedTime:UInt = 0;

        public function new(type:String, _status:Int, bytesTotal:UInt, bytesLoaded:UInt, elapsedTime:UInt)
        {
            this._status = status;
            this._bytesTotal = bytesTotal;
            this._bytesLoaded = bytesLoaded;
            this._elapsedTime = elapsedTime;
            super(type, false, false);
        }

        public var status(get,never):Int;
public function  get_status():Int
        {
            return this._status;
        }

        public var bytesTotal(get,never):UInt;
public function  get_bytesTotal():UInt
        {
            return this._bytesTotal;
        }

        public var bytesLoaded(get,never):UInt;
public function  get_bytesLoaded():UInt
        {
            return this._bytesLoaded;
        }

        public var elapsedTime(get,never):UInt;
public function  get_elapsedTime():UInt
        {
            return this._elapsedTime;
        }

        override public function clone():Event
        {
            return new LibraryLoaderEvent(type, this._status, this._bytesTotal, this._bytesLoaded, this.elapsedTime);
        }
    }

