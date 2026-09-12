package com.sulake.habbo.avatar
;
    import com.sulake.core.runtime.Component;
    import com.sulake.habbo.avatar.alias.AssetAliasCollection;
    import com.sulake.core.utils.Map;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.runtime.ComponentDependency;
    import com.sulake.iid.IIDHabboConfigurationManager;
    import flash.events.Event;
    import com.sulake.habbo.avatar._enum.RenderMode;
    import com.sulake.core.assets.AssetLibraryCollection;
    import flash.net.URLRequest;
    import com.sulake.core.assets.loaders.AssetLoaderEvent;
    import com.sulake.habbo.avatar.structure.AvatarStructureDownload;
    import com.sulake.habbo.avatar.structure.IFigureSetData;
    import com.sulake.core.assets.IAsset;
    import com.sulake.habbo.avatar._enum.AvatarRenderEvent;
    import com.sulake.habbo.avatar.structure.IStructureData;
    import com.sulake.habbo.avatar.structure.figure.IFigurePartSet;
    import com.sulake.habbo.utils.FigureDataContainer;
    import com.sulake.habbo.avatar.animation.IAnimationManager;
    import com.sulake.habbo.avatar.structure.figure.ISetType;
    import com.sulake.core.utils.ErrorReportStorage;
    import com.sulake.habbo.avatar.structure.figure.IPalette;
    import com.sulake.habbo.avatar.structure.figure.IPartColor;
    import com.sulake.habbo.avatar._enum.AvatarSetType;
    import com.sulake.iid.*;

     class AvatarRenderManager extends Component implements IAvatarRenderManager 
    {
        /**
         * Animations shipped with the client rather than downloaded with an effect library.
         *
         * battleball_ride_animation poses a rider's arms. Bouncing Human Class puts the arms in a
         * different action from the rest of the figure -- sit for body/legs/shoes, carry for the hands
         * and sleeves -- and a bodypart animation is how this client expresses that. The alternative,
         * giving the avatar a carry item, is wrong: AvatarLogic runs an automatic sip timer on anything
         * held, so after five seconds the rider repeatedly raises it to their face.
         */
        static final BUILT_IN_ANIMATION_ASSET_NAMES:Array<ASAny> = ["dance_sixseven_animation", "battleball_ride_animation"];

        static inline final _Str_1161= "hd-99999-99999";

        var _aliasCollection:AssetAliasCollection;
        var _structure:AvatarStructure;
        var _mode:String;
        var _petImageListeners:Map;
        var _avatarAssetDownloadManager:AvatarAssetDownloadManager;
        var _effectAssetDownloadManager:EffectAssetDownloadManager;
        var _avatarPlaceholderFigure:AvatarFigureContainer;
        var _figureMapReady:Bool = false;
        var _structureReady:Bool = false;
        var _isReady:Bool = false;
        var _inNuxFlow:Bool = false;
        var _actionsAreReady:Bool = false;
        var _effectMapReady:Bool = false;

        public function new(k:IContext, _arg_2:UInt, _arg_3:IAssetLibrary, _arg_4:Bool=false)
        {
            this._inNuxFlow = _arg_4;
            _arg_2 = (ASCompat.toInt(_arg_2 )| ASCompat.toInt(Component.COMPONENT_FLAG_INTERFACE));
            super(k, _arg_2, _arg_3);
        }

        override function  get_dependencies():Vector<ComponentDependency>
        {
            return (this._inNuxFlow ? super.dependencies : super.dependencies.concat(Vector.ofArray([new ComponentDependency(new IIDHabboConfigurationManager(), null, true, [{
			"type":Event.COMPLETE,
			"callback":this.onConfigurationComplete
			}])])));
        }

        override function initComponent()
        {
            this._mode = RenderMode.COMPONENT;
            this._petImageListeners = new Map();
            var k= new com.sulake.core.utils.xml.XML("<actions><action id=\"Default\" precedence=\"1000\" state=\"std\" main=\"1\" isdefault=\"1\" geometrytype=\"vertical\" activepartset=\"figure\" assetpartdefinition=\"std\"/></actions>")
            ;
            this._structure = new AvatarStructure(this);
            this._structure.initGeometry((assets.hasAsset("HabboAvatarGeometry") ? ((assets.getAssetByName("HabboAvatarGeometry").content : com.sulake.core.utils.xml.XML) ) : null));
            this._structure.initPartSets((assets.hasAsset("HabboAvatarPartSets") ? ((assets.getAssetByName("HabboAvatarPartSets").content : com.sulake.core.utils.xml.XML) ) : null));
            this._structure.initActions(assets, k);
            this._structure.initAnimation((assets.hasAsset("HabboAvatarAnimation") ? ((assets.getAssetByName("HabboAvatarAnimation").content : com.sulake.core.utils.xml.XML) ) : null));
            this._structure.initFigureData((assets.hasAsset("HabboAvatarFigure") ? ((assets.getAssetByName("HabboAvatarFigure").content : com.sulake.core.utils.xml.XML) ) : null));
            this._Str_1200();
            this._aliasCollection = new AssetAliasCollection(this, Std.downcast(context.assets , AssetLibraryCollection));
            this._aliasCollection.init();
            this.createStructure();
        }

        function _Str_1200()
        {
            var k:ASAny = (getProperty("flash.dynamic.avatar.download.url") + "HabboAvatarActions.xml");
            var _local_2= new URLRequest(k);
            var _local_3= assets.loadAssetFromFile("HabboAvatarActions", _local_2, "text/xml");
            _local_3.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTCOMPLETE, this.onAvatarAssetsLibraryReady);
        }

        function onAvatarAssetsLibraryReady(k:Event=null)
        {
            if (this._structure == null)
            {
                return;
            }
            var _local_2= new com.sulake.core.utils.xml.XML("<actions><action id=\"Default\" precedence=\"1000\" state=\"std\" main=\"1\" isdefault=\"1\" geometrytype=\"vertical\" activepartset=\"figure\" assetpartdefinition=\"std\"/></actions>")
            ;
            this._structure.updateActions((assets.hasAsset("HabboAvatarActions") ? ((assets.getAssetByName("HabboAvatarActions").content : com.sulake.core.utils.xml.XML) ) : _local_2));
            this.registerBuiltInAnimations();
            this._actionsAreReady = true;
            this.createStructure();
        }

        /**
         * hasAsset() is true for anything the component class embeds, but getAssetByName() only builds
         * an asset for names the manifest declares -- an embed without its manifest row returns null
         * here. Dereferencing that would throw before _actionsAreReady is set and take every avatar
         * down with it, so the asset is captured and checked rather than trusted.
         */
        function registerBuiltInAnimations()
        {
            var k:String = null;
            var _local_2:IAsset = null;
            var _local_3:com.sulake.core.utils.xml.XML = null;
            final _iter_ = BUILT_IN_ANIMATION_ASSET_NAMES; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                _local_2 = assets.hasAsset(k) ? assets.getAssetByName(k) : null;
                if (_local_2 == null)
                {
                    Logger.log(["Avatar animation asset is embedded but not declared in the manifest: " + k]);
                    continue;
                }
                _local_3 = (_local_2.content : com.sulake.core.utils.xml.XML) ;
                if (_local_3 != null)
                {
                    this._structure.registerAnimation(_local_3);
                }
            }
        }

        override public function dispose()
        {
            super.dispose();
            if (this._structure != null)
            {
                this._structure.dispose();
                this._structure = null;
            }
            if (this._aliasCollection != null)
            {
                this._aliasCollection.dispose();
                this._aliasCollection = null;
            }
            if (this._petImageListeners != null)
            {
                this._petImageListeners.dispose();
                this._petImageListeners = null;
            }
            if (this._avatarAssetDownloadManager != null)
            {
                this._avatarAssetDownloadManager.removeEventListener(Event.COMPLETE, this._Str_1656);
                this._avatarAssetDownloadManager.dispose();
                this._avatarAssetDownloadManager = null;
            }
            if (this._effectAssetDownloadManager != null)
            {
                this._effectAssetDownloadManager.removeEventListener(Event.COMPLETE, this._Str_1656);
                this._effectAssetDownloadManager.dispose();
                this._effectAssetDownloadManager = null;
            }
        }

        function onConfigurationComplete(k:Event)
        {
            var _local_2:String = null;
            var _local_3:AvatarStructureDownload = null;
            var _local_4:String = null;
            var _local_5:String = null;
            var _local_6:String = null;
            var _local_7:String = null;
            if (this._structure != null)
            {
                _local_2 = getProperty("external.figurepartlist.txt");
                if (assets.hasAsset(_local_2))
                {
                    assets.removeAsset(assets.getAssetByName(_local_2));
                }
                _local_3 = new AvatarStructureDownload(assets, _local_2, ASCompat.reinterpretAs(this._structure.figureData , IFigureSetData));
                _local_3.addEventListener(AvatarStructureDownload.AVATAR_STRUCTURE_DONE, this._Str_1521);
                if (this._avatarAssetDownloadManager == null)
                {
                    _local_4 = getProperty("flash.dynamic.avatar.download.configuration");
                    _local_5 = getProperty("flash.dynamic.avatar.download.url");
                    _local_6 = getProperty("flash.dynamic.avatar.download.name.template");
                    this._avatarAssetDownloadManager = new AvatarAssetDownloadManager(context.assets, _local_4, _local_5, this._structure, _local_6);
                    this._avatarAssetDownloadManager.addEventListener(Event.COMPLETE, this._Str_1656);
                    this._avatarAssetDownloadManager.addEventListener(AvatarAssetDownloadManager.LIBRARY_LOADED, this._Str_1154);
                }
                if (this._effectAssetDownloadManager == null)
                {
                    _local_7 = (getProperty("flash.dynamic.avatar.download.url") + "effectmap.xml");
                    _local_5 = getProperty("flash.dynamic.avatar.download.url");
                    _local_6 = getProperty("flash.dynamic.avatar.download.name.template");
                    this._effectAssetDownloadManager = new EffectAssetDownloadManager(context.assets, _local_7, _local_5, this._structure, _local_6);
                    this._effectAssetDownloadManager.addEventListener(Event.COMPLETE, this._Str_1528);
                    this._effectAssetDownloadManager.addEventListener(AvatarAssetDownloadManager.LIBRARY_LOADED, this._Str_1613);
                }
            }
        }

        function _Str_1154(k:Event=null)
        {
            this._aliasCollection.reset();
        }

        function _Str_1613(k:Event=null)
        {
            this._aliasCollection.reset();
        }

        function _Str_1521(k:Event=null)
        {
            var _local_2= assets.getAssetByName(getProperty("external.figurepartlist.txt"));
            if (_local_2 != null)
            {
                assets.removeAsset(_local_2).dispose();
            }
            this._structureReady = true;
            this._structure.init();
            this.createStructure();
        }

        function _Str_1656(k:Event=null)
        {
            this._figureMapReady = true;
            this.createStructure();
        }

        function _Str_1528(k:Event=null)
        {
            this._effectMapReady = true;
            this.createStructure();
        }

        public var _Str_906(get,never):ASDictionary<ASAny,ASAny>;
