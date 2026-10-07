package snowwar.ui
;
	import com.sulake.core.runtime.IDisposable;
	import com.sulake.habbo.avatar._enum.AvatarSetType;
	import com.sulake.habbo.avatar._enum.AvatarScaleType;
	import com.sulake.habbo.game.WindowUtils;
	import com.sulake.habbo.avatar.IAvatarImageListener;
	import com.sulake.core.utils.Map;
	import com.sulake.core.window.IWindow;
	import com.sulake.core.window.IWindowContainer;
	import com.sulake.core.window.components.IBitmapWrapperWindow;
	import com.sulake.core.window.components.IItemListWindow;
	import com.sulake.core.window.components.IRegionWindow;
	import com.sulake.core.window.events.WindowEvent;
	import com.sulake.core.window.events.WindowMouseEvent;
	import com.sulake.habbo.communication.messages.outgoing.navigator.GetGuestRoomMessageComposer;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import snowwar.SnowWarEngine;
	import snowwar._str_254.SnowWarAnimatedWindowElement;
	import snowwar._str_373._SafeStr_3665;
	import snowwar._str_496._SafeStr_4018;
	import snowwar._str_496._SafeStr_4032;

     class GameStartingViewController implements IDisposable implements  IAvatarImageListener 
    {
        var _disposed:Bool = false;
        var _snowWarEngine:SnowWarEngine;
        var _SafeStr_9274:IWindowContainer;
        var _SafeStr_18586:Map;
        var _SafeStr_18794:_SafeStr_4018;
        var _gameLoadingViewController:GameLoadingViewController;
        var _SafeStr_18795:Array<ASAny>;

        public function new(k:SnowWarEngine)
        {
            this._SafeStr_18795 = [];
            this._snowWarEngine = k;
            this._SafeStr_18586 = new Map();
            this._SafeStr_6656();
            this._gameLoadingViewController = new GameLoadingViewController(this._snowWarEngine);
            this._gameLoadingViewController.background.visible = true;
            this._snowWarEngine.windowManager.getDesktop(1).visible = false;
            this._snowWarEngine.roomUI.visible = false;
        }

        public function dispose()
        {
            var k:SnowWarAnimatedWindowElement = null;
            if (this._disposed)
            {
                return;
            }
            this._snowWarEngine.windowManager.getDesktop(1).visible = true;
            this._snowWarEngine = null;
            if (this._SafeStr_18586 != null)
            {
                final _iter_ = this._SafeStr_18586; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
                {
k  = _tmp_;
                    k.dispose();
                }
                this._SafeStr_18586.dispose();
                this._SafeStr_18586 = null;
            }
            if (this._SafeStr_9274 != null)
            {
                this._SafeStr_9274.dispose();
                this._SafeStr_9274 = null;
            }
            if (this._gameLoadingViewController != null)
            {
                this._gameLoadingViewController.dispose();
                this._gameLoadingViewController = null;
            }
            this._disposed = true;
            this._SafeStr_18795 = [];
        }

        function _SafeStr_6656()
        {
            this._SafeStr_9274 = Std.downcast(WindowUtils.createWindow("snowwar_ending") , IWindowContainer);
            this._SafeStr_9274.x = Std.int((this._SafeStr_9274.desktop.width - this._SafeStr_9274.width) / 2);
            this._SafeStr_9274.y = ((this._SafeStr_9274.desktop.height > 685) ? 115 : 10);
            WindowUtils._Str_4180(this._SafeStr_9274.findChildByName("endingInformation"), "${snowwar.loading.title}");
            WindowUtils._Str_26294(this._SafeStr_9274, "buttonsContainer");
            WindowUtils._Str_26294(this._SafeStr_9274, "mostKillsContainer");
            WindowUtils._Str_26294(this._SafeStr_9274, "mostHitsContainer");
            WindowUtils._Str_26294(this._SafeStr_9274, "team1Score");
            WindowUtils._Str_26294(this._SafeStr_9274, "team2Score");
            WindowUtils._Str_26294(this._SafeStr_9274, "statusContainer");
            this._SafeStr_9274.findChildByName("loadingContainer").visible = true;
            this._SafeStr_9274.findChildByName("leave_link_region").procedure = this._SafeStr_16837;
        }

        function _SafeStr_16837(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this._SafeStr_9859();
        }

        function _SafeStr_9859()
        {
            if (this._snowWarEngine != null)
            {
                this._snowWarEngine._SafeStr_13222(true);
                this._snowWarEngine.send(new _SafeStr_3665());
                if (this._snowWarEngine.rejoinRoom > -1)
                {
                    this._snowWarEngine.send(new GetGuestRoomMessageComposer(this._snowWarEngine.rejoinRoom, false, true));
                }
                this._snowWarEngine.disposeGameStartingViewController();
            }
        }

        public function show(k:_SafeStr_4018)
        {
            this._SafeStr_18794 = k;
            var _local_2= Std.downcast(this._SafeStr_9274.findChildByName("arenaPreview") , IBitmapWrapperWindow);
            var _local_3= this._snowWarEngine.assets.getAssetByName((("arena_" + Std.string(k.fieldName)) + "_preview"));
            if (_local_3 != null)
            {
                _local_2.bitmap = ASCompat.dynamicAs(_local_3.content , BitmapData);
                _local_2.disposesBitmap = false;
            }
            WindowUtils._Str_4180(this._SafeStr_9274.findChildByName("arenaName"), this._snowWarEngine.gameArenaName(k));
            this._SafeStr_18796();
        }

        function _SafeStr_18796()
        {
            var k:_SafeStr_4032 = null;
            this._SafeStr_18797();
            final _iter_ = ASCompat.ASArray.sort(this._SafeStr_18794._SafeStr_13266, _SafeStr_4032._SafeStr_18802); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                this._SafeStr_18798(k);
            }
        }

        function _SafeStr_18797()
        {
            var _local_2:IItemListWindow = null;
            var k= 1;
            while ((_local_2 = Std.downcast(this._SafeStr_9274.findChildByName((("team" + Std.string(k++)) + "PlayersList")) , IItemListWindow)) != null)
            {
                _local_2.destroyListItems();
            }
        }

        function _SafeStr_18798(k:_SafeStr_4032)
        {
            var _local_8 = 0;
            var _local_2= k.__as3_final;
            var _local_3= Std.downcast(this._SafeStr_9274.findChildByName((("team" + Std.string(_local_2)) + "PlayersList")) , IItemListWindow);
            var _local_4= Std.downcast(WindowUtils.createWindow(("snowwar_results_player_team_" + Std.string(_local_2))) , IItemListWindow);
            var _local_5= Std.downcast(_local_4.getListItemByName("playerImageContainer") , IWindowContainer);
            var _local_6= Std.downcast(_local_4.getListItemByName("playerDataContainer") , IWindowContainer);
            var _local_7= Std.downcast(_local_4.getListItemByName("playerScoreContainer") , IWindowContainer);
            if (k.userId == this._snowWarEngine.sessionDataManager.userId)
            {
                WindowUtils.setElementImage(_local_5.findChildByName("playerImageBackground"), this._SafeStr_12987("green_square"));
            }
            switch (_local_2)
            {
                case 2:
                    _local_8 = 4;
                    
                default:
                    _local_8 = 2;
            }
            WindowUtils.setElementImage(this._SafeStr_18800(_local_5, "playerImage"), this._SafeStr_18801(k.__as3_final, k.figure, k.gender, _local_8));
            WindowUtils._Str_4180(this._SafeStr_18800(_local_6, "playerName"), k.name);
            WindowUtils._Str_26294(_local_6, "playerStats");
            WindowUtils._Str_26294(_local_7, "playerScore");
            WindowUtils._Str_26294(_local_6, "playerTotalStats");
            var _local_9= Std.downcast(_local_6.findChildByName("skillLevel") , IBitmapWrapperWindow);
            if (_local_9.bitmap != null)
            {
                _local_9.bitmap.dispose();
            }
            _local_9.bitmap = this._SafeStr_18799(k.skillLevel, k.__as3_final);
            var _local_10= Std.downcast(_local_6.findChildByName("scoreTooltip") , IRegionWindow);
            _local_10.toolTipCaption = ((Std.string(k._SafeStr_17897) + "/") + Std.string(k._SafeStr_18803));
            _local_10.visible = true;
            _local_3.addListItem(_local_4);
            var _local_11= Std.downcast(_local_7.findChildByName("loadingIcon") , IBitmapWrapperWindow);
            var _local_12:SnowWarAnimatedWindowElement = this._SafeStr_18586.remove(k.userId);
            if (_local_12 != null)
            {
                _local_12.dispose();
            }
            _local_12 = new SnowWarAnimatedWindowElement(this._snowWarEngine.assets, _local_11, "load_", 8);
            this._SafeStr_18586.add(k.userId, _local_12);
            _local_11.visible = true;
        }

        function _SafeStr_18799(k:Int, _arg_2:Int):BitmapData
        {
            var _local_8:BitmapData = null;
            var _local_11:Point = null;
            k = Std.int(Math.min(k, 30));
            var _local_3= ASCompat.dynamicAs(this._snowWarEngine.assets.getAssetByName("star_empty").content , BitmapData);
            var _local_4= ASCompat.dynamicAs(this._snowWarEngine.assets.getAssetByName("star_filled_bronze").content , BitmapData);
            var _local_5= ASCompat.dynamicAs(this._snowWarEngine.assets.getAssetByName("star_filled_silver").content , BitmapData);
            var _local_6= ASCompat.dynamicAs(this._snowWarEngine.assets.getAssetByName("star_filled_gold").content , BitmapData);
            var _local_7= ((k > 0) ? (((k - 1) % 10) + 1) : 0);
            var _local_9= new BitmapData(150, 13, true, 0);
            var _local_10 = 0;
            while (_local_10 < 10)
            {
                _local_11 = ((_arg_2 == 1) ? new Point((_local_10 * 15), 0) : new Point(((9 - _local_10) * 15), 0));
                _local_8 = ((k > 20) ? ((_local_7-- > 0) ? _local_6 : _local_3) : ((k > 10) ? ((_local_7-- > 0) ? _local_5 : _local_3) : ((_local_7-- > 0) ? _local_4 : _local_3)));
                _local_9.copyPixels(_local_8, _local_8.rect, _local_11);
                _local_10++;
            }
            return _local_9;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function avatarImageReady(k:String)
        {
            if (this._SafeStr_18795.indexOf(k) == -1)
            {
                this._SafeStr_18796();
                this._SafeStr_18795.push(k);
            }
        }

        function _SafeStr_18800(k:IWindowContainer, _arg_2:String):IWindow
        {
            return k.findChildByName(_arg_2);
        }

        function _SafeStr_12987(k:String):BitmapData
        {
            return ASCompat.dynamicAs(this._snowWarEngine.assets.getAssetByName(k).content , BitmapData);
        }

        function _SafeStr_18801(k:Int, _arg_2:String, _arg_3:String, _arg_4:Int):BitmapData
        {
            var _local_5= this._snowWarEngine.avatarRenderManager._Str_718(_arg_2);
            switch (k)
            {
                case 1:
                    _local_5._Str_830("ch", 20000, [1]);
                    
                case 2:
                    _local_5._Str_830("ch", 20001, [1]);
                    
                default:
                    _local_5._Str_830("ch", 20000, [1]);
            }
            var _local_6= this._snowWarEngine.avatarRenderManager.createAvatarImage(_local_5.getFigureString(), AvatarScaleType.SMALL, _arg_3, this);
            if (_local_6 != null)
            {
                _local_6.setDirection(AvatarSetType.FULL, _arg_4);
return _local_6.getCroppedImage(AvatarSetType.FULL);
            }
            return null;
        }

        public function playersInitialized(k:Array<ASAny>)
        {
            var _local_2 = 0;
            var _local_3:SnowWarAnimatedWindowElement = null;
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_2  = ASCompat.toInt(_tmp_);
                _local_3 = this._SafeStr_18586.remove(_local_2);
                if (_local_3 != null)
                {
                    _local_3.dispose();
                }
            }
            if (this._SafeStr_18586.length == 0)
            {
                this._SafeStr_18586.add(-1, new SnowWarAnimatedWindowElement(this._snowWarEngine.assets, Std.downcast(this._SafeStr_9274.findChildByName("mainLoadingIcon") , IBitmapWrapperWindow), "load_", 8));
                WindowUtils._Str_4180(this._SafeStr_9274.findChildByName("loadingText"), "${snowwar.loading_arena}");
            }
        }
    }

