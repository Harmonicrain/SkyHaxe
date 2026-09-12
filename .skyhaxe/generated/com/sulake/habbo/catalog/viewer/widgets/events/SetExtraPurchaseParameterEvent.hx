package com.sulake.habbo.catalog.viewer.widgets.events
;
    import flash.events.Event;

     class SetExtraPurchaseParameterEvent extends Event 
    {
        var _parameter:String;

        public function new(k:String, _arg_2:Bool=false, _arg_3:Bool=false)
        {
            super(CatalogWidgetEvent.SET_EXTRA_PARM, _arg_2, _arg_3);
            this._parameter = k;
        }

        public var parameter(get,never):String;
public function  get_parameter():String
        {
            return this._parameter;
        }
    }

