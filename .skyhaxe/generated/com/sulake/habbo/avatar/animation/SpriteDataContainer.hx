package com.sulake.habbo.avatar.animation
;
     class SpriteDataContainer implements ISpriteDataContainer 
    {
        var _animation:IAnimation;
        var _id:String;
        var _ink:Int = 0;
        var _member:String;
        var _hasDirections:Bool = false;
        var _hasStaticY:Bool = false;
        var _dx:Array<ASAny>;
        var _dy:Array<ASAny>;
        var _dz:Array<ASAny>;

        public function new(k:IAnimation, _arg_2:com.sulake.core.utils.xml.XML)
        {
            var _local_3:com.sulake.core.utils.xml.XML = null;
            var _local_4 = 0;
            this._animation = k;
            this._id = _arg_2.attribute("id").toString();
            this._ink = ASCompat.parseInt(_arg_2.attribute("ink").toString());
            this._member = _arg_2.attribute("member").toString();
            this._hasStaticY = ASCompat.toBool(ASCompat.parseInt(_arg_2.attribute("staticY").toString()));
            this._hasDirections = ASCompat.toBool(ASCompat.parseInt(_arg_2.attribute("directions").toString()));
            this._dx = [];
            this._dy = [];
            this._dz = [];
            final _iter_ = _arg_2.child("direction"); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                _local_4 = ASCompat.parseInt(_local_3.attribute("id").toString());
                this._dx[_local_4] = ASCompat.parseInt(_local_3.attribute("dx").toString());
                this._dy[_local_4] = ASCompat.parseInt(_local_3.attribute("dy").toString());
                this._dz[_local_4] = ASCompat.parseInt(_local_3.attribute("dz").toString());
            }
        }

        public function getDirectionOffsetX(k:Int):Int
        {
            if (k < this._dx.length)
            {
                return ASCompat.toInt(this._dx[k]);
            }
            return 0;
        }

        public function getDirectionOffsetY(k:Int):Int
        {
            if (k < this._dy.length)
            {
                return ASCompat.toInt(this._dy[k]);
            }
            return 0;
        }

        public function getDirectionOffsetZ(k:Int):Int
        {
            if (k < this._dz.length)
            {
                return ASCompat.toInt(this._dz[k]);
            }
            return 0;
        }

        public var animation(get,never):IAnimation;
public function  get_animation():IAnimation
        {
            return this._animation;
        }

        public var id(get,never):String;
public function  get_id():String
        {
            return this._id;
        }

        public var ink(get,never):Int;
public function  get_ink():Int
        {
            return this._ink;
        }

        public var member(get,never):String;
public function  get_member():String
        {
            return this._member;
        }

        public var hasDirections(get,never):Bool;
public function  get_hasDirections():Bool
        {
            return this._hasDirections;
        }

        public var hasStaticY(get,never):Bool;
public function  get_hasStaticY():Bool
        {
            return this._hasStaticY;
        }
    }

