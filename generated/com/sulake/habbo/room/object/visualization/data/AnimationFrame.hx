package com.sulake.habbo.room.object.visualization.data
;
     class AnimationFrame 
    {
        public static inline final FRAME_REPEAT_FOREVER= -1;
        public static inline final SEQUENCE_NOT_DEFINED= -1;
        static inline final POOL_SIZE_LIMIT= 3000;
        static final POOL:Array<ASAny> = [];

        var _id:Int = 0;
        var _x:Int = 0;
        var _y:Int = 0;
        var _repeats:Int = 1;
        var _frameRepeats:Int = 1;
        var _remainingFrameRepeats:Int = 1;
        var _activeSequence:Int = -1;
        var _activeSequenceOffset:Int = 0;
        var _isLastFrame:Bool = false;
        var _isRecycled:Bool = false;


        public static function _Str_2363(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Int, _arg_5:Int, _arg_6:Bool, _arg_7:Int=-1, _arg_8:Int=0):AnimationFrame
        {
            var _local_9:AnimationFrame = ((POOL.length > 0) ? POOL.pop() : Type.createInstance(AnimationFrame, []));
            _local_9._isRecycled = false;
            _local_9._id = k;
            _local_9._x = _arg_2;
            _local_9._y = _arg_3;
            _local_9._isLastFrame = _arg_6;
            if (_arg_4 < 1)
            {
                _arg_4 = 1;
            }
            _local_9._repeats = _arg_4;
            if (_arg_5 < 0)
            {
                _arg_5 = FRAME_REPEAT_FOREVER;
            }
            _local_9._frameRepeats = _arg_5;
            _local_9._remainingFrameRepeats = _arg_5;
            if (_arg_7 >= 0)
            {
                _local_9._activeSequence = _arg_7;
                _local_9._activeSequenceOffset = _arg_8;
            }
            return _local_9;
        }


        public var id(get,never):Int;
function  get_id():Int
        {
            if (this._id >= 0)
            {
                return this._id;
            }
            return Std.int(-this._id * Math.random());
        }

        public var x(get,never):Int;
function  get_x():Int
        {
            return this._x;
        }

        public var y(get,never):Int;
function  get_y():Int
        {
            return this._y;
        }

        public var repeats(get,never):Int;
function  get_repeats():Int
        {
            return this._repeats;
        }

        public var frameRepeats(get,never):Int;
function  get_frameRepeats():Int
        {
            return this._frameRepeats;
        }

        public var isLastFrame(get,never):Bool;
function  get_isLastFrame():Bool
        {
            return this._isLastFrame;
        }

        
        public var _Str_9508(get,set):Int;
function  get__Str_9508():Int
        {
            if (this._frameRepeats < 0)
            {
                return FRAME_REPEAT_FOREVER;
            }
            return this._remainingFrameRepeats;
        }
function  set__Str_9508(k:Int):Int        {
            if (k < 0)
            {
                k = 0;
            }
            if (((this._frameRepeats > 0) && (k > this._frameRepeats)))
            {
                k = this._frameRepeats;
            }
            return this._remainingFrameRepeats = k;
        }

        public var activeSequence(get,never):Int;
function  get_activeSequence():Int
        {
            return this._activeSequence;
        }

        public var activeSequenceOffset(get,never):Int;
function  get_activeSequenceOffset():Int
        {
            return this._activeSequenceOffset;
        }

        public function recycle()
        {
            if (!this._isRecycled)
            {
                this._isRecycled = true;
                if (POOL.length < POOL_SIZE_LIMIT)
                {
                    POOL.push(this);
                }
            }
        }

	public function new() {}
    }

