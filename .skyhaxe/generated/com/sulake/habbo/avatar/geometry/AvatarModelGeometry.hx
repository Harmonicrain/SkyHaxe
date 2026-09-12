package com.sulake.habbo.avatar.geometry
;
    import com.sulake.habbo.avatar.structure.AvatarCanvas;
    import com.sulake.habbo.avatar.IAvatarImage;

     class AvatarModelGeometry 
    {
        var _avatarSet:AvatarSet;
        var _geometryTypes:ASDictionary<ASAny,ASAny>;
        var _itemIdToBodyPartMap:ASDictionary<ASAny,ASAny>;
        var _transformation:Matrix4x4;
        var _camera:Vector3D;
        var _canvases:ASDictionary<ASAny,ASAny>;

        public function new(k:com.sulake.core.utils.xml.XML)
        {
            var _local_3:com.sulake.core.utils.xml.XML = null;
            var _local_4:com.sulake.core.utils.xml.XML = null;
            var _local_5:AvatarCanvas = null;
            var _local_6:com.sulake.core.utils.xml.XML = null;
            var _local_7:ASDictionary<ASAny,ASAny> = null;
            var _local_8:ASDictionary<ASAny,ASAny> = null;
            var _local_9:com.sulake.core.utils.xml.XML = null;
            var _local_10:GeometryBodyPart = null;
            var _local_11 = Math.NaN;
            var _local_12 = Math.NaN;
            var _local_13 = Math.NaN;
            var _local_14:String = null;
            var _local_15:ASDictionary<ASAny,ASAny> = null;
            var _local_16:String = null;
            this._camera = new Vector3D(0, 0, 10);
            this._transformation = new Matrix4x4();
            this._geometryTypes = new ASDictionary<ASAny,ASAny>();
            this._itemIdToBodyPartMap = new ASDictionary<ASAny,ASAny>();
            this._avatarSet = new AvatarSet(k.child("avatarset").at(0));
            this._canvases = new ASDictionary<ASAny,ASAny>();
            var _local_2= k.child("camera").at(0);
            if (_local_2 != null)
            {
                _local_11 = Std.parseFloat(ASCompat.xmlListToString(_local_2.child("x").text()));
                _local_12 = Std.parseFloat(ASCompat.xmlListToString(_local_2.child("y").text()));
                _local_13 = Std.parseFloat(ASCompat.xmlListToString(_local_2.child("z").text()));
                this._camera.x = _local_11;
                this._camera.y = _local_12;
                this._camera.z = _local_13;
            }
            final _iter_ = k.child("canvas"); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                _local_14 = _local_3.attribute("scale").toString();
                _local_15 = new ASDictionary<ASAny,ASAny>();
                final _iter_ = _local_3.child("geometry"); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_4  = _tmp_;
                    _local_5 = new AvatarCanvas(_local_4, _local_14);
                    _local_15[_local_4.attribute("id").toString()] = _local_5;
                }
                this._canvases[_local_14] = _local_15;
            }
            final _iter_ = k.child("type"); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_6  = _tmp_;
                _local_7 = new ASDictionary<ASAny,ASAny>();
                _local_8 = new ASDictionary<ASAny,ASAny>();
                final _iter_ = _local_6.child("bodypart"); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_9  = _tmp_;
                    _local_10 = new GeometryBodyPart(_local_9);
                    _local_7[_local_9.attribute("id").toString()] = _local_10;
                    final _iter_ = _local_10.getPartIds(null); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                    {
_local_16  = _tmp_;
                        _local_8[_local_16] = _local_10;
                    }
                }
                this._geometryTypes[_local_6.attribute("id").toString()] = _local_7;
                this._itemIdToBodyPartMap[_local_6.attribute("id").toString()] = _local_8;
            }
        }

        public function _Str_2101(k:IAvatarImage)
        {
            var _local_2:ASDictionary<ASAny,ASAny> = null;
            var _local_3:GeometryBodyPart = null;
            final _iter_ = this._geometryTypes; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (checkNullIteratee(_local_2)) for (_tmp_ in _local_2)
                {
_local_3  = _tmp_;
                    _local_3.removeDynamicParts(k);
                }
            }
        }

        public function getBodyPartIdsInAvatarSet(k:String):Array<ASAny>
        {
            var _local_2:Array<ASAny> = [];
            var _local_3= this._avatarSet.findAvatarSet(k);
            if (_local_3 != null)
            {
                _local_2 = _local_3.getBodyParts();
            }
            return _local_2;
        }

        public function _Str_1939(k:String):Bool
        {
            var _local_2= this._avatarSet.findAvatarSet(k);
            if (_local_2 != null)
            {
                return _local_2.isMain;
            }
            return false;
        }

        public function getCanvas(k:String, _arg_2:String):AvatarCanvas
        {
            var _local_4:AvatarCanvas = null;
            var _local_3:ASDictionary<ASAny,ASAny> = this._canvases[k];
            if (_local_3 != null)
            {
                _local_4 = ASCompat.dynamicAs(_local_3[_arg_2] , AvatarCanvas);
            }
            return _local_4;
        }

        function typeExists(k:String):Bool
        {
            return !(this._geometryTypes[k] == null);
        }

        function hasBodyPart(k:String, _arg_2:String):Bool
        {
            var _local_3:ASDictionary<ASAny,ASAny> = null;
            if (this.typeExists(k))
            {
                _local_3 = ASDictionary.asDictionary(this._geometryTypes[k] );
                return !(_local_3[_arg_2] == null);
            }
            return false;
        }

        function getBodyPartIDs(k:String):Array<ASAny>
        {
var _local_4:String  = null;            var _local_4:String = null;
            var _local_2= this.getBodyPartsOfType(k);
            var _local_3= new Array<ASAny>();
            final _iter_ = this._geometryTypes; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
            {
_local_4 = _tmp_;
                _local_3.push(_local_4);
            }
            return _local_3;
        }

        function getBodyPartsOfType(k:String):ASDictionary<ASAny,ASAny>
        {
            if (this.typeExists(k))
            {
                return ASDictionary.asDictionary(this._geometryTypes[k] );
            }
            return new ASDictionary<ASAny,ASAny>();
        }

        public function getBodyPart(k:String, _arg_2:String):GeometryBodyPart
        {
            var _local_3= this.getBodyPartsOfType(k);
            return _local_3[_arg_2];
        }

        public function getBodyPartOfItem(k:String, _arg_2:String, _arg_3:IAvatarImage):GeometryBodyPart
        {
            var _local_5:GeometryBodyPart = null;
            var _local_6:ASDictionary<ASAny,ASAny> = null;
            var _local_4:ASDictionary<ASAny,ASAny> = this._itemIdToBodyPartMap[k];
            if (_local_4 != null)
            {
                _local_5 = _local_4[_arg_2];
                if (_local_5 != null)
                {
                    return _local_5;
                }
                _local_6 = this.getBodyPartsOfType(k);
                if (checkNullIteratee(_local_6)) for (_tmp_ in _local_6)
                {
_local_5  = _tmp_;
                    if (_local_5.hasPart(_arg_2, _arg_3))
                    {
                        return _local_5;
                    }
                }
            }
            return null;
        }

        function getBodyPartsInAvatarSet(k:ASDictionary<ASAny,ASAny>, _arg_2:String):Array<ASAny>
        {
            var _local_5:GeometryBodyPart = null;
            var _local_6:String = null;
            var _local_3:Array<ASAny> = [];
            var _local_4= this.getBodyPartIdsInAvatarSet(_arg_2);
            if (checkNullIteratee(_local_4)) for (_tmp_ in _local_4)
            {
_local_6  = _tmp_;
                _local_5 = k[_local_6];
                if (_local_5 != null)
                {
                    _local_3.push(_local_5);
                }
            }
            return _local_3;
        }

        public function _Str_2250(k:String, _arg_2:UInt, _arg_3:String):Array<ASAny>
        {
            var _local_7:GeometryBodyPart = null;
            var _local_9 = Math.NaN;
            var _local_10:Array<ASAny> = null;
            if (_arg_3 == null)
            {
                Logger.log(["[AvatarModelGeometry] ERROR: Geometry ID not found for action: "]);
                return [];
            }
            var _local_4= this.getBodyPartsOfType(_arg_3);
            var _local_5= this.getBodyPartsInAvatarSet(_local_4, k);
            var _local_6= new Array<ASAny>();
            var _local_8= new Array<ASAny>();
            this._transformation = Matrix4x4.getYRotationMatrix(_arg_2);
            if (checkNullIteratee(_local_5)) for (_tmp_ in _local_5)
            {
_local_7  = _tmp_;
                _local_7.applyTransform(this._transformation);
                _local_9 = _local_7.getDistance(this._camera);
                _local_6.push(([_local_9, _local_7] : Array<Dynamic>));
            }
            ASCompat.ASArray.sort(_local_6, this.orderByDistance);
            if (checkNullIteratee(_local_6)) for (_tmp_ in _local_6)
            {
_local_10  = _tmp_;
                _local_7 = ASCompat.dynamicAs(_local_10[1] , GeometryBodyPart);
                _local_8.push(_local_7.id);
            }
            return _local_8;
        }

        public function _Str_713(k:String, _arg_2:String, _arg_3:UInt, _arg_4:Array<ASAny>, _arg_5:IAvatarImage):Array<ASAny>
        {
            var _local_6:GeometryBodyPart = null;
            if (this.hasBodyPart(k, _arg_2))
            {
                _local_6 = ASCompat.dynamicAs(this.getBodyPartsOfType(k)[_arg_2] , GeometryBodyPart);
                this._transformation = Matrix4x4.getYRotationMatrix(_arg_3);
                return _local_6._Str_713(this._transformation, this._camera, _arg_4, _arg_5);
            }
            return [];
        }

        function orderByDistance(k:Array<ASAny>, _arg_2:Array<ASAny>):Float
        {
            var _local_3= ASCompat.asNumber(k[0] );
            var _local_4= ASCompat.asNumber(_arg_2[0] );
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
    }

