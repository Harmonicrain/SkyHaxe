package com.sulake.habbo.room.utils
;

     class FurniStackingHeightMap 
    {
        var _heightMap:Vector<Float>;
        var _isNotStackable:Vector<Bool>;
        var _isRoomTile:Vector<Bool>;
        var _width:Int = 0;
        var _height:Int = 0;

        public function new(k:Int, _arg_2:Int)
        {
            this._width = k;
            this._height = _arg_2;
            this._heightMap = new Vector<Float>((k * _arg_2));
            this._isNotStackable = new Vector<Bool>((k * _arg_2));
            this._isRoomTile = new Vector<Bool>((k * _arg_2));
        }

        public var width(get,never):Int;
function  get_width():Int
        {
            return this._width;
        }

        public var height(get,never):Int;
function  get_height():Int
        {
            return this._height;
        }

        public function dispose()
        {
            this._heightMap = null;
            this._isNotStackable = null;
            this._isRoomTile = null;
            this._width = 0;
            this._height = 0;
        }

        function validPosition(k:Int, _arg_2:Int):Bool
        {
            return (((k >= 0) && (k < this._width)) && (_arg_2 >= 0)) && (_arg_2 < this._height);
        }

        public function getTileHeight(k:Int, _arg_2:Int):Float
        {
            return this.validPosition(k, _arg_2) ? this._heightMap[((_arg_2 * this._width) + k)] : 0;
        }

        public function _Str_3982(k:Int, _arg_2:Int, _arg_3:Float)
        {
            if (this.validPosition(k, _arg_2))
            {
                this._heightMap[((_arg_2 * this._width) + k)] = _arg_3;
            }
        }

        public function setStackingBlocked(k:Int, _arg_2:Int, _arg_3:Bool)
        {
            if (this.validPosition(k, _arg_2))
            {
                this._isNotStackable[((_arg_2 * this._width) + k)] = _arg_3;
            }
        }

        public function setIsRoomTile(k:Int, _arg_2:Int, _arg_3:Bool)
        {
            if (this.validPosition(k, _arg_2))
            {
                this._isRoomTile[((_arg_2 * this._width) + k)] = _arg_3;
            }
        }

        public function validateLocation(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Int, _arg_5:Int, _arg_6:Int, _arg_7:Int, _arg_8:Int, _arg_9:Bool, _arg_10:Float=-1):Bool
        {
            var _local_12:Int;
            var _local_13:Int;
            if (((!this.validPosition(k, _arg_2)) || (!this.validPosition(((k + _arg_3) - 1), ((_arg_2 + _arg_4) - 1)))))
            {
                return false;
            }
            if (((_arg_5 < 0) || (_arg_5 >= this._width)))
            {
                _arg_5 = 0;
            }
            if (((_arg_6 < 0) || (_arg_6 >= this._height)))
            {
                _arg_6 = 0;
            }
            _arg_7 = Std.int(Math.min(_arg_7, (this._width - _arg_5)));
            _arg_8 = Std.int(Math.min(_arg_8, (this._height - _arg_6)));
            if (_arg_10 == -1)
            {
                _arg_10 = this.getTileHeight(k, _arg_2);
            }
            var _local_11= _arg_2;
            while (_local_11 < (_arg_2 + _arg_4))
            {
                _local_12 = k;
                while (_local_12 < (k + _arg_3))
                {
                    if (((((_local_12 < _arg_5) || (_local_12 >= (_arg_5 + _arg_7))) || (_local_11 < _arg_6)) || (_local_11 >= (_arg_6 + _arg_8))))
                    {
                        _local_13 = ((_local_11 * this._width) + _local_12);
                        if (_arg_9)
                        {
                            if (!this._isRoomTile[_local_13])
                            {
                                return false;
                            }
                        }
                        else
                        {
                            if (((this._isNotStackable[_local_13] || (!this._isRoomTile[_local_13])) || (Math.abs((this._heightMap[_local_13] - _arg_10)) > 0.01)))
                            {
                                return false;
                            }
                        }
                    }
                    _local_12++;
                }
                _local_11++;
            }
            return true;
        }
    }

