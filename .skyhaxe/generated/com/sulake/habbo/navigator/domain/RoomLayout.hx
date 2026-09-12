package com.sulake.habbo.navigator.domain
;
    import com.sulake.core.window.IWindowContainer;

     class RoomLayout 
    {
        var _level:Int = 0;
        var _tileSize:Int = 0;
        var _name:String;
        var _view:IWindowContainer;

        public function new(_level:Int, _tileSize:Int, _name:String)
        {
            this._level = _level;
            this._tileSize = _tileSize;
            this._name = _name;
        }

        public var requiredClubLevel(get,never):Int;
public function  get_requiredClubLevel():Int
        {
            return this._level;
        }

        public var tileSize(get,never):Int;
public function  get_tileSize():Int
        {
            return this._tileSize;
        }

        public var name(get,never):String;
public function  get_name():String
        {
            return this._name;
        }

        
        public var view(get,set):IWindowContainer;
public function  get_view():IWindowContainer
        {
            return this._view;
        }
public function  set_view(k:IWindowContainer):IWindowContainer        {
            return this._view = k;
        }
    }

