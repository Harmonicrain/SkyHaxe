package com.sulake.habbo.ui.widget.events
;
     class _Str_3858 
    {
        var _id:Int = 0;
        var _category:Int = 0;
        var _name:String;
        var _Str_3748:Int = 0;
        var _Str_4105:Int = 0;
        var _Str_21788:Int = 0;
        var _replace:Bool = false;

        public function new(k:Int, _arg_2:Int, _arg_3:String, _arg_4:Int, _arg_5:Int, _arg_6:Int=-1, _arg_7:Bool=false)
        {
            this._id = k;
            this._category = _arg_2;
            this._name = _arg_3;
            this._Str_3748 = _arg_4;
            this._Str_4105 = _arg_5;
            this._Str_21788 = _arg_6;
            this._replace = _arg_7;
        }

        public function dispose()
        {
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

        public var _Str_3710(get,never):Int;
public function  get__Str_3710():Int
        {
            return this._Str_3748;
        }

        public var _Str_5563(get,never):Int;
public function  get__Str_5563():Int
        {
            return this._Str_4105;
        }

        public var _Str_24139(get,never):Int;
public function  get__Str_24139():Int
        {
            return this._Str_21788;
        }

        public var replace(get,never):Bool;
public function  get_replace():Bool
        {
            return this._replace;
        }
    }

