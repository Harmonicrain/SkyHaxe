package com.sulake.habbo.gamecenter
;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.game.GameAssetEnum;
    import flash.events.IEventDispatcher;

     class GameConfigurations 
    {
        static inline final _ICON= "_icon";
        static inline final _SMALL_ICON= "_small_icon";
        static inline final _LOGO= "_logo";
        static inline final _THEME= "_theme";
        static inline final _PNG= ".png";
        static var _games:Vector<GameConfiguration> = new Vector();
        static var _badges:Map = new Map();
        static var _gameListInitialized:Bool = false;
        static var _gameAchievementsInitialized:Bool = false;


        public static function resetGames()
        {
            _games = new Vector<GameConfiguration>();
        }

        public static function resetBadges()
        {
            _badges = new Map();
        }

        public static function addGame(k:GameConfiguration)
        {
            _games.push(k);
        }

        public static function addGameAchievementBadge(k:Int, _arg_2:String)
        {
            _badges.add(_arg_2, k);
        }

        public static function getGame(k:Int):GameConfiguration
        {
            var _local_2:GameConfiguration = null;
            final _iter_ = _games; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.gameId == k)
                {
                    return _local_2;
                }
            }
            return null;
        }

        public static function gameIds():Array<ASAny>
        {
            var _local_2:GameConfiguration = null;
            var k= new Array<ASAny>();
            final _iter_ = _games; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                k.push(_local_2.gameId);
            }
            return k;
        }

        public static function getId(k:String):Int
        {
            var _local_2:GameConfiguration = null;
            final _iter_ = _games; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.gameNameId == k)
                {
                    return _local_2.gameId;
                }
            }
            return -1;
        }

        public static function getNameId(k:Int):String
        {
            var _local_2:GameConfiguration = null;
            final _iter_ = _games; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.gameId == k)
                {
                    return _local_2.gameNameId;
                }
            }
            return null;
        }

        public static function isGameEnabled(k:Int):Bool
        {
            var _local_2:GameConfiguration = null;
            final _iter_ = _games; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.gameId == k)
                {
                    return true;
                }
            }
            return false;
        }

        public static function getBgColor(k:Int):UInt
        {
            var _local_2:GameConfiguration = null;
            final _iter_ = _games; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.gameId == k)
                {
                    return _local_2.bgColor;
                }
            }
            return 0xFF93D4F3;
        }

        public static function getTextColor(k:Int):UInt
        {
            var _local_2:GameConfiguration = null;
            final _iter_ = _games; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.gameId == k)
                {
                    return _local_2.textColor;
                }
            }
            return 0;
        }

        public static function getSupportUrl(k:Int):String
        {
            var _local_2:GameConfiguration = null;
            final _iter_ = _games; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.gameId == k)
                {
                    return _local_2.supportUrl;
                }
            }
            return null;
        }

        public static function getAssetUrl(k:Int, _arg_2:String):String
        {
            var _local_3= getGame(k);
            if (_local_3 == null)
            {
                return "";
            }
            var _local_4= _local_3.assetUrl;
            _local_4 = (_local_4 + _local_3.gameNameId);
            switch (_arg_2)
            {
                case GameAssetEnum.ICON:
                    _local_4 = (_local_4 + _ICON);
                    
                case GameAssetEnum.SMALL_ICON:
                    _local_4 = (_local_4 + _SMALL_ICON);
                    
                case GameAssetEnum.LOGO:
                    _local_4 = (_local_4 + _LOGO);
                    
                case GameAssetEnum.THEME:
                    _local_4 = (_local_4 + _THEME);
                    
            }
            _local_4 = (_local_4 + _PNG);
            return _local_4;
        }

        public static function isGameBadge(k:String):Bool
        {
            return !(_badges.getKeys().indexOf(k) == -1);
        }

        public static function getBadgeImageUri(k:String):String
        {
            var _local_2= ASCompat.toInt(_badges.getValue(k));
            var _local_3= getGame(_local_2);
            if (_local_3 == null)
            {
                return ("${image.library.url}album1584/" + k) + ".gif";
            }
            return ((_local_3.assetUrl + k) + _PNG).toLowerCase();
        }

        public static function setGameListInitialized(k:IEventDispatcher)
        {
            _gameListInitialized = true;
            checkInitialization(k);
        }

        public static function setGameAchievementsInitialized(k:IEventDispatcher)
        {
            _gameAchievementsInitialized = true;
            checkInitialization(k);
        }

        
        public static var initialized(get,set):Bool;
public static function  get_initialized():Bool
        {
            return _gameListInitialized && _gameAchievementsInitialized;
        }
public static function  set_initialized(k:Bool):Bool        {
            _gameListInitialized = k;
            return _gameAchievementsInitialized = k;
        }

        static function checkInitialization(k:IEventDispatcher)
        {
            if (initialized)
            {
                k.dispatchEvent(new GameCenterEvent(GameCenterEvent.GAME_CONFIGURATIONS_INITIALIZED));
            }
        }

	public function new() {}
    }

