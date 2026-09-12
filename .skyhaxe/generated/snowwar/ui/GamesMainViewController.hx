package snowwar.ui
;
    import com.sulake.habbo.catalog.IVideoOfferLauncher;
    import com.sulake.core.runtime.IDisposable;
    import snowwar.SnowWarEngine;
	import com.sulake.core.window.IWindowContainer;
    import snowwar._str_254.SnowWarAnimatedWindowElement;
    import flash.utils.Timer;
    import com.sulake.habbo.game.WindowUtils;
	import com.sulake.core.window.events.WindowMouseEvent;
	import com.sulake.core.window.components.IItemListWindow;
	import com.sulake.core.window.IWindow;
	import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.display.BitmapData;
    import flash.events.TimerEvent;

     class GamesMainViewController implements IVideoOfferLauncher implements  IDisposable 
    {
        static inline final _SafeStr_18751= 0;
        static inline final _SafeStr_18752= 1;
        static inline final _SafeStr_18753= 2;
        static final _SafeStr_18754:Array<ASAny> = ["move_", "throw_1_", "throw_2_", "throw_3_", "balls_"];
        static final _SafeStr_18755:Array<ASAny> = [4, 4, 5, 5, 5];
        static inline final _SafeStr_18756= 1000;

        var _snowWarEngine:SnowWarEngine;
        var _mainWindow:IWindowContainer;
        var _quickPlayContainer:IWindowContainer;
        var _gameLobbyViewController:GameLobbyViewController;
        var _SafeStr_5041:Bool = false;
        var _SafeStr_18758:SnowWarAnimatedWindowElement;
        var _SafeStr_18759:Timer;
        var _SafeStr_18760:Int = 0;
        var _SafeStr_18761:Int = 0;
        var _SafeStr_18762:Int = -1;
        var _SafeStr_18763:Int = 0;

        public function new(snowWarEngine:SnowWarEngine)
        {
            this._snowWarEngine = snowWarEngine;
        }

        public var snowWarEngine(get,never):SnowWarEngine;
public function  get_snowWarEngine():SnowWarEngine
        {
            return this._snowWarEngine;
        }

        public var mainWindow(get,never):IWindowContainer;
public function  get_mainWindow():IWindowContainer
        {
            return this._mainWindow;
        }

        public var gameLobbyViewController(get,never):GameLobbyViewController;
public function  get_gameLobbyViewController():GameLobbyViewController
        {
            return this._gameLobbyViewController;
        }

        public function _SafeStr_7703()
        {
            if (this._mainWindow != null)
            {
                this._mainWindow.visible = (!this.mainWindow.visible);
            }
            else
            {
                this.createAndVisible(true);
            }
        }

        function createWindow()
        {
            this._SafeStr_18761 = (this._snowWarEngine.config.getBoolean("games.buy.x.games.enabled") ? _SafeStr_18752 : _SafeStr_18751);
            if ((this._snowWarEngine.catalog.videoOffers.enabled && this._snowWarEngine.config.getBoolean("games.buy.x.games.video.enabled")))
            {
                this._SafeStr_18761 = _SafeStr_18753;
                this._snowWarEngine.catalog.videoOffers.load(this);
            }
            this._mainWindow = Std.downcast(WindowUtils.createWindow("games_main", 1) , IWindowContainer);
            this._mainWindow.findChildByTag("close").addEventListener(WindowMouseEvent.CLICK, this._SafeStr_9859);
            this._mainWindow.visible = true;
            this._mainWindow.center();
            this._quickPlayContainer = Std.downcast(this._mainWindow.findChildByName("quick_play_container") , IWindowContainer);
            this._quickPlayContainer.findChildByName("play.button").addEventListener(WindowMouseEvent.CLICK, this._SafeStr_18764);
            this._quickPlayContainer.findChildByName("buy.button").addEventListener(WindowMouseEvent.CLICK, this._SafeStr_18765);
            this._quickPlayContainer.findChildByName("watch_video.button").addEventListener(WindowMouseEvent.CLICK, this._SafeStr_18765);
            this._quickPlayContainer.visible = false;
            this._quickPlayContainer.findChildByName("instructions_link").addEventListener(WindowMouseEvent.CLICK, this._SafeStr_18766);
            this._quickPlayContainer.findChildByName("leaderboard_link").addEventListener(WindowMouseEvent.CLICK, this._SafeStr_18767);
            this._quickPlayContainer.findChildByName("instructions_back").addEventListener(WindowMouseEvent.CLICK, this._SafeStr_12885);
            this._quickPlayContainer.findChildByName("instructions_next").addEventListener(WindowMouseEvent.CLICK, this._SafeStr_18768);
            this._quickPlayContainer.findChildByName("instructions_prev").addEventListener(WindowMouseEvent.CLICK, this._SafeStr_18769);
            this._quickPlayContainer.findChildByName("games_left_region").addEventListener(WindowMouseEvent.CLICK, this._SafeStr_18770);
            this._quickPlayContainer.findChildByName("leaderboard_link").visible = this._snowWarEngine.config.getBoolean("games.highscores.enabled");
            var k= Std.downcast(this._quickPlayContainer.findChildByName("page_list") , IItemListWindow);
            var _local_2 = 0;
            while (_local_2 < k.numListItems)
            {
                k.getListItemAt(_local_2).addEventListener(WindowMouseEvent.CLICK, this._SafeStr_18771);
                _local_2++;
            }
            this._SafeStr_5041 = false;
            this._SafeStr_13278();
        }

        public function close(k:Bool)
        {
            if (((this._gameLobbyViewController != null) && this._gameLobbyViewController.visible))
            {
                this._gameLobbyViewController._SafeStr_9859(k);
            }
            this._SafeStr_18774();
        }

        function _SafeStr_9859(k:WindowMouseEvent)
        {
            this.close(true);
        }

        function _SafeStr_18764(k:WindowMouseEvent)
        {
            if (this._snowWarEngine._SafeStr_13224 != 0)
            {
                this._snowWarEngine._SafeStr_13185();
            }
            else
            {
                this._SafeStr_18770(k);
            }
        }

        function _SafeStr_18765(k:WindowMouseEvent)
        {
            this._SafeStr_18770(k);
        }

        function _SafeStr_18772()
        {
            var k= this._quickPlayContainer.findChildByName("play.button");
            var _local_2= this._quickPlayContainer.findChildByName("buy.button");
            var _local_3= this._quickPlayContainer.findChildByName("watch_video.button");
            var _local_4= this._quickPlayContainer.findChildByName("games.lobby.get.vip");
            var _local_5= this._quickPlayContainer.findChildByName("games.lobby.get.games");
            var _local_6= this._quickPlayContainer.findChildByName("games.lobby.get.games_for_video");
            k.visible = false;
            _local_2.visible = false;
            _local_3.visible = false;
            _local_4.visible = false;
            _local_5.visible = false;
            _local_6.visible = false;
            switch (this._SafeStr_18761)
            {
                case _SafeStr_18752:
                    if (this._snowWarEngine._SafeStr_13224 == 0)
                    {
                        _local_2.visible = true;
                    }
                    else
                    {
                        k.visible = true;
                    }
                    _local_5.visible = true;
                    return;
                case _SafeStr_18753:
                    if (this._snowWarEngine._SafeStr_13224 == 0)
                    {
                        _local_3.visible = true;
                    }
                    else
                    {
                        k.visible = true;
                    }
                    if (this._SafeStr_18762 > 0)
                    {
                        _local_6.visible = true;
                    }
                    return;
                default:
                    k.visible = true;
                    _local_4.visible = true;
            }
        }

        public function offersAvailable(k:Int)
        {
            this._SafeStr_18762 = k;
            if (this._SafeStr_18762 < 1)
            {
                this._SafeStr_18761 = _SafeStr_18751;
            }
            if (this._quickPlayContainer != null)
            {
                this._SafeStr_18772();
            }
        }

        function _SafeStr_18766(k:WindowMouseEvent)
        {
            this._SafeStr_18773(true);
        }

        function _SafeStr_18767(k:WindowMouseEvent)
        {
            this._snowWarEngine.showLeaderboard();
        }

        function _SafeStr_12885(k:WindowMouseEvent)
        {
            this._SafeStr_18773(false);
        }

        function _SafeStr_18768(k:WindowMouseEvent)
        {
            this._SafeStr_18763++;
            this._SafeStr_18763 = (this._SafeStr_18763 % _SafeStr_18754.length);
            this._SafeStr_18773(true);
        }

        function _SafeStr_18769(k:WindowMouseEvent)
        {
            this._SafeStr_18763 = ((this._SafeStr_18763 - 1) + _SafeStr_18754.length);
            this._SafeStr_18763 = (this._SafeStr_18763 % _SafeStr_18754.length);
            this._SafeStr_18773(true);
        }

        function _SafeStr_18771(k:WindowMouseEvent)
        {
            this._SafeStr_18763 = ASCompat.parseInt(ASCompat.stringReplace(k.window.name, "page_", ""));
            this._SafeStr_18773(true);
        }

        function _SafeStr_18773(k:Bool)
        {
            var _local_7:IWindowContainer = null;
            this._quickPlayContainer.findChildByName("teaser_container").visible = (!k);
            this._quickPlayContainer.findChildByName("instructions_container").visible = k;
            if (this._SafeStr_18758 != null)
            {
                this._SafeStr_18758.dispose();
                this._SafeStr_18758 = null;
            }
            if (!k)
            {
                return;
            }
            var _local_2= Std.downcast(this._quickPlayContainer.findChildByName("instructions_image") , IBitmapWrapperWindow);
            var _local_3:String = _SafeStr_18754[this._SafeStr_18763];
            var _local_4= ASCompat.toInt(_SafeStr_18755[this._SafeStr_18763]);
            this._SafeStr_18758 = new SnowWarAnimatedWindowElement(this._snowWarEngine.assets, _local_2, _local_3, _local_4, _SafeStr_18756);
            this._quickPlayContainer.findChildByName("instruction_text").caption = (("${snowwar.instructions." + Std.string(this._SafeStr_18763 + 1)) + "}");
            var _local_5= Std.downcast(this._quickPlayContainer.findChildByName("page_list") , IItemListWindow);
            var _local_6 = 0;
            while (_local_6 < _local_5.numListItems)
            {
                _local_7 = Std.downcast(_local_5.getListItemAt(_local_6) , IWindowContainer);
                _local_3 = ((_local_6 <= this._SafeStr_18763) ? "pagination_ball_hilite" : "pagination_ball");
                WindowUtils.setElementImage(_local_7.getChildAt(0), this._SafeStr_12987(_local_3));
                _local_6++;
            }
        }

        function _SafeStr_12987(k:String):BitmapData
        {
            var _local_2= this._snowWarEngine.assets.getAssetByName(k);
            if (_local_2 != null)
            {
                return ASCompat.dynamicAs(_local_2.content , BitmapData);
            }
            return null;
        }

        function _SafeStr_18770(k:WindowMouseEvent)
        {
            switch (this._SafeStr_18761)
            {
                case _SafeStr_18752:
                    this._snowWarEngine._SafeStr_13226("gameFramework.buyTokens.clicked.frontView");
                    return;
                case _SafeStr_18753:
                    if (!this._snowWarEngine._SafeStr_13227("gameFramework.videoOffer.clicked.frontView"))
                    {
                        this._SafeStr_18761 = _SafeStr_18751;
                        this._SafeStr_18772();
                    }
                    return;
                default:
                    this._snowWarEngine._SafeStr_7664("gameFramework.getVip.clicked.frontView");
            }
        }

        public function createAndVisible(create:Bool)
        {
            if (((!(this._mainWindow != null)) && create))
            {
                this.createWindow();
            }
            else
            {
                if (((!(this.mainWindow != null)) && (!create)))
                {
                    return;
                }
            }
            if (this._gameLobbyViewController != null)
            {
                this._gameLobbyViewController.visible = false;
            }
            this._quickPlayContainer.visible = true;
        }

        public function _SafeStr_13273(k:String, _arg_2:Int, _arg_3:Int)
        {
            if (this._mainWindow == null)
            {
                this.createWindow();
            }
            if (this._gameLobbyViewController == null)
            {
                this._gameLobbyViewController = new GameLobbyViewController(this, k, _arg_2, _arg_3);
            }
            else
            {
                this._gameLobbyViewController._SafeStr_18594 = k;
                this._gameLobbyViewController._SafeStr_13274 = _arg_2;
                this._gameLobbyViewController._SafeStr_18593 = _arg_3;
                this._gameLobbyViewController._SafeStr_18590();
            }
            this._quickPlayContainer.visible = false;
            this._gameLobbyViewController.visible = true;
        }

        public function dispose()
        {
            if (!this._SafeStr_5041)
            {
                this._SafeStr_18774();
                this._SafeStr_5041 = true;
                this._SafeStr_18775();
            }
        }

        function _SafeStr_18774()
        {
            if (this._SafeStr_18758 != null)
            {
                this._SafeStr_18758.dispose();
                this._SafeStr_18758 = null;
            }
            if (this._gameLobbyViewController != null)
            {
                this._gameLobbyViewController.dispose();
                this._gameLobbyViewController = null;
            }
            if (this._quickPlayContainer != null)
            {
                this._quickPlayContainer.dispose();
                this._quickPlayContainer = null;
            }
            if (this._mainWindow != null)
            {
                this._mainWindow.dispose();
                this._mainWindow = null;
            }
        }

        function _SafeStr_18775()
        {
            if (this._SafeStr_18759 != null)
            {
                this._SafeStr_18759.removeEventListener(TimerEvent.TIMER, (this._SafeStr_18589 : ASAny));
                this._SafeStr_18759.stop();
                this._SafeStr_18759 = null;
            }
            this._SafeStr_18760 = Std.int(Math.NaN);
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._SafeStr_5041;
        }

        public function _SafeStr_13278()
        {
            var k:IWindowContainer = null;
            var _local_2:ITextWindow = null;
            var _local_3:IWindow = null;
            if (((this._quickPlayContainer != null) && this._quickPlayContainer.visible))
            {
                WindowUtils._Str_4180(this._quickPlayContainer.findChildByName("games_left"), Std.string(this._snowWarEngine._SafeStr_13224));
                k = Std.downcast(this._quickPlayContainer.findChildByName("games_left_region") , IWindowContainer);
                _local_2 = Std.downcast(this._quickPlayContainer.findChildByName("games_left_stroke") , ITextWindow);
                _local_3 = this._quickPlayContainer.findChildByName("play.button");
                _local_3.visible = true;
                this._SafeStr_18772();
                if (this._SafeStr_18776(k, _local_2, _local_3))
                {
                    this._SafeStr_18777(_local_3);
                }
            }
        }

        function _SafeStr_18776(k:IWindowContainer, _arg_2:ITextWindow, _arg_3:IWindow):Bool
        {
            if (this._snowWarEngine._SafeStr_13223)
            {
                k.visible = false;
                return true;
            }
            k.visible = true;
            var _local_4:IWindow = cast(this._quickPlayContainer.findChildByName("play_text"), ITextWindow);
            _arg_3.color = 0x55CC00;
            switch (this._snowWarEngine._SafeStr_13224)
            {
                case -1:
                    k.visible = false;
                    WindowUtils._Str_4180(_local_4, "${snowwar.play}");
                    return true;
                case 0:
                    k.visible = true;
                    _arg_2.textColor = 0xFF0000;
                    WindowUtils._Str_4180(_local_4, "${catalog.vip.buy.title}");
                    return false;
                default:
                    k.visible = true;
                    _arg_2.textColor = 1079212;
                    WindowUtils._Str_4180(_local_4, "${snowwar.play}");
                    return true;
            }
        }

        function _SafeStr_18777(k:IWindow)
        {
            var _local_3 = 0;
            var _local_4 = 0;
            var _local_2:IWindow = cast(this._quickPlayContainer.findChildByName("play_text"), ITextWindow);
            if (this._SafeStr_18760 > 0)
            {
                k.disable();
                k.color = 0xCCCCCC;
                _local_3 = Std.int(Math.ffloor((this._SafeStr_18760 / 60)));
                _local_4 = (this._SafeStr_18760 % 60);
                _local_2.caption = ((Std.string(_local_3) + ":") + ((_local_4 < 10) ? ("0" + Std.string(_local_4)) : Std.string(_local_4)));
            }
            else
            {
                if (this._SafeStr_18760 <= 0)
                {
                    k.enable();
                    k.color = 0x55CC00;
                    WindowUtils._Str_4180(_local_2, "${snowwar.play}");
                }
            }
        }

        function _SafeStr_18589(k:TimerEvent)
        {
            if (((this._SafeStr_18760 != 0) && (this._SafeStr_18760 > 0)))
            {
                this._SafeStr_18760--;
                HabboGamesCom.log([("on block tick " + Std.string(this._SafeStr_18760))]);
                this._SafeStr_13278();
            }
            if (this._SafeStr_18760 <= 0)
            {
                this._SafeStr_13278();
                this._SafeStr_18775();
            }
        }

        public function _SafeStr_18778(k:Int)
        {
            if (k > 0)
            {
                this._SafeStr_18760 = k;
                if (this._SafeStr_18759 == null)
                {
                    this._SafeStr_18759 = new Timer(1000, this._SafeStr_18760);
                    this._SafeStr_18759.addEventListener(TimerEvent.TIMER, (this._SafeStr_18589 : ASAny));
                    this._SafeStr_18759.start();
                }
            }
            this._SafeStr_13278();
        }
    }

