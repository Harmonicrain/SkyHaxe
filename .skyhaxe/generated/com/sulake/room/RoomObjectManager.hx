package com.sulake.room
;
    import com.sulake.core.utils.Map;
    import com.sulake.room.object.RoomObject;
    import com.sulake.room.object.IRoomObjectController;

     class RoomObjectManager implements IRoomObjectManager 
    {
        var _objects:Map;
        var _objectsPerType:Map;

        public function new()
        {
            this._objects = new Map();
            this._objectsPerType = new Map();
        }

        public function dispose()
        {
            this.reset();
            if (this._objects != null)
            {
                this._objects.dispose();
                this._objects = null;
            }
            if (this._objectsPerType != null)
            {
                this._objectsPerType.dispose();
                this._objectsPerType = null;
            }
        }

        public function createObject(k:Int, _arg_2:UInt, _arg_3:String):IRoomObjectController
        {
            var _local_4= new RoomObject(k, ASCompat.toInt(_arg_2), _arg_3);
            return this.addObject(Std.string(k), _arg_3, _local_4);
        }

        function addObject(k:String, _arg_2:String, _arg_3:IRoomObjectController):IRoomObjectController
        {
            if (this._objects.getValue(k) != null)
            {
                _arg_3.dispose();
                return null;
            }
            this._objects.add(k, _arg_3);
            var _local_4= this.getObjectsForType(_arg_2);
            _local_4.add(k, _arg_3);
            return _arg_3;
        }

        function getObjectsForType(k:String, _arg_2:Bool=true):Map
        {
            var _local_3:Map = this._objectsPerType.getValue(k);
            if (((_local_3 == null) && _arg_2))
            {
                _local_3 = new Map();
                this._objectsPerType.add(k, _local_3);
            }
            return _local_3;
        }

        public function getObject(k:Int):IRoomObjectController
        {
            var _local_2= ASCompat.dynamicAs(this._objects.getValue(Std.string(k)) , IRoomObjectController);
            return _local_2;
        }

        public function getObjects():Array<ASAny>
        {
            return this._objects.getValues();
        }

        public function getObjectWithIndex(k:Int):IRoomObjectController
        {
            var _local_2= ASCompat.dynamicAs(this._objects.getWithIndex(k) , IRoomObjectController);
            return _local_2;
        }

        public function getObjectCount():Int
        {
            return ASCompat.toInt(this._objects.length);
        }

        public function getObjectCountForType(k:String):Int
        {
            var _local_2= this.getObjectsForType(k, false);
            if (_local_2 != null)
            {
                return ASCompat.toInt(_local_2.length);
            }
            return 0;
        }

        public function getObjectWithIndexAndType(k:Int, _arg_2:String):IRoomObjectController
        {
            var _local_4:IRoomObjectController = null;
            var _local_3= this.getObjectsForType(_arg_2, false);
            if (_local_3 != null)
            {
                _local_4 = ASCompat.dynamicAs(_local_3.getWithIndex(k) , IRoomObjectController);
                return _local_4;
            }
            return null;
        }

        public function disposeObject(k:Int):Bool
        {
            var _local_4:String = null;
            var _local_5:Map = null;
            var _local_2= Std.string(k);
            var _local_3= ASCompat.dynamicAs(this._objects.remove(_local_2) , RoomObject);
            if (_local_3 != null)
            {
                _local_4 = _local_3.getType();
                _local_5 = this.getObjectsForType(_local_4, false);
                if (_local_5 != null)
                {
                    _local_5.remove(_local_2);
                }
                _local_3.dispose();
                return true;
            }
            return false;
        }

        public function reset()
        {
            var k = 0;
            var _local_2:IRoomObjectController = null;
            var _local_3 = 0;
            var _local_4:Map = null;
            if (this._objects != null)
            {
                k = 0;
                while ((k : UInt) < this._objects.length)
                {
                    _local_2 = ASCompat.dynamicAs(this._objects.getWithIndex(k) , IRoomObjectController);
                    if (_local_2 != null)
                    {
                        _local_2.dispose();
                    }
                    k++;
                }
                this._objects.reset();
            }
            if (this._objectsPerType != null)
            {
                _local_3 = 0;
                while ((_local_3 : UInt) < this._objectsPerType.length)
                {
                    _local_4 = ASCompat.dynamicAs(this._objectsPerType.getWithIndex(_local_3) , Map);
                    if (_local_4 != null)
                    {
                        _local_4.dispose();
                    }
                    _local_3++;
                }
                this._objectsPerType.reset();
            }
        }
    }

