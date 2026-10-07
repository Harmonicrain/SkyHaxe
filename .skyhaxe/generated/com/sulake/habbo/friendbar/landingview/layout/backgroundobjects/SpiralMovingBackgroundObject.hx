package com.sulake.habbo.friendbar.landingview.layout.backgroundobjects
;
    import com.sulake.core.window.IWindowContainer;
    import flash.events.EventDispatcher;
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;
    import com.sulake.habbo.friendbar.landingview.layout.backgroundobjects.events.PathResetEvent;
    import com.sulake.core.window._enum.PivotPoint;

     class SpiralMovingBackgroundObject extends _Str_3317 
    {
        var _startRadius:Int = 0;
        var _startAngle:Int = 0;
        var _posRadius:Float = Math.NaN;
        var _posAngle:Float = Math.NaN;
        var _speedRadius:Float = Math.NaN;
        var _speedAngle:Float = Math.NaN;
        var _centerX:Float = Math.NaN;
        var _centerY:Float = Math.NaN;

        public function new(k:Int, _arg_2:IWindowContainer, _arg_3:EventDispatcher, _arg_4:HabboLandingView, _arg_5:String)
        {
            super(k, _arg_2, _arg_3, _arg_4, _arg_5);
            var _local_6:Array<ASAny> = (cast _arg_5.split(";"));
            var _local_7:String = _local_6[0];
            this._startRadius = ASCompat.toInt(_local_6[2]);
            this._startAngle = ASCompat.toInt(_local_6[3]);
            this._speedRadius = ASCompat.toNumber(_local_6[4]);
            this._speedAngle = ASCompat.toNumber(_local_6[5]);
            this._centerX = ASCompat.toNumber(_local_6[6]);
            this._centerY = ASCompat.toNumber(_local_6[7]);
            this._posRadius = this._startRadius;
            this._posAngle = this._startAngle;
            sprite.assetUri = (("${image.library.url}reception/" + _local_7) + ".png");
        }

        override public function update(k:UInt)
        {
            super.update(k);
            var _local_2= (this._startRadius / this._posRadius);
            var _local_3= (1 + ((this._startRadius / this._posRadius) / 8));
            this._posRadius = (this._posRadius + (k * this._speedRadius));
            this._posAngle = (this._posAngle + ((k * this._speedAngle) * _local_2));
            if (sprite.bitmapData != null)
            {
                if (this._posRadius <= 0)
                {
                    this._posRadius = this._startRadius;
                    sprite.width = sprite.bitmapData.width;
                    sprite.height = sprite.bitmapData.height;
                    events.dispatchEvent(new PathResetEvent(PathResetEvent.LWMOPRE_MOVING_OBJECT_PATH_RESET, id));
                }
            }
            if (this._posRadius > this._startRadius)
            {
                this._posRadius = 0;
                sprite.width = 0;
                sprite.height = 0;
                events.dispatchEvent(new PathResetEvent(PathResetEvent.LWMOPRE_MOVING_OBJECT_PATH_RESET, id));
            }
            if (this._posAngle < 0)
            {
                this._posAngle = (Math.PI * 2);
            }
            if (this._posAngle > (Math.PI * 2))
            {
                this._posAngle = 0;
            }
            sprite.x = Std.int(this._centerX + (Math.sin(this._posAngle) * this._posRadius));
            sprite.y = Std.int(this._centerY + (Math.cos(this._posAngle) * this._posRadius));
            if (sprite.bitmapData != null)
            {
                sprite.pivotPoint = PivotPoint.CENTER;
                sprite.stretchedX = true;
                sprite.stretchedY = true;
                sprite.width = Std.int(sprite.bitmapData.width / _local_3);
                sprite.height = Std.int(sprite.bitmapData.height / _local_3);
            }
        }
    }

