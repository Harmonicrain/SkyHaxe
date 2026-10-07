package com.sulake.habbo.game
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.communication.messages.incoming.availability.HotelWillCloseInMinutesEvent;
    import com.sulake.habbo.communication.messages.incoming.game.lobby.GameListMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.availability.MaintenanceStatusMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.game.lobby.GameAchievementsMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.game.lobby.UnloadGameMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.game.lobby.LoadGameMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.availability.HotelClosesAndWillOpenAtEvent;
    import com.sulake.habbo.communication.messages.incoming.game.directory.Game2AccountGameStatusMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.game.lobby.LeftQueueMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.handshake.AuthenticationOKMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.game.lobby.JoinedQueueMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.game.lobby.LoadGameUrlMessageEvent;
    import com.sulake.habbo.communication.messages.outgoing.game.directory.Game2GetAccountGameStatusMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.game.lobby.GetGameListMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.game.lobby.GetGameAchievementsMessageComposer;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.game.lobby.GameConfigurationData;
    import com.sulake.habbo.communication.messages.parser.game.lobby.GameListMessageParser;
    import com.sulake.habbo.gamecenter.GameConfigurations;
    import com.sulake.habbo.gamecenter.GameConfiguration;
    import com.sulake.habbo.communication.messages.parser.game.lobby.GameAchievementData;
    import com.sulake.habbo.communication.messages.parser.game.lobby.GameAchievementsMessageParser;

     class IncomingMessages implements IDisposable 
    {
        var _gameManager:HabboGameManager;
        var _isDisposed:Bool = false;

        public function new(k:HabboGameManager)
        {
            this._gameManager = k;
            var _local_2= this._gameManager.communication;
            _local_2.addHabboConnectionMessageEvent(new HotelWillCloseInMinutesEvent(this.onHotelClosed));
            _local_2.addHabboConnectionMessageEvent(new GameListMessageEvent(this.onGameList));
            _local_2.addHabboConnectionMessageEvent(new MaintenanceStatusMessageEvent(this.onHotelClosed));
            _local_2.addHabboConnectionMessageEvent(new GameAchievementsMessageEvent(this.onGameAchievements));
            _local_2.addHabboConnectionMessageEvent(new UnloadGameMessageEvent(this.onUnloadGame));
            _local_2.addHabboConnectionMessageEvent(new LoadGameMessageEvent(this.onLoadGame));
            _local_2.addHabboConnectionMessageEvent(new HotelClosesAndWillOpenAtEvent(this.onHotelClosed));
            _local_2.addHabboConnectionMessageEvent(new Game2AccountGameStatusMessageEvent(this.onAccountGameStatus));
            _local_2.addHabboConnectionMessageEvent(new LeftQueueMessageEvent(this.onLeftQueue));
            _local_2.addHabboConnectionMessageEvent(new AuthenticationOKMessageEvent(this.onAuthenticationOk));
            _local_2.addHabboConnectionMessageEvent(new JoinedQueueMessageEvent(this.onJoinedQueue));
            _local_2.addHabboConnectionMessageEvent(new LoadGameUrlMessageEvent(this.onLoadGameUrl));
        }

        public function dispose()
        {
            this._gameManager = null;
            this._isDisposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._isDisposed;
        }

        function onJoinedQueue(k:JoinedQueueMessageEvent)
        {
            var _local_2= k.getParser();
            HabboGamesCom.log([("[BaseJump] joined queue for game " + Std.string(_local_2.gameTypeId))]);
        }

        function onLeftQueue(k:LeftQueueMessageEvent)
        {
            var _local_2= k.getParser();
            HabboGamesCom.log([("[BaseJump] left queue for game " + Std.string(_local_2.gameTypeId))]);
        }

        function onLoadGame(k:LoadGameMessageEvent)
        {
            var _local_2= k.getParser();
            HabboGamesCom.log([((("[BaseJump] load game " + Std.string(_local_2.gameTypeId)) + " url:") + _local_2.url)]);
            this._gameManager.loadGameClient(_local_2.gameTypeId, _local_2._Str_12486, _local_2.url, _local_2.quality, _local_2.scaleMode, _local_2.frameRate, _local_2.minMajorVersion, _local_2.minMinorVersion, _local_2.params);
        }

        function onLoadGameUrl(k:LoadGameUrlMessageEvent)
        {
            var _local_2= k.getParser();
            HabboGamesCom.log([((("[BaseJump] load game url " + Std.string(_local_2.gameTypeId)) + " url:") + _local_2.url)]);
            this._gameManager._Str_19055(_local_2.gameTypeId, _local_2._Str_12486, _local_2.url);
        }

        function onUnloadGame(k:UnloadGameMessageEvent)
        {
            var _local_2= k.getParser();
            HabboGamesCom.log([("[BaseJump] unload game " + Std.string(_local_2.gameTypeId))]);
            this._gameManager.unloadGame(_local_2.gameTypeId, _local_2._Str_12486, "unloadGameClient");
        }

        function onAccountGameStatus(k:Game2AccountGameStatusMessageEvent)
        {
            var _local_2= k.getParser();
            if (_local_2.gameTypeId == this._gameManager.promotedGameId())
            {
                this._gameManager._Str_23215(_local_2.gamesPlayedTotal);
                this._gameManager._Str_22499();
            }
        }

        function onAuthenticationOk(k:AuthenticationOKMessageEvent)
        {
            var _local_2= this._gameManager.promotedGameId();
            if (_local_2 != -1)
            {
                this._gameManager.send(new Game2GetAccountGameStatusMessageComposer(_local_2));
            }
            this._gameManager.send(new GetGameListMessageComposer());
            this._gameManager.send(new GetGameAchievementsMessageComposer());
        }

        function onHotelClosed(k:IMessageEvent)
        {
            this._gameManager.hotelClosed = true;
        }

        function onGameList(k:GameListMessageEvent)
        {
            var _local_3:GameConfigurationData = null;
            var _local_2= Std.downcast(k.parser , GameListMessageParser);
            GameConfigurations.resetGames();
            final _iter_ = _local_2.games; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                GameConfigurations.addGame(new GameConfiguration(_local_3.gameId, _local_3.gameNameId, _local_3.bgColor, _local_3.textColor, _local_3.assetUrl, _local_3.supportUrl));
            }
            GameConfigurations.setGameListInitialized(this._gameManager.events);
        }

        function onGameAchievements(k:GameAchievementsMessageEvent)
        {
            var _local_3:GameAchievementData = null;
            var _local_4 = 0;
            var _local_5:String = null;
            var _local_2= Std.downcast(k.parser , GameAchievementsMessageParser);
            GameConfigurations.resetBadges();
            final _iter_ = _local_2.achievements; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                _local_4 = 1;
                while (_local_4 <= _local_3.levels)
                {
                    _local_5 = (("ACH_" + _local_3.achievementName) + Std.string(_local_4));
                    GameConfigurations.addGameAchievementBadge(_local_3.gameTypeId, _local_5);
                    _local_4++;
                }
            }
            GameConfigurations.setGameAchievementsInitialized(this._gameManager.events);
        }
    }

