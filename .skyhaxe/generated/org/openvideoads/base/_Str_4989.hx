package org.openvideoads.base
;
    import flash.events.EventDispatcher;
    import flash.events.Event;

     class _Str_4989 extends Debuggable 
    {
        var _eventDispatcher:EventDispatcher;

        public function new()
        {
            this._eventDispatcher = new EventDispatcher();
            super();
        }

        public function dispatchEvent(k:Event)
        {
            this._eventDispatcher.dispatchEvent(k);
        }

        public function addEventListener(k:String, _arg_2:ASFunction, _arg_3:Bool=false, _arg_4:Int=0, _arg_5:Bool=false)
        {
            this._eventDispatcher.addEventListener(k, (_arg_2 : ASAny), _arg_3, _arg_4, _arg_5);
        }

        public function removeEventListener(k:String, _arg_2:ASFunction, _arg_3:Bool=false)
        {
            this._eventDispatcher.removeEventListener(k, (_arg_2 : ASAny), _arg_3);
        }
    }

