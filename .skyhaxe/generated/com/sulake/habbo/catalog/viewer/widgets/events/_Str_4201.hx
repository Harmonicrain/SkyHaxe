package com.sulake.habbo.catalog.viewer.widgets.events
;
    import flash.events.Event;

     class _Str_4201 extends Event 
    {
        var _Str_11471:String;
        var _enabled:Bool = false;

        public function new(k:String, _arg_2:Bool, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            super(CatalogWidgetEvent.TOGGLE, _arg_3, _arg_4);
            this._Str_11471 = k;
            this._enabled = _arg_2;
        }

        public var _Str_25555(get,never):String;
public function  get__Str_25555():String
        {
            return this._Str_11471;
        }

        public var enabled(get,never):Bool;
public function  get_enabled():Bool
        {
            return this._enabled;
        }
    }

