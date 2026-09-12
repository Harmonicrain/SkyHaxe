package snowwar._str_39
;
    import snowwar.Tile;
    import snowwar._str_254.Location;
    import snowwar._str_254.Direction8;
    import snowwar.SnowWarEngine;
    import com.sulake.core.utils.Map;
    import snowwar.SnowWarGameStage;
    import snowwar._str_62.HumanGameObjectData;
    import snowwar._str_62.SnowWarGameObjectData;
    import com.sulake.core.runtime.exceptions.Exception;
    import snowwar._str_254.CollisionDetection;
    import snowwar._str_254.Direction360;
    import snowwar._str_231.SynchronizedGameStage;
    import snowwar._str_254._SafeStr_4667;
    import com.sulake.habbo.sound.HabboSoundTypesEnum;
    import snowwar._SafeStr_4034;
    import snowwar._str_231.SynchronizedGameArena;
	import com.sulake.habbo.avatar._enum.AvatarAction;
	import com.sulake.habbo.room.object.RoomObjectVariableEnum;

     class HumanGameObject extends SnowWarGameObject 
    {
        public static inline final _SafeStr_18811= 534;
        public static inline final _SafeStr_18812= 5;
        public static inline final _SafeStr_18813= 5;
        public static inline final _SafeStr_18814= 5;
        public static inline final _SafeStr_18815= 20;
        public static inline final _SafeStr_18816= 100;
        public static inline final _SafeStr_18817= 60;
        public static inline final _SafeStr_18818= 0;
        public static inline final _SafeStr_18819= 1;
        public static inline final _SafeStr_18820= 2;
        public static inline final _SafeStr_18821= 3;
        public static inline final _SafeStr_18822= 5;
        public static final _SafeStr_18823:Array<ASAny> = [1600];
        public static inline final _SafeStr_18824= 5000;
        static inline final _SafeStr_18825= 5;
        static inline final _SafeStr_18826= 1;

        var _currentTile:Tile;
        var _nextTile:Tile;
        var _SafeStr_18827:Bool = false;
        var _currentLocation:Location;
        var _moveTarget:Location;
        var _stoppedDir:Direction8;
        var _SafeStr_18829:Int = 0;
        var _SafeStr_18830:Int = 0;
        var _SafeStr_18831:Int = 0;
        var _SafeStr_18832:Int = 0;
        var _SafeStr_18833:Int = 0;
        var _score:Int = 0;
        var _team:Int = 0;
        var _SafeStr_18835:Int = 0;
        var _name:String;
        var _mission:String;
        var _figure:String;
        var _sex:String;
        var _userId:Int = 0;
        var _SafeStr_18836:Int = 0;
        var _SafeStr_18579:SnowWarEngine;
        var _SafeStr_18837:Map;

        public function new(k:SnowWarGameStage, _arg_2:HumanGameObjectData, _arg_3:Bool, _arg_4:SnowWarEngine)
        {
            this._currentLocation = new Location(0, 0, 0);
            this._moveTarget = new Location(0, 0, 0);
            this._stoppedDir = Direction8.SE;
            super(_arg_2.id, _arg_3);
            this._sex = _arg_2.sex;
            this._name = _arg_2.name;
            this._mission = _arg_2.mission;
            this._figure = _arg_2.figure;
            this._team = _arg_2.team;
            this._userId = _arg_2.userId;
            this._SafeStr_18833 = _arg_2._SafeStr_12588;
            this._SafeStr_18832 = _arg_2._SafeStr_12587;
            this._currentLocation.setPosition(_arg_2.x, _arg_2.y);
            this._stoppedDir = Direction8.fromIndex(_arg_2._SafeStr_12583);
            this._SafeStr_18829 = _arg_2._SafeStr_12584;
            this._moveTarget.setPosition(_arg_2._SafeStr_12591, _arg_2._SafeStr_12592);
            this._SafeStr_18830 = _arg_2._SafeStr_12585;
            this._score = _arg_2.score;
			trace("Human Game Object: " + Std.string(_arg_2._SafeStr_12581) + " | " + Std.string(_arg_2._SafeStr_12582));
			trace(k.tileMap());
            this._currentTile = k.getTileAt(_arg_2._SafeStr_12581, _arg_2._SafeStr_12582);
			if (this._currentTile == null)
			{
				throw cast("Human Game Object: " + Std.string(_arg_2._SafeStr_12581) + " | " + Std.string(_arg_2._SafeStr_12582) + " > " + ASCompat.toString(k.tileMap()) == null + " /" + Std.string(k.tileMap().length), ASError);
			}
            this._currentTile.addActiveGameObject(this);
            var _local_5= k.getTileAt(_arg_2._SafeStr_12589, _arg_2._SafeStr_12590);
            if (_local_5 != this._currentTile)
            {
                this._nextTile = _local_5;
                this._nextTile.addActiveGameObject(this);
                this._currentTile.removeHumanGameObject();
                this._SafeStr_18827 = true;
            }
            this._SafeStr_18579 = _arg_4;
            this._SafeStr_18837 = new Map();
        }

        
        public var _SafeStr_18745(get,set):Int;
public function  get__SafeStr_18745():Int
        {
            return this._SafeStr_18836;
        }
public function  set__SafeStr_18745(k:Int):Int        {
            return this._SafeStr_18836 = k;
        }

        public var _SafeStr_18748(get,never):Bool;
public function  get__SafeStr_18748():Bool
        {
            return this._SafeStr_18833 == _SafeStr_18821;
        }

        override public function dispose()
        {
            super.dispose();
            this._sex = "";
            this._name = "";
            this._mission = "";
            this._figure = "";
            this._team = 0;
            this._userId = 0;
            this._currentLocation = null;
            this._stoppedDir = null;
            this._moveTarget = null;
            this._SafeStr_18830 = 0;
            this._score = 0;
            this._SafeStr_18827 = false;
            this._SafeStr_18579 = null;
            this._SafeStr_18837 = null;
        }

        override public function  get_numberOfVariables():Int
        {
            return HumanGameObjectData.NUM_OF_VARIABLES;
        }

        override public function getVariable(k:Int):Int
        {
            switch (k)
            {
                case 0:
                    return SnowWarGameObjectData.OBJECT_TYPE_HUMAN;
                case 1:
                    return _id;
                case 2:
                    return this._currentLocation.x;
                case 3:
                    return this._currentLocation.y;
                case 4:
                    return ASCompat.toInt(this._currentTile._SafeStr_18688[0]);
                case 5:
                    return ASCompat.toInt(this._currentTile._SafeStr_18688[1]);
                case 6:
                    return this._stoppedDir.index();
                case 7:
                    return this._SafeStr_18829;
                case 8:
                    return this._SafeStr_18830;
                case 9:
                    return this._SafeStr_18831;
                case 10:
                    return this._SafeStr_18832;
                case 11:
                    return this._SafeStr_18833;
                case 12:
                    return ASCompat.toInt((this._nextTile != null) ? ASCompat.toInt(this._nextTile._SafeStr_18688[0] ): ASCompat.toInt(this._currentTile._SafeStr_18688[0]));
                case 13:
                    return ASCompat.toInt((this._nextTile != null) ? ASCompat.toInt(this._nextTile._SafeStr_18688[1] ): ASCompat.toInt(this._currentTile._SafeStr_18688[1]));
                case 14:
                    return this._moveTarget.x;
                case 15:
                    return this._moveTarget.y;
                case 16:
                    return this._score;
                case 17:
                    return this._team;
                case 18:
                    return this._userId;
            }
            throw new Exception(("No such variable:" + Std.string(k)));
        }

        public function _SafeStr_13261(k:HumanGameObject)
        {
            this._currentLocation.setPosition(k._currentLocation.x, k._currentLocation.y);
            this._currentTile = k._currentTile;
            this._stoppedDir = k._stoppedDir;
            this._SafeStr_18829 = k._SafeStr_18829;
            this._SafeStr_18830 = k._SafeStr_18830;
            this._SafeStr_18831 = k._SafeStr_18831;
            this._SafeStr_18832 = k._SafeStr_18832;
            this._SafeStr_18833 = k._SafeStr_18833;
            this._nextTile = k._nextTile;
            this._moveTarget.setPosition(k._moveTarget.x, k._moveTarget.y);
            this._score = k._score;
            this._team = k._team;
            this._userId = k._userId;
        }

        public function _SafeStr_13259(k:Int, _arg_2:Location):Bool
        {
            var _local_3:Location = this._SafeStr_18837.getValue(k);
            if (_local_3 != null)
            {
                return _local_3._SafeStr_18791(_arg_2, Tile.STEP_DIAG_COST);
            }
            return false;
        }

        public function _SafeStr_13262(k:Int)
        {
            var _local_2= new Location(0, 0, 0);
            _local_2.setPosition(this._currentLocation.x, this._currentLocation.y);
            this._SafeStr_18837.setProperty(k, _local_2);
        }

        public function _SafeStr_13260(k:Int)
        {
            this._SafeStr_18837.remove(k);
        }

        public function _SafeStr_18838(k:Direction8)
        {
            this._stoppedDir = k;
        }

        override public function  get_boundingType():Int
        {
            return CollisionDetection._SafeStr_18853;
        }

        override public function  get_boundingData():Array<ASAny>
        {
            return _SafeStr_18823;
        }

        override public function  get_location3D():Location
        {
            return this._currentLocation;
        }

        override public function  get_direction360():Direction360
        {
            return null;
        }

        override public function onRemove()
        {
            if (((this._currentTile != null) && (this._currentTile.humanGameObject == this)))
            {
                this._currentTile.removeHumanGameObject();
            }
            if (((this._nextTile != null) && (this._nextTile.humanGameObject == this)))
            {
                this._nextTile.removeHumanGameObject();
            }
            this._SafeStr_18827 = false;
        }

        public function _SafeStr_18839()
        {
            if (this._SafeStr_18833 == _SafeStr_18820)
            {
                this._SafeStr_18829 = _SafeStr_18814;
                this._SafeStr_18833 = _SafeStr_18821;
                this._SafeStr_18832 = _SafeStr_18817;
                return;
            }
            if (this._SafeStr_18833 == _SafeStr_18819)
            {
                this._SafeStr_18830++;
            }
            this._SafeStr_18833 = _SafeStr_18818;
            this._SafeStr_18579._SafeStr_13225(_SafeStr_13236);
        }

        override public function subturn(k:SynchronizedGameStage)
        {
            var _local_3 = 0;
            var _local_4:Direction8 = null;
            var _local_2= Std.downcast(k , SnowWarGameStage);
            if (this._SafeStr_18832 > 0)
            {
                if (this._SafeStr_18832 == 1)
                {
                    this._SafeStr_18839();
                }
                this._SafeStr_18832--;
            }
            if (this._SafeStr_18835 > 0)
            {
                this._SafeStr_18835--;
            }
            if (HabboGamesCom.logEnabled)
            {
                HabboGamesCom.log([((((Std.string(_SafeStr_13236) + " currentTile:") + this._currentTile) + " nextTile:") + this._nextTile)]);
            }
            if ((this._SafeStr_18848() && (!(this._currentTile == null))))
            {
                if (this._nextTile != null)
                {
                    if (HabboGamesCom.logEnabled)
                    {
                        HabboGamesCom.log([((((Std.string(_SafeStr_13236) + " Moving towards next tile:") + this._nextTile) + " _currentLocation:") + this._currentLocation)]);
                    }
                    this._SafeStr_18840();
                }
                else
                {
                    if (!this._currentTile._SafeStr_18689(this._moveTarget))
                    {
                        _local_3 = Direction360._SafeStr_18792((this._moveTarget.x - this._currentTile.location.x), (this._moveTarget.y - this._currentTile.location.y));
                        _local_4 = Direction360.direction360ValueToDirection8(_local_3);
                        this._nextTile = this._currentTile.adjacentTile(_local_4);
                        if (((this._nextTile == null) || (!this._nextTile.walkable(this))))
                        {
                            if (((!(this._nextTile == null)) && (!this._nextTile.walkable(this))))
                            {
                                if (this._moveTarget.equalLocation(this._nextTile.location))
                                {
                                    this._nextTile = null;
                                    this._SafeStr_13252();
                                    return;
                                }
                            }
                            _local_4 = _local_4._SafeStr_18854(-1);
                            this._nextTile = this._currentTile.adjacentTile(_local_4);
                            if (((this._nextTile == null) || (!this._nextTile.walkable(this))))
                            {
                                _local_4 = _local_4._SafeStr_18854(2);
                                this._nextTile = this._currentTile.adjacentTile(_local_4);
                                if (((!(this._nextTile == null)) && (!this._nextTile.walkable(this))))
                                {
                                    this._nextTile = null;
                                }
                            }
                        }
                        if (this._nextTile != null)
                        {
                            if (!_SafeStr_18700)
                            {
                                this._currentTile.removeHumanGameObject();
                                this._nextTile.addActiveGameObject(this);
                            }
                            this._SafeStr_18838(_local_4);
                            this._SafeStr_18840();
                        }
                        else
                        {
                            this._SafeStr_18827 = false;
                        }
                        if (HabboGamesCom.logEnabled)
                        {
                            HabboGamesCom.log([((((((((Std.string(_SafeStr_13236) + " Starting to move to next tile in direction360:") + Std.string(_local_3)) + ", nextTile is now ") + this._nextTile) + "_currentLocationn:") + this._currentLocation) + ", moveTarget:") + this._moveTarget)]);
                        }
                    }
                    else
                    {
                        this._SafeStr_18827 = false;
                    }
                }
            }
            else
            {
                this._SafeStr_18827 = false;
            }
        }

        function _SafeStr_18840()
        {
            if (HabboGamesCom.logEnabled)
            {
                HabboGamesCom.log([((((Std.string(_SafeStr_13236) + " [MoveTowardsNextTile], currentX: ") + Std.string(this._currentLocation.x)) + " currentY: ") + Std.string(this._currentLocation.y))]);
            }
            var k= this._nextTile.location.x;
            var _local_2= this._currentLocation.x;
            var _local_3= (_local_2 - k);
            if (_local_3 != 0)
            {
                if (_local_3 < 0)
                {
                    if (_local_3 > -_SafeStr_18811)
                    {
                        _local_2 = k;
                    }
                    else
                    {
                        _local_2 = (_local_2 + _SafeStr_18811);
                    }
                }
                else
                {
                    if (_local_3 < _SafeStr_18811)
                    {
                        _local_2 = k;
                    }
                    else
                    {
                        _local_2 = (_local_2 - _SafeStr_18811);
                    }
                }
            }
            var _local_4= this._nextTile.location.y;
            var _local_5= this._currentLocation.y;
            var _local_6= (_local_5 - _local_4);
            if (_local_6 != 0)
            {
                if (_local_6 < 0)
                {
                    if (_local_6 > -_SafeStr_18811)
                    {
                        _local_5 = _local_4;
                    }
                    else
                    {
                        _local_5 = (_local_5 + _SafeStr_18811);
                    }
                }
                else
                {
                    if (_local_6 < _SafeStr_18811)
                    {
                        _local_5 = _local_4;
                    }
                    else
                    {
                        _local_5 = (_local_5 - _SafeStr_18811);
                    }
                }
            }
            if (HabboGamesCom.logEnabled)
            {
                HabboGamesCom.log([((((Std.string(_SafeStr_13236) + " [MoveTowardsNextTile], nextX: ") + Std.string(_local_2)) + " nextY: ") + Std.string(_local_5))]);
            }
            this._currentLocation.setPosition(_local_2, _local_5);
            if (this._currentLocation.distanceTo(this._nextTile.location) < _SafeStr_4667._SafeStr_18698((_SafeStr_18811 / 2)))
            {
                this._currentTile = this._nextTile;
                this._nextTile = null;
            }
            this._SafeStr_18827 = true;
        }

        public function _SafeStr_18603(k:Int, _arg_2:Int)
        {
            if (this._SafeStr_18833 == _SafeStr_18819)
            {
                this._SafeStr_18833 = _SafeStr_18818;
                this._SafeStr_18832 = 0;
                this._SafeStr_18579._SafeStr_13225(_SafeStr_13236);
            }
            if (((this._SafeStr_18833 == _SafeStr_18818) || (this._SafeStr_18833 == _SafeStr_18821)))
            {
                this._moveTarget.setPosition(k, _arg_2);
            }
        }

        public var currentLocation(get,never):Location;
public function  get_currentLocation():Location
        {
            return this._currentLocation;
        }

        public function _SafeStr_18841(k:SnowWarGameStage, _arg_2:HumanGameObject, _arg_3:Int)
        {
            if (_SafeStr_18805)
            {
                return;
            }
            if (this._team == _arg_2.team)
            {
                return;
            }
            if (this._SafeStr_18829 > 0)
            {
                if (this._SafeStr_18829 == 1)
                {
                    this._SafeStr_18845(_arg_3);
                    _arg_2._SafeStr_18843(k, this);
                    SnowWarEngine.playSound(HabboSoundTypesEnum.GAMES_SW_HIT3);
                }
                this._SafeStr_18829--;
                this._SafeStr_18579._SafeStr_13228(this, _arg_2);
            }
        }

        public function _SafeStr_18842(k:SnowWarGameStage, _arg_2:HumanGameObject)
        {
            if (((!_arg_2._SafeStr_18700) && ((!(this.team == _arg_2.team)) || cast(k.synchronizedGameArena.getExtension(), _SafeStr_4034)._SafeStr_18784())))
            {
                this._SafeStr_18844(k.synchronizedGameArena, _SafeStr_18826);
            }
        }

        public function _SafeStr_18843(k:SnowWarGameStage, _arg_2:HumanGameObject)
        {
            if (((!_arg_2._SafeStr_18700) && ((!(this.team == _arg_2.team)) || cast(k.synchronizedGameArena.getExtension(), _SafeStr_4034)._SafeStr_18784())))
            {
                this._SafeStr_18844(k.synchronizedGameArena, _SafeStr_18825);
            }
        }

        public function _SafeStr_18844(k:SynchronizedGameArena, _arg_2:Int)
        {
            this._score = (this._score + _arg_2);
            k._SafeStr_18855(this.team, _arg_2);
        }

        public function _SafeStr_18845(k:Int)
        {
            this._SafeStr_18833 = _SafeStr_18820;
            this._SafeStr_18832 = _SafeStr_18816;
            this._SafeStr_18838(Direction360.direction360ValueToDirection8(k).rotateDirection180Degrees());
            this._SafeStr_13252();
            this._SafeStr_18579._SafeStr_13225(_SafeStr_13236);
        }

        public function _SafeStr_13252()
        {
            if (this._nextTile == null)
            {
                this._moveTarget.fromLocation(this._currentTile.location);
                this._currentLocation.fromLocation(this._currentTile.location);
            }
            else
            {
                this._currentTile = this._nextTile;
                this._currentLocation.fromLocation(this._nextTile.location);
                this._moveTarget.fromLocation(this._nextTile.location);
                this._nextTile = null;
            }
            this._SafeStr_18827 = false;
            if (HabboGamesCom.logEnabled)
            {
                HabboGamesCom.log([((((((((("Stopped. dir:" + this._stoppedDir) + "_currentTilee:") + this._currentTile) + "_nextTilee:") + this._nextTile) + "_currentLocationn:") + this._currentLocation) + "_moveTargett:") + this._moveTarget)]);
            }
        }

        public function _SafeStr_18743():Int
        {
            return this._stoppedDir.index();
        }

        public function _SafeStr_13242():Bool
        {
            return ((this._SafeStr_18830 > 0) && (this._SafeStr_18835 < 1)) && ((this._SafeStr_18833 == _SafeStr_18818) || (this._SafeStr_18833 == _SafeStr_18821));
        }

        public function _SafeStr_18846()
        {
            this._SafeStr_18835 = _SafeStr_18822;
        }

        public function _SafeStr_18847(k:Int, _arg_2:Int):Bool
        {
            if (this._SafeStr_18830 < 1)
            {
                return false;
            }
            this._SafeStr_13252();
            var _local_3= Direction360._SafeStr_18792((k - this._currentLocation.x), (_arg_2 - this._currentLocation.y));
            var _local_4= Direction360.direction360ValueToDirection8(_local_3).index();
            this._SafeStr_18838(Direction8.fromIndex(_local_4));
            if (HabboGamesCom.logEnabled)
            {
                HabboGamesCom.log([((((((((((("Turning to:" + Std.string(_local_4)) + " 360 value:") + Std.string(_local_3)) + " target:") + Std.string(k)) + ",") + Std.string(_arg_2)) + " location:") + Std.string(this._currentLocation.x)) + ",") + Std.string(this._currentLocation.y))]);
            }
            this._SafeStr_18830--;
            return true;
        }

        public function _SafeStr_18848():Bool
        {
            return (this._SafeStr_18833 == _SafeStr_18818) || (this._SafeStr_18833 == _SafeStr_18821);
        }

        public function _SafeStr_13250():Bool
        {
            return ((this._SafeStr_18833 == _SafeStr_18818) || (this._SafeStr_18833 == _SafeStr_18821)) && ((this._SafeStr_18830 < _SafeStr_18813) || _SafeStr_18700);
        }

        public function _SafeStr_18849()
        {
            if (this._SafeStr_13250())
            {
                this._SafeStr_18833 = _SafeStr_18819;
                this._SafeStr_18832 = _SafeStr_18815;
                this._SafeStr_13252();
            }
        }

        public function _SafeStr_18850():Int
        {
            return _SafeStr_18813 - this._SafeStr_18830;
        }

        public function _SafeStr_18851(k:Int)
        {
            this._SafeStr_18830 = (this._SafeStr_18830 + k);
        }

        public function _SafeStr_18749():Bool
        {
            return this._SafeStr_18833 == _SafeStr_18820;
        }

        public var name(get,never):String;
public function  get_name():String
        {
            return this._name;
        }

        public var mission(get,never):String;
public function  get_mission():String
        {
            return this._mission;
        }

        public var figure(get,never):String;
public function  get_figure():String
        {
            return this._figure;
        }

        public var sex(get,never):String;
public function  get_sex():String
        {
            return this._sex;
        }

        public var score(get,never):Int;
public function  get_score():Int
        {
            return this._score;
        }

        public var team(get,never):Int;
public function  get_team():Int
        {
            return this._team;
        }

        public var _SafeStr_18742(get,never):Int;
public function  get__SafeStr_18742():Int
        {
            return this._SafeStr_18830;
        }

        public var _SafeStr_12584(get,never):Int;
public function  get__SafeStr_12584():Int
        {
            return this._SafeStr_18829;
        }

        public var posture(get,never):String;
public function  get_posture():String
        {
            if (this._SafeStr_18835 > 0)
            {
                return AvatarAction.SNOWWAR_THROW;
            }
            switch (this._SafeStr_18833)
            {
                case _SafeStr_18820:
                    return AvatarAction.SNOWWAR_DIE_BACK;
                case _SafeStr_18819:
                    return AvatarAction.SNOWWAR_PICK;
            }
            if (this._SafeStr_18827)
            {
                return AvatarAction.SNOWWAR_RUN;
            }
            return AvatarAction.POSTURE_STAND;
        }

        public var action(get,never):String;
public function  get_action():String
        {
            switch (this._SafeStr_18833)
            {
                case _SafeStr_18821:
                    return RoomObjectVariableEnum.FIGURE_DANCE;
            }
            return RoomObjectVariableEnum.FIGURE_DANCE;
        }

        public var parameter(get,never):Int;
public function  get_parameter():Int
        {
            if (this._SafeStr_18835 > 1)
            {
                return 1;
            }
            if (this._SafeStr_18835 == 1)
            {
                return 0;
            }
            switch (this._SafeStr_18833)
            {
                case _SafeStr_18821:
                    return 1;
            }
            return 0;
        }

        override public function testSnowBallCollision(k:_SafeStr_4035):Bool
        {
            if ((((((!_SafeStr_18805) && (!(this._SafeStr_18833 == _SafeStr_18820))) && (!(this._SafeStr_18833 == _SafeStr_18821))) && (!(k._SafeStr_18040 == this))) && super.testSnowBallCollision(k)))
            {
                return true;
            }
            return false;
        }

        override public function onSnowBallHit(k:SnowWarGameStage, _arg_2:_SafeStr_4035)
        {
            var _local_3= _arg_2._SafeStr_18040;
            this._SafeStr_18841(k, _local_3, _arg_2.direction360.index());
            _local_3._SafeStr_18842(k, this);
            SnowWarEngine.playSound(HabboSoundTypesEnum.GAMES_SW_HIT1);
        }

        override public function  get_collisionHeight():Int
        {
            return _SafeStr_18824;
        }

        public function toString():String
        {
            return ((" ref:" + Std.string(_id)) + "_name:") + this._name;
        }
    }

