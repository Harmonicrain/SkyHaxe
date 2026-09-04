package com.sulake.habbo.room.object
;
    import com.sulake.room.utils.Vector3d;
    import flash.geom.Point;
    import com.sulake.room.utils.IVector3d;

     class RoomWallData 
    {
        public static var WALL_DIRECTION_VECTORS:Array<ASAny> = [];
        public static var WALL_NORMAL_VECTORS:Array<ASAny> = [];

        var _corners:Array<ASAny>;
        var _endPoints:Array<ASAny>;
        var _directions:Array<ASAny>;
        var _lengths:Array<ASAny>;
        var _leftTurns:Array<ASAny>;
        var _borders:Array<ASAny>;
        var _hideWalls:Array<ASAny>;
        var _manuallyLeftCut:Array<ASAny>;
        var _manuallyRightCut:Array<ASAny>;
        var _addDuplicates:Bool = false;
        var _count:Int = 0;

        public function new()
        {
            this._corners = [];
            this._endPoints = [];
            this._directions = [];
            this._lengths = [];
            this._leftTurns = [];
            this._borders = [];
            this._hideWalls = [];
            this._manuallyLeftCut = [];
            this._manuallyRightCut = [];
        }

        public function _Str_17862(k:Point, _arg_2:Int, _arg_3:Int, _arg_4:Bool, _arg_5:Bool)
        {
            if ((this._addDuplicates || this.checkIsNotDuplicate(k, _arg_2, _arg_3, _arg_4, _arg_5)))
            {
                this._corners.push(k);
                this._directions.push(_arg_2);
                this._lengths.push(_arg_3);
                this._borders.push(_arg_4);
                this._leftTurns.push(_arg_5);
                this._hideWalls.push(false);
                this._manuallyLeftCut.push(false);
                this._manuallyRightCut.push(false);
                this._count++;
            }
        }

        function checkIsNotDuplicate(k:Point, _arg_2:Int, _arg_3:Int, _arg_4:Bool, _arg_5:Bool):Bool
        {
            var _local_6 = 0;
            while (_local_6 < this._count)
            {
                if (((((((this._corners[_local_6].x == k.x) && (this._corners[_local_6].y == k.y)) && (this._directions[_local_6] == _arg_2)) && (this._lengths[_local_6] == _arg_3)) && (this._borders[_local_6] == _arg_4)) && (this._leftTurns[_local_6] == _arg_5)))
                {
                    return false;
                }
                _local_6++;
            }
            return true;
        }

        public var count(get,never):Int;
function  get_count():Int
        {
            return this._count;
        }

        public function getCorner(k:Int):Point
        {
            return this._corners[k];
        }

        public function getEndPoint(k:Int):Point
        {
            this.calculateWallEndPoints();
            return this._endPoints[k];
        }

        public function getLength(k:Int):Int
        {
            return ASCompat.toInt(this._lengths[k]);
        }

        public function getDirection(k:Int):Int
        {
            return ASCompat.toInt(this._directions[k]);
        }

        public function getBorder(k:Int):Bool
        {
            return this._borders[k];
        }

        public function getHideWall(k:Int):Bool
        {
            return this._hideWalls[k];
        }

        public function getLeftTurn(k:Int):Bool
        {
            return this._leftTurns[k];
        }

        public function getManuallyLeftCut(k:Int):Bool
        {
            return this._manuallyLeftCut[k];
        }

        public function getManuallyRightCut(k:Int):Bool
        {
            return this._manuallyRightCut[k];
        }

        public function setHideWall(k:Int, _arg_2:Bool)
        {
            this._hideWalls[k] = _arg_2;
        }

        public function setLength(k:Int, _arg_2:Int)
        {
            if (_arg_2 < this._lengths[k])
            {
                this._lengths[k] = _arg_2;
                this._manuallyRightCut[k] = true;
            }
        }

        public function moveCorner(k:Int, _arg_2:Int)
        {
            var _local_3:IVector3d;
            if (((_arg_2 > 0) && (_arg_2 < this._lengths[k])))
            {
                _local_3 = WALL_DIRECTION_VECTORS[this.getDirection(k)];
                this._corners[k] = this._corners[k].add(new Point((_arg_2 * _local_3.x), (_arg_2 * _local_3.y)));
                this._lengths[k] = (ASCompat.toNumber(this._lengths[k]) - _arg_2);
                this._manuallyLeftCut[k] = true;
            }
        }

        function calculateWallEndPoints()
        {
            var k:Int;
            var _local_2:Point;
            var _local_3:Point;
            var _local_4:IVector3d;
            var _local_5:Int;
            if (this._endPoints.length != this.count)
            {
                this._endPoints = [];
                k = 0;
                while (k < this.count)
                {
                    _local_2 = this.getCorner(k);
                    _local_3 = new Point(_local_2.x, _local_2.y);
                    _local_4 = RoomWallData.WALL_DIRECTION_VECTORS[this.getDirection(k)];
                    _local_5 = this.getLength(k);
                    _local_3.x = (_local_3.x + (_local_4.x * _local_5));
                    _local_3.y = (_local_3.y + (_local_4.y * _local_5));
                    this._endPoints.push(_local_3);
                    k++;
                }
            }
        }

	static final ___init = {

        {
            WALL_DIRECTION_VECTORS.push(new Vector3d(1, 0, 0));
            WALL_DIRECTION_VECTORS.push(new Vector3d(0, 1, 0));
            WALL_DIRECTION_VECTORS.push(new Vector3d(-1, 0, 0));
            WALL_DIRECTION_VECTORS.push(new Vector3d(0, -1, 0));
            WALL_NORMAL_VECTORS.push(new Vector3d(0, 1, 0));
            WALL_NORMAL_VECTORS.push(new Vector3d(-1, 0, 0));
            WALL_NORMAL_VECTORS.push(new Vector3d(0, -1, 0));
            WALL_NORMAL_VECTORS.push(new Vector3d(1, 0, 0));
        }

	null;
	};
    }

