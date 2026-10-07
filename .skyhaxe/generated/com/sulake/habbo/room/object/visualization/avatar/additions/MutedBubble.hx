package com.sulake.habbo.room.object.visualization.avatar.additions
;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.habbo.room.object.visualization.avatar.AvatarVisualization;
    import flash.display.BitmapData;
    import com.sulake.room.object.visualization.IRoomObjectSprite;
    import com.sulake.habbo.avatar._enum.AvatarAction;

     class MutedBubble implements IAvatarAddition 
    {
        var _id:Int = -1;
        var _asset:BitmapDataAsset;
        var _avatar:AvatarVisualization;
        var _relativeDepth:Float = 0;

        public function new(k:Int, _arg_2:AvatarVisualization)
        {
            this._id = k;
            this._avatar = _arg_2;
        }

        public var relativeDepth(never,set):Float;
public function  set_relativeDepth(k:Float):Float        {
            return this._relativeDepth = k;
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._avatar == null;
        }

        public function dispose()
        {
            this._avatar = null;
            this._asset = null;
        }

        public function animate(k:IRoomObjectSprite):Bool
        {
            if (((this._asset != null) && (k != null)))
            {
                k.asset = ASCompat.dynamicAs(this._asset.content , BitmapData);
            }
            return false;
        }

        public function update(k:IRoomObjectSprite, _arg_2:Float)
        {
            var _local_3 = 0;
            var _local_4 = 0;
            if (k == null)
            {
                return;
            }
            k.visible = true;
            k.relativeDepth = this._relativeDepth;
            k.alpha = 0xFF;
            var _local_5= 64;
            if (_arg_2 < 48)
            {
                this._asset = Std.downcast(this._avatar.getAvatarRendererAsset("user_muted_small_png") , BitmapDataAsset);
                _local_3 = -12;
                _local_4 = -66;
                _local_5 = 32;
            }
            else
            {
                this._asset = Std.downcast(this._avatar.getAvatarRendererAsset("user_muted_png") , BitmapDataAsset);
                _local_3 = -15;
                _local_4 = -110;
            }
            if (this._avatar.posture == AvatarAction.POSTURE_SIT)
            {
                _local_4 = Std.int(_local_4 + (_local_5 / 2));
            }
            else
            {
                if (this._avatar.posture == AvatarAction.POSTURE_LAY)
                {
                    _local_4 = (_local_4 + _local_5);
                }
            }
            if (this._asset != null)
            {
                k.asset = ASCompat.dynamicAs(this._asset.content , BitmapData);
                k.offsetX = _local_3;
                k.offsetY = _local_4;
                k.relativeDepth = (-0.02 + 0);
            }
        }
    }

