package com.apdevblog.ui.video.controls
;
    import flash.display.Sprite;
    import flash.display.Shape;
    import com.apdevblog.model.vo.VideoMetadataVo;
    import flash.events.MouseEvent;
    import com.apdevblog.utils._Str_3771;
    import com.apdevblog.ui.video.controls.VideoControlsEvent;

     class _Str_8015 extends Sprite 
    {
        var _Str_6998:Shape;
        var _Str_4597:Sprite;
        var _Str_5463:Sprite;
        var _Str_2467:Float = 0;
        var _Str_9553:Sprite;
        var _Str_6953:Shape;
        var _Str_20846:Int = 0;
        var _Str_20838:Bool = false;

        public function new(k:Int)
        {
            super();
            this._Str_1400(k);
        }

        public function _Str_17296(k:Float)
        {
            this._Str_6953.scaleX = ((k <= 1) ? k : 1);
        }

        public function _Str_16501(k:VideoMetadataVo)
        {
            this._Str_2467 = k.duration;
        }

        public function _Str_12997(k:Float)
        {
            this._Str_5463.scaleX = ((k <= 1) ? k : 1);
            this._Str_9553.x = Math.fround(this._Str_5463.width);
        }

        function _Str_20378()
        {
            if (this._Str_4597 != null)
            {
                this._Str_4597.removeEventListener(MouseEvent.CLICK, (this._Str_20897 : ASAny));
                removeChild(this._Str_4597);
                this._Str_4597 = null;
            }
            if (this._Str_6953 != null)
            {
                removeChild(this._Str_6953);
                this._Str_6953 = null;
            }
            if (this._Str_5463 != null)
            {
                removeChild(this._Str_5463);
                this._Str_5463 = null;
            }
            this._Str_4597 = new Sprite();
            this._Str_4597.buttonMode = true;
            this._Str_4597.addChild(_Str_3771.rect(this._Str_6998.width, 5, 5787708, 1));
            this._Str_4597.addEventListener(MouseEvent.MOUSE_DOWN, (this._Str_20897 : ASAny), false, 0, true);
            addChild(this._Str_4597);
            this._Str_6953 = _Str_3771.rect(this._Str_6998.width, 5, 0xFF0000, 1);
            addChild(this._Str_6953);
            this._Str_4597.mask = this._Str_6953;
            this._Str_5463 = new Sprite();
            this._Str_5463.mouseEnabled = false;
            this._Str_5463.addChild(_Str_3771.rect(this._Str_6998.width, 5, 13020778, 1));
            addChild(this._Str_5463);
            this._Str_6953.scaleX = 0;
            this._Str_5463.scaleX = 0;
        }

        function _Str_4149()
        {
            this._Str_6998 = _Str_3771.rect(this._Str_20846, 5, 5787708, 0.5);
            addChild(this._Str_6998);
            this._Str_20378();
            this._Str_9553 = new Sprite();
            this._Str_9553.mouseEnabled = false;
            this._Str_9553.addChild(_Str_3771.rect(5, 11, 0, 0.2, -2, -3));
            this._Str_9553.addChild(_Str_3771.rect(3, 9, 0xFFFFFF, 1, -1, -2));
            addChild(this._Str_9553);
        }

        function _Str_1400(k:Int)
        {
            this._Str_20846 = k;
            this._Str_4149();
        }

        function _Str_16616(k:Bool)
        {
            var _local_3:VideoControlsEvent = null;
            if (!this._Str_18989)
            {
                return;
            }
            var _local_2= ((this._Str_4597.mouseX * this._Str_4597.scaleX) / this._Str_4597.width);
            if (k)
            {
                _local_3 = new VideoControlsEvent(VideoControlsEvent.SCRUB, true, true, _local_2);
            }
            else
            {
                _local_3 = new VideoControlsEvent(VideoControlsEvent.SEEK, true, true, _local_2);
            }
            dispatchEvent(_local_3);
        }

        function _Str_20897(k:MouseEvent)
        {
            dispatchEvent(new VideoControlsEvent(VideoControlsEvent.TOGGLEPLAYPAUSE, true, true, false));
            this._Str_16616(false);
            stage.addEventListener(MouseEvent.MOUSE_UP, (this._Str_712 : ASAny), false, 0, true);
            stage.addEventListener(MouseEvent.MOUSE_MOVE, (this._Str_4955 : ASAny), false, 0, true);
        }

        function _Str_4955(k:MouseEvent)
        {
            this._Str_16616(true);
        }

        function _Str_712(k:MouseEvent)
        {
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, (this._Str_4955 : ASAny));
            stage.removeEventListener(MouseEvent.MOUSE_UP, (this._Str_712 : ASAny));
            this._Str_16616(false);
            dispatchEvent(new VideoControlsEvent(VideoControlsEvent.TOGGLEPLAYPAUSE, true, true, true));
        }

        override public function  set_width(k:Float):Float        {
            this._Str_6998.width = k;
            this._Str_20378();
return k;
        }

        override public function  get_width():Float
        {
            return this._Str_6998.width;
        }

        
        public var _Str_18989(get,set):Bool;
public function  get__Str_18989():Bool
        {
            return this._Str_20838;
        }
public function  set__Str_18989(k:Bool):Bool        {
            return this._Str_20838 = k;
        }
    }

