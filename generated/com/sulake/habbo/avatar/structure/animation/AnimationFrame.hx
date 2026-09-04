package com.sulake.habbo.avatar.structure.animation
;
     class AnimationFrame 
    {
        var _number:Int = 0;
        var _assetPartDefinition:String;

        public function new(k:com.sulake.core.utils.xml.XML)
        {
            this._number = ASCompat.parseInt(k.attribute("number").toString());
            this._assetPartDefinition = k.attribute("assetpartdefinition").toString();
        }

        public var number(get,never):Int;
function  get_number():Int
        {
            return this._number;
        }

        public var assetPartDefinition(get,never):String;
function  get_assetPartDefinition():String
        {
            return this._assetPartDefinition;
        }
    }

