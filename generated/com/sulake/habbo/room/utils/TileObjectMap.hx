package com.sulake.habbo.room.utils
;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;

     class TileObjectMap 
    {
        var _tileObjectMap:Vector<Vector<IRoomObject>>;
        var _width:Int = 0;
        var _height:Int = 0;

        public function new(k:Int, _arg_2:Int)
        {
            this._tileObjectMap = new Vector<Vector<IRoomObject>>(_arg_2, true);
            var _local_3 = 0;
            while (_local_3 < _arg_2)
            {
                this._tileObjectMap[_local_3] = new Vector<IRoomObject>(k, true);
                _local_3++;
            }
            this._width = k;
            this._height = _arg_2;
        }

        public function clear()
        {
            var k:Vector<IRoomObject>;
            var _local_2:Int;
            for (_tmp_ in this._tileObjectMap)
            {
k  = _tmp_;
                _local_2 = 0;
                while (_local_2 < this._width)
                {
                    k[_local_2] = null;
                    _local_2++;
                }
            }
        }

        public function populate(k:Array<ASAny>)
        {
            var _local_2:IRoomObject;
            this.clear();
            for (_tmp_ in k)
            {
_local_2  = _tmp_;
                this.addRoomObject(_local_2);
            }
        }

        public function dispose()
        {
            this._tileObjectMap = null;
            this._width = 0;
            this._height = 0;
        }

        public function getObjectInTile(k:Int, _arg_2:Int):IRoomObject
        {
            if (((((k >= 0) && (k < this._width)) && (_arg_2 >= 0)) && (_arg_2 < this._height)))
            {
                return this._tileObjectMap[_arg_2][k];
            }
            return null;
        }

        public function setObjectInTile(k:Int, _arg_2:Int, _arg_3:IRoomObject)
        {
            if (!_arg_3.isInitialized())
            {
                Logger.log(["Assigning non initialized object to tile object map!"]);
                return;
            }
            if (((((k >= 0) && (k < this._width)) && (_arg_2 >= 0)) && (_arg_2 < this._height)))
            {
                this._tileObjectMap[_arg_2][k] = _arg_3;
            }
        }

        public function addRoomObject(k:IRoomObject)
        {
            var _local_8:IRoomObject;
            var _local_10:Int;
            if ((((k == null) || (k.getModel() == null)) || (!k.isInitialized())))
            {
                return;
            }
            var _local_2= k.getLocation();
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= k.getDirection();
            if (_local_3 == null)
            {
                return;
            }
            var _local_4= Std.int(k.getModel().getNumber(RoomObjectVariableEnum.FURNITURE_SIZE_X));
            var _local_5= Std.int(k.getModel().getNumber(RoomObjectVariableEnum.FURNITURE_SIZE_Y));
            if (_local_4 < 1)
            {
                _local_4 = 1;
            }
            if (_local_5 < 1)
            {
                _local_5 = 1;
            }
            var _local_6:Int;
            var _local_7= Std.int((Std.int((_local_3.x + 45)) % 360) / 90);
            if (((_local_7 == 1) || (_local_7 == 3)))
            {
                _local_6 = _local_4;
                _local_4 = _local_5;
                _local_5 = _local_6;
            }
            var _local_9= Std.int(_local_2.y);
            while (_local_9 < (_local_2.y + _local_5))
            {
                _local_10 = Std.int(_local_2.x);
                while (_local_10 < (_local_2.x + _local_4))
                {
                    _local_8 = this.getObjectInTile(_local_10, _local_9);
                    if (((!(_local_8 != null)) || ((!(_local_8 == k)) && (_local_8.getLocation().z <= _local_2.z))))
                    {
                        this.setObjectInTile(_local_10, _local_9, k);
                    }
                    _local_10++;
                }
                _local_9++;
            }
        }

        public function toString():String
        {
            var _local_2:IRoomObject;
            var _local_4:Int;
            var k= "";
            var _local_3 = 0;
            while (_local_3 < this._height)
            {
                _local_4 = 0;
                while (_local_4 < this._width)
                {
                    _local_2 = this._tileObjectMap[_local_3][_local_4];
                    k = (k + (((_local_2 != null) ? Std.string(_local_2.getId()) : "x") + "\t"));
                    _local_4++;
                }
                k = (k + "\n");
                _local_3++;
            }
            return k;
        }
    }

