package com.sulake.core.runtime.events
;
    import flash.events.ProgressEvent;

     class LibraryProgressEvent extends ProgressEvent 
    {
        var _elapsedTime:Int = 0;
        var _fileName:String = "";

        public function new(fileName:String, bytesLoaded:UInt=0, bytesTotal:UInt=0, elapsedTime:Int=0)
        {
            this._fileName = fileName;
            this._elapsedTime = elapsedTime;
            super(ProgressEvent.PROGRESS, false, false, bytesLoaded, bytesTotal);
        }

        public var elapsedTime(get,never):Int;
function  get_elapsedTime():Int
        {
            return this._elapsedTime;
        }

        public var fileName(get,never):String;
function  get_fileName():String
        {
            return this._fileName;
        }
    }

