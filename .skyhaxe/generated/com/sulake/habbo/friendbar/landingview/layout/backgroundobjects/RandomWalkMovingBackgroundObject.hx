package com.sulake.habbo.friendbar.landingview.layout.backgroundobjects
;
    import com.sulake.core.window.IWindowContainer;
    import flash.events.EventDispatcher;
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;
    import com.sulake.habbo.utils._Str_988;
    import com.sulake.habbo.friendbar.landingview.layout.backgroundobjects.events.PathResetEvent;

     class RandomWalkMovingBackgroundObject extends _Str_3317 
    {
        var _startX:Int = 0;
        var _startY:Int = 0;
        var _randomX:Float = Math.NaN;
        var _randomY:Float = Math.NaN;
        var _speedX:Float = Math.NaN;
        var _speedY:Float = Math.NaN;
        var _randomTimeSpan:Float = Math.NaN;
        var _timer:UInt = 0;
        var _posX:Float = Math.NaN;
        var _posY:Float = Math.NaN;
        var _nextRandomX:Float = 0;
        var _nextRandomY:Float = 0;
        var _currentRandomX:Float = 0;
        var _currentRandomY:Float = 0;
        var _lastSample:UInt = 0;

        public function new(k:Int, _arg_2:IWindowContainer, _arg_3:EventDispatcher, _arg_4:HabboLandingView, _arg_5:String)
        {
            super(k, _arg_2, _arg_3, _arg_4, _arg_5, false);
            var _local_6:Array<ASAny> = (cast _arg_5.split(";"));
            var _local_7:String = _local_6[0];
            this._startX = ASCompat.toInt(_local_6[2]);
            this._startY = ASCompat.toInt(_local_6[3]);
            this._speedX = ASCompat.toNumber(_local_6[4]);
            this._speedY = ASCompat.toNumber(_local_6[5]);
            this._randomX = ASCompat.toNumber(_local_6[6]);
            this._randomY = ASCompat.toNumber(_local_6[7]);
            this._randomTimeSpan = ASCompat.toInt(_local_6[8]);
            this._posX = this._startX;
            this._posY = this._startY;
            sprite.assetUri = (("${image.library.url}" + _local_7) + ".png");
        }

        override public function update(k:UInt)
        {
            super.update(k);
            if (sprite == null)
            {
                return;
            }
            this._timer = (this._timer + k);
            if ((this._timer - this._lastSample) > this._randomTimeSpan)
            {
                this._currentRandomX = this._nextRandomX;
                this._currentRandomY = this._nextRandomY;
                this._nextRandomX = (((Math.random() * 2) - 1) * this._randomX);
                this._nextRandomY = (((Math.random() * 2) - 1) * this._randomY);
                this._lastSample = this._timer;
            }
            var _local_2= window.width;
            var _local_3= window.height;
            var _local_4= ((this._timer - this._lastSample) / this._randomTimeSpan);
            this._posX = (this._posX + ((k / 1000) * (this._speedX + _Str_988._Str_1028(_local_4, this._currentRandomX, this._nextRandomX))));
            this._posY = (this._posY + ((k / 1000) * (this._speedY + _Str_988._Str_1028(_local_4, this._currentRandomY, this._nextRandomY))));
            sprite.x = Std.int(this._posX);
            sprite.y = Std.int(this._posY);
            if ((((((this._speedX > 0) && (sprite.x > _local_2)) || ((this._speedX < 0) && ((sprite.x + sprite.width) < 0))) || ((this._speedY > 0) && (sprite.y > _local_3))) || ((this._speedY < 0) && ((sprite.y + sprite.height) < 0))))
            {
                this._posX = this._startX;
                this._posY = this._startY;
                events.dispatchEvent(new PathResetEvent(PathResetEvent.LWMOPRE_MOVING_OBJECT_PATH_RESET, id));
            }
        }
    }

