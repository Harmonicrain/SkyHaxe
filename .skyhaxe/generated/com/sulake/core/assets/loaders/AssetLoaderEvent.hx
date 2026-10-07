package com.sulake.core.assets.loaders
;
    import flash.events.Event;

     class AssetLoaderEvent extends Event 
    {
        public static inline final ASSETLOADEREVENTCOMPLETE= "AssetLoaderEventComplete";
        public static inline final ASSETLOADEREVENTPROGRESS= "AssetLoaderEventProgress";
        public static inline final ASSETLOADEREVENTUNLOAD= "AssetLoaderEventUnload";
        public static inline final ASSETLOADEREVENTSTATUS= "AssetLoaderEventStatus";
        public static inline final ASSETLOADEREVENTERROR= "AssetLoaderEventError";
        public static inline final ASSETLOADEREVENTOPEN= "AssetLoaderEventOpen";

        var _status:Int = 0;

        public function new(type:String, status:Int)
        {
            this._status = status;
            super(type, false, false);
        }

        public var status(get,never):Int;
public function  get_status():Int
        {
            return this._status;
        }

        override public function clone():Event
        {
            return new AssetLoaderEvent(type, this._status);
        }

        override public function toString():String
        {
            return formatToString("AssetLoaderEvent", "type", "status");
        }
    }

