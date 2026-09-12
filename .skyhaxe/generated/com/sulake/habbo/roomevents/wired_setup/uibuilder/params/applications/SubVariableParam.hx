package com.sulake.habbo.roomevents.wired_setup.uibuilder.params.applications
;
     class SubVariableParam
    {
        var _id:Int = 0;
        var _name:String;
        var _hasExtraText:Bool = false;

        public function new(id:Int, name:String, hasExtraText:Bool = false)
        {
            this._id = id;
            this._name = name;
            this._hasExtraText = hasExtraText;
        }

        public var id(get,never):Int;
public function  get_id():Int { return this._id; }
        public var name(get,never):String;
public function  get_name():String { return this._name; }
        public var hasExtraText(get,never):Bool;
public function  get_hasExtraText():Bool { return this._hasExtraText; }
    }

