package com.sulake.habbo.avatar
;
    import com.sulake.habbo.avatar.structure.IStructureData;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.avatar.common.IAvatarEditorCategoryModel;
    import com.sulake.habbo.avatar.common.ISideContentModel;
    import com.sulake.habbo.avatar._enum.AvatarEditorSideCategory;
    import com.sulake.habbo.avatar.wardrobe.WardrobeModel;
    import com.sulake.habbo.avatar.figuredata.FigureData;
    import com.sulake.habbo.avatar._enum.AvatarEditorFigureCategory;
    import com.sulake.habbo.avatar.generic.BodyModel;
    import com.sulake.habbo.avatar.head.HeadModel;
    import com.sulake.habbo.avatar.torso.TorsoModel;
    import com.sulake.habbo.avatar.legs.LegsModel;
    import com.sulake.habbo.avatar.misc.MiscModel;
    import com.sulake.habbo.avatar.hotlooks.HotLooksModel;
    import com.sulake.habbo.avatar.effects.EffectsModel;
    import com.sulake.habbo.avatar.structure.figure.ISetType;
    import com.sulake.habbo.avatar.structure.figure.IPalette;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.communication.messages.outgoing.register.UpdateFigureDataMessageComposer;
    import com.sulake.habbo.avatar.events.AvatarUpdateEvent;
    import com.sulake.habbo.avatar.structure.figure.IFigurePartSet;
    import com.sulake.habbo.avatar.common.AvatarEditorGridPartItem;
    import com.sulake.habbo.avatar.structure.figure.IPartColor;
    import com.sulake.habbo.avatar.common.AvatarEditorGridColorItem;
    import com.sulake.core.assets.BitmapDataAsset;
    import flash.display.BitmapData;
    import com.sulake.habbo.avatar.common.AvatarEditorGridView;
    import com.sulake.habbo.avatar.common.CategoryData;
    import com.sulake.habbo.avatar._enum.AvatarEditorInstanceId;

     class HabboAvatarEditor 
    {
        static inline final DEFAULT_MALE_FIGURE= "hr-100.hd-180-7.ch-215-66.lg-270-79.sh-305-62.ha-1002-70.wa-2007";
        static inline final DEFAULT_FEMALE_FIGURE= "hr-515-33.hd-600-1.ch-635-70.lg-716-66-62.sh-735-68";
        static inline final MAX_COLOR_LAYERS= 2;

        var _instanceId:UInt = 0;
        var _manager:HabboAvatarEditorManager;
        var _figureStructureData:IStructureData;
        var _view:AvatarEditorView;
        var _isInitialized:Bool = false;
        var _categories:Map;
        var _sideContents:Map;
        var _figures:ASDictionary<ASAny,ASAny>;
        var _gender:String = "M";
        var _figureString:String;
        var _editorSaver:_Str_5523 = null;
        var _enableSideContent:Bool = false;
        var _avatarEffectChanged:Bool = false;
        var _clubMemberLevel:Int = 0;
        var _forceSellableClothingVisibility:Bool = false;

        public function new(k:UInt, _arg_2:HabboAvatarEditorManager, _arg_3:Bool=false)
        {
            this._instanceId = k;
            this._manager = _arg_2;
            this._figureStructureData = this._manager.avatarRenderManager._Str_813();
            this._forceSellableClothingVisibility = _arg_3;
        }

        public function dispose()
        {
            var k:IAvatarEditorCategoryModel = null;
            var _local_2:ISideContentModel = null;
            if (this._categories != null)
            {
                final _iter_ = this._categories; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
                {
k  = _tmp_;
                    k.dispose();
                    k = null;
                }
                this._categories = null;
            }
            if (this._sideContents != null)
            {
                final _iter_ = this._sideContents; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
                {
_local_2  = _tmp_;
                    _local_2.dispose();
                    _local_2 = null;
                }
                this._sideContents = null;
            }
            if (this._view != null)
            {
                this._view.dispose();
                this._view = null;
            }
            this._figureStructureData = null;
            this._figures = null;
            this._editorSaver = null;
        }

        function init(k:Array<ASAny>=null)
        {
            if (this._isInitialized)
            {
                return;
            }
            this._categories = new Map();
            this._sideContents = new Map();
            this._sideContents.add(AvatarEditorSideCategory.WARDROBE, new WardrobeModel(this));
            this._categories.add(AvatarEditorFigureCategory.GENERIC, new BodyModel(this));
            this._categories.add(AvatarEditorFigureCategory.HEAD, new HeadModel(this));
            this._categories.add(AvatarEditorFigureCategory.TORSO, new TorsoModel(this));
            this._categories.add(AvatarEditorFigureCategory.LEGS, new LegsModel(this));
            this._categories.add(AvatarEditorFigureCategory.MISC, new MiscModel(this));
            if (((k == null) || (k.indexOf(AvatarEditorFigureCategory.HOTLOOKS) > -1)))
            {
                this._categories.add(AvatarEditorFigureCategory.HOTLOOKS, new HotLooksModel(this));
            }
            this._categories.add(AvatarEditorFigureCategory.EFFECTS, new EffectsModel(this));
            if (k == null)
            {
                k = [AvatarEditorFigureCategory.GENERIC, AvatarEditorFigureCategory.HEAD, AvatarEditorFigureCategory.TORSO, AvatarEditorFigureCategory.LEGS, AvatarEditorFigureCategory.HOTLOOKS, AvatarEditorFigureCategory.WARDROBE];
                if (this._manager.getBoolean("effects.in.avatar.editor"))
                {
                    k.push(AvatarEditorFigureCategory.EFFECTS);
                }
                if (this._manager.getBoolean("clothing.misc.tab.enabled"))
                {
                    k.push(AvatarEditorFigureCategory.MISC);
                }
            }
            this._view = new AvatarEditorView(this, k);
            this._figures = new ASDictionary<ASAny,ASAny>();
            this._figures[FigureData.M] = new FigureData(this);
            this._figures[FigureData.F] = new FigureData(this);
            var _local_2:FigureData = this._figures[FigureData.M];
            var _local_3:FigureData = this._figures[FigureData.F];
            _local_2.loadAvatarData(DEFAULT_MALE_FIGURE, FigureData.M);
            _local_3.loadAvatarData(DEFAULT_FEMALE_FIGURE, FigureData.F);
            this._isInitialized = true;
        }

        public function loadAvatarInEditor(k:String, _arg_2:String, _arg_3:Int=0)
        {
            var _local_6:IAvatarEditorCategoryModel = null;
            switch (_arg_2)
            {
                case FigureData.M
                   | "m"
                   | "M":
                    _arg_2 = FigureData.M;
                    
                case FigureData.F
                   | "f"
                   | "F":
                    _arg_2 = FigureData.F;
                    
                default:
                    _arg_2 = FigureData.M;
            }
            this.clubMemberLevel = _arg_3;
            var _local_4 = false;
            var _local_5:FigureData = this._figures[_arg_2];
            if (_local_5 == null)
            {
                return;
            }
            _local_5.loadAvatarData(k, _arg_2);
            if (_arg_2 != this.gender)
            {
                this.gender = _arg_2;
                _local_4 = true;
            }
            if (this._figureString != k)
            {
                this._figureString = k;
                _local_4 = true;
            }
            if (((this._categories != null) && _local_4))
            {
                final _iter_ = this._categories; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
                {
_local_6  = _tmp_;
                    _local_6.reset();
                }
            }
            if (this._view != null)
            {
                this._view.update();
            }
        }

        public function getFigureSetType(k:String):ISetType
        {
            if (this._figureStructureData == null)
            {
                return null;
            }
            return this._figureStructureData._Str_740(k);
        }

        public function getPalette(k:Int):IPalette
        {
            if (this._figureStructureData == null)
            {
                return null;
            }
            return this._figureStructureData.getPalette(k);
        }

        public function openWindow(k:_Str_5523, _arg_2:Array<ASAny>=null, _arg_3:Bool=false, _arg_4:String=null, _arg_5:String="generic"):IFrameWindow
        {
            this._editorSaver = k;
            this._enableSideContent = _arg_3;
            this.init(_arg_2);
            this.selectDefaultCategory(_arg_2, _arg_5);
            return this._view.getFrame(_arg_2, _arg_4);
        }

        public function embedToContext(k:IWindowContainer=null, _arg_2:_Str_5523=null, _arg_3:Array<ASAny>=null, _arg_4:Bool=false):Bool
        {
            this._editorSaver = _arg_2;
            this._enableSideContent = _arg_4;
            this.init(_arg_3);
            this._view._Str_13533(k, _arg_3);
            this.selectDefaultCategory(_arg_3);
            return true;
        }

        function selectDefaultCategory(k:Array<ASAny>, _arg_2:String="generic")
        {
            var _local_3= ((!(k == null)) && (k.length > 0));
            if (((!(_arg_2 == null)) && ((!_local_3) || (k.indexOf(_arg_2) >= 0))))
            {
                this._Str_14039(_arg_2);
            }
            else
            {
                if (_local_3)
                {
                    this._Str_14039(k[0]);
                }
                else
                {
                    this._Str_14039(AvatarEditorFigureCategory.GENERIC);
                }
            }
        }

        public var instanceId(get,never):UInt;
public function  get_instanceId():UInt
        {
            return this._instanceId;
        }

        public function hide()
        {
            this._view.hide();
        }

        public function getCategoryWindowContainer(k:String):IWindow
        {
            var _local_2= ASCompat.dynamicAs(this._categories.getValue(k) , IAvatarEditorCategoryModel);
            if (_local_2 != null)
            {
                return _local_2.getWindowContainer();
            }
            return null;
        }

        public function activateCategory(k:String)
        {
            var _local_2= ASCompat.dynamicAs(this._categories.getValue(k) , IAvatarEditorCategoryModel);
            if (_local_2 != null)
            {
                _local_2.switchCategory();
            }
        }

        public function getSideContentWindowContainer(k:String):IWindowContainer
        {
            var _local_2= ASCompat.dynamicAs(this._sideContents.getValue(k) , ISideContentModel);
            if (_local_2 != null)
            {
                return _local_2.getWindowContainer();
            }
            return null;
        }

        public function _Str_14039(k:String)
        {
            if (this._view != null)
            {
                this._view.toggleCategoryView(k, false);
            }
        }

        public function _Str_26108()
        {
            if (this._categories == null)
            {
                return;
            }
            this.update();
        }

        public function _Str_21039()
        {
            if (this._categories == null)
            {
                return;
            }
            this.update();
        }

        public var figureData(get,never):FigureData;
public function  get_figureData():FigureData
        {
            return this._figures[this._gender];
        }

        public function saveCurrentSelection()
        {
            var _local_3:UpdateFigureDataMessageComposer = null;
            var k= this.figureData.getFigureString();
            var _local_2= this.figureData.gender;
            if (this._editorSaver != null)
            {
                this._editorSaver._Str_21941(k, _local_2);
            }
            else
            {
                _local_3 = new UpdateFigureDataMessageComposer(k, _local_2);
                this._manager.communication.connection.send(_local_3);
                this._manager.events.dispatchEvent(new AvatarUpdateEvent(k));
                _local_3.dispose();
                _local_3 = null;
                if (this._avatarEffectChanged)
                {
                    if (this.figureData.avatarEffectType != -1)
                    {
                        this._manager.inventory.setEffectSelected(this.figureData.avatarEffectType);
                    }
                    else
                    {
                        this._manager.inventory.deselectAllEffects(true);
                    }
                }
                this._avatarEffectChanged = false;
            }
        }

        public function generateDataContent(k:IAvatarEditorCategoryModel, _arg_2:String):CategoryData
        {
            var _local_5 = 0;
            var _local_6:IFigurePartSet = null;
            var _local_7:AvatarEditorGridPartItem = null;
            var _local_8:ISetType = null;
            var _local_9:IPalette = null;
            var _local_10:Array<ASAny> = null;
            var _local_11:Array<ASAny> = null;
            var _local_12 = false;
            var _local_13:IPartColor = null;
            var _local_14:Array<ASAny> = null;
            var _local_15 = false;
            var _local_16 = false;
            var _local_17:Map = null;
            var _local_18 = 0;
            var _local_19 = 0;
            var _local_20 = 0;
            var _local_21 = false;
            var _local_22:AvatarEditorGridColorItem = null;
            var _local_23 = 0;
            var _local_24 = 0;
            var _local_25:BitmapDataAsset = null;
            var _local_26:BitmapData = null;
            var _local_27:IWindowContainer = null;
            var _local_28 = false;
            var _local_29 = false;
            var _local_30 = false;
            var _local_31:BitmapDataAsset = null;
            var _local_32:BitmapData = null;
            var _local_33:IWindowContainer = null;
            var _local_34:Array<ASAny> = null;
            if (k == null)
            {
                return null;
            }
            if (!ASCompat.stringAsBool(_arg_2))
            {
                return null;
            }
            var _local_3:Array<ASAny> = [];
            var _local_4= new Array<ASAny>();
            _local_5 = 0;
            while (_local_5 < MAX_COLOR_LAYERS)
            {
                _local_4.push(new Array<ASAny>());
                _local_5++;
            }
            _local_8 = this.getFigureSetType(_arg_2);
            if (_local_8 == null)
            {
                return null;
            }
            if (_local_8 != null)
            {
                _local_9 = this.getPalette(_local_8._Str_734);
                if (_local_9 == null)
                {
                    return null;
                }
                _local_10 = this.figureData.getColourIds(_arg_2);
                if (_local_10 == null)
                {
                    _local_10 = new Array<ASAny>();
                }
                _local_11 = ASCompat.allocArray(_local_10.length);
                _local_12 = this.showClubItemsDimmedConfiguration();
                final _iter_ = _local_9.colors; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_13  = _tmp_;
                    if ((_local_13.isSelectable && (_local_12 || (this.clubMemberLevel >= _local_13.clubLevel))))
                    {
                        _local_20 = 0;
                        while (_local_20 < MAX_COLOR_LAYERS)
                        {
                            _local_21 = (this.clubMemberLevel < _local_13.clubLevel);
                            _local_22 = new AvatarEditorGridColorItem(Std.downcast(AvatarEditorView._Str_8604.clone() , IWindowContainer), k, _local_13, _local_21);
                            _local_4[_local_20].push(_local_22);
                            _local_20++;
                        }
                        if (_arg_2 != FigureData.FACE)
                        {
                            _local_23 = 0;
                            while (_local_23 < _local_10.length)
                            {
                                if (_local_13.id == _local_10[_local_23])
                                {
                                    _local_11[_local_23] = _local_13;
                                }
                                _local_23++;
                            }
                        }
                    }
                }
                if (_local_12)
                {
                    _local_24 = 2;
                    _local_14 = this._manager.avatarRenderManager._Str_838(this.gender, _local_24);
                }
                else
                {
                    _local_14 = this._manager.avatarRenderManager._Str_838(this.gender, this.clubMemberLevel);
                }
                _local_15 = (_local_14.indexOf(_arg_2) == -1);
                if (_local_15)
                {
                    _local_25 = Std.downcast(this._manager.windowManager.assets.getAssetByName("avatar_editor_generic_remove_selection") , BitmapDataAsset);
                    _local_26 = ASCompat.dynamicAs(_local_25.content , BitmapData).clone();
                    _local_27 = Std.downcast(AvatarEditorView._Str_6802.clone() , IWindowContainer);
                    _local_27.name = AvatarEditorGridView.REMOVE_ITEM;
                    _local_7 = new AvatarEditorGridPartItem(_local_27, k, null, null, false);
                    _local_7.icon = _local_26;
                    _local_3.push(_local_7);
                }
                _local_16 = (!(_arg_2 == FigureData.FACE));
                _local_17 = _local_8._Str_710;
                _local_18 = ASCompat.toInt(_local_17.length);
                _local_19 = (_local_18 - 1);
                while (_local_19 >= 0)
                {
                    _local_6 = _local_17.getWithIndex(_local_19);
                    _local_28 = false;
                    if (_local_6.gender == FigureData.U)
                    {
                        _local_28 = true;
                    }
                    else
                    {
                        if (_local_6.gender == this.gender)
                        {
                            _local_28 = true;
                        }
                    }
                    if (((_local_6.isSelectable && _local_28) && (_local_12 || (this.clubMemberLevel >= _local_6.clubLevel))))
                    {
                        _local_29 = (this.clubMemberLevel < _local_6.clubLevel);
                        _local_30 = true;
                        if (_local_6.isSellable)
                        {
                            _local_30 = (((this.manager.inventory != null) && this._manager.inventory.hasFigureSetIdInInventory(_local_6.id)) || this.isDevelopmentEditor());
                        }
                        if (_local_30)
                        {
                            _local_7 = new AvatarEditorGridPartItem(Std.downcast(AvatarEditorView._Str_6802.clone() , IWindowContainer), k, _local_6, _local_11, _local_16, _local_29);
                            _local_3.push(_local_7);
                        }
                    }
                    _local_19--;
                }
            }
            ASCompat.ASArray.sort(_local_3, (this.showClubItemsFirst ? this._Str_25189 : this._Str_23935));
            if ((this._forceSellableClothingVisibility || this._manager.getBoolean("avatareditor.support.sellablefurni")))
            {
                _local_31 = Std.downcast(this._manager.windowManager.assets.getAssetByName("camera_zoom_in") , BitmapDataAsset);
                _local_32 = ASCompat.dynamicAs(_local_31.content , BitmapData).clone();
                _local_33 = Std.downcast(AvatarEditorView._Str_6802.clone() , IWindowContainer);
                _local_33.name = AvatarEditorGridView.GET_MORE;
                _local_7 = new AvatarEditorGridPartItem(_local_33, k, null, null, false);
                _local_7.icon = _local_32;
                _local_3.push(_local_7);
            }
            _local_5 = 0;
            while (_local_5 < MAX_COLOR_LAYERS)
            {
                _local_34 = ASCompat.dynamicAs(_local_4[_local_5] , Array);
                ASCompat.ASArray.sort(_local_34, this._Str_23625);
                _local_5++;
            }
            return new CategoryData(_local_3, _local_4);
        }

        public function isSideContentEnabled():Bool
        {
            return this._enableSideContent;
        }

        public function _Str_16127():Bool
        {
            var k:IAvatarEditorCategoryModel = null;
            var _local_2 = false;
            final _iter_ = this._categories.getValues(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                _local_2 = k._Str_20411(this.clubMemberLevel);
                if (_local_2)
                {
                    return true;
                }
            }
            return false;
        }

        public function _Str_7960():Bool
        {
            var k:IAvatarEditorCategoryModel = null;
            var _local_2 = false;
            final _iter_ = this._categories.getValues(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                _local_2 = k._Str_7960(this._manager.inventory);
                if (_local_2)
                {
                    return true;
                }
            }
            return false;
        }

        public function _Str_21762()
        {
            var k:IAvatarEditorCategoryModel = null;
            final _iter_ = this._categories.getValues(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                k._Str_15298(this.clubMemberLevel);
            }
            this.figureData.updateView();
        }

        public function _Str_8360()
        {
            var k:IAvatarEditorCategoryModel = null;
            final _iter_ = this._categories.getValues(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                k._Str_8360();
            }
            this.figureData.updateView();
        }

        public function _Str_24919(k:String):Int
        {
            var _local_3:IPalette = null;
            var _local_4:IPartColor = null;
            var _local_2= this.getFigureSetType(k);
            if (_local_2 != null)
            {
                _local_3 = this.getPalette(_local_2._Str_734);
                final _iter_ = _local_3.colors; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_4  = _tmp_;
                    if ((_local_4.isSelectable && (this.clubMemberLevel >= _local_4.clubLevel)))
                    {
                        return _local_4.id;
                    }
                }
            }
            return -1;
        }

        function _Str_23935(k:AvatarEditorGridPartItem, _arg_2:AvatarEditorGridPartItem):Float
        {
            var _local_3= ((k.partSet == null) ? -1 : k.partSet.clubLevel);
            var _local_4= ((_arg_2.partSet == null) ? -1 : _arg_2.partSet.clubLevel);
            var _local_5= ((k.partSet == null) ? false : k.partSet.isSellable);
            var _local_6= ((_arg_2.partSet == null) ? false : _arg_2.partSet.isSellable);
            if ((_local_5 && (!_local_6)))
            {
                return 1;
            }
            if ((_local_6 && (!_local_5)))
            {
                return -1;
            }
            if (_local_3 < _local_4)
            {
                return -1;
            }
            if (_local_3 > _local_4)
            {
                return 1;
            }
            if (k.partSet.id < _arg_2.partSet.id)
            {
                return -1;
            }
            if (k.partSet.id > _arg_2.partSet.id)
            {
                return 1;
            }
            return 0;
        }

        function _Str_25189(k:AvatarEditorGridPartItem, _arg_2:AvatarEditorGridPartItem):Float
        {
            var _local_3= ((k.partSet == null) ? 9999999999 : k.partSet.clubLevel);
            var _local_4= ((_arg_2.partSet == null) ? 9999999999 : _arg_2.partSet.clubLevel);
            var _local_5= ((k.partSet == null) ? false : k.partSet.isSellable);
            var _local_6= ((_arg_2.partSet == null) ? false : _arg_2.partSet.isSellable);
            if ((_local_5 && (!_local_6)))
            {
                return 1;
            }
            if ((_local_6 && (!_local_5)))
            {
                return -1;
            }
            if (_local_3 > _local_4)
            {
                return -1;
            }
            if (_local_3 < _local_4)
            {
                return 1;
            }
            if (k.partSet.id > _arg_2.partSet.id)
            {
                return -1;
            }
            if (k.partSet.id < _arg_2.partSet.id)
            {
                return 1;
            }
            return 0;
        }

        function _Str_23625(k:AvatarEditorGridColorItem, _arg_2:AvatarEditorGridColorItem):Float
        {
            var _local_3= ((k.partColor == null) ? -1 : ASCompat.asNumber(k.partColor.clubLevel ));
            var _local_4= ((_arg_2.partColor == null) ? -1 : ASCompat.asNumber(_arg_2.partColor.clubLevel ));
            if (_local_3 < _local_4)
            {
                return -1;
            }
            if (_local_3 > _local_4)
            {
                return 1;
            }
            if (k.partColor.index < _arg_2.partColor.index)
            {
                return -1;
            }
            if (k.partColor.index > _arg_2.partColor.index)
            {
                return 1;
            }
            return 0;
        }

        
        public var gender(get,set):String;
