package org.openvideoads.vast.events
;
    import flash.events.Event;
    import org.openvideoads.vast.tracking._Str_2460;

     class TrackingPointEvent extends Event 
    {
        public static inline final _Str_17334= "tp-set";
        public static inline final _Str_7314= "tp-fired";
        public static inline final BA= "BA";
        public static inline final EA= "EA";
        public static inline final LINEAR_AD_Q1= "Q1";
        public static inline final HW= "HW";
        public static inline final LINEAR_AD_Q3= "Q3";
        public static inline final BS= "BS";
        public static inline final ES= "ES";

        var _data:ASObject = null;

        public function new(k:String, _arg_2:ASObject=null, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            super(k, _arg_3, _arg_4);
            if (_arg_2 != null)
            {
                this._data = _arg_2;
            }
        }

        public var eventType(get,never):String;
public function  get_eventType():String
        {
            if (this._Str_24608())
            {
                return this.trackingPoint.type;
            }
            return null;
        }

        public function _Str_26012():Bool
        {
            return this.eventType == BA;
        }

        public function _Str_25943():Bool
        {
            return this.eventType == EA;
        }

        public function _Str_13568():Bool
        {
            return !(this._data == null);
        }

        
        public var data(get,set):ASObject;
public function  set_data(k:ASObject):ASObject        {
            return this._data = k;
        }
public function  get_data():ASObject
        {
            return this._data;
        }

        public function _Str_24608():Bool
        {
            return (!(this._data == null)) && Std.is(this.data , _Str_2460);
        }

        public var trackingPoint(get,never):_Str_2460;
public function  get_trackingPoint():_Str_2460
        {
            return ASCompat.dynamicAs(this._data , _Str_2460);
        }

        override public function clone():Event
        {
            return new TrackingPointEvent(type, this._data, bubbles, cancelable);
        }

        override public function toString():String
        {
            return Std.string(this._data);
        }
    }

