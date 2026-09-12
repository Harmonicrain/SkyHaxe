package com.sulake.habbo.avatar
;
    import com.sulake.core.window.IWindowContainer;
    import flash.geom.Point;
    import com.sulake.core.window.components.ITabContextWindow;
    import com.sulake.core.window.components.IFrameWindow;
    import flash.utils.Timer;
    import com.sulake.habbo.avatar.common.IAvatarEditorGridView;
    import com.sulake.habbo.avatar.view.AvatarEditorNameChangeView;
    import com.sulake.habbo.avatar._enum.AvatarEditorFigureCategory;
    import flash.events.TimerEvent;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window._enum.WindowType;
    import com.sulake.habbo.window._enum.HabboWindowStyle;
    import com.sulake.core.window._enum.WindowParam;
    import flash.geom.Rectangle;
    import flash.events.Event;
    import com.sulake.core.window.components.ITabButtonWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.avatar.common.AvatarEditorGridView;
    import com.sulake.habbo.avatar.effects.AvatarEditorGridViewEffects;
    import com.sulake.habbo.session.HabboClubLevelEnum;
    import com.sulake.habbo.avatar._enum.AvatarEditorSideCategory;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.components.IWidgetWindow;

     class AvatarEditorView 
    {
        public static var _Str_6802:IWindowContainer;
        public static var _Str_8604:IWindowContainer;
        public static var _Str_20146:Int = 0x666666;
        static inline final _Str_15942= 1500;
        static final DEFAULT_LOCATION:Point = new Point(100, 30);

        var _editor:HabboAvatarEditor;
        var _editorContent:IWindowContainer;
        var _currentViewId:String;
        var _tabContainer:ITabContextWindow;
        var _frameWindow:IFrameWindow;
        var _windowContext:IWindowContainer;
        var _saveTimer:Timer;
        var _avatarDirection:Int = 4;
        var _currentSideContentType:String;
        var _showWardrobeOnUpdate:Bool = true;
        var _availableCategories:Array<ASAny>;
        var _allCategories:Array<ASAny>;
        var _categoryContainers:ASDictionary<ASAny,ASAny>;
        var _gridView:IAvatarEditorGridView;
        var _effectsGridView:IAvatarEditorGridView;
        var _avatarEditorNameChangeView:AvatarEditorNameChangeView;

        public function new(k:HabboAvatarEditor, _arg_2:Array<ASAny>)
        {
            var _local_3:String = null;
            this._availableCategories = [];
            this._allCategories = [AvatarEditorFigureCategory.GENERIC, AvatarEditorFigureCategory.HEAD, AvatarEditorFigureCategory.TORSO, AvatarEditorFigureCategory.LEGS, AvatarEditorFigureCategory.HOTLOOKS, AvatarEditorFigureCategory.WARDROBE];
            this._editor = k;
            this._saveTimer = new Timer(_Str_15942, 1);
            this._saveTimer.addEventListener(TimerEvent.TIMER, (this.onUpdate : ASAny));
            if (k.manager.getBoolean("effects.in.avatar.editor"))
            {
                this._allCategories.push(AvatarEditorFigureCategory.EFFECTS);
            }
            if (k.manager.getBoolean("clothing.misc.tab.enabled"))
            {
                this._allCategories.push("misc");
            }
            if (_arg_2 == null)
            {
                _arg_2 = this._allCategories;
            }
            if (checkNullIteratee(_arg_2)) for (_tmp_ in _arg_2)
            {
_local_3  = _tmp_;
                this._availableCategories.push(_local_3);
            }
            this.createWindow();
        }

        public function dispose()
        {
            var k:IWindowContainer = null;
            var _local_2:IWindowContainer = null;
            var _local_3:IWindowContainer = null;
            if (this._saveTimer != null)
            {
                this._saveTimer.stop();
                this._saveTimer.removeEventListener(TimerEvent.TIMER, (this.onUpdate : ASAny));
                this._saveTimer = null;
            }
            if (this._tabContainer != null)
            {
                this._tabContainer.dispose();
                this._tabContainer = null;
            }
            if (this._editorContent != null)
            {
                this._editorContent.dispose();
                this._editorContent = null;
            }
            if (this._windowContext != null)
            {
                this._windowContext.dispose();
                this._windowContext = null;
            }
            if (this._frameWindow != null)
            {
                this._frameWindow.dispose();
                this._frameWindow = null;
            }
            if (this._editorContent != null)
            {
                k = Std.downcast(this._editorContent.findChildByName("figureContainer") , IWindowContainer);
                if (k != null)
                {
                    while (k.numChildren > 0)
                    {
                        k.removeChildAt(0);
                    }
                }
                _local_2 = Std.downcast(this._editorContent.findChildByName("contentArea") , IWindowContainer);
                if (_local_2 != null)
                {
                    while (_local_2.numChildren > 0)
                    {
                        _local_2.removeChildAt(0);
                    }
                }
                _local_3 = Std.downcast(this._editorContent.findChildByName("sideContainer") , IWindowContainer);
                if (_local_3 != null)
                {
                    while (_local_3.numChildren > 0)
                    {
                        _local_3.removeChildAt(0);
                    }
                }
                this._editor = null;
            }
        }

        public function getFrame(k:Array<ASAny>, _arg_2:String=null):IFrameWindow
        {
            if (this._frameWindow != null)
            {
                this._frameWindow.visible = true;
                this._frameWindow.activate();
                return this._frameWindow;
            }
            if (this._frameWindow != null)
            {
                this._frameWindow.dispose();
                this._frameWindow = null;
            }
            var _local_3= Std.downcast(this._editor.manager.assets.getAssetByName("AvatarEditorFrame") , XmlAsset);
            if (_local_3 != null)
            {
                this._frameWindow = Std.downcast(this._editor.manager.windowManager.buildFromXML(((_local_3.content : com.sulake.core.utils.xml.XML) )) , IFrameWindow);
            }
            if (this._frameWindow == null)
            {
                return null;
            }
            var _local_4= Std.downcast(this._frameWindow.findChildByName("maincontent") , IWindowContainer);
            if (!this._Str_13533(_local_4, k))
            {
                this._frameWindow.dispose();
                this._frameWindow = null;
                return null;
            }
            if ((ASCompat.stringAsBool(_arg_2) && (!(this._frameWindow.header == null))))
            {
                this._frameWindow.header.title.text = _arg_2;
            }
            this._frameWindow.position = DEFAULT_LOCATION;
            this._frameWindow.findChildByName("header_button_close").procedure = this.windowEventProc;
            return this._frameWindow;
        }

        public function _Str_13533(k:IWindowContainer, _arg_2:Array<ASAny>):Bool
        {
            var _local_3 = 0;
            if (!this._Str_19170(_arg_2))
            {
                return false;
            }
            if (k != null)
            {
                _local_3 = k.getChildIndex(this._editorContent);
                if (_local_3 != 0)
                {
                    k.removeChildAt(_local_3);
                }
                k.addChild(this._editorContent);
            }
            else
            {
                if (this._windowContext == null)
                {
                    this._windowContext = Std.downcast(this._editor.manager.windowManager.createWindow("avatarEditorContainer", "", WindowType.WINDOW_TYPE_CONTAINER, HabboWindowStyle.SHINY, (ASCompat.toInt(WindowParam.WINDOW_PARAM_EXPAND_TO_ACCOMMODATE_CHILDREN )| ASCompat.toInt(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR)), new Rectangle(0, 0, 2, 2), null, 0) , IWindowContainer);
                    this._windowContext.addChild(this._editorContent);
                }
                _local_3 = this._windowContext.getChildIndex(this._editorContent);
                if (_local_3 != 0)
                {
                    k.removeChildAt(_local_3);
                }
                this._windowContext.visible = true;
            }
            return true;
        }

        public function _Str_19170(k:Array<ASAny>):Bool
        {
            var _local_2:String = null;
            if (k == null)
            {
                return this._Str_19170(this._allCategories);
            }
            if (k.length != this._availableCategories.length)
            {
                return false;
            }
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_2  = _tmp_;
                if (this._availableCategories.indexOf(_local_2) < 0)
                {
                    return false;
                }
            }
            return true;
        }

        function onUpdate(k:Event=null)
        {
            this._saveTimer.stop();
            if (this._editorContent != null)
            {
                this._editorContent.findChildByName("save").enable();
            }
        }

        public function show()
        {
            if (this._frameWindow != null)
            {
                this._frameWindow.visible = true;
            }
            else
            {
                if (this._editorContent != null)
                {
                    this._editorContent.visible = true;
                }
            }
        }

        public function hide()
        {
            if (this._frameWindow != null)
            {
                this._frameWindow.visible = false;
            }
            else
            {
                if (this._editorContent != null)
                {
                    this._editorContent.visible = false;
                }
            }
        }

        function createWindow()
        {
            var _local_4:String = null;
            var _local_5:ITabButtonWindow = null;
            var _local_6 = 0;
            var _local_7:IWindow = null;
            if (this._editorContent == null)
            {
                this._editorContent = Std.downcast(this._editor.manager.windowManager.buildFromXML(((Std.downcast(this._editor.manager.assets.getAssetByName("AvatarEditorContent") , XmlAsset).content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            }
            if (_Str_6802 == null)
            {
                _Str_6802 = Std.downcast(this._editorContent.findChildByName("thumb_template") , IWindowContainer);
                if (_Str_6802 != null)
                {
                    this._editorContent.removeChild(_Str_6802);
                }
            }
            if (_Str_8604 == null)
            {
                _Str_8604 = Std.downcast(this._editorContent.findChildByName("palette_template") , IWindowContainer);
                if (_Str_8604 != null)
                {
                    this._editorContent.removeChild(_Str_8604);
                }
            }
            if (((!(this._editor.manager == null)) && (!(this._editor.manager.sessionData == null))))
            {
                this._editorContent.findChildByName("avatar_name").caption = this._editor.manager.sessionData.userName;
                if (this._editor.manager.getBoolean("premium.name.change.enabled"))
                {
                    this._editorContent.findChildByName("avatar_name_change").visible = true;
                }
            }
            this._editorContent.procedure = this.windowEventProc;
            this._tabContainer = Std.downcast(this._editorContent.findChildByName("mainTabs") , ITabContextWindow);
            var k= new Vector<String>(0);
            var _local_2= ASCompat.toInt(this._tabContainer.numTabs - 1);
            while (_local_2 >= 0)
            {
                _local_5 = this._tabContainer.getTabButtonAt(_local_2);
                k.push(_local_5.name);
                if (((!(_local_5 == null)) && (this._availableCategories.indexOf(_local_5.name) < 0)))
                {
                    this._tabContainer._Str_5897(_local_5);
                    _local_6 = (_local_2 + 1);
                    while ((_local_6 : UInt) < this._tabContainer.numTabs)
                    {
                        this._tabContainer.getTabButtonAt(_local_6).x = (this._tabContainer.getTabButtonAt(_local_6).x - _local_5.width);
                        _local_6++;
                    }
                }
                _local_2--;
            }
            this._categoryContainers = new ASDictionary<ASAny,ASAny>();
            var _local_3= Std.downcast(this._editorContent.findChildByName("contentArea") , IWindowContainer);
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_4  = _tmp_;
                _local_7 = _local_3.findChildByName((_local_4 + "_content"));
                if (_local_7 != null)
                {
                    this._categoryContainers[_local_4] = _local_3.removeChild(_local_7);
                }
            }
            this._gridView = new AvatarEditorGridView(Std.downcast(this._editorContent.findChildByName("grid_container") , IWindowContainer));
            this._effectsGridView = new AvatarEditorGridViewEffects(Std.downcast(this._editorContent.findChildByName("grid_container") , IWindowContainer));
            this._tabContainer.selector.setSelected(this._tabContainer.getTabButtonAt(0));
            this.update();
        }

        public function update()
        {
            var k= this._editorContent.findChildByName("wardrobeButtonContainer") ;
            if (((k != null) && (this._editor.manager.sessionData != null)))
            {
                k.visible = ((this._editor.manager.sessionData.clubLevel >= HabboClubLevelEnum.CLUB) && this._editor.isSideContentEnabled());
                k.visible = this._editor.isSideContentEnabled();
            }
            var _local_2= AvatarEditorSideCategory.NOTHING;
            if (((this._currentSideContentType == AvatarEditorSideCategory.WARDROBE) || this._showWardrobeOnUpdate))
            {
                _local_2 = AvatarEditorSideCategory.WARDROBE;
            }
            if (!this._editor.isSideContentEnabled())
            {
                _local_2 = AvatarEditorSideCategory.NOTHING;
            }
            if (this._editor._Str_16127())
            {
                this._editor._Str_21762();
                this._editor._Str_21039();
            }
            if (this._editor._Str_7960())
            {
                this._editor._Str_8360();
            }
            this._Str_17697(_local_2);
            this.setViewToCategory(this._currentViewId);
        }

        public function toggleCategoryView(k:String, _arg_2:Bool=false)
        {
            if (_arg_2)
            {
            }
            this.setViewToCategory(k);
        }

        function _Str_24588()
        {
            if (this._currentSideContentType == AvatarEditorSideCategory.WARDROBE)
            {
                this._showWardrobeOnUpdate = false;
                this._Str_17697(AvatarEditorSideCategory.NOTHING);
            }
            else
            {
                this._Str_17697(AvatarEditorSideCategory.WARDROBE);
            }
        }

        function _Str_17697(k:String)
        {
            var _local_5 = 0;
            if (this._currentSideContentType == k)
            {
                return;
            }
            var _local_2= Std.downcast(this._editorContent.findChildByName("sideContainer") , IWindowContainer);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3:IWindow = null;
            switch (k)
            {
                case AvatarEditorSideCategory.NOTHING:
                    
                case AvatarEditorSideCategory.WARDROBE:
                    _local_3 = this._editor.getSideContentWindowContainer(AvatarEditorSideCategory.WARDROBE);
                    
            }
            var _local_4= _local_2.removeChildAt(0);
            if (_local_4 != null)
            {
                this._editorContent.width = (this._editorContent.width - _local_4.width);
            }
            if (_local_3 != null)
            {
                _local_2.addChild(_local_3);
                _local_3.visible = true;
                _local_2.width = _local_3.width;
            }
            else
            {
                _local_2.width = 0;
            }
            this._currentSideContentType = k;
            if (this._frameWindow != null)
            {
                _local_5 = 8;
                this._frameWindow.content.width = (this._editorContent.width + _local_5);
            }
        }

        function setViewToCategory(k:String)
        {
            if (k == null)
            {
                return;
            }
            if (k == "")
            {
                return;
            }
            var _local_2= Std.downcast(this._editorContent.findChildByName("contentArea") , IWindowContainer);
            if (_local_2 == null)
            {
                return;
            }
            if (k == AvatarEditorFigureCategory.EFFECTS)
            {
                this.effectsParamViewContainer.visible = true;
            }
            else
            {
                this.effectsParamViewContainer.visible = false;
            }
            var _local_3= _local_2.getChildAt(0);
            _local_2.removeChild(_local_3);
            _local_2.invalidate();
            var _local_4= this._editor.getCategoryWindowContainer(k);
            if (_local_4 == null)
            {
                return;
            }
            this._gridView.window.visible = false;
            _local_4.visible = true;
            _local_2.addChild(_local_4);
            this._editor.activateCategory(k);
            this._currentViewId = k;
            this._tabContainer.selector.setSelected(this._tabContainer._Str_19493(k));
        }

        public function windowEventProc(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3:String = null;
            if (k.type == WindowEvent.WINDOW_EVENT_SELECTED)
            {
                _local_3 = Std.downcast(_arg_2 , ITabContextWindow).selector.getSelected().name;
                if (_local_3 != this._currentViewId)
                {
                    this._editor._Str_14039(_local_3);
                }
            }
            else
            {
                if (k.type == WindowMouseEvent.CLICK)
                {
                    switch (_arg_2.name)
                    {
                        case "save":
                            if (((!this._editor.isDevelopmentEditor()) && this._editor._Str_7960()))
                            {
                                this._Str_25363();
                                this._saveTimer.start();
                                this._editorContent.findChildByName("save").disable();
                                return;
                            }
                            if (((!this._editor.isDevelopmentEditor()) && this._editor._Str_16127()))
                            {
                                this._editor.openHabboClubAdWindow();
                                this._saveTimer.start();
                                this._editorContent.findChildByName("save").disable();
                                return;
                            }
                            this._saveTimer.start();
                            this._editorContent.findChildByName("save").disable();
                            this._editor.saveCurrentSelection();
                            this._editor.manager.close(this._editor.instanceId);
                            return;
                        case "cancel"
                           | "header_button_close":
                            if (this._editor._Str_16127())
                            {
                                this._editor._Str_21762();
                                this._editor._Str_21039();
                            }
                            this._editor.manager.close(this._editor.instanceId);
                            return;
                        case "rotate_avatar":
                            this._avatarDirection++;
                            if (this._avatarDirection > 7)
                            {
                                this._avatarDirection = 0;
                            }
                            this._editor.figureData.direction = this._avatarDirection;
                            return;
                        case "wardrobe":
                            this._Str_24588();
                            return;
                        case "avatar_name_change":
                            if (this._avatarEditorNameChangeView != null)
                            {
                                this._avatarEditorNameChangeView.focus();
                            }
                            else
                            {
                                this._avatarEditorNameChangeView = new AvatarEditorNameChangeView(this, (this._editorContent.x + this._editorContent.width), this._editorContent.y);
                            }
                            return;
                    }
                }
            }
        }

        function _Str_25363()
        {
            if (this._editor.manager.catalog != null)
            {
                this._editor.manager.catalog.openCatalogPage(this._editor.manager.getProperty("catalog.clothes.page"));
            }
        }

        public var effectsParamViewContainer(get,never):IWindowContainer;
public function  get_effectsParamViewContainer():IWindowContainer
        {
            return cast(this._editorContent.findChildByName("effectParamsContainer"), IWindowContainer);
        }

        public function getCategoryContainer(k:String):IWindow
        {
            return this._categoryContainers[k];
        }

        public var _Str_19197(get,never):IAvatarEditorGridView;
public function  get__Str_19197():IAvatarEditorGridView
        {
            return this._gridView;
        }

        public function _Str_25244():IWidgetWindow
        {
            return Std.downcast(this._editorContent.findChildByName("avatarWidget") , IWidgetWindow);
        }

        public var effectsGridView(get,never):IAvatarEditorGridView;
public function  get_effectsGridView():IAvatarEditorGridView
        {
            return this._effectsGridView;
        }

        public var editor(get,never):HabboAvatarEditor;
public function  get_editor():HabboAvatarEditor
        {
            return this._editor;
        }

        public var _Str_22767(get,never):AvatarEditorNameChangeView;
public function  get__Str_22767():AvatarEditorNameChangeView
        {
            return this._avatarEditorNameChangeView;
        }
    }