public function  get_gender():String
        {
            return this._gender;
        }
public function  set_gender(k:String):String        {
            var _local_2:IAvatarEditorCategoryModel = null;
            if (this._gender == k)
            {
                return k;
            }
            this._gender = k;
            final _iter_ = this._categories; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
            {
_local_2  = _tmp_;
                _local_2.reset();
            }
            if (this._view != null)
            {
                this._view.update();
            }
return k;
        }

        public var handler(get,never):AvatarEditorMessageHandler;
public function  get_handler():AvatarEditorMessageHandler
        {
            return this._manager.handler;
        }

        public var wardrobe(get,never):WardrobeModel;
public function  get_wardrobe():WardrobeModel
        {
            if (!this._isInitialized)
            {
                return null;
            }
            return this._sideContents.getValue(AvatarEditorSideCategory.WARDROBE);
        }

        public var effects(get,never):EffectsModel;
public function  get_effects():EffectsModel
        {
            if (!this._isInitialized)
            {
                return null;
            }
            return this._categories.getValue(AvatarEditorFigureCategory.EFFECTS);
        }

        
        public var clubMemberLevel(get,set):Int;
public function  set_clubMemberLevel(k:Int):Int        {
            return this._clubMemberLevel = k;
        }
public function  get_clubMemberLevel():Int
        {
            if (this._clubMemberLevel == 0)
            {
                return this._manager.sessionData.clubLevel;
            }
            return this._clubMemberLevel;
        }

        public function verifyClubLevel():Bool
        {
            return this._manager.catalog.verifyClubLevel();
        }

        var showClubItemsFirst(get,never):Bool;
