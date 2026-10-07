package org.openvideoads.util
;
    import flash.utils.Timer;
    import flash.net.URLRequest;
    import flash.events.TimerEvent;
    import flash.events.Event;
    import flash.utils.ByteArray;

     class _Str_9615 extends TransformingLoader 
    {
        var _Str_17656:Timer = null;


        override public function load(k:URLRequest)
        {
        }

        public function process(k:String)
        {
            this.data = k;
            this._Str_17656 = new Timer(300, 1);
            this._Str_17656.addEventListener(TimerEvent.TIMER, (this._Str_22988 : ASAny));
            this._Str_17656.start();
        }

        function _Str_22988(k:TimerEvent)
        {
            this.dispatchEvent(new Event(Event.COMPLETE));
        }

        public function _Str_25957():UInt
        {
            var k:com.sulake.core.utils.ByteArray = null;
            if (this.data != null)
            {
                k = new com.sulake.core.utils.ByteArray();
                k.writeUTFBytes(this.data);
                return k.length;
            }
            return 0;
        }

	public function new() { super(); }
    }

