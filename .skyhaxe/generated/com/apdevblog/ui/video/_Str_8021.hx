package com.apdevblog.ui.video
;
    import flash.display.Sprite;
    import flash.display.Shape;
    import com.apdevblog.ui.video.controls._Str_9571;
    import com.apdevblog.ui.video.controls._Str_8015;
    import com.apdevblog.ui.video.controls.BtnSound;
    import com.apdevblog.ui.video.controls._Str_9222;
    import com.apdevblog.ui.video.controls.VideoTimeLabel;
    import com.apdevblog.model.vo.VideoMetadataVo;
    import com.apdevblog.utils._Str_3771;
    import flash.events.MouseEvent;
    import com.apdevblog.ui.video.controls.VideoControlsEvent;

     class _Str_8021 extends Sprite 
    {
        var _Str_16463:Int = 0;
        var _Str_3888:Shape;
        var _play:_Str_9571;
        var _bar:_Str_8015;
        var _mute:BtnSound;
        var _fullscreen:_Str_9222;
        var _time:VideoTimeLabel;
        var _Str_7402:VideoMetadataVo;

        public function new(k:Int)
        {
            super();
            this._Str_1400(k);
        }

        public function _Str_25228(k:String)
        {
            this._fullscreen._Str_3820(k);
        }

        public function _Str_17296(k:Float)
        {
            this._bar._Str_17296(k);
        }

        public function _Str_12997(k:Float)
        {
            this._bar._Str_12997(k);
            if (this._Str_7402 != null)
            {
                this._time.update((this._Str_7402.duration * k));
            }
        }

        function _Str_4149()
        {
            this._Str_3888 = _Str_3771.rect(this.width, 29, 0, 0);
            addChild(this._Str_3888);
            this._play = new _Str_9571();
            this._play.x = 0;
            this._play.y = 3;
            addChild(this._play);
            this._mute = new BtnSound();
            this._time = new VideoTimeLabel();
            this._fullscreen = new _Str_9222();
            this._bar = new _Str_8015(Std.int(this.width - ((((this._play.width + this._mute.width) + this._fullscreen.width) + this._time.width) + (4 * 3))));
            this._time.x = (((((this.width - this._fullscreen.width) - this._mute.width) - 3) - this._time.width) - 3);
            this._time.y = 3;
            this._mute.x = (((this.width - this._fullscreen.width) - this._mute.width) - 3);
            this._mute.y = 3;
            this._fullscreen.x = (this.width - this._fullscreen.width);
            this._fullscreen.y = 3;
            this._bar.x = ((this._play.x + this._play.width) + 3);
            this._bar.y = 11;
            addChild(this._bar);
            addChild(this._time);
            addChild(this._mute);
            addChild(this._fullscreen);
        }

        function _Str_1400(k:Int)
        {
            this._Str_16463 = k;
            this._Str_4149();
            addEventListener(MouseEvent.CLICK, (this.onClick : ASAny), false, 0, true);
        }

        function onClick(k:MouseEvent)
        {
            switch (k.target)
            {
                case (_ == this._play => true):
                    dispatchEvent(new VideoControlsEvent(VideoControlsEvent.TOGGLEPLAYPAUSE, true, true));
                    return;
                case (_ == this._fullscreen => true):
                    dispatchEvent(new VideoControlsEvent(VideoControlsEvent.ENTERFULLSCREEN, true, true));
                    return;

default:
            }
        }

        override public function  get_width():Float
        {
            return this._Str_16463;
        }

        override public function  set_width(k:Float):Float        {
            this._Str_16463 = Std.int(k);
            if (this._Str_3888 != null)
            {
                this._Str_3888.width = k;
                this._bar.width = k;
                this._mute.x = ((this._bar.x + this._bar.width) + 4);
            }
return k;
        }

        public var state(never,set):String;
public function  set_state(k:String):String        {
            this._play._Str_3820(k);
return k;
        }

        public var volume(never,set):Float;
public function  set_volume(k:Float):Float        {
            this._mute._Str_3820(k);
return k;
        }

        public var meta(never,set):VideoMetadataVo;
public function  set_meta(k:VideoMetadataVo):VideoMetadataVo        {
            this._Str_7402 = k;
            this._bar._Str_16501(k);
            this._time._Str_16501(k);
return k;
        }

        public var play(get,never):_Str_9571;
public function  get_play():_Str_9571
        {
            return this._play;
        }

        public var bar(get,never):_Str_8015;
public function  get_bar():_Str_8015
        {
            return this._bar;
        }

        public var mute(get,never):BtnSound;
public function  get_mute():BtnSound
        {
            return this._mute;
        }

        public var fullscreen(get,never):_Str_9222;
public function  get_fullscreen():_Str_9222
        {
            return this._fullscreen;
        }

        public var time(get,never):VideoTimeLabel;
public function  get_time():VideoTimeLabel
        {
            return this._time;
        }
    }

