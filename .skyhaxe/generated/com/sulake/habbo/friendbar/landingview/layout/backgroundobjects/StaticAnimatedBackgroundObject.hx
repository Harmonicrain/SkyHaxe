package com.sulake.habbo.friendbar.landingview.layout.backgroundobjects
;
    import com.sulake.habbo.friendbar.landingview.layout.backgroundobjects.events.PathResetEvent;
    import com.sulake.core.window.IWindowContainer;
    import flash.events.EventDispatcher;
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;

     class StaticAnimatedBackgroundObject extends _Str_3317 
    {
        var _currentMs:UInt = 0;
        var _imageBaseUri:String;
        var _frameCount:Int = 0;
        var _fps:Int = 0;
        var _posX:Int = 0;
        var _posY:Int = 0;
        var _triggeringObjectIds:Array<ASAny>;
        var _triggerMs:UInt = 0;

        public function new(k:Int, _arg_2:IWindowContainer, _arg_3:EventDispatcher, _arg_4:HabboLandingView, _arg_5:String)
        {
            super(k, _arg_2, _arg_3, _arg_4, _arg_5);
            var _local_6:Array<ASAny> = (cast _arg_5.split(";"));
            this._imageBaseUri = ("${image.library.url}reception/" + _local_6[0]);
            this._frameCount = ASCompat.toInt(_local_6[2]);
            this._fps = ASCompat.toInt(_local_6[3]);
            this._posX = ASCompat.toInt(_local_6[4]);
            this._posY = ASCompat.toInt(_local_6[5]);
            this._triggeringObjectIds = (cast ASCompat.toString(_local_6[6]).split(","));
            _arg_3.addEventListener(PathResetEvent.LWMOPRE_MOVING_OBJECT_PATH_RESET, (this._Str_20385 : ASAny));
            sprite.x = this._posX;
            sprite.y = this._posY;
        }

        override public function dispose()
        {
            events.removeEventListener(PathResetEvent.LWMOPRE_MOVING_OBJECT_PATH_RESET, (this._Str_20385 : ASAny));
            super.dispose();
        }

        override public function update(k:UInt)
        {
            super.update(k);
            var _local_2= Std.int(1000 / this._fps);
            var _local_3= (this._currentMs - this._triggerMs);
            var _local_4= (this._frameCount - 1);
            if (this._triggeringObjectIds.length > 0)
            {
                if (_local_3 < ((this._frameCount * _local_2) : UInt))
                {
                    _local_4 = Std.int(_local_3 / _local_2);
                }
            }
            else
            {
                _local_4 = ASCompat.toInt(this._currentMs % _local_2);
            }
            sprite.assetUri = ((this._imageBaseUri + Std.string(_local_4 + 1)) + ".png");
            this._currentMs = (this._currentMs + k);
        }

        function _Str_20385(k:PathResetEvent)
        {
            if (this._triggeringObjectIds.indexOf(Std.string(k.objectId)) != -1)
            {
                this._triggerMs = this._currentMs;
            }
        }
    }

