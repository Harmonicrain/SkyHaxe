package com.sulake.habbo.avatar.geometry
;
     class Node3D 
    {
        var _location:Vector3D;
        var _transformedLocation:Vector3D;
        var _needsTransformation:Bool = false;

        public function new(k:Float, _arg_2:Float, _arg_3:Float)
        {
            this._transformedLocation = new Vector3D();
            this._location = new Vector3D(k, _arg_2, _arg_3);
            if ((((!(k == 0)) || (!(_arg_2 == 0))) || (!(_arg_3 == 0))))
            {
                this._needsTransformation = true;
            }
        }

        public var location(get,never):Vector3D;
public function  get_location():Vector3D
        {
            return this._location;
        }

        public var transformedLocation(get,never):Vector3D;
public function  get_transformedLocation():Vector3D
        {
            return this._transformedLocation;
        }

        public function applyTransform(k:Matrix4x4)
        {
            if (this._needsTransformation)
            {
                this._transformedLocation = k.vectorMultiplication(this._location);
            }
        }
    }

