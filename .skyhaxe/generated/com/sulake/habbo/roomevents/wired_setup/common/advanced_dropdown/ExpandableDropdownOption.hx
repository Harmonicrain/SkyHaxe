package com.sulake.habbo.roomevents.wired_setup.common.advanced_dropdown
;
     class ExpandableDropdownOption
    {
        var _id:Int = 0;
        var _displayString:String;
        var _isAdvanced:Bool = false;

        public function new(_arg_1:Int, _arg_2:String, _arg_3:Bool = false)
        {
            this._id = _arg_1;
            this._displayString = _arg_2;
            this._isAdvanced = _arg_3;
        }

        public var id(get,never):Int;
public function  get_id():Int { return this._id; }
        public var displayString(get,never):String;
public function  get_displayString():String { return this._displayString; }
        public var isAdvanced(get,never):Bool;
public function  get_isAdvanced():Bool { return this._isAdvanced; }
    }

