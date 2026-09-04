package com.sulake.habbo.avatar.geometry
;
    import com.sulake.habbo.avatar.IAvatarImage;

     class GeometryBodyPart extends Node3D 
    {
        var _id:String;
        var _parts:ASDictionary<ASAny,ASAny>;
        var _radius:Float = Math.NaN;
        var _dynamicParts:ASDictionary<ASAny,ASAny>;

        public function new(k:com.sulake.core.utils.xml.XML)
        {
            super(Std.parseFloat(k.attribute("x").toString()), Std.parseFloat(k.attribute("y").toString()), Std.parseFloat(k.attribute("z").toString()));
            this._radius = Std.parseFloat(k.attribute("radius").toString());
            this._id = k.attribute("id").toString();
            this._parts = new ASDictionary<ASAny,ASAny>();
            this._dynamicParts = new ASDictionary<ASAny,ASAny>(true);
            this.collectItems(k);
        }

        function collectItems(k:com.sulake.core.utils.xml.XML)
        {
            var child:com.sulake.core.utils.xml.XML;
            for (_tmp_ in k.children())
            {
child  = _tmp_;
                if (child.localName() == "item")
                {
                    this._parts[child.attribute("id").toString()] = new GeometryItem(child);
                }
                this.collectItems(child);
            }
        }

        public function getDynamicParts(k:IAvatarImage):Array<ASAny>
        {
            var _local_3:GeometryItem;
            var _local_2:Array<ASAny> = [];
            if (this._dynamicParts[k] != /*undefined*/null)
            {
                for (_tmp_ in this._dynamicParts[k])
                {
_local_3  = _tmp_;
                    if (_local_3 != null)
                    {
                        _local_2.push(_local_3);
                    }
                }
            }
            return _local_2;
        }

        public function getPartIds(k:IAvatarImage):Array<ASAny>
        {
            var _local_2:GeometryItem;
            var _local_3:Array<ASAny> = [];
            for (_tmp_ in this._parts)
            {
_local_2  = _tmp_;
                if (_local_2 != null)
                {
                    _local_3.push(_local_2.id);
                }
            }
            if (this._dynamicParts[k] != /*undefined*/null)
            {
                for (_tmp_ in this._dynamicParts[k])
                {
_local_2  = _tmp_;
                    if (_local_2 != null)
                    {
                        _local_3.push(_local_2.id);
                    }
                }
            }
            return _local_3;
        }

        public function removeDynamicParts(k:IAvatarImage):Bool
        {
            var _local_2:String;
            if (this._dynamicParts[k] != /*undefined*/null)
            {
                for (_tmp_ in this._dynamicParts[k].___keys())
                {
var _local_2:String  = _tmp_;
                    Reflect.deleteField(this._dynamicParts[k], _local_2);
                }
                this._dynamicParts[k] = null;
                this._dynamicParts.remove(k);
            }
            return true;
        }

        public function addPart(k:com.sulake.core.utils.xml.XML, _arg_2:IAvatarImage):Bool
        {
            var _local_3= k.attribute("id").toString();
            if (this.hasPart(_local_3, _arg_2))
            {
                return false;
            }
            if (this._dynamicParts[_arg_2] == /*undefined*/null)
            {
                this._dynamicParts[_arg_2] = new ASDictionary<ASAny,ASAny>();
            }
            this._dynamicParts[_arg_2][_local_3] = new GeometryItem(k, true);
            return true;
        }

        public function hasPart(k:String, _arg_2:IAvatarImage):Bool
        {
            var _local_3:GeometryItem = this._parts[k];
            if (((_local_3 == null) && (!(this._dynamicParts[_arg_2] == /*undefined*/null))))
            {
                _local_3 = this._dynamicParts[_arg_2][k];
            }
            return !(_local_3 == null);
        }

        public function _Str_713(k:Matrix4x4, _arg_2:Vector3D, _arg_3:Array<ASAny>, _arg_4:IAvatarImage):Array<ASAny>
        {
            var _local_5:Float;
            var _local_6:GeometryItem;
            var _local_9:Array<ASAny>;
            var _local_7= new Array<ASAny>();
            var _local_8= new Array<ASAny>();
            for (_tmp_ in this._parts)
            {
_local_6  = _tmp_;
                if (_local_6 != null)
                {
                    _local_6.applyTransform(k);
                    _local_5 = _local_6.getDistance(_arg_2);
                    _local_7.push([_local_5, _local_6]);
                }
            }
            for (_tmp_ in this._dynamicParts[_arg_4])
            {
_local_6  = _tmp_;
                if (_local_6 != null)
                {
                    _local_6.applyTransform(k);
                    _local_5 = _local_6.getDistance(_arg_2);
                    _local_7.push([_local_5, _local_6]);
                }
            }
            ASCompat.ASArray.sort(_local_7, this.orderParts);
            for (_tmp_ in _local_7)
            {
_local_9  = _tmp_;
                _local_6 = ASCompat.dynamicAs(_local_9[1] , GeometryItem);
                _local_8.push(_local_6.id);
            }
            return _local_8;
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

        function orderParts(k:Array<ASAny>, _arg_2:Array<ASAny>):Float
        {
            var _local_3= ASCompat.toNumber(k[0] );
            var _local_4= ASCompat.toNumber(_arg_2[0] );
            if (_local_3 < _local_4)
            {
                return -1;
            }
            if (_local_3 > _local_4)
            {
                return 1;
            }
            return 0;
        }

        public var radius(get,never):Float;
function  get_radius():Float
        {
            return this._radius;
        }
    }

