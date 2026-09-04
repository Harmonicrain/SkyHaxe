package com.sulake.habbo.room.object.visualization.avatar.additions
;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.habbo.room.object.visualization.avatar.AvatarVisualization;
    import flash.display.BitmapData;
    import com.sulake.room.object.visualization.IRoomObjectSprite;

     class FloatingHeart extends ExpressionAddition 
    {
        static inline final DELAY_BEFORE_ANIMATION= 300;
        static inline final STATE_DELAY= 0;
        static inline final STATE_FADE_IN= 1;
        static inline final STATE_FLOAT= 2;
        static inline final STATE_COMPLETE= 3;

        var _asset:BitmapDataAsset;
        var _startTime:Int = 0;
        var _delta:Float = 0;
        var _offsetY:Int = 0;
        var _scale:Float = Math.NaN;
        var _state:Int = -1;

        public function new(k:Int, _arg_2:Int, _arg_3:AvatarVisualization)
        {
            super(k, _arg_2, _arg_3);
            this._startTime = flash.Lib.getTimer();
            this._state = 0;
        }

        override public function animate(k:IRoomObjectSprite):Bool
        {
            var _local_2:Float;
            var _local_3:Int;
            if (k == null)
            {
                return false;
            }
            if (this._asset != null)
            {
                k.asset = ASCompat.dynamicAs(this._asset.content , BitmapData);
            }
            if (this._state == STATE_DELAY)
            {
                if ((flash.Lib.getTimer() - this._startTime) < DELAY_BEFORE_ANIMATION)
                {
                    return false;
                }
                this._state = STATE_FADE_IN;
                k.alpha = 0;
                k.visible = true;
                this._delta = 0;
                return true;
            }
            if (this._state == STATE_FADE_IN)
            {
                this._delta = (this._delta + 0.1);
                k.offsetY = this._offsetY;
                k.alpha = Std.int(Math.pow(this._delta, 0.9) * 0xFF);
                if (this._delta >= 1)
                {
                    this._delta = 0;
                    k.alpha = 0xFF;
                    this._state = STATE_FLOAT;
                }
                return true;
            }
            if (this._state == STATE_FLOAT)
            {
                _local_2 = Math.pow(this._delta, 0.9);
                this._delta = (this._delta + 0.05);
                _local_3 = ((this._scale < 48) ? -30 : -40);
                k.offsetY = Std.int(this._offsetY + (((this._delta < 1) ? _local_2 : 1) * _local_3));
                k.alpha = Std.int((1 - _local_2) * 0xFF);
                if (k.alpha <= 0)
                {
                    k.visible = false;
                    this._state = STATE_COMPLETE;
                }
                return true;
            }
            return false;
        }

        override public function update(k:IRoomObjectSprite, _arg_2:Float)
        {
            var _local_3:Int;
            var _local_5:Float;
            if (k == null)
            {
                return;
            }
            this._scale = _arg_2;
            var _local_4= 64;
            if (_arg_2 < 48)
            {
                this._asset = Std.downcast(_Str_1070.getAvatarRendererAsset("user_blowkiss_small_png") , BitmapDataAsset);
                if (((_Str_1070.angle == 90) || (_Str_1070.angle == 270)))
                {
                    _local_3 = 0;
                }
                else
                {
                    if ((((_Str_1070.angle == 135) || (_Str_1070.angle == 180)) || (_Str_1070.angle == 225)))
                    {
                        _local_3 = 6;
                    }
                    else
                    {
                        _local_3 = -6;
                    }
                }
                this._offsetY = -38;
                _local_4 = 32;
            }
            else
            {
                this._asset = Std.downcast(_Str_1070.getAvatarRendererAsset("user_blowkiss_png") , BitmapDataAsset);
                if (((_Str_1070.angle == 90) || (_Str_1070.angle == 270)))
                {
                    _local_3 = -3;
                }
                else
                {
                    if ((((_Str_1070.angle == 135) || (_Str_1070.angle == 180)) || (_Str_1070.angle == 225)))
                    {
                        _local_3 = 22;
                    }
                    else
                    {
                        _local_3 = -30;
                    }
                }
                this._offsetY = -70;
            }
            if (_Str_1070.posture == "sit")
            {
                this._offsetY = Std.int(this._offsetY + (_local_4 / 2));
            }
            else
            {
                if (_Str_1070.posture == "lay")
                {
                    this._offsetY = (this._offsetY + _local_4);
                }
            }
            if (this._asset != null)
            {
                k.asset = ASCompat.dynamicAs(this._asset.content , BitmapData);
                k.offsetX = _local_3;
                k.offsetY = this._offsetY;
                k.relativeDepth = -0.02;
                k.alpha = 0;
                _local_5 = this._delta;
                this.animate(k);
                this._delta = _local_5;
            }
        }
    }

