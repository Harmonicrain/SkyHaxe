package com.sulake.core.window.graphics.renderer
;
    import flash.geom.Rectangle;

     class SkinTemplateEntity implements ISkinTemplateEntity 
    {
        var _id:UInt = 0;
        var _name:String;
        var _type:String;
        var _rect:Rectangle;

        public function new(name:String, type:String, id:UInt, rect:Rectangle)
        {
            this._id = id;
            this._name = name;
            this._type = type;
            this._rect = rect;
        }

        public var id(get,never):UInt;
public function  get_id():UInt
        {
            return this._id;
        }

        public var name(get,never):String;
public function  get_name():String
        {
            return this._name;
        }

        public var type(get,never):String;
public function  get_type():String
        {
            return this._type;
        }

        public var region(get,never):Rectangle;
public function  get_region():Rectangle
        {
            return this._rect;
        }
    }

