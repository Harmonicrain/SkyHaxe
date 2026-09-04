package com.sulake.room
;
    import com.sulake.core.runtime.Component;
    import com.sulake.core.utils.Map;
    import com.sulake.room.object.IRoomObjectVisualizationFactory;
    import com.sulake.room.events.RoomContentLoadedEvent;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.runtime.ComponentDependency;
    import com.sulake.iid.IIDRoomObjectFactory;
    import com.sulake.iid.IIDRoomObjectVisualizationFactory;
    import com.sulake.room.exceptions.RoomManagerException;
    import com.sulake.room.object.visualization.utils.IGraphicAssetCollection;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.room.object.IRoomObjectController;
    import com.sulake.room.object.visualization.IRoomObjectGraphicVisualization;
    import com.sulake.room.object.visualization.IRoomObjectVisualizationData;
    import com.sulake.room.object.logic.IRoomObjectEventHandler;
    import com.sulake.iid.*;

     class RoomManager extends Component implements IRoomManager implements  IRoomInstanceContainer 
    {
        public static inline final ROOM_MANAGER_ERROR= -1;
        public static inline final ROOM_MANAGER_LOADING= 0;
        public static inline final ROOM_MANAGER_LOADED= 1;
        public static inline final ROOM_MANAGER_INITIALIZING= 2;
        public static inline final ROOM_MANAGER_INITIALIZED= 3;
        static inline final CONTENT_PROCESSING_TIME_LIMIT_MILLISECONDS= 40;

        var _rooms:Map;
        var _contentLoader:IRoomContentLoader;
        var _initialLoadList:Array<ASAny>;
        var _updateCategories:Array<ASAny>;
        var _updateInterval:Int = 0;
        var _listener:IRoomManagerListener;
        var _objectFactory:IRoomObjectFactory = null;
        var _visualizationFactory:IRoomObjectVisualizationFactory = null;
        var _state:Int = 0;
        var _initializationData:com.sulake.core.utils.xml.XML = null;
        var _unprocessedLoadedContentTypes:Array<ASAny>;
        var _skipContentProcessingForNextFrame:Bool = false;
        var _limitContentProcessing:Bool = true;
        var _disposed__com_sulake_room_RoomManager/*redefined private*/:Bool = false;

        public function new(k:IContext, _arg_2:UInt=0)
        {
            this._unprocessedLoadedContentTypes = [];
            super(k, _arg_2);
            this._rooms = new Map();
            this._initialLoadList = [];
            this._updateCategories = [];
            events.addEventListener(RoomContentLoadedEvent.RCLE_SUCCESS, this._Str_9536);
            events.addEventListener(RoomContentLoadedEvent.RCLE_FAILURE, this._Str_9536);
            events.addEventListener(RoomContentLoadedEvent.RCLE_CANCEL, this._Str_9536);
        }

        override function  get_disposed():Bool
        {
            return this._disposed__com_sulake_room_RoomManager;
        }

        public var limitContentProcessing(never,set):Bool;
function  set_limitContentProcessing(k:Bool):Bool        {
            return this._limitContentProcessing = k;
        }

        override function  get_dependencies():Vector<ComponentDependency>
        {
            return super.dependencies.concat(Vector.ofArray([new ComponentDependency(new IIDRoomObjectFactory(), function (k:IRoomObjectFactory)
            {
                _objectFactory = k;
            }), new ComponentDependency(new IIDRoomObjectVisualizationFactory(), function (k:IRoomObjectVisualizationFactory)
            {
                _visualizationFactory = k;
            })]));
        }

        override function initComponent()
        {
            var k:com.sulake.core.utils.xml.XML;
            this._state = ROOM_MANAGER_LOADED;
            if (this._initializationData != null)
            {
                k = this._initializationData;
                this._initializationData = null;
                this.initialize(k, this._listener);
            }
        }

        override public function dispose()
        {
            var k:IRoomInstance;
            if (this.disposed)
            {
                return;
            }
            if (this._rooms != null)
            {
                for (_tmp_ in this._rooms.getValues())
                {
k  = _tmp_;
                    if (k != null)
                    {
                        k.dispose();
                    }
                }
                this._rooms.dispose();
                this._rooms = null;
            }
            this._listener = null;
            this._initialLoadList = null;
            this._updateCategories = null;
            this._contentLoader = null;
            super.dispose();
        }

        public function initialize(k:com.sulake.core.utils.xml.XML, _arg_2:IRoomManagerListener):Bool
        {
            var _local_5:String;
            if (this._state == ROOM_MANAGER_LOADING)
            {
                if (this._initializationData != null)
                {
                    return false;
                }
                this._initializationData = k;
                this._listener = _arg_2;
                return true;
            }
            if (this._state >= ROOM_MANAGER_INITIALIZING)
            {
                return false;
            }
            if (k == null)
            {
                return false;
            }
            if (this._contentLoader == null)
            {
                return false;
            }
            this._updateInterval = 50;
            this._listener = _arg_2;
            var _local_3= this._contentLoader.getPlaceHolderTypes();
            var _local_4 = 0;
            while (_local_4 < _local_3.length)
            {
                _local_5 = _local_3[_local_4];
                if (this._initialLoadList.indexOf(_local_5) < 0)
                {
                    this._contentLoader.loadObjectContent(_local_5, events);
                    this._initialLoadList.push(_local_5);
                }
                _local_4++;
            }
            this._state = ROOM_MANAGER_INITIALIZING;
            return true;
        }

        public function setContentLoader(k:IRoomContentLoader)
        {
            if (this._contentLoader != null)
            {
                this._contentLoader.dispose();
            }
            this._contentLoader = k;
        }

        public function addObjectUpdateCategory(k:Int)
        {
            var _local_4:RoomInstance;
            var _local_2= this._updateCategories.indexOf(k);
            if (_local_2 >= 0)
            {
                return;
            }
            this._updateCategories.push(k);
            var _local_3:Int = (this._rooms.length - 1);
            while (_local_3 >= 0)
            {
                _local_4 = ASCompat.dynamicAs(this._rooms.getWithIndex(_local_3) , RoomInstance);
                if (_local_4 != null)
                {
                    _local_4.addObjectUpdateCategory(k);
                }
                _local_3--;
            }
        }

        public function removeObjectUpdateCategory(k:Int)
        {
            var _local_4:RoomInstance;
            var _local_2= this._updateCategories.indexOf(k);
            if (_local_2 < 0)
            {
                return;
            }
            this._updateCategories.splice(_local_2, 1);
            var _local_3:Int = (this._rooms.length - 1);
            while (_local_3 >= 0)
            {
                _local_4 = ASCompat.dynamicAs(this._rooms.getWithIndex(_local_3) , RoomInstance);
                if (_local_4 != null)
                {
                    _local_4.removeObjectUpdateCategory(k);
                }
                _local_3--;
            }
        }

        public function createRoom(k:String, _arg_2:com.sulake.core.utils.xml.XML):IRoomInstance
        {
            var _local_5:Int;
            if (this._state < ROOM_MANAGER_INITIALIZED)
            {
                throw new RoomManagerException();
            }
            if (this._rooms.getValue(k) != null)
            {
                return null;
            }
            var _local_3= new RoomInstance(k, this);
            this._rooms.add(k, _local_3);
            var _local_4= (this._updateCategories.length - 1);
            while (_local_4 >= 0)
            {
                _local_5 = ASCompat.toInt(this._updateCategories[_local_4]);
                _local_3.addObjectUpdateCategory(_local_5);
                _local_4--;
            }
            return _local_3;
        }

        public function getRoom(k:String):IRoomInstance
        {
            return ASCompat.dynamicAs(this._rooms.getValue(k) , IRoomInstance);
        }

        public function getRoomWithIndex(k:Int):IRoomInstance
        {
            return this._rooms.getWithIndex(k);
        }

        public function getRoomCount():Int
        {
            return this._rooms.length;
        }

        public function disposeRoom(k:String):Bool
        {
            var _local_2= ASCompat.dynamicAs(this._rooms.remove(k) , IRoomInstance);
            if (_local_2 != null)
            {
                _local_2.dispose();
                return true;
            }
            return false;
        }

        public function createRoomObject(k:String, _arg_2:Int, _arg_3:String, _arg_4:Int):IRoomObject
        {
            if (this._state < ROOM_MANAGER_INITIALIZED)
            {
                throw new RoomManagerException();
            }
            var _local_5= this.getRoom(k);
            if (_local_5 == null)
            {
                return null;
            }
            if (this._contentLoader == null)
            {
                return null;
            }
            var _local_6= Std.downcast(_local_5 , RoomInstance);
            if (_local_6 == null)
            {
                return null;
            }
            var _local_7:IGraphicAssetCollection = null;
            var _local_8:com.sulake.core.utils.xml.XML = null;
            var _local_9:com.sulake.core.utils.xml.XML = null;
            var _local_10:String;
            var _local_11:String;
            var _local_12= _arg_3;
            var _local_13 = false;
            if (!this._contentLoader.hasInternalContent(_arg_3))
            {
                _local_7 = this._contentLoader.getGraphicAssetCollection(_arg_3);
                if (_local_7 == null)
                {
                    _local_13 = true;
                    this._contentLoader.loadObjectContent(_arg_3, events);
                    _local_12 = this._contentLoader.getPlaceHolderType(_arg_3);
                    _local_7 = this._contentLoader.getGraphicAssetCollection(_local_12);
                }
                _local_8 = this._contentLoader.getVisualizationXML(_local_12);
                _local_9 = this._contentLoader.getLogicXML(_local_12);
                if (((_local_8 == null) || (_local_7 == null)))
                {
                    return null;
                }
                _local_10 = this._contentLoader.getVisualizationType(_local_12);
                _local_11 = this._contentLoader.getLogicType(_local_12);
            }
            else
            {
                _local_10 = _arg_3;
                _local_11 = _arg_3;
            }
            var _local_14= 1;
            var _local_15= _local_6.createObjectInternal(_arg_2, _local_14, _arg_3, _arg_4);
            var _local_16= Std.downcast(_local_15 , IRoomObjectController);
            if (_local_16 == null)
            {
                return null;
            }
            var _local_17= this._visualizationFactory.createRoomObjectVisualization(_local_10);
            if (_local_17 == null)
            {
                _local_5.disposeObject(_arg_2, _arg_4);
                return null;
            }
            _local_17.assetCollection = _local_7;
            _local_17.setExternalBaseUrls(context.configuration.getProperty("stories.image_url_base"), context.configuration.getProperty("extra_data_service_url"), context.configuration.getBoolean("extra_data_batches_enabled"));
            var _local_18:IRoomObjectVisualizationData;
            _local_18 = this._visualizationFactory.getRoomObjectVisualizationData(_local_12, _local_10, _local_8);
            if (!_local_17.initialize(_local_18))
            {
                _local_5.disposeObject(_arg_2, _arg_4);
                return null;
            }
            _local_16.setVisualization(_local_17);
            var _local_19= this._objectFactory.createRoomObjectLogic(_local_11);
            _local_16.setEventHandler(_local_19);
            if (((!(_local_19 == null)) && (!(_local_9 == null))))
            {
                _local_19.initialize(_local_9);
            }
            if (!_local_13)
            {
                _local_16.setInitialized(true);
            }
            this._contentLoader.roomObjectCreated(_local_16, k);
            return _local_16;
        }

        public function createRoomObjectManager():IRoomObjectManager
        {
            if (this._objectFactory != null)
            {
                return this._objectFactory.createRoomObjectManager();
            }
            return null;
        }

        public function isContentAvailable(k:String):Bool
        {
            if (this._contentLoader != null)
            {
                if (this._contentLoader.getGraphicAssetCollection(k) != null)
                {
                    return true;
                }
            }
            return false;
        }

        public function resetObjectContentToPlaceHolder(k:String):Bool
        {
            var _local_2:String;
            var _local_3:com.sulake.core.utils.xml.XML;
            var _local_4:com.sulake.core.utils.xml.XML;
            var _local_5:IGraphicAssetCollection;
            var _local_6:String;
            var _local_7:String;
            var _local_8:IRoomObjectVisualizationData;
            var _local_9:RoomInstance;
            var _local_10:Array<ASAny>;
            var _local_11:Int;
            var _local_12:Int;
            var _local_14:IRoomObjectController;
            var _local_15:IRoomObjectGraphicVisualization;
            var _local_16:IRoomObjectEventHandler;
            var _local_17 = false;
            if (k == null)
            {
                return false;
            }
            if ((((this._contentLoader == null) || (this._visualizationFactory == null)) || (this._objectFactory == null)))
            {
                return false;
            }
            _local_2 = this._contentLoader.getPlaceHolderType(k);
            if (_local_2 == null)
            {
                return false;
            }
            _local_3 = this._contentLoader.getVisualizationXML(_local_2);
            _local_4 = this._contentLoader.getLogicXML(_local_2);
            _local_5 = this._contentLoader.getGraphicAssetCollection(_local_2);
            if (((_local_3 == null) || (_local_5 == null)))
            {
                return false;
            }
            _local_6 = this._contentLoader.getVisualizationType(_local_2);
            _local_7 = this._contentLoader.getLogicType(_local_2);
            _local_8 = this._visualizationFactory.getRoomObjectVisualizationData(_local_2, _local_6, _local_3);
            var _local_18:Int = (this._rooms.length - 1);
            while (_local_18 >= 0)
            {
                _local_9 = ASCompat.dynamicAs(this._rooms.getWithIndex(_local_18) , RoomInstance);
                if (_local_9 != null)
                {
                    _local_10 = _local_9.getObjectManagerIds();
                    for (_tmp_ in _local_10)
                    {
_local_11  = ASCompat.toInt(_tmp_);
                        _local_12 = (_local_9.getObjectCountForType(k, _local_11) - 1);
                        while (_local_12 >= 0)
                        {
                            _local_14 = Std.downcast(_local_9.getObjectWithIndexAndType(_local_12, k, _local_11) , IRoomObjectController);
                            if (_local_14 != null)
                            {
                                _local_15 = this._visualizationFactory.createRoomObjectVisualization(_local_6);
                                if (_local_15 != null)
                                {
                                    _local_15.assetCollection = _local_5;
                                    _local_15.setExternalBaseUrls(context.configuration.getProperty("stories.image_url_base"), context.configuration.getProperty("extra_data_service_url"), context.configuration.getBoolean("extra_data_batches_enabled"));
                                    if (_local_15.initialize(_local_8))
                                    {
                                        _local_14.setVisualization(_local_15);
                                        _local_16 = this._objectFactory.createRoomObjectLogic(_local_7);
                                        _local_14.setEventHandler(_local_16);
                                        if (((_local_16 != null) && (_local_4 != null)))
                                        {
                                            _local_16.initialize(_local_4);
                                        }
                                        _local_14.setInitialized(false);
                                        _local_17 = true;
                                    }
                                    else
                                    {
                                        _local_15.dispose();
                                    }
                                }
                            }
                            _local_12--;
                        }
                    }
                }
                _local_18--;
            }
            return _local_17;
        }

        public function loadObjectContent(k:String):Bool
        {
            if (((k == null) || (this._contentLoader == null)))
            {
                return false;
            }
            return this._contentLoader.loadObjectContent(k, events);
        }

        function processInitialContentLoad(k:String)
        {
            var _local_2:Int;
            if (k == null)
            {
                return;
            }
            if (this._state == ROOM_MANAGER_ERROR)
            {
                return;
            }
            if (this._contentLoader == null)
            {
                this._state = ROOM_MANAGER_ERROR;
                return;
            }
            if (this._contentLoader.getGraphicAssetCollection(k) != null)
            {
                _local_2 = this._initialLoadList.indexOf(k);
                if (_local_2 >= 0)
                {
                    this._initialLoadList.splice(_local_2, 1);
                }
                if (this._initialLoadList.length == 0)
                {
                    this._state = ROOM_MANAGER_INITIALIZED;
                    if (this._listener != null)
                    {
                        this._listener.roomManagerInitialized(true);
                    }
                }
            }
            else
            {
                this._state = ROOM_MANAGER_ERROR;
                this._listener.roomManagerInitialized(false);
            }
        }

        function _Str_9536(k:RoomContentLoadedEvent)
        {
            if (this._contentLoader == null)
            {
                return;
            }
            var _local_2= k.contentType;
            if (_local_2 == null)
            {
                if (this._listener != null)
                {
                    this._listener.contentLoaded(null, false);
                }
                return;
            }
            if (this._unprocessedLoadedContentTypes.indexOf(_local_2) < 0)
            {
                this._unprocessedLoadedContentTypes.push(_local_2);
            }
        }

        function processLoadedContentTypes()
        {
            var _local_2:String;
            var _local_3:IGraphicAssetCollection;
            var _local_4:Int;
            if (this._skipContentProcessingForNextFrame)
            {
                this._skipContentProcessingForNextFrame = false;
                return;
            }
            var k= flash.Lib.getTimer();
            while (this._unprocessedLoadedContentTypes.length > 0)
            {
                _local_2 = this._unprocessedLoadedContentTypes[0];
                this._unprocessedLoadedContentTypes.splice(0, 1);
                if (!this._contentLoader.hasVisualizationXML(_local_2))
                {
                    if (this._listener != null)
                    {
                        this._listener.contentLoaded(_local_2, false);
                    }
                    return;
                }
                _local_3 = this._contentLoader.getGraphicAssetCollection(_local_2);
                if (_local_3 == null)
                {
                    if (this._listener != null)
                    {
                        this._listener.contentLoaded(_local_2, false);
                    }
                    return;
                }
                this.updateObjectContents(_local_2);
                if (this._listener != null)
                {
                    this._listener.contentLoaded(_local_2, true);
                }
                if (this._initialLoadList.length > 0)
                {
                    this.processInitialContentLoad(_local_2);
                }
                _local_4 = flash.Lib.getTimer();
                if ((((_local_4 - k) >= CONTENT_PROCESSING_TIME_LIMIT_MILLISECONDS) && this._limitContentProcessing))
                {
                    this._skipContentProcessingForNextFrame = true;
                    return;
                }
            }
        }

        function updateObjectContents(k:String)
        {
            var _local_2:com.sulake.core.utils.xml.XML;
            var _local_3:com.sulake.core.utils.xml.XML = null;
            var _local_4:IGraphicAssetCollection = null;
            var _local_7:IRoomObjectVisualizationData = null;
            var _local_9:RoomInstance;
            var _local_10:String;
            var _local_11:Array<ASAny>;
            var _local_12:Bool;
            var _local_13:Int;
            var _local_14:Int;
            var _local_15:Int;
            var _local_16:IRoomObjectController;
            var _local_17:IRoomObjectGraphicVisualization;
            var _local_18:IRoomObjectEventHandler;
            if (k == null)
            {
                return;
            }
            if (((this._contentLoader == null) || (this._visualizationFactory == null)))
            {
                return;
            }
            var _local_5= this._contentLoader.getVisualizationType(k);
            var _local_6= this._contentLoader.getLogicType(k);
            var _local_8:Int = (this._rooms.length - 1);
            while (_local_8 >= 0)
            {
                _local_9 = ASCompat.dynamicAs(this._rooms.getWithIndex(_local_8) , RoomInstance);
                _local_10 = this._rooms.getKey(_local_8);
                if (_local_9 != null)
                {
                    _local_11 = _local_9.getObjectManagerIds();
                    _local_12 = false;
                    for (_tmp_ in _local_11)
                    {
_local_13  = ASCompat.toInt(_tmp_);
                        _local_14 = _local_9.getObjectCountForType(k, _local_13);
                        _local_15 = (_local_14 - 1);
                        while (_local_15 >= 0)
                        {
                            _local_16 = Std.downcast(_local_9.getObjectWithIndexAndType(_local_15, k, _local_13) , IRoomObjectController);
                            if (_local_16 != null)
                            {
                                if (_local_7 == null)
                                {
                                    _local_2 = this._contentLoader.getVisualizationXML(k);
                                    if (_local_2 == null)
                                    {
                                        return;
                                    }
                                    _local_3 = this._contentLoader.getLogicXML(k);
                                    _local_4 = this._contentLoader.getGraphicAssetCollection(k);
                                    if (_local_4 == null)
                                    {
                                        return;
                                    }
                                    _local_7 = this._visualizationFactory.getRoomObjectVisualizationData(k, _local_5, _local_2);
                                }
                                _local_17 = this._visualizationFactory.createRoomObjectVisualization(_local_5);
                                if (_local_17 != null)
                                {
                                    _local_17.assetCollection = _local_4;
                                    _local_17.setExternalBaseUrls(context.configuration.getProperty("stories.image_url_base"), context.configuration.getProperty("extra_data_service_url"), context.configuration.getBoolean("extra_data_batches_enabled"));
                                    if (!_local_17.initialize(_local_7))
                                    {
                                        _local_9.disposeObject(_local_16.getId(), _local_13);
                                    }
                                    else
                                    {
                                        _local_16.setVisualization(_local_17);
                                        _local_18 = this._objectFactory.createRoomObjectLogic(_local_6);
                                        _local_16.setEventHandler(_local_18);
                                        if (_local_18 != null)
                                        {
                                            _local_18.initialize(_local_3);
                                        }
                                        _local_16.setInitialized(true);
                                        if (this._listener != null)
                                        {
                                            this._listener.objectInitialized(_local_10, _local_16.getId(), _local_13);
                                            _local_12 = true;
                                        }
                                    }
                                }
                                else
                                {
                                    _local_9.disposeObject(_local_16.getId(), _local_13);
                                }
                            }
                            _local_15--;
                        }
                    }
                    if (((!_local_9.hasUninitializedObjects()) && _local_12))
                    {
                        this._listener.objectsInitialized(_local_10);
                    }
                }
                _local_8--;
            }
        }

        public function update(k:UInt)
        {
            var _local_3:RoomInstance;
            this.processLoadedContentTypes();
            var _local_2:Int = (this._rooms.length - 1);
            while (_local_2 >= 0)
            {
                _local_3 = ASCompat.dynamicAs(this._rooms.getWithIndex(_local_2) , RoomInstance);
                if (_local_3 != null)
                {
                    _local_3.update();
                }
                _local_2--;
            }
        }
    }








