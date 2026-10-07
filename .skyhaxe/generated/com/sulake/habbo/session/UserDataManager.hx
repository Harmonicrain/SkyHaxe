package com.sulake.habbo.session
;
    import com.sulake.core.utils.Map;
    import com.sulake.core.communication.connection.IConnection;
    import com.sulake.habbo.communication.messages.outgoing.users.GetSelectedBadgesMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.room.pets.GetPetInfoMessageComposer;

     class UserDataManager
    {
        static inline final TYPE_USER= 1;
        static inline final TYPE_PET= 2;
        static inline final TYPE_BOT= 3;
        static inline final TYPE_RENTABLE_BOT= 4;

        var _userDataByType:Map;
        var _userDataByRoomIndex:Map;
        var _userBadges:Map;
        var _connection:IConnection;

        public function new()
        {
            this._userDataByType = new Map();
            this._userDataByRoomIndex = new Map();
            this._userBadges = new Map();
        }

        public function dispose()
        {
            this._connection = null;
            this._userDataByType.dispose();
            this._userDataByType = null;
            this._userDataByRoomIndex.dispose();
            this._userDataByRoomIndex = null;
            this._userBadges.dispose();
            this._userBadges = null;
        }

        public var connection(never,set):IConnection;
public function  set_connection(k:IConnection):IConnection        {
            return this._connection = k;
        }

        public function getUserData(k:Int):RoomUserData
        {
            return this.getUserDataByType(k, TYPE_USER);
        }

        public function getUserDataByType(k:Int, _arg_2:Int):RoomUserData
        {
            var _local_3:RoomUserData = null;
            var _local_4:Map = this._userDataByType.getValue(_arg_2);
            if (_local_4 != null)
            {
                _local_3 = _local_4.getValue(k);
            }
            return _local_3;
        }

        public function getUserDataByIndex(k:Int):RoomUserData
        {
            return this._userDataByRoomIndex.getValue(k);
        }

        public function getUserDataByName(k:String):RoomUserData
        {
            var _local_2:RoomUserData = null;
            final _iter_ = this._userDataByRoomIndex; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
            {
_local_2  = _tmp_;
                if (_local_2.name == k)
                {
                    return _local_2;
                }
            }
            return null;
        }

        public function getUserBadges(k:Int):Array<ASAny>
        {
            if (this._connection != null)
            {
                this._connection.send(new GetSelectedBadgesMessageComposer(k));
            }
            var _local_2:Array<ASAny> = ASCompat.dynamicAs(this._userBadges.getValue(k) , Array);
            if (_local_2 == null)
            {
                _local_2 = [];
            }
            return _local_2;
        }

        public function _Str_22067(k:RoomUserData)
        {
            if (k == null)
            {
                return;
            }
            this.removeUserDataByRoomIndex(k.roomObjectId);
            var _local_2:Map = this._userDataByType.getValue(k.type);
            if (_local_2 == null)
            {
                _local_2 = new Map();
                this._userDataByType.add(k.type, _local_2);
            }
            _local_2.add(k.id, k);
            this._userDataByRoomIndex.add(k.roomObjectId, k);
        }

        public function removeUserDataByRoomIndex(k:Int)
        {
            var _local_3:Map = null;
            var _local_4:RoomUserData = null;
            var _local_2:RoomUserData = this._userDataByRoomIndex.remove(k);
            if (_local_2 != null)
            {
                _local_3 = this._userDataByType.getValue(_local_2.type);
                if (_local_3 != null)
                {
                    _local_4 = _local_3.remove(_local_2.id);
                    if (_local_4 != null)
                    {
                    }
                }
            }
        }

        public function setUserBadges(k:Int, _arg_2:Array<ASAny>)
        {
            this._userBadges.remove(k);
            this._userBadges.add(k, _arg_2);
        }

        public function updateFigure(k:Int, _arg_2:String, _arg_3:String, _arg_4:Bool, _arg_5:Bool)
        {
            var _local_6= this.getUserDataByIndex(k);
            if (_local_6 != null)
            {
                _local_6.figure = _arg_2;
                _local_6.sex = _arg_3;
                _local_6.hasSaddle = _arg_4;
                _local_6.isRiding = _arg_5;
            }
        }

        public function updatePetLevel(k:Int, _arg_2:Int)
        {
            var _local_3= this.getUserDataByIndex(k);
            if (_local_3 != null)
            {
                _local_3.petLevel = _arg_2;
            }
        }

        public function updatePetBreedingStatus(k:Int, _arg_2:Bool, _arg_3:Bool, _arg_4:Bool, _arg_5:Bool)
        {
            var _local_6= this.getUserDataByIndex(k);
            if (_local_6 != null)
            {
                _local_6.canBreed = _arg_2;
                _local_6.canHarvest = _arg_3;
                _local_6.canRevive = _arg_4;
                _local_6.hasBreedingPermission = _arg_5;
            }
        }

        public function updateCustom(k:Int, _arg_2:String)
        {
            var _local_3= this.getUserDataByIndex(k);
            if (_local_3 != null)
            {
                _local_3.custom = _arg_2;
            }
        }

        public function updateAchievementScore(k:Int, _arg_2:Int)
        {
            var _local_3= this.getUserDataByIndex(k);
            if (_local_3 != null)
            {
                _local_3.activityPoints = _arg_2;
            }
        }

        public function updateNameByIndex(k:Int, _arg_2:String)
        {
            var _local_3= this.getUserDataByIndex(k);
            if (_local_3 != null)
            {
                _local_3.name = _arg_2;
            }
        }

        public function _Str_8631(k:Int):RoomUserData
        {
            return this.getUserDataByType(k, TYPE_PET);
        }

        public function _Str_17237(k:Int):RoomUserData
        {
            return this.getUserDataByType(k, TYPE_RENTABLE_BOT);
        }

        public function requestPetInfo(k:Int)
        {
            var _local_2= this._Str_8631(k);
            if (((!(_local_2 == null)) && (!(this._connection == null))))
            {
                this._connection.send(new GetPetInfoMessageComposer(_local_2.id));
            }
        }

        public function _Str_23028():Array<ASAny>
        {
            var _local_2:RoomUserData = null;
            var k= new Array<ASAny>();
            final _iter_ = this._userDataByRoomIndex; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
            {
_local_2  = _tmp_;
                k.push(_local_2.id);
            }
            return k;
        }
    }

