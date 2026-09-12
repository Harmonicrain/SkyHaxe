package com.sulake.habbo.room.object
;
    import com.sulake.core.runtime.Component;
    import com.sulake.room.object.IRoomObjectVisualizationFactory;
    import com.sulake.habbo.avatar.IAvatarRenderManager;
    import com.sulake.core.utils.Map;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.runtime.ComponentDependency;
    import com.sulake.iid.IIDAvatarRenderManager;
    import com.sulake.room.object.visualization.IRoomObjectVisualizationData;
    import com.sulake.habbo.room.object.visualization.room.RoomVisualization;
    import com.sulake.habbo.room.object.visualization.room.publicroom.PublicRoomVisualization;
    import com.sulake.habbo.room.object.visualization.room.publicroom.PublicRoomParkVisualization;
    import com.sulake.habbo.room.object.visualization.room.publicroom.PublicRoomVisualizationData;
    import com.sulake.habbo.room.object.visualization.room.TileCursorVisualization;
    import com.sulake.habbo.room.object.visualization.avatar.AvatarVisualization;
    import com.sulake.habbo.room.object.visualization.pet.AnimatedPetVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureAnimatedVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureResettingAnimatedVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurniturePosterVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureHabbowheelVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureValRandomizerVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureBottleVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureFurniChestVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureCoinsChestVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurniturePlanetSystemVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureQueueTileVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurniturePartyBeamerVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureCuboidVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureGiftWrappedVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureCounterClockVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureWaterAreaVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureScoreBoardVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureFireworksVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FUrnitureGiftWrappedFireworksVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureBBVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureRoomBackgroundVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureStickieVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureMannequinVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureGuildCustomizedVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureGuildIsometricBadgeVisualization;
    import com.sulake.habbo.room.object.visualization.game.GameSnowballVisualization;
    import com.sulake.habbo.room.object.visualization.game.ShockwaveSnowballVisualization;
    import com.sulake.habbo.room.object.visualization.game.ShockwaveSnowSplashVisualization;
    import com.sulake.habbo.room.object.visualization.game.GameSnowSplashVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureVoteCounterVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureVoteMajorityVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureSoundblockVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureBadgeDisplayVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureYoutubeVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureExternalImageVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureBuilderPlaceholderVisualization;
    import com.sulake.room.object.visualization.IRoomObjectGraphicVisualization;
    import com.sulake.habbo.room.object.visualization.avatar.AvatarVisualizationData;
    import com.sulake.habbo.room.object.visualization.pet.AnimatedPetVisualizationData;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureMannequinVisualizationData;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureVisualizationData;
    import com.sulake.habbo.room.object.visualization.furniture.AnimatedFurnitureVisualizationData;
    import com.sulake.habbo.room.object.visualization.room.RoomVisualizationData;
    import com.sulake.habbo.room.object.visualization.furniture.GameObjectVisualization;
    import com.sulake.room.object.visualization.utils.GraphicAssetCollection;
    import com.sulake.room.object.visualization.utils.IGraphicAssetCollection;

     class RoomObjectVisualizationFactory extends Component implements IRoomObjectVisualizationFactory 
    {
        var _habboAvatar:IAvatarRenderManager = null;
        var _visualizationDatas:Map;
        var _enableCaching:Bool = true;

        public function new(k:IContext, _arg_2:UInt=0, _arg_3:IAssetLibrary=null)
        {
            super(k, _arg_2, _arg_3);
            this._enableCaching = (_arg_2 == 0);
            this._visualizationDatas = new Map();
        }

        override function  get_dependencies():Vector<ComponentDependency>
        {
            return super.dependencies.concat(Vector.ofArray([new ComponentDependency(new IIDAvatarRenderManager(), function (k:IAvatarRenderManager)
            {
                _habboAvatar = k;
            }, false)]));
        }

        override public function dispose()
        {
            var k:IRoomObjectVisualizationData = null;
            var _local_2 = 0;
            if (disposed)
            {
                return;
            }
            if (this._visualizationDatas != null)
            {
                k = null;
                _local_2 = 0;
                while ((_local_2 : UInt) < this._visualizationDatas.length)
                {
                    k = ASCompat.dynamicAs(this._visualizationDatas.getWithIndex(_local_2) , IRoomObjectVisualizationData);
                    if (k != null)
                    {
                        k.dispose();
                    }
                    _local_2++;
                }
                this._visualizationDatas.dispose();
                this._visualizationDatas = null;
            }
            super.dispose();
        }

        public function createRoomObjectVisualization(k:String):IRoomObjectGraphicVisualization
        {
            var _local_2:Class<Dynamic> = null;
            switch (k)
            {
                case RoomObjectVisualizationType.ROOM:
                    _local_2 = RoomVisualization;
                    
                case RoomObjectVisualizationType.PUBLIC_ROOM:
                    _local_2 = PublicRoomVisualization;
                    
                case RoomObjectVisualizationType.PUBLIC_ROOM_PARK:
                    _local_2 = PublicRoomParkVisualization;
                    
                case RoomObjectVisualizationType.TILE_CURSOR:
                    _local_2 = TileCursorVisualization;
                    
                case RoomObjectVisualizationType.USER:
                    _local_2 = AvatarVisualization;
                    
                case RoomObjectVisualizationType.BOT
                   | RoomObjectVisualizationType.RENTABLE_BOT:
                    _local_2 = AvatarVisualization;
                    
                case RoomObjectVisualizationType.PET_ANIMATED:
                    _local_2 = AnimatedPetVisualization;
                    
                case RoomObjectVisualizationType.FURNITURE_STATIC:
                    _local_2 = FurnitureVisualization;
                    
                case RoomObjectVisualizationType.FURNITURE_ANIMATED:
                    _local_2 = FurnitureAnimatedVisualization;
                    
                case RoomObjectVisualizationType.FURNITURE_RESETTING_ANIMATED:
                    _local_2 = FurnitureResettingAnimatedVisualization;
                    
                case RoomObjectVisualizationType.FURNITURE_POSTER:
                    _local_2 = FurniturePosterVisualization;
                    
                case RoomObjectVisualizationType.FURNITURE_HABBOWHEEL:
                    _local_2 = FurnitureHabbowheelVisualization;
                    
                case RoomObjectVisualizationType.FURNITURE_VAL_RANDOMIZER:
                    _local_2 = FurnitureValRandomizerVisualization;
                    
                case RoomObjectVisualizationType.FURNITURE_BOTTLE:
                    _local_2 = FurnitureBottleVisualization;
                    
                case RoomObjectVisualizationType.FURNITURE_FURNI_CHEST:
                    _local_2 = FurnitureFurniChestVisualization;
                    
                case RoomObjectVisualizationType.FURNITURE_COINS_CHEST:
                    _local_2 = FurnitureCoinsChestVisualization;
                    
                case RoomObjectVisualizationType.FURNITURE_PLANET_SYSTEM:
                    _local_2 = FurniturePlanetSystemVisualization;
                    
                case RoomObjectVisualizationType.FURNITURE_QUEUE_TILE:
                    _local_2 = FurnitureQueueTileVisualization;
                    
                case RoomObjectVisualizationType.FURNITURE_PARTY_BEAMER:
                    _local_2 = FurniturePartyBeamerVisualization;
                    
                case RoomObjectVisualizationType.FURNITURE_CUBOID:
                    _local_2 = FurnitureCuboidVisualization;
                    
                case RoomObjectVisualizationType.FURNITURE_GIFT_WRAPPED:
                    _local_2 = FurnitureGiftWrappedVisualization;
                    
                case RoomObjectVisualizationType.FURNITURE_COUNTER_CLOCK:
                    _local_2 = FurnitureCounterClockVisualization;
                    
                case RoomObjectVisualizationType.FURNITURE_WATER_AREA:
                    _local_2 = FurnitureWaterAreaVisualization;
                    
                case RoomObjectVisualizationType.FURNITURE_SCORE_BOARD:
                    _local_2 = FurnitureScoreBoardVisualization;
                    
                case RoomObjectVisualizationType.FURNITURE_FIREWORKS:
                    _local_2 = FurnitureFireworksVisualization;
                    
                case RoomObjectVisualizationType.FURNITURE_GIFT_WRAPPED_FIREWORKS:
                    _local_2 = FUrnitureGiftWrappedFireworksVisualization;
                    
                case RoomObjectVisualizationType.FURNITURE_BB:
                    _local_2 = FurnitureBBVisualization;
                    
                case RoomObjectVisualizationType.FURNITURE_BG:
                    _local_2 = FurnitureRoomBackgroundVisualization;
                    
                case RoomObjectVisualizationType.FURNITURE_STICKIE:
                    _local_2 = FurnitureStickieVisualization;
                    
                case RoomObjectVisualizationType.FURNITURE_MANNEQUIN:
                    _local_2 = FurnitureMannequinVisualization;
                    
                case RoomObjectVisualizationType.FURNITURE_GUILD_CUSTOMIZED:
                    _local_2 = FurnitureGuildCustomizedVisualization;
                    
                case RoomObjectVisualizationType.FURNITURE_GUILD_ISOMETRIC_BADGE:
                    _local_2 = FurnitureGuildIsometricBadgeVisualization;
                    
                case RoomObjectVisualizationType.GAME_SNOWBALL:
                    _local_2 = GameSnowballVisualization;
                    
                case RoomObjectVisualizationType.GAME_SHOCKWAVE_SNOWBALL:
                    _local_2 = ShockwaveSnowballVisualization;
                    
                case RoomObjectVisualizationType.GAME_SNOWSPLASH:
                    _local_2 = GameSnowSplashVisualization;
                    
                case RoomObjectVisualizationType.GAME_SHOCKWAVE_SNOWSPLASH:
                    _local_2 = ShockwaveSnowSplashVisualization;
                    
                case RoomObjectVisualizationType.FURNITURE_VOTE_COUNTER:
                    _local_2 = FurnitureVoteCounterVisualization;
                    
                case RoomObjectVisualizationType.FURNITURE_VOTE_MAJORITY:
                    _local_2 = FurnitureVoteMajorityVisualization;
                    
                case RoomObjectVisualizationType.FURNITURE_SOUNDBLOCK:
                    _local_2 = FurnitureSoundblockVisualization;
                    
                case RoomObjectVisualizationType.FURNITURE_BADGE_DISPLAY:
                    _local_2 = FurnitureBadgeDisplayVisualization;
                    
                case RoomObjectVisualizationType.FURNITURE_YOUTUBE:
                    _local_2 = FurnitureYoutubeVisualization;
                    
                case RoomObjectVisualizationType.FURNITURE_EXTERNAL_IMAGE:
                    _local_2 = FurnitureExternalImageVisualization;
                    
                case RoomObjectVisualizationType.FURNITURE_BUILDER_PLACEHOLDER:
                    _local_2 = FurnitureBuilderPlaceholderVisualization;
                    
            }
            if (_local_2 == null)
            {
                return null;
            }
            var _local_3:ASObject = Type.createInstance(_local_2, []);
            if (Std.is(_local_3 , IRoomObjectGraphicVisualization))
            {
                return ASCompat.dynamicAs(_local_3 , IRoomObjectGraphicVisualization);
            }
            return null;
        }

        public function getRoomObjectVisualizationData(k:String, _arg_2:String, _arg_3:com.sulake.core.utils.xml.XML):IRoomObjectVisualizationData
        {
            var _local_6:IRoomObjectVisualizationData = null;
            var _local_7:AvatarVisualizationData = null;
            var _local_8:AnimatedPetVisualizationData = null;
            var _local_9:FurnitureMannequinVisualizationData = null;
            var _local_4:IRoomObjectVisualizationData = null;
            _local_4 = ASCompat.dynamicAs(this._visualizationDatas.getValue(k) , IRoomObjectVisualizationData);
            if (_local_4 != null)
            {
                return _local_4;
            }
            var _local_5:Class<Dynamic> = null;
            switch (_arg_2)
            {
                case RoomObjectVisualizationType.FURNITURE_STATIC
                   | RoomObjectVisualizationType.FURNITURE_GIFT_WRAPPED
                   | RoomObjectVisualizationType.FURNITURE_BB
                   | RoomObjectVisualizationType.FURNITURE_BG
                   | RoomObjectVisualizationType.FURNITURE_STICKIE
                   | RoomObjectVisualizationType.FURNITURE_BUILDER_PLACEHOLDER:
                    _local_5 = FurnitureVisualizationData;
                    
                case RoomObjectVisualizationType.FURNITURE_ANIMATED
                   | RoomObjectVisualizationType.FURNITURE_FURNI_CHEST
                   | RoomObjectVisualizationType.FURNITURE_COINS_CHEST
                   | RoomObjectVisualizationType.FURNITURE_RESETTING_ANIMATED
                   | RoomObjectVisualizationType.FURNITURE_POSTER
                   | RoomObjectVisualizationType.FURNITURE_HABBOWHEEL
                   | RoomObjectVisualizationType.FURNITURE_VAL_RANDOMIZER
                   | RoomObjectVisualizationType.FURNITURE_BOTTLE
                   | RoomObjectVisualizationType.FURNITURE_PLANET_SYSTEM
                   | RoomObjectVisualizationType.FURNITURE_QUEUE_TILE
                   | RoomObjectVisualizationType.FURNITURE_PARTY_BEAMER
                   | RoomObjectVisualizationType.FURNITURE_COUNTER_CLOCK
                   | RoomObjectVisualizationType.FURNITURE_WATER_AREA
                   | RoomObjectVisualizationType.FURNITURE_SCORE_BOARD
                   | RoomObjectVisualizationType.FURNITURE_FIREWORKS
                   | RoomObjectVisualizationType.FURNITURE_GIFT_WRAPPED_FIREWORKS
                   | RoomObjectVisualizationType.FURNITURE_GUILD_CUSTOMIZED
                   | RoomObjectVisualizationType.FURNITURE_GUILD_ISOMETRIC_BADGE
                   | RoomObjectVisualizationType.FURNITURE_VOTE_COUNTER
                   | RoomObjectVisualizationType.FURNITURE_VOTE_MAJORITY
                   | RoomObjectVisualizationType.FURNITURE_SOUNDBLOCK
                   | RoomObjectVisualizationType.FURNITURE_BADGE_DISPLAY
                   | RoomObjectVisualizationType.FURNITURE_EXTERNAL_IMAGE
                   | RoomObjectVisualizationType.FURNITURE_YOUTUBE
                   | RoomObjectVisualizationType.TILE_CURSOR:
                    _local_5 = AnimatedFurnitureVisualizationData;
                    
                case RoomObjectVisualizationType.FURNITURE_MANNEQUIN:
                    _local_5 = FurnitureMannequinVisualizationData;
                    
                case RoomObjectVisualizationType.ROOM:
                    _local_5 = RoomVisualizationData;
                    
                case RoomObjectVisualizationType.PUBLIC_ROOM
                   | RoomObjectVisualizationType.PUBLIC_ROOM_PARK:
                    _local_5 = PublicRoomVisualizationData;
                    
                case RoomObjectVisualizationType.USER
                   | RoomObjectVisualizationType.BOT
                   | RoomObjectVisualizationType.RENTABLE_BOT:
                    _local_5 = AvatarVisualizationData;
                    
                case RoomObjectVisualizationType.PET_ANIMATED:
                    _local_5 = AnimatedPetVisualizationData;
                    
                case RoomObjectVisualizationType.GAME_SNOWBALL
                   | RoomObjectVisualizationType.GAME_SHOCKWAVE_SNOWBALL
                   | RoomObjectVisualizationType.GAME_SHOCKWAVE_SNOWSPLASH
                   | RoomObjectVisualizationType.GAME_SNOWSPLASH:
                    _local_5 = GameObjectVisualization;
                    
            }
            if (_local_5 == null)
            {
                return null;
            }
            _local_4 = Type.createInstance(_local_5, []);
            if (_local_4 != null)
            {
                _local_6 = null;
                _local_6 = _local_4 ;
                if (!_local_6.initialize(_arg_3))
                {
                    _local_6.dispose();
                    return null;
                }
                if (Std.is(_local_6 , AvatarVisualizationData))
                {
                    _local_7 = Std.downcast(_local_4 , AvatarVisualizationData);
                    _local_7._Str_1458 = this._habboAvatar;
                }
                else
                {
                    if (Std.is(_local_6 , AnimatedPetVisualizationData))
                    {
                        _local_8 = Std.downcast(_local_4 , AnimatedPetVisualizationData);
                        _local_8._Str_14822 = assets;
                    }
                    else
                    {
                        if (Std.is(_local_6 , FurnitureMannequinVisualizationData))
                        {
                            _local_9 = Std.downcast(_local_4 , FurnitureMannequinVisualizationData);
                            _local_9._Str_1458 = this._habboAvatar;
                        }
                        else
                        {
                            if (Std.is(_local_6 , GameObjectVisualization))
                            {
                                cast(_local_6, GameObjectVisualization).assets = assets;
                            }
                        }
                    }
                }
                if (this._enableCaching)
                {
                    this._visualizationDatas.add(k, _local_6);
                }
                return _local_6;
            }
            return null;
        }

        public function createGraphicAssetCollection():IGraphicAssetCollection
        {
            return new GraphicAssetCollection();
        }
    }

