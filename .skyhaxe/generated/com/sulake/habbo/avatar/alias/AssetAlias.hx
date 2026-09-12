package com.sulake.habbo.avatar.alias
;
     class AssetAlias 
    {
        var _name:String;
        var _link:String;
        var _flipH:Bool = false;
        var _flipV:Bool = false;

        public function new(k:com.sulake.core.utils.xml.XML)
        {
            this._name = k.attribute("name").toString();
            this._link = k.attribute("link").toString();
            this._flipH = ASCompat.toBool(ASCompat.parseInt(k.attribute("fliph").toString()));
            this._flipV = ASCompat.toBool(ASCompat.parseInt(k.attribute("flipv").toString()));
        }

        public var name(get,never):String;
public function  get_name():String
        {
            return this._name;
        }

        public var link(get,never):String;
public function  get_link():String
        {
            return this._link;
        }

        public var flipH(get,never):Bool;
public function  get_flipH():Bool
        {
            return this._flipH;
        }

        public var flipV(get,never):Bool;
public function  get_flipV():Bool
        {
            return this._flipV;
        }
    }

