package com.sulake.habbo.room.object.visualization.data
;
     class AnimationFrameSequenceData 
    {
        var _frames:Array<ASAny>;
        var _frameIndexes:Array<ASAny>;
        var _frameRepeats:Array<ASAny>;
        var _isRandom:Bool = false;
        var _loopCount:Int = 1;

        public function new(k:Int, _arg_2:Bool)
        {
            this._frames = [];
            this._frameIndexes = [];
            this._frameRepeats = [];
            if (k < 1)
            {
                k = 1;
            }
            this._loopCount = k;
            this._isRandom = _arg_2;
        }

        public var isRandom(get,never):Bool;
public function  get_isRandom():Bool
        {
            return this._isRandom;
        }

        public var _Str_2185(get,never):Int;
public function  get__Str_2185():Int
        {
            return this._frameIndexes.length * this._loopCount;
        }

        public function dispose()
        {
            this._frames = [];
        }

        public function initialize()
        {
            var k= 1;
            var _local_2= -1;
            var _local_3= (this._frameIndexes.length - 1);
            while (_local_3 >= 0)
            {
                if (this._frameIndexes[_local_3] == _local_2)
                {
                    k++;
                }
                else
                {
                    _local_2 = ASCompat.toInt(this._frameIndexes[_local_3]);
                    k = 1;
                }
                this._frameRepeats[_local_3] = k;
                _local_3--;
            }
        }

        public function addFrame(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Int, _arg_5:Int, _arg_6:DirectionalOffsetData)
        {
            var _local_7:AnimationFrameData = null;
            var _local_8= 1;
            if (this._frames.length > 0)
            {
                _local_7 = this._frames[(this._frames.length - 1)];
                if (((((((((_local_7.id == k) && (!_local_7.hasDirectionalOffsets())) && (_local_7.x == _arg_2)) && (_local_7.y == _arg_3)) && (_local_7.randomX == _arg_4)) && (_arg_4 == 0)) && (_local_7.randomY == _arg_5)) && (_arg_5 == 0)))
                {
                    _local_8 = (_local_8 + _local_7.repeats);
                    this._frames.pop();
                }
            }
            var _local_9:AnimationFrameData = null;
            if (_arg_6 == null)
            {
                _local_9 = new AnimationFrameData(k, _arg_2, _arg_3, _arg_4, _arg_5, _local_8);
            }
            else
            {
                _local_9 = new AnimationFrameDirectionalData(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _local_8);
            }
            this._frames.push(_local_9);
            this._frameIndexes.push((this._frames.length - 1));
            this._frameRepeats.push(1);
        }

        public function getFrame(k:Int):AnimationFrameData
        {
            if ((((this._frames.length == 0) || (k < 0)) || (k >= this._Str_2185)))
            {
                return null;
            }
            k = ASCompat.toInt(this._frameIndexes[(k % this._frameIndexes.length)]);
            return ASCompat.dynamicAs(this._frames[k] , AnimationFrameData);
        }

        public function _Str_1674(k:Int):Int
        {
            if (((k < 0) || (k >= this._Str_2185)))
            {
                return -1;
            }
            if (this._isRandom)
            {
                k = Std.int((Math.random() * this._frameIndexes.length));
                if (k == this._frameIndexes.length)
                {
                    k--;
                }
            }
            return k;
        }

        public function getRepeats(k:Int):Int
        {
            if (((k < 0) || (k >= this._Str_2185)))
            {
                return 0;
            }
            return ASCompat.toInt(this._frameRepeats[(k % this._frameRepeats.length)]);
        }
    }

