package com.apdevblog.ui.video.controls
;
    import flash.display.Sprite;
    import com.apdevblog.utils._Str_3771;

     class _Str_9370 extends Sprite 
    {
        public function new()
        {
            super();
            mouseEnabled = false;
            mouseChildren = false;
            alpha = 0.3;
            var k= _Str_3771._Str_25390(28, 40, 360, 0xFFFFFF, 1);
            addChild(k);
            var _local_2= graphics;
            _local_2.beginFill(0xFFFFFF, 1);
            _local_2.moveTo(-9, -16);
            _local_2.lineTo(15, 0);
            _local_2.lineTo(-9, 16);
            _local_2.lineTo(-9, -16);
            _local_2.endFill();
        }
    }