public function  get__Str_906():ASDictionary<ASAny,ASAny>
        {
            if (this._effectMapReady)
            {
                return this._effectAssetDownloadManager._Str_1452;
            }
            return null;
        }

        function createStructure()
        {
            if (!this._isReady)
            {
                if ((((this._figureMapReady && this._structureReady) && this._actionsAreReady) && this._effectMapReady))
                {
                    this._isReady = true;
                    this.events.dispatchEvent(new Event(AvatarRenderEvent.AVATAR_RENDER_READY));
                }
            }
        }

        public function _Str_718(k:String):IAvatarFigureContainer
        {
            return new AvatarFigureContainer(k);
        }

        public function _Str_961(k:IAvatarFigureContainer):Bool
        {
            if (this._avatarAssetDownloadManager == null)
            {
                return false;
            }
            return this._avatarAssetDownloadManager.isReady(k);
        }

        public function _Str_889(k:IAvatarFigureContainer, _arg_2:IAvatarImageListener)
        {
            if (this._avatarAssetDownloadManager == null)
            {
                return;
            }
            this._avatarAssetDownloadManager._Str_1320(k, _arg_2);
        }

        public function createAvatarImage(figure:String, _arg_2:String, gender:String=null, _arg_4:IAvatarImageListener=null, _arg_5:_Str_936=null):IAvatarImage
        {
            if (this._structure == null)
            {
                return null;
            }
            if (((!(this._avatarAssetDownloadManager != null)) && (!(this._mode == RenderMode.LOCAL_ONLY))))
            {
                return null;
            }
            var figureContainer= new AvatarFigureContainer(figure);
            if (ASCompat.stringAsBool(gender))
            {
                this.validateAvatarFigure(figureContainer, gender);
            }
            if (((this._mode == RenderMode.LOCAL_ONLY) || this._avatarAssetDownloadManager.isReady(figureContainer)))
            {
                return new AvatarImage(this._structure, this._aliasCollection, figureContainer, _arg_2, this._effectAssetDownloadManager, _arg_5);
            }
            if (this._avatarPlaceholderFigure == null)
            {
                this._avatarPlaceholderFigure = new AvatarFigureContainer(AvatarRenderManager._Str_1161);
            }
            this._avatarAssetDownloadManager._Str_1320(figureContainer, _arg_4);
            return new PlaceholderAvatarImage(this._structure, this._aliasCollection, this._avatarPlaceholderFigure, _arg_2, this._effectAssetDownloadManager);
        }

        public function _Str_813():IStructureData
        {
            if (this._structure != null)
            {
                return this._structure.figureData;
            }
            return null;
        }

        public function isValidFigureSetForGender(k:Int, _arg_2:String):Bool
        {
            var _local_3= this._Str_813();
            var _local_4= _local_3._Str_938(k);
            if (_local_4 != null)
            {
                if (((_local_4.gender.toUpperCase() == "U") || (_local_4.gender.toUpperCase() == _arg_2.toUpperCase())))
                {
                    return true;
                }
            }
            return false;
        }

        public function getFigureStringWithFigureIds(k:String, _arg_2:String, _arg_3:Vector<Int>):String
        {
            var _local_6:IFigurePartSet = null;
            var _local_4= new FigureDataContainer();
            _local_4._Str_2153(k, _arg_2);
            var _local_5= this._Str_1667(_arg_3);
            if (checkNullIteratee(_local_5)) for (_tmp_ in _local_5)
            {
_local_6  = _tmp_;
                _local_4._Str_2088(_local_6.type, _local_6.id, _local_4.getColourIds(_local_6.type));
            }
            return _local_4.getFigureString();
        }

        function _Str_1667(k:Vector<Int>):Vector<IFigurePartSet>
        {
            var _local_4 = 0;
            var _local_5:IFigurePartSet = null;
            var _local_2= this._Str_813();
            var _local_3= new Vector<IFigurePartSet>(0);
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_4  = _tmp_;
                _local_5 = _local_2._Str_938(_local_4);
                if (_local_5 != null)
                {
                    _local_3.push(_local_5);
                }
            }
            return _local_3;
        }

        public function _Str_672():Array<ASAny>
        {
            return this._structure._Str_672();
        }

        public function _Str_723():IAnimationManager
        {
            if (this._structure != null)
            {
                return this._structure.animationManager;
            }
            return null;
        }

        public function _Str_838(k:String, _arg_2:Int):Array<ASAny>
        {
            if (this._structure != null)
            {
                return this._structure.getMandatorySetTypeIds(k, _arg_2);
            }
            return null;
        }

        public function getAssetByName(k:String):IAsset
        {
            return this._aliasCollection.getAssetByName(k);
        }

        
        public var mode(get,set):String;
