package com.sulake.habbo.friendbar.landingview.layout
;
    import com.sulake.core.runtime.IUpdateReceiver;
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.habbo.communication.messages.incoming.competition.CurrentTimingCodeMessageEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.communication.messages.outgoing.competition.GetCurrentTimingCodeMessageComposer;
    import flash.geom.Point;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.habbo.friendbar.landingview.interfaces.ILandingViewWidget;
    import com.sulake.habbo.friendbar.landingview.interfaces.ISlotAwareWidget;

     class WidgetContainerLayout implements IUpdateReceiver
    {
        static inline final COLORABLE= "COLORABLE";
        static inline final WINDOW_LAYER_INDEX= 0;
        static inline final LANDING_VIEW_DEFAULT_DYNAMIC_LAYOUT= "landing_view_default_dynamic_layout";
        static inline final LANDING_VIEW_GENERIC_RECEPTION= "landing_view_generic_reception";
        static inline final WIDGET_PLACEHOLDER_= "widget_placeholder_";
        static final OVERRIDE_GRAPHICS:Array<ASAny> = ["background_back", "background_front", "background_gradient_top", "background_hotel_top", "background_gradient", "background_right", "background_horizon", "background_left", "background_left_bottom"];

        var habboLandingView:HabboLandingView;
        var windowContainer:IWindowContainer;
        var dynamicLayoutManager:DynamicLayoutManager;
        var movingBackgroundObjects:MovingBackgroundObjects;
        var _orgWindowWidth:Int = 0;
        var _orgWindowHeight:Int = 0;
        var _registeredWidgets:Array<ASAny>;
        var _commonWidgetSettings:CommonWidgetSettings;
        var _schedulingStr:String;

        public function new(k:HabboLandingView)
        {
            this._registeredWidgets = [];
            this.habboLandingView = k;
            this.registerFixedWidgets();
            this.movingBackgroundObjects = new MovingBackgroundObjects(this.landingView);
            this._commonWidgetSettings = new CommonWidgetSettings(this.landingView);
            k.registerUpdateReceiver(this, 1000);
        }

        static function getColorizableElements(k:IWindowContainer):Array<ASAny>
        {
            var colorableChildren= ASCompat.allocArray(0);
            k.groupChildrenWithTag(COLORABLE, colorableChildren, -1);
            return colorableChildren;
        }

        public static function applyColorizableWidgetTextColor(search:IWindowContainer, newTextColor:UInt)
        {
            var textWindow:ITextWindow = null;
            if (search == null)
            {
                return;
            }
            final _iter_ = getColorizableElements(search); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
textWindow  = _tmp_;
                textWindow.textColor = newTextColor;
            }
        }

        public static function applyColorizableWidgetEtchingColor(search:IWindowContainer, newEtchingColor:UInt)
        {
            var textWindow:ITextWindow = null;
            if (search == null)
            {
                return;
            }
            final _iter_ = getColorizableElements(search); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
textWindow  = _tmp_;
                textWindow.etchingColor = newEtchingColor;
            }
        }

        public static function applyColorizableWidgetEtchingPosition(search:IWindowContainer, newEtchingPosition:String)
        {
            var textWindow:ITextWindow = null;
            if (search == null)
            {
                return;
            }
            final _iter_ = getColorizableElements(search); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
textWindow  = _tmp_;
                textWindow.etchingPosition = newEtchingPosition;
            }
        }

        public static function applyCommonWidgetSettings(search:IWindowContainer, _arg_2:CommonWidgetSettings)
        {
            var _local_3:ITextWindow = null;
            if (search == null)
            {
                return;
            }
            if (((_arg_2.isTextColorSet || _arg_2.isEtchingColorSet) || _arg_2.isEtchingPositionSet))
            {
                final _iter_ = getColorizableElements(search); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_3  = _tmp_;
                    _local_3.textColor = (_arg_2.isTextColorSet ? _arg_2.textColor : _local_3.textColor);
                    _local_3.etchingColor = (_arg_2.isEtchingColorSet ? _arg_2.etchingColor : _local_3.etchingColor);
                    _local_3.etchingPosition = (_arg_2.isEtchingPositionSet ? _arg_2.etchingPosition : _local_3.etchingPosition);
                }
            }
        }


        public function update(k:UInt)
        {
            if (((!(this.windowContainer == null)) && this.windowContainer.visible))
            {
                this.movingBackgroundObjects.update(k);
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this.landingView == null;
        }

        public function dispose()
        {
            var registeredWidget:WidgetPlaceholder = null;
            if (this.landingView != null)
            {
                this.landingView.removeUpdateReceiver(this);
            }
            this.habboLandingView = null;
            if (this.windowContainer != null)
            {
                this.windowContainer.dispose();
                this.windowContainer = null;
            }
            if (this._registeredWidgets != null)
            {
                final _iter_ = this._registeredWidgets; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
registeredWidget  = _tmp_;
                    registeredWidget.dispose();
                }
                this._registeredWidgets = null;
            }
            if (this.movingBackgroundObjects != null)
            {
                this.movingBackgroundObjects.dispose();
                this.movingBackgroundObjects = null;
            }
            if (this.dynamicLayoutManager != null)
            {
                this.dynamicLayoutManager.dispose();
                this.dynamicLayoutManager = null;
            }
            if (this._commonWidgetSettings != null)
            {
                this._commonWidgetSettings = null;
            }
        }

        public function activate()
        {
            var registeredWidget:WidgetPlaceholder = null;
            if (this.windowContainer == null)
            {
                this.createWindow();
                this.initializeDynamicWidgetList();
                this.landingView.communicationManager.addHabboConnectionMessageEvent(new CurrentTimingCodeMessageEvent(this.onTimingCode));
                this._schedulingStr = this.landingView.getProperty("landing.view.bgtiming");
            }
            final _iter_ = this._registeredWidgets; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
registeredWidget  = _tmp_;
                registeredWidget.refresh(this.windowContainer);
            }
            this.resizeWindow();
            this.landingView.windowManager.getWindowContext(WINDOW_LAYER_INDEX).getDesktopWindow().addEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this.onDesktopResized);
            this.windowContainer.invalidate();
            if (this.navigatorPosition != null)
            {
                this.landingView.navigator.openNavigator(this.navigatorPosition);
            }
            this.landingView.send(new GetCurrentTimingCodeMessageComposer(this._schedulingStr));
            this.windowContainer.visible = true;
        }

        var navigatorPosition(get,never):Point;
