package com.sulake.habbo.room.object.visualization.furniture
;
    import flash.geom.Vector3D;
    import com.sulake.room.object.visualization.utils.IGraphicAsset;

     class FurnitureParticleSystemParticle 
    {
        var _x:Float = Math.NaN;
        var _y:Float = Math.NaN;
        var _z:Float = Math.NaN;
        var _lastX:Float = Math.NaN;
        var _lastY:Float = Math.NaN;
        var _lastZ:Float = Math.NaN;
        var _hasMoved:Bool = false;
        var _direction:Vector3D;
        var _age:Int = 0;
        var _lifeTime:Int = 0;
        var _isEmitter:Bool = false;
        var _fade:Bool = false;
        var _fadeTime:Float = Math.NaN;
        var _alphaMultiplier:Float = 1;
        var _frames:Array<ASAny>;


        public var fade(get,never):Bool;
function  get_fade():Bool
        {
            return this._fade;
        }

        public var alphaMultiplier(get,never):Float;
function  get_alphaMultiplier():Float
        {
            return this._alphaMultiplier;
        }

        public var direction(get,never):Vector3D;
function  get_direction():Vector3D
        {
            return this._direction;
        }

        public var age(get,never):Int;
function  get_age():Int
        {
            return this._age;
        }

        public function init(k:Float, _arg_2:Float, _arg_3:Float, _arg_4:Vector3D, _arg_5:Float, _arg_6:Float, _arg_7:Int, _arg_8:Bool=false, _arg_9:Array<ASAny>=null, _arg_10:Bool=false)
        {
            this._x = k;
            this._y = _arg_2;
            this._z = _arg_3;
            this._direction = new Vector3D(_arg_4.x, _arg_4.y, _arg_4.z);
            this._direction.scaleBy(_arg_5);
            this._lastX = (this._x - (this._direction.x * _arg_6));
            this._lastY = (this._y - (this._direction.y * _arg_6));
            this._lastZ = (this._z - (this._direction.z * _arg_6));
            this._age = 0;
            this._hasMoved = false;
            this._lifeTime = _arg_7;
            this._isEmitter = _arg_8;
            this._frames = _arg_9;
            this._fade = _arg_10;
            this._alphaMultiplier = 1;
            this._fadeTime = (0.5 + (Math.random() * 0.5));
        }

        public function update()
        {
            this._age++;
            if (this._age == this._lifeTime)
            {
                this.ignite();
            }
            if (this._fade)
            {
                if ((this._age / this._lifeTime) > this._fadeTime)
                {
                    this._alphaMultiplier = ((this._lifeTime - this._age) / (this._lifeTime * (1 - this._fadeTime)));
                }
            }
        }

        public function getAsset():IGraphicAsset
        {
            if (((this._frames != null) && (this._frames.length > 0)))
            {
                return this._frames[(this._age % this._frames.length)];
            }
            return null;
        }

        function ignite()
        {
        }

        public var isEmitter(get,never):Bool;
function  get_isEmitter():Bool
        {
            return this._isEmitter;
        }

        public var isAlive(get,never):Bool;
function  get_isAlive():Bool
        {
            return this._age <= this._lifeTime;
        }

        public function dispose()
        {
            this._direction = null;
        }

        
        public var x(get,set):Float;
function  get_x():Float
        {
            return this._x;
        }

        
        public var y(get,set):Float;
function  get_y():Float
        {
            return this._y;
        }

        
        public var z(get,set):Float;
function  get_z():Float
        {
            return this._z;
        }
function  set_x(k:Float):Float        {
            return this._x = k;
        }
function  set_y(k:Float):Float        {
            return this._y = k;
        }
function  set_z(k:Float):Float        {
            return this._z = k;
        }

        
        public var _Str_10744(get,set):Float;
function  get__Str_10744():Float
        {
            return this._lastX;
        }
function  set__Str_10744(k:Float):Float        {
            this._hasMoved = true;
            return this._lastX = k;
        }

        
        public var _Str_12459(get,set):Float;
function  get__Str_12459():Float
        {
            return this._lastY;
        }
function  set__Str_12459(k:Float):Float        {
            this._hasMoved = true;
            return this._lastY = k;
        }

        
        public var _Str_11680(get,set):Float;
function  get__Str_11680():Float
        {
            return this._lastZ;
        }
function  set__Str_11680(k:Float):Float        {
            this._hasMoved = true;
            return this._lastZ = k;
        }

        public var hasMoved(get,never):Bool;
function  get_hasMoved():Bool
        {
            return this._hasMoved;
        }

        public function toString():String
        {
            return [this._x, this._y, this._z].toString();
        }

        public function copy(k:FurnitureParticleSystemParticle, _arg_2:Float)
        {
            this._x = (k._x * _arg_2);
            this._y = (k._y * _arg_2);
            this._z = (k._z * _arg_2);
            this._lastX = (k._lastX * _arg_2);
            this._lastY = (k._lastY * _arg_2);
            this._lastZ = (k._lastZ * _arg_2);
            this._hasMoved = k.hasMoved;
            this._direction = k._direction;
            this._age = k._age;
            this._lifeTime = k._lifeTime;
            this._isEmitter = k._isEmitter;
            this._fade = k._fade;
            this._fadeTime = k._fadeTime;
            this._alphaMultiplier = k._alphaMultiplier;
        }
public function new(){}
    }

