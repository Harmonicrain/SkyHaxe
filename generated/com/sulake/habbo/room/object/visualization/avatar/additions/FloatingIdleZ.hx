package com.sulake.habbo.room.object.visualization.avatar.additions
;
    import com.sulake.habbo.room.object.visualization.avatar.AvatarVisualization;
    import com.sulake.core.assets.BitmapDataAsset;
    import flash.display.BitmapData;
    import com.sulake.room.object.visualization.IRoomObjectSprite;

     class FloatingIdleZ implements IAvatarAddition 
    {
        static inline final DELAY_BEFORE_ANIMATION= 2000;
        static inline final DELAY_PER_FRAME= 2000;
        static inline final STATE_DELAY= 0;
        static inline final STATE_FRAME_A= 1;
        static inline final STATE_FRAME_B= 2;

        var _id:Int = 0;
        var _Str_1070:AvatarVisualization;
        var _asset:BitmapDataAsset;
        var _startTime:Int = 0;
        var _offsetY:Int = 0;
        var _scale:Float = Math.NaN;
        var _state:Int = -1;

        public function new(k:Int, _arg_2:AvatarVisualization)
        {
            this._id = k;
            this._Str_1070 = _arg_2;
            this._startTime = flash.Lib.getTimer();
            this._state = 0;
        }

        public var id(get,never):Int;
function  get_id():Int
        {
            return this._id;
        }

        public var disposed(get,never):Bool;
function  get_disposed():Bool
        {
            return this._Str_1070 == null;
        }

        public function dispose()
        {
            this._Str_1070 = null;
            this._asset = null;
        }

        function getAssetNameForFrame(k:Int):String
        {
            var _local_2= "left";
            if (((((this._Str_1070.angle == 135) || (this._Str_1070.angle == 180)) || (this._Str_1070.angle == 225)) || (this._Str_1070.angle == 270)))
            {
                _local_2 = "right";
            }
            return (((("user_idle_" + _local_2) + "_") + k) + ((this._scale < 48) ? "_small" : "")) + "_png";
        }

        public function animate(k:IRoomObjectSprite):Bool
        {
            if (k == null)
            {
                return false;
            }
            if (this._state == STATE_DELAY)
            {
                if ((flash.Lib.getTimer() - this._startTime) >= DELAY_BEFORE_ANIMATION)
                {
                    this._state = STATE_FRAME_A;
                    this._startTime = flash.Lib.getTimer();
                    this._asset = Std.downcast(this._Str_1070.getAvatarRendererAsset(this.getAssetNameForFrame(1)) , BitmapDataAsset);
                }
            }
            if (this._state == STATE_FRAME_A)
            {
                if ((flash.Lib.getTimer() - this._startTime) >= DELAY_PER_FRAME)
                {
                    this._state = STATE_FRAME_B;
                    this._startTime = flash.Lib.getTimer();
                    this._asset = Std.downcast(this._Str_1070.getAvatarRendererAsset(this.getAssetNameForFrame(2)) , BitmapDataAsset);
                }
            }
            if (this._state == STATE_FRAME_B)
            {
                if ((flash.Lib.getTimer() - this._startTime) >= DELAY_PER_FRAME)
                {
                    this._state = STATE_FRAME_A;
                    this._startTime = flash.Lib.getTimer();
                    this._asset = Std.downcast(this._Str_1070.getAvatarRendererAsset(this.getAssetNameForFrame(1)) , BitmapDataAsset);
                }
            }
            if (this._asset != null)
            {
                k.asset = ASCompat.dynamicAs(this._asset.content , BitmapData);
                k.alpha = 0xFF;
                k.visible = true;
            }
            else
            {
                k.visible = false;
            }
            return false;
        }

        public function update(k:IRoomObjectSprite, _arg_2:Float)
        {
            var _local_3:Int;
            if (k == null)
            {
                return;
            }
            this._scale = _arg_2;
            this._asset = Std.downcast(this._Str_1070.getAvatarRendererAsset(this.getAssetNameForFrame(((this._state == STATE_FRAME_A) ? 1 : 2))) , BitmapDataAsset);
            var _local_4= 64;
            if (_arg_2 < 48)
            {
                if (((((this._Str_1070.angle == 135) || (this._Str_1070.angle == 180)) || (this._Str_1070.angle == 225)) || (this._Str_1070.angle == 270)))
                {
                    _local_3 = 10;
                }
                else
                {
                    _local_3 = -16;
                }
                this._offsetY = -38;
                _local_4 = 32;
            }
            else
            {
                if (((((this._Str_1070.angle == 135) || (this._Str_1070.angle == 180)) || (this._Str_1070.angle == 225)) || (this._Str_1070.angle == 270)))
                {
                    _local_3 = 22;
                }
                else
                {
                    _local_3 = -30;
                }
                this._offsetY = -70;
            }
            if (this._Str_1070.posture == "sit")
            {
                this._offsetY = Std.int(this._offsetY + (_local_4 / 2));
            }
            else
            {
                if (this._Str_1070.posture == "lay")
                {
                    this._offsetY = Std.int(this._offsetY + (_local_4 - (0.3 * _local_4)));
                }
            }
            if (this._asset != null)
            {
                k.asset = ASCompat.dynamicAs(this._asset.content , BitmapData);
                k.offsetX = _local_3;
                k.offsetY = this._offsetY;
                k.relativeDepth = -0.02;
                k.alpha = 0;
            }
        }
    }

