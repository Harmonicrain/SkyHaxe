package com.sulake.habbo.room
;
     class PetColorResult 
    {
        static final COLOR_TAGS:Array<ASAny> = ["Null", "Black", "White", "Grey", "Red", "Orange", "Pink", "Green", "Lime", "Blue", "Light-Blue", "Dark-Blue", "Yellow", "Brown", "Dark-Brown", "Beige", "Cyan", "Purple", "Gold"];

        var _breed:Int = 0;
        var _tag:String;
        var _id:String;
        var _primaryColor:Int = 0;
        var _secondaryColor:Int = 0;
        var _isMaster:Bool = false;
        var _layerTags:Array<ASAny>;

        public function new(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Int, _arg_5:String, _arg_6:Bool, _arg_7:Array<ASAny>)
        {
            this._layerTags = [];
            this._primaryColor = (k & 0xFFFFFF);
            this._secondaryColor = (_arg_2 & 0xFFFFFF);
            this._breed = _arg_3;
            this._tag = (((_arg_4 > -1) && (_arg_4 < COLOR_TAGS.length)) ? COLOR_TAGS[_arg_4] : "");
            this._id = _arg_5;
            this._isMaster = _arg_6;
            this._layerTags = _arg_7;
        }

        public var _Str_5845(get,never):Int;
public function  get__Str_5845():Int
        {
            return this._primaryColor;
        }

        public var _Str_6659(get,never):Int;
public function  get__Str_6659():Int
        {
            return this._secondaryColor;
        }

        public var breed(get,never):Int;
public function  get_breed():Int
        {
            return this._breed;
        }

        public var tag(get,never):String;
public function  get_tag():String
        {
            return this._tag;
        }

        public var id(get,never):String;
public function  get_id():String
        {
            return this._id;
        }

        public var isMaster(get,never):Bool;
public function  get_isMaster():Bool
        {
            return this._isMaster;
        }

        public var layerTags(get,never):Array<ASAny>;
public function  get_layerTags():Array<ASAny>
        {
            return this._layerTags;
        }
    }

