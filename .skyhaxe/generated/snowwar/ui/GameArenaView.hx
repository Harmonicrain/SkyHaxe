package snowwar.ui
;
	import com.sulake.core.runtime.IDisposable;
	import com.sulake.room.object.visualization.IRoomObjectSprite;
	import com.sulake.room.object.visualization.IRoomObjectSpriteVisualization;
	import com.sulake.habbo.sound.HabboSoundTypesEnum;
	import com.sulake.habbo.avatar._enum.AvatarAction;
	import com.sulake.habbo.avatar.IAvatarFigureContainer;
	import com.sulake.habbo.room.object.RoomObjectVariableEnum;
	import com.sulake.habbo.room.object.RoomPlaneParser;
	import com.sulake.habbo.room.object.RoomObjectCategoryEnum;
	import com.sulake.room.utils.IVector3d;
	import com.sulake.room.utils.Vector3d;
	import com.sulake.room.object.IRoomObject;
	import com.sulake.room.object.IRoomObjectController;
	import com.sulake.habbo.room.RoomEngine;
	import com.sulake.habbo.room.IStuffData;
	import com.sulake.habbo.room.IRoomEngineServices;
	import com.sulake.habbo.room.IRoomCreator;
	import com.sulake.habbo.catalog._enum._SafeStr_2308;
	import flash.display.BlendMode;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import snowwar.KeyboardListener;
	import snowwar.SnowWarEngine;
	import snowwar.SnowWarGameStage;
	import snowwar.Tile;
	import snowwar._SafeStr_4034;
	import snowwar._str_231._SafeStr_4028;
	import snowwar._str_254.Direction360;
	import snowwar._str_254.Direction8;
	import snowwar._str_39.HumanGameObject;
	import snowwar._str_39.SnowWarGameObject;
	import snowwar._str_39.TreeGameObject;
	import snowwar._str_39._SafeStr_4035;
	import snowwar._str_39._SafeStr_4671;
	import snowwar._str_39._SafeStr_4672;
	import snowwar._str_496.SnowWarFurnitureObject;

     class GameArenaView implements IDisposable 
    {
        static inline final _SafeStr_18716= 1;
        static inline final TILE_CURSOR_STATE_TEAM_1= 3;
        static inline final TILE_CURSOR_STATE_TEAM_2= 2;
        static inline final TILE_CURSOR_STATE_TEAM_3= 4;
        static inline final TILE_CURSOR_STATE_TEAM_4= 5;
        static inline final _SafeStr_18717= 95;
        static inline final _SafeStr_18718= 96;
        static inline final _SafeStr_18719= 98;
        static inline final _SafeStr_18720= 500;

        var _snowWarEngine:SnowWarEngine;
        var _SafeStr_18721:Array<ASAny>;
        var _SafeStr_18722:Array<ASAny>;
        var _SafeStr_18723:Array<ASAny>;
        var _keyboardListener:KeyboardListener;
        var _disposed:Bool = false;
        var _snowWarUI:SnowWarUI;
        var _SafeStr_18726:Bool = false;
        var _stage:Stage;
        var _specialButtonHeld:Bool = false;

        public function new(k:SnowWarEngine)
        {
            this._SafeStr_18721 = [];
            this._SafeStr_18722 = [];
            this._SafeStr_18723 = [];
            this._snowWarEngine = k;
            this._snowWarEngine.roomEngine.addObjectUpdateCategory(RoomObjectCategoryEnum.SNOW_SPLASH);
        }

        public function dispose()
        {
            this._snowWarEngine.roomEngine.disposeRoom(_SafeStr_18716);
            this._snowWarEngine.roomEngine.removeObjectUpdateCategory(RoomObjectCategoryEnum.SNOW_SPLASH);
            if (this._keyboardListener != null)
            {
                this._keyboardListener.dispose();
                this._keyboardListener = null;
            }
            if (this._stage != null)
            {
                this._stage.removeEventListener(MouseEvent.MOUSE_MOVE, (this.onMouseMoveHandler : ASAny));
                this._stage = null;
            }
            this._snowWarEngine = null;
            this._SafeStr_18721 = null;
            this._SafeStr_18722 = null;
            if (this._snowWarUI != null)
            {
                this._snowWarUI.dispose();
                this._snowWarUI = null;
            }
            this._disposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function init()
        {
			HabboGamesCom.log(["GameArenaView::Init()!"]);
            var _local_6:SnowWarFurnitureObject = null;
            var _local_7 = 0;
            var _local_8 = Math.NaN;
            var _local_9:Vector3d = null;
            var _local_10:Vector3d = null;
            var _local_11 = 0;
            var _local_12:IStuffData = null;
            var _local_13 = 0;
            var _local_14 = Math.NaN;
            this._snowWarEngine.roomEngine.setIsSelectedObjectInValidPosition = true;
            var k= Std.downcast(this._snowWarEngine.synchronizedGameArena.synchronizedGameStage() , SnowWarGameStage);
            var _local_2= k._SafeStr_18703;
            var _local_3= k.tileMap();
            var _local_4= new RoomPlaneParser();
            _local_4.initializeTileMap(_local_2.width, _local_2.height);
            var _local_5 = 0;
            while (_local_5 < _local_2.height)
            {
                _local_7 = 0;
                while (_local_7 < _local_2.width)
                {
                    _local_4._Str_3982(_local_7, _local_5, ((_local_3[_local_5][_local_7] == null) ? RoomPlaneParser.TILE_HOLE : 0));
                    _local_7++;
                }
                _local_5++;
            }
            _local_4.initializeFromTileData();
            this._snowWarEngine.roomEngine.initializeRoom(_SafeStr_18716, _local_4.getXML());
            ASCompat.reinterpretAs(this._snowWarEngine.roomEngine , IRoomCreator).updateObjectRoomVisibilities(_SafeStr_18716, false);
            _local_4.dispose();
            final _iter_ = k._SafeStr_18703.fuseObjects; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_6  = _tmp_;
                _local_8 = (_local_6.altitude / Tile.STEP_COST);
                _local_9 = new Vector3d(_local_6.x, _local_6.y, _local_8);
                _local_10 = new Vector3d((_local_6.direction * 45));
                _local_11 = this._snowWarEngine.roomEngine.getFurnitureTypeId(_local_6.name);
                _local_12 = _local_6.extradata;
                _local_13 = 0;
                _local_14 = ASCompat.parseInt(_local_12.getLegacyString());
                if (!Math.isNaN(_local_14))
                {
                    _local_13 = Std.int(_local_14);
                }
                this._snowWarEngine.roomEngine.addObjectFurniture(_SafeStr_18716, _local_6.id, _local_11, _local_9, _local_10, _local_13, _local_12);
            }
            this._snowWarEngine.roomUI.visible = false;
            this._stage = this._snowWarEngine.context.displayObjectContainer.stage;
            this._stage.addEventListener(MouseEvent.MOUSE_MOVE, (this.onMouseMoveHandler : ASAny));
        }

        function onMouseMoveHandler(k:MouseEvent)
        {
            this._specialButtonHeld = (k.altKey || k.shiftKey);
        }

        public function _SafeStr_13264(k:Int)
        {
            this._snowWarUI = new SnowWarUI(this._snowWarEngine);
            this._snowWarUI.init();
            this._SafeStr_18736();
        }

        public function disposeUI()
        {
            if (this._snowWarUI != null)
            {
                this._snowWarUI.dispose();
                this._snowWarUI = null;
            }
        }

        public function update(k:UInt, _arg_2:Bool=false)
        {
            var _local_4:_SafeStr_4028 = null;
            var _local_5 = 0;
            var _local_8:SnowWarGameObject = null;
            var _local_10:Direction8 = null;
            var _local_11:HumanGameObject = null;
            var _local_12 = Math.NaN;
            var _local_13 = Math.NaN;
            var _local_14 = 0;
            var _local_15 = 0;
            var _local_16 = 0;
            var _local_17:IRoomObject = null;
            var _local_18:IVector3d = null;
            var _local_19:ASAny = null;
            var _local_20:HumanGameObject = null;
            var _local_21:_SafeStr_4035 = null;
            var _local_22:_SafeStr_4672 = null;
            var _local_23:_SafeStr_4671 = null;
            var _local_24:TreeGameObject = null;
            var _local_25 = false;
            var _local_26 = 0;
            if ((_arg_2 && (this._keyboardListener != null)))
            {
                _local_10 = this._keyboardListener.direction;
                if (_local_10 != null)
                {
                    _local_11 = Std.downcast(this._snowWarEngine.synchronizedGameArena.synchronizedGameStage().getGameObject(this._snowWarEngine.gamePlayerId) , HumanGameObject);
                    _local_12 = (_local_11.currentLocation.x / Tile.COST);
                    _local_13 = (_local_11.currentLocation.y / Tile.COST);
                    _local_12 = (_local_12 + (_local_10.offsetX() * 2));
                    _local_13 = (_local_13 + (_local_10.offsetY() * 2));
                    this._snowWarEngine._SafeStr_13189(Std.int(_local_12), Std.int(_local_13));
                }
            }
            var _local_3= flash.Lib.getTimer();
            final _iter_ = this._snowWarEngine.synchronizedGameArena.synchronizedGameStage().resetRemovedGameObjects(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_4  = _tmp_;
                _local_14 = _local_4._SafeStr_13236;
                _local_15 = this._SafeStr_18721.indexOf(_local_14);
                if (_local_15 > -1)
                {
                    this._snowWarEngine.roomEngine.disposeObjectUser(_SafeStr_18716, _local_14);
                    this._SafeStr_18721.splice(_local_15, 1);
                }
                _local_16 = this._SafeStr_18722.indexOf(_local_14);
                if (_local_16 > -1)
                {
                    _local_17 = this._snowWarEngine.roomEngine.getRoomObject(_SafeStr_18716, _local_14, RoomObjectCategoryEnum.SNOWBALL);
                    _local_18 = _local_17.getLocation();
                    this._snowWarEngine.roomEngine.updateObjectUserGesture(_SafeStr_18716, _local_14, RoomObjectCategoryEnum.SNOWBALL);
                    this._SafeStr_18722.splice(_local_16, 1);
                    if (!cast(_local_4, SnowWarGameObject).isActive)
                    {
                        this._snowWarEngine.roomEngine._SafeStr_7811(_SafeStr_18716, _local_14, _local_18, RoomObjectCategoryEnum.SNOW_SPLASH);
                        this._SafeStr_18723.push({
                            "id":_local_14,
                            "time":_local_3,
                            "category":RoomObjectCategoryEnum.SNOW_SPLASH
                        });
                    }
                }
            }
            _local_5 = (this._SafeStr_18723.length - 1);
            while (_local_5 > -1)
            {
                _local_19 = this._SafeStr_18723[_local_5];
                if ((_local_3 - ASCompat.toNumber(_local_19.time)) >= _SafeStr_18720)
                {
                    this._snowWarEngine.roomEngine.updateObjectUserGesture(_SafeStr_18716, ASCompat.toInt(_local_19.id), ASCompat.toInt(_local_19.category));
                    this._SafeStr_18723.splice(_local_5, 1);
                }
                _local_5--;
            }
            var _local_6= this._snowWarEngine.synchronizedGameArena.synchronizedGameStage()._SafeStr_18711();
            var _local_7 = false;
            if (checkNullIteratee(_local_6)) for (_tmp_ in _local_6)
            {
_local_8  = _tmp_;
                _local_20 = Std.downcast(_local_8 , HumanGameObject);
                if (_local_20 != null)
                {
                    _local_25 = (_local_20.posture == AvatarAction.SNOWWAR_RUN);
                    _local_7 = (_local_7 || _local_25);
                    this._SafeStr_18728(_local_20);
                    if (_local_20._SafeStr_13236 == this._snowWarEngine.gamePlayerId)
                    {
                        _local_26 = Std.downcast(this._snowWarEngine.synchronizedGameArena.getExtension() , _SafeStr_4034)._SafeStr_13253();
                        this._snowWarUI._SafeStr_18740 = Std.int(this._snowWarEngine.gameDuration - ((this._snowWarEngine.currentSubTurn * _local_26) / 1000));
                        this._snowWarUI._SafeStr_18741 = _local_20.score;
                        this._snowWarUI._SafeStr_18742 = _local_20._SafeStr_18742;
                        this._snowWarUI._SafeStr_12584 = _local_20._SafeStr_12584;
                    }
                }
                _local_21 = Std.downcast(_local_8 , _SafeStr_4035);
                if (_local_21 != null)
                {
                    this._SafeStr_18729(_local_21);
                }
                _local_22 = Std.downcast(_local_8 , _SafeStr_4672);
                if (_local_22 != null)
                {
                    this._SafeStr_18730(_local_22);
                }
                _local_23 = Std.downcast(_local_8 , _SafeStr_4671);
                if (_local_23 != null)
                {
                    this._SafeStr_18731(_local_23);
                }
                _local_24 = Std.downcast(_local_8 , TreeGameObject);
                if (_local_24 != null)
                {
                    this._SafeStr_18732(_local_24);
                }
            }
            if (this._snowWarUI != null)
            {
                this._snowWarUI.update(k);
            }
            if ((_local_7 && (!this._SafeStr_18726)))
            {
                this._SafeStr_18726 = true;
                SnowWarEngine.playSound(HabboSoundTypesEnum.GAMES_SW_WALK, ASCompat.MAX_INT);
            }
            else
            {
                if (((!_local_7) && this._SafeStr_18726))
                {
                    this._SafeStr_18726 = false;
                    SnowWarEngine.stopSound(HabboSoundTypesEnum.GAMES_SW_WALK);
                }
            }
            var _local_9= this._snowWarEngine._SafeStr_13187();
            this._snowWarEngine.roomEngine.updateObjectUserEffect(_SafeStr_18716, _local_9._SafeStr_13236, ((_local_9.team == 1) ? _SafeStr_18718 : _SafeStr_18717));
        }

        function _SafeStr_18728(k:HumanGameObject)
        {
            var _local_9:IAvatarFigureContainer = null;
            var _local_10 = false;
            var _local_11:IRoomObjectSpriteVisualization = null;
            var _local_12 = false;
            var _local_2= (k.currentLocation.x / Tile.COST);
            var _local_3= (k.currentLocation.y / Tile.COST);
            var _local_4= k._SafeStr_13236;
            var _local_5= k._SafeStr_18743();
            var _local_6= Direction360.direction8ToDirection360Value(Direction8.fromIndex(_local_5));
            var _local_7:IVector3d = new Vector3d(_local_6, 0, 0);
            if (this._SafeStr_18721.indexOf(_local_4) == -1)
            {
                _local_9 = this._snowWarEngine.avatarRenderManager._Str_718(k.figure);
                switch (k.team)
                {
                    case 1:
                        _local_9._Str_830("ch", 20000, [1]);
                        
                    case 2:
                        _local_9._Str_830("ch", 20001, [1]);
                        
                    default:
                        _local_9._Str_830("ch", 20000, [1]);
                }
                this._snowWarEngine.roomEngine.addObjectUser(_SafeStr_18716, _local_4, new Vector3d(_local_2, _local_3, 0), _local_7, _local_6, 1, _local_9.getFigureString());
                this._snowWarEngine.roomEngine.updateObjectUserPosture(_SafeStr_18716, _local_4, "std");
                this._snowWarEngine.roomEngine.updateObjectUserAction(_SafeStr_18716, _local_4, RoomObjectVariableEnum.FIGURE_IS_PLAYING_GAME, 1);
                this._SafeStr_18721.push(_local_4);
                switch (k._SafeStr_18745)
                {
                    case _SafeStr_2308._SafeStr_10198:
                        this._SafeStr_18734(this._SafeStr_18733(_local_4));
                        
                    case _SafeStr_2308._SafeStr_7300:
                        this._SafeStr_18735(this._SafeStr_18733(_local_4));
                        
                }
            }
            else
            {
                this._snowWarEngine.roomEngine.updateObjectUser(_SafeStr_18716, _local_4, new Vector3d(_local_2, _local_3, 0), new Vector3d(_local_2, _local_3, 0), false, 0, _local_7, _local_6);
                this._snowWarEngine.roomEngine.updateObjectUserPosture(_SafeStr_18716, _local_4, k.posture);
                _local_10 = ((!(k.posture == AvatarAction.SNOWWAR_DIE_BACK)) && (!(k.posture == AvatarAction.SNOWWAR_DIE_FRONT)));
                this._snowWarEngine.roomEngine.updateObjectUserAction(_SafeStr_18716, _local_4, RoomObjectVariableEnum.FIGURE_IS_PLAYING_GAME, ASCompat.toInt(_local_10));
            }
            var _local_8= this._SafeStr_18733(_local_4);
            if (_local_8 != null)
            {
                _local_11 = Std.downcast(_local_8.getVisualization() , IRoomObjectSpriteVisualization);
                _local_11.getSprite(0).alpha = (k._SafeStr_18748 ? 100 : 0xFF);
                _local_12 = (!(k.team == this._snowWarEngine._SafeStr_13187().team));
                if (_local_12)
                {
                    if ((((ASCompat.reinterpretAs(this._snowWarEngine.roomEngine , IRoomEngineServices).playerUnderCursor == _local_4) && (!k._SafeStr_18748)) && (!k._SafeStr_18749())))
                    {
                        this._snowWarEngine.roomEngine.updateObjectUserEffect(_SafeStr_18716, _local_4, _SafeStr_18719);
                    }
                    else
                    {
                        this._snowWarEngine.roomEngine.updateObjectUserEffect(_SafeStr_18716, _local_4, 0);
                    }
                }
            }
        }

        function _SafeStr_18729(k:_SafeStr_4035)
        {
            var _local_2= (k.location3D.x / Tile.COST);
            var _local_3= (k.location3D.y / Tile.COST);
            var _local_4= (k.location3D.z / Tile.STEP_COST);
            var _local_5= new Vector3d(_local_2, _local_3, _local_4);
            var _local_6= k._SafeStr_13236;
            if (this._SafeStr_18722.indexOf(_local_6) == -1)
            {
				//Figure this out. game_snowball //DONE
                this._snowWarEngine.roomEngine._SafeStr_7811(_SafeStr_18716, _local_6, _local_5, RoomObjectCategoryEnum.SNOWBALL);
                this._SafeStr_18722.push(_local_6);
            }
            else
            {
				//Figure this out. RoomEngine. Names have changed /removed. Possibly need to be re-added? //DONE
                this._snowWarEngine.roomEngine._SafeStr_7817(_SafeStr_18716, _local_6, _local_5, RoomObjectCategoryEnum.SNOWBALL);
            }
        }

        function _SafeStr_18730(k:_SafeStr_4672)
        {
            var _local_2= Std.downcast(this._snowWarEngine.roomEngine , RoomEngine);
            var _local_3= Std.downcast(_local_2.getRoomObject(_SafeStr_18716, k._SafeStr_18032, RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE) , IRoomObjectController);
            if (_local_3.getState(0) != k._SafeStr_18035)
            {
                _local_2.updateObjectFurniture(_SafeStr_18716, k._SafeStr_18032, null, null, k._SafeStr_18035, null);
                _local_3.setState(k._SafeStr_18035, 0);
            }
        }

        function _SafeStr_18731(k:_SafeStr_4671)
        {
            var _local_2= Std.downcast(this._snowWarEngine.roomEngine , RoomEngine);
            var _local_3= Std.downcast(_local_2.getRoomObject(_SafeStr_18716, k._SafeStr_18032, RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE) , IRoomObjectController);
            var _local_4= (k._SafeStr_18034 - k._SafeStr_18035);
            if (((_local_3 != null) && (!(_local_3.getState(0) == _local_4))))
            {
                _local_2.updateObjectFurniture(_SafeStr_18716, k._SafeStr_18032, null, null, _local_4, null);
                _local_3.setState(_local_4, 0);
            }
        }

        function _SafeStr_18732(k:TreeGameObject)
        {
            var _local_2= Std.downcast(this._snowWarEngine.roomEngine , RoomEngine);
            var _local_3= Std.downcast(_local_2.getRoomObject(_SafeStr_18716, k._SafeStr_18032, RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE) , IRoomObjectController);
            if (((_local_3 != null) && (!(_local_3.getState(0) == k.hits))))
            {
                _local_2.updateObjectFurniture(_SafeStr_18716, k._SafeStr_18032, null, null, k.hits, null);
                _local_3.setState(k.hits, 0);
            }
        }

        function _SafeStr_18733(k:Int):IRoomObject
        {
            return this._snowWarEngine.roomEngine.getRoomObject(_SafeStr_18716, k, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER);
        }

        function _SafeStr_18734(k:IRoomObject)
        {
            var _local_2:IRoomObjectSpriteVisualization = null;
            var _local_3 = 0;
            var _local_4:IRoomObjectSprite = null;
            if (k != null)
            {
                _local_2 = Std.downcast(k.getVisualization() , IRoomObjectSpriteVisualization);
                _local_3 = 0;
                while (_local_3 < _local_2.spriteCount)
                {
                    _local_4 = _local_2.getSprite(_local_3);
                    _local_4.blendMode = BlendMode.HARDLIGHT;
                    _local_3++;
                }
            }
        }

        function _SafeStr_18735(k:IRoomObject)
        {
            var _local_2:IRoomObjectSpriteVisualization = null;
            var _local_3 = 0;
            var _local_4:IRoomObjectSprite = null;
            if (k != null)
            {
                _local_2 = Std.downcast(k.getVisualization() , IRoomObjectSpriteVisualization);
                _local_3 = 0;
                while (_local_3 < _local_2.spriteCount)
                {
                    _local_4 = _local_2.getSprite(_local_3);
                    _local_4.visible = false;
                    _local_3++;
                }
            }
        }

        public function setChecksumIndicatorColor(k:UInt)
        {
            this._snowWarUI.setChecksumIndicatorColor(k);
        }

        function _SafeStr_18736()
        {
            this._snowWarUI._SafeStr_18750();
            this._snowWarUI.update(1000);
        }

        public function _SafeStr_13238(k:Int)
        {
            var _local_2 = 0;
            switch (k)
            {
                case 1:
                    _local_2 = TILE_CURSOR_STATE_TEAM_1;
                    
                case 2:
                    _local_2 = TILE_CURSOR_STATE_TEAM_2;
                    
                case 3:
                    _local_2 = TILE_CURSOR_STATE_TEAM_3;
                    
                case 4:
                    _local_2 = TILE_CURSOR_STATE_TEAM_4;
                    
                default:
                    _local_2 = 0;
            }
            this._snowWarEngine.roomEngine.setTileCursorState(_SafeStr_18716, _local_2);
        }

        public function _SafeStr_13225()
        {
            if (this._snowWarUI != null)
            {
                this._snowWarUI._SafeStr_13225();
            }
        }

        public function _SafeStr_13237()
        {
            if (this._snowWarUI != null)
            {
                this._snowWarUI._SafeStr_13237();
            }
        }

        public function _SafeStr_13280(k:Bool)
        {
            if (this._snowWarUI != null)
            {
                this._snowWarUI._SafeStr_13280(k);
            }
        }
    }