public function  get_mode():String
        {
            return this._mode;
        }
public function  set_mode(k:String):String        {
            return this._mode = k;
        }

        public function _Str_882(k:com.sulake.core.utils.xml.XML)
        {
            if (this._structure != null)
            {
                this._structure._Str_882(k);
            }
        }

        function validateAvatarFigure(k:AvatarFigureContainer, _arg_2:String):Bool
        {
            var _local_3 = false;
            var figureData:IStructureData = null;
            var _local_7:String = null;
            var _local_8:IFigurePartSet = null;
            var setType:ISetType = null;
            var _local_10:IFigurePartSet = null;
            var _local_11:IFigurePartSet = null;
            if (this._structure == null)
            {
                ErrorReportStorage.addDebugData("AvatarRenderManager", "validateAvatarFigure: structure is null!");
            }
            var _local_4= 2;
            var _local_5= this._structure.getMandatorySetTypeIds(_arg_2, _local_4);
            if (_local_5 != null)
            {
                figureData = this._structure.figureData;
                if (figureData == null)
                {
                    ErrorReportStorage.addDebugData("AvatarRenderManager", "validateAvatarFigure: figureData is null!");
                }
                if (checkNullIteratee(_local_5)) for (_tmp_ in _local_5)
                {
_local_7  = _tmp_;
                    if (!k._Str_744(_local_7))
                    {
                        _local_8 = this._structure._Str_2264(_local_7, _arg_2);
                        if (_local_8 != null)
                        {
                            k._Str_830(_local_7, _local_8.id, [0]);
                            _local_3 = true;
                        }
                    }
                    else
                    {
                        setType = figureData._Str_740(_local_7);
                        if (setType == null)
                        {
                            ErrorReportStorage.addDebugData("AvatarRenderManager", "validateAvatarFigure: setType is null!");
                        }
                        _local_10 = setType._Str_1020(k.getPartSetId(_local_7));
                        if (_local_10 == null)
                        {
                            _local_11 = this._structure._Str_2264(_local_7, _arg_2);
                            if (_local_11 != null)
                            {
                                k._Str_830(_local_7, _local_11.id, [0]);
                                _local_3 = true;
                            }
                        }
                    }
                }
            }
            return !_local_3;
        }

        public function _Str_932(k:IAvatarFigureContainer, _arg_2:String, _arg_3:Array<ASAny>=null):Int
        {
            var _local_6:String = null;
            var _local_7:ISetType = null;
            var _local_9:String = null;
            var _local_10 = 0;
            var _local_11:IFigurePartSet = null;
            var _local_12:IPalette = null;
            var _local_13:Array<ASAny> = null;
            var _local_14 = 0;
            var _local_15:IPartColor = null;
            var _local_4 = 0;
            if (this._structure == null)
            {
                return 0;
            }
            var _local_5= this._structure.figureData;
            var _local_8= k._Str_1016();
            if (checkNullIteratee(_local_8)) for (_tmp_ in _local_8)
            {
_local_6  = _tmp_;
                _local_7 = _local_5._Str_740(_local_6);
                _local_10 = k.getPartSetId(_local_6);
                _local_11 = _local_7._Str_1020(_local_10);
                if (_local_11 == null)
                {
                }
                else
                {
                    _local_4 = Std.int(Math.max(_local_11.clubLevel, _local_4));
                    _local_12 = _local_5.getPalette(_local_7._Str_734);
                    _local_13 = k._Str_815(_local_6);
                    if (checkNullIteratee(_local_13)) for (_tmp_ in _local_13)
                    {
_local_14  = ASCompat.toInt(_tmp_);
                        _local_15 = _local_12.getColor(_local_14);
                        _local_4 = Std.int(Math.max(_local_15.clubLevel, _local_4));
                    }
                }
            }
            if (_arg_3 == null)
            {
                _arg_3 = this._structure.getBodyPartsUnordered(AvatarSetType.FULL);
            }
            if (checkNullIteratee(_arg_3)) for (_tmp_ in _arg_3)
            {
_local_9  = _tmp_;
                _local_7 = _local_5._Str_740(_local_9);
                if (_local_8.indexOf(_local_9) == -1)
                {
                    _local_4 = Std.int(Math.max(_local_7._Str_1002(_arg_2), _local_4));
                }
            }
            return _local_4;
        }

        public function resetAssetManager()
        {
            this._aliasCollection.reset();
        }

        public var isReady(get,never):Bool;
public function  get_isReady():Bool
        {
            return this._isReady;
        }
    }

