package com.sulake.habbo.room
;
    import com.sulake.core.communication.connection.IConnection;
    import com.sulake.habbo.room.object.RoomPlaneParser;
    import com.sulake.habbo.communication.messages.incoming.room.layout.RoomEntryTileMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.handshake.UserObjectEvent;
    import com.sulake.habbo.communication.messages.incoming.room.session.RoomReadyMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.engine.RoomPropertyMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.engine.FloorHeightMapEvent;
    import com.sulake.habbo.communication.messages.incoming.room.engine.AreaHideMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.engine.HeightMapEvent;
    import com.sulake.habbo.communication.messages.incoming.room.engine.HeightMapUpdateMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.engine.RoomVisualizationSettingsEvent;
    import com.sulake.habbo.communication.messages.incoming.room.engine.FurnitureAliasesMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.engine.ObjectsMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.engine.ObjectAddMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.engine.ObjectUpdateMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.engine.ObjectDataUpdateMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.engine.ObjectsDataUpdateMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.engine.ObjectRemoveMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.engine.PublicRoomObjectMessageData;
    import com.sulake.habbo.communication.messages.incoming.room.engine.PublicRoomObjectsMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.publicroom.BusDoorMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.games.OpenGameBoardMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.games.OpenLeaderboardMessageEvent;
    import com.sulake.habbo.room.events.RoomEngineLeaderboardEvent;
    import com.sulake.habbo.communication.messages.incoming.games.GameBoardUpdateMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.games.CloseGameBoardMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.engine.ItemsEvent;
    import com.sulake.habbo.communication.messages.incoming.room.engine.ItemAddMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.engine.ItemRemoveMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.engine.ItemUpdateMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.engine.ItemDataUpdateMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.engine.UsersEvent;
    import com.sulake.habbo.communication.messages.incoming.room.engine.UserUpdateEvent;
    import com.sulake.habbo.communication.messages.incoming.room.engine.UserRemoveMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.engine.UserChangeMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.action.ExpressionMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.action.DanceMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.action.AvatarEffectMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.action.SleepMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.action.CarryObjectMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.action.UseObjectMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.engine.SlideObjectBundleMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.engine.WiredMovementsMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.engine.ConfigurationItemStatesMessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.engine.ConfigurationItemStatesMessageParser;
    import com.sulake.habbo.communication.messages.incoming.room.engine.WiredFurniMovementData;
    import com.sulake.habbo.communication.messages.incoming.room.engine.WiredUserMovementData;
    import com.sulake.habbo.communication.messages.incoming.room.engine.WiredWallItemMovementData;
    import com.sulake.habbo.communication.messages.incoming.room.engine.WiredUserDirectionData;
    import com.sulake.room.object.IRoomObjectModel;
    import com.sulake.habbo.communication.messages.incoming.room.chat.ChatMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.chat.WhisperMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.chat.ShoutMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.chat.UserTypingMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.furniture.DiceValueMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.furniture.OneWayDoorStatusMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.pets.PetExperienceEvent;
    import com.sulake.habbo.communication.messages.incoming.room.session.YouArePlayingGameMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.session.GamePlayerValueMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.pets.PetFigureUpdateEvent;
    import com.sulake.habbo.communication.messages.incoming.users.IgnoreResultMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.help.GuideSessionStartedMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.help.GuideSessionEndedMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.help.GuideSessionErrorMessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.outgoing.room.engine.GetFurnitureAliasesMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.room.engine.GetRoomEntryDataMessageComposer;
    import com.sulake.habbo.communication.messages.parser.room.engine.FurnitureAliasesMessageParser;
    import com.sulake.habbo.room.utils.FurniStackingHeightMap;
    import com.sulake.habbo.communication.messages.parser.room.layout.RoomEntryTileMessageParser;
    import com.sulake.habbo.communication.messages.incoming.room.engine.ObjectMessageData;
    import com.sulake.room.utils.IVector3d;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.habbo.room.IAreaHideInfo;
    import com.sulake.habbo.communication.messages.incoming.room.engine.ObjectData;
    import com.sulake.habbo.communication.messages.parser.room.engine.ObjectRemoveMessageParser;
    import com.sulake.habbo.room.events.RoomEngineGamehallEvent;
    import com.sulake.habbo.communication.messages.incoming.room.engine.ItemMessageData;
    import com.sulake.habbo.communication.messages.incoming.room.engine.UserMessageData;
    import com.sulake.habbo.room.object.RoomObjectUserTypes;
    import com.sulake.habbo.avatar.pets.PetTypeEnum;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.habbo.communication.messages.incoming.room.engine.UserUpdateMessageData;
    import com.sulake.habbo.communication.messages.incoming.room.engine.AvatarActionMessageData;
    import com.sulake.room.IRoomInstance;
    import com.sulake.habbo.communication.messages.parser.room.action.CarryObjectMessageParser;
    import com.sulake.habbo.communication.messages.parser.room.action.UseObjectMessageParser;
    import com.sulake.habbo.communication.messages.parser.room.engine.SlideObjectBundleMessageParser;
    import com.sulake.habbo.communication.messages.incoming.room.engine.SlideObjectMessageData;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;
    import com.sulake.habbo.communication.messages.parser.room.chat.ChatMessageParser;
    import com.sulake.habbo.room.object.data.LegacyStuffData;
    import com.sulake.habbo.communication.messages.parser.room.session.GamePlayerValueMessageParser;
    import com.sulake.habbo.communication.messages.parser.help.GuideSessionStartedMessageParser;
    import com.sulake.habbo.avatar._enum.AvatarGuideStatus;
    import com.sulake.habbo.room.object.RoomObjectTypeEnum;
    import com.sulake.habbo.communication.messages.incoming.catalog.BCPlacementWarningMessageEvent;
    import com.sulake.habbo.communication.messages.parser.catalog.BCPlacementWarningMessageParser;
    import com.sulake.habbo.communication.messages.outgoing.catalog.BuildersClubPlaceRoomItemMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.catalog.BuildersClubPlaceWallItemMessageComposer;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.window.events.WindowEvent;

     class RoomMessageHandler
    {
        static inline final PUBLIC_ROOM_OBJECT_RETRY_DELAY= 100;
        static inline final PUBLIC_ROOM_OBJECT_MAX_RETRIES= 50;
        var _connection:IConnection = null;
        var _roomCreator:IRoomCreator = null;
        var _planeParser:RoomPlaneParser = null;
        var _latestEntryTileEvent:RoomEntryTileMessageEvent = null;
        var _ownUserId:Int = -1;
        var _initialConnection:Bool = true;
        var _passiveObjectRunningId:Int = Std.int(-1000000000);
        var _currentRoomId:Int = 0;
        var _tempViralHolder:ASObject;
        var _guideId:Int = -1;
        var _requesterId:Int = -1;
        var _pendingPublicRoomObjects:ASObject;
        var _pendingPublicRoomObjectRetryCounts:ASObject;
        var _pendingPublicRoomObjectRetryScheduled:ASObject;

        public function new(k:IRoomCreator)
        {
            this._tempViralHolder = new ASObject();
            this._pendingPublicRoomObjects = new ASObject();
            this._pendingPublicRoomObjectRetryCounts = new ASObject();
            this._pendingPublicRoomObjectRetryScheduled = new ASObject();
            this._roomCreator = k;
            this._planeParser = new RoomPlaneParser();
            this._initialConnection = true;
        }

        public function dispose()
        {
            this._connection = null;
            this._roomCreator = null;
            if (this._planeParser != null)
            {
                this._planeParser.dispose();
                this._planeParser = null;
            }
            this._latestEntryTileEvent = null;
            this._pendingPublicRoomObjects = null;
            this._pendingPublicRoomObjectRetryCounts = null;
            this._pendingPublicRoomObjectRetryScheduled = null;
        }

        public function setCurrentRoom(k:Int)
        {
            if (this._currentRoomId != 0)
            {
                this.clearPendingPublicRoomObjects(this._currentRoomId);
                if (this._roomCreator != null)
                {
                    this._roomCreator.disposeRoom(this._currentRoomId);
                }
            }
            this._currentRoomId = k;
            this._latestEntryTileEvent = null;
        }

        public function resetCurrentRoom()
        {
            this.clearPendingPublicRoomObjects(this._currentRoomId);
            this._currentRoomId = 0;
            this._latestEntryTileEvent = null;
        }

        function getRoomId(k:Int):Int
        {
            return this._currentRoomId;
        }

        public var connection(never,set):IConnection;
public function  set_connection(k:IConnection):IConnection        {
            if (this._connection != null)
            {
                return k;
            }
            if (k != null)
            {
                this._connection = k;
                k.addMessageEvent(new UserObjectEvent(this.onOwnUserEvent));
                k.addMessageEvent(new RoomReadyMessageEvent(this.onRoomReady));
                k.addMessageEvent(new RoomPropertyMessageEvent(this.onRoomProperty));
                k.addMessageEvent(new RoomEntryTileMessageEvent(this.onEntryTileData));
                k.addMessageEvent(new FloorHeightMapEvent(this.onFloorHeightMap));
                k.addMessageEvent(new AreaHideMessageEvent(this.onAreaHide));
                k.addMessageEvent(new HeightMapEvent(this.onHeightMap));
                k.addMessageEvent(new HeightMapUpdateMessageEvent(this.onHeightMapUpdate));
                k.addMessageEvent(new RoomVisualizationSettingsEvent(this.onRoomVisualizationSettings));
                k.addMessageEvent(new FurnitureAliasesMessageEvent(this.onFurnitureAliases));
                k.addMessageEvent(new ObjectsMessageEvent(this.onObjects));
                k.addMessageEvent(new ObjectAddMessageEvent(this.onObjectAdd));
                k.addMessageEvent(new ObjectUpdateMessageEvent(this.onObjectUpdate));
                k.addMessageEvent(new ObjectDataUpdateMessageEvent(this.onObjectDataUpdate));
                k.addMessageEvent(new ObjectsDataUpdateMessageEvent(this.onObjectsDataUpdate));
                k.addMessageEvent(new ObjectRemoveMessageEvent(this.onObjectRemove));
                k.addMessageEvent(new PublicRoomObjectsMessageEvent(this.onPublicRoomObjects));
                k.addMessageEvent(new BusDoorMessageEvent(this.onBusDoor));
                k.addMessageEvent(new OpenGameBoardMessageEvent(this.onOpenGameBoard));
                k.addMessageEvent(new OpenLeaderboardMessageEvent(this.onOpenLeaderboard));
                k.addMessageEvent(new GameBoardUpdateMessageEvent(this.onGameBoardUpdate));
                k.addMessageEvent(new CloseGameBoardMessageEvent(this.onCloseGameBoard));
                k.addMessageEvent(new ItemsEvent(this.onItems));
                k.addMessageEvent(new ItemAddMessageEvent(this.onItemAdd));
                k.addMessageEvent(new ItemRemoveMessageEvent(this.onItemRemove));
                k.addMessageEvent(new ItemUpdateMessageEvent(this.onItemUpdate));
                k.addMessageEvent(new ItemDataUpdateMessageEvent(this.onItemDataUpdate));
                k.addMessageEvent(new UsersEvent(this.onUsers));
                k.addMessageEvent(new UserUpdateEvent(this.onUserUpdate));
                k.addMessageEvent(new UserRemoveMessageEvent(this.onUserRemove));
                k.addMessageEvent(new UserChangeMessageEvent(this.onUserChange));
                k.addMessageEvent(new ExpressionMessageEvent(this.onExpression));
                k.addMessageEvent(new DanceMessageEvent(this.onDance));
                k.addMessageEvent(new AvatarEffectMessageEvent(this.onAvatarEffect));
                k.addMessageEvent(new SleepMessageEvent(this.onAvatarSleep));
                k.addMessageEvent(new CarryObjectMessageEvent(this.onCarryObject));
                k.addMessageEvent(new UseObjectMessageEvent(this.onUseObject));
                k.addMessageEvent(new SlideObjectBundleMessageEvent(this.onSlideUpdate));
                k.addMessageEvent(new WiredMovementsMessageEvent(this.onWiredMovements));
                k.addMessageEvent(new ConfigurationItemStatesMessageEvent(this.onConfigurationItemStates));
                k.addMessageEvent(new ChatMessageEvent(this.onChat));
                k.addMessageEvent(new WhisperMessageEvent(this.onChat));
                k.addMessageEvent(new ShoutMessageEvent(this.onChat));
                k.addMessageEvent(new UserTypingMessageEvent(this.onTypingStatus));
                k.addMessageEvent(new DiceValueMessageEvent(this.onDiceValue));
                k.addMessageEvent(new OneWayDoorStatusMessageEvent(this.onOneWayDoorStatus));
                k.addMessageEvent(new PetExperienceEvent(this.onPetExperience));
                k.addMessageEvent(new YouArePlayingGameMessageEvent(this.onPlayingGame));
                k.addMessageEvent(new GamePlayerValueMessageEvent(this.onGamePlayerNumberValue));
                k.addMessageEvent(new PetFigureUpdateEvent(this.onPetFigureUpdate));
                k.addMessageEvent(new IgnoreResultMessageEvent(this.onIgnoreResult));
                k.addMessageEvent(new GuideSessionStartedMessageEvent(this.onGuideSessionStarted));
                k.addMessageEvent(new GuideSessionEndedMessageEvent(this.onGuideSessionEnded));
                k.addMessageEvent(new GuideSessionErrorMessageEvent(this.onGuideSessionError));
                k.addMessageEvent(new BCPlacementWarningMessageEvent(this.onBCPlacementWarning));
            }
return k;
        }

        function onBCPlacementWarning(k:IMessageEvent)
        {
            var event= Std.downcast(k , BCPlacementWarningMessageEvent);
            if (event == null)
            {
                return;
            }
            var parser= event.getParser();
            if (parser == null)
            {
                return;
            }

            var composer:IMessageComposer = null;
            if (parser.typeCode == BCPlacementWarningMessageParser.TYPE_FLOOR)
            {
                composer = new BuildersClubPlaceRoomItemMessageComposer(
                    parser.pageId, parser.offerId, parser.extraParam,
                    parser.x, parser.y, parser.direction, true);
            }
            else
            {
                composer = new BuildersClubPlaceWallItemMessageComposer(
                    parser.pageId, parser.offerId, parser.extraParam,
                    parser.wallLocation, true);
            }

            ASCompat.reinterpretAs(this._roomCreator , IRoomEngineServices).windowManager.confirm(
                "${generic.alert.title}",
                "${room.confirm.hide_room}",
                0,
                function(dlg:com.sulake.habbo.window.utils.IConfirmDialog, evt:WindowEvent)
                {
                    dlg.dispose();
                    if (evt.type == WindowEvent.WINDOW_EVENT_OK)
                    {
                        k.connection.send(composer);
                    }
                }
            );
        }

        function onOwnUserEvent(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , UserObjectEvent);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= _local_2.getParser();
            if (_local_3 != null)
            {
                this._ownUserId = _local_3.id;
            }
        }

        function onRoomReady(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , RoomReadyMessageEvent);
            if ((((_local_2 == null) || (_local_2.getParser() == null)) || (k.connection == null)))
            {
                return;
            }
            var _local_3= _local_2.getParser();
            if (this._currentRoomId != _local_3.roomId)
            {
                this.setCurrentRoom(_local_3.roomId);
            }
            var _local_4= _local_3.roomType;
            if (this._roomCreator != null)
            {
                this._roomCreator.setWorldType(_local_3.roomId, _local_4, _local_3.isPublic);
            }
            if (this._initialConnection)
            {
                k.connection.send(new GetFurnitureAliasesMessageComposer());
                this._initialConnection = false;
            }
            else
            {
                k.connection.send(new GetRoomEntryDataMessageComposer());
            }
        }

        function onFurnitureAliases(k:IMessageEvent)
        {
            var _local_2:FurnitureAliasesMessageEvent = null;
            var _local_3:FurnitureAliasesMessageParser = null;
            var _local_4 = 0;
            var _local_5 = 0;
            var _local_6:String = null;
            var _local_7:String = null;
            if (this._roomCreator != null)
            {
                _local_2 = Std.downcast(k , FurnitureAliasesMessageEvent);
                if (((_local_2 == null) || (_local_2.getParser() == null)))
                {
                    return;
                }
                _local_3 = _local_2.getParser();
                if (_local_3 != null)
                {
                    _local_4 = _local_3.aliasCount;
                    _local_5 = 0;
                    while (_local_5 < _local_4)
                    {
                        _local_6 = _local_3.getName(_local_5);
                        _local_7 = _local_3.getAlias(_local_5);
                        this._roomCreator.setRoomObjectAlias(_local_6, _local_7);
                        _local_5++;
                    }
                }
            }
            k.connection.send(new GetRoomEntryDataMessageComposer());
        }

        function onBusDoor(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , BusDoorMessageEvent);
            if ((((_local_2 == null) || (_local_2.getParser() == null)) || (this._roomCreator == null)))
            {
                return;
            }
            var _local_3= _local_2.getParser();
            this._roomCreator.updatePublicRoomParkBusDoor(this._currentRoomId, _local_3.open);
        }

        function onOpenGameBoard(k:IMessageEvent)
        {
            var event= Std.downcast(k , OpenGameBoardMessageEvent);
            var engine= ASCompat.reinterpretAs(this._roomCreator , IRoomEngineServices);
            if (event == null || event.getParser() == null || engine == null || engine.events == null)
            {
                return;
            }
            var parser= event.getParser();
            engine.events.dispatchEvent(new RoomEngineGamehallEvent(
                RoomEngineGamehallEvent.OPEN,
                this._currentRoomId,
                parser.stationId,
                parser.gameType,
                parser.localSeat,
                parser.seatCount));
        }

        function onOpenLeaderboard(k:IMessageEvent)
        {
            var event= Std.downcast(k , OpenLeaderboardMessageEvent);
            var engine= ASCompat.reinterpretAs(this._roomCreator , IRoomEngineServices);
            if (event == null || event.getParser() == null || engine == null || engine.events == null)
            {
                return;
            }
            engine.events.dispatchEvent(new RoomEngineLeaderboardEvent(this._currentRoomId, event.getParser()));
        }

        function onGameBoardUpdate(k:IMessageEvent)
        {
            var event= Std.downcast(k , GameBoardUpdateMessageEvent);
            var engine= ASCompat.reinterpretAs(this._roomCreator , IRoomEngineServices);
            if (event == null || event.getParser() == null || engine == null || engine.events == null)
            {
                return;
            }
            var parser= event.getParser();
            engine.events.dispatchEvent(new RoomEngineGamehallEvent(
                RoomEngineGamehallEvent.UPDATE,
                this._currentRoomId,
                parser.stationId,
                "",
                0,
                0,
                parser.verb,
                parser.args));
        }

        function onCloseGameBoard(k:IMessageEvent)
        {
            var event= Std.downcast(k , CloseGameBoardMessageEvent);
            var engine= ASCompat.reinterpretAs(this._roomCreator , IRoomEngineServices);
            if (event == null || event.getParser() == null || engine == null || engine.events == null)
            {
                return;
            }
            var parser= event.getParser();
            engine.events.dispatchEvent(new RoomEngineGamehallEvent(
                RoomEngineGamehallEvent.CLOSE,
                this._currentRoomId,
                parser.stationId,
                "",
                0,
                0,
                "",
                null,
                parser.reason));
        }

        function onPublicRoomObjects(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , PublicRoomObjectsMessageEvent);
            if ((((_local_2 == null) || (_local_2.getParser() == null)) || (this._roomCreator == null)))
            {
                return;
            }
            var _local_3= _local_2.getParser();
            var _local_4= _local_3.roomId;
            var _local_5= this._roomCreator.getWorldType(_local_4);
            if (((_local_5 == null) || (_local_5.length == 0)))
            {
                return;
            }
            var _local_6= _local_3.objects;
            if (_local_6 == null)
            {
                return;
            }
            this.clearPendingPublicRoomObjects(_local_4);
            var _local_7 = 0;
            var _local_8:PublicRoomObjectMessageData = null;
            var _local_9:String = null;
            var _local_10= this._roomCreator.getPublicRoomContentType(_local_5);
            var _local_12:Array<ASAny> = [];
            while (_local_7 < _local_6.length)
            {
                _local_8 = _local_6[_local_7];
                _local_9 = ((_local_10 + "_") + _local_8.type);
                _local_12.push({"id":this.getNextPassiveObjectId(), "data":_local_8, "clientType":_local_9});
                _local_7++;
            }
            if (_local_12.length == 0)
            {
                return;
            }
            this._pendingPublicRoomObjects[Std.string(_local_4)] = _local_12;
            this._pendingPublicRoomObjectRetryCounts[Std.string(_local_4)] = 0;
            this._pendingPublicRoomObjectRetryScheduled[Std.string(_local_4)] = false;
            this.flushPublicRoomObjects(_local_4);
        }

        function getNextPassiveObjectId():Int
        {
            if (this._passiveObjectRunningId > 0)
            {
                this._passiveObjectRunningId = Std.int(-1000000000);
            }
            return --this._passiveObjectRunningId;
        }

        function flushPublicRoomObjects(k:Int)
        {
            var _local_3:ASObject = null;
            var _local_4:PublicRoomObjectMessageData = null;
            var _local_5:String = null;
            var _local_6:Vector3d = null;
            var _local_7:Vector3d = null;
            var _local_8:Array<ASAny> = null;
            var _local_9 = 0;
            var _local_10 = 0;
            if (((this._roomCreator == null) || (this._pendingPublicRoomObjects == null)))
            {
                return;
            }
            var _local_2:Array<ASAny> = ASCompat.dynamicAs(this._pendingPublicRoomObjects[Std.string(k)] , Array);
            if (_local_2 == null)
            {
                return;
            }
            this._pendingPublicRoomObjectRetryScheduled[Std.string(k)] = false;
            _local_8 = [];
            if (checkNullIteratee(_local_2)) for (_tmp_ in _local_2)
            {
_local_3  = _tmp_;
                _local_4 = ASCompat.dynamicAs(_local_3.data , PublicRoomObjectMessageData);
                _local_5 = ASCompat.asString(_local_3.clientType );
                if (((_local_4 == null) || (_local_5 == null)))
                {
                    continue;
                }
                if (!this._roomCreator.isRoomObjectContentAvailable(_local_5))
                {
                    _local_8.push(_local_3);
                }
                else
                {
                    _local_6 = new Vector3d(_local_4.x, _local_4.y, _local_4.z);
                    _local_7 = new Vector3d(_local_4.direction, 0, 0);
                    this._roomCreator.addObjectFurnitureByName(k, ASCompat.toInt(_local_3.id), _local_5, _local_6, _local_7, 0, null);
                }
            }
            if (_local_8.length == 0)
            {
                this.clearPendingPublicRoomObjects(k);
                return;
            }
            _local_9 = ASCompat.toInt(this._pendingPublicRoomObjectRetryCounts[Std.string(k)]);
            if (_local_9 >= PUBLIC_ROOM_OBJECT_MAX_RETRIES)
            {
                this.clearPendingPublicRoomObjects(k);
                return;
            }
            this._pendingPublicRoomObjects[Std.string(k)] = _local_8;
            this._pendingPublicRoomObjectRetryCounts[Std.string(k)] = (_local_9 + 1);
            if (this._pendingPublicRoomObjectRetryScheduled[Std.string(k)])
            {
                return;
            }
            this._pendingPublicRoomObjectRetryScheduled[Std.string(k)] = true;
            _local_10 = k;
            ASCompat.setTimeout(function ()
            {
                flushPublicRoomObjects(_local_10);
            }, PUBLIC_ROOM_OBJECT_RETRY_DELAY);
        }

        function clearPendingPublicRoomObjects(k:Int)
        {
            if (this._pendingPublicRoomObjects != null)
            {
                Reflect.deleteField(this._pendingPublicRoomObjects, Std.string(k));
            }
            if (this._pendingPublicRoomObjectRetryCounts != null)
            {
                Reflect.deleteField(this._pendingPublicRoomObjectRetryCounts, Std.string(k));
            }
            if (this._pendingPublicRoomObjectRetryScheduled != null)
            {
                Reflect.deleteField(this._pendingPublicRoomObjectRetryScheduled, Std.string(k));
            }
        }

        function onHeightMap(k:IMessageEvent)
        {
            var _local_8 = 0;
            var _local_9 = Math.NaN;
            var _local_10 = false;
            var _local_11 = false;
            var _local_2= Std.downcast(k , HeightMapEvent);
            if (((_local_2 == null) || (_local_2.getParser() == null)))
            {
                return;
            }
            if (this._roomCreator == null)
            {
                return;
            }
            var _local_3= _local_2.getParser();
            var _local_4= _local_3.width;
            var _local_5= _local_3.height;
            var _local_6= new FurniStackingHeightMap(_local_4, _local_5);
            var _local_7 = 0;
            while (_local_7 < _local_5)
            {
                _local_8 = 0;
                while (_local_8 < _local_4)
                {
                    _local_9 = _local_3.getTileHeight(_local_8, _local_7);
                    _local_10 = _local_3.getStackingBlocked(_local_8, _local_7);
                    _local_11 = _local_3.isRoomTile(_local_8, _local_7);
                    _local_6._Str_3982(_local_8, _local_7, _local_9);
                    _local_6.setStackingBlocked(_local_8, _local_7, _local_10);
                    _local_6.setIsRoomTile(_local_8, _local_7, _local_11);
                    _local_8++;
                }
                _local_7++;
            }
            this._roomCreator.setFurniStackingHeightMap(this._currentRoomId, _local_6);
        }

        function onHeightMapUpdate(k:IMessageEvent)
        {
            var _local_5 = 0;
            var _local_6 = 0;
            var _local_2= Std.downcast(k , HeightMapUpdateMessageEvent);
            if (((_local_2 == null) || (_local_2.getParser() == null)))
            {
                return;
            }
            if (this._roomCreator == null)
            {
                return;
            }
            var _local_3= _local_2.getParser();
            var _local_4= this._roomCreator.getFurniStackingHeightMap(this._currentRoomId);
            if (_local_4 == null)
            {
                return;
            }
            while (_local_3.next())
            {
                _local_5 = _local_3.x;
                _local_6 = _local_3.y;
                _local_4._Str_3982(_local_5, _local_6, _local_3.tileHeight);
                _local_4.setStackingBlocked(_local_5, _local_6, _local_3.isStackingBlocked);
                _local_4.setIsRoomTile(_local_5, _local_6, _local_3.isRoomTile);
            }
            this._roomCreator.refreshTileObjectMap(this._currentRoomId, "RoomMessageHandler.onHeightMapUpdate()");
        }

        function onRoomVisualizationSettings(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , RoomVisualizationSettingsEvent);
            if (((_local_2 == null) || (_local_2.getParser() == null)))
            {
                return;
            }
            var _local_3= _local_2.getParser();
            var _local_4:ASAny = (!_local_3.wallsHidden);
            var _local_5= true;
            var _local_6= _local_3.wallThicknessMultiplier;
            var _local_7= _local_3.floorThicknessMultiplier;
            if (this._roomCreator != null)
            {
                this._roomCreator.updateObjectRoomVisibilities(this._currentRoomId, _local_4, _local_5);
                this._roomCreator.updateObjectRoomPlaneThicknesses(this._currentRoomId, _local_6, _local_7);
            }
        }

        function onRoomProperty(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , RoomPropertyMessageEvent);
            if (((_local_2 == null) || (_local_2.getParser() == null)))
            {
                return;
            }
            var _local_3= _local_2.getParser();
            var _local_4= _local_3.floorType;
            var _local_5= _local_3.wallType;
            var _local_6= _local_3.landscapeType;
            if (this._roomCreator != null)
            {
                this._roomCreator.updateObjectRoom(this._currentRoomId, _local_4, _local_5, _local_6);
            }
        }

        function onAreaHide(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , AreaHideMessageEvent);
            if (((_local_2 == null) || (_local_2.getParser() == null) || (this._roomCreator == null)))
            {
                return;
            }
            var _local_3= _local_2.getParser().areaHideMessageData;
            if (_local_3 != null)
            {
                this._roomCreator.updateAreaHide(this._currentRoomId, _local_3.furniId, _local_3.on, _local_3.rootX, _local_3.rootY, _local_3.width, _local_3.length, _local_3.invert);
            }
        }

        function onEntryTileData(k:RoomEntryTileMessageEvent)
        {
            this._latestEntryTileEvent = k;
        }

        function onFloorHeightMap(k:IMessageEvent)
        {
            var _local_17 = 0;
            var _local_18 = 0;
            var _local_19 = 0;
            var _local_2= Std.downcast(k , FloorHeightMapEvent);
            if (((_local_2 == null) || (_local_2.getParser() == null)))
            {
                return;
            }
            var _local_3= _local_2.getParser();
            if (this._roomCreator == null)
            {
                return;
            }
            var _local_4= this._roomCreator.getLegacyGeometry(this._currentRoomId);
            if (_local_4 == null)
            {
                return;
            }
            this._planeParser.reset();
            var _local_5= _local_3.width;
            var _local_6= _local_3.height;
            this._planeParser.initializeTileMap(_local_5, _local_6);
            var _local_7:Float = -1;
            var _local_8:Float = -1;
            var _local_9:Float = 0;
            var _local_10:Float = 0;
            var _local_11:RoomEntryTileMessageParser = null;
            if (this._latestEntryTileEvent != null)
            {
                _local_11 = this._latestEntryTileEvent.getParser();
            }
            var _local_12= this._roomCreator.getFurniStackingHeightMap(this._currentRoomId);
            if (_local_12 == null)
            {
                return;
            }
            var _local_13 = 0;
            while (_local_13 < _local_6)
            {
                _local_17 = 0;
                while (_local_17 < _local_5)
                {
                    _local_18 = _local_3.getTileHeight(_local_17, _local_13);
                    if ((((((_local_13 > 0) && (_local_13 < (_local_6 - 1))) || ((_local_17 > 0) && (_local_17 < (_local_5 - 1)))) && (!(_local_18 == RoomPlaneParser.TILE_BLOCKED))) && ((_local_11 == null) || ((_local_17 == _local_11.x) && (_local_13 == _local_11.y)))))
                    {
                        if ((((_local_3.getTileHeight(_local_17, (_local_13 - 1)) == RoomPlaneParser.TILE_BLOCKED) && (_local_3.getTileHeight((_local_17 - 1), _local_13) == RoomPlaneParser.TILE_BLOCKED)) && (_local_3.getTileHeight(_local_17, (_local_13 + 1)) == RoomPlaneParser.TILE_BLOCKED)))
                        {
                            _local_7 = (_local_17 + 0.5);
                            _local_8 = _local_13;
                            _local_9 = _local_18;
                            _local_10 = 90;
                        }
                        if ((((_local_3.getTileHeight(_local_17, (_local_13 - 1)) == RoomPlaneParser.TILE_BLOCKED) && (_local_3.getTileHeight((_local_17 - 1), _local_13) == RoomPlaneParser.TILE_BLOCKED)) && (_local_3.getTileHeight((_local_17 + 1), _local_13) == RoomPlaneParser.TILE_BLOCKED)))
                        {
                            _local_7 = _local_17;
                            _local_8 = (_local_13 + 0.5);
                            _local_9 = _local_18;
                            _local_10 = 180;
                        }
                    }
                    this._planeParser._Str_3982(_local_17, _local_13, _local_18);
                    _local_17++;
                }
                _local_13++;
            }
            this._planeParser._Str_3982(Std.int(Math.ffloor(_local_7)), Std.int(Math.ffloor(_local_8)), _local_9);
            this._planeParser.initializeFromTileData(_local_2.getParser().fixedWallsHeight);
            this._planeParser._Str_3982(Std.int(Math.ffloor(_local_7)), Std.int(Math.ffloor(_local_8)), (_local_9 + this._planeParser.wallHeight));
            _local_4.scale = Std.int(_local_3.scale);
            _local_4.initialize(_local_5, _local_6, Std.int(this._planeParser.floorHeight));
            var _local_14= (_local_3.height - 1);
            while (_local_14 >= 0)
            {
                _local_19 = (_local_3.width - 1);
                while (_local_19 >= 0)
                {
                    _local_4._Str_3982(_local_19, _local_14, this._planeParser.getTileHeight(_local_19, _local_14));
                    _local_19--;
                }
                _local_14--;
            }
            var _local_15= this._planeParser.getXML();
            var _local_16:com.sulake.core.utils.xml.XML = Type.createInstance(com.sulake.core.utils.xml.XML, [(("<doors>" + (((((((('<door x="' + Std.string(_local_7)) + '" y="') + Std.string(_local_8)) + '" z="') + Std.string(_local_9)) + '" dir="') + Std.string(_local_10)) + '"/>')) + "</doors>")]);
            _local_15.appendChild(_local_16);
            if (_local_3.hasExtendedData)
            {
                this._roomCreator.initializeRoom(this._currentRoomId, _local_15, new Vector3d(_local_3.cameraInitX, _local_3.cameraInitY, _local_3.cameraInitZ), (cast Vector.convert(_local_3.areaHideData) : Vector<IAreaHideInfo>));
            }
            else
            {
                this._roomCreator.initializeRoom(this._currentRoomId, _local_15);
            }
            if (this._tempViralHolder.objectData)
            {
                this.addActiveObject(this._currentRoomId, this._tempViralHolder.objectData);
                this._tempViralHolder.objectData = null;
            }
            else
            {
                this._tempViralHolder.floorReady = true;
            }
        }

        function onObjects(k:IMessageEvent)
        {
            var _local_6:ObjectMessageData = null;
            var _local_2= Std.downcast(k , ObjectsMessageEvent);
            if (((_local_2 == null) || (_local_2.getParser() == null)))
            {
                return;
            }
            var _local_3= _local_2.getParser();
            var _local_4= _local_3.getObjectCount();
            var _local_5 = 0;
            while (_local_5 < _local_4)
            {
                _local_6 = _local_3.getObject(_local_5);
                this.addActiveObject(this._currentRoomId, _local_6);
                _local_5++;
            }
        }

        function onObjectAdd(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , ObjectAddMessageEvent);
            if (((_local_2 == null) || (_local_2.getParser() == null)))
            {
                return;
            }
            var _local_3= _local_2.getParser();
            var _local_4= _local_3.data;
            this.addActiveObject(this._currentRoomId, _local_4);
        }

        function onObjectUpdate(k:IMessageEvent)
        {
            var _local_5:IVector3d = null;
            var _local_6:IVector3d = null;
            var _local_2= Std.downcast(k , ObjectUpdateMessageEvent);
            if (((_local_2 == null) || (_local_2.getParser() == null)))
            {
                return;
            }
            if (this._roomCreator == null)
            {
                return;
            }
            var _local_3= _local_2.getParser();
            var _local_4= _local_3.data;
            if (_local_4 != null)
            {
                _local_5 = new Vector3d(_local_4.x, _local_4.y, _local_4.z);
                _local_6 = new Vector3d(_local_4.dir);
                this._roomCreator.updateObjectFurniture(this._currentRoomId, _local_4.id, _local_5, _local_6, _local_4.state, _local_4.data, _local_4.extra);
                this._roomCreator.updateObjectFurnitureHeight(this._currentRoomId, _local_4.id, _local_4.sizeZ);
                this._roomCreator.updateObjectFurnitureExpiryTime(this._currentRoomId, _local_4.id, _local_4.expiryTime);
            }
        }

        function onObjectDataUpdate(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , ObjectDataUpdateMessageEvent);
            if (((_local_2 == null) || (_local_2.getParser() == null)))
            {
                return;
            }
            if (this._roomCreator == null)
            {
                return;
            }
            var _local_3= _local_2.getParser();
            var _local_4= _local_3.id;
            var _local_5= _local_3.state;
            var _local_6= _local_3.data;
            this._roomCreator.updateObjectFurniture(this._currentRoomId, _local_4, null, null, _local_5, _local_6);
        }

        function onObjectsDataUpdate(k:IMessageEvent)
        {
            var _local_5:ObjectData = null;
            var _local_6 = 0;
            var _local_7 = 0;
            var _local_8:IStuffData = null;
            var _local_2= Std.downcast(k , ObjectsDataUpdateMessageEvent);
            if (((_local_2 == null) || (_local_2.getParser() == null)))
            {
                return;
            }
            if (this._roomCreator == null)
            {
                return;
            }
            var _local_3= _local_2.getParser();
            var _local_4 = 0;
            while (_local_4 < _local_3.objectCount)
            {
                _local_5 = _local_3._Str_24113(_local_4);
                if (_local_5 != null)
                {
                    _local_6 = _local_5.id;
                    _local_7 = _local_5.state;
                    _local_8 = _local_5.data;
                    this._roomCreator.updateObjectFurniture(this._currentRoomId, _local_6, null, null, _local_7, _local_8);
                }
                _local_4++;
            }
        }

        function onObjectRemove(event:IMessageEvent)
        {
            var parser:ObjectRemoveMessageParser = null;
            var id = 0;
            var objectRemoveEvent= Std.downcast(event , ObjectRemoveMessageEvent);
            if (((objectRemoveEvent == null) || (objectRemoveEvent.getParser() == null)))
            {
                return;
            }
            if (this._roomCreator == null)
            {
                return;
            }
            parser = objectRemoveEvent.getParser();
            id = parser.id;
            var delay= parser.delay;
            if (delay > 0)
            {
                ASCompat.setTimeout(function ()
                {
                    _roomCreator.disposeObjectFurniture(_currentRoomId, id, (parser.isExpired ? -1 : parser.pickerId), true);
                }, delay);
            }
            else
            {
                this._roomCreator.disposeObjectFurniture(this._currentRoomId, id, (parser.isExpired ? -1 : parser.pickerId), true);
            }
        }

        function addActiveObject(k:Int, _arg_2:ObjectMessageData)
        {
            if (((_arg_2 == null) || (this._roomCreator == null)))
            {
                return;
            }
            var _local_3:IVector3d = new Vector3d(_arg_2.x, _arg_2.y, _arg_2.z);
            var _local_4:IVector3d = new Vector3d(_arg_2.dir);
            if (_arg_2.staticClass != null)
            {
                this._roomCreator.addObjectFurnitureByName(k, _arg_2.id, _arg_2.staticClass, _local_3, _local_4, _arg_2.state, _arg_2.data, _arg_2.extra);
            }
            else
            {
                this._roomCreator.addObjectFurniture(k, _arg_2.id, _arg_2.type, _local_3, _local_4, _arg_2.state, _arg_2.data, _arg_2.extra, _arg_2.expiryTime, _arg_2.usagePolicy, _arg_2.ownerId, _arg_2.ownerName, true, true, _arg_2.sizeZ);
            }
        }

        function onItems(k:IMessageEvent)
        {
            var _local_6:ItemMessageData = null;
            var _local_2= Std.downcast(k , ItemsEvent);
            if (((_local_2 == null) || (_local_2.getParser() == null)))
            {
                return;
            }
            var _local_3= _local_2.getParser();
            var _local_4= _local_3.getItemCount();
            var _local_5 = 0;
            while (_local_5 < _local_4)
            {
                _local_6 = _local_3.getItem(_local_5);
                this.addWallItem(this._currentRoomId, _local_6);
                _local_5++;
            }
        }

        function onItemAdd(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , ItemAddMessageEvent);
            if (((_local_2 == null) || (_local_2.getParser() == null)))
            {
                return;
            }
            var _local_3= _local_2.getParser();
            var _local_4= _local_3.data;
            if (_local_4 != null)
            {
                this.addWallItem(this._currentRoomId, _local_4);
            }
        }

        function onItemRemove(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , ItemRemoveMessageEvent);
            if (((_local_2 == null) || (_local_2.getParser() == null)))
            {
                return;
            }
            if (this._roomCreator == null)
            {
                return;
            }
            var _local_3= _local_2.getParser();
            this._roomCreator.disposeObjectWallItem(this._currentRoomId, _local_3.itemId, _local_3.pickerId);
        }

        function onItemUpdate(k:IMessageEvent)
        {
            var _local_6:IVector3d = null;
            var _local_7:IVector3d = null;
            var _local_2= Std.downcast(k , ItemUpdateMessageEvent);
            if (((_local_2 == null) || (_local_2.getParser() == null)))
            {
                return;
            }
            var _local_3= _local_2.getParser();
            var _local_4= this._roomCreator.getLegacyGeometry(this._currentRoomId);
            if (((this._roomCreator == null) || (_local_4 == null)))
            {
                return;
            }
            var _local_5= _local_3.data;
            if (_local_5 != null)
            {
                _local_6 = _local_4.getLocation(Std.int(_local_5.wallX), Std.int(_local_5.wallY), Std.int(_local_5.localX), Std.int(_local_5.localY), _local_5.dir);
                _local_7 = new Vector3d(_local_4.getDirection(_local_5.dir));
                this._roomCreator.updateObjectWallItem(this._currentRoomId, _local_5.id, _local_6, _local_7, _local_5.state, _local_5.data);
                this._roomCreator.updateObjectWallItemExpiryTime(this._currentRoomId, _local_5.id, _local_5.secondsToExpiration);
            }
        }

        function onItemDataUpdate(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , ItemDataUpdateMessageEvent);
            if (((_local_2 == null) || (_local_2.getParser() == null)))
            {
                return;
            }
            var _local_3= _local_2.getParser();
            this._roomCreator.updateObjectWallItemData(this._currentRoomId, _local_3.id, _local_3.itemData);
        }

        function addWallItem(k:Int, _arg_2:ItemMessageData)
        {
            if (((_arg_2 == null) || (this._roomCreator == null)))
            {
                return;
            }
            var _local_3= this._roomCreator.getLegacyGeometry(k);
            if (_local_3 == null)
            {
                return;
            }
            var _local_4:IVector3d = null;
            if (!_arg_2.isOldFormat)
            {
                _local_4 = _local_3.getLocation(Std.int(_arg_2.wallX), Std.int(_arg_2.wallY), Std.int(_arg_2.localX), Std.int(_arg_2.localY), _arg_2.dir);
            }
            else
            {
                _local_4 = _local_3.getLocationOldFormat(_arg_2.y, _arg_2.z, _arg_2.dir);
            }
            var _local_5:IVector3d = new Vector3d(_local_3.getDirection(_arg_2.dir));
            this._roomCreator.addObjectWallItem(k, _arg_2.id, _arg_2.type, _local_4, _local_5, _arg_2.state, _arg_2.data, _arg_2.usagePolicy, _arg_2.ownerId, _arg_2.ownerName, _arg_2.secondsToExpiration);
        }

        function onUsers(k:IMessageEvent)
        {
            var _local_5:UserMessageData = null;
            var _local_6:IVector3d = null;
            var _local_7:IVector3d = null;
            var _local_8 = 0;
            var _local_2= Std.downcast(k , UsersEvent);
            if (((_local_2 == null) || (_local_2.getParser() == null)))
            {
                return;
            }
            if (this._roomCreator == null)
            {
                return;
            }
            var _local_3= _local_2.getParser();
            var _local_4 = 0;
            while (_local_4 < _local_3.getUserCount())
            {
                _local_5 = _local_3.getUser(_local_4);
                if (_local_5 != null)
                {
                    _local_6 = new Vector3d(_local_5.x, _local_5.y, _local_5.z);
                    _local_7 = new Vector3d(_local_5.dir);
                    _local_8 = _local_5.userType;
                    this._roomCreator.addObjectUser(this._currentRoomId, _local_5.roomIndex, _local_6, _local_7, _local_5.dir, _local_8, _local_5.figure);
                    if (_local_5.id == this._ownUserId)
                    {
                        this._roomCreator.setOwnUserId(this._currentRoomId, _local_5.roomIndex);
                        this._roomCreator.updateObjectUserOwnUserAvatar(this._currentRoomId, _local_5.roomIndex);
                    }
                    this._roomCreator.updateObjectUserFigure(this._currentRoomId, _local_5.roomIndex, _local_5.figure, _local_5.sex, _local_5.subType, _local_5.isRiding);
                    if (RoomObjectUserTypes.getName(_local_8) == RoomObjectUserTypes.PET)
                    {
                        if (this._roomCreator.getPetTypeId(_local_5.figure) == PetTypeEnum.MONSTERPLANT)
                        {
                            this._roomCreator.updateObjectUserPosture(this._currentRoomId, _local_5.roomIndex, _local_5.petPosture);
                        }
                    }
                    if (this._roomCreator.configuration.getBoolean("avatar.ignored.bubble.enabled"))
                    {
                        this._roomCreator.updateObjectUserAction(this._currentRoomId, _local_5.roomIndex, RoomObjectVariableEnum.FIGURE_IS_MUTED, Std.int(ASCompat.toNumber(this._roomCreator.sessionDataManager.isIgnored(_local_5.name))));
                    }
                }
                _local_4++;
            }
            this.updateGuideMarker();
        }

        function onUserUpdate(k:IMessageEvent)
        {
            var _local_7:UserUpdateMessageData = null;
            var _local_8 = Math.NaN;
            var _local_9:IVector3d = null;
            var _local_10:IVector3d = null;
            var _local_11:IVector3d = null;
            var _local_12 = false;
            var _local_13 = false;
            var _local_14:String = null;
            var _local_15:String = null;
            var _local_16 = false;
            var _local_17 = false;
            var _local_18:UInt = 0;
            var _local_19:AvatarActionMessageData = null;
            var _local_2= Std.downcast(k , UserUpdateEvent);
            if (((_local_2 == null) || (_local_2.getParser() == null)))
            {
                return;
            }
            if (this._roomCreator == null)
            {
                return;
            }
            var _local_3= _local_2.getParser();
            var _local_4= this._roomCreator.getRoom(this._currentRoomId);
            if (_local_4 == null)
            {
                return;
            }
            var _local_5= _local_4.getNumber(RoomVariableEnum.ROOM_Z_SCALE);
            var _local_6 = 0;
            while (_local_6 < _local_3.userUpdateCount)
            {
                _local_7 = _local_3._Str_24400(_local_6);
                if (_local_7 != null)
                {
                    _local_8 = _local_7._Str_23720;
                    if (_local_5 != 0)
                    {
                        _local_8 = (_local_8 / _local_5);
                    }
                    _local_9 = new Vector3d(_local_7.x, _local_7.y, (_local_7.z + _local_8));
                    _local_10 = new Vector3d(_local_7.dir);
                    _local_11 = null;
                    if (_local_7.isMoving)
                    {
                        _local_11 = new Vector3d(_local_7._Str_24054, _local_7._Str_24331, _local_7._Str_25822);
                    }
                    this._roomCreator.updateObjectUser(this._currentRoomId, _local_7.id, _local_9, _local_11, _local_7.canStandUp, _local_8, _local_10, _local_7.dirHead);
                    _local_12 = true;
                    _local_13 = false;
                    _local_14 = RoomObjectVariableEnum.STD;
                    _local_15 = "";
                    this._roomCreator.updateObjectUserFlatControl(this._currentRoomId, _local_7.id, null);
                    _local_16 = false;
                    _local_17 = false;
                    _local_18 = _local_7.actions.length;
                    final _iter_ = _local_7.actions; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                    {
_local_19  = _tmp_;
                        switch (_local_19.actionType)
                        {
                            case "flatctrl":
                                this._roomCreator.updateObjectUserFlatControl(this._currentRoomId, _local_7.id, _local_19.actionParameter);
                                
                            case "sign":
                                if (_local_18 == 1)
                                {
                                    _local_12 = false;
                                }
                                this._roomCreator.updateObjectUserAction(this._currentRoomId, _local_7.id, RoomObjectVariableEnum.FIGURE_SIGN, ASCompat.toInt(_local_19.actionParameter));
                                
                            case "gst":
                                if (_local_18 == 1)
                                {
                                    _local_12 = false;
                                }
                                this._roomCreator.updateObjectPetGesture(this._currentRoomId, _local_7.id, _local_19.actionParameter);
                                
                            case "wav"
                               | "mv":
                                _local_17 = true;
                                _local_13 = true;
                                _local_14 = _local_19.actionType;
                                _local_15 = _local_19.actionParameter;
                                
                            case "swim":
                                _local_16 = true;
                                _local_13 = true;
                                _local_14 = _local_19.actionType;
                                _local_15 = _local_19.actionParameter;
                                
                            case "trd":
                                
                            default:
                                _local_13 = true;
                                _local_14 = _local_19.actionType;
                                _local_15 = _local_19.actionParameter;
                        }
                    }
                    if (((!_local_17) && _local_16))
                    {
                        _local_13 = true;
                        _local_14 = "float";
                    }
                    if (_local_13)
                    {
                        this._roomCreator.updateObjectUserPosture(this._currentRoomId, _local_7.id, _local_14, _local_15);
                    }
                    else
                    {
                        if (_local_12)
                        {
                            this._roomCreator.updateObjectUserPosture(this._currentRoomId, _local_7.id, RoomObjectVariableEnum.STD, "");
                        }
                    }
                }
                _local_6++;
            }
            this.updateGuideMarker();
        }

        function onUserRemove(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , UserRemoveMessageEvent);
            if (((_local_2 == null) || (_local_2.getParser() == null)))
            {
                return;
            }
            if (this._roomCreator == null)
            {
                return;
            }
            var _local_3= _local_2.getParser();
            this._roomCreator.disposeObjectUser(this._currentRoomId, _local_3.id);
            this.updateGuideMarker();
        }

        function onUserChange(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , UserChangeMessageEvent);
            if (_local_2 == null)
            {
                return;
            }
            this._roomCreator.updateObjectUserFigure(this._currentRoomId, _local_2.id, _local_2.figure, _local_2.sex);
        }

        function onPetFigureUpdate(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , PetFigureUpdateEvent);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= _local_2.getParser();
            this._roomCreator.updateObjectUserFigure(this._currentRoomId, _local_3.roomIndex, _local_3.figureData.figuredata, "", "", _local_3.isRiding);
        }

        function onExpression(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , ExpressionMessageEvent);
            if (_local_2 == null)
            {
                return;
            }
            if (this._roomCreator == null)
            {
                return;
            }
            var _local_3= _local_2.getParser();
            if (_local_3 == null)
            {
                return;
            }
            this._roomCreator.updateObjectUserAction(this._currentRoomId, _local_3.userId, RoomObjectVariableEnum.FIGURE_EXPRESSION, _local_3.expressionType);
        }

        function onDance(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , DanceMessageEvent);
            if (((_local_2 == null) || (_local_2.getParser() == null)))
            {
                return;
            }
            if (this._roomCreator == null)
            {
                return;
            }
            var _local_3= _local_2.getParser();
            this._roomCreator.updateObjectUserAction(this._currentRoomId, _local_3.userId, RoomObjectVariableEnum.FIGURE_DANCE, _local_3._Str_8263);
        }

        function onAvatarEffect(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , AvatarEffectMessageEvent);
            if (((_local_2 == null) || (_local_2.getParser() == null)))
            {
                return;
            }
            if (this._roomCreator == null)
            {
                return;
            }
            var _local_3= _local_2.getParser();
            this._roomCreator.updateObjectUserEffect(this._currentRoomId, _local_3.userId, _local_3.effectId, _local_3.delayMilliSeconds);
        }

        function onAvatarSleep(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , SleepMessageEvent);
            if (((_local_2 == null) || (_local_2.getParser() == null)))
            {
                return;
            }
            if (this._roomCreator == null)
            {
                return;
            }
            var _local_3= _local_2.getParser();
            var _local_4= 1;
            if (!_local_3.sleeping)
            {
                _local_4 = 0;
            }
            this._roomCreator.updateObjectUserAction(this._currentRoomId, _local_3.userId, RoomObjectVariableEnum.FIGURE_SLEEP, _local_4);
        }

        function onCarryObject(k:IMessageEvent)
        {
            var _local_2:CarryObjectMessageParser = null;
            if (this._roomCreator == null)
            {
                return;
            }
            if (Std.is(k , CarryObjectMessageEvent))
            {
                _local_2 = Std.downcast(k , CarryObjectMessageEvent).getParser();
                this._roomCreator.updateObjectUserAction(this._currentRoomId, _local_2.userId, RoomObjectVariableEnum.FIGURE_CARRY_OBJECT, _local_2.itemType);
            }
        }

        function onUseObject(k:IMessageEvent)
        {
            var _local_2:UseObjectMessageParser = null;
            if (this._roomCreator == null)
            {
                return;
            }
            if (Std.is(k , UseObjectMessageEvent))
            {
                _local_2 = Std.downcast(k , UseObjectMessageEvent).getParser();
                this._roomCreator.updateObjectUserAction(this._currentRoomId, _local_2.userId, RoomObjectVariableEnum.FIGURE_USE_OBJECT, _local_2.itemType);
            }
        }

        function onConfigurationItemStates(k:IMessageEvent)
        {
            var _local_2:ConfigurationItemStatesMessageParser = null;
            if (this._roomCreator == null)
            {
                return;
            }
            _local_2 = Std.downcast(k , ConfigurationItemStatesMessageEvent).getParser();
            if (_local_2 != null)
            {
                this._roomCreator.setHanditemControlBlocked(
                    this._currentRoomId, _local_2.isHanditemControlBlocked);
                this._roomCreator.setChooserDisabled(
                    this._currentRoomId, _local_2.chooserDisabled);
                this._roomCreator.setFreeFurniMovementsMode(
                    this._currentRoomId, _local_2.freeFurniMovementsEnabled);
                this._roomCreator.setInvisibleFurni(this._currentRoomId, _local_2.invisibleFurni);
            }
        }

        function onWiredMovements(k:IMessageEvent)
        {
            var _local_3:WiredUserMovementData = null;
            var _local_4:WiredFurniMovementData = null;
            var _local_5:WiredWallItemMovementData = null;
            var _local_6:WiredUserDirectionData = null;
            if (this._roomCreator == null)
            {
                return;
            }
            var _local_2= Std.downcast(k , WiredMovementsMessageEvent).getParser();
            if (_local_2 == null)
            {
                return;
            }
            final _iter_ = _local_2.userMoves; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                this.onWiredUserMove(_local_3);
            }
            final _iter_ = _local_2.furniMoves; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_4  = _tmp_;
                this.onWiredFurniMove(_local_4);
            }
            final _iter_ = _local_2.wallItemMoves; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_5  = _tmp_;
                this.onWiredWallItemMove(_local_5);
            }
            final _iter_ = _local_2.userDirectionUpdates; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_6  = _tmp_;
                this.onUserDirectionUpdate(_local_6);
            }
        }

        function onWiredFurniMove(k:WiredFurniMovementData)
        {
            var _local_2:IVector3d = new Vector3d(((k.rotation % 8) * 45));
            this._roomCreator.updateObjectFurnitureLocation(this._currentRoomId, k.furniId,
                this.roundWiredLocation(k.source), _local_2, this.roundWiredLocation(k.target),
                k.animationTime, k.overshootingDistance, k.curveStrength);
        }

        /**
         * July aligns movement endpoints to whole screen pixels by applying a
         * tiny Z correction through the active room geometry. Without this,
         * repeated Wired movements can visibly shimmer between adjacent pixels.
         */
        function roundWiredLocation(k:IVector3d):IVector3d
        {
            var engine= ASCompat.reinterpretAs(this._roomCreator , IRoomEngine);
            if (engine == null)
            {
                return k;
            }
            var geometry= engine.getRoomCanvasGeometry(this._currentRoomId);
            if (geometry == null)
            {
                return k;
            }
            var screen= geometry.getScreenPosition(k);
            if (screen == null)
            {
                return k;
            }
            var raised= geometry.getScreenPosition(new Vector3d(k.x, k.y, k.z + 0.01));
            if (raised == null)
            {
                return k;
            }
            var zPixelsPerUnit= (screen.y - raised.y) * 100;
            if (zPixelsPerUnit == 0)
            {
                return k;
            }
            var pixelFraction= screen.y - Math.fround(screen.y);
            return new Vector3d(k.x, k.y, k.z + pixelFraction / zPixelsPerUnit);
        }

        function onWiredUserMove(k:WiredUserMovementData)
        {
            var _local_2 = false;
            var _local_3:IRoomInstance = null;
            var _local_4:IRoomObject = null;
            if (k.moveType == "sld")
            {
                _local_3 = this._roomCreator.getRoom(this._currentRoomId);
                if (_local_3 != null)
                {
                    _local_4 = _local_3.getObject(k.userIndex, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER);
                    if (_local_4 != null)
                    {
                        _local_2 = (_local_4.getModel().getNumber(RoomObjectVariableEnum.FIGURE_CAN_STAND_UP) > 0);
                    }
                }
            }
            var _local_5:IVector3d = new Vector3d(((k.bodyDirection % 8) * 45));
            var _local_6:Float = ((k.headDirection % 8) * 45);
            this._roomCreator.updateObjectUser(this._currentRoomId, k.userIndex,
                this.roundWiredLocation(k.source), this.roundWiredLocation(k.target),
                _local_2, 0, _local_5, _local_6, k.animationTime, false, k.jumpPower);
            this.setUserMovePosture(k.userIndex, k.moveType);
        }

        function onWiredWallItemMove(k:WiredWallItemMovementData)
        {
            var _local_2= this._roomCreator.getLegacyGeometry(this._currentRoomId);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= (k.isDirectionRight ? "r" : "l");
            var _local_4= _local_2.getLocation(k.oldWallX, k.oldWallY, k.oldOffsetX, k.oldOffsetY, _local_3);
            var _local_5= _local_2.getLocation(k.newWallX, k.newWallY, k.newOffsetX, k.newOffsetY, _local_3);
            this._roomCreator.updateObjectWallItemLocation(this._currentRoomId, k.itemId,
                this.roundWiredLocation(_local_4), this.roundWiredLocation(_local_5), k.animationTime);
        }

        function onUserDirectionUpdate(k:WiredUserDirectionData)
        {
            var _local_2:IVector3d = new Vector3d(((k.bodyDirection % 8) * 45));
            var _local_3:Float = ((k.bodyDirection % 8) * 45);
            this._roomCreator.updateObjectUserDir(this._currentRoomId, k.userIndex, _local_2, _local_3);
        }

        function setUserMovePosture(k:Int, _arg_2:String)
        {
            var _local_4:IRoomObject = null;
            var _local_5:String = null;
            var _local_6:IRoomObjectModel = null;
            var _local_7:String = null;
            var _local_3= this._roomCreator.getRoom(this._currentRoomId);
            if (_local_3 != null)
            {
                _local_4 = _local_3.getObject(k, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER);
            }
            if (((!(_local_4 == null)) && (!(_local_4.getType() == RoomObjectUserTypes.MONSTERPLANT))))
            {
                _local_6 = _local_4.getModel();
                switch (_arg_2)
                {
                    case "mv":
                        _local_5 = "mv";
                        
                    case "sld":
                        _local_7 = _local_6.getString(RoomObjectVariableEnum.FIGURE_POSTURE);
                        _local_5 = ((_local_7 == "mv") ? "std" : _local_7);
                }
                this._roomCreator.updateObjectUserPosture(this._currentRoomId, k, _local_5);
            }
        }

        function onSlideUpdate(k:IMessageEvent)
        {
            var _local_2:SlideObjectBundleMessageParser = null;
            var _local_3:Array<ASAny> = null;
            var _local_4 = 0;
            var _local_5:SlideObjectMessageData = null;
            var _local_6:SlideObjectMessageData = null;
            var _local_7:IRoomObject = null;
            var _local_8:String = null;
            var _local_9:IRoomInstance = null;
            if (this._roomCreator == null)
            {
                return;
            }
            if (Std.is(k , SlideObjectBundleMessageEvent))
            {
                _local_2 = Std.downcast(k , SlideObjectBundleMessageEvent).getParser();
                this._roomCreator.updateObjectFurniture(this._currentRoomId, _local_2.id, null, null, 1, null);
                this._roomCreator.updateObjectFurniture(this._currentRoomId, _local_2.id, null, null, 2, null);
                _local_3 = _local_2.objectList;
                _local_4 = 0;
                while (_local_4 < _local_3.length)
                {
                    _local_5 = _local_3[_local_4];
                    if (_local_5 != null)
                    {
                        this._roomCreator.updateObjectFurnitureLocation(this._currentRoomId, _local_5.id, _local_5.loc, null, _local_5.target);
                    }
                    _local_4++;
                }
                if (_local_2.avatar != null)
                {
                    _local_6 = _local_2.avatar;
                    this._roomCreator.updateObjectUser(this._currentRoomId, _local_6.id, _local_6.loc, _local_6.target);
                    if (this._roomCreator != null)
                    {
                        _local_9 = this._roomCreator.getRoom(this._currentRoomId);
                        if (_local_9 != null)
                        {
                            _local_7 = _local_9.getObject(_local_6.id, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER);
                        }
                    }
                    if (((!(_local_7 == null)) && (!(_local_7.getType() == RoomObjectUserTypes.MONSTERPLANT))))
                    {
                        switch (_local_6._Str_21300)
                        {
                            case SlideObjectMessageData.MV:
                                _local_8 = "mv";
                                
                            case SlideObjectMessageData.SLD:
                                _local_8 = "std";
                                
                        }
                        this._roomCreator.updateObjectUserPosture(this._currentRoomId, _local_6.id, _local_8);
                    }
                }
            }
        }

        function onChat(k:IMessageEvent)
        {
            var _local_2:ChatMessageParser = null;
            if (this._roomCreator == null)
            {
                return;
            }
            var _local_3= this._roomCreator.roomSessionManager.getSession(this._currentRoomId);
            if (Std.is(k , ChatMessageEvent))
            {
                _local_2 = Std.downcast(k , ChatMessageEvent).getParser();
            }
            else
            {
                if (Std.is(k , WhisperMessageEvent))
                {
                    _local_2 = Std.downcast(k , WhisperMessageEvent).getParser();
                    if ((((_local_2 != null) && (_local_3 != null)) && (_local_2.userId == _local_3.ownUserRoomId)))
                    {
                        return;
                    }
                }
                else
                {
                    if (Std.is(k , ShoutMessageEvent))
                    {
                        _local_2 = Std.downcast(k , ShoutMessageEvent).getParser();
                    }
                }
            }
            if (_local_2 == null)
            {
                return;
            }
            this._roomCreator.updateObjectUserGesture(this._currentRoomId, _local_2.userId, _local_2.gesture);
            this._roomCreator.updateObjectUserAction(this._currentRoomId, _local_2.userId, RoomObjectVariableEnum.FIGURE_TALK, Std.int(Math.fceil((_local_2.text.length / 10))));
        }

        function onTypingStatus(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , UserTypingMessageEvent);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= _local_2.getParser();
            var _local_4= 1;
            if (!_local_3.isTyping)
            {
                _local_4 = 0;
            }
            this._roomCreator.updateObjectUserAction(this._currentRoomId, _local_3.userId, RoomObjectVariableEnum.FIGURE_IS_TYPING, _local_4);
        }

        function onPetExperience(k:PetExperienceEvent)
        {
            if (k == null)
            {
                return;
            }
            var _local_2= k.getParser();
            this._roomCreator.updateObjectUserAction(this._currentRoomId, _local_2.petRoomIndex, RoomObjectVariableEnum.FIGURE_GAINED_EXPERIENCE, _local_2._Str_18578);
        }

        function onDiceValue(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , DiceValueMessageEvent);
            if (((_local_2 == null) || (_local_2.getParser() == null)))
            {
                return;
            }
            if (this._roomCreator == null)
            {
                return;
            }
            var _local_3= _local_2.getParser();
            var _local_4= _local_3.id;
            var _local_5= _local_3.value;
            var _local_6:IStuffData = new LegacyStuffData();
            this._roomCreator.updateObjectFurniture(this._currentRoomId, _local_4, null, null, _local_5, _local_6);
        }

        function onOneWayDoorStatus(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , OneWayDoorStatusMessageEvent);
            if (((_local_2 == null) || (_local_2.getParser() == null)))
            {
                return;
            }
            if (this._roomCreator == null)
            {
                return;
            }
            var _local_3= _local_2.getParser();
            var _local_4= _local_3.id;
            var _local_5= _local_3.status;
            var _local_6:IStuffData = new LegacyStuffData();
            this._roomCreator.updateObjectFurniture(this._currentRoomId, _local_4, null, null, _local_5, _local_6);
        }

        function onPlayingGame(k:YouArePlayingGameMessageEvent)
        {
            if (k == null)
            {
                return;
            }
            var _local_2= k.getParser();
            var _local_3= _local_2.isPlaying;
            this._roomCreator.setIsPlayingGame(this._currentRoomId, _local_3);
        }

        function onGamePlayerNumberValue(k:IMessageEvent)
        {
            var _local_2:GamePlayerValueMessageParser = null;
            var _local_3 = 0;
            if (this._roomCreator == null)
            {
                return;
            }
            if (Std.is(k , GamePlayerValueMessageEvent))
            {
                _local_2 = Std.downcast(k , GamePlayerValueMessageEvent).getParser();
                _local_3 = this.getRoomId(0);
                this._roomCreator.updateObjectUserAction(_local_3, _local_2.userId, RoomObjectVariableEnum.FIGURE_NUMBER_VALUE, _local_2.value);
            }
        }

        function onIgnoreResult(k:IMessageEvent)
        {
            if (!this._roomCreator.configuration.getBoolean("avatar.ignored.bubble.enabled"))
            {
                return;
            }
            var _local_2= Std.downcast(k , IgnoreResultMessageEvent);
            var _local_3= this._roomCreator.roomSessionManager.getSession(this._currentRoomId).userDataManager.getUserDataByName(_local_2.name);
            if (_local_3 != null)
            {
                switch (_local_2.result)
                {
                    case 1
                       | 2:
                        this._roomCreator.updateObjectUserAction(this._currentRoomId, _local_3.roomObjectId, RoomObjectVariableEnum.FIGURE_IS_MUTED, 1);
                        return;
                    case 3:
                        this._roomCreator.updateObjectUserAction(this._currentRoomId, _local_3.roomObjectId, RoomObjectVariableEnum.FIGURE_IS_MUTED, 0);
                        return;
                }
            }
        }

        function onGuideSessionStarted(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k.parser , GuideSessionStartedMessageParser);
            this._guideId = _local_2.guideUserId;
            this._requesterId = _local_2.requesterUserId;
            this.updateGuideMarker();
        }

        function onGuideSessionEnded(k:IMessageEvent)
        {
            this.removeGuideMarker();
        }

        function onGuideSessionError(k:IMessageEvent)
        {
            this.removeGuideMarker();
        }

        function updateGuideMarker()
        {
            var k= this._roomCreator.sessionDataManager.userId;
            this.setUserGuideStatus(this._guideId, ((this._requesterId == k) ? AvatarGuideStatus.GUIDE : AvatarGuideStatus.NONE));
            this.setUserGuideStatus(this._requesterId, ((this._guideId == k) ? AvatarGuideStatus.REQUESTER : AvatarGuideStatus.NONE));
        }

        function removeGuideMarker()
        {
            this.setUserGuideStatus(this._guideId, AvatarGuideStatus.NONE);
            this.setUserGuideStatus(this._requesterId, AvatarGuideStatus.NONE);
            this._guideId = -1;
            this._requesterId = -1;
        }

        function setUserGuideStatus(k:Int, _arg_2:Int)
        {
            if (((!(this._roomCreator != null)) || (!(this._roomCreator.roomSessionManager != null))))
            {
                return;
            }
            var _local_3= this._roomCreator.roomSessionManager.getSession(this._currentRoomId);
            if (_local_3 == null)
            {
                return;
            }
            var _local_4= _local_3.userDataManager.getUserDataByType(k, RoomObjectTypeEnum.HABBO);
            if (_local_4 != null)
            {
                this._roomCreator.updateObjectUserAction(this._currentRoomId, _local_4.roomObjectId, RoomObjectVariableEnum.FIGURE_GUIDE_STATUS, _arg_2);
            }
        }
    }

