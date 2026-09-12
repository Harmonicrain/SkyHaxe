package com.sulake.habbo.ui.widget.events
;
     class _Str_3405
    {
        var _id:Int = 0;
        var _category:Int = 0;
        var _name:String;
        var _owner:String;
        var _type:Int = 0;
        var _lowerCaseName:String;

        public function new(k:Int, _arg_2:Int, _arg_3:String, _arg_4:String="", _arg_5:Int=0)
        {
            this._id = k;
            this._category = _arg_2;
            this._name = ((_arg_3 != null) ? _arg_3 : "");
            this._owner = ((_arg_4 != null) ? _arg_4 : "");
            this._type = _arg_5;
            this._lowerCaseName = this._name.toLowerCase();
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }

        public var category(get,never):Int;
public function  get_category():Int
        {
            return this._category;
        }

        public var name(get,never):String;
public function  get_name():String
        {
            return this._name;
        }

        public var owner(get,never):String;
public function  get_owner():String
        {
            return this._owner;
        }

        public var type(get,never):Int;
public function  get_type():Int
        {
            return this._type;
        }

        public var lowerCaseName(get,never):String;
public function  get_lowerCaseName():String
        {
            return this._lowerCaseName;
        }
    }

