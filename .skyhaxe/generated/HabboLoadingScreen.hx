 

    import flash.display.Sprite;
    import com.sulake.core.runtime.IDisposable;
    import flash.utils.Timer;
    import splash.PhotoSplashScreen;
    import onBoardingHcUi.LoaderUI;
    import flash.text.TextFormatAlign;
    import flash.text.TextField;
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.events.*;

     class HabboLoadingScreen extends Sprite implements IDisposable implements  IHabboLoadingScreen 
    {
        static inline final _Str_1968= 28;
        public static inline final _Str_1292= 400;
        public static inline final _Str_1794= 25;
        public static inline final _Str_1195= 2;
        public static inline final _Str_2172= 2;
        public static inline final CONTAINER= "container";
        public static inline final FILELOADINGBAR= "fileLoadingBar";
        public static inline final FILEBARSPRITE= "fileBarSprite";
        public static inline final PHOTOSPLASHSCREEN= "photoSplashScreen";
        public static inline final BACKGROUND= "background";
        public static inline final HABBOLOGO= "habboLogo";
        public static inline final TEXTFIELD= "textField";
        public static inline final LOADINGNUMBERTEXTFIELD= "loadingNumberTextField";

        var _Str_1214:Timer;
        var _Str_1981:Int = 0;
        var _Str_1747:PhotoSplashScreen;
        var _disposed:Bool = false;
        var _Str_1541:Int = 0;
        var _Str_2236:String = null;
        var _Str_2109:Bool = false;

        public function new(k:Int, _arg_2:Int, _arg_3:String, _arg_4:String)
        {
            var _local_6:Sprite = null;
            var _local_7:Sprite = null;
            var _local_11:Array<ASAny> = null;
            super();
            var _local_5= new Sprite();
            _local_5.name = BACKGROUND;
            _local_5.graphics.clear();
            _local_5.graphics.beginFill(922908);
            _local_5.graphics.drawRect(0, 0, k, _arg_2);
            addChild(_local_5);
            this._Str_1747 = new PhotoSplashScreen(this);
            this._Str_1747.name = PHOTOSPLASHSCREEN;
            addChild(this._Str_1747);
            _local_6 = new Sprite();
            _local_6.name = FILELOADINGBAR;
            _local_6.graphics.lineStyle(1, 0xFFFFFF, 1, true);
            _local_6.graphics.beginFill(2500143);
            _local_6.graphics.drawRect(1, 0, (_Str_1292 - 1), 0);
            _local_6.graphics.drawRect(_Str_1292, 1, 0, (_Str_1794 - 1));
            _local_6.graphics.drawRect(1, _Str_1794, (_Str_1292 - 1), 0);
            _local_6.graphics.drawRect(0, 1, 0, (_Str_1794 - 1));
            _local_6.graphics.endFill();
            addChild(_local_6);
            var _local_8:String = null;
            if (_arg_4 != null)
            {
                _local_11 = (cast _arg_4.split("/"));
                this._Str_1541 = Std.int(this._Str_1537(0, (_local_11.length - 1)));
                this._Str_2236 = _arg_4;
                _local_8 = _local_11[this._Str_1541];
            }
            else
            {
                _local_8 = _arg_3;
            }
            var _local_9= LoaderUI.createTextField(_local_8, _Str_1968, LoaderUI._Str_1545, true, false, false, false, TextFormatAlign.CENTER);
            _local_9.name = TEXTFIELD;
            addChild(_local_9);
            var _local_10= LoaderUI.createTextField("0%", 14, 0x999999, true, false, false, false, TextFormatAlign.CENTER);
            _local_10.name = LOADINGNUMBERTEXTFIELD;
            addChild(_local_10);
            _local_7 = new Sprite();
            _local_7.name = FILEBARSPRITE;
            _local_6.addChild(_local_7);
            _local_6.visible = true;
            addEventListener(Event.ADDED_TO_STAGE, (this.onAddedToStage : ASAny));
        }

        function onRemovedFromStage(k:Event)
        {
            Logger.log(["Habbo Loading Screen was removed from stage."]);
        }

        function onAddedToStage(k:Event)
        {
            removeEventListener(Event.ADDED_TO_STAGE, (this.onAddedToStage : ASAny));
            stage.addEventListener(Event.RESIZE, (this.onResize : ASAny));
            this._Str_1370();
            this._Str_1214 = new Timer(750);
            this._Str_1214.addEventListener(TimerEvent.TIMER, (this._Str_1187 : ASAny));
            this._Str_1214.start();
        }

        function onResize(k:Event)
        {
            this._Str_1370();
        }

        function _Str_1187(k:Event)
        {
            var _local_2:Array<ASAny> = null;
            var _local_3:TextField = null;
            var _local_4:TextField = null;
            if (this._Str_1981 == 100)
            {
                if (this._Str_2109)
                {
                    _local_2 = (cast this._Str_2236.split("/"));
                    _local_3 = Std.downcast(getChildByName(TEXTFIELD) , TextField);
                    if (_local_3 != null)
                    {
                        this._Str_1397(TEXTFIELD);
                        _local_4 = LoaderUI.createTextField(_local_2[this._Str_1541], _Str_1968, LoaderUI._Str_1545, true, false, false, false, TextFormatAlign.CENTER);
                        _local_4.x = ((width - _local_4.width) / 2);
                        _local_4.y = _local_3.y;
                        _local_4.name = TEXTFIELD;
                        addChild(_local_4);
                    }
                    this._Str_2109 = false;
                }
                this._Str_1981 = 0;
            }
            else
            {
                this._Str_1981 = Std.int(this._Str_1981 + Math.min(this._Str_1537(1, this._Str_1537(15, 33)), (100 - this._Str_1981)));
            }
            if (((this._Str_1981 == 100) && (!(this._Str_2236 == null))))
            {
                this._Str_2109 = true;
                this._Str_1541 = ((this._Str_1541 + 1) % (this._Str_2236.split("/").length - 1));
            }
            this._Str_1846((this._Str_1981 / 100));
        }

        function _Str_1537(k:Float, _arg_2:Float):Float
        {
            return Math.ffloor((Math.random() * ((_arg_2 - k) + 1))) + k;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        function _Str_1397(k:String)
        {
            var _local_2= getChildByName(k);
            if (_local_2 != null)
            {
                removeChild(_local_2);
            }
        }

        public function dispose()
        {
            if (this.disposed)
            {
                return;
            }
            this._disposed = true;
            var k= stage;
            if (k != null)
            {
                k.removeEventListener(Event.RESIZE, (this.onResize : ASAny));
            }
            removeEventListener(Event.ADDED_TO_STAGE, (this.onAddedToStage : ASAny));
            removeEventListener(Event.REMOVED_FROM_STAGE, (this.onRemovedFromStage : ASAny));
            this._Str_1397(PHOTOSPLASHSCREEN);
            this._Str_1397(BACKGROUND);
            this._Str_1397(TEXTFIELD);
            this._Str_1397(HABBOLOGO);
            this._Str_1397(FILELOADINGBAR);
            this._Str_1397(CONTAINER);
            this._Str_1214.stop();
            this._Str_1214.removeEventListener(TimerEvent.TIMER, (this._Str_1187 : ASAny));
            if (parent != null)
            {
                parent.removeChild(this);
            }
        }

        public function _Str_1370()
        {
            var k = 0;
            var _local_2 = 0;
            var _local_3= this.stage;
            if (_local_3 != null)
            {
                k = _local_3.stageWidth;
                _local_2 = _local_3.stageHeight;
            }
            else
            {
                k = Std.int(this.width);
                _local_2 = Std.int(this.height);
            }
            var _local_4= Std.downcast(getChildByName(BACKGROUND) , Sprite);
            if (_local_4 != null)
            {
                _local_4.x = 0;
                _local_4.y = 0;
                _local_4.graphics.clear();
                _local_4.graphics.beginFill(922908);
                _local_4.graphics.drawRect(0, 0, k, _local_2);
            }
            var _local_5 = 0;
            var _local_6 = 0;
            var _local_7 = 0;
            var _local_8 = 0;
            var _local_9 = 0;
            var _local_10= 10;
            var _local_11= Std.downcast(getChildByName(PHOTOSPLASHSCREEN) , Sprite);
            if (_local_11 != null)
            {
                _local_11.x = ((k - _local_11.width) / 2);
                _local_9 = Std.int(_local_11.y + _local_11.height);
            }
            var _local_12= Std.downcast(getChildByName(TEXTFIELD) , TextField);
            if (_local_12 != null)
            {
                _local_12.x = ((k - _local_12.width) / 2);
                if (_local_12.width > _local_7)
                {
                    _local_7 = Std.int(_local_12.width);
                    _local_5 = Std.int(_local_12.x);
                }
            }
            var _local_13= Std.downcast(getChildByName(FILELOADINGBAR) , Sprite);
            if (_local_13 != null)
            {
                _local_13.x = ((k - _local_13.width) / 2);
                _local_13.y = _local_9;
                _local_9 = Std.int(_local_13.y + _local_13.height);
                if (_local_13.width > _local_7)
                {
                    _local_7 = Std.int(_local_13.width);
                    _local_5 = Std.int(_local_13.x);
                }
            }
            var _local_14= Std.downcast(getChildByName(LOADINGNUMBERTEXTFIELD) , TextField);
            if (_local_14 != null)
            {
                _local_14.x = ((k - _local_14.width) / 2);
                if (_local_14.width > _local_7)
                {
                    _local_7 = Std.int(_local_14.width);
                    _local_5 = Std.int(_local_14.x);
                }
            }
            _local_9 = Std.int((_local_2 - _local_9) / 2);
            _local_9 = (_local_9 - (_local_10 * 2));
            if (_local_11 != null)
            {
                _local_11.y = _local_9;
                _local_9 = Std.int(_local_11.y + _local_11.height);
            }
            if (_local_12 != null)
            {
                _local_12.y = (_local_9 + 50);
                _local_9 = Std.int((_local_12.y + _local_12.height) + _local_10);
            }
            if (_local_13 != null)
            {
                _local_13.y = _local_9;
                _local_9 = Std.int((_local_13.y + _local_13.height) + (_local_10 / 2));
            }
            if (_local_14 != null)
            {
                _local_14.y = _local_9;
            }
        }

        public function _Str_1846(k:Float)
        {
            var _local_2= _Str_1292;
            var _local_3= _Str_1794;
            var _local_4= _Str_1195;
            var _local_5= _Str_2172;
            var _local_6= Std.downcast(getChildByName(FILELOADINGBAR) , Sprite);
            if (_local_6 == null)
            {
                return;
            }
            var _local_7= Std.downcast(_local_6.getChildByName(FILEBARSPRITE) , Sprite);
            if (_local_7 == null)
            {
                return;
            }
            _local_7.x = (_local_4 + _local_5);
            _local_7.y = (_local_4 + _local_5);
            _local_7.graphics.clear();
            var _local_8= ((_local_3 - (_local_4 * 2)) - (_local_5 * 2));
            var _local_9= Std.int(((_local_2 - (_local_4 * 2)) - (_local_5 * 2)) * k);
            _local_7.graphics.beginFill(0);
            _local_7.graphics.drawRect(-1, -1, (_local_2 - (_local_4 * 2)), (_local_3 - (_local_5 * 2)));
            _local_7.graphics.endFill();
            _local_7.graphics.beginFill(12241619);
            _local_7.graphics.drawRect(0, 0, _local_9, (_local_8 / 2));
            _local_7.graphics.endFill();
            _local_7.graphics.beginFill(9216429);
            _local_7.graphics.drawRect(0, (_local_8 / 2), _local_9, ((_local_8 / 2) + 1));
            _local_7.graphics.endFill();
        }

        public function _Str_774(k:Float)
        {
            var _local_2= Std.downcast(getChildByName(LOADINGNUMBERTEXTFIELD) , TextField);
            if (_local_2 != null)
            {
                _local_2.text = (Std.string(Math.fround((k * 100))) + "%");
            }
        }
    }

