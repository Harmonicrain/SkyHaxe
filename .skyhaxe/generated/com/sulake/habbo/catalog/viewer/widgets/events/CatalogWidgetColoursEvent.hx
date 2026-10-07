package com.sulake.habbo.catalog.viewer.widgets.events
;
    import flash.events.Event;

     class CatalogWidgetColoursEvent extends Event 
    {
        var _colours:Array<ASAny>;
        var _backgroundAssetName:String;
        var _colourAssetName:String;
        var _chosenColourAssetName:String;
        var _index:Int = 0;

        public function new(k:Array<ASAny>, _arg_2:String, _arg_3:String, _arg_4:String, _arg_5:Int=0, _arg_6:Bool=false, _arg_7:Bool=false)
        {
            super(CatalogWidgetEvent.COLOUR_ARRAY, _arg_6, _arg_7);
            this._colours = k;
            this._backgroundAssetName = _arg_2;
            this._colourAssetName = _arg_3;
            this._chosenColourAssetName = _arg_4;
            this._index = _arg_5;
        }

        public var colours(get,never):Array<ASAny>;
public function  get_colours():Array<ASAny>
        {
            return this._colours;
        }

        public var _Str_17113(get,never):String;
public function  get__Str_17113():String
        {
            return this._backgroundAssetName;
        }

        public var _Str_17801(get,never):String;
public function  get__Str_17801():String
        {
            return this._colourAssetName;
        }

        public var _Str_17175(get,never):String;
public function  get__Str_17175():String
        {
            return this._chosenColourAssetName;
        }

        public var index(get,never):Int;
public function  get_index():Int
        {
            return this._index;
        }
    }

