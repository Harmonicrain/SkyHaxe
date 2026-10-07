package org.openvideoads.util
;
    import flash.utils.Timer;
    import flash.events.Event;
    import flash.events.ErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.events.IOErrorEvent;
    import flash.net.URLRequest;
    import flash.events.TimerEvent;
    import org.openvideoads.events._Str_5692;

     class TimedTransformingLoader extends TransformingLoader 
    {
        var _Str_13620:Int = -1;
        var _Str_2850:Timer = null;

        public function new(k:Float=-1)
        {
            super();
            this._Str_13620 = Std.int(k);
            addEventListener(Event.COMPLETE, (this._Str_15779 : ASAny));
            addEventListener(ErrorEvent.ERROR, (this._Str_15779 : ASAny));
            addEventListener(SecurityErrorEvent.SECURITY_ERROR, (this._Str_15779 : ASAny));
            addEventListener(IOErrorEvent.IO_ERROR, (this._Str_15779 : ASAny));
        }

        override public function load(k:URLRequest)
        {
            if (this._Str_13620 > 0)
            {
                this._Str_8612();
            }
            super.load(k);
        }

        function _Str_15779(k:Event)
        {
            if (this._Str_2850 != null)
            {
                this._Str_4743();
            }
        }

        function _Str_8612()
        {
            if (this._Str_2850 != null)
            {
                this._Str_4743();
            }
            if (this._Str_13620 > 0)
            {
                this._Str_2850 = new Timer(this._Str_13620, 1);
                this._Str_2850.addEventListener(TimerEvent.TIMER, (this._Str_17789 : ASAny));
                this._Str_2850.start();
            }
        }

        function _Str_4743()
        {
            if (this._Str_2850 != null)
            {
                this._Str_2850.stop();
                this._Str_2850 = null;
            }
        }

        function _Str_17789(k:TimerEvent)
        {
            this.close();
            this._Str_4743();
            dispatchEvent(new _Str_5692(_Str_5692._Str_5406));
        }
    }

