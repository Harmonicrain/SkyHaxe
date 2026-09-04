package com.sulake.habbo.room.object.visualization.avatar.additions
;
    import com.sulake.habbo.room.object.visualization.avatar.AvatarVisualization;
    import com.sulake.core.assets.BitmapDataAsset;
    import flash.display.BitmapData;
    import com.sulake.room.object.visualization.IRoomObjectSprite;

     class NumberBubble implements IAvatarAddition 
    {
        var _id:Int = -1;
        var _avatar:AvatarVisualization;
        var _asset:BitmapDataAsset;
        var _scale:Float = Math.NaN;
        var _number:Int = 0;
        var _numberValueFadeDirection:Int = 0;
        var _numberValueMoving:Bool = false;
        var _numberValueMoveCounter:Int = 0;

        public function new(k:Int, _arg_2:Int, _arg_3:AvatarVisualization)
        {
            this._id = k;
            this._number = _arg_2;
            this._avatar = _arg_3;
        }

        public var id(get,never):Int;
function  get_id():Int
        {
            return this._id;
        }

        public var disposed(get,never):Bool;
function  get_disposed():Bool
        {
            return this._avatar == null;
        }

        public function dispose()
        {
            this._avatar = null;
            this._asset = null;
        }

        public function update(k:IRoomObjectSprite, _arg_2:Float)
        {
            var _local_3:Int;
            var _local_4:Int;
            var _local_5:Int;
            if (k == null)
            {
                return;
            }
            this._scale = _arg_2;
            if (this._number > 0)
            {
                _local_5 = 64;
                if (_arg_2 < 48)
                {
                    this._asset = Std.downcast(this._avatar.getAvatarRendererAsset((("number_" + this._number) + "_small_png")) , BitmapDataAsset);
                    _local_3 = -6;
                    _local_4 = -52;
                    _local_5 = 32;
                }
                else
                {
                    this._asset = Std.downcast(this._avatar.getAvatarRendererAsset((("number_" + this._number) + "_png")) , BitmapDataAsset);
                    _local_3 = -8;
                    _local_4 = -105;
                }
                if (this._avatar.posture == "sit")
                {
                    _local_4 = Std.int(_local_4 + (_local_5 / 2));
                }
                else
                {
                    if (this._avatar.posture == "lay")
                    {
                        _local_4 = (_local_4 + _local_5);
                    }
                }
                if (this._asset != null)
                {
                    k.visible = true;
                    k.asset = ASCompat.dynamicAs(this._asset.content , BitmapData);
                    k.offsetX = _local_3;
                    k.offsetY = _local_4;
                    k.relativeDepth = -0.01;
                    this._numberValueFadeDirection = 1;
                    this._numberValueMoving = true;
                    this._numberValueMoveCounter = 0;
                    k.alpha = 0;
                }
                else
                {
                    k.visible = false;
                }
            }
            else
            {
                if (k.visible)
                {
                    this._numberValueFadeDirection = -1;
                }
            }
        }

        public function animate(k:IRoomObjectSprite):Bool
        {
            var _local_4:Int;
            if (k == null)
            {
                return false;
            }
            if (this._asset != null)
            {
                k.asset = ASCompat.dynamicAs(this._asset.content , BitmapData);
            }
            var _local_2= k.alpha;
            var _local_3 = false;
            if (this._numberValueMoving)
            {
                this._numberValueMoveCounter++;
                if (this._numberValueMoveCounter < 10)
                {
                    return false;
                }
                if (this._numberValueFadeDirection < 0)
                {
                    if (this._scale < 48)
                    {
                        k.offsetY = (k.offsetY - 2);
                    }
                    else
                    {
                        k.offsetY = (k.offsetY - 4);
                    }
                }
                else
                {
                    _local_4 = 4;
                    if (this._scale < 48)
                    {
                        _local_4 = 8;
                    }
                    if ((this._numberValueMoveCounter % _local_4) == 0)
                    {
                        k.offsetY--;
                        _local_3 = true;
                    }
                }
            }
            if (this._numberValueFadeDirection > 0)
            {
                if (_local_2 < 0xFF)
                {
                    _local_2 = (_local_2 + 32);
                }
                if (_local_2 >= 0xFF)
                {
                    _local_2 = 0xFF;
                    this._numberValueFadeDirection = 0;
                }
                k.alpha = _local_2;
                return true;
            }
            if (this._numberValueFadeDirection < 0)
            {
                if (_local_2 >= 0)
                {
                    _local_2 = (_local_2 - 32);
                }
                if (_local_2 <= 0)
                {
                    this._numberValueFadeDirection = 0;
                    this._numberValueMoving = false;
                    _local_2 = 0;
                    k.visible = false;
                }
                k.alpha = _local_2;
                return true;
            }
            return _local_3;
        }
    }

