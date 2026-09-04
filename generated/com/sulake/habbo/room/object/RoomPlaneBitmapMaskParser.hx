package com.sulake.habbo.room.object
;
    import com.sulake.core.utils.Map;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.room.utils.XMLValidator;
    import com.sulake.room.utils.IVector3d;

     class RoomPlaneBitmapMaskParser 
    {
        var _masks:Map = null;

        public function new()
        {
            this._masks = new Map();
        }

        public var maskCount(get,never):Int;
function  get_maskCount():Int
        {
            return this._masks.length;
        }

        public function dispose()
        {
            if (this._masks != null)
            {
                this.reset();
                this._masks.dispose();
                this._masks = null;
            }
        }

        public function initialize(k:com.sulake.core.utils.xml.XML):Bool
        {
            var _local_7:com.sulake.core.utils.xml.XML;
            var _local_8:String;
            var _local_9:String;
            var _local_10:Vector3d;
            var _local_11:String;
            var _local_12:com.sulake.core.utils.xml.XMLList;
            var _local_13:com.sulake.core.utils.xml.XML;
            var _local_14:RoomPlaneBitmapMaskData;
            if (k == null)
            {
                return false;
            }
            this._masks.reset();
            var _local_2:Array<ASAny> = ["id", "type", "category"];
            var _local_3:Array<ASAny> = ["x", "y", "z"];
            var _local_4:com.sulake.core.utils.xml.XMLList;
            var _local_5= k.child("planeMask");
            var _local_6 = 0;
            while (_local_6 < _local_5.length())
            {
                _local_7 = _local_5.at(_local_6);
                if (!XMLValidator.checkRequiredAttributes(_local_7, _local_2))
                {
                    return false;
                }
                _local_8 = _local_7.attribute("id").toString();
                _local_9 = _local_7.attribute("type").toString();
                _local_10 = null;
                _local_11 = _local_7.attribute("category").toString();
                _local_12 = _local_7.child("location");
                if (_local_12.length() != 1)
                {
                    return false;
                }
                _local_13 = _local_12.at(0);
                if (!XMLValidator.checkRequiredAttributes(_local_13, _local_3))
                {
                    return false;
                }
                _local_10 = new Vector3d(ASCompat.toNumber(_local_13.attribute("x").toString()), ASCompat.toNumber(_local_13.attribute("y").toString()), ASCompat.toNumber(_local_13.attribute("z").toString()));
                _local_14 = new RoomPlaneBitmapMaskData(_local_9, _local_10, _local_11);
                this._masks.add(_local_8, _local_14);
                _local_6++;
            }
            return true;
        }

        public function reset()
        {
            var _local_2:RoomPlaneBitmapMaskData;
            var k = 0;
            while ((k : UInt) < this._masks.length)
            {
                _local_2 = ASCompat.dynamicAs(this._masks.getWithIndex(k) , RoomPlaneBitmapMaskData);
                if (_local_2 != null)
                {
                    _local_2.dispose();
                }
                k++;
            }
            this._masks.reset();
        }

        public function addMask(k:String, _arg_2:String, _arg_3:IVector3d, _arg_4:String)
        {
            var _local_5= new RoomPlaneBitmapMaskData(_arg_2, _arg_3, _arg_4);
            this._masks.remove(k);
            this._masks.add(k, _local_5);
        }

        public function removeMask(k:String):Bool
        {
            var _local_2= ASCompat.dynamicAs(this._masks.remove(k) , RoomPlaneBitmapMaskData);
            if (_local_2 != null)
            {
                _local_2.dispose();
                return true;
            }
            return false;
        }

        public function getXML():com.sulake.core.utils.xml.XML
        {
            var _local_3:String;
            var _local_4:String;
            var _local_5:com.sulake.core.utils.xml.XML;
            var _local_6:IVector3d;
            var k= new com.sulake.core.utils.xml.XML("<planeMasks/>")
            ;
            var _local_2 = 0;
            while (_local_2 < this.maskCount)
            {
                _local_3 = this.getMaskType(_local_2);
                _local_4 = this.getMaskCategory(_local_2);
                _local_5 = Type.createInstance(com.sulake.core.utils.xml.XML, [(((((('<planeMask id="' + _local_2) + '" type="') + _local_3) + '" category="') + _local_4) + '"/>')]);
                _local_6 = this.getMaskLocation(_local_2);
                if (_local_6 != null)
                {
                    _local_5.appendChild(Type.createInstance(com.sulake.core.utils.xml.XML, [(((((('<location x="' + _local_6.x) + '" y="') + _local_6.y) + '" z="') + _local_6.z) + '"/>')]));
                    k.appendChild(_local_5);
                }
                _local_2++;
            }
            return k;
        }

        public function getMaskLocation(k:Int):IVector3d
        {
            if (((k < 0) || (k >= this.maskCount)))
            {
                return null;
            }
            var _local_2= ASCompat.dynamicAs(this._masks.getWithIndex(k) , RoomPlaneBitmapMaskData);
            if (_local_2 != null)
            {
                return _local_2.loc;
            }
            return null;
        }

        public function getMaskType(k:Int):String
        {
            if (((k < 0) || (k >= this.maskCount)))
            {
                return null;
            }
            var _local_2= ASCompat.dynamicAs(this._masks.getWithIndex(k) , RoomPlaneBitmapMaskData);
            if (_local_2 != null)
            {
                return _local_2.type;
            }
            return null;
        }

        public function getMaskCategory(k:Int):String
        {
            if (((k < 0) || (k >= this.maskCount)))
            {
                return null;
            }
            var _local_2= ASCompat.dynamicAs(this._masks.getWithIndex(k) , RoomPlaneBitmapMaskData);
            if (_local_2 != null)
            {
                return _local_2.category;
            }
            return null;
        }
    }