function  get_showClubItemsFirst():Bool
        {
            return this._manager.getBoolean("avatareditor.show.clubitems.first");
        }

        function showClubItemsDimmedConfiguration():Bool
        {
            return this._manager.getBoolean("avatareditor.show.clubitems.dimmed");
        }

        public var manager(get,never):HabboAvatarEditorManager;
public function  get_manager():HabboAvatarEditorManager
        {
            return this._manager;
        }

        public function update()
        {
            var k:IAvatarEditorCategoryModel = null;
            var _local_2:ISideContentModel = null;
            final _iter_ = this._categories; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
            {
k  = _tmp_;
                k.reset();
            }
            final _iter_ = this._sideContents; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
            {
_local_2  = _tmp_;
                _local_2.reset();
            }
            if (this._view != null)
            {
                this._view.update();
            }
        }

        public function setAvatarEffectType(k:Int)
        {
            this.figureData.avatarEffectType = k;
            this.figureData.updateView();
            this._avatarEffectChanged = true;
        }

        public var view(get,never):AvatarEditorView;
public function  get_view():AvatarEditorView
        {
            return this._view;
        }

        public function openHabboClubAdWindow()
        {
            if (this._manager.catalog != null)
            {
                this._manager.catalog.openClubCenter();
            }
        }

        public function isDevelopmentEditor():Bool
        {
            return this._instanceId == AvatarEditorInstanceId.DEV_TOOL_EDITOR;
        }
    }













