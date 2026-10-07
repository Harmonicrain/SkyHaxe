package com.sulake.habbo.room.object.visualization.furniture
;
    import com.sulake.room.object.visualization.IRoomObjectSprite;
    import flash.geom.Point;

     class FurniturePartyBeamerVisualization extends FurnitureAnimatedVisualization 
    {
        static inline final UPDATE_INTERVAL= 2;
        static inline final AREA_DIAMETER_SMALL= 15;
        static inline final AREA_DIAMETER_LARGE= 31;
        static inline final ANIM_SPEED_FAST= 2;
        static inline final ANIM_SPEED_SLOW= 1;

        var _animPhaseIndex:Array<ASAny>;
        var _animDirectionIndex:Array<ASAny>;
        var _animSpeedIndex:Array<ASAny>;
        var _animFactorIndex:Array<ASAny>;
        var _animOffsetIndex:Array<ASAny>;

        public function new()
        {
            this._animOffsetIndex = new Array<ASAny>();
            super();
        }

        override function updateAnimation(k:Float):Int
        {
            var _local_2:IRoomObjectSprite = null;
            var _local_3:Point = null;
            if (this._animSpeedIndex == null)
            {
                this.initItems(k);
            }
            _local_2 = getSprite(2);
            if (_local_2 != null)
            {
                this._animOffsetIndex[0] = this.getNewPoint(k, 0);
            }
            _local_2 = getSprite(3);
            if (_local_2 != null)
            {
                this._animOffsetIndex[1] = this.getNewPoint(k, 1);
            }
            return super.updateAnimation(k);
        }

        override function getSpriteXOffset(k:Int, _arg_2:Int, _arg_3:Int):Int
        {
            if (((_arg_3 == 2) || (_arg_3 == 3)))
            {
                if (this._animOffsetIndex.length == 2)
                {
                    return ASCompat.toInt(this._animOffsetIndex[(_arg_3 - 2)].x);
                }
            }
            return super.getSpriteXOffset(k, _arg_2, _arg_3);
        }

        override function getSpriteYOffset(k:Int, _arg_2:Int, _arg_3:Int):Int
        {
            if (((_arg_3 == 2) || (_arg_3 == 3)))
            {
                if (this._animOffsetIndex.length == 2)
                {
                    return ASCompat.toInt(this._animOffsetIndex[(_arg_3 - 2)].y);
                }
            }
            return super.getSpriteYOffset(k, _arg_2, _arg_3);
        }

        function getNewPoint(k:Float, _arg_2:Int):Point
        {
            var _local_8 = 0;
            var _local_3= ASCompat.toNumber(this._animPhaseIndex[_arg_2]);
            var _local_4= ASCompat.toInt(this._animDirectionIndex[_arg_2]);
            var _local_5= ASCompat.toInt(this._animSpeedIndex[_arg_2]);
            var _local_6= ASCompat.toNumber(this._animFactorIndex[_arg_2]);
            var _local_7:Float = 1;
            if (k == 32)
            {
                _local_8 = AREA_DIAMETER_SMALL;
                _local_7 = 0.5;
            }
            else
            {
                _local_8 = AREA_DIAMETER_LARGE;
            }
            var _local_9= (_local_3 + (_local_4 * _local_5));
            if (Math.abs(_local_9) >= _local_8)
            {
                if (_local_4 > 0)
                {
                    _local_3 = (_local_3 - (_local_9 - _local_8));
                }
                else
                {
                    _local_3 = (_local_3 + (-_local_8 - _local_9));
                }
                _local_4 = -_local_4;
                this._animDirectionIndex[_arg_2] = _local_4;
            }
            var _local_10= ((_local_8 - Math.abs(_local_3)) * _local_6);
            var _local_11= ((_local_4 * Math.sin(Math.abs((_local_3 / 4)))) * _local_10);
            if (_local_4 > 0)
            {
                _local_11 = (_local_11 - _local_10);
            }
            else
            {
                _local_11 = (_local_11 + _local_10);
            }
            _local_3 = (_local_3 + ((_local_4 * _local_5) * _local_7));
            this._animPhaseIndex[_arg_2] = _local_3;
            if (Std.int(_local_11) == 0)
            {
                this._animFactorIndex[_arg_2] = this.getRandomAmplitudeFactor();
            }
            return new Point(_local_3, _local_11);
        }

        function initItems(k:Float)
        {
            var _local_2 = 0;
            if (k == 32)
            {
                _local_2 = AREA_DIAMETER_SMALL;
            }
            else
            {
                _local_2 = AREA_DIAMETER_LARGE;
            }
            this._animPhaseIndex = new Array<ASAny>();
            this._animPhaseIndex.push(((Math.random() * _local_2) * 1.5));
            this._animPhaseIndex.push(((Math.random() * _local_2) * 1.5));
            this._animDirectionIndex = new Array<ASAny>();
            this._animDirectionIndex.push(1);
            this._animDirectionIndex.push(-1);
            this._animSpeedIndex = new Array<ASAny>();
            this._animSpeedIndex.push(ANIM_SPEED_FAST);
            this._animSpeedIndex.push(ANIM_SPEED_SLOW);
            this._animFactorIndex = new Array<ASAny>();
            this._animFactorIndex.push(this.getRandomAmplitudeFactor());
            this._animFactorIndex.push(this.getRandomAmplitudeFactor());
        }

        function getRandomAmplitudeFactor():Float
        {
            return ((Math.random() * 30) / 100) + 0.15;
        }
    }

