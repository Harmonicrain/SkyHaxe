package com.sulake.habbo.avatar.animation
;
     class DirectionDataContainer 
    {
        var _offset:Int = 0;

        public function new(k:com.sulake.core.utils.xml.XML)
        {
            this._offset = ASCompat.parseInt(k.attribute("offset").toString());
        }

        public var offset(get,never):Int;
function  get_offset():Int
        {
            return this._offset;
        }
    }

