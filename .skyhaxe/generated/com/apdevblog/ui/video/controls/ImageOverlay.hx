package com.apdevblog.ui.video.controls
;
    import flash.display.Sprite;
    import flash.display.Loader;
    import flash.net.URLRequest;
    import com.apdevblog.utils._Str_3771;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import com.apdevblog.ui.video.controls.VideoControlsEvent;

     class ImageOverlay extends Sprite
    {
        var _Str_2835:Loader;
        var _Str_8321:_Str_9370;
        var _Str_4901:Float = Math.NaN;
        var _Str_4960:Float = Math.NaN;

        public function new(k:Float, _arg_2:Float)
        {
            super();
            this._Str_1400(k, _arg_2);
        }

        public function load(k:URLRequest)
        {
            if (k == null)
            {
                return;
            }
            this._Str_2835.load(k);
        }

        function _Str_4149()
        {
            this._Str_2835 = new Loader();
            addChild(this._Str_2835);
            this._Str_8321 = new _Str_9370();
            this._Str_8321.x = Math.fround((this._Str_4901 * 0.5));
            this._Str_8321.y = Math.fround((this._Str_4960 * 0.5));
            addChild(this._Str_8321);
            var k= _Str_3771.rect(this._Str_4901, this._Str_4960, 0xFF0000, 1);
            addChild(k);
            mask = k;
        }

        function _Str_1400(k:Float, _arg_2:Float)
        {
            this._Str_4901 = k;
            this._Str_4960 = _arg_2;
            buttonMode = true;
            this._Str_4149();
            addEventListener(MouseEvent.MOUSE_OVER, (this._Str_23190 : ASAny), false, 0, true);
            addEventListener(MouseEvent.MOUSE_OUT, (this._Str_24680 : ASAny), false, 0, true);
            addEventListener(MouseEvent.CLICK, (this._Str_24204 : ASAny), false, 0, true);
            this._Str_2835.contentLoaderInfo.addEventListener(Event.COMPLETE, (this.onImageLoaded : ASAny), false, 0, true);
        }

        function _Str_24204(k:MouseEvent)
        {
            dispatchEvent(new VideoControlsEvent(VideoControlsEvent.TOGGLEPLAYPAUSE, true, true));
        }

        function onImageLoaded(k:Event)
        {
            var _local_2 = Math.NaN;
            var _local_3 = Math.NaN;
            var _local_4 = Math.NaN;
            var _local_6 = Math.NaN;
            _local_2 = (this._Str_2835.width / this._Str_2835.height);
            _local_3 = this._Str_4901;
            _local_4 = this._Str_4960;
            var _local_5= (_local_3 / _local_4);
            if (_local_2 > _local_5)
            {
                this._Str_2835.width = _local_3;
                this._Str_2835.height = (_local_3 / _local_2);
                if (this._Str_2835.height < _local_4)
                {
                    _local_6 = (_local_4 / this._Str_2835.height);
                    this._Str_2835.width = (this._Str_2835.width * _local_6);
                    this._Str_2835.height = (this._Str_2835.height * _local_6);
                }
            }
            else
            {
                this._Str_2835.width = (_local_4 * _local_2);
                this._Str_2835.height = _local_4;
                if (this._Str_2835.width < _local_3)
                {
                    _local_6 = (_local_3 / this._Str_2835.width);
                    this._Str_2835.width = (this._Str_2835.width * _local_6);
                    this._Str_2835.height = (this._Str_2835.height * _local_6);
                }
            }
            this._Str_2835.x = Math.fround(((_local_3 - this._Str_2835.width) * 0.5));
            this._Str_2835.y = Math.fround(((_local_4 - this._Str_2835.height) * 0.5));
        }

        function _Str_24680(k:MouseEvent)
        {
            this._Str_8321.alpha = 0.3;
        }

        function _Str_23190(k:MouseEvent)
        {
            this._Str_8321.alpha = 0.5;
        }
    }

