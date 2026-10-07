package com.sulake.habbo.friendbar.landingview.layout.backgroundobjects
;
    import com.sulake.core.window.IWindowContainer;
    import flash.events.EventDispatcher;
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;
    import com.sulake.habbo.friendbar.landingview.layout.backgroundobjects.events.PathResetEvent;

     class LinearMovingBackgroundObject extends _Str_3317 
    {
        var _startX:Int = 0;
        var _startY:Int = 0;
        var _posX:Float = Math.NaN;
        var _posY:Float = Math.NaN;
        var _speedX:Float = Math.NaN;
        var _speedY:Float = Math.NaN;

        public function new(k:Int, _arg_2:IWindowContainer, _arg_3:EventDispatcher, _arg_4:HabboLandingView, _arg_5:String)
        {
            super(k, _arg_2, _arg_3, _arg_4, _arg_5);
            var _local_6:Array<ASAny> = (cast _arg_5.split(";"));
            var _local_7:String = _local_6[0];
            this._startX = ASCompat.toInt(_local_6[2]);
            this._startY = ASCompat.toInt(_local_6[3]);
            this._speedX = ASCompat.toNumber(_local_6[4]);
            this._speedY = ASCompat.toNumber(_local_6[5]);
            this._posX = this._startX;
            this._posY = this._startY;
            sprite.assetUri = (("${image.library.url}reception/" + _local_7) + ".png");
        }

        override public function update(k:UInt)
        {
            super.update(k);
            if (sprite == null)
            {
                return;
            }
            var _local_2= window.width;
            var _local_3= window.height;
            this._posX = (this._posX + (k * this._speedX));
            this._posY = (this._posY + (k * this._speedY));
            sprite.x = Std.int(this._posX);
            sprite.y = Std.int(this._posY + window.desktop.height);
            if ((((((this._speedX > 0) && (sprite.x > _local_2)) || ((this._speedX < 0) && ((sprite.x + sprite.width) < 0))) || ((this._speedY > 0) && (sprite.y > _local_3))) || ((this._speedY < 0) && ((sprite.y + sprite.height) < 0))))
            {
                this._posX = this._startX;
                this._posY = this._startY;
                events.dispatchEvent(new PathResetEvent(PathResetEvent.LWMOPRE_MOVING_OBJECT_PATH_RESET, id));
            }
        }
    }

