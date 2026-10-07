package org.openvideoads.regions.events
;
    import flash.events.Event;
    import org.openvideoads.regions.view.RegionView;
    import flash.events.MouseEvent;

     class _Str_6326 extends Event 
    {
        public static inline final _Str_18707= "region-clicked";

        var _Str_16177:RegionView;
        var _Str_6489:MouseEvent = null;

        public function new(k:String, _arg_2:RegionView, _arg_3:MouseEvent, _arg_4:Bool=false, _arg_5:Bool=false)
        {
            super(k, _arg_4, _arg_5);
            this._Str_16177 = _arg_2;
            this._Str_6489 = _arg_3;
        }

        public var _Str_24777(get,never):RegionView;
public function  get__Str_24777():RegionView
        {
            return this._Str_16177;
        }

        public var regionID(get,never):String;
public function  get_regionID():String
        {
            return this._Str_16177.id;
        }

        
        public var _Str_13787(get,set):MouseEvent;
public function  set__Str_13787(k:MouseEvent):MouseEvent        {
            return this._Str_6489 = k;
        }
public function  get__Str_13787():MouseEvent
        {
            return this._Str_6489;
        }

        override public function clone():Event
        {
            return new _Str_6326(type, this._Str_24777, this._Str_13787, bubbles, cancelable);
        }
    }

