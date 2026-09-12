package com.sulake.habbo.catalog.viewer.widgets.events
;
    import flash.events.Event;

     class TextInputEvent extends Event 
    {
        var _text:String;

        public function new(k:String, _arg_2:Bool=false, _arg_3:Bool=false)
        {
            super(CatalogWidgetEvent.TEXT_INPUT, _arg_2, _arg_3);
            this._text = k;
        }

        public var text(get,never):String;
public function  get_text():String
        {
            return this._text;
        }
    }

