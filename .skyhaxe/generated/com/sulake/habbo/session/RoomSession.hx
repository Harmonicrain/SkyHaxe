package com.sulake.habbo.session
;
    import com.sulake.core.communication.connection.IConnection;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.tracking.IHabboTracking;
    import com.sulake.habbo.communication.messages.incoming.roomsettings.RoomModerationSettings;
    import com.sulake.habbo.session.events.RoomSessionEvent;
    import com.sulake.habbo.session._enum.RoomControllerLevel;
    import com.sulake.habbo.session._enum.RoomTradingLevelEnum;
    import com.sulake.habbo.communication.messages.outgoing.room.session.OpenFlatConnectionMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.game.arena.Game2GameChatMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.room.chat.ChatMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.room.avatar.ChangeMottoMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.room.chat.ShoutMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.room.chat.WhisperMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.room.chat.StartTypingMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.room.chat.CancelTypingMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.room.avatar.AvatarExpressionMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.room.avatar.SignMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.room.avatar.DanceMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.room.avatar.ChangePostureMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.room.furniture.CreditFurniRedeemMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.room.furniture.PresentOpenMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.room.furniture.OpenPetPackageMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.room.furniture.RoomDimmerGetPresetsMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.room.furniture.RoomDimmerSavePresetMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.room.furniture.RoomDimmerChangeStateMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.tracking.EventLogMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.poll.PollStartComposer;
    import com.sulake.habbo.communication.messages.outgoing.poll.PollRejectComposer;
    import com.sulake.habbo.communication.messages.outgoing.poll.PollAnswerComposer;
    import com.sulake.habbo.communication.messages.outgoing.userclassification.PeerUsersClassificationMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.userclassification.RoomUsersClassificationMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.friendlist.FollowFriendMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.room.action.AmbassadorAlertMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.room.action.RoomUserKickMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.room.action.BanUserWithDurationMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.room.action.RoomUserMuteMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.room.action.AssignRightsMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.room.action.RemoveRightsMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.room.action.LetUserInMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.room.engine.RemovePetFromFlatMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.room.engine.MountPetMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.room.engine.TogglePetRidingPermissionMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.room.engine.TogglePetBreedingPermissionMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.room.engine.RemoveSaddleFromPetMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.room.engine.HarvestPetMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.room.engine.CompostPlantMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.room.engine.GetPetCommandsMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.room.pets.CustomizePetWithFurniComposer;
    import com.sulake.habbo.communication.messages.outgoing.room.engine.UseFurnitureMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.nux.NewUserExperienceScriptProceedComposer;
    import com.sulake.habbo.communication.messages.outgoing.room.session.QuitMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.room.session.ChangeQueueMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.room.engine.SetClothingChangeDataMessageComposer;
    import com.sulake.habbo.communication.messages.incoming.roomsettings.RoomSettingsData;
	import com.sulake.habbo.ui.widget.infobuspolls.VotePollCounterMessageComposer;

     class RoomSession implements IRoomSession 
    {
        static inline final CHAT_LAG_WARNING_LIMIT= 2500;

        var _connection:IConnection;
        var _roomId:Int = 0;
        var _password:String = "";
        var _roomResources:String = "";
        var _openConnectionComposer:IMessageComposer = null;
        var _state:String = "RSE_CREATED";
        var _userDataManager:UserDataManager;
        var _ownUserRoomId:Int = -1;
        var _isRoomOwner:Bool = false;
        var _roomControllerLevel:Int = 0;
        var _playTestMode:Bool = false;
        var _tradeMode:Int = 0;
        var _isGuildRoom:Bool = false;
        var _isSpectatorMode:Bool = false;
        var _arePetsAllowed:Bool = false;
        var _doorMode:Int = 0;
        var _messageLagTrackingMap:Map;
        var _chatTrackingId:Int = 0;
        var _habboTracking:IHabboTracking = null;
        var _isUserDecorating:Bool = false;
        var _isGameSession:Bool = false;
        var _nuxNotComplete:Bool = false;
        var _roomModerationSettings:RoomModerationSettings = null;

        public function new()
        {
            this._messageLagTrackingMap = new Map();
            this._userDataManager = new UserDataManager();
        }

        public var connection(never,set):IConnection;
public function  set_connection(k:IConnection):IConnection        {
            if (k == null)
            {
                return k;
            }
            this._connection = k;
            if (this._userDataManager != null)
            {
                this._userDataManager.connection = k;
            }
return k;
        }

        public function dispose()
        {
            this._connection = null;
            if (this._userDataManager != null)
            {
                this._userDataManager.dispose();
                this._userDataManager = null;
            }
            if (this._messageLagTrackingMap != null)
            {
                this._messageLagTrackingMap.dispose();
                this._messageLagTrackingMap = null;
            }
            if (this._openConnectionComposer != null)
            {
                this._openConnectionComposer.dispose();
                this._openConnectionComposer = null;
            }
            if (this._roomModerationSettings != null)
            {
                this._roomModerationSettings = null;
            }
        }

        
        public var roomId(get,set):Int;
public function  get_roomId():Int
        {
            return this._roomId;
        }
public function  set_roomId(k:Int):Int        {
            return this._roomId = k;
        }

        
        public var roomPassword(get,set):String;
public function  get_roomPassword():String
        {
            return this._password;
        }
public function  set_roomPassword(k:String):String        {
            return this._password = k;
        }

        
        public var roomResources(get,set):String;
public function  get_roomResources():String
        {
            return this._roomResources;
        }
public function  set_roomResources(k:String):String        {
            return this._roomResources = k;
        }

        
        public var openConnectionComposer(get,set):IMessageComposer;
public function  get_openConnectionComposer():IMessageComposer
        {
            return this._openConnectionComposer;
        }
public function  set_openConnectionComposer(k:IMessageComposer):IMessageComposer        {
            return this._openConnectionComposer = k;
        }

        public var state(get,never):String;
public function  get_state():String
        {
            return this._state;
        }

        
        public var habboTracking(get,set):IHabboTracking;
public function  get_habboTracking():IHabboTracking
        {
            return this._habboTracking;
        }
public function  set_habboTracking(k:IHabboTracking):IHabboTracking        {
            return this._habboTracking = k;
        }

        
        public var isGameSession(get,set):Bool;
public function  get_isGameSession():Bool
        {
            return this._isGameSession;
        }
public function  set_isGameSession(k:Bool):Bool        {
            return this._isGameSession = k;
        }

        
        public var roomModerationSettings(get,set):RoomModerationSettings;
public function  get_roomModerationSettings():RoomModerationSettings
        {
            return this._roomModerationSettings;
        }
public function  set_roomModerationSettings(k:RoomModerationSettings):RoomModerationSettings        {
            return this._roomModerationSettings = k;
        }

        public function start():Bool
        {
            if (((this._state == RoomSessionEvent.CREATED) && (!(this._connection == null))))
            {
                this._state = RoomSessionEvent.STARTED;
                if (this._openConnectionComposer != null)
                {
                    return this.sendPredefinedOpenConnection();
                }
                return this.sendOpenFlatConnectionMessage();
            }
            return false;
        }

        public function reset(k:Int)
        {
            if (k != this._roomId)
            {
                this._roomId = k;
                this._isRoomOwner = false;
                this._roomControllerLevel = RoomControllerLevel.NONE;
                this._tradeMode = RoomTradingLevelEnum.NO_TRADING;
                this._isSpectatorMode = false;
            }
        }

        function sendOpenFlatConnectionMessage():Bool
        {
            if (this._connection == null)
            {
                return false;
            }
            this._connection.send(new OpenFlatConnectionMessageComposer(this._roomId, this._password));
            return true;
        }

        function sendPredefinedOpenConnection():Bool
        {
            if (this._connection == null)
            {
                return false;
            }
            this._connection.send(this._openConnectionComposer);
            this._openConnectionComposer = null;
            return true;
        }

        public function sendChatMessage(k:String, _arg_2:Int=0)
        {
            if (this._isGameSession)
            {
                this._connection.send(new Game2GameChatMessageComposer(k));
            }
            else
            {
                k = new compat.RegExp("&#[0-9]+;", "g").replace(k, "");
                this._connection.send(new ChatMessageComposer(k, _arg_2, this._chatTrackingId));
                this._messageLagTrackingMap.add(this._chatTrackingId, flash.Lib.getTimer());
                this._chatTrackingId++;
            }
        }

        public function sendChangeMottoMessage(k:String)
        {
            this._connection.send(new ChangeMottoMessageComposer(k));
        }

        public function receivedChatWithTrackingId(k:Int)
        {
            var _local_3 = 0;
            var _local_2:ASObject = this._messageLagTrackingMap.remove(k);
            if (_local_2 != null)
            {
                _local_3 = flash.Lib.getTimer();
                if ((_local_3 - ASCompat.toInt(_local_2)) > RoomSession.CHAT_LAG_WARNING_LIMIT)
                {
                    if (this._habboTracking != null)
                    {
                        this._habboTracking.chatLagDetected(_local_3);
                    }
                }
            }
        }

        public function sendShoutMessage(k:String, _arg_2:Int=0)
        {
            this._connection.send(new ShoutMessageComposer(k, _arg_2));
        }

        public function sendWhisperMessage(k:String, _arg_2:String, _arg_3:Int=0)
        {
            this._connection.send(new WhisperMessageComposer(k, _arg_2, _arg_3));
        }

        public function sendChatTypingMessage(k:Bool)
        {
            if (k)
            {
                this._connection.send(new StartTypingMessageComposer());
            }
            else
            {
                this._connection.send(new CancelTypingMessageComposer());
            }
        }

        public function sendAvatarExpressionMessage(k:Int)
        {
            this._connection.send(new AvatarExpressionMessageComposer(k));
        }

        public function sendSignMessage(k:Int)
        {
            if (((k >= 0) && (k <= 17)))
            {
                this._connection.send(new SignMessageComposer(k));
            }
        }

        public function sendDanceMessage(k:Int)
        {
            this._connection.send(new DanceMessageComposer(k));
        }

        public function sendChangePostureMessage(k:Int)
        {
            this._connection.send(new ChangePostureMessageComposer(k));
        }

        public function sendCreditFurniRedeemMessage(k:Int)
        {
            this._connection.send(new CreditFurniRedeemMessageComposer(k));
        }

        public function sendPresentOpenMessage(k:Int)
        {
            this._connection.send(new PresentOpenMessageComposer(k));
        }

        public function sendOpenPetPackageMessage(k:Int, _arg_2:String)
        {
            this._connection.send(new OpenPetPackageMessageComposer(k, _arg_2));
        }

        public function sendRoomDimmerGetPresetsMessage()
        {
            this._connection.send(new RoomDimmerGetPresetsMessageComposer());
        }

        public function sendRoomDimmerSavePresetMessage(k:Int, _arg_2:Int, _arg_3:UInt, _arg_4:Int, _arg_5:Bool)
        {
            var _local_6= ("000000" + ASCompat.toRadix(_arg_3, 16).toUpperCase());
            var _local_7= ("#" + _local_6.substr((_local_6.length - 6)));
            this._connection.send(new RoomDimmerSavePresetMessageComposer(k, _arg_2, _local_7, _arg_4, _arg_5));
        }

        public function sendRoomDimmerChangeStateMessage()
        {
            this._connection.send(new RoomDimmerChangeStateMessageComposer());
        }

        public function sendConversionPoint(k:String, _arg_2:String, _arg_3:String, _arg_4:String=null, _arg_5:Int=0)
        {
            this._connection.send(new EventLogMessageComposer(k, _arg_2, _arg_3, _arg_4, _arg_5));
        }

        public function sendPollStartMessage(k:Int)
        {
            this._connection.send(new PollStartComposer(k));
        }

        public function sendPollRejectMessage(k:Int)
        {
            this._connection.send(new PollRejectComposer(k));
        }

        public function sendPollAnswerMessage(k:Int, _arg_2:Int, _arg_3:Array<ASAny>)
        {
            this._connection.send(new PollAnswerComposer(k, _arg_2, _arg_3));
        }

        public function sendPeerUsersClassificationMessage(k:String)
        {
            this._connection.send(new PeerUsersClassificationMessageComposer(k));
        }

        public function sendRoomUsersClassificationMessage(k:String)
        {
            this._connection.send(new RoomUsersClassificationMessageComposer(k));
        }

        public function sendVisitFlatMessage(k:Int)
        {
            this._connection.send(new OpenFlatConnectionMessageComposer(k));
        }

        public function sendVisitUserMessage(k:String)
        {
            this._connection.send(new FollowFriendMessageComposer(k));
        }

        public function ambassadorAlert(k:Int)
        {
            this._connection.send(new AmbassadorAlertMessageComposer(k));
        }

        public function kickUser(k:Int)
        {
            this._connection.send(new RoomUserKickMessageComposer(k));
        }

        public function banUserWithDuration(k:Int, _arg_2:String)
        {
            this._connection.send(new BanUserWithDurationMessageComposer(k, _arg_2, this.roomId));
        }

        public function muteUser(userId:Int, minutes:Int)
        {
            this._connection.send(new RoomUserMuteMessageComposer(userId, minutes, this.roomId));
        }

        public function assignRights(k:Int)
        {
            this._connection.send(new AssignRightsMessageComposer(k));
        }

        public function removeRights(k:Int)
        {
            var _local_2:Array<ASAny> = [];
            _local_2.push(k);
            var _local_3= new RemoveRightsMessageComposer(_local_2);
            this._connection.send(_local_3);
        }

        public function letUserIn(k:String, _arg_2:Bool)
        {
            this._connection.send(new LetUserInMessageComposer(k, _arg_2));
        }

        public function pickUpPet(k:Int)
        {
            this._connection.send(new RemovePetFromFlatMessageComposer(k));
        }

        public function mountPet(k:Int)
        {
            this._connection.send(new MountPetMessageComposer(k, true));
        }

        public function togglePetRidingPermission(k:Int)
        {
            this._connection.send(new TogglePetRidingPermissionMessageComposer(k));
        }

        public function togglePetBreedingPermission(k:Int)
        {
            this._connection.send(new TogglePetBreedingPermissionMessageComposer(k));
        }

        public function dismountPet(k:Int)
        {
            this._connection.send(new MountPetMessageComposer(k, false));
        }

        public function removeSaddleFromPet(k:Int)
        {
            this._connection.send(new RemoveSaddleFromPetMessageComposer(k));
        }

        public function harvestPet(k:Int)
        {
            this._connection.send(new HarvestPetMessageComposer(k));
        }

        public function compostPlant(k:Int)
        {
            this._connection.send(new CompostPlantMessageComposer(k));
        }

        public function requestPetCommands(k:Int)
        {
            this._connection.send(new GetPetCommandsMessageComposer(k));
        }

        public function useProductForPet(k:Int, _arg_2:Int)
        {
            this._connection.send(new CustomizePetWithFurniComposer(k, _arg_2));
        }

        public function plantSeed(k:Int)
        {
            this._connection.send(new UseFurnitureMessageComposer(k));
        }

        public function sendScriptProceed()
        {
            this._connection.send(new NewUserExperienceScriptProceedComposer());
        }

        public function quit()
        {
            if (this._connection != null)
            {
                this._connection.send(new QuitMessageComposer());
            }
        }

        public function changeQueue(k:Int)
        {
            if (this._connection == null)
            {
                return;
            }
            this._connection.send(new ChangeQueueMessageComposer(k));
        }

        public function sendUpdateClothingChangeFurniture(k:Int, _arg_2:String, _arg_3:String)
        {
            if (this._connection == null)
            {
                return;
            }
            var _local_4= new SetClothingChangeDataMessageComposer(k, _arg_2, _arg_3);
            this._connection.send(_local_4);
            _local_4.dispose();
            _local_4 = null;
        }

        public var userDataManager(get,never):UserDataManager;
public function  get_userDataManager():UserDataManager
        {
            return this._userDataManager;
        }

        
        public var ownUserRoomId(get,set):Int;
public function  get_ownUserRoomId():Int
        {
            return this._ownUserRoomId;
        }
public function  set_ownUserRoomId(k:Int):Int        {
            return this._ownUserRoomId = k;
        }

        
        public var isRoomOwner(get,set):Bool;
public function  set_isRoomOwner(k:Bool):Bool        {
            return this._isRoomOwner = k;
        }
public function  get_isRoomOwner():Bool
        {
            return this._isRoomOwner;
        }

        
        public var roomControllerLevel(get,set):Int;
public function  set_roomControllerLevel(k:Int):Int        {
            if (((k >= RoomControllerLevel.NONE) && (k <= RoomControllerLevel.MODERATOR)))
            {
                this._roomControllerLevel = k;
            }
            else
            {
                Logger.log([(("Invalid roomControllerLevel " + Std.string(k)) + ", setting to ROOM_CONTROL_LEVEL_NONE instead")]);
                this._roomControllerLevel = RoomControllerLevel.NONE;
            }
return k;
        }
public function  get_roomControllerLevel():Int
        {
            if (this._playTestMode)
            {
                return RoomControllerLevel.NONE;
            }
            return this._roomControllerLevel;
        }

        
        public var playTestMode(get,set):Bool;
public function  set_playTestMode(value:Bool):Bool        {
            return this._playTestMode = value;
        }
public function  get_playTestMode():Bool
        {
            return this._playTestMode;
        }

        
        public var tradeMode(get,set):Int;
public function  get_tradeMode():Int
        {
            return this._tradeMode;
        }

        public var isPrivateRoom(get,never):Bool;
public function  get_isPrivateRoom():Bool
        {
            return true;
        }
public function  set_tradeMode(k:Int):Int        {
            return this._tradeMode = k;
        }

        
        public var isGuildRoom(get,set):Bool;
public function  get_isGuildRoom():Bool
        {
            return this._isGuildRoom;
        }
public function  set_isGuildRoom(k:Bool):Bool        {
            return this._isGuildRoom = k;
        }

        public var isNoobRoom(get,never):Bool;
public function  get_isNoobRoom():Bool
        {
            return this._doorMode == RoomSettingsData.DOORMODE_NOOBS_ONLY;
        }

        public var doorMode(never,set):Int;
public function  set_doorMode(k:Int):Int        {
            return this._doorMode = k;
        }

        
        public var isSpectatorMode(get,set):Bool;
public function  get_isSpectatorMode():Bool
        {
            return this._isSpectatorMode;
        }
public function  set_isSpectatorMode(k:Bool):Bool        {
            return this._isSpectatorMode = k;
        }

        
        public var arePetsAllowed(get,set):Bool;
public function  get_arePetsAllowed():Bool
        {
            return this._arePetsAllowed;
        }
public function  set_arePetsAllowed(k:Bool):Bool        {
            return this._arePetsAllowed = k;
        }

        public var areBotsAllowed(get,never):Bool;
public function  get_areBotsAllowed():Bool
        {
            return this._isRoomOwner;
        }

        
        public var isUserDecorating(get,set):Bool;
public function  get_isUserDecorating():Bool
        {
            return this._isUserDecorating;
        }
public function  set_isUserDecorating(k:Bool):Bool        {
            return this._isUserDecorating = k;
        }

        
        public var isNuxNotComplete(get,set):Bool;
public function  get_isNuxNotComplete():Bool
        {
            return this._nuxNotComplete;
        }
public function  set_isNuxNotComplete(k:Bool):Bool        {
            return this._nuxNotComplete = k;
        }

		public function votePoll(counter:Int)
		{
			this._connection.send(new VotePollCounterMessageComposer(counter));
		}
    }

