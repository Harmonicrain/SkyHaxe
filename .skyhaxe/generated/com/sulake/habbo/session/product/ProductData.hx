package com.sulake.habbo.session.product
;
     class ProductData implements IProductData 
    {
        var _type:String;
        var _name:String;
        var _description:String;

        public function new(k:String, _arg_2:String, _arg_3:String)
        {
            this._type = k;
            this._name = _arg_2;
            this._description = _arg_3;
        }

        public var type(get,never):String;
public function  get_type():String
        {
            return this._type;
        }

        public var name(get,never):String;
public function  get_name():String
        {
            return this._name;
        }

        public var description(get,never):String;
public function  get_description():String
        {
            return this._description;
        }
    }

