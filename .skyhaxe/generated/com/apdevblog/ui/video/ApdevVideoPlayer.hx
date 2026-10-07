package com.apdevblog.ui.video
;
    import flash.display.Sprite;
    import flash.media.Video;
    import flash.net.NetConnection;
    import flash.net.NetStream;
    import flash.utils.Timer;
    import com.apdevblog.model.vo.VideoMetadataVo;
    import flash.display.DisplayObjectContainer;
    import com.apdevblog.ui.video.controls.ImageOverlay;
    import com.apdevblog.ui.video.controls.VideoControlsEvent;
    import com.apdevblog.utils._Str_3771;
    import flash.events.TimerEvent;
    import flash.events.NetStatusEvent;
    import flash.events.SecurityErrorEvent;
    import flash.events.AsyncErrorEvent;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.FullScreenEvent;
    import flash.display.Stage;
    import flash.display.StageAlign;
    import flash.events.ErrorEvent;
    import flash.media.SoundMixer;
    import flash.media.SoundTransform;
    import flash.net.URLRequest;

     class ApdevVideoPlayer extends Sprite 
    {
        public static inline final MIN_SIZE= 140;
        public static inline final _Str_17157= 2000;

        var _Str_5336:Sprite;
        var _Str_3878:Video;
        var _Str_8304:NetConnection;
        var _Str_3167:NetStream;
        var _Str_13484:Timer;
        var _Str_8436:Timer;
        var _Str_11229:String;
        var _offset:Float = Math.NaN;
        var _Str_23145:Float = Math.NaN;
        var _Str_11271:Int = 0;
        var _Str_16691:String;
        var _autoPlay:Bool = false;
        var _Str_4218:Bool = false;
        var _Str_22687:Float = Math.NaN;
        var _Str_8940:String;
        var _Str_21382:VideoMetadataVo;
        var _Str_3319:_Str_8021;
        var _volume:Float = Math.NaN;
        var _Str_4901:Int = 0;
        var _Str_4960:Int = 0;
        var _Str_18277:Bool = false;
        var _Str_11808:Bool = false;
        var _Str_20793:Bool = false;
        var _Str_16161:Bool = false;
        var _Str_18354:Bool = false;
        var _Str_19047:String;
        var _Str_6957:Float = Math.NaN;
        var _Str_6961:Float = Math.NaN;
        var _Str_20927:DisplayObjectContainer;
        var _Str_19777:Int = 0;
        var _Str_12093:Timer;
        var _Str_19802:Int = 0;
        var _Str_8247:ASAny;
        var _image:ImageOverlay;
        var _Str_18114:Bool = false;

        public function new(k:Int, _arg_2:Int)
        {
            super();
            this._Str_1400(k, _arg_2);
        }

        public function clear()
        {
            this.pause();
            this._Str_3878.clear();
            this._Str_3167.close();
            this._Str_3878.attachNetStream(null);
            this._Str_3878.visible = false;
            this._Str_3404 = _Str_2872.VIDEOSTATEEMPTY;
        }

        public function load(k:String)
        {
            if (k == null)
            {
                return;
            }
            this._Str_4245 = null;
            this._Str_11229 = k;
            if ((this._autoPlay || this._Str_18114))
            {
                this._Str_3167.play([k]);
                this._Str_3878.attachNetStream(this._Str_3167);
                this._Str_3878.visible = true;
                this._Str_4218 = true;
                this._Str_13484.start();
                this._Str_8436.start();
                this._image.visible = false;
            }
        }

        public function pause()
        {
            if (!this._Str_4218)
            {
                return;
            }
            this._Str_3167.pause();
            this._Str_8436.reset();
            this._Str_3404 = _Str_2872.VIDEOSTATEPAUSED;
            dispatchEvent(new VideoControlsEvent(_Str_2872.VIDEOSTATEPAUSED));
        }

        public function play()
        {
            if (!this._Str_4218)
            {
                this._Str_18114 = true;
                this.load(this._Str_11229);
                return;
            }
            this._image.visible = false;
            this._Str_3167.resume();
            this._Str_8436.start();
            this._Str_3404 = _Str_2872.VIDEOSTATEPLAYING;
        }

        public function seek(k:Float, _arg_2:Bool=false)
        {
            if (k < 0)
            {
                k = 0;
            }
            if (k > (this._Str_3167.bytesLoaded / this._Str_3167.bytesTotal))
            {
                k = (this._Str_3167.bytesLoaded / this._Str_3167.bytesTotal);
            }
            if (!_arg_2)
            {
                this._Str_11271 = 0;
            }
            else
            {
                this._Str_11271++;
            }
            if (this._Str_11271 == 1)
            {
                this._Str_16691 = this._Str_3404;
                if (((this._Str_3404 == _Str_2872.VIDEOSTATEPLAYING) || (this._Str_3404 == _Str_2872.VIDEOSTATESTOPPED)))
                {
                    this.pause();
                }
            }
            this._Str_3167.seek((k * this._Str_4245.duration));
            this._Str_3319._Str_12997(k);
            if (!_arg_2)
            {
                if (((this._Str_16691 == _Str_2872.VIDEOSTATEPLAYING) || (this._Str_16691 == _Str_2872.VIDEOSTATESTOPPED)))
                {
                    this.play();
                }
            }
        }

        public function getPosition():Float
        {
            var k:Float = 0;
            if (((!(this._Str_3167 == null)) && (!(this._Str_4245 == null))))
            {
                k = (this._Str_3167.time / this._Str_4245.duration);
            }
            return k;
        }

        public function _Str_26444(k:ASObject)
        {
            if (this._Str_4245 == null)
            {
                this._Str_4245 = new VideoMetadataVo(k);
                if (((!Math.isNaN(this._Str_4245.width)) && (!Math.isNaN(this._Str_4245.height))))
                {
                    this._Str_16733(this._Str_4901, this._Str_4960);
                }
            }
        }

        function _Str_4149()
        {
            this._Str_5336 = new Sprite();
            this._Str_5336.addChild(_Str_3771._Str_13333(this._Str_9635, this._Str_5932, 90, 3748644, 0, 1, 1));
            addChild(this._Str_5336);
            this._Str_3878 = new Video(this._Str_9635, this._Str_5932);
            this._Str_3878.smoothing = true;
            addChild(this._Str_3878);
            this._Str_3319 = new _Str_8021(this._Str_9635);
            this._Str_14540 = false;
            addChild(this._Str_3319);
            this._image = new ImageOverlay(this._Str_9635, this._Str_5932);
            this._image.visible = false;
            addChild(this._image);
        }

        function _Str_1400(k:Int, _arg_2:Int)
        {
            var _local_3 = Math.NaN;
            this._Str_22687 = 0;
            this._offset = 0;
            this._Str_23145 = 0;
            this._Str_11271 = 0;
            this._autoPlay = false;
            this._Str_18114 = false;
            this._Str_18354 = (this._Str_16161 = false);
            if (k < ApdevVideoPlayer.MIN_SIZE)
            {
                _local_3 = ((_arg_2 > 0) ? (k / _arg_2) : (4 / 3));
                this._Str_4901 = ApdevVideoPlayer.MIN_SIZE;
                this._Str_4960 = Std.int(ApdevVideoPlayer.MIN_SIZE / _local_3);
            }
            else
            {
                this._Str_4901 = k;
                this._Str_4960 = _arg_2;
            }
            this._Str_4149();
            this._Str_3404 = _Str_2872.VIDEOSTATEEMPTY;
            this._Str_13484 = new Timer(500);
            this._Str_13484.addEventListener(TimerEvent.TIMER, (this._Str_22266 : ASAny), false, 0, true);
            this._Str_8436 = new Timer(100);
            this._Str_8436.addEventListener(TimerEvent.TIMER, (this._Str_23017 : ASAny), false, 0, true);
            this._Str_16581 = ApdevVideoPlayer._Str_17157;
            this._Str_12093 = new Timer(this._Str_16581, 1);
            this._Str_12093.addEventListener(TimerEvent.TIMER_COMPLETE, (this._Str_24752 : ASAny), false, 0, true);
            this._Str_8304 = new NetConnection();
            this._Str_8304.addEventListener(NetStatusEvent.NET_STATUS, (this._Str_20451 : ASAny), false, 0, true);
            this._Str_8304.addEventListener(SecurityErrorEvent.SECURITY_ERROR, (this.onError : ASAny), false, 0, true);
            this._Str_8304.addEventListener(AsyncErrorEvent.ASYNC_ERROR, (this.onError : ASAny), false, 0, true);
            this._Str_8304.connect(null);
            addEventListener(VideoControlsEvent.SEEK, (this._Str_21626 : ASAny), false, 0, true);
            addEventListener(VideoControlsEvent.SCRUB, (this._Str_21626 : ASAny), false, 0, true);
            addEventListener(VideoControlsEvent.TOGGLEPLAYPAUSE, (this._Str_23562 : ASAny), false, 0, true);
            addEventListener(VideoControlsEvent.SETVOLUME, (this._Str_23756 : ASAny), false, 0, true);
            addEventListener(VideoControlsEvent.ENTERFULLSCREEN, (this._Str_23232 : ASAny), false, 0, true);
            this._Str_5336.buttonMode = true;
            this._Str_5336.doubleClickEnabled = true;
            this._Str_5336.addEventListener(MouseEvent.CLICK, (this._Str_23822 : ASAny), false, 0, true);
            addEventListener(MouseEvent.MOUSE_OVER, (this.onMouseOver : ASAny), false, 0, true);
            addEventListener(MouseEvent.MOUSE_OUT, (this.onMouseOut : ASAny), false, 0, true);
            addEventListener(Event.ADDED_TO_STAGE, (this.onAddedToStage : ASAny), false, 0, true);
        }

        function _Str_23773()
        {
            this._Str_3167 = new NetStream(this._Str_8304);
            this._Str_3167.addEventListener(NetStatusEvent.NET_STATUS, (this._Str_20451 : ASAny), false, 0, true);
            this._Str_3167.addEventListener(IOErrorEvent.IO_ERROR, (this.onError : ASAny), false, 0, true);
            this._Str_3167.addEventListener(AsyncErrorEvent.ASYNC_ERROR, (this._Str_23806 : ASAny), false, 0, true);
            this._Str_3167.bufferTime = 5;
            this._Str_3167.client = this;
        }

        function _Str_16733(k:Float, _arg_2:Float)
        {
            var _local_3= (this._Str_4245.width / this._Str_4245.height);
            var _local_4= (k / _arg_2);
            if (_local_3 > _local_4)
            {
                this._Str_3878.width = k;
                this._Str_3878.height = (k / _local_3);
            }
            else
            {
                this._Str_3878.width = (_arg_2 * _local_3);
                this._Str_3878.height = _arg_2;
            }
            this._Str_3878.x = Math.fround(((k - this._Str_3878.width) * 0.5));
            this._Str_3878.y = Math.fround(((_arg_2 - this._Str_3878.height) * 0.5));
        }

        function _Str_25359()
        {
            if (this._Str_4245 == null)
            {
                return;
            }
            if (stage.displayState == "normal")
            {
                this._Str_18354 = this._Str_11185;
                this._Str_11185 = true;
                stage.displayState = "fullScreen";
            }
            else
            {
                stage.displayState = "normal";
            }
        }

        function _Str_19602()
        {
            if (this._Str_3404 == _Str_2872.VIDEOSTATEPLAYING)
            {
                this.pause();
            }
            else
            {
                if (((this._Str_3404 == _Str_2872.VIDEOSTATEPAUSED) || (this._Str_3404 == _Str_2872.VIDEOSTATEEMPTY)))
                {
                    this.play();
                }
                else
                {
                    if (this._Str_3404 == _Str_2872.VIDEOSTATESTOPPED)
                    {
                        this.seek(0);
                        this.play();
                    }
                }
            }
        }

        function _Str_7366(k:Bool)
        {
            this._Str_3319.visible = k;
        }

        function onAddedToStage(k:Event)
        {
            removeEventListener(Event.ADDED_TO_STAGE, (this.onAddedToStage : ASAny));
            stage.addEventListener(FullScreenEvent.FULL_SCREEN, (this._Str_22420 : ASAny), false, 0, true);
        }

        function _Str_23756(k:VideoControlsEvent)
        {
            this.volume = ASCompat.asNumber(k.data );
        }

        function _Str_23822(k:MouseEvent)
        {
            this._Str_19602();
        }

        function _Str_22420(k:FullScreenEvent)
        {
            var _local_2:Stage = null;
            if (!this._Str_11185)
            {
                return;
            }
            this._Str_3319._Str_25228(stage.displayState);
            if (k.fullScreen)
            {
                this._Str_19047 = stage.align;
                stage.align = StageAlign.TOP_LEFT;
                this._Str_6957 = x;
                this._Str_6961 = y;
                x = 0;
                y = 0;
                _local_2 = stage;
                this._Str_20927 = parent;
                this._Str_19777 = parent.getChildIndex(this);
                parent.removeChild(this);
                _local_2.addChild(this);
                this._Str_5336.width = stage.stageWidth;
                this._Str_5336.height = stage.stageHeight;
                this._Str_16733(stage.stageWidth, stage.stageHeight);
                this._Str_20793 = this._Str_11762;
                this._Str_11762 = true;
                this._Str_3319.x = Math.fround(((stage.stageWidth - this._Str_3319.width) * 0.5));
                this._Str_3319.y = Math.fround(((stage.stageHeight - this._Str_3319.height) - 100));
                stage.addEventListener(MouseEvent.MOUSE_MOVE, (this._Str_4955 : ASAny), false, 0, true);
            }
            else
            {
                this._Str_5336.width = this._Str_4901;
                this._Str_5336.height = this._Str_4960;
                this._Str_16733(this._Str_9635, this._Str_5932);
                stage.align = this._Str_19047;
                x = this._Str_6957;
                y = this._Str_6961;
                stage.removeChild(this);
                this._Str_20927.addChildAt(this, this._Str_19777);
                this._Str_11185 = this._Str_18354;
                this._Str_11762 = this._Str_20793;
                this._Str_3319.x = 0;
                if (this._Str_14540)
                {
                    this._Str_3319.y = (this._Str_5932 - this._Str_3319.height);
                }
                else
                {
                    this._Str_3319.y = this._Str_5932;
                }
                stage.removeEventListener(MouseEvent.MOUSE_MOVE, (this._Str_4955 : ASAny));
                this._Str_12093.reset();
                this._Str_7366(true);
            }
        }

        function _Str_23232(k:VideoControlsEvent)
        {
            this._Str_25359();
        }

        function _Str_24752(k:TimerEvent)
        {
            this._Str_7366(false);
        }

        function _Str_4955(k:MouseEvent)
        {
            this._Str_7366(true);
            this._Str_12093.reset();
            this._Str_12093.start();
        }

        public function _Str_25969(k:ASAny)
        {
        }

        function onMouseOut(k:MouseEvent)
        {
            if (this._Str_11808)
            {
                this._Str_7366(false);
            }
        }

        function onMouseOver(k:MouseEvent)
        {
            if (this._Str_11808)
            {
                this._Str_7366(true);
            }
        }

        function _Str_23562(k:VideoControlsEvent)
        {
            if (k.cancelable)
            {
                k.stopImmediatePropagation();
            }
            this._Str_19602();
        }

        function _Str_21626(k:VideoControlsEvent)
        {
            if (k.cancelable)
            {
                k.stopImmediatePropagation();
            }
            this.seek(ASCompat.asNumber(k.data ), (k.type == VideoControlsEvent.SCRUB));
        }

        function _Str_23806(k:ErrorEvent)
        {
        }

        function onError(k:ErrorEvent)
        {
        }

        function _Str_22266(k:TimerEvent)
        {
            if (this._Str_3167 != null)
            {
                this._Str_3319._Str_17296((this._Str_3167.bytesLoaded / this._Str_3167.bytesTotal));
                if (this._Str_3167.bytesLoaded >= this._Str_3167.bytesTotal)
                {
                    this._Str_13484.reset();
                }
            }
        }

        function _Str_20451(k:NetStatusEvent)
        {
            switch (ASCompat.getDynamicProperty(k.info, "code"))
            {
                case "NetStream.Play.Start":
                    if (this._Str_3404 != _Str_2872.VIDEOSTATEPAUSED)
                    {
                        this._Str_3404 = _Str_2872.VIDEOSTATEPLAYING;
                    }
                    return;
                case "NetStream.Play.Stop":
                    this._Str_3404 = _Str_2872.VIDEOSTATESTOPPED;
                    return;
                case "NetConnection.Connect.Success":
                    this._Str_23773();
                    return;
                case "NetConnection.Connect.Failed":
                    return;
            }
        }

        public function _Str_26358(k:ASObject)
        {
            if (this._Str_3404 == _Str_2872.VIDEOSTATESTOPPED)
            {
            }
        }

        function _Str_23017(k:TimerEvent)
        {
            if (this._Str_4245 == null)
            {
                return;
            }
            this._Str_3319._Str_12997((this._Str_3167.time / this._Str_4245.duration));
            if (this._Str_3404 == _Str_2872.VIDEOSTATESTOPPED)
            {
                this._Str_8436.reset();
            }
        }

        
        public var _Str_4245(get,set):VideoMetadataVo;
public function  get__Str_4245():VideoMetadataVo
        {
            return this._Str_21382;
        }
public function  set__Str_4245(k:VideoMetadataVo):VideoMetadataVo        {
            this._Str_21382 = k;
            if (k != null)
            {
                this._Str_3319.meta = k;
            }
return k;
        }

        
        public var _Str_3404(get,set):String;
public function  get__Str_3404():String
        {
            return this._Str_8940;
        }
public function  set__Str_3404(k:String):String        {
            this._Str_8940 = k;
            if (this._Str_3167 != null)
            {
                this._Str_3319.state = k;
            }
            dispatchEvent(new VideoControlsEvent(VideoControlsEvent.STATEUPDATE, true, true, k));
return k;
        }

        
        public var volume(get,set):Float;
public function  get_volume():Float
        {
            return this._volume;
        }
public function  set_volume(k:Float):Float        {
            this._volume = k;
            SoundMixer.soundTransform = new SoundTransform(k);
            return this._Str_3319.volume = k;
        }

        
        public var _Str_9635(get,set):Int;
public function  get__Str_9635():Int
        {
            return this._Str_4901;
        }
public function  set__Str_9635(k:Int):Int        {
            return this._Str_4901 = k;
        }

        
        public var _Str_5932(get,set):Int;
public function  get__Str_5932():Int
        {
            return this._Str_4960;
        }
public function  set__Str_5932(k:Int):Int        {
            return this._Str_4960 = k;
        }

        
        public var _Str_14540(get,set):Bool;
public function  get__Str_14540():Bool
        {
            return this._Str_18277;
        }
public function  set__Str_14540(k:Bool):Bool        {
            this._Str_18277 = k;
            if (this._Str_18277)
            {
                this._Str_3319.y = (this._Str_5932 - this._Str_3319.height);
            }
            else
            {
                this._Str_3319.y = this._Str_5932;
            }
return k;
        }

        
        public var autoPlay(get,set):Bool;
public function  get_autoPlay():Bool
        {
            return this._autoPlay;
        }
public function  set_autoPlay(k:Bool):Bool        {
            return this._autoPlay = k;
        }

        
        public var _Str_11762(get,set):Bool;
public function  get__Str_11762():Bool
        {
            return this._Str_11808;
        }
public function  set__Str_11762(k:Bool):Bool        {
            this._Str_11808 = k;
            if (this._Str_11808)
            {
                this._Str_7366(false);
            }
            else
            {
                this._Str_7366(true);
            }
return k;
        }

        
        public var _Str_11185(get,set):Bool;
public function  get__Str_11185():Bool
        {
            return this._Str_16161;
        }
public function  set__Str_11185(k:Bool):Bool        {
            return this._Str_16161 = k;
        }

        
        public var _Str_16581(get,set):Int;
public function  get__Str_16581():Int
        {
            return this._Str_19802;
        }
public function  set__Str_16581(k:Int):Int        {
            return this._Str_19802 = k;
        }

        
        public var _Str_20925(get,set):ASAny;
public function  get__Str_20925():ASAny
        {
            return this._Str_8247;
        }
public function  set__Str_20925(k:ASAny):ASAny        {
            var _local_2:URLRequest = null;
            if (k == null)
            {
                return k;
            }
            this._Str_8247 = k;
            if (this._Str_3404 == _Str_2872.VIDEOSTATEEMPTY)
            {
                this._image.visible = true;
                if (Std.is(this._Str_8247 , URLRequest))
                {
                    this._image.load(this._Str_8247);
                }
                else
                {
                    if (Std.is(this._Str_8247 , String))
                    {
                        _local_2 = new URLRequest(this._Str_8247);
                        this._image.load(_local_2);
                    }
                }
            }
return k;
        }

        public var _Str_17422(get,never):_Str_8021;
public function  get__Str_17422():_Str_8021
        {
            return this._Str_3319;
        }
    }

