package com.sulake.habbo.catalog.viewer.widgets.events
;
    import flash.events.Event;

     class CatalogWidgetColourIndexEvent extends Event 
    {
        var _index:Int = 0;

        public function new(k:Int, _arg_2:Bool=false, _arg_3:Bool=false)
        {
            super(CatalogWidgetEvent.COLOUR_INDEX, _arg_2, _arg_3);
            this._index = k;
        }

        public var index(get,never):Int;
public function  get_index():Int
        {
            return this._index;
        }
    }

