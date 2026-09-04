package com.sulake.habbo.avatar.geometry
;
     class GeometryItem extends Node3D 
    {
        var _id:String;
        var _radius:Float = Math.NaN;
        var _normal:Vector3D;
        var _isDoubleSided:Bool = false;
        var _isDynamic:Bool = false;

        public function new(k:com.sulake.core.utils.xml.XML, _arg_2:Bool=false)
        {
            super(Std.parseFloat(k.attribute("x").toString()), Std.parseFloat(k.attribute("y").toString()), Std.parseFloat(k.attribute("z").toString()));
            this._id = k.attribute("id").toString();
            this._radius = Std.parseFloat(k.attribute("radius").toString());
            this._normal = new Vector3D(Std.parseFloat(k.attribute("nx").toString()), Std.parseFloat(k.attribute("ny").toString()), Std.parseFloat(k.attribute("nz").toString()));
            this._isDoubleSided = ASCompat.toBool(ASCompat.parseInt(k.attribute("double").toString()) );
            this._isDynamic = _arg_2;
        }

        public function getDistance(k:Vector3D):Float
        {
            var _local_2= Math.abs(((k.z - this.transformedLocation.z) - this._radius));
            var _local_3= Math.abs(((k.z - this.transformedLocation.z) + this._radius));
            return Math.min(_local_2, _local_3);
        }

        public var id(get,never):String;
function  get_id():String
        {
            return this._id;
        }

        public var normal(get,never):Vector3D;
function  get_normal():Vector3D
        {
            return this._normal;
        }

        public var isDoubleSided(get,never):Bool;
function  get_isDoubleSided():Bool
        {
            return this._isDoubleSided;
        }

        public function toString():String
        {
            var k= ((((this._id + ": ") + this.location) + " - ") + this.transformedLocation);
            return k;
        }

        public var isDynamic(get,never):Bool;
function  get_isDynamic():Bool
        {
            return this._isDynamic;
        }
    }

