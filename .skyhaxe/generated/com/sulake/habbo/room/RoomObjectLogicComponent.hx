package com.sulake.habbo.room
;
    import com.sulake.core.runtime.Component;
    import com.sulake.room.IRoomObjectFactory;
    import com.sulake.core.utils.Map;
    import com.sulake.core.runtime.IContext;
    import com.sulake.room.object.logic.IRoomObjectEventHandler;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureLogic;
    import com.sulake.habbo.room.object.RoomObjectLogicEnum;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureMultistateLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureMultiheightLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurniturePlaceholderLogic;
    import com.sulake.habbo.room.object.logic.AvatarLogic;
    import com.sulake.habbo.room.object.logic.PetLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureRandomstateLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureCreditLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureStickieLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureExternalImageLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurniturePresentLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureTrophyLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureFurniChestLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureCoinsChestLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureEcotronBoxLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureDiceLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureHockeyScoreLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureHabbowheelLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureOneWayDoorLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurniturePlanetSystemLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureWindowLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureRoomDimmerLogic;
    import com.sulake.habbo.room.object.logic.room.TileCursorLogic;
    import com.sulake.habbo.room.object.logic.room.SelectionArrowLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureSoundMachineLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureJukeboxLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureCrackableLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureSongDiskLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurniturePushableLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureClothingChangeLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureCounterClockLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureScoreLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureIceStormLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureFireworksLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureRoomBillboardLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureRoomBackgroundLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureWelcomeGiftLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureFloorHoleLogic;
    import com.sulake.habbo.room.object.logic.room.RoomLogic;
    import com.sulake.habbo.room.object.logic.room.publicroom.PublicRoomParkLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureMannequinLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureGuildCustomizedLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureGroupForumTerminalLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurniturePetCustomizationLogic;
    import com.sulake.habbo.room.object.logic.game.GameSnowballLogic;
    import com.sulake.habbo.room.object.logic.game.GameSnowsplashLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureCuckooClockLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureVoteCounterLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureVoteMajorityLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureSoundBlockLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureRandomTeleportLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureMonsterplantSeedLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurniturePurchasableClothingLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureRoomBackgroundColorLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureAreaHideLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureMysterboxLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureEffectboxLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureMysterytrophyLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureAchievementResolutionLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureLovelockLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureWildwestWantedLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureHweenLovelockLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureBadgeDisplayLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureHighScoreLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureInternalLinkLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureEditableInternalLinkLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureEditableRoomLinkLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureCustomStackHeightLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureYoutubeLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureRentableSpaceLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureChangeStateWhenStepOnLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureVimeoLogic;
    import com.sulake.habbo.room.object.logic.furniture.FurnitureCraftingGizmoLogic;
    import com.sulake.room.RoomObjectManager;
    import com.sulake.room.IRoomObjectManager;

     class RoomObjectLogicComponent extends Component implements IRoomObjectFactory 
    {
        var cachedEvents:Map;
        var registeredEvents:Map;
        var functions:Array<ASAny>;

        public function new(k:IContext, _arg_2:UInt=0)
        {
            this.cachedEvents = new Map();
            this.registeredEvents = new Map();
            this.functions = [];
            super(k, _arg_2);
        }

        public function addObjectEventListener(k:ASFunction)
        {
            var _local_2:String = null;
            if (this.functions.indexOf(k) < 0)
            {
                this.functions.push(k);
                if (k != null)
                {
                    final _iter_ = this.registeredEvents.getKeys(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                    {
_local_2  = _tmp_;
                        events.addEventListener(_local_2, k);
                    }
                }
            }
        }

        public function removeObjectEventListener(k:ASFunction)
        {
            var _local_2:String = null;
            var _local_3= this.functions.indexOf(k);
            if (_local_3 >= 0)
            {
                this.functions.splice(_local_3, 1);
                if (k != null)
                {
                    final _iter_ = this.registeredEvents.getKeys(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                    {
_local_2  = _tmp_;
                        events.removeEventListener(_local_2, k);
                    }
                }
            }
        }

        function registerEventType(eventType:String)
        {
var func:ASFunction  = null;            if (this.registeredEvents.getValue(eventType) == null)
            {
                this.registeredEvents.add(eventType, true);
                final _iter_ = this.functions; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
func = _tmp_;
                    if (func != null)
                    {
                        events.addEventListener(eventType, func);
                    }
                }
            }
        }

        public function createRoomObjectLogic(logicKey:String):IRoomObjectEventHandler
        {
var eventType:String  = null;            var roomObjectLogic:IRoomObjectEventHandler = null;
            var classDefinition:Class<Dynamic> = null;
            switch (logicKey)
            {
                case RoomObjectLogicEnum.FURNITURE_BASIC:
                    classDefinition = FurnitureLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_MULTISTATE:
                    classDefinition = FurnitureMultistateLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_MULTIHEIGHT:
                    classDefinition = FurnitureMultiheightLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_PLACEHOLDER:
                    classDefinition = FurniturePlaceholderLogic;
                    
                case RoomObjectLogicEnum.USER
                   | RoomObjectLogicEnum.BOT
                   | RoomObjectLogicEnum.RENTABLE_BOT:
                    classDefinition = AvatarLogic;
                    
                case RoomObjectLogicEnum.PET:
                    classDefinition = PetLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_RANDOMSTATE:
                    classDefinition = FurnitureRandomstateLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_CREDIT:
                    classDefinition = FurnitureCreditLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_STICKIE:
                    classDefinition = FurnitureStickieLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_EXTERNAL_IMAGE_WALLITEM:
                    classDefinition = FurnitureExternalImageLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_PRESENT:
                    classDefinition = FurniturePresentLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_TROPHY:
                    classDefinition = FurnitureTrophyLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_FURNI_CHEST:
                    classDefinition = FurnitureFurniChestLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_COINS_CHEST:
                    classDefinition = FurnitureCoinsChestLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_ECOTRON_BOX:
                    classDefinition = FurnitureEcotronBoxLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_DICE:
                    classDefinition = FurnitureDiceLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_HOCKEY_SCORE:
                    classDefinition = FurnitureHockeyScoreLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_HABBOWHEEL:
                    classDefinition = FurnitureHabbowheelLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_ONE_WAY_DOOR:
                    classDefinition = FurnitureOneWayDoorLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_PLANET_SYSTEM:
                    classDefinition = FurniturePlanetSystemLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_WINDOW:
                    classDefinition = FurnitureWindowLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_ROOMDIMMER:
                    classDefinition = FurnitureRoomDimmerLogic;
                    
                case RoomObjectLogicEnum.TILE_CURSOR:
                    classDefinition = TileCursorLogic;
                    
                case RoomObjectLogicEnum.SELECTION_ARROW:
                    classDefinition = SelectionArrowLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_SOUND_MACHINE:
                    classDefinition = FurnitureSoundMachineLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_JUKEBOX:
                    classDefinition = FurnitureJukeboxLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_CRACKABLE:
                    classDefinition = FurnitureCrackableLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_SONG_DISK:
                    classDefinition = FurnitureSongDiskLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_PUSHABLE:
                    classDefinition = FurniturePushableLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_CLOTHING_CHANGE:
                    classDefinition = FurnitureClothingChangeLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_COUNTER_CLOCK:
                    classDefinition = FurnitureCounterClockLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_SCORE:
                    classDefinition = FurnitureScoreLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_ES:
                    classDefinition = FurnitureIceStormLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_FIREWORKS:
                    classDefinition = FurnitureFireworksLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_BB:
                    classDefinition = FurnitureRoomBillboardLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_BG:
                    classDefinition = FurnitureRoomBackgroundLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_WELCOME_GIFT:
                    classDefinition = FurnitureWelcomeGiftLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_FLOOR_HOLE:
                    classDefinition = FurnitureFloorHoleLogic;
                    
                case RoomObjectLogicEnum.ROOM
                   | RoomObjectLogicEnum.PUBLIC_ROOM:
                    classDefinition = RoomLogic;
                    
                case RoomObjectLogicEnum.PUBLIC_ROOM_PARK:
                    classDefinition = PublicRoomParkLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_MANNEQUIN:
                    classDefinition = FurnitureMannequinLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_GUILD_CUSTOMIZED:
                    classDefinition = FurnitureGuildCustomizedLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_GROUP_FORUM_TERMINAL:
                    classDefinition = FurnitureGroupForumTerminalLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_PET_CUSTOMIZATION:
                    classDefinition = FurniturePetCustomizationLogic;
                    
                case RoomObjectLogicEnum.GAME_SNOWBALL
                   | RoomObjectLogicEnum.GAME_SHOCKWAVE_SNOWBALL:
                    classDefinition = GameSnowballLogic;
                    
                case RoomObjectLogicEnum.GAME_SNOWSPLASH
                   | RoomObjectLogicEnum.GAME_SHOCKWAVE_SNOWSPLASH:
                    classDefinition = GameSnowsplashLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_CUCKOO_CLOCK:
                    classDefinition = FurnitureCuckooClockLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_VOTE_COUNTER:
                    classDefinition = FurnitureVoteCounterLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_VOTE_MAJORITY:
                    classDefinition = FurnitureVoteMajorityLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_SOUNDBLOCK:
                    classDefinition = FurnitureSoundBlockLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_RANDOM_TELEPORT:
                    classDefinition = FurnitureRandomTeleportLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_MONSTERPLANT_SEED:
                    classDefinition = FurnitureMonsterplantSeedLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_PURCHASABLE_CLOTHING:
                    classDefinition = FurniturePurchasableClothingLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_BACKGROUND_COLOR:
                    classDefinition = FurnitureRoomBackgroundColorLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_AREA_HIDE:
                    classDefinition = FurnitureAreaHideLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_MYSTERYBOX:
                    classDefinition = FurnitureMysterboxLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_EFFECTBOX:
                    classDefinition = FurnitureEffectboxLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_MYSTERYTROPHY:
                    classDefinition = FurnitureMysterytrophyLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_ACHIEVEMENT_RESOLUTION:
                    classDefinition = FurnitureAchievementResolutionLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_LOVELOCK:
                    classDefinition = FurnitureLovelockLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_WILDWEST_WANTED:
                    classDefinition = FurnitureWildwestWantedLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_HWEEN_LOVELOCK:
                    classDefinition = FurnitureHweenLovelockLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_BADGE_DISPLAY:
                    classDefinition = FurnitureBadgeDisplayLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_HIGH_SCORE:
                    classDefinition = FurnitureHighScoreLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_INTERNAL_LINK:
                    classDefinition = FurnitureInternalLinkLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_EDITABLE_INTERNAL_LINK:
                    classDefinition = FurnitureEditableInternalLinkLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_EDITABLE_ROOM_LINK:
                    classDefinition = FurnitureEditableRoomLinkLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_CUSTOM_STACK_HEIGHT:
                    classDefinition = FurnitureCustomStackHeightLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_YOUTUBE:
                    classDefinition = FurnitureYoutubeLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_RENTABLE_SPACE:
                    classDefinition = FurnitureRentableSpaceLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_CHANGE_STATE_WHEN_STEP_ON:
                    classDefinition = FurnitureChangeStateWhenStepOnLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_VIMEO:
                    classDefinition = FurnitureVimeoLogic;
                    
                case RoomObjectLogicEnum.FURNITURE_CRAFTING_GIZMO:
                    classDefinition = FurnitureCraftingGizmoLogic;
                    
            }
            if (classDefinition == null)
            {
                return null;
            }
            var logicInstance:ASObject = Type.createInstance(classDefinition, []);
            if (Std.is(logicInstance , IRoomObjectEventHandler))
            {
                roomObjectLogic = ASCompat.dynamicAs(logicInstance , IRoomObjectEventHandler);
                roomObjectLogic.eventDispatcher = this.events;
                if (this.cachedEvents.getValue(logicKey) == null)
                {
                    this.cachedEvents.add(logicKey, true);
                    final _iter_ = roomObjectLogic.getEventTypes(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                    {
eventType = _tmp_;
                        this.registerEventType(eventType);
                    }
                }
                return roomObjectLogic;
            }
            return null;
        }

        public function createRoomObjectManager():IRoomObjectManager
        {
            return new RoomObjectManager();
        }
    }

