package snowwar.ui
;
	import com.sulake.core.runtime.IDisposable;
	import com.sulake.habbo.sound.HabboSoundTypesEnum;
	import com.sulake.core.window.IWindow;
	import com.sulake.core.window.IWindowContainer;
	import com.sulake.core.assets.BitmapDataAsset;
	import com.sulake.habbo.avatar._enum.AvatarScaleType;
	import com.sulake.habbo.avatar._enum.AvatarSetType;
	import com.sulake.habbo.game.WindowUtils;
	import com.sulake.habbo.avatar.IAvatarImageListener;
	import snowwar._str_254.SnowWarAnimatedWindowElement;
	import com.sulake.core.window.events.WindowMouseEvent;
	import snowwar._str_373._SafeStr_3665;
	import com.sulake.core.window.components.IBitmapWrapperWindow;
	import com.sulake.habbo.session.SecurityLevelEnum;
	import flash.display.BitmapData;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import snowwar.SnowWarEngine;

     class SnowWarUI implements IDisposable implements  IAvatarImageListener 
    {
        static inline final _SafeStr_22085= 4;
        static inline final _SafeStr_22086= 75;
        static inline final _SafeStr_22087= 4;
        static inline final _SafeStr_22088= 50;
        static inline final _SafeStr_22089= 5;
        static inline final _SafeStr_22090= 5;

        var _snowWarEngine:SnowWarEngine;
        var _exit:IWindowContainer;
        var _snowballs:IWindowContainer;
        var _ownStats:IWindowContainer;
        var _timer:IWindowContainer;
        var _teamScores:IWindowContainer;
        var _SafeStr_22094:IWindowContainer;
        var _indicatorForgroundColor:RGBColor;
        var _indicatorBackgroundColor:RGBColor;
        var _counter:IBitmapWrapperWindow;
        var _SafeStr_5041:Bool = false;
        var _SafeStr_12657:Int = 1;
        var _SafeStr_13145:UInt = 0;
        var _SafeStr_22098:Int = -1;
        var _SafeStr_22099:Int = 5;
        var _makeSnowballImage:IBitmapWrapperWindow;
        var _SafeStr_22101:Bool = false;
        var _SafeStr_22102:Int = 5;
        var _ballProgress:IBitmapWrapperWindow;
        var _SafeStr_22104:SnowWarAnimatedWindowElement;
        var _emptyFlashImage:IBitmapWrapperWindow;
        var _uiNoBalls:SnowWarAnimatedWindowElement;
        var _backgroundFlashImage:IBitmapWrapperWindow;
        var _SafeStr_22108:Int = 0;
        var _SafeStr_22109:String = "";
        var _SafeStr_22110:Timer;
        var _hasChecksumIndicator:Bool = false;

        public function new(k:SnowWarEngine)
        {
            this._snowWarEngine = k;
            this._snowWarEngine.windowManager.getDesktop(1).visible = false;
            this._hasChecksumIndicator = this._snowWarEngine.sessionDataManager.hasSecurity(SecurityLevelEnum.EMPLOYEE);
            if (true)
            {
                this._indicatorForgroundColor = new RGBColor();
                this._indicatorBackgroundColor = new RGBColor(0xFFFFFF);
            }
        }

        public function dispose()
        {
            this._snowWarEngine.windowManager.getDesktop(1).visible = true;
            this._snowWarEngine = null;
            if (this._exit != null)
            {
                this._exit.dispose();
                this._exit = null;
            }
            if (this._snowballs != null)
            {
                this._makeSnowballImage = null;
                this._ballProgress = null;
                this._emptyFlashImage = null;
                this._snowballs.dispose();
                this._snowballs = null;
            }
            if (this._ownStats != null)
            {
                this._backgroundFlashImage = null;
                this._ownStats.dispose();
                this._ownStats = null;
            }
            if (this._timer != null)
            {
                this._timer.dispose();
                this._timer = null;
            }
            if (this._teamScores != null)
            {
                this._teamScores.dispose();
                this._teamScores = null;
            }
            if (this._counter != null)
            {
                this._counter.dispose();
                this._counter = null;
            }
            if (this._uiNoBalls != null)
            {
                this._uiNoBalls.dispose();
                this._uiNoBalls = null;
            }
            if (this._SafeStr_22094 != null)
            {
                this._SafeStr_22094.dispose();
                this._SafeStr_22094 = null;
            }
            if (this._SafeStr_22110 != null)
            {
                this._SafeStr_22110.removeEventListener(TimerEvent.TIMER_COMPLETE, (this.onTimerComplete : ASAny));
                this._SafeStr_22110.stop();
                this._SafeStr_22110 = null;
            }
            this._SafeStr_22116();
            this._SafeStr_5041 = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._SafeStr_5041;
        }

        public function init()
        {
            this._exit = Std.downcast(WindowUtils.createWindow("snowwar_exit") , IWindowContainer);
            this._exit.addEventListener(WindowMouseEvent.CLICK, this._SafeStr_22112);
            this._exit.x = 0;
            this._exit.y = 10;
			
            this._snowballs = Std.downcast(WindowUtils.createWindow("snowwar_snowballs") , IWindowContainer);
            var k= this._snowballs.findChildByName("make_snowball");
            k.addEventListener(WindowMouseEvent.DOWN, this.onButtonDownEvent);
            k.addEventListener(WindowMouseEvent.UP, this.onButtonUpEvent);
            k.addEventListener(WindowMouseEvent.OUT, this.onButtonUpEvent);
            this._snowballs.center();
            this._snowballs.x = 10;
			
            this._makeSnowballImage = Std.downcast(this._snowballs.findChildByName("makeSnowballImage") , IBitmapWrapperWindow);
			
            this._emptyFlashImage = Std.downcast(this._snowballs.findChildByName("emptyFlashImage") , IBitmapWrapperWindow);
            this._emptyFlashImage.visible = false;
			
            this._uiNoBalls = new SnowWarAnimatedWindowElement(this._snowWarEngine.assets, this._emptyFlashImage, "ui_no_balls_", _SafeStr_22085, _SafeStr_22086, true);
			
            this._ballProgress = Std.downcast(this._snowballs.findChildByName("ballProgress") , IBitmapWrapperWindow);
			
            this._ownStats = Std.downcast(WindowUtils.createWindow("snowwar_own_stats") , IWindowContainer);
            this._ownStats.x = 10;
            this._ownStats.y = ((this._ownStats.desktop.height - this._ownStats.height) - 10);
			
            this._backgroundFlashImage = Std.downcast(this._ownStats.findChildByName("backgroundFlashImage") , IBitmapWrapperWindow);
            this._SafeStr_22115();
            this._teamScores = Std.downcast(WindowUtils.createWindow("snowwar_team_scores") , IWindowContainer);
            this._teamScores.x = ((this._teamScores.desktop.width - this._teamScores.width) - 10);
            this._teamScores.y = 10;
            this._timer = Std.downcast(WindowUtils.createWindow("snowwar_timer") , IWindowContainer);
            this._timer.x = ((this._timer.desktop.width - this._timer.width) - 50);
            this._timer.y = 105;
            this._SafeStr_18740 = 0;
            this._counter = Std.downcast(WindowUtils.createWindow("counter") , IBitmapWrapperWindow);
            this._counter.center();
            if (true)
            {
                this._timer.getChildByName("checksumIndicator").visible = true;
                this._indicatorForgroundColor.fromInt(this._timer.color);
            }
            this._SafeStr_22099 = _SafeStr_22090;
        }

        public function avatarImageReady(k:String)
        {
            this._SafeStr_22115();
        }

        function _SafeStr_22115()
        {
            var k:BitmapData = null;
            var _local_2= this._snowWarEngine.sessionDataManager.figure;
            var _local_3= this._snowWarEngine.sessionDataManager.gender;
            var _local_4= this._snowWarEngine.avatarRenderManager.createAvatarImage(_local_2, AvatarScaleType.LARGE, _local_3, this);
            if (_local_4 != null)
            {
                _local_4.setDirection(AvatarSetType.FULL, 2);
k = _local_4.getCroppedImage(AvatarSetType.HEAD);
                _local_4.dispose();
                WindowUtils.setElementImage(this._ownStats.findChildByName("user_image"), k);
                k.dispose();
            }
        }

        function _SafeStr_12987(k:String):BitmapData
        {
            return ASCompat.dynamicAs(this._snowWarEngine.assets.getAssetByName(k).content , BitmapData);
        }

        function _SafeStr_18800(k:IWindowContainer, _arg_2:String):IWindow
        {
            return k.findChildByName(_arg_2);
        }

        function onButtonDownEvent(k:WindowMouseEvent)
        {
            this._SafeStr_22123(true);
            if (this._snowWarEngine._SafeStr_13194())
            {
                this._SafeStr_13237();
            }
        }

        function onButtonUpEvent(k:WindowMouseEvent)
        {
            this._SafeStr_22123(false);
        }

        public function _SafeStr_13237()
        {
            if (this._SafeStr_22104 != null)
            {
                this._SafeStr_22104.dispose();
                this._SafeStr_22104 = null;
            }
            this._SafeStr_22104 = new SnowWarAnimatedWindowElement(this._snowWarEngine.assets, this._ballProgress, "load_", 8);
            SnowWarEngine.playSound(HabboSoundTypesEnum.GAMES_SW_MAKE_SNOWBALL);
        }

        public function _SafeStr_13225()
        {
            this._SafeStr_22116();
            SnowWarEngine.stopSound(HabboSoundTypesEnum.GAMES_SW_MAKE_SNOWBALL);
            if (this._SafeStr_22101)
            {
                this.onButtonDownEvent(null);
            }
        }

        function _SafeStr_22116()
        {
            if (this._SafeStr_22104 != null)
            {
                this._SafeStr_22104.dispose();
                this._SafeStr_22104 = null;
            }
        }

        function _SafeStr_22112(k:WindowMouseEvent)
        {
            if (this._SafeStr_22094 == null)
            {
                this._SafeStr_22094 = Std.downcast(WindowUtils.createWindow("snowwar_exit_confirmation") , IWindowContainer);
                this._SafeStr_22094.findChildByName("yes").addEventListener(WindowMouseEvent.CLICK, this.onSnowWarExitConfirmationWindowClicked);
                this._SafeStr_22094.findChildByName("no").addEventListener(WindowMouseEvent.CLICK, this.onSnowWarExitConfirmationWindowClicked);
                this._SafeStr_22094.findChildByTag("close").addEventListener(WindowMouseEvent.CLICK, this.onSnowWarExitConfirmationWindowClicked);
            }
            else
            {
                this._SafeStr_22094.visible = true;
                this._SafeStr_22094.activate();
            }
        }

        function onSnowWarExitConfirmationWindowClicked(k:WindowMouseEvent)
        {
            if (k.window.name == "yes")
            {
                this._snowWarEngine.send(new _SafeStr_3665());
                this._snowWarEngine.onStageEnding();
                this._snowWarEngine._SafeStr_13209();
            }
            else
            {
                this._SafeStr_22094.visible = false;
            }
        }

        public var _SafeStr_18742(never,set):Int;
public function  set__SafeStr_18742(k:Int):Int        {
            var _local_2 = 0;
            while (_local_2 < _SafeStr_22089)
            {
                this._snowballs.findChildByName(("ball_" + Std.string(_local_2))).visible = (_local_2 < k);
                _local_2++;
            }
            this._SafeStr_22102 = k;
            var _local_3= this._snowballs.findChildByName(("ball_" + Std.string(k)));
            if (_local_3 != null)
            {
                this._ballProgress.x = _local_3.x;
                this._ballProgress.y = _local_3.y;
            }
return k;
        }

        public var _SafeStr_18741(never,set):Int;
public function  set__SafeStr_18741(k:Int):Int        {
            WindowUtils._Str_4180(this._ownStats.findChildByName("personal_score"), Std.string(k));
return k;
        }

        public var _SafeStr_18740(never,set):Int;
public function  set__SafeStr_18740(k:Int):Int        {
            if (this._hasChecksumIndicator)
            {
                if (this._indicatorForgroundColor != null)
                {
                    this._indicatorForgroundColor.tweenTo(this._indicatorBackgroundColor);
                    this._timer.getChildByName("checksumIndicator").color = this._indicatorForgroundColor.rgb;
                }
            }
            if (this._SafeStr_22098 == k)
            {
                return k;
            }
            this._SafeStr_22098 = k;
            var _local_2= ("" + Std.string(Std.int((k / 60))));
            var _local_3= ("" + Std.string(k % 60));
            if (ASCompat.toInt(_local_2) < 10)
            {
                _local_2 = ("0" + _local_2);
            }
            if (ASCompat.toInt(_local_3) < 10)
            {
                _local_3 = ("0" + _local_3);
            }
            WindowUtils._Str_26291(this._timer, "time_left");
            WindowUtils._Str_4180(this._timer.findChildByName("time_left"), ((_local_2 + ":") + _local_3));
            if (((k <= 5) && (k > 0)))
            {
                SnowWarEngine.playSound(HabboSoundTypesEnum.CALL_FOR_HELP);
                if (this._SafeStr_22110 == null)
                {
                    this._SafeStr_22110 = new Timer(500, 1);
                    this._SafeStr_22110.addEventListener(TimerEvent.TIMER_COMPLETE, (this.onTimerComplete : ASAny));
                }
                this._SafeStr_22110.reset();
                this._SafeStr_22110.start();
            }
return k;
        }

        function onTimerComplete(k:TimerEvent)
        {
            if (this._timer != null)
            {
                WindowUtils._Str_26294(this._timer, "time_left");
            }
        }

        public var _SafeStr_12584(never,set):Int;
public function  set__SafeStr_12584(k:Int):Int        {
            if (this._SafeStr_22099 != k)
            {
                WindowUtils.setElementImage(this._SafeStr_18800(this._ownStats, "energy_bar"), this._SafeStr_12987(("ui_me_health_" + Std.string(k))));
                this._SafeStr_22099 = k;
            }
return k;
        }

        public function setChecksumIndicatorColor(k:UInt)
        {
            if (this._hasChecksumIndicator)
            {
                this._timer.color = k;
                if (this._indicatorForgroundColor != null)
                {
                    this._indicatorForgroundColor.fromInt(k);
                }
            }
        }

        public function _SafeStr_18750()
        {
            this._SafeStr_13145 = 0;
            this._SafeStr_12657 = 1;
        }

        public function update(k:UInt)
        {
            this._SafeStr_22119();
            this._SafeStr_22120(k);
            this._SafeStr_22118(k);
            this._SafeStr_22122();
        }

        function _SafeStr_22118(k:UInt)
        {
            var _local_2 = 0;
            if (this._SafeStr_22108 > 0)
            {
                _local_2 = Std.int((this._SafeStr_22108 / _SafeStr_22088) + 1);
                if (_local_2 > _SafeStr_22087)
                {
                    this._SafeStr_22108 = 0;
                    this._backgroundFlashImage.visible = false;
                }
                else
                {
                    this._SafeStr_22108 = ASCompat.toInt(this._SafeStr_22108 + k);
                    this._backgroundFlashImage.visible = true;
                    WindowUtils.setElementImage(this._backgroundFlashImage, this._SafeStr_12987((this._SafeStr_22109 + Std.string(_local_2))));
                }
            }
        }

        public function _SafeStr_13280(k:Bool)
        {
            this._SafeStr_22108 = 1;
            this._SafeStr_22109 = (k ? "ui_me_plus_" : "ui_me_minus_");
        }

        function _SafeStr_22119()
        {
            this._emptyFlashImage.visible = ((this._SafeStr_22102 == 0) && (this._SafeStr_22104 == null));
        }

        function _SafeStr_22120(k:UInt)
        {
            var _local_4:BitmapData = null;
            var _local_5:Point = null;
            var _local_2 = false;
            this._SafeStr_13145 = (this._SafeStr_13145 + k);
            if (this._SafeStr_12657 < 6)
            {
                if (this._SafeStr_13145 >= 1000)
                {
                    _local_2 = true;
                    this._SafeStr_13145 = 0;
                }
            }
            else
            {
                if (this._SafeStr_12657 < 11)
                {
                    if (this._SafeStr_13145 > 100)
                    {
                        _local_2 = true;
                        this._SafeStr_13145 = 0;
                    }
                }
                else
                {
                    if (this._counter != null)
                    {
                        this._counter.dispose();
                        this._counter = null;
                    }
                }
            }
            if ((((!_local_2) || this._SafeStr_5041) || (!(this._counter != null))))
            {
                return;
            }
            var _local_3= Std.downcast(this._snowWarEngine.assets.getAssetByName(this._SafeStr_22121("explosion", this._SafeStr_12657)) , BitmapDataAsset);
            if (_local_3 != null)
            {
                _local_4 = ASCompat.dynamicAs(_local_3.content , BitmapData);
                if (this._counter.bitmap == null)
                {
                    this._counter.bitmap = new BitmapData(this._counter.width, this._counter.height, true, 0xFFFFFF);
                }
                this._counter.bitmap.fillRect(this._counter.bitmap.rect, 0xFFFFFF);
                _local_5 = new Point(-_local_3.offset.x, -_local_3.offset.y);
                this._counter.bitmap.copyPixels(_local_4, _local_4.rect, _local_5, null, null, true);
                this._counter.invalidate();
            }
            this._SafeStr_12657++;
        }

        function _SafeStr_22121(k:String, _arg_2:Int, _arg_3:Int=4):String
        {
            var _local_4= Std.string(_arg_2);
            while (_local_4.length < _arg_3)
            {
                _local_4 = ("0" + _local_4);
            }
            return k + _local_4;
        }

        function _SafeStr_22122()
        {
            var k= this._snowWarEngine.synchronizedGameArena._SafeStr_19011();
            if (k.length >= 2)
            {
                WindowUtils._Str_4180(this._teamScores.findChildByName("score_blue"), k[0]);
                WindowUtils._Str_4180(this._teamScores.findChildByName("score_red"), k[1]);
            }
        }

        function _SafeStr_22123(k:Bool)
        {
            if (this._SafeStr_22101 != k)
            {
                WindowUtils.setElementImage(this._makeSnowballImage, this._SafeStr_12987(("ui_make_balls_" + (k ? "down" : "up"))));
            }
            this._SafeStr_22101 = k;
        }
    }