function  get_navigatorPosition():Point
        {
            var point:Point = null;
            var placer= this.windowContainer.findChildByName("navigator_placer");
            if (placer == null)
            {
                return null;
            }
            point = new Point();
            placer.getGlobalPosition(point);
            return point;
        }

        public function disable()
        {
            var registeredWidget:WidgetPlaceholder = null;
            if (this.windowContainer != null)
            {
                this.windowContainer.visible = false;
            }
            final _iter_ = this._registeredWidgets; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
registeredWidget  = _tmp_;
                registeredWidget.disable();
            }
        }

        function createWindow()
        {
            if (this.windowContainer != null)
            {
                return;
            }
            var k= this.getLayout();
            this.windowContainer = cast(this.landingView.getXmlWindow(k, 0), IWindowContainer);
            this.hideWarningIfPresent();
            if (this.landingView.getBoolean("landing.view.right_pane_dimmer.hidden"))
            {
                if (this.windowContainer.findChildByName("right_pane_dimmer") != null)
                {
                    this.windowContainer.findChildByName("right_pane_dimmer").visible = false;
                }
            }
            this.setOrgWindowSize();
            this.setupBottomSlotWidgetName();
        }

        function hideWarningIfPresent()
        {
            var k= this.windowContainer.findChildByName("warning");
            if (k != null)
            {
                k.visible = false;
            }
        }

        function setOrgWindowSize()
        {
            this._orgWindowWidth = this.windowContainer.width;
            this._orgWindowHeight = this.windowContainer.height;
        }

        function setupBottomSlotWidgetName()
        {
            var _local_2:String = null;
            var k= this.windowContainer.findChildByName("widget_placeholder_bottom_slot");
            if (k != null)
            {
                _local_2 = this.landingView.getProperty("landing.view.dynamic.slot.6.widget");
                if (_local_2 == "")
                {
                    k.visible = false;
                }
                else
                {
                    k.name = ("widget_placeholder_" + _local_2);
                }
            }
        }

        function getLayout():String
        {
            return this.landingView.propertyExists("landing.view.layoutxml") ? this.landingView.getProperty("landing.view.layoutxml") : LANDING_VIEW_DEFAULT_DYNAMIC_LAYOUT;
        }

        function isGenericReceptionLayout():Bool
        {
            return this.getLayout() == LANDING_VIEW_GENERIC_RECEPTION;
        }

        function resizeWindow()
        {
            var k:WidgetPlaceholder = null;
            if (this.windowContainer != null)
            {
                if (this.dynamicLayoutManager != null)
                {
                    this.resizeDynamicLayout();
                }
                else
                {
                    this.resizeCustomLayout();
                }
                this.windowContainer.invalidate();
            }
            final _iter_ = this._registeredWidgets; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                k._Str_17674();
            }
        }

        function resizeDynamicLayout()
        {
            var k= this.windowContainer.desktop.rectangle;
            this.windowContainer.width = Std.int(k.width);
            this.windowContainer.height = Std.int(k.height);
            var _local_2= Std.int(this._orgWindowHeight - k.height);
            var _local_3= Std.int(this._orgWindowWidth - k.width);
            this.dynamicLayoutManager._Str_24842((this.dynamicLayoutManager._Str_19568 - _local_3), (this.dynamicLayoutManager._Str_19625 - _local_2));
            this.dynamicLayoutManager._Str_22592 = Std.int(Math.min(this.windowContainer.width, (k.width + this.window.x)));
        }

        function resizeCustomLayout()
        {
            this.windowContainer.x = 0;
            this.windowContainer.y = 0;
            var k= this.windowContainer.desktop.rectangle;
            this.windowContainer.x = Std.int(Math.max(0, ((k.width - this.windowContainer.width) / 2)));
            if (((k.height > this.windowContainer.height) || this.isGenericReceptionLayout()))
            {
                this.windowContainer.y = Std.int(Math.max(0, ((k.height - this.windowContainer.height) / 2)));
            }
            else
            {
                this.windowContainer.y = Std.int(k.height - this.windowContainer.height);
            }
        }

        function onDesktopResized(k:WindowEvent)
        {
            this.resizeWindow();
        }

        function setBackgroundGraphics(k:String)
        {
            var _local_2:String = null;
            var _local_3:IStaticBitmapWrapperWindow = null;
            var _local_4:String = null;
            k = (((k == null) || (k == "")) ? "" : (k + "."));
            final _iter_ = OVERRIDE_GRAPHICS; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                _local_3 = cast(this.windowContainer.findChildByName(_local_2), IStaticBitmapWrapperWindow);
                if (_local_3 != null)
                {
                    if (this.landingView.getProperty(((("landing.view." + k) + _local_2) + ".visible")) == "false")
                    {
                        _local_3.visible = false;
                    }
                    else
                    {
                        _local_3.visible = true;
                        _local_4 = this.landingView.getProperty(((("landing.view." + k) + _local_2) + ".uri"), null);
                        if ((((!(_local_3.assetUri == _local_4)) && (!(_local_4 == null))) && (!(_local_4 == ""))))
                        {
                            _local_3.assetUri = _local_4;
                        }
                    }
                }
            }
        }

        function registerFixedWidgets()
        {
            this.addWidgetPlaceholder(HabboLandingViewWidgets.AVATAR_IMAGE);
            this.addWidgetPlaceholder(HabboLandingViewWidgets.EXPIRING_CATALOG_PAGE);
            this.addWidgetPlaceholder(HabboLandingViewWidgets.EXPIRING_CATALOG_PAGE_SMALL);
            this.addWidgetPlaceholder(HabboLandingViewWidgets.COMMUNITY_GOAL);
            this.addWidgetPlaceholder(HabboLandingViewWidgets.CATALOG_PROMO);
            this.addWidgetPlaceholder(HabboLandingViewWidgets.ACHIEVEMENT_COMPETITION_HALL_OF_FAME);
            this.addWidgetPlaceholder(HabboLandingViewWidgets.ACHIEVEMENT_COMPETITION_PRIZES);
            this.addWidgetPlaceholder(HabboLandingViewWidgets.DAILYQUEST);
            this.addWidgetPlaceholder(HabboLandingViewWidgets.NEXT_LIMITED_RARE_COUNTDOWN);
            this.addWidgetPlaceholder(HabboLandingViewWidgets.HABBO_MODERATION_PROMO);
            this.addWidgetPlaceholder(HabboLandingViewWidgets.HABBO_TALENTS_PROMO);
            this.addWidgetPlaceholder(HabboLandingViewWidgets.HABBO_WAY_PROMO);
            this.addWidgetPlaceholder(HabboLandingViewWidgets.FASTFOOD_GAME_PROMO);
            this.addWidgetPlaceholder(HabboLandingViewWidgets.SAFETY_QUIZ_PROMO);
            this.addWidgetPlaceholder(HabboLandingViewWidgets.GENERIC);
            this.addWidgetPlaceholder(HabboLandingViewWidgets.WIDGET_CONTAINER);
        }

        function addWidgetPlaceholder(widgetCode:String)
        {
            var widget= HabboLandingViewWidgets.createWidget(widgetCode, this.landingView);
            this._registeredWidgets.push(new WidgetPlaceholder(widget, (WIDGET_PLACEHOLDER_ + widgetCode), this._commonWidgetSettings));
        }

        function initializeDynamicWidgetList()
        {
            var _local_2:String = null;
            var widget:ILandingViewWidget = null;
            if (this.windowContainer.findChildByName(DynamicLayoutManager.PLACEHOLDER_DYNAMIC_WIDGET_SLOTS) == null)
            {
                Logger.log(["ERROR! Tried to initialize dynamic widget list for landing view without the dynamic element present"]);
                return;
            }
            this.dynamicLayoutManager = new DynamicLayoutManager(this, this._commonWidgetSettings);
            var k = 0;
            while (k < 6)
            {
                _local_2 = this.landingView.getProperty((("landing.view.dynamic.slot." + Std.string(k + 1)) + ".widget"), null);
                widget = HabboLandingViewWidgets.createWidget(_local_2, this.landingView);
                if (widget != null)
                {
                    if (Std.is(widget , ISlotAwareWidget))
                    {
                        cast(widget, ISlotAwareWidget).slot = (k + 1);
                    }
                    this._registeredWidgets.push(new WidgetPlaceholder(widget, null, this._commonWidgetSettings, this.dynamicLayoutManager._Str_23980(k)));
                }
                k++;
            }
            if (this.landingView.getBoolean("landing.view.dynamic.slot.5.ignore"))
            {
                this.dynamicLayoutManager._Str_24583 = true;
            }
            if (this.landingView.getBoolean("landing.view.dynamic.slot.4.separator"))
            {
                this.dynamicLayoutManager._Str_20363(4, this.landingView.getProperty("landing.view.dynamic.slot.4.title"));
            }
            if (this.landingView.getBoolean("landing.view.dynamic.slot.5.separator"))
            {
                this.dynamicLayoutManager._Str_20363(5, this.landingView.getProperty("landing.view.dynamic.slot.5.title"));
            }
        }

        public var window(get,never):IWindowContainer;
public function  get_window():IWindowContainer
        {
            return this.windowContainer;
        }

        public var landingView(get,never):HabboLandingView;
public function  get_landingView():HabboLandingView
        {
            return this.habboLandingView;
        }

        function onTimingCode(k:CurrentTimingCodeMessageEvent)
        {
            if (((k.getParser().schedulingStr == this._schedulingStr) && (this.landingView != null)))
            {
                this.setBackgroundGraphics(k.getParser().code);
                this.movingBackgroundObjects._Str_23132 = k.getParser().code;
                this.movingBackgroundObjects.initialize(this.windowContainer);
            }
        }
    }

