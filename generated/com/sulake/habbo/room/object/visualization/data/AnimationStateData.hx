package com.sulake.habbo.room.object.visualization.data
;
     class AnimationStateData 
    {
        var _animationId:Int = -1;
        var _animationAfterTransitionId:Int = 0;
        var _animationOver:Bool = false;
        var _frameCounter:Int = 0;
        var _frames:Array<ASAny>;
        var _lastFramePlayed:Array<ASAny>;
        var _animationPlayed:Array<ASAny>;
        var _layerCount:Int = 0;

        public function new()
        {
            this._frames = [];
            this._lastFramePlayed = [];
            this._animationPlayed = [];
        }

        
        public var _Str_5293(get,set):Bool;
function  get__Str_5293():Bool
        {
            return this._animationOver;
        }
function  set__Str_5293(k:Bool):Bool        {
            return this._animationOver = k;
        }

        
        public var _Str_16814(get,set):Int;
function  get__Str_16814():Int
        {
            return this._frameCounter;
        }
function  set__Str_16814(k:Int):Int        {
            return this._frameCounter = k;
        }

        
        public var animationId(get,set):Int;
function  get_animationId():Int
        {
            return this._animationId;
        }
function  set_animationId(k:Int):Int        {
            if (k != this._animationId)
            {
                this._animationId = k;
                this.resetAnimationFrames(false);
            }
return k;
        }

        
        public var _Str_5355(get,set):Int;
function  get__Str_5355():Int
        {
            return this._animationAfterTransitionId;
        }
function  set__Str_5355(k:Int):Int        {
            return this._animationAfterTransitionId = k;
        }

        public function dispose()
        {
            this.recycleFrames();
            this._frames = null;
            this._lastFramePlayed = null;
            this._animationPlayed = null;
        }

        public function setLayerCount(k:Int)
        {
            this._layerCount = k;
            this.resetAnimationFrames();
        }

        public function resetAnimationFrames(k:Bool=true)
        {
            var _local_3:AnimationFrame;
            if ((k || (this._frames == null)))
            {
                this.recycleFrames();
                this._frames = [];
            }
            this._lastFramePlayed = [];
            this._animationPlayed = [];
            this._animationOver = false;
            this._frameCounter = 0;
            var _local_2 = 0;
            while (_local_2 < this._layerCount)
            {
                if ((k || (this._frames.length <= _local_2)))
                {
                    this._frames[_local_2] = null;
                }
                else
                {
                    _local_3 = this._frames[_local_2];
                    if (_local_3 != null)
                    {
                        _local_3.recycle();
                        this._frames[_local_2] = AnimationFrame._Str_2363(_local_3.id, _local_3.x, _local_3.y, _local_3.repeats, 0, _local_3.isLastFrame);
                    }
                }
                this._lastFramePlayed[_local_2] = false;
                this._animationPlayed[_local_2] = false;
                _local_2++;
            }
        }

        function recycleFrames()
        {
            var k:AnimationFrame;
            if (this._frames != null)
            {
                for (_tmp_ in this._frames)
                {
k  = _tmp_;
                    if (k != null)
                    {
                        k.recycle();
                    }
                }
            }
        }

        public function getFrame(k:Int):AnimationFrame
        {
            if (((k >= 0) && (k < this._layerCount)))
            {
                return this._frames[k];
            }
            return null;
        }

        public function setFrame(k:Int, _arg_2:AnimationFrame)
        {
            var _local_3:AnimationFrame;
            if (((k >= 0) && (k < this._layerCount)))
            {
                _local_3 = this._frames[k];
                if (_local_3 != null)
                {
                    _local_3.recycle();
                }
                this._frames[k] = _arg_2;
            }
        }

        public function getAnimationPlayed(k:Int):Bool
        {
            if (((k >= 0) && (k < this._layerCount)))
            {
                return this._animationPlayed[k];
            }
            return true;
        }

        public function setAnimationPlayed(k:Int, _arg_2:Bool)
        {
            if (((k >= 0) && (k < this._layerCount)))
            {
                this._animationPlayed[k] = _arg_2;
            }
        }

        public function getLastFramePlayed(k:Int):Bool
        {
            if (((k >= 0) && (k < this._layerCount)))
            {
                return this._lastFramePlayed[k];
            }
            return true;
        }

        public function setLastFramePlayed(k:Int, _arg_2:Bool)
        {
            if (((k >= 0) && (k < this._layerCount)))
            {
                this._lastFramePlayed[k] = _arg_2;
            }
        }
    }

