package org.openvideoads.vast.events
;
    import flash.events.Event;

     class _Str_3525 extends Event 
    {
        public static inline final _Str_3831= "display-notice";
        public static inline final _Str_2703= "hide-notice";
        public static inline final _Str_18470= "tick-notice";

        var _Str_3124:ASObject = null;
        var _Str_2467:Int = 0;

        public function new(k:String, _arg_2:ASObject=null, _arg_3:Int=0, _arg_4:Bool=false, _arg_5:Bool=false)
        {
            super(k, _arg_4, _arg_5);
            if (_arg_2 != null)
            {
                this._Str_3124 = _arg_2;
            }
            this._Str_2467 = _arg_3;
        }

        public function _Str_23019():Bool
        {
            return !(this._Str_3124 == null);
        }

        
        public var notice(get,set):ASObject;
public function  set_notice(k:ASObject):ASObject        {
            return this._Str_3124 = k;
        }
public function  get_notice():ASObject
        {
            return this._Str_3124;
        }

        
        public var duration(get,set):Int;
public function  set_duration(k:Int):Int        {
            return this._Str_2467 = k;
        }
public function  get_duration():Int
        {
            return this._Str_2467;
        }

        override public function clone():Event
        {
            return new _Str_3525(type, this._Str_3124, this._Str_2467, bubbles, cancelable);
        }
    }

