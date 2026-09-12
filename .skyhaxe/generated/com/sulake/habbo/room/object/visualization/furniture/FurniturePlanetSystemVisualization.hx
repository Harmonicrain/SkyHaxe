package com.sulake.habbo.room.object.visualization.furniture
;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.room.object.visualization.IRoomObjectSprite;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;

     class FurniturePlanetSystemVisualization extends FurnitureAnimatedVisualization 
    {
        var _planetIndex:Array<ASAny>;
        var _planetNameIndex:Array<ASAny>;
        var _offsetArray:Array<ASAny>;
        var _rootPosition:Vector3d;

        public function new()
        {
            this._offsetArray = new Array<ASAny>();
            this._rootPosition = new Vector3d(0, 0, 0);
            super();
        }

        override public function dispose()
        {
            var k:FurniturePlanetSystemVisualizationPlanetObject = null;
            if (this._planetIndex != null)
            {
                while (this._planetIndex.length > 0)
                {
                    k = this._planetIndex.shift();
                    k.dispose();
                }
            }
            this._planetIndex = null;
            this._planetNameIndex = null;
        }

        override function updateAnimation(k:Float):Int
        {
            var _local_2:FurniturePlanetSystemVisualizationPlanetObject = null;
            var _local_3 = 0;
            if (((this._planetIndex == null) && (spriteCount > 0)))
            {
                if (!this._Str_18684())
                {
                    return 0;
                }
            }
            if (this._planetIndex != null)
            {
                _local_3 = 0;
                while (_local_3 < this._planetIndex.length)
                {
                    _local_2 = this._planetIndex[_local_3];
                    _local_2.update(this._offsetArray, this._rootPosition, k);
                    _local_3++;
                }
                return super.updateAnimation(k);
            }
            return 0;
        }

        override function getSpriteXOffset(k:Int, _arg_2:Int, _arg_3:Int):Int
        {
            if (_arg_3 < this._offsetArray.length)
            {
                return ASCompat.toInt(this._offsetArray[_arg_3].x);
            }
            return super.getSpriteXOffset(k, _arg_2, _arg_3);
        }

        override function getSpriteYOffset(k:Int, _arg_2:Int, _arg_3:Int):Int
        {
            if (_arg_3 < this._offsetArray.length)
            {
                return ASCompat.toInt(this._offsetArray[_arg_3].y);
            }
            return super.getSpriteYOffset(k, _arg_2, _arg_3);
        }

        override function getSpriteZOffset(k:Int, _arg_2:Int, _arg_3:Int):Float
        {
            if (_arg_3 < this._offsetArray.length)
            {
                return ASCompat.toNumber(this._offsetArray[_arg_3].z);
            }
            return super.getSpriteZOffset(k, _arg_2, _arg_3);
        }

        function _Str_18684():Bool
        {
            var _local_7:IRoomObjectSprite = null;
            var _local_9:com.sulake.core.utils.xml.XML = null;
            var k= object;
            if (k == null)
            {
                return false;
            }
            var _local_2= k.getModel();
            if (_local_2 == null)
            {
                return false;
            }
            var _local_3= _local_2.getString(RoomObjectVariableEnum.FURNITURE_PLANETSYSTEM_DATA);
            var _local_4= com.sulake.core.utils.xml.XMLList.coerce(_local_3);
            var _local_5= _local_4.children();
            var _local_6= _local_5.length();
            this._planetIndex = new Array<ASAny>();
            this._planetNameIndex = new Array<ASAny>();
            var _local_8 = 0;
            while (_local_8 < _local_6)
            {
                _local_9 = _local_5.at(_local_8);
                _local_7 = getSprite(_local_8);
                if (_local_7 != null)
                {
                    this.addPlanet(_local_9.attribute("name").toString(), _local_8, _local_9.attribute("parent").toString(), ASCompat.toNumber(ASCompat.xmlListToString(_local_9.attribute("radius"))), ASCompat.toNumber(ASCompat.xmlListToString(_local_9.attribute("arcspeed"))), ASCompat.toNumber(ASCompat.xmlListToString(_local_9.attribute("arcoffset"))), ASCompat.toNumber(ASCompat.xmlListToString(_local_9.attribute("height"))));
                }
                _local_8++;
            }
            return true;
        }

        function addPlanet(k:String, _arg_2:Int, _arg_3:String, _arg_4:Float, _arg_5:Float, _arg_6:Float, _arg_7:Float)
        {
            var _local_9:FurniturePlanetSystemVisualizationPlanetObject = null;
            if (this._planetIndex == null)
            {
                return;
            }
            var _local_8= new FurniturePlanetSystemVisualizationPlanetObject(k, _arg_2, _arg_4, _arg_5, _arg_6, _arg_7);
            _local_9 = this.getPlanet(_arg_3);
            if (_local_9 != null)
            {
                _local_9.addChild(_local_8);
            }
            else
            {
                this._planetIndex.push(_local_8);
                this._planetNameIndex.push(k);
            }
        }

        function getPlanet(k:String):FurniturePlanetSystemVisualizationPlanetObject
        {
            var _local_2:FurniturePlanetSystemVisualizationPlanetObject = null;
            var _local_3 = 0;
            while (_local_3 < this._planetIndex.length)
            {
                _local_2 = this._planetIndex[_local_3];
                if (_local_2.name == k)
                {
                    return _local_2;
                }
                if (_local_2.hasChild(k))
                {
                    return _local_2.getChild(k);
                }
                _local_3++;
            }
            return null;
        }
    }

