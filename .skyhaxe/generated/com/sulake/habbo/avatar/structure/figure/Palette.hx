package com.sulake.habbo.avatar.structure.figure
;

     class Palette implements IPalette 
    {
        var _id:Int = 0;
        var _colors:ASDictionary<ASAny,ASAny>;

        public function new(k:com.sulake.core.utils.xml.XML)
        {
            this._id = ASCompat.parseInt(k.attribute("id").toString());
            this._colors = new ASDictionary<ASAny,ASAny>();
            this._Str_2015(k);
        }

        public function _Str_2015(k:com.sulake.core.utils.xml.XML)
        {
            var _local_2:com.sulake.core.utils.xml.XML = null;
            final _iter_ = k.child("color"); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                this._colors[_local_2.attribute("id").toString()] = new PartColor(_local_2);
            }
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }

        public function getColor(k:Int):IPartColor
        {
            return this._colors[Std.string(k)];
        }

        public var colors(get,never):ASDictionary<ASAny,ASAny>;
public function  get_colors():ASDictionary<ASAny,ASAny>
        {
            return this._colors;
        }
    }

