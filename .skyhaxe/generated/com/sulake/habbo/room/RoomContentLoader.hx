package com.sulake.habbo.room
;
    import com.sulake.room.IRoomContentLoader;
    import com.sulake.habbo.session.furniture.IFurniDataListener;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.utils.Map;
    import com.sulake.room.object.IRoomObjectVisualizationFactory;
    import flash.events.IEventDispatcher;
    import com.sulake.room.IRoomManager;
    import com.sulake.habbo.session.ISessionDataManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.runtime.IHabboConfigurationManager;
    import com.sulake.habbo.session.furniture.IFurnitureData;
    import com.sulake.core.assets.AssetLibrary;
    import com.sulake.room.object.visualization.utils.IGraphicAssetCollection;
    import com.sulake.habbo.utils.StringUtil;
    import flash.events.Event;
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;
    import com.sulake.habbo.room.object.RoomObjectUserTypes;
    import com.sulake.habbo.room.object.RoomObjectVisualizationType;
    import com.sulake.core.assets.AssetLibraryCollection;
    import com.sulake.room.events.RoomContentLoadedEvent;
    import com.sulake.core.assets.AssetLoaderStruct;
    import flash.net.URLRequest;
    import com.sulake.core.assets.loaders.AssetLoaderEvent;
    import com.sulake.core.utils.LibraryLoader;
    import com.sulake.core.utils.LibraryLoaderEvent;
    import com.sulake.core.Core;
    import com.sulake.core.assets.IAsset;
    import flash.display.BitmapData;
    import com.sulake.room.object.IRoomObjectController;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.habbo.utils.HabboWebTools;
    import com.sulake.habbo.room.utils.PublicRoomData;

     class RoomContentLoader implements IRoomContentLoader implements  IFurniDataListener implements  IDisposable 
    {
        public static inline final RCL_LOADER_READY= "RCL_LOADER_READY";
        static inline final RCL_PREFIX= "RoomContentLoader ";
        static inline final CONST_ZERO= 0;
        static inline final CONST_ONE= 1;
        static inline final CONST_TWO= 2;
        static inline final PLACE_HOLDER= "place_holder";
        static inline final WALL_PLACE_HOLDER= "wall_place_holder";
        static inline final PET_PLACE_HOLDER= "pet_place_holder";
        static final DEFAULT_PLACE_HOLDER:String = PLACE_HOLDER;//"place_holder"
        static inline final ROOM= "room";
        static inline final TILE_CURSOR= "tile_cursor";
        static inline final SELECTION_ARROW= "selection_arrow";
        static final PLACE_HOLDER_TYPES_GPU:Array<ASAny> = [PLACE_HOLDER, WALL_PLACE_HOLDER, PET_PLACE_HOLDER, ROOM, TILE_CURSOR, SELECTION_ARROW];
        static final _Str_20672:Array<ASAny> = [PLACE_HOLDER, WALL_PLACE_HOLDER, PET_PLACE_HOLDER, ROOM, SELECTION_ARROW];
        static inline final RCL_PUBLICROOM_PREFIX= "RCL_PUBLICROOM_";
        static final PUBLIC_ROOM_VISUALIZATIONS:Array<ASAny> = ["room_public", "room_public_park", "room_public_pool"];
        static inline final CONST_20000= 20000;
        static inline final CONST_30000= 30000;

        var _baseUrl:String;
        var _libraries:Map = null;
        var _events:Map = null;
        var _additionalObjectTypeLibraries:Map = null;
        var _assetCollections:Map = null;
        var _visualizationFactory:IRoomObjectVisualizationFactory = null;
        var _state:Int = 0;
        var _stateEvents:IEventDispatcher = null;
        var _isDisposed:Bool = false;
        var _dataInitialized:Bool = false;
        var _activeObjectTypes:Map = null;
        var _activeObjects:ASDictionary<ASAny,ASAny>;
        var _activeObjectTypeIds:Map = null;
        var _wallItemTypes:Map = null;
        var _wallItems:ASDictionary<ASAny,ASAny>;
        var _wallItemTypeIds:Map = null;
        var _petTypes:Map = null;
        var _pets:ASDictionary<ASAny,ASAny>;
        var _petColors:Map = null;
        var _petLayers:Map = null;
        var _furniRevisions:Map = null;
        var _objectAliases:Map = null;
        var _objectOriginalNames:Map = null;
        var _objectTypeAdURLs:Map = null;
        var _furniLoadUrlBase:String;
        var _furniLoadNameTemplate:String;
        var _iconLoadNameTemplate:String;
        var _assetUrlBase:String;
        var _petLoadNameTemplate:String;
        var _publicRoomLoadUrlBase:String;
        var _publicRoomLoadNameTemplate:String;
        var _waitingForSessionDataManager:Bool = false;
        var _lastAssetCompressionTime:UInt = 0;
        var _sessionDataManager:ISessionDataManager;
        var _iconAssets:IAssetLibrary;
        var _iconListener:IRoomContentListener;
        var _configuration:IHabboConfigurationManager;
        var _ignoredFurniTypes:Array<ASAny>;
        var _furniReloadToken:String = null;
        var _roomManager:IRoomManager;
        var _pendingFurnitureContentRefresh:Array<ASAny> = null;
        var _publicRooms:Map = null;
        var _currentPublicRoom:PublicRoomData = null;
        var _publicRoomPreloadTypes:Array<ASAny> = [];
        var _publicRoomAssetSourceAliases:Map = null;
        var _publicRoomObjectLibraries:Map = null;

        public function new(k:String)
        {
            this._activeObjects = new ASDictionary<ASAny,ASAny>();
            this._wallItems = new ASDictionary<ASAny,ASAny>();
            this._pets = new ASDictionary<ASAny,ASAny>();
            this._baseUrl = k;
            this._libraries = new Map();
            this._events = new Map();
            this._activeObjectTypes = new Map();
            this._activeObjectTypeIds = new Map();
            this._wallItemTypes = new Map();
            this._wallItemTypeIds = new Map();
            this._petTypes = new Map();
            this._objectTypeAdURLs = new Map();
            this._furniRevisions = new Map();
            this._objectAliases = new Map();
            this._objectOriginalNames = new Map();
            this._assetCollections = new Map();
            this._additionalObjectTypeLibraries = new Map();
            this._publicRooms = new Map();
            this._publicRoomAssetSourceAliases = new Map();
            this._publicRoomObjectLibraries = new Map();
        }

        public var sessionDataManager(never,set):ISessionDataManager;
public function  set_sessionDataManager(k:ISessionDataManager):ISessionDataManager        {
            this._sessionDataManager = k;
            if (this._waitingForSessionDataManager)
            {
                this._waitingForSessionDataManager = false;
                this.initFurnitureData();
            }
return k;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._isDisposed;
        }

        public var visualizationFactory(never,set):IRoomObjectVisualizationFactory;
public function  set_visualizationFactory(k:IRoomObjectVisualizationFactory):IRoomObjectVisualizationFactory        {
            return this._visualizationFactory = k;
        }

        public var roomManager(never,set):IRoomManager;
public function  set_roomManager(k:IRoomManager):IRoomManager        {
            return this._roomManager = k;
        }

        public function initialize(k:IEventDispatcher, _arg_2:IHabboConfigurationManager)
        {
            this._stateEvents = k;
            this._furniLoadUrlBase = _arg_2.getProperty("flash.dynamic.download.url");
            this._furniLoadNameTemplate = _arg_2.getProperty("flash.dynamic.download.name.template");
            this._iconLoadNameTemplate = _arg_2.getProperty("flash.dynamic.icon.download.name.template");
            this._assetUrlBase = _arg_2.getProperty("pet.dynamic.download.url");
            this._petLoadNameTemplate = _arg_2.getProperty("pet.dynamic.download.name.template");
            this._publicRoomLoadUrlBase = _arg_2.getProperty("public.room.dynamic.download.url");
            this._publicRoomLoadNameTemplate = _arg_2.getProperty("public.room.dynamic.download.name.template");
            if (((this._publicRoomLoadNameTemplate == null) || (this._publicRoomLoadNameTemplate == "")))
            {
                this._publicRoomLoadNameTemplate = "%typeid%.swf";
            }
            this.initPublicRoomPreloadTypes(_arg_2.getProperty("public.room.preload.types"));
            this._configuration = _arg_2;
            this._state = CONST_ONE;
            this.initFurnitureData();
            this._Str_24006(_arg_2);
        }

        function _Str_24006(k:IHabboConfigurationManager)
        {
            var _local_4:String = null;
            var _local_2:Array<ASAny> = (cast k.getProperty("pet.configuration").split(","));
            var _local_3 = 0;
            if (checkNullIteratee(_local_2)) for (_tmp_ in _local_2)
            {
_local_4  = _tmp_;
                this._pets[_local_4] = _local_3;
                this._petTypes.add(_local_3, _local_4);
                _local_3++;
            }
            this._petColors = new Map();
            this._petLayers = new Map();
        }

        function initFurnitureData()
        {
            if (this._sessionDataManager == null)
            {
                this._waitingForSessionDataManager = true;
                return;
            }
            var k= this._sessionDataManager.getFurniData(this);
            if (k == null)
            {
                return;
            }
            this._sessionDataManager.removeFurniDataListener(this);
            this.populateFurniData(k, 0, function ()
            {
                if (this._isDisposed)
                {
                    return;
                }
                this._dataInitialized = true;
                this._Str_23030();
                this.continueInitilization();
            });
        }

        public function dispose()
        {
var k:String  = null;            var k:String = null;
            var _local_2 = 0;
            var _local_3 = 0;
            var _local_4:AssetLibrary = null;
            var _local_5:IGraphicAssetCollection = null;
            if (this._libraries != null)
            {
                _local_2 = ASCompat.toInt(this._libraries.length);
                _local_3 = 0;
                while (_local_3 < _local_2)
                {
                    _local_4 = ASCompat.dynamicAs(this._libraries.getWithIndex(_local_3) , AssetLibrary);
                    if (_local_4 != null)
                    {
                        _local_4.dispose();
                    }
                    _local_3++;
                }
                this._libraries.dispose();
                this._libraries = null;
            }
            if (this._events != null)
            {
                this._events.dispose();
                this._events = null;
            }
            if (this._activeObjectTypes != null)
            {
                this._activeObjectTypes.dispose();
                this._activeObjectTypes = null;
            }
            if (this._activeObjectTypeIds != null)
            {
                this._activeObjectTypeIds.dispose();
                this._activeObjectTypeIds = null;
            }
            if (this._wallItemTypes != null)
            {
                this._wallItemTypes.dispose();
                this._wallItemTypes = null;
            }
            if (this._wallItemTypeIds != null)
            {
                this._wallItemTypeIds.dispose();
                this._wallItemTypeIds = null;
            }
            if (this._petTypes != null)
            {
                this._petTypes.dispose();
                this._petTypes = null;
            }
            if (this._petColors != null)
            {
                this._petColors.dispose();
                this._petColors = null;
            }
            if (this._petLayers != null)
            {
                this._petLayers.dispose();
                this._petLayers = null;
            }
            if (this._furniRevisions != null)
            {
                this._furniRevisions.dispose();
                this._furniRevisions = null;
            }
            if (this._objectAliases != null)
            {
                this._objectAliases.dispose();
                this._objectAliases = null;
            }
            if (this._objectOriginalNames != null)
            {
                this._objectOriginalNames.dispose();
                this._objectOriginalNames = null;
            }
            if (this._objectTypeAdURLs != null)
            {
                this._objectTypeAdURLs.dispose();
                this._objectTypeAdURLs = null;
            }
            if (this._assetCollections != null)
            {
                _local_2 = ASCompat.toInt(this._assetCollections.length);
                _local_3 = 0;
                while (_local_3 < _local_2)
                {
                    _local_5 = ASCompat.dynamicAs(this._assetCollections.getWithIndex(_local_3) , IGraphicAssetCollection);
                    if (_local_5 != null)
                    {
                        _local_5.dispose();
                    }
                    _local_3++;
                }
                this._assetCollections.dispose();
                this._assetCollections = null;
            }
            if (this._additionalObjectTypeLibraries != null)
            {
                this._additionalObjectTypeLibraries.dispose();
                this._additionalObjectTypeLibraries = null;
            }
            if (this._publicRooms != null)
            {
                this._publicRooms.dispose();
                this._publicRooms = null;
            }
            if (this._publicRoomAssetSourceAliases != null)
            {
                this._publicRoomAssetSourceAliases.dispose();
                this._publicRoomAssetSourceAliases = null;
            }
            if (this._publicRoomObjectLibraries != null)
            {
                this._publicRoomObjectLibraries.dispose();
                this._publicRoomObjectLibraries = null;
            }
            if (this._activeObjects != null)
            {
                final _iter_ = this._activeObjects; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
                {
k = _tmp_;
                    this._activeObjects.remove(k);
                }
                this._activeObjects = null;
            }
            if (this._wallItems != null)
            {
                final _iter_ = this._wallItems; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
                {
k = _tmp_;
                    this._wallItems.remove(k);
                }
                this._wallItems = null;
            }
            if (this._pets != null)
            {
                final _iter_ = this._pets; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
                {
k = _tmp_;
                    this._pets.remove(k);
                }
                this._pets = null;
            }
            this._stateEvents = null;
            this._sessionDataManager = null;
            this._configuration = null;
            this._isDisposed = true;
        }

        function _Str_23030()
        {
            var k= this._configuration.getProperty("gpu.ignored_furni");
            if (!ASCompat.stringAsBool(k))
            {
                return;
            }
            this._ignoredFurniTypes = (cast k.split(","));
            var _local_2= this._ignoredFurniTypes.length;
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._ignoredFurniTypes[_local_3] = StringUtil.trim(this._ignoredFurniTypes[_local_3]);
                _local_3++;
            }
        }

        function _Str_23570(k:String):Bool
        {
            return (this._ignoredFurniTypes != null) ? (!(this._ignoredFurniTypes.indexOf(k) == -1)) : false;
        }

        function populateFurniData(k:Vector<IFurnitureData>, start:Int, complete:ASFunction)
        {
            var _local_2:IFurnitureData = null;
            var _local_3 = 0;
            var _local_4:String = null;
            var _local_5 = 0;
            var _local_6:String = null;
            var _local_7:String = null;
            var _local_8 = 0;
            var index = start;
            var deadline = flash.Lib.getTimer() + 8;
            while ((index < k.length) && (flash.Lib.getTimer() < deadline))
            {
                _local_2 = k[index];
                _local_3 = _local_2.id;
                _local_4 = _local_2.className;
                if (_local_2.hasIndexedColor)
                {
                    _local_4 = ((_local_4 + "*") + Std.string(_local_2.colourIndex));
                }
                _local_5 = _local_2.revision;
                _local_6 = _local_2.adUrl;
                if (((!(_local_6 == null)) && (_local_6.length > 0)))
                {
                    this._objectTypeAdURLs.add(_local_4, _local_6);
                }
                _local_7 = _local_2.className;
                if (_local_2.type == "s")
                {
                    this._activeObjectTypes.add(_local_3, _local_4);
                    this._activeObjectTypeIds.add(_local_4, _local_3);
                    if (this._activeObjects[_local_7] == null)
                    {
                        this._activeObjects[_local_7] = 1;
                    }
                }
                else
                {
                    if (_local_2.type == "i")
                    {
                        if (_local_4 == "post.it")
                        {
                            _local_4 = "post_it";
                            _local_7 = "post_it";
                        }
                        if (_local_4 == "post.it.vd")
                        {
                            _local_4 = "post_it_vd";
                            _local_7 = "post_it_vd";
                        }
                        this._wallItemTypes.add(_local_3, _local_4);
                        this._wallItemTypeIds.add(_local_4, _local_3);
                        if (this._wallItems[_local_7] == null)
                        {
                            this._wallItems[_local_7] = 1;
                        }
                    }
                }
                _local_8 = ASCompat.toInt(this._furniRevisions.getValue(_local_7));
                if (_local_5 > _local_8)
                {
                    this._furniRevisions.remove(_local_7);
                    this._furniRevisions.add(_local_7, _local_5);
                }
                index++;
            }
            if (index < k.length)
            {
                var next = index;
                ASCompat.setTimeout(function ()
                {
                    if (!this._isDisposed)
                    {
                        this.populateFurniData(k, next, complete);
                    }
                }, 0);
                return;
            }
            if (complete != null)
            {
                complete();
            }
        }

        function continueInitilization()
        {
            if (this._dataInitialized)
            {
                this._state = CONST_TWO;
                if (this._stateEvents != null)
                {
                    this._stateEvents.dispatchEvent(new Event(RCL_LOADER_READY));
                }
            }
        }

        public function setRoomObjectAlias(k:String, _arg_2:String)
        {
            if (this._objectAliases != null)
            {
                this._objectAliases.remove(k);
                this._objectAliases.add(k, _arg_2);
            }
            if (this._objectOriginalNames != null)
            {
                this._objectOriginalNames.remove(_arg_2);
                this._objectOriginalNames.add(_arg_2, k);
            }
        }

        function getRoomObjectAlias(k:String):String
        {
            var _local_2:String = null;
            if (this._objectAliases != null)
            {
                _local_2 = ASCompat.asString(this._objectAliases.getValue(k) );
            }
            if (_local_2 == null)
            {
                _local_2 = k;
            }
            return _local_2;
        }

        function getRoomObjectOriginalName(k:String):String
        {
            var _local_2:String = null;
            if (this._objectOriginalNames != null)
            {
                _local_2 = ASCompat.asString(this._objectOriginalNames.getValue(k) );
            }
            if (_local_2 == null)
            {
                _local_2 = k;
            }
            return _local_2;
        }

        public function getObjectCategory(k:String):Int
        {
            var _local_2 = 0;
            var _local_3:PublicRoomData = null;
            if (k == null)
            {
                return RoomObjectCategoryEnum.OBJECT_CATEGORY_UNKNOWN;
            }
            if (this._activeObjects[k] != null)
            {
                return RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE;
            }
            if (this._wallItems[k] != null)
            {
                return RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM;
            }
            if (this._pets[k] != null)
            {
                return RoomObjectCategoryEnum.OBJECT_CATEGORY_USER;
            }
            if (k.indexOf("poster") == 0)
            {
                return RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM;
            }
            if (k == "room")
            {
                return RoomObjectCategoryEnum.OBJECT_CATEGORY_ROOM;
            }
            if (k == RoomObjectUserTypes.USER)
            {
                return RoomObjectCategoryEnum.OBJECT_CATEGORY_USER;
            }
            if (k == RoomObjectUserTypes.PET)
            {
                return RoomObjectCategoryEnum.OBJECT_CATEGORY_USER;
            }
            if (k == RoomObjectUserTypes.BOT)
            {
                return RoomObjectCategoryEnum.OBJECT_CATEGORY_USER;
            }
            if (k == RoomObjectUserTypes.RENTABLE_BOT)
            {
                return RoomObjectCategoryEnum.OBJECT_CATEGORY_USER;
            }
            if (((k == "tile_cursor") || (k == "selection_arrow")))
            {
                return RoomObjectCategoryEnum.OBJECT_CATEGORY_CURSOR;
            }
            if (((!(this._currentPublicRoom == null)) && ((this._currentPublicRoom.type == k) || this._currentPublicRoom.hasWorldType(k))))
            {
                return RoomObjectCategoryEnum.OBJECT_CATEGORY_ROOM;
            }
            if (this._publicRooms != null)
            {
                _local_2 = 0;
                while ((_local_2 : UInt) < this._publicRooms.length)
                {
                    _local_3 = ASCompat.dynamicAs(this._publicRooms.getWithIndex(_local_2) , PublicRoomData);
                    if (((!(_local_3 == null)) && ((_local_3.type == k) || _local_3.hasWorldType(k))))
                    {
                        return RoomObjectCategoryEnum.OBJECT_CATEGORY_ROOM;
                    }
                    _local_2++;
                }
            }
            return RoomObjectCategoryEnum.OBJECT_CATEGORY_UNKNOWN;
        }

        public function getPlaceHolderType(k:String):String
        {
            if (this._activeObjects[k] != null)
            {
                return PLACE_HOLDER;
            }
            if (this._wallItems[k] != null)
            {
                return WALL_PLACE_HOLDER;
            }
            if (this._pets[k] != null)
            {
                return PET_PLACE_HOLDER;
            }
            return DEFAULT_PLACE_HOLDER;
        }

        function initPublicRoomPreloadTypes(k:String)
        {
            var _local_3:String = null;
            var _local_4:String = null;
            this._publicRoomPreloadTypes = [];
            var _local_2= (((k == null) || (k == "")) ? "netcafe" : k);
            final _iter_ = _local_2.split(","); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                _local_4 = StringUtil.trim(_local_3);
                if (_local_4.length > 0)
                {
                    this._publicRoomPreloadTypes.push(("hh_room_" + _local_4));
                }
            }
        }

        public function getPlaceHolderTypes():Array<ASAny>
        {
            return PLACE_HOLDER_TYPES_GPU.concat(this._publicRoomPreloadTypes);
        }

        function isPreloadedPublicRoomAsset(k:String):Bool
        {
            var _local_2:String = null;
            if (k == null)
            {
                return false;
            }
            final _iter_ = this._publicRoomPreloadTypes; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (((k == _local_2) || (k.indexOf((_local_2 + "_")) == 0)))
                {
                    return true;
                }
            }
            return false;
        }

        public function getActiveObjectType(k:Int):String
        {
            var _local_2= ASCompat.asString(this._activeObjectTypes.getValue(k) );
            return this.getObjectType(_local_2);
        }

        public function getActiveObjectTypeId(k:String):Int
        {
            return ASCompat.toInt(this._activeObjectTypeIds.getValue(k));
        }

        public function getWallItemType(k:Int, _arg_2:String=null):String
        {
            var _local_3= ASCompat.asString(this._wallItemTypes.getValue(k) );
            if (((_local_3 == "poster") && (!(_arg_2 == null))))
            {
                _local_3 = (_local_3 + _arg_2);
            }
            return this.getObjectType(_local_3);
        }

        public function _Str_26208(k:String):Int
        {
            return ASCompat.toInt(this._wallItemTypeIds.getValue(k));
        }

        public function getPetType(k:Int):String
        {
            var _local_2= ASCompat.asString(this._petTypes.getValue(k) );
            return _local_2;
        }

        public function getWallItemTypeId(k:String):Int
        {
            return ASCompat.toInt(this._pets[k]);
        }

        public function getPetColor(k:Int, _arg_2:Int):PetColorResult
        {
            var _local_3:Map = this._petColors.getValue(k);
            if (_local_3 != null)
            {
                return ASCompat.dynamicAs(_local_3.getValue(_arg_2), PetColorResult);
            }
            return null;
        }

        public function getPetColorsByTag(k:Int, _arg_2:String):Array<ASAny>
        {
            var _local_5:PetColorResult = null;
            var _local_3:Map = this._petColors.getValue(k);
            var _local_4:Array<ASAny> = [];
            if (_local_3 != null)
            {
                final _iter_ = _local_3.getValues(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_5  = _tmp_;
                    if (_local_5.tag == _arg_2)
                    {
                        _local_4.push(_local_5);
                    }
                }
            }
            return _local_4;
        }

        public function getPetLayerIdForTag(k:Int, _arg_2:String, _arg_3:Int=64):Int
        {
            var _local_5:ASDictionary<ASAny,ASAny> = null;
            var _local_4:Map = this._petLayers.getValue(k);
            if (_local_4 != null)
            {
                _local_5 = _local_4.getValue(Std.string(_arg_3));
                if (_local_5 != null)
                {
                    return ASCompat.toInt((_local_5[_arg_2] != null) ? ASCompat.toInt(_local_5[_arg_2] ): -1);
                }
            }
            return -1;
        }

        public function getPetDefaultPalette(k:Int, _arg_2:String):PetColorResult
        {
            var _local_4:PetColorResult = null;
            var _local_3:Map = this._petColors.getValue(k);
            if (_local_3 != null)
            {
                final _iter_ = _local_3.getValues(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_4  = _tmp_;
                    if (((_local_4.layerTags.indexOf(_arg_2) > -1) && _local_4.isMaster))
                    {
                        return _local_4;
                    }
                }
            }
            return null;
        }

        public function getActiveObjectColorIndex(k:Int):Int
        {
            var _local_2= ASCompat.asString(this._activeObjectTypes.getValue(k) );
            return this.getObjectColorIndex(_local_2);
        }

        public function getWallItemColorIndex(k:Int):Int
        {
            var _local_2= ASCompat.asString(this._wallItemTypes.getValue(k) );
            return this.getObjectColorIndex(_local_2);
        }

        public function getRoomObjectAdURL(k:String):String
        {
            if (this._objectTypeAdURLs.getValue(k) != null)
            {
                return this._objectTypeAdURLs.getValue(k);
            }
            return "";
        }

        function getObjectType(k:String):String
        {
            if (k == null)
            {
                return null;
            }
            var _local_2= k.indexOf("*");
            if (_local_2 >= 0)
            {
                k = k.substr(0, _local_2);
            }
            return k;
        }

        function getObjectColorIndex(k:String):Int
        {
            if (k == null)
            {
                return -1;
            }
            var _local_2 = 0;
            var _local_3= k.indexOf("*");
            if (_local_3 >= 0)
            {
                _local_2 = ASCompat.toInt(k.substr((_local_3 + 1)));
            }
            return _local_2;
        }

        public function getContentType(k:String):String
        {
            return k;
        }

        public function hasInternalContent(k:String):Bool
        {
            k = RoomObjectUserTypes.getVisualizationType(k);
            if (k == RoomObjectVisualizationType.USER ||
                k == RoomObjectVisualizationType.GAME_SNOWBALL ||
                k == RoomObjectVisualizationType.GAME_SHOCKWAVE_SNOWBALL ||
                k == RoomObjectVisualizationType.GAME_SHOCKWAVE_SNOWSPLASH ||
                k == RoomObjectVisualizationType.GAME_SNOWSPLASH)
            {
                return true;
            }
            return false;
        }

        function getObjectRevision(k:String):Int
        {
            var _local_3 = 0;
            var _local_2= this.getObjectCategory(k);
            if (((_local_2 == RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE) || (_local_2 == RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM)))
            {
                if (k.indexOf("poster") == 0)
                {
                    k = "poster";
                }
                _local_3 = ASCompat.toInt(this._furniRevisions.getValue(k));
                return _local_3;
            }
            return 0;
        }

        function getObjectContentURLs(k:String, _arg_2:String=null, _arg_3:Bool=false):Array<ASAny>
        {
            var _local_4:String = null;
            var _local_5 = 0;
            var _local_6:String = null;
            var _local_7:String = null;
            var _local_8 = 0;
            var _local_9 = false;
            var _local_10:String = null;
            _local_4 = this.getContentType(k);
            switch (_local_4)
            {
                case PLACE_HOLDER:
                    return [this.resolveLocalOrAssetBaseUrl("PlaceHolderFurniture.swf")];
                case WALL_PLACE_HOLDER:
                    return [this.resolveLocalOrAssetBaseUrl("PlaceHolderWallItem.swf")];
                case PET_PLACE_HOLDER:
                    return [this.resolveLocalOrAssetBaseUrl("PlaceHolderPet.swf")];
                case ROOM:
                    return [this.resolveLocalOrAssetBaseUrl("HabboRoomContent.swf")];
                case TILE_CURSOR:
                    return [this.resolveLocalOrAssetBaseUrl("TileCursor.swf")];
                case SELECTION_ARROW:
                    return [this.resolveLocalOrAssetBaseUrl("SelectionArrow.swf")];
                default:
                    if (this.isPublicRoomObjectType(_local_4))
                    {
                        _local_7 = this._publicRoomLoadNameTemplate;
                        _local_7 = new compat.RegExp("%typeid%").replace(_local_7, _local_4);
                        if (_local_4 == "hh_room_park")
                        {
                            // The park's bus graphics live in the regional pack hh_room_park_uk.
                            // Load it alongside the base park into the same asset collection, the
                            // way r39 loads base + regional libraries together (comma content type).
                            _local_10 = new compat.RegExp("%typeid%").replace(this._publicRoomLoadNameTemplate, "hh_room_park_uk");
                            return [this.resolvePublicRoomUrl(_local_7), this.resolvePublicRoomUrl(_local_10)];
                        }
                        return [this.resolvePublicRoomUrl(_local_7)];
                    }
                    _local_5 = this.getObjectCategory(_local_4);
                    if (((_local_5 == RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE) || (_local_5 == RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM)))
                    {
                        _local_6 = this.getRoomObjectAlias(_local_4);
                        _local_7 = (_arg_3 ? this._iconLoadNameTemplate : this._furniLoadNameTemplate);
                        _local_7 = new compat.RegExp("%typeid%").replace(_local_7, _local_6);
                        _local_8 = this.getObjectRevision(_local_4);
                        _local_7 = ASCompat.stringReplace(_local_7, new compat.RegExp("%revision%"), _local_8);
                        if (_arg_3)
                        {
                            _local_9 = (((!(_arg_2 == null)) && (!(_arg_2 == ""))) && this._activeObjectTypeIds.hasKey(((k + "*") + _arg_2)));
                            _local_7 = new compat.RegExp("%param%").replace(_local_7, (_local_9 ? ("_" + _arg_2) : ""));
                        }
                        return [this.appendFurniReloadToken(this._furniLoadUrlBase + _local_7)];
                    }
                    if (_local_5 == RoomObjectCategoryEnum.OBJECT_CATEGORY_USER)
                    {
                        _local_10 = (this._assetUrlBase + this._petLoadNameTemplate);
                        _local_10 = new compat.RegExp("%type%").replace(_local_10, _local_4);
                        return [_local_10];
                    }
            }
            return [];
        }

        function appendFurniReloadToken(k:String):String
        {
            if (((this._furniReloadToken == null) || (this._furniReloadToken.length == 0)))
            {
                return k;
            }
            return (k + ((k.indexOf("?") == -1) ? "?" : "&") + "furni_reload=" + ASCompat.encodeURIComponent(this._furniReloadToken));
        }

        function getAssetLibraryName(k:String):String
        {
            return this._assetUrlBase + k;
        }

        function resolveLocalOrAssetBaseUrl(k:String):String
        {
            if (HabboWebTools.isAirApplication)
            {
                return "app:/local_include/" + k;
            }
            return this.getAssetLibraryName(k);
        }

        function isPublicRoomObjectType(k:String):Bool
        {
            if (((k == null) || (!(k.indexOf("hh_room_") == 0))))
            {
                return false;
            }
            // Exact preloaded public-room library (e.g. hh_room_sun_terrace). World names can
            // contain underscores, which the single-word check below would wrongly reject as a
            // child object type, breaking the SWF load (stuck at 100%).
            if (this._publicRoomPreloadTypes.indexOf(k) >= 0)
            {
                return true;
            }
            // Single-word room library: no underscore after the "hh_room_" prefix (distinguishes
            // the room library from its child object types like hh_room_theater_mic).
            return (k.indexOf("_", 8) == -1);
        }

        function resolvePublicRoomUrl(k:String):String
        {
            if (((this._publicRoomLoadUrlBase == null) || (this._publicRoomLoadUrlBase == "")))
            {
                return this.getAssetLibraryName(k);
            }
            return (this._publicRoomLoadUrlBase + k);
        }

        public function insertObjectContent(k:Int, _arg_2:Int, _arg_3:IAssetLibrary):Bool
        {
            var _local_6:Event = null;
            var _local_7:IEventDispatcher = null;
            var _local_4= this.getAssetLibraryType(_arg_3);
            switch (_arg_2)
            {
                case RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE:
                    this._activeObjectTypes.setProperty(k, _local_4);
                    this._activeObjectTypeIds.add(_local_4, k);
                    
                case RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM:
                    this._wallItemTypes.setProperty(k, _local_4);
                    
                default:
                    throw new ASError((("Registering content library for unsupported category " + Std.string(_arg_2)) + "!"));
            }
            var _local_5= Std.downcast(this.addAssetLibraryCollection(_local_4, null) , AssetLibraryCollection);
            if (_local_5 != null)
            {
                _local_5.addAssetLibrary(_arg_3);
                if (this.initializeGraphicAssetCollection(_local_4, _arg_3))
                {
                    switch (_arg_2)
                    {
                        case RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE:
                            if (this._activeObjects[_local_4] == null)
                            {
                                this._activeObjects[_local_4] = 1;
                            }
                            
                        case RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM:
                            if (this._wallItems[_local_4] == null)
                            {
                                this._wallItems[_local_4] = 1;
                            }
                            
                        default:
                            throw new ASError((("Registering content library for unsupported category " + Std.string(_arg_2)) + "!"));
                    }
                    _local_6 = new RoomContentLoadedEvent(RoomContentLoadedEvent.RCLE_SUCCESS, _local_4);
                    _local_7 = this.getAssetLibraryEventDispatcher(_local_4, true);
                    if (_local_7 != null)
                    {
                        _local_7.dispatchEvent(_local_6);
                    }
                    return true;
                }
            }
            return false;
        }

        public function _Str_21771(k:String, _arg_2:String):String
        {
            var _local_4:Array<ASAny> = null;
            var _local_3:String = null;
            if ((ASCompat.stringAsBool(k) && (k.indexOf(",") >= 0)))
            {
                _local_3 = k;
                k = _local_3.split(",")[0];
            }
            if (_local_3 != null)
            {
                _local_4 = this.getObjectContentURLs(_local_3, _arg_2, true);
            }
            else
            {
                _local_4 = this.getObjectContentURLs(k, _arg_2, true);
            }
            if (_local_4.length > 0)
            {
                return ASCompat.asString(_local_4[0] );
            }
            return null;
        }

        public function loadThumbnailContent(k:Int, _arg_2:String, _arg_3:String, _arg_4:IEventDispatcher):Bool
        {
            var _local_6:Array<ASAny> = null;
            var _local_7 = 0;
            var _local_8:String = null;
            var _local_9:String = null;
            var _local_10:AssetLoaderStruct = null;
            var _local_5:String = null;
            if ((ASCompat.stringAsBool(_arg_2) && (_arg_2.indexOf(",") >= 0)))
            {
                _local_5 = _arg_2;
                _arg_2 = _local_5.split(",")[0];
            }
            if (_local_5 != null)
            {
                _local_6 = this.getObjectContentURLs(_local_5, _arg_3, true);
            }
            else
            {
                _local_6 = this.getObjectContentURLs(_arg_2, _arg_3, true);
            }
            if (((!(_local_6 == null)) && (_local_6.length > 0)))
            {
                _local_7 = 0;
                while (_local_7 < _local_6.length)
                {
                    _local_8 = _local_6[_local_7];
                    _local_9 = _local_8;
                    _local_10 = this._iconAssets.loadAssetFromFile(([_arg_2, _arg_3] : Array<Dynamic>).join("_"), new URLRequest(_local_9), "image/png", null, -1, k);
                    _local_10.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTCOMPLETE, this._Str_9536);
                    _local_10.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTERROR, this.onThumbnailContentError);
                    _local_7++;
                }
                return true;
            }
            return false;
        }

        public function loadObjectContent(k:String, _arg_2:IEventDispatcher):Bool
        {
            var _local_5:Array<ASAny> = null;
            var _local_6 = 0;
            var _local_7:LibraryLoader = null;
            var _local_8:String = null;
            var _local_9:String = null;
            var _local_3:String = null;
            if ((ASCompat.stringAsBool(k) && (k.indexOf(",") >= 0)))
            {
                _local_3 = k;
                k = _local_3.split(",")[0];
            }
            if (this._publicRooms.getValue(k) != null)
            {
                this._currentPublicRoom = ASCompat.dynamicAs(this._publicRooms.getValue(k) , PublicRoomData);
            }
            if (((!(this.getAssetLibrary(k) == null)) || (!(this.getAssetLibraryEventDispatcher(k) == null))))
            {
                return false;
            }
            var _local_4= Std.downcast(this.addAssetLibraryCollection(k, _arg_2) , AssetLibraryCollection);
            if (_local_4 == null)
            {
                return false;
            }
            if (this._Str_23570(k))
            {
                Logger.log([("Ignored object type found from configuration. Not downloading assets for: " + k)]);
                return false;
            }
            if (_local_3 != null)
            {
                _local_5 = this.getObjectContentURLs(_local_3);
            }
            else
            {
                _local_5 = this.getObjectContentURLs(k);
            }
            if (((!(_local_5 == null)) && (_local_5.length > 0)))
            {
                _local_4.addEventListener(AssetLibrary.ASSET_LIBRARY_LOADED, this._Str_9536);
                _local_6 = 0;
                while (_local_6 < _local_5.length)
                {
                    _local_7 = new LibraryLoader();
                    _local_8 = _local_5[_local_6];
                    _local_9 = _local_8;
                    _local_4.loadFromFile(_local_7, true);
                    _local_7.addEventListener(LibraryLoaderEvent.LIBRARY_LOADER_EVENT_ERROR, this.onContentLoadError);
                    _local_7.load(new URLRequest(_local_9));
                    _local_6++;
                }
                return true;
            }
            return false;
        }

        function onContentLoadError(k:Event)
        {
            var _local_4:String = null;
            var _local_5:Array<ASAny> = null;
            var _local_2= cast(k.target, LibraryLoader);
            var _local_3= this.getPlaceHolderTypes();
            if (checkNullIteratee(_local_3)) for (_tmp_ in _local_3)
            {
_local_4  = _tmp_;
                _local_5 = this.getObjectContentURLs(_local_4);
                if ((((_local_5.length > 0) && (!(_local_2.url == null))) && (_local_2.url.indexOf(_local_5[0]) == 0)))
                {
                    Core.crash(("Failed to load asset: " + _local_2.url), Core.ERROR_CATEGORY_DOWNLOAD_CRITICAL_ASSET);
                    return;
                }
            }
        }

        function _Str_9536(k:Event)
        {
            var _local_2:AssetLoaderStruct = null;
            var _local_3:IAssetLibrary = null;
            if (this.disposed)
            {
                return;
            }
            if (Std.is(k.target , AssetLoaderStruct))
            {
                _local_2 = ASCompat.dynamicAs(k.target , AssetLoaderStruct);
                this._iconListener.iconLoaded(_local_2.assetLoader.id, _local_2.assetName, true);
            }
            else
            {
                _local_3 = ASCompat.dynamicAs(k.target , IAssetLibrary);
                if (_local_3 == null)
                {
                    return;
                }
                this.processLoadedLibrary(_local_3);
            }
        }

        function onThumbnailContentError(k:AssetLoaderEvent)
        {
        }

        function processLoadedLibrary(k:IAssetLibrary)
        {
            var _local_2:RoomContentLoadedEvent = null;
            var _local_3 = false;
            var _local_6:com.sulake.core.utils.xml.XML = null;
            var _local_7:PublicRoomData = null;
            var _local_8:Array<ASAny> = null;
            var _local_9 = 0;
            var _local_4= this.getAssetLibraryType(k);
            _local_4 = this.getRoomObjectOriginalName(_local_4);
            if (_local_4 != null)
            {
                _local_3 = this.initializeGraphicAssetCollection(_local_4, k);
            }
            if (_local_3)
            {
                if (this._pets[_local_4] != null)
                {
                    this.extractPetDataFromLoadedContent(_local_4);
                }
                if (PUBLIC_ROOM_VISUALIZATIONS.indexOf(this.getVisualizationType(_local_4)) >= 0)
                {
                    _local_6 = this.getVisualizationXML(_local_4);
                    _local_7 = this.extractPublicRoomFromXML(_local_4, _local_6);
                    this._publicRooms.add(_local_4, _local_7);
                    this._currentPublicRoom = _local_7;
                    _local_8 = this.extractPublicRoomFurnitures(_local_4, k);
                }
                _local_2 = new RoomContentLoadedEvent(RoomContentLoadedEvent.RCLE_SUCCESS, _local_4);
            }
            else
            {
                _local_2 = new RoomContentLoadedEvent(RoomContentLoadedEvent.RCLE_FAILURE, _local_4);
            }
            var _local_5= this.getAssetLibraryEventDispatcher(_local_4, true);
            if (((!(_local_5 == null)) && (!(_local_2 == null))))
            {
                _local_5.dispatchEvent(_local_2);
                if (((_local_8 != null) && (_local_2.type == RoomContentLoadedEvent.RCLE_SUCCESS)))
                {
                    _local_9 = 0;
                    while (_local_9 < _local_8.length)
                    {
                        _local_5.dispatchEvent(new RoomContentLoadedEvent(RoomContentLoadedEvent.RCLE_SUCCESS, _local_8[_local_9]));
                        _local_9++;
                    }
                }
            }
        }

        function extractPetDataFromLoadedContent(k:String)
        {
            var _local_5:Map = null;
            var _local_6:Array<ASAny> = null;
            var _local_7:String = null;
            var _local_8:Array<ASAny> = null;
            var _local_9:com.sulake.core.utils.xml.XML = null;
            var _local_10 = 0;
            var _local_11 = 0;
            var _local_12:Array<ASAny> = null;
            var _local_13 = false;
            var _local_14:Map = null;
            var _local_15:com.sulake.core.utils.xml.XML = null;
            var _local_16:ASDictionary<ASAny,ASAny> = null;
            var _local_17:com.sulake.core.utils.xml.XML = null;
            var _local_18:String = null;
            var _local_19:String = null;
            var _local_2= ASCompat.toInt(this._pets[k]);
            var _local_3= this.getGraphicAssetCollection(k);
            if (_local_3 != null)
            {
                _local_5 = new Map();
                _local_6 = _local_3._Str_21825();
                if (checkNullIteratee(_local_6)) for (_tmp_ in _local_6)
                {
_local_7  = _tmp_;
                    _local_8 = _local_3._Str_20963(_local_7);
                    if (((!(_local_8 == null)) && (_local_8.length >= 2)))
                    {
                        _local_9 = _local_3._Str_17888(_local_7);
                        _local_10 = ASCompat.toInt(ASCompat.xmlListToString(_local_9.attribute("breed")));
                        _local_11 = (_local_9.hasOwnProperty("@colortag") ? ASCompat.toInt(ASCompat.xmlListToString(_local_9.attribute("colortag"))) : -1);
                        _local_12 = (_local_9.hasOwnProperty("@tags") ? (cast _local_9.attribute("tags").toString().split(",")) : []);
                        _local_13 = (_local_9.hasOwnProperty("@master") ? (_local_9.attribute("master").toString() == "true") : false);
                        _local_5.add(_local_7, new PetColorResult(ASCompat.toInt(_local_8[0]), ASCompat.toInt(_local_8[1]), _local_10, _local_11, _local_7, _local_13, _local_12));
                    }
                }
                this._petColors.add(_local_2, _local_5);
            }
            var _local_4= this.getVisualizationXML(k);
            if (_local_4 != null)
            {
                _local_14 = new Map();
                final _iter_ = _local_4.child("visualization"); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_15  = _tmp_;
                    _local_16 = new ASDictionary<ASAny,ASAny>();
                    final _iter_ = _local_15.child("layers").child("layer"); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                    {
_local_17  = _tmp_;
                        if (_local_17.hasOwnProperty("@tag"))
                        {
                            _local_19 = _local_17.attribute("tag").toString();
                            _local_16[_local_19] = ASCompat.parseInt(_local_17.attribute("id").toString());
                        }
                    }
                    _local_18 = _local_15.attribute("size").toString();
                    _local_14.add(_local_18, _local_16);
                }
                this._petLayers.add(_local_2, _local_14);
            }
        }

        function initializeGraphicAssetCollection(k:String, _arg_2:IAssetLibrary):Bool
        {
            var _local_5:com.sulake.core.utils.xml.XML = null;
            if (((k == null) || (_arg_2 == null)))
            {
                return false;
            }
            var _local_3 = false;
            var _local_4= this.createGraphicAssetCollection(k, _arg_2);
            if (_local_4 != null)
            {
                _local_5 = this.getAssetXML(k);
                if (_local_4._Str_13182(_local_5))
                {
                    _local_3 = true;
                }
                else
                {
                    this.disposeGraphicAssetCollection(k);
                }
            }
            return _local_3;
        }

        public function extractObjectContent(k:String, _arg_2:String):Bool
        {
            var _local_3= this.getAssetLibrary(k);
            this._additionalObjectTypeLibraries.add(_arg_2, k);
            if (this.initializeGraphicAssetCollection(_arg_2, _local_3))
            {
                return true;
            }
            this._additionalObjectTypeLibraries.remove(_arg_2);
            return false;
        }

        function extractPublicRoomFromXML(k:String, _arg_2:com.sulake.core.utils.xml.XML):PublicRoomData
        {
            var _local_6:com.sulake.core.utils.xml.XML = null;
            var _local_7:String = null;
            var _local_8 = Math.NaN;
            var _local_9 = Math.NaN;
            var _local_3= _arg_2.child("layoutData");
            var _local_4= new PublicRoomData(k);
            var _local_5 = 0;
            while (_local_5 < _local_3.length())
            {
                _local_6 = _local_3.at(_local_5);
                _local_7 = (RCL_PUBLICROOM_PREFIX + _local_6.attribute("name").toString());
                _local_8 = 32;
                _local_9 = 1;
                if (_local_6.attribute("size").toString() != "")
                {
                    _local_8 = ASCompat.parseInt(_local_6.attribute("size").toString());
                }
                if (_local_6.attribute("heightScale").toString() != "")
                {
                    _local_9 = Std.parseFloat(_local_6.attribute("heightScale").toString());
                }
                _local_4.addWorld(_local_7, _local_8, _local_9);
                _local_5++;
            }
            return _local_4;
        }

        function extractPublicRoomFurnitures(k:String, _arg_2:IAssetLibrary):Array<ASAny>
        {
var _local_12 = false;            var _local_8:IAsset = null;
            var _local_9:com.sulake.core.utils.xml.XML = null;
            var _local_10:String = null;
            var _local_11:String = null;
            var _local_6:String = null;
            var _local_7:String = null;
            var _local_4:Array<ASAny> = [];
            if (_arg_2 == null)
            {
                return _local_4;
            }
            var _local_3= _arg_2.nameArray;
            var _local_5 = 0;
            while (_local_5 < _local_3.length)
            {
                _local_6 = _local_3[_local_5];
                if (_local_6.indexOf("_index") > 0)
                {
                    _local_7 = _local_6.substring(0, _local_6.indexOf("_index"));
                    _local_10 = _local_7;
                    _local_8 = _arg_2.getAssetByName(_local_6);
                    if (_local_8 != null)
                    {
                        _local_9 = ((_local_8.content : com.sulake.core.utils.xml.XML) );
                        if (((!(_local_9 == null)) && (_local_9.attribute("type").toString() != "")))
                        {
                            _local_10 = _local_9.attribute("type").toString();
                            this.setRoomObjectAlias(_local_10, _local_7);
                        }
                    }
                    this._publicRoomAssetSourceAliases.remove(_local_10);
                    _local_11 = this.findPublicRoomAssetRoot(_arg_2, k, _local_10, _local_7);
                    this._publicRoomAssetSourceAliases.add(_local_10, _local_11);
                    this._publicRoomObjectLibraries.remove(_local_10);
                    this._publicRoomObjectLibraries.add(_local_10, _arg_2);
_local_12= this.extractObjectContent(k, _local_10);
                    if (_local_12)
                    {
                        _local_4.push(_local_10);
                    }
                }
                _local_5++;
            }
            return _local_4;
        }

        function findPublicRoomAssetRoot(k:IAssetLibrary, _arg_2:String, _arg_3:String, _arg_4:String):String
        {
            var _local_6:String = null;
            var _local_9:String = null;
            var _local_10:String = null;
            var _local_11 = 0;
            if (k == null)
            {
                return _arg_4;
            }
            var _local_5:Array<ASAny> = [_arg_4, _arg_3, ((_arg_2 + "_") + _arg_3), ((_arg_2 + "_") + _arg_4)];
            if (checkNullIteratee(_local_5)) for (_tmp_ in _local_5)
            {
_local_6  = _tmp_;
                if (((!(_local_6 == null)) && k.hasAsset((_local_6 + "_assets"))))
                {
                    return _local_6;
                }
            }
            var _local_7= (_arg_3 + "_assets");
            var _local_8= k.nameArray;
            _local_11 = 0;
            while (_local_11 < _local_8.length)
            {
                _local_9 = _local_8[_local_11];
                if (_local_9.indexOf("_assets") > 0)
                {
                    _local_10 = _local_9.substring(0, _local_9.indexOf("_assets"));
                    if (((_local_9 == _local_7) || (_local_9.indexOf(_local_7) == (_local_9.length - _local_7.length))))
                    {
                        return _local_10;
                    }
                }
                _local_11++;
            }
            return _arg_4;
        }

        function getPublicRoomDataForWorld(k:String):PublicRoomData
        {
            var _local_3 = 0;
            var _local_4:PublicRoomData = null;
            var _local_2= (RCL_PUBLICROOM_PREFIX + k);
            if (((!(this._currentPublicRoom == null)) && this._currentPublicRoom.hasWorldType(_local_2)))
            {
                return this._currentPublicRoom;
            }
            if (this._publicRooms != null)
            {
                _local_3 = 0;
                while ((_local_3 : UInt) < this._publicRooms.length)
                {
                    _local_4 = ASCompat.dynamicAs(this._publicRooms.getWithIndex(_local_3) , PublicRoomData);
                    if (((!(_local_4 == null)) && _local_4.hasWorldType(_local_2)))
                    {
                        return _local_4;
                    }
                    _local_3++;
                }
            }
            return null;
        }

        public function getPublicRoomContentType(k:String):String
        {
            var _local_2= this.getPublicRoomDataForWorld(k);
            if (!(_local_2 == null))
            {
                return _local_2.type;
            }
            return k;
        }

        public function getPublicRoomWorldHeightScale(k:String):Float
        {
            var _local_2= this.getPublicRoomDataForWorld(k);
            if (!(_local_2 == null))
            {
                return _local_2.getWorldHeightScale((RCL_PUBLICROOM_PREFIX + k));
            }
            return 1;
        }

        public function getPublicRoomWorldSize(k:String):Int
        {
            var _local_2= this.getPublicRoomDataForWorld(k);
            if (!(_local_2 == null))
            {
                return Std.int(_local_2.getWorldScale((RCL_PUBLICROOM_PREFIX + k)));
            }
            return 32;
        }

        public function isPublicRoomWorldType(k:String):Bool
        {
            return (!(this.getPublicRoomDataForWorld(k) == null));
        }

        function _Str_10970(k:String):String
        {
            return RCL_PREFIX + k;
        }

        function getAssetLibrary(k:String):IAssetLibrary
        {
            var _local_4:String = null;
            var _local_2= this.getContentType(k);
            _local_2 = this.getRoomObjectOriginalName(_local_2);
            var _local_3= ASCompat.dynamicAs(this._libraries.getValue(this._Str_10970(_local_2)) , IAssetLibrary);
            if (_local_3 == null)
            {
                _local_4 = this._additionalObjectTypeLibraries.getValue(_local_2);
                if (_local_4 != null)
                {
                    _local_2 = this.getContentType(_local_4);
                    _local_3 = ASCompat.dynamicAs(this._libraries.getValue(this._Str_10970(_local_2)) , IAssetLibrary);
                }
            }
            return _local_3;
        }

        function addAssetLibraryCollection(k:String, _arg_2:IEventDispatcher):IAssetLibrary
        {
            var _local_3= this.getContentType(k);
            var _local_4= this.getAssetLibrary(k);
            if (_local_4 != null)
            {
                return _local_4;
            }
            var _local_5= this._Str_10970(_local_3);
            _local_4 = new AssetLibraryCollection(_local_5);
            this._libraries.add(_local_5, _local_4);
            if (((!(_arg_2 == null)) && (this.getAssetLibraryEventDispatcher(k) == null)))
            {
                this._events.add(_local_3, _arg_2);
            }
            return _local_4;
        }

        function getAssetLibraryEventDispatcher(k:String, _arg_2:Bool=false):IEventDispatcher
        {
            var _local_3= this.getContentType(k);
            if (!_arg_2)
            {
                return this._events.getValue(_local_3);
            }
            return this._events.remove(_local_3);
        }

        function getIconAssetType(k:AssetLoaderStruct):String
        {
            if (k == null)
            {
                return null;
            }
            var _local_2= k.assetName;
            var _local_3:Array<ASAny> = (cast _local_2.split("_"));
            var _local_4= ASCompat.parseInt(_local_3.pop());
            var _local_5= _local_3.join("_");
            return (_local_4 > 0) ? ((_local_5 + "*") + Std.string(_local_4)) : _local_5;
        }

        function getAssetLibraryType(k:IAssetLibrary):String
        {
            if (k == null)
            {
                return null;
            }
            var _local_2= k.getAssetByName("index");
            if (_local_2 == null)
            {
                return null;
            }
            var _local_3= ((_local_2.content : com.sulake.core.utils.xml.XML) );
            if (_local_3 == null)
            {
                return null;
            }
            var _local_4= _local_3.attribute("type").toString();
            return _local_4;
        }

        public function getVisualizationType(k:String):String
        {
            if (k == null)
            {
                return null;
            }
            var _local_2= this.getAssetLibrary(k);
            if (_local_2 == null)
            {
                return null;
            }
            var _local_6= this.getRoomObjectAlias(this.getContentType(k));
            var _local_3= _local_2.getAssetByName((_local_6 + "_index"));
            if (_local_3 == null)
            {
                _local_3 = _local_2.getAssetByName((k + "_index"));
                if (_local_3 == null)
                {
                    _local_3 = _local_2.getAssetByName("index");
                }
            }
            if (_local_3 == null)
            {
                return null;
            }
            var _local_4= ((_local_3.content : com.sulake.core.utils.xml.XML) );
            if (_local_4 == null)
            {
                return null;
            }
            var _local_5= _local_4.attribute("visualization").toString();
            return _local_5;
        }

        public function getLogicType(k:String):String
        {
            if (k == null)
            {
                return null;
            }
            var _local_2= this.getAssetLibrary(k);
            if (_local_2 == null)
            {
                return null;
            }
            var _local_6= this.getRoomObjectAlias(this.getContentType(k));
            var _local_3= _local_2.getAssetByName((_local_6 + "_index"));
            if (_local_3 == null)
            {
                _local_3 = _local_2.getAssetByName((k + "_index"));
                if (_local_3 == null)
                {
                    _local_3 = _local_2.getAssetByName("index");
                }
            }
            if (_local_3 == null)
            {
                return null;
            }
            var _local_4= ((_local_3.content : com.sulake.core.utils.xml.XML) );
            if (_local_4 == null)
            {
                return null;
            }
            var _local_5= _local_4.attribute("logic").toString();
            return _local_5;
        }

        public function hasVisualizationXML(k:String):Bool
        {
            return this.hasXML(k, "_visualization");
        }

        public function getVisualizationXML(k:String):com.sulake.core.utils.xml.XML
        {
            return this.getXML(k, "_visualization");
        }

        public function hasAssetXML(k:String):Bool
        {
            return this.hasXML(k, "_assets");
        }

        public function getAssetXML(k:String):com.sulake.core.utils.xml.XML
        {
            return this.getXML(k, "_assets");
        }

        public function hasLogicXML(k:String):Bool
        {
            return this.hasXML(k, "_logic");
        }

        public function getLogicXML(k:String):com.sulake.core.utils.xml.XML
        {
            return this.getXML(k, "_logic");
        }

        function getXML(k:String, _arg_2:String):com.sulake.core.utils.xml.XML
        {
            var _local_8:com.sulake.core.utils.xml.XML = null;
            var _local_9:String = null;
            var _local_10:String = null;
            var _local_4= this.getContentType(k);
            var _local_3= ASCompat.dynamicAs(this._publicRoomObjectLibraries.getValue(_local_4) , IAssetLibrary);
            if (_local_3 == null)
            {
                _local_3 = this.getAssetLibrary(k);
                if (_local_3 == null)
                {
                    return null;
                }
            }
            var _local_5= this.getRoomObjectAlias(_local_4);
            _local_10 = ASCompat.asString(this._publicRoomAssetSourceAliases.getValue(_local_4) );
            var _local_6= _local_3.getAssetByName((_local_5 + _arg_2));
            if (((_local_6 == null) && (!(_local_10 == null)) && (!(_local_10 == _local_5))))
            {
                _local_6 = _local_3.getAssetByName((_local_10 + _arg_2));
            }
            if (_local_6 == null)
            {
                return null;
            }
            var _local_7= ((_local_6.content : com.sulake.core.utils.xml.XML) );
            if (_local_7 == null)
            {
                return null;
            }
            if (_local_10 == null)
            {
                _local_10 = _local_5;
            }
            if (((_arg_2 == "_assets") && (!(_local_10 == _local_4))))
            {
                _local_7 = _local_7.copy();
                final _iter_ = _local_7.child("asset"); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_8  = _tmp_;
                    if (_local_8.attribute("source").toString() == "")
                    {
                        _local_9 = _local_8.attribute("name").toString();
                        if (_local_9.indexOf(_local_4) == 0)
                        {
                            _local_8.setAttribute("source", (_local_10 + _local_9.substr(_local_4.length))) ;
                        }
                    }
                }
            }
            return _local_7;
        }

        function hasXML(k:String, _arg_2:String):Bool
        {
            var _local_3= this.getAssetLibrary(k);
            if (_local_3 == null)
            {
                return false;
            }
            var _local_4= this.getContentType(k);
            var _local_5= this.getRoomObjectAlias(_local_4);
            return _local_3.hasAsset((_local_5 + _arg_2));
        }

        public function _Str_16696(k:String, _arg_2:String, _arg_3:BitmapData, _arg_4:Bool, _arg_5:Bool=true):Bool
        {
            var _local_6= this.getGraphicAssetCollection(k);
            if (_local_6 != null)
            {
                return _local_6.addAsset(_arg_2, _arg_3, _arg_4, 0, 0, false, false);
            }
            return false;
        }

        function createGraphicAssetCollection(k:String, _arg_2:IAssetLibrary):IGraphicAssetCollection
        {
            var _local_3= this.getGraphicAssetCollection(k);
            if (_local_3 != null)
            {
                return _local_3;
            }
            if (_arg_2 == null)
            {
                return null;
            }
            _local_3 = this._visualizationFactory.createGraphicAssetCollection();
            if (_local_3 != null)
            {
                _local_3.assetLibrary = _arg_2;
                this._assetCollections.add(k, _local_3);
            }
            return _local_3;
        }

        public function getGraphicAssetCollection(k:String):IGraphicAssetCollection
        {
            var _local_2= this.getContentType(k);
            return ASCompat.dynamicAs(this._assetCollections.getValue(_local_2) , IGraphicAssetCollection);
        }

        public function roomObjectCreated(k:IRoomObject, _arg_2:String)
        {
            var _local_3= Std.downcast(k , IRoomObjectController);
            if (((_local_3 != null) && (_local_3.getModelController() != null)))
            {
                _local_3.getModelController().setString(RoomObjectVariableEnum.OBJECT_ROOM_ID, _arg_2, true);
            }
        }

        function disposeGraphicAssetCollection(k:String):Bool
        {
            var _local_3:IGraphicAssetCollection = null;
            var _local_2= this.getContentType(k);
            if (this._assetCollections.getValue(_local_2)!= null)
            {
                _local_3 = this._assetCollections.remove(_local_2);
                if (_local_3 != null)
                {
                    _local_3.dispose();
                }
                return true;
            }
            return false;
        }

        public function furniDataReady()
        {
            this.reloadFurnitureAssets((this._sessionDataManager == null) ? null : this._sessionDataManager.furniDataReloadToken);
            this.initFurnitureData();
            this.loadPendingFurnitureContent();
        }

        function reloadFurnitureAssets(k:String)
        {
            if (((k == null) || (k.length == 0)))
            {
                return;
            }
            this._furniReloadToken = k;
            this._pendingFurnitureContentRefresh = this.getLoadedFurnitureAssetTypes();
            this.resetLoadedFurnitureObjectsToPlaceHolders(this._pendingFurnitureContentRefresh);
            this.purgeFurnitureAssetTypes(this._pendingFurnitureContentRefresh);
            this.resetFurnitureDataMaps();
        }

        function getLoadedFurnitureAssetTypes():Array<ASAny>
        {
            var _local_2:String = null;
            var k:Array<ASAny> = [];
            var _local_4= ASCompat.toInt(this._assetCollections.length - 1);
            while (_local_4 > -1)
            {
                _local_2 = this._assetCollections.getKey(_local_4);
                if (this.isReloadableFurnitureAsset(_local_2))
                {
                    k.push(_local_2);
                }
                _local_4--;
            }
            return k;
        }

        function isReloadableFurnitureAsset(k:String):Bool
        {
            var _local_2 = 0;
            if (((k == null) || (PLACE_HOLDER_TYPES_GPU.indexOf(k) >= 0)))
            {
                return false;
            }
            if (this.isPreloadedPublicRoomAsset(k))
            {
                return false;
            }
            _local_2 = this.getObjectCategory(k);
            return ((_local_2 == RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE) || (_local_2 == RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM));
        }

        function resetLoadedFurnitureObjectsToPlaceHolders(k:Array<ASAny>)
        {
            var _local_2:String = null;
            if (((k == null) || (this._roomManager == null)))
            {
                return;
            }
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_2  = _tmp_;
                this._roomManager.resetObjectContentToPlaceHolder(_local_2);
            }
        }

        function purgeFurnitureAssetTypes(k:Array<ASAny>)
        {
            var _local_2:String = null;
            if (k == null)
            {
                return;
            }
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_2  = _tmp_;
                this.purgeFurnitureAssetType(_local_2);
            }
        }

        function purgeFurnitureAssetType(k:String)
        {
            var _local_2:String = null;
            var _local_3:IGraphicAssetCollection = null;
            var _local_4:String = null;
            var _local_5:IAssetLibrary = null;
            if (k == null)
            {
                return;
            }
            _local_2 = this.getContentType(k);
            _local_3 = ASCompat.dynamicAs(this._assetCollections.remove(_local_2) , IGraphicAssetCollection);
            if (_local_3 != null)
            {
                _local_3.dispose();
            }
            _local_4 = this._Str_10970(_local_2);
            _local_5 = ASCompat.dynamicAs(this._libraries.remove(_local_4) , IAssetLibrary);
            if (_local_5 != null)
            {
                _local_5.dispose();
            }
            this._events.remove(_local_2);
        }

        function loadPendingFurnitureContent()
        {
            var _local_2:String = null;
            if (this._pendingFurnitureContentRefresh == null)
            {
                return;
            }
            final _iter_ = this._pendingFurnitureContentRefresh; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (this.isReloadableFurnitureAsset(_local_2))
                {
                    if (this._roomManager != null)
                    {
                        this._roomManager.loadObjectContent(_local_2);
                    }
                }
            }
            this._pendingFurnitureContentRefresh = null;
        }

        function resetFurnitureDataMaps()
        {
var k:String  = null;            var k:String = null;
            this._activeObjectTypes.reset();
            this._activeObjectTypeIds.reset();
            this._wallItemTypes.reset();
            this._wallItemTypeIds.reset();
            this._furniRevisions.reset();
            this._objectAliases.reset();
            this._objectOriginalNames.reset();
            this._objectTypeAdURLs.reset();
            final _iter_ = this._activeObjects; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
            {
k = _tmp_;
                this._activeObjects.remove(k);
            }
            final _iter_ = this._wallItems; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
            {
k = _tmp_;
                this._wallItems.remove(k);
            }
        }

        public function setActiveObjectType(k:Int, _arg_2:String)
        {
            this._activeObjectTypes.remove(k);
            this._activeObjectTypes.add(k, _arg_2);
        }

        public function compressAssets()
        {
            var _local_2:IGraphicAssetCollection = null;
            var _local_3:String = null;
            var _local_6:String = null;
            var _local_7:IAssetLibrary = null;
            var _local_8 = 0;
            var _local_9 = 0;
            var _local_10:BitmapDataAsset = null;
            var k= ASCompat.toInt(this._assetCollections.length);
            var _local_4= this.getPlaceHolderTypes();
            var _local_5= (k - 1);
            while (_local_5 > -1)
            {
                _local_3 = this._assetCollections.getKey(_local_5);
                if (_local_4.indexOf(_local_3) != -1)
                {
                }
                else
                {
                    _local_2 = this._assetCollections.getValue(_local_3);
                    _local_6 = this._Str_10970(_local_3);
                    _local_7 = ASCompat.dynamicAs(this._libraries.getValue(_local_6) , IAssetLibrary);
                    if (_local_7 == null)
                    {
                    }
                    else
                    {
                        _local_8 = ASCompat.toInt(_local_7.numAssets);
                        _local_9 = 0;
                        while (_local_9 < _local_8)
                        {
                            _local_10 = Std.downcast(_local_7.getAssetByIndex(_local_9) , BitmapDataAsset);
                            if (_local_10 != null)
                            {
                            }
                            _local_9++;
                        }
                    }
                }
                _local_5--;
            }
            this._lastAssetCompressionTime = flash.Lib.getTimer();
        }

        public function purge()
        {
            var _local_2:IGraphicAssetCollection = null;
            var _local_3:String = null;
            var _local_6:String = null;
            var _local_7:IAssetLibrary = null;
            var k= ASCompat.toInt(this._assetCollections.length);
            var _local_4= flash.Lib.getTimer();
            var _local_5= (k - 1);
            while (_local_5 > -1)
            {
                _local_3 = this._assetCollections.getKey(_local_5);
                if (((PLACE_HOLDER_TYPES_GPU.indexOf(_local_3) < 0) && (!this.isPreloadedPublicRoomAsset(_local_3))))
                {
                    _local_2 = this._assetCollections.getValue(_local_3);
                    if (((_local_2._Str_20679() < 1) && ((_local_4 - _local_2._Str_21431()) >= CONST_20000)))
                    {
                        this._assetCollections.remove(_local_3);
                        _local_2.dispose();
                        _local_6 = this._Str_10970(_local_3);
                        _local_7 = ASCompat.dynamicAs(this._libraries.getValue(_local_6) , IAssetLibrary);
                        if (_local_7 != null)
                        {
                            this._libraries.remove(_local_6);
                            _local_7.dispose();
                        }
                    }
                }
                _local_5--;
            }
        }

        public function _Str_26341(k:String):String
        {
            var _local_2= this.getContentType(k);
            if (((((((_local_2 == PLACE_HOLDER) || (_local_2 == WALL_PLACE_HOLDER)) || (_local_2 == PET_PLACE_HOLDER)) || (_local_2 == ROOM)) || (_local_2 == TILE_CURSOR)) || (_local_2 == SELECTION_ARROW)))
            {
                return null;
            }
            var _local_3= this.getObjectCategory(_local_2);
            if (((!(_local_3 == RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE)) && (!(_local_3 == RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM))))
            {
                return null;
            }
            var _local_4= this.getObjectRevision(_local_2);
            return ((((("room_content/" + k) + "/") + Std.string(_local_4)) + "/") + k) + ".swf";
        }

        public var iconAssets(never,set):IAssetLibrary;
public function  set_iconAssets(k:IAssetLibrary):IAssetLibrary        {
            return this._iconAssets = k;
        }

        public var iconListener(never,set):IRoomContentListener;
public function  set_iconListener(k:IRoomContentListener):IRoomContentListener        {
            return this._iconListener = k;
        }
    }
