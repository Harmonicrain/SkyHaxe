package com.sulake.habbo.gamecenter
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.room.IGetImageListener;
    import com.sulake.habbo.game.HabboGameManager;
    import flash.utils.Timer;
    import com.sulake.habbo.window.utils.IAlertDialog;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.session.ISessionDataManager;
    import com.sulake.habbo.avatar.IAvatarRenderManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.room.IRoomEngine;
    import flash.events.TimerEvent;
    import com.sulake.habbo.communication.messages.incoming.game.score.WeeklyGameRewardEvent;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.communication.messages.outgoing.game.score.GetWeeklyGameRewardComposer;
    import com.sulake.core.communication.messages.IMessageEvent;
    import flash.display.BitmapData;

     class GameCenterView implements IDisposable implements  IGetImageListener 
    {
        static inline final _Str_7257= 3000;

        var _disposed:Bool = false;
        var _gameManager:HabboGameManager;
        var _layout:GameCenterLayout;
        var _leaderboard:LeaderboardView;
        var _waitingGame:WaitingGameView;
        var _teaserView:TeaserView;
        var _waitingGameTimer:Timer;
        var _waitingGameId:Int = -1;
        var _alert:IAlertDialog;
        var _gameRewardListener:IGameRewardListener;
        var _waitingRewardFurniId:Int = 0;
        var _startPlaying:Bool = false;

        public function new(k:HabboGameManager)
        {
            this._gameManager = k;
        }

        public var windowManager(get,never):IHabboWindowManager;
public function  get_windowManager():IHabboWindowManager
        {
            return this._gameManager.windowManager;
        }

        public var communication(get,never):IHabboCommunicationManager;
public function  get_communication():IHabboCommunicationManager
        {
            return this._gameManager.communication;
        }

        public var localization(get,never):IHabboLocalizationManager;
public function  get_localization():IHabboLocalizationManager
        {
            return this._gameManager.localization;
        }

        public var sessionDataManager(get,never):ISessionDataManager;
public function  get_sessionDataManager():ISessionDataManager
        {
            return this._gameManager.sessionDataManager;
        }

        public var avatarRenderManager(get,never):IAvatarRenderManager;
public function  get_avatarRenderManager():IAvatarRenderManager
        {
            return this._gameManager.avatarRenderManager;
        }

        public var assets(get,never):IAssetLibrary;
public function  get_assets():IAssetLibrary
        {
            return this._gameManager.assets;
        }

        public var roomEngine(get,never):IRoomEngine;
public function  get_roomEngine():IRoomEngine
        {
            return this._gameManager.roomEngine;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var gameManager(get,never):HabboGameManager;
public function  get_gameManager():HabboGameManager
        {
            return this._gameManager;
        }

        public function dispose()
        {
            if (this._layout != null)
            {
                this._layout.dispose();
                this._layout = null;
            }
            if (this._leaderboard != null)
            {
                this._leaderboard.dispose();
                this._leaderboard = null;
            }
            this._waitingGameId = -1;
            if (this._waitingGame != null)
            {
                this._waitingGame.dispose();
                this._waitingGame = null;
            }
            if (this._waitingGameTimer != null)
            {
                this._waitingGameTimer.removeEventListener(TimerEvent.TIMER, (this._Str_10599 : ASAny));
                this._waitingGameTimer.stop();
                this._waitingGameTimer = null;
            }
            if (this._teaserView != null)
            {
                this._teaserView.dispose();
                this._teaserView = null;
            }
            this._Str_18574();
            this._gameManager = null;
            this._disposed = true;
        }

        public function initialize(k:Int, _arg_2:Bool)
        {
            var _local_3:Array<ASAny> = null;
            this._startPlaying = _arg_2;
            if (this._layout == null)
            {
                this._layout = new GameCenterLayout(this);
            }
            if (!GameConfigurations.isGameEnabled(k))
            {
                _local_3 = GameConfigurations.gameIds();
                if (((_local_3 != null) && (_local_3.length > 0)))
                {
                    k = ASCompat.toInt(_local_3[0]);
                }
            }
            if (GameConfigurations.isGameEnabled(k))
            {
                this.activate(k, _arg_2);
            }
            this.communication.addHabboConnectionMessageEvent(new WeeklyGameRewardEvent(this._Str_23350));
        }

        public function activate(k:Int, _arg_2:Bool)
        {
            if (this._layout != null)
            {
                this._layout.activate(k, _arg_2);
            }
        }

        public function disable()
        {
            if (this._layout != null)
            {
                this._layout.disable();
            }
            if (this._leaderboard != null)
            {
                this._leaderboard.disable();
            }
            if (this._waitingGame != null)
            {
                this._waitingGame.disable();
            }
            if (this._teaserView != null)
            {
                this._teaserView.disable();
            }
        }

        public function _Str_18157(k:Int)
        {
            if (this._leaderboard != null)
            {
                this._leaderboard._Str_18157(k);
            }
        }

        public var isHotelClosed(get,never):Bool;
public function  get_isHotelClosed():Bool
        {
            return this._gameManager.isHotelClosed;
        }

        public function getLocalization(k:Int):String
        {
            var _local_2= GameConfigurations.getNameId(k);
            return this.localization.getLocalization((("gamecenter." + _local_2) + ".name"));
        }

        public function _Str_3777(k:String, _arg_2:String, _arg_3:String="", _arg_4:Int=0)
        {
            this._gameManager._Str_3777(k, _arg_2, _arg_3, _arg_4);
        }

        public function registerParameter(k:Int, _arg_2:String):String
        {
            return this.localization.registerParameter(_arg_2, "game", this.getLocalization(k));
        }

        public function send(k:IMessageComposer)
        {
            this._gameManager.send(k);
        }

        public function joinPlayerQueue(k:Int)
        {
            this._startPlaying = false;
            this._gameManager.joinPlayerQueue(k);
        }

        public function leavePlayerQueue(k:Int)
        {
            this._gameManager.leavePlayerQueue(k);
        }

        public function showLeaderboard(k:Int)
        {
            if (this._leaderboard == null)
            {
                this._leaderboard = new LeaderboardView(this);
            }
            this._leaderboard.activate(k);
            this._Str_3777(GameConfigurations.getNameId(k), "showLeaderboard");
        }

        public function _Str_26125(k:Int)
        {
            if (this._teaserView == null)
            {
                this._teaserView = new TeaserView(this);
            }
            this._teaserView.activate(k);
            this._Str_3777(GameConfigurations.getNameId(k), "showTeaser");
        }

        public function _Str_19498(k:Int)
        {
            if (this._waitingGameId > -1)
            {
                return;
            }
            if (this._waitingGame == null)
            {
                this._waitingGame = new WaitingGameView(this);
            }
            if (this._waitingGameTimer == null)
            {
                this._waitingGameTimer = new Timer(_Str_7257, 1);
                this._waitingGameTimer.addEventListener(TimerEvent.TIMER, (this._Str_10599 : ASAny));
            }
            this._waitingGameTimer.start();
            this._waitingGameId = k;
        }

        function _Str_10599(k:TimerEvent)
        {
            if (this._waitingGameId > -1)
            {
                this._waitingGame.activate(this._waitingGameId);
            }
        }

        public function _Str_18594(k:Int)
        {
            this._waitingGameId = -1;
            if (this._waitingGameTimer != null)
            {
                this._waitingGameTimer.reset();
            }
            if (this._waitingGame != null)
            {
                this._waitingGame.disable();
            }
        }

        public function showAlert(k:String)
        {
            this._Str_18574();
            this._alert = this.windowManager.alert("Game Center Alert", k, 0, this.onAlertClose);
        }

        function _Str_18574()
        {
            if (this._alert != null)
            {
                this._alert.dispose();
                this._alert = null;
            }
        }

        function onAlertClose(k:IAlertDialog, _arg_2:WindowEvent)
        {
            this._Str_18574();
        }

        public function openVipBuying(k:Int)
        {
            this._startPlaying = false;
            var _local_2= GameConfigurations.getNameId(k);
            this._gameManager._Str_22538(_local_2, "getVip.clicked.playNow");
        }

        public function getWeeklyGameRewardInformation(k:IGameRewardListener)
        {
            this._gameRewardListener = k;
            this.send(new GetWeeklyGameRewardComposer(k.getCurrentlySelectedGame()));
        }

        function _Str_23350(k:IMessageEvent)
        {
        }

        public function imageReady(k:Int, _arg_2:BitmapData)
        {
            if ((((this._waitingRewardFurniId == k) && (this._gameRewardListener != null)) && (!ASCompat.reinterpretAs(this._gameRewardListener , IDisposable).disposed)))
            {
                this._gameRewardListener.setGameRewardImage(_arg_2);
            }
            this._waitingRewardFurniId = -1;
            this._gameRewardListener = null;
        }

        public function imageFailed(k:Int)
        {
        }

        @:allow(com.sulake.habbo.gamecenter) var startPlaying(get,never):Bool;
function  get_startPlaying():Bool
        {
            return this._startPlaying;
        }
    }

