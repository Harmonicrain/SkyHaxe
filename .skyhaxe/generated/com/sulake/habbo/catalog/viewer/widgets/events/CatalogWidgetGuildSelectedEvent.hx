package com.sulake.habbo.catalog.viewer.widgets.events
;
    import flash.events.Event;

     class CatalogWidgetGuildSelectedEvent extends Event 
    {
        public static inline final _Str_15457= -1;

        var _guildId:Int = 0;
        var _color1:String;
        var _color2:String;
        var _badgeCode:String;

        public function new(k:Int, _arg_2:String, _arg_3:String, _arg_4:String)
        {
            this._guildId = k;
            this._color1 = _arg_2;
            this._color2 = _arg_3;
            this._badgeCode = _arg_4;
            super(CatalogWidgetEvent.GUILD_SELECTED);
        }

        public var guildId(get,never):Int;
public function  get_guildId():Int
        {
            return this._guildId;
        }

        public var color1(get,never):String;
public function  get_color1():String
        {
            return this._color1;
        }

        public var color2(get,never):String;
public function  get_color2():String
        {
            return this._color2;
        }

        public var badgeCode(get,never):String;
public function  get_badgeCode():String
        {
            return this._badgeCode;
        }
    }

