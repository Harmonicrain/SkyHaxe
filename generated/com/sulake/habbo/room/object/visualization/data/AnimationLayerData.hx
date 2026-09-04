package com.sulake.habbo.room.object.visualization.data
;
     class AnimationLayerData 
    {
        var _frameSequences:Array<ASAny>;
        var _frameCount:Int = -1;
        var _loopCount:Int = 1;
        var _frameRepeat:Int = 1;
        var _isRandom:Bool = false;

        public function new(k:Int, _arg_2:Int, _arg_3:Bool)
        {
            this._frameSequences = [];
            if (k < 0)
            {
                k = 0;
            }
            if (_arg_2 < 1)
            {
                _arg_2 = 1;
            }
            this._loopCount = k;
            this._frameRepeat = _arg_2;
            this._isRandom = _arg_3;
        }

        public var _Str_2185(get,never):Int;
function  get__Str_2185():Int
        {
            if (this._frameCount < 0)
            {
                this.calculateLength();
            }
            return this._frameCount;
        }

        public function dispose()
        {
            var _local_2:AnimationFrameSequenceData;
            var k = 0;
            while (k < this._frameSequences.length)
            {
                _local_2 = ASCompat.dynamicAs(this._frameSequences[k] , AnimationFrameSequenceData);
                if (_local_2 != null)
                {
                    _local_2.dispose();
                }
                k++;
            }
            this._frameSequences = [];
        }

        public function addFrameSequence(k:Int, _arg_2:Bool):AnimationFrameSequenceData
        {
            var _local_3= new AnimationFrameSequenceData(k, _arg_2);
            this._frameSequences.push(_local_3);
            return _local_3;
        }

        public function calculateLength()
        {
            var _local_2:AnimationFrameSequenceData;
            this._frameCount = 0;
            var k = 0;
            while (k < this._frameSequences.length)
            {
                _local_2 = ASCompat.dynamicAs(this._frameSequences[k] , AnimationFrameSequenceData);
                if (_local_2 != null)
                {
                    this._frameCount = (this._frameCount + _local_2._Str_2185);
                }
                k++;
            }
        }

        public function getFrame(k:Int, _arg_2:Int):AnimationFrame
        {
            var _local_6:Int;
            var _local_7:Int;
            if (this._frameCount < 1)
            {
                return null;
            }
            var _local_3:AnimationFrameSequenceData = null;
            _arg_2 = Std.int(_arg_2 / this._frameRepeat);
            var _local_4 = false;
            var _local_5:Int;
            if (!this._isRandom)
            {
                _local_6 = Std.int(_arg_2 / this._frameCount);
                _arg_2 = (_arg_2 % this._frameCount);
                if ((((this._loopCount > 0) && (_local_6 >= this._loopCount)) || ((this._loopCount <= 0) && (this._frameCount == 1))))
                {
                    _arg_2 = (this._frameCount - 1);
                    _local_4 = true;
                }
                _local_7 = 0;
                _local_5 = 0;
                while (_local_5 < this._frameSequences.length)
                {
                    _local_3 = ASCompat.dynamicAs(this._frameSequences[_local_5] , AnimationFrameSequenceData);
                    if (_local_3 != null)
                    {
                        if (_arg_2 < (_local_7 + _local_3._Str_2185))
                        {
                            break;
                        }
                        _local_7 = (_local_7 + _local_3._Str_2185);
                    }
                    _local_5++;
                }
                return this.getFrameFromSpecificSequence(k, _local_3, _local_5, (_arg_2 - _local_7), _local_4);
            }
            _local_5 = Std.int((this._frameSequences.length * Math.random()));
            _local_3 = ASCompat.dynamicAs(this._frameSequences[_local_5] , AnimationFrameSequenceData);
            if (_local_3._Str_2185 < 1)
            {
                return null;
            }
            _arg_2 = 0;
            return this.getFrameFromSpecificSequence(k, _local_3, _local_5, _arg_2, false);
        }

        public function _Str_7945(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Int):AnimationFrame
        {
            if (((_arg_2 < 0) || (_arg_2 >= this._frameSequences.length)))
            {
                return null;
            }
            var _local_5= ASCompat.dynamicAs(this._frameSequences[_arg_2] , AnimationFrameSequenceData);
            if (_local_5 != null)
            {
                if (_arg_3 >= _local_5._Str_2185)
                {
                    return this.getFrame(k, _arg_4);
                }
                return this.getFrameFromSpecificSequence(k, _local_5, _arg_2, _arg_3, false);
            }
            return null;
        }

        function getFrameFromSpecificSequence(k:Int, _arg_2:AnimationFrameSequenceData, _arg_3:Int, _arg_4:Int, _arg_5:Bool):AnimationFrame
        {
            var _local_6:Int;
            var _local_7:AnimationFrameData;
            var _local_8:Int;
            var _local_9:Int;
            var _local_10:Int;
            var _local_11:Int;
            var _local_12:Int;
            var _local_13:Int;
            var _local_14:Bool;
            var _local_15:AnimationFrame;
            if (_arg_2 != null)
            {
                _local_6 = _arg_2._Str_1674(_arg_4);
                _local_7 = _arg_2.getFrame(_local_6);
                if (_local_7 == null)
                {
                    return null;
                }
                _local_8 = _local_7.getX(k);
                _local_9 = _local_7.getY(k);
                _local_10 = _local_7.randomX;
                _local_11 = _local_7.randomY;
                if (_local_10 != 0)
                {
                    _local_8 = Std.int((_local_8 + (_local_10 * Math.random())));
                }
                if (_local_11 != 0)
                {
                    _local_9 = Std.int((_local_9 + (_local_11 * Math.random())));
                }
                _local_12 = _local_7.repeats;
                if (_local_12 > 1)
                {
                    _local_12 = _arg_2.getRepeats(_local_6);
                }
                _local_13 = (this._frameRepeat * _local_12);
                if (_arg_5)
                {
                    _local_13 = AnimationFrame.FRAME_REPEAT_FOREVER;
                }
                _local_14 = false;
                if (((!this._isRandom) && (!_arg_2.isRandom)))
                {
                    if (((_arg_3 == (this._frameSequences.length - 1)) && (_arg_4 == (_arg_2._Str_2185 - 1))))
                    {
                        _local_14 = true;
                    }
                }
                _local_15 = AnimationFrame._Str_2363(_local_7.id, _local_8, _local_9, _local_12, _local_13, _local_14, _arg_3, _arg_4);
                return _local_15;
            }
            return null;
        }
    }

