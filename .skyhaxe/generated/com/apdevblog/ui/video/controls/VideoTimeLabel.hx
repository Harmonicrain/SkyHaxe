package com.apdevblog.ui.video.controls
;
    import flash.display.Sprite;
    import flash.display.Shape;
    import flash.text.TextField;
    import com.apdevblog.model.vo.VideoMetadataVo;
    import com.apdevblog.utils.StringUtils;
    import com.apdevblog.utils._Str_3771;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    import flash.events.MouseEvent;

     class VideoTimeLabel extends Sprite 
    {
        public static inline final STATECOUNTUP= "stateCountUp";
        public static inline final STATECOUNTDOWN= "stateCountDown";

        var _Str_3888:Shape;
        var _txt:TextField;
        var _state:String;
        var _Str_7402:VideoMetadataVo;
        var _Str_4492:Float = Math.NaN;

        public function new()
        {
            super();
            this._Str_1400();
        }

        public function update(k:Float)
        {
            var _local_6 = 0;
            this._Str_4492 = k;
            if (this._state == VideoTimeLabel.STATECOUNTDOWN)
            {
                _local_6 = Std.int((this._Str_7402 != null) ? Std.int(this._Str_7402.duration ): 0);
                k = (_local_6 - k);
                this._txt.textColor = 5787708;
            }
            else
            {
                this._txt.textColor = 13020778;
            }
            var _local_2= (k % 60);
            var _local_3= ((k - _local_2) / 60);
            var _local_4= Std.string(_local_2).split(".")[0];
            _local_4 = StringUtils._Str_22222(_local_4, 2, "0");
            var _local_5= StringUtils._Str_22222(Std.string(_local_3), 2, "0");
            this._txt.text = ((_local_5 + ":") + _local_4);
        }

        public function _Str_16501(k:VideoMetadataVo)
        {
            this._Str_7402 = k;
        }

        function _Str_4149()
        {
            this._Str_3888 = _Str_3771.rect(34, 23, 0xFF0000, 0);
            addChild(this._Str_3888);
            this._txt = new TextField();
            this._txt.width = 34;
            this._txt.height = 18;
            this._txt.y = 2;
            this._txt.selectable = false;
            var k= new TextFormat();
            k.font = "Arial";
            k.color = 13020778;
            k.size = 10;
            k.kerning = true;
            k.align = TextFormatAlign.CENTER;
            this._txt.defaultTextFormat = k;
            this._txt.text = "00:00";
            addChild(this._txt);
        }

        function _Str_1400()
        {
            mouseChildren = false;
            buttonMode = true;
            this._state = VideoTimeLabel.STATECOUNTUP;
            this._Str_4492 = 0;
            this._Str_4149();
            addEventListener(MouseEvent.CLICK, (this.onMouseClick : ASAny), false, 0, true);
        }

        function _Str_25190()
        {
            if (this._state == VideoTimeLabel.STATECOUNTUP)
            {
                this._state = VideoTimeLabel.STATECOUNTDOWN;
            }
            else
            {
                this._state = VideoTimeLabel.STATECOUNTUP;
            }
            this.update(this._Str_4492);
        }

        function onMouseClick(k:MouseEvent)
        {
            this._Str_25190();
        }
    }

