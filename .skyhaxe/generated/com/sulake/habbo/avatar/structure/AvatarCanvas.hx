package com.sulake.habbo.avatar.structure
;
    import flash.geom.Point;
    import com.sulake.habbo.avatar._enum.AvatarScaleType;

     class AvatarCanvas 
    {
        var _id:String;
        var _width:Int = 0;
        var _height:Int = 0;
        var _offset:Point;
        var _regPoint:Point;

        public function new(k:com.sulake.core.utils.xml.XML, _arg_2:String)
        {
            this._id = k.attribute("id").toString();
            this._width = ASCompat.parseInt(k.attribute("width").toString());
            this._height = ASCompat.parseInt(k.attribute("height").toString());
            this._offset = new Point(ASCompat.parseInt(k.attribute("dx").toString()), ASCompat.parseInt(k.attribute("dy").toString()));
            if (_arg_2 == AvatarScaleType.LARGE)
            {
                this._regPoint = new Point(((this._width - 64) / 2), 0);
            }
            else
            {
                this._regPoint = new Point(((this._width - 32) / 2), 0);
            }
        }

        public var width(get,never):Int;
public function  get_width():Int
        {
            return this._width;
        }

        public var height(get,never):Int;
public function  get_height():Int
        {
            return this._height;
        }

        public var offset(get,never):Point;
public function  get_offset():Point
        {
            return this._offset;
        }

        public var id(get,never):String;
public function  get_id():String
        {
            return this._id;
        }

        public var _Str_1076(get,never):Point;
public function  get__Str_1076():Point
        {
            return this._regPoint;
        }
    }

