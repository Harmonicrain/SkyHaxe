package com.apdevblog.ui.video.controls
;
    import flash.display.Sprite;
    import com.apdevblog.utils._Str_3771;
    import flash.events.MouseEvent;
    import flash.filters.GlowFilter;

     class _Str_9222 extends Sprite 
    {
        var _Str_6493:Sprite;
        var _Str_5758:Sprite;

        public function new()
        {
            super();
            this._Str_1400();
        }

        public function _Str_3820(k:String)
        {
            switch (k)
            {
                case "normal":
                    this._Str_6493.visible = true;
                    this._Str_5758.visible = false;
                    return;
                case "fullScreen":
                    this._Str_6493.visible = false;
                    this._Str_5758.visible = true;
                    return;
            }
        }

        function _Str_4149()
        {
            var k= _Str_3771._Str_13333(25, 23, 90, 3748644, 0, 1, 1);
            addChild(k);
            this._Str_6493 = new Sprite();
            var _local_2= this._Str_6493.graphics;
            _local_2.beginFill(13020778, 1);
            _local_2.drawRect(2, 2, 3, 1);
            _local_2.drawRect(2, 3, 1, 2);
            _local_2.drawRect(20, 2, 3, 1);
            _local_2.drawRect(22, 3, 1, 2);
            _local_2.drawRect(2, 18, 1, 3);
            _local_2.drawRect(3, 20, 2, 1);
            _local_2.drawRect(20, 20, 3, 1);
            _local_2.drawRect(22, 18, 1, 2);
            _local_2.drawRect(6, 5, 13, 3);
            _local_2.drawRect(6, 8, 1, 9);
            _local_2.drawRect(18, 8, 1, 9);
            _local_2.drawRect(7, 16, 11, 1);
            _local_2.endFill();
            addChild(this._Str_6493);
            this._Str_5758 = new Sprite();
            this._Str_5758.visible = false;
            _local_2 = this._Str_5758.graphics;
            _local_2.beginFill(13020778, 1);
            _local_2.drawRect(6, 10, 3, 1);
            _local_2.drawRect(8, 8, 1, 2);
            _local_2.drawRect(6, 14, 3, 1);
            _local_2.drawRect(8, 15, 1, 2);
            _local_2.drawRect(16, 8, 1, 3);
            _local_2.drawRect(17, 10, 2, 1);
            _local_2.drawRect(16, 14, 3, 1);
            _local_2.drawRect(16, 15, 1, 2);
            _local_2.drawRect(3, 3, 19, 3);
            _local_2.drawRect(3, 6, 1, 14);
            _local_2.drawRect(21, 6, 1, 14);
            _local_2.drawRect(4, 19, 17, 1);
            _local_2.endFill();
            addChild(this._Str_5758);
        }

        function _Str_1400()
        {
            buttonMode = true;
            mouseChildren = false;
            this._Str_4149();
            addEventListener(MouseEvent.CLICK, (this.onMouseClick : ASAny), false, 0, true);
            addEventListener(MouseEvent.MOUSE_OVER, (this.onMouseOver : ASAny), false, 0, true);
            addEventListener(MouseEvent.MOUSE_OUT, (this.onMouseOut : ASAny), false, 0, true);
        }

        function onMouseClick(k:MouseEvent)
        {
            this._Str_6493.filters = [];
            this._Str_5758.filters = [];
        }

        function onMouseOver(k:MouseEvent)
        {
            this._Str_6493.filters = [new GlowFilter(0xFFFFFF, 0.45)];
            this._Str_5758.filters = [new GlowFilter(0xFFFFFF, 0.45)];
        }

        function onMouseOut(k:MouseEvent)
        {
            this._Str_6493.filters = [];
            this._Str_5758.filters = [];
        }
    }

