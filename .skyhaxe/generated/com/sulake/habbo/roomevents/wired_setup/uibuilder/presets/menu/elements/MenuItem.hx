package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.menu.elements
;
     class MenuItem implements IMenuElement
    {
        var _name:String;
        var _onClick:ASFunction;
        var _tooltip:String;
        var _hasCheckbox:Bool = false;
        var _selectedChange:ASFunction;

        public function new(name:String, onClick:ASFunction, tooltip:String = "",
            hasCheckbox:Bool = false, selectedChange:ASFunction = null)
        {
            this._name = name;
            this._onClick = onClick;
            this._tooltip = tooltip;
            this._hasCheckbox = hasCheckbox;
            this._selectedChange = selectedChange;
        }

        public var name(get,never):String;
public function  get_name():String { return this._name; }
        public var onClick(get,never):ASFunction;
public function  get_onClick():ASFunction { return this._onClick; }
        public var tooltip(get,never):String;
public function  get_tooltip():String { return this._tooltip; }
        public var hasCheckbox(get,never):Bool;
public function  get_hasCheckbox():Bool { return this._hasCheckbox; }
        public var selectedChange(get,never):ASFunction;
public function  get_selectedChange():ASFunction { return this._selectedChange; }
    }

