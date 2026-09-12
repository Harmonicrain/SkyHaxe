package com.sulake.habbo.toolbar.extensions.purse
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import flash.events.IEventDispatcher;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.utils._Str_988;

     class CurrencyIndicatorBase implements ICurrencyIndicator 
    {
        static inline final _Str_13195= 0;
        static inline final _Str_20899= 1;
        static inline final _Str_17795= 0.025;

        var _window:IWindowContainer;
        var _windowManager:IHabboWindowManager;
        var _assets:IAssetLibrary;
        var _disposed:Bool = false;
        var _Str_11528:IStaticBitmapWrapperWindow;
        var _Str_20776:UInt = 0;
        var _Str_19880:UInt = 0;
        var _Str_17400:String;
        var _Str_4381:Vector<String>;
        var _Str_19991:UInt = 0;
        var _Str_19883:String = null;
        var _Str_17496:UInt = 0;
        var _Str_4371:Int = 0;
        var _Str_3923:Timer;
        var _Str_7792:Timer;
        var _Str_8733:Float = Math.NaN;
        var _Str_21965:Int = 0;
        var _Str_17953:Int = 0;

        public function new(k:IHabboWindowManager, _arg_2:IAssetLibrary)
        {
            this._Str_4381 = new Vector<String>();
            this._window = null;
            this._windowManager = k;
            this._assets = _arg_2;
            this._Str_3923 = null;
            this._Str_7792 = new Timer(40);
            this._Str_7792.addEventListener(TimerEvent.TIMER, (this._Str_20072 : ASAny));
        }

        var _Str_19567(never,set):UInt;
function  set__Str_19567(k:UInt):UInt        {
            return this._Str_20776 = k;
        }

        var _Str_21715(never,set):UInt;
function  set__Str_21715(k:UInt):UInt        {
            return this._Str_19880 = k;
        }

        var _Str_15051(never,set):String;
function  set__Str_15051(k:String):String        {
            return this._Str_17400 = k;
        }

        var _Str_22454(never,set):UInt;
function  set__Str_22454(k:UInt):UInt        {
            return this._Str_19991 = k;
        }

        
        var _Str_8446(get,set):String;
function  set__Str_8446(k:String):String        {
            return this._Str_19883 = k;
        }
function  get__Str_8446():String
        {
            return this._Str_19883;
        }

        public var window(get,never):IWindowContainer;
public function  get_window():IWindowContainer
        {
            return this._window;
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            if (this._Str_7792 != null)
            {
                this._Str_7792.stop();
                this._Str_7792 = null;
            }
            if (this._Str_3923 != null)
            {
                this._Str_3923.stop();
                this._Str_3923 = null;
            }
            if (this._Str_4381 != null)
            {
                this._Str_4381 = null;
            }
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            this._disposed = true;
        }

        public function registerUpdateEvents(k:IEventDispatcher)
        {
        }

        public function unregisterUpdateEvents(k:IEventDispatcher)
        {
        }

        function onContainerClick(k:WindowMouseEvent)
        {
        }

        function createWindow(k:String, _arg_2:String)
        {
            var _local_4:Array<ASAny> = null;
            var _local_3= Std.downcast(this._assets.getAssetByName(k) , XmlAsset);
            if (_local_3 != null)
            {
                this._window = Std.downcast(this._windowManager.buildFromXML(((_local_3.content : com.sulake.core.utils.xml.XML) ), 1) , IWindowContainer);
                if (this._window != null)
                {
                    this._window.addEventListener(WindowMouseEvent.CLICK, this.onContainerClick);
                    this._window.addEventListener(WindowMouseEvent.OVER, this.onContainerOver);
                    this._window.addEventListener(WindowMouseEvent.OUT, this.onContainerOut);
                    _local_4 = [];
                    if (this._window.groupChildrenWithTag("ICON", _local_4, -1) == 1)
                    {
                        this._Str_11528 = ASCompat.dynamicAs(_local_4[0] , IStaticBitmapWrapperWindow);
                        this.setAssetUri(_arg_2);
                    }
                }
            }
        }

        function _Str_26406(k:Int)
        {
            this._Str_17496 = k;
            if (((this._Str_11528 != null) && (this._Str_4381.length > 0)))
            {
                if (this._Str_17496 == (_Str_13195 : UInt))
                {
                    this._Str_4371 = 0;
                }
                else
                {
                    this._Str_4371 = (this._Str_4381.length - 1);
                }
                this._Str_3923 = new Timer(this._Str_19991, this._Str_4381.length);
                this._Str_3923.addEventListener(TimerEvent.TIMER, (this._Str_14894 : ASAny));
                this._Str_3923.addEventListener(TimerEvent.TIMER_COMPLETE, (this.onTimerComplete : ASAny));
                this._Str_3923.start();
                this._Str_14894(null);
            }
        }

        function setAmount(k:Int, _arg_2:Int=-1)
        {
            this.setText(Std.string(k));
        }

        function setText(k:String)
        {
            if (this._window != null)
            {
                this._window.findChildByName(this._Str_17400).caption = k;
            }
        }

        function _Str_13549(k:Bool)
        {
            if (this._window != null)
            {
                cast(this._window.findChildByName(this._Str_17400), ITextWindow).underline = k;
            }
        }

        var _Str_23355(never,set):Array<ASAny>;
function  set__Str_23355(k:Array<ASAny>):Array<ASAny>        {
            var _local_2:String = null;
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_2  = _tmp_;
                this._Str_4381.push(_local_2);
            }
return k;
        }

        function _Str_14894(k:TimerEvent)
        {
            if (((this._Str_11528 != null) && (this._Str_4381.length > 0)))
            {
                this.setAssetUri(this._Str_4381[this._Str_4371]);
                if (this._Str_17496 == (_Str_13195 : UInt))
                {
                    this._Str_4371++;
                    this._Str_4371 = ((this._Str_4371 < this._Str_4381.length) ? this._Str_4371 : (this._Str_4381.length - 1));
                }
                else
                {
                    this._Str_4371--;
                    this._Str_4371 = ((this._Str_4371 >= 0) ? this._Str_4371 : 0);
                }
            }
        }

        function onTimerComplete(k:TimerEvent)
        {
            if (this._Str_4381.length > 0)
            {
                this.setAssetUri(this._Str_4381[0]);
            }
        }

        function setAssetUri(k:String)
        {
            if (this._Str_11528 != null)
            {
                this._Str_11528.assetUri = k;
            }
        }

        function onContainerOver(k:WindowMouseEvent)
        {
            this._window.findChildByTag("BGCOLOR").color = this._Str_20776;
        }

        function onContainerOut(k:WindowMouseEvent)
        {
            this._window.findChildByTag("BGCOLOR").color = this._Str_19880;
        }

        function _Str_19581(k:Int, _arg_2:Int)
        {
            var _local_3:IWindow = null;
            this._Str_8733 = 0;
            this._Str_21965 = k;
            this._Str_17953 = _arg_2;
            if (this._window != null)
            {
                _local_3 = this._window.findChildByName("change");
                if (_local_3 != null)
                {
                    _local_3.caption = (((_arg_2 > k) ? "+" : "") + Std.string((_arg_2 - k)));
                }
            }
            this._Str_7792.start();
            this._Str_20072(null);
        }

        function _Str_20072(k:TimerEvent)
        {
            var _local_2= ((Math.pow((this._Str_8733 - 0.5), 3) * 4) + 0.5);
            this.setAmount(Std.int(_Str_988._Str_1028(Math.max(0, ((this._Str_8733 * 2) - 1)), this._Str_21965, this._Str_17953)));
            var _local_3= Std.downcast(this._window.findChildByName("change_overlay") , IWindowContainer);
            if (_local_3 == null)
            {
                return;
            }
            _local_3.visible = true;
            _local_3.blend = (1 - (Math.abs((0.5 - _local_2)) * 2));
            _local_3.x = Std.int(_Str_988._Str_1028(_local_2, 0, (this._window.width - _local_3.width)));
            this._Str_8733 = (this._Str_8733 + _Str_17795);
            if (this._Str_8733 >= 1)
            {
                _local_3.visible = false;
                this._Str_7792.stop();
                this.setAmount(this._Str_17953);
            }
        }
    }

