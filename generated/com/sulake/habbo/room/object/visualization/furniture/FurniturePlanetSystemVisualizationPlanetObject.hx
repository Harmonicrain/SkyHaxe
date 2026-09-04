package com.sulake.habbo.room.object.visualization.furniture
;
    import com.sulake.room.utils.Vector3d;

     class FurniturePlanetSystemVisualizationPlanetObject 
    {
        static inline final SYSTEM_TEMPO:Float = 30;

        var _index:Int = 0;
        var _name:String;
        var _radius:Float = Math.NaN;
        var _arcSpeed:Float = Math.NaN;
        var _arcOffset:Float = Math.NaN;
        var _height:Float = Math.NaN;
        var _position:Float = Math.NaN;
        var _positionVector:Vector3d;
        var _children:Array<ASAny>;

        public function new(k:String, _arg_2:Int, _arg_3:Float, _arg_4:Float, _arg_5:Float, _arg_6:Float)
        {
            this._positionVector = new Vector3d(0, 0, 0);
            this._children = new Array<ASAny>();
            this._name = k;
            this._index = _arg_2;
            this._radius = _arg_3;
            this._arcSpeed = (((_arg_4 * Math.PI) * 2) / 360);
            this._arcOffset = (((_arg_5 * Math.PI) * 2) / 360);
            this._height = _arg_6;
            this._position = 0;
        }

        public var name(get,never):String;
function  get_name():String
        {
            return this._name;
        }

        public function dispose()
        {
            var k:FurniturePlanetSystemVisualizationPlanetObject;
            while (this._children.length > 0)
            {
                k = this._children.shift();
                if (k != null)
                {
                    k.dispose();
                }
            }
        }

        public function update(k:Array<ASAny>, _arg_2:Vector3d, _arg_3:Float)
        {
            var _local_4:FurniturePlanetSystemVisualizationPlanetObject;
            this._position = (this._position + (this._arcSpeed / SYSTEM_TEMPO));
            k[this._index] = this.getPositionVector(_arg_2, _arg_3);
            var _local_5 = 0;
            while (_local_5 < this._children.length)
            {
                _local_4 = this._children[_local_5];
                _local_4.update(k, this._positionVector, _arg_3);
                _local_5++;
            }
        }

        public function getPositionVector(k:Vector3d, _arg_2:Float):Vector3d
        {
            var _local_3= (this._radius * Math.cos((this._position + this._arcOffset)));
            var _local_4= (this._radius * Math.sin((this._position + this._arcOffset)));
            var _local_5= this._height;
            this._positionVector.x = ((_local_3 - _local_4) * (_arg_2 / 2));
            this._positionVector.y = ((((_local_4 + _local_3) * (_arg_2 / 2)) * 0.5) - (this._height * (_arg_2 / 2)));
            this._positionVector.z = -Std.int(((4 * (_local_3 + _local_4)) - 0.7));
            if (k != null)
            {
                this._positionVector.add(k);
            }
            return this._positionVector;
        }

        public function addChild(k:FurniturePlanetSystemVisualizationPlanetObject)
        {
            if (this._children.indexOf(k) < 0)
            {
                this._children.push(k);
            }
        }

        public function hasChild(k:String):Bool
        {
            var _local_2:FurniturePlanetSystemVisualizationPlanetObject;
            var _local_3 = 0;
            while (_local_3 < this._children.length)
            {
                _local_2 = this._children[_local_3];
                if (_local_2.name == k)
                {
                    return true;
                }
                if (_local_2.hasChild(k))
                {
                    return true;
                }
                _local_3++;
            }
            return false;
        }

        public function getChild(k:String):FurniturePlanetSystemVisualizationPlanetObject
        {
            var _local_2:FurniturePlanetSystemVisualizationPlanetObject;
            var _local_3 = 0;
            while (_local_3 < this._children.length)
            {
                _local_2 = this._children[_local_3];
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

