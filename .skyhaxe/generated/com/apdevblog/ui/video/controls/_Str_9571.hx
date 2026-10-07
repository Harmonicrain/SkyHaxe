package com.apdevblog.ui.video.controls
;
    import flash.display.Sprite;
    import com.apdevblog.ui.video._Str_2872;
    import flash.display.Graphics;
    import com.apdevblog.utils._Str_3771;
    import flash.events.MouseEvent;
    import flash.filters.GlowFilter;

     class _Str_9571 extends Sprite 
    {
        var _Str_3662:Sprite;
        var _Str_6609:Sprite;
        var _state:String;

        public function new()
        {
            super();
            this._Str_1400();
        }

        public function _Str_3820(k:String)
        {
            visible = true;
            this._state = k;
            switch (k)
            {
                case _Str_2872.VIDEOSTATEPLAYING:
                    this._Str_3662.visible = false;
                    this._Str_6609.visible = true;
                    return;
                case _Str_2872.VIDEOSTATEPAUSED
                   | _Str_2872.VIDEOSTATESTOPPED:
                    this._Str_3662.visible = true;
                    this._Str_6609.visible = false;
                    return;
            }
        }

        function _Str_4149()
        {
            var _local_2:Graphics = null;
            var k= _Str_3771._Str_13333(23, 23, 90, 3748644, 0, 1, 1);
            addChild(k);
            this._Str_3662 = new Sprite();
            _local_2 = this._Str_3662.graphics;
            _local_2.beginFill(13020778, 1);
            _local_2.drawRect(9, 5, 1, 1);
            _local_2.drawRect(9, 6, 2, 1);
            _local_2.drawRect(9, 7, 3, 1);
            _local_2.drawRect(9, 8, 4, 1);
            _local_2.drawRect(9, 9, 5, 1);
            _local_2.drawRect(9, 10, 6, 1);
            _local_2.drawRect(9, 11, 7, 1);
            _local_2.drawRect(9, 12, 6, 1);
            _local_2.drawRect(9, 13, 5, 1);
            _local_2.drawRect(9, 14, 4, 1);
            _local_2.drawRect(9, 15, 3, 1);
            _local_2.drawRect(9, 16, 2, 1);
            _local_2.drawRect(9, 17, 1, 1);
            _local_2.endFill();
            addChild(this._Str_3662);
            this._Str_6609 = new Sprite();
            this._Str_6609.visible = false;
            _local_2 = this._Str_6609.graphics;
            _local_2.beginFill(13020778, 1);
            _local_2.drawRect(7, 5, 3, 12);
            _local_2.drawRect(13, 5, 3, 12);
            _local_2.endFill();
            addChild(this._Str_6609);
        }

        function _Str_1400()
        {
            buttonMode = true;
            mouseChildren = false;
            this._Str_4149();
            addEventListener(MouseEvent.MOUSE_OVER, (this.onMouseOver : ASAny), false, 0, true);
            addEventListener(MouseEvent.MOUSE_OUT, (this.onMouseOut : ASAny), false, 0, true);
            this._state = _Str_2872.VIDEOSTATEPAUSED;
        }

        function onMouseOver(k:MouseEvent)
        {
            this._Str_6609.filters = [new GlowFilter(0xFFFFFF, 0.45)];
            this._Str_3662.filters = [new GlowFilter(0xFFFFFF, 0.45)];
        }

        function onMouseOut(k:MouseEvent)
        {
            this._Str_6609.filters = [];
            this._Str_3662.filters = [];
        }
    }

