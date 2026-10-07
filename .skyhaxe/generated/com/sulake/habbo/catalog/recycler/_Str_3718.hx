package com.sulake.habbo.catalog.recycler
;
     class _Str_3718 
    {
        var _id:Int = 0;
        var _category:Int = 0;
        var _typeId:Int = 0;
        var _xxxExtra:String = null;

        public function new(k:Int, _arg_2:Int, _arg_3:Int=0, _arg_4:String=null)
        {
            this._id = k;
            this._category = _arg_2;
            this._typeId = _arg_3;
            this._xxxExtra = _arg_4;
        }

        
        public var id(get,set):Int;
public function  get_id():Int
        {
            return this._id;
        }

        public var category(get,never):Int;
public function  get_category():Int
        {
            return this._category;
        }

        public var typeId(get,never):Int;
public function  get_typeId():Int
        {
            return this._typeId;
        }

        public var xxxExtra(get,never):String;
public function  get_xxxExtra():String
        {
            return this._xxxExtra;
        }
public function  set_id(k:Int):Int        {
            return this._id = k;
        }
    }

