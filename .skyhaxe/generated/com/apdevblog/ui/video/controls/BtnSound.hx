package com.apdevblog.ui.video.controls
;
    import flash.display.Sprite;
    import flash.display.Shape;
    import com.apdevblog.utils._Str_3771;
    import flash.events.MouseEvent;
    import com.apdevblog.ui.video.controls.VideoControlsEvent;

     class BtnSound extends Sprite 
    {
        var _Str_17479:Array<ASAny>;

        public function new()
        {
            super();
            this._Str_1400();
        }

        public function _Str_3820(k:Float)
        {
            var _local_4:Shape = null;
            var _local_2= Std.int(Math.fceil((k * 7)));
            var _local_3:Float = 1;
            while (_local_3 < 9)
            {
                _local_4 = ASCompat.dynamicAs(this._Str_17479[Std.int(_local_3 - 1)] , Shape);
                if (_local_4 != null)
                {
                    _local_4.alpha = (((_local_3 - 1) > _local_2) ? 0.25 : 1);
                }
                _local_3++;
            }
        }

        function _Str_4149()
        {
            var _local_3:Shape = null;
            var k= _Str_3771._Str_13333(31, 23, 90, 3748644, 0, 1, 1);
            addChild(k);
            this._Str_17479 = new Array<ASAny>();
            var _local_2:Float = 0;
            while (_local_2 < 8)
            {
                _local_3 = _Str_3771.rect(2, (_local_2 + 1), 13020778, 1);
                _local_3.x = (4 + (_local_2 * 3));
                _local_3.y = (16 - (1 + _local_2));
                addChild(_local_3);
                this._Str_17479.push(_local_3);
                _local_2++;
            }
        }

        function _Str_1400()
        {
            mouseEnabled = true;
            buttonMode = true;
            this._Str_4149();
            addEventListener(MouseEvent.MOUSE_DOWN, (this._Str_780 : ASAny), false, 0, true);
        }

        function _Str_19706()
        {
            var _local_2 = Math.NaN;
            var k= Std.int(mouseX);
            if (k < 4)
            {
                _local_2 = 0;
            }
            else
            {
                if (k > 27)
                {
                    _local_2 = 1;
                }
                else
                {
                    _local_2 = ((k - 4) / 23);
                }
            }
            dispatchEvent(new VideoControlsEvent(VideoControlsEvent.SETVOLUME, true, true, _local_2));
        }

        function _Str_4955(k:MouseEvent)
        {
            this._Str_19706();
        }

        function _Str_780(k:MouseEvent)
        {
            addEventListener(MouseEvent.MOUSE_UP, (this._Str_712 : ASAny), false, 0, true);
            addEventListener(MouseEvent.MOUSE_MOVE, (this._Str_4955 : ASAny), false, 0, true);
        }

        function _Str_712(k:MouseEvent)
        {
            removeEventListener(MouseEvent.MOUSE_UP, (this._Str_712 : ASAny));
            removeEventListener(MouseEvent.MOUSE_MOVE, (this._Str_4955 : ASAny));
            this._Str_19706();
        }
    }

