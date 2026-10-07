package org.openvideoads.vast.model
;
    import org.openvideoads.base.Debuggable;
    import org.openvideoads.util.NetworkResource;
    import org.openvideoads.util.ArrayUtils;

     class TrackingEvent extends Debuggable 
    {
        public static inline final START= "start";
        public static inline final STOP= "stop";
        public static inline final RESUME= "resume";
        public static inline final MIDPOINT= "midpoint";
        public static inline final EVENT_1STQUARTILE= "firstQuartile";
        public static inline final EVENT_3RDQUARTILE= "thirdQuartile";
        public static inline final COMPLETE= "complete";
        public static inline final MUTE= "mute";
        public static inline final UNMUTE= "unmute";
        public static inline final PAUSE= "pause";
        public static inline final REPLAY= "replay";
        public static inline final FULLSCREEN= "fullscreen";
        public static inline final REWIND= "rewind";
        public static inline final EXPAND= "expand";
        public static inline final COLLAPSE= "collapse";
        public static inline final CLOSE= "close";
        public static inline final ACCEPTINVITATION= "acceptInvitation";
        public static inline final CREATIVEVIEW= "creativeView";
        public static inline final _Str_21110:Float = 5000;

        var _urls:Array<ASAny>;
        var _eventType:String;
        var _lastFired:Float = -1;
        var _alwaysFire:Bool = false;

        public function new(k:String=null, _arg_2:NetworkResource=null, _arg_3:Bool=false)
        {
            this._urls = new Array<ASAny>();
            super();
            this._eventType = k;
            this._alwaysFire = _arg_3;
            if (_arg_2 != null)
            {
                this._Str_9951(_arg_2);
            }
        }

        public function unload()
        {
            var k = 0;
            if (this._urls != null)
            {
                k = 0;
                while (k < this._urls.length)
                {
                    this.urls[k].close();
                    k++;
                }
            }
        }

        
        public var urls(get,set):Array<ASAny>;
public function  set_urls(k:Array<ASAny>):Array<ASAny>        {
            return this._urls = k;
        }
public function  get_urls():Array<ASAny>
        {
            return this._urls;
        }

        public function getURLList():Array<ASAny>
        {
            var _local_2 = 0;
            var k= new Array<ASAny>();
            if (this._urls != null)
            {
                _local_2 = 0;
                while (_local_2 < this._urls.length)
                {
                    k.push(cast(this._urls[_local_2], NetworkResource).url);
                    _local_2++;
                }
            }
            return k;
        }

        public function _Str_9951(k:NetworkResource)
        {
            this._urls.push(k);
        }

        
        public var eventType(get,set):String;
public function  set_eventType(k:String):String        {
            return this._eventType = k;
        }
public function  get_eventType():String
        {
            return this._eventType;
        }

        public function execute()
        {
            var k = 0;
            while (k < this._urls.length)
            {
                this.urls[k].call();
                k++;
            }
        }

        public function clone():TrackingEvent
        {
            var k= new TrackingEvent(this._eventType, null, this._alwaysFire);
            k.urls = this._urls;
            return k;
        }

        override public function toJSObject():ASObject
        {
            var k:ASObject = new ASObject();
            k = {
                "uid":_uid,
                "eventType":this._eventType,
                "urls":ArrayUtils._Str_6975(this._urls),
                "alwaysFire":this._alwaysFire
            }
;            return k;
        }
    }