private class RGBColor 
{
    var _r:UInt = 0;
    var _g:UInt = 0;
    var _b:UInt = 0;
    var _a:UInt = 0;

    public function new(k:UInt=0)
    {
        this.fromInt(k);
    }

    public var r(get,never):UInt;
public function  get_r():UInt
    {
        return this._r;
    }

    public var g(get,never):UInt;
public function  get_g():UInt
    {
        return this._g;
    }

    public var b(get,never):UInt;
public function  get_b():UInt
    {
        return this._b;
    }

    public var a(get,never):UInt;
public function  get_a():UInt
    {
        return this._a;
    }

    public function fromInt(k:UInt)
    {
        this._a = ((ASCompat.toInt(k )>> 24) & 0xFF);
        this._r = ((ASCompat.toInt(k )>> 16) & 0xFF);
        this._g = ((ASCompat.toInt(k )>> 8) & 0xFF);
        this._b = ((ASCompat.toInt(k )>> 0) & 0xFF);
    }

    public var rgb(get,never):UInt;
public function  get_rgb():UInt
    {
        return (((ASCompat.toInt(this._a )<< 24) | (ASCompat.toInt(this._r )<< 16)) | (ASCompat.toInt(this._g )<< 8)) | ASCompat.toInt(this._b);
    }

    public function tweenTo(k:RGBColor)
    {
        this._a = Std.int(this._a + ((k.a - this.a) / 24));
        this._r = Std.int(this._r + ((k.r - this.r) / 24));
        this._g = Std.int(this._g + ((k.g - this.g) / 24));
        this._b = Std.int(this._b + ((k.b - this.b) / 24));
    }
}
