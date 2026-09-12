package com.sulake.habbo.catalog.viewer.widgets.events
;
    import flash.events.Event;

     class CatalogWidgetUpdateRoomPreviewEvent extends Event 
    {
        var _wallType:String = "default";
        var _floorType:String = "default";
        var _landscapeType:String = "1.1";
        var _tileSize:Int = 64;

        public function new(k:String, _arg_2:String, _arg_3:String, _arg_4:Int, _arg_5:Bool=false, _arg_6:Bool=false)
        {
            super(CatalogWidgetEvent.UPDATE_ROOM_PREVIEW, _arg_5, _arg_6);
            this._floorType = k;
            this._wallType = _arg_2;
            this._landscapeType = _arg_3;
            this._tileSize = _arg_4;
        }

        public var wallType(get,never):String;
public function  get_wallType():String
        {
            return this._wallType;
        }

        public var floorType(get,never):String;
public function  get_floorType():String
        {
            return this._floorType;
        }

        public var landscapeType(get,never):String;
public function  get_landscapeType():String
        {
            return this._landscapeType;
        }

        public var tileSize(get,never):Int;
public function  get_tileSize():Int
        {
            return this._tileSize;
        }
    }

