package com.sulake.habbo.quest
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.runtime.IUpdateReceiver;
    import flash.geom.Point;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.communication.messages.incoming.inventory.achievements.Achievement;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.quest.events.UnseenAchievementsCountUpdateEvent;
    import com.sulake.habbo.communication.messages.outgoing.inventory.achievements.GetAchievementsComposer;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.communication.messages.outgoing.tracking.EventLogMessageComposer;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.widgets.IBadgeImageWidget;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.habbo.session.events.BadgeImageReadyEvent;

     class AchievementController implements IDisposable implements  IUpdateReceiver 
    {
        static inline final _Str_12149= 3;
        static inline final _Str_18016= 8;
        static inline final _Str_16554= 5;
        static inline final _Str_16714= 6;
        static inline final _Str_18851= 3;
        static inline final _Str_18502= 2;
        static inline final _Str_16007= 4;
        static inline final _Str_10474= 6;
        static inline final _Str_17339= 180;
        static inline final _Str_17358= 246;
        static inline final _Str_18435:UInt = 12910463;
        static inline final _Str_7408= 45;
        static final _Str_18670:Point = new Point(115, 93);
        static final _Str_17128:Point = new Point(72, 1);
        static inline final _Str_18715= 20;
        static inline final _Str_18343= 3;

        var _questEngine:HabboQuestEngine;
        var _window:IFrameWindow;
        var _categoriesContainer:IWindowContainer;
        var _achievementsContainer:IWindowContainer;
        var _achievementContainer:IWindowContainer;
        var _achievementsHeaderContainer:IWindowContainer;
        var _categoriesFooterContainer:IWindowContainer;
        var _categories:AchievementCategories;
        var _category:AchievementCategory;
        var _achievement:Achievement;
        var _badgeRefreshTimer:Timer;
        var _badgeImages:ASDictionary<ASAny,ASAny>;
        var _inLevelProgressBar:ProgressBar;
        var _totalProgressBar:ProgressBar;
        var _pendingCategorySelect:String = null;
        var _pendingLevel:Achievement;
        var _pendingLevelTimer:Timer;
        var _badgeYPositionFixes:ASDictionary<ASAny,ASAny>;
        var _requestedShowAchievements:Bool = false;
        var _unseenAchievements:ASDictionary<ASAny,ASAny>;

        public function new(k:HabboQuestEngine)
        {
            this._badgeImages = new ASDictionary<ASAny,ASAny>();
            this._badgeYPositionFixes = new ASDictionary<ASAny,ASAny>();
            this._unseenAchievements = new ASDictionary<ASAny,ASAny>();
            this._questEngine = k;
            this._badgeRefreshTimer = new Timer(100, 1);
            this._badgeRefreshTimer.addEventListener(TimerEvent.TIMER, (this._Str_19817 : ASAny));
            this._pendingLevelTimer = new Timer(2000, 1);
            this._pendingLevelTimer.addEventListener(TimerEvent.TIMER, (this._Str_20234 : ASAny));
            this._badgeYPositionFixes[16] = 1;
            this._badgeYPositionFixes[28] = 6;
            this._badgeYPositionFixes[38] = 4;
            this._badgeYPositionFixes[39] = 3;
            this._badgeYPositionFixes[40] = 1;
        }

        public static function _Str_14509(k:IWindowContainer, _arg_2:Int, _arg_3:Int)
        {
            var _local_4 = 0;
            var _local_5:IWindow = null;
            while (_local_4 < k.numChildren)
            {
                _local_5 = k.getChildAt(_local_4);
                if ((((!(_local_5 == null)) && _local_5.visible) && (_local_5.height > 0)))
                {
                    _local_5.y = _arg_2;
                    _arg_2 = (_arg_2 + (_local_5.height + _arg_3));
                }
                _local_4++;
            }
        }

        public static function getLowestPoint(k:IWindowContainer):Int
        {
            var _local_4:IWindow = null;
            var _local_2 = 0;
            var _local_3 = 0;
            while (_local_3 < k.numChildren)
            {
                _local_4 = k.getChildAt(_local_3);
                if (_local_4.visible)
                {
                    _local_2 = Std.int(Math.max(_local_2, (_local_4.y + _local_4.height)));
                }
                _local_3++;
            }
            return _local_2;
        }


        public function dispose()
        {
            this._questEngine = null;
            this._badgeImages = null;
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            if (this._badgeRefreshTimer != null)
            {
                this._badgeRefreshTimer.removeEventListener(TimerEvent.TIMER, (this._Str_19817 : ASAny));
                this._badgeRefreshTimer.reset();
                this._badgeRefreshTimer = null;
            }
            if (this._pendingLevelTimer != null)
            {
                this._pendingLevelTimer.removeEventListener(TimerEvent.TIMER, (this._Str_20234 : ASAny));
                this._pendingLevelTimer.reset();
                this._pendingLevelTimer = null;
            }
            if (this._inLevelProgressBar != null)
            {
                this._inLevelProgressBar.dispose();
                this._inLevelProgressBar = null;
            }
            if (this._totalProgressBar != null)
            {
                this._totalProgressBar.dispose();
                this._totalProgressBar = null;
            }
            this._categoriesContainer = null;
            this._achievementContainer = null;
            this._achievementContainer = null;
            this._achievementsHeaderContainer = null;
            this._categoriesFooterContainer = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._questEngine == null;
        }

        public function isVisible():Bool
        {
            return (this._window != null) && this._window.visible;
        }

        public function close()
        {
            this._unseenAchievements = new ASDictionary<ASAny,ASAny>();
            this._Str_18521();
            if (this._window != null)
            {
                this._window.visible = false;
            }
        }

        function _Str_18521()
        {
            var _local_2:Achievement = null;
            var k = 0;
            final _iter_ = this._unseenAchievements; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (this._Str_25504(_local_2.badgeId))
                {
                }
                else
                {
                    k++;
                }
            }
            this._questEngine.events.dispatchEvent(new UnseenAchievementsCountUpdateEvent(k));
        }

        public function onRoomExit()
        {
            this.close();
        }

        public function onToolbarClick()
        {
            if (this.isVisible())
            {
                this.close();
            }
            else
            {
                this.show();
            }
        }

        public function ensureAchievementsInitialized()
        {
            if (this._categories == null)
            {
                this._questEngine.send(new GetAchievementsComposer());
            }
        }

        public function show()
        {
            if (this._categories == null)
            {
                this._questEngine.send(new GetAchievementsComposer());
                this._requestedShowAchievements = true;
            }
            else
            {
                this.refresh();
                this._window.visible = true;
                this._window.activate();
            }
        }

        public function _Str_17329(k:Array<ASAny>, _arg_2:String)
        {
            if (this._categories == null)
            {
                this._categories = new AchievementCategories(k);
            }
            if (!this._requestedShowAchievements)
            {
                return;
            }
            this._requestedShowAchievements = false;
            this.refresh();
            this._window.visible = true;
            this._window.activate();
            var _local_3= ((this._pendingCategorySelect == null) ? _arg_2 : this._pendingCategorySelect);
            var _local_4= this._categories._Str_16342(_local_3);
            if (_local_4 != null)
            {
                this._Str_17738(_local_4);
                this._pendingCategorySelect = null;
            }
        }

        public function _Str_12011(k:Achievement)
        {
            var _local_2 = false;
            if (this._categories != null)
            {
                _local_2 = ((this._achievement != null) && (this._achievement.achievementId == k.achievementId));
                if (((!_local_2) && (!this._unseenAchievements.exists(k.achievementId ))))
                {
                    this._unseenAchievements[k.achievementId] = k;
                    this._Str_18521();
                }
                if ((_local_2 && (k.level > this._achievement.level)))
                {
                    this._achievement._Str_24410();
                    this._pendingLevel = k;
                    this._pendingLevelTimer.start();
                }
                else
                {
                    this._categories.update(k);
                    if (_local_2)
                    {
                        this._achievement = k;
                    }
                }
                if (((this._window != null) && this._window.visible))
                {
                    this.refresh();
                }
            }
        }

        function _Str_24797(k:String):Int
        {
            var _local_3:Achievement = null;
            var _local_2 = 0;
            final _iter_ = this._unseenAchievements; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                if (_local_3.category == k)
                {
                    _local_2++;
                }
            }
            return _local_2;
        }

        function refresh()
        {
            this.prepareWindow();
            this._Str_20399();
            this._Str_23920();
            this._Str_25170();
            this._Str_24736();
            this._Str_22606();
            _Str_14509(this._window.content, 0, 4);
            this._window.height = (getLowestPoint(this._window.content) + _Str_7408);
        }

        function _Str_20399()
        {
            var _local_3 = false;
            if (this._category != null)
            {
                this._categoriesContainer.visible = false;
                return;
            }
            this._categoriesContainer.visible = true;
            var k= this._categories._Str_16947;
            var _local_2 = 0;
            while (true)
            {
                if (_local_2 < k.length)
                {
                    this._Str_12989(_local_2, k[_local_2]);
                }
                else
                {
                    _local_3 = this._Str_12989(_local_2, null);
                    if (_local_3)
                    {
                        break;
                    }
                }
                _local_2++;
            }
            this._categoriesContainer.height = getLowestPoint(this._categoriesContainer);
        }

        function _Str_23920()
        {
            if (this._category != null)
            {
                this._categoriesFooterContainer.visible = false;
                return;
            }
            this._categoriesFooterContainer.visible = true;
            this._totalProgressBar.refresh(this._categories._Str_9594(), this._categories._Str_10932(), 0, 0);
        }

        function _Str_24736()
        {
            var _local_4:IWindow = null;
            var _local_5 = false;
            var k= this._window.findChildByName("achievements_list");
            if (this._category == null)
            {
                k.visible = false;
                return;
            }
            k.visible = true;
            Logger.log([(((this._category.code + " has ") + Std.string(this._category.achievements.length)) + " achievemenets")]);
            var _local_2= this._category.achievements;
            while (this._achievementsContainer.numChildren > 0)
            {
                this._achievementsContainer.removeChildAt(0);
            }
            var _local_3 = 0;
            while (true)
            {
                if (_local_3 < _local_2.length)
                {
                    this._Str_19385(_local_3, _local_2[_local_3]);
                }
                else
                {
                    _local_5 = this._Str_19385(_local_3, null);
                    if (_local_5)
                    {
                        break;
                    }
                }
                _local_3++;
            }
            this._achievementsContainer.height = getLowestPoint(this._achievementsContainer);
            k.height = (this._achievementsContainer.height + 1);
            this._window.findChildByName("achievements_scrollarea").height = k.height;
            _local_4 = this._window.findChildByName("achievements_scrollbar");
            _local_4.visible = this._Str_18649;
            _local_4.height = k.height;
        }

        function _Str_25170()
        {
            if (this._category == null)
            {
                this._achievementsHeaderContainer.visible = false;
                return;
            }
            this._achievementsHeaderContainer.visible = true;
            this._achievementsHeaderContainer.findChildByName("category_name_txt").caption = this._questEngine._Str_21442(this._category.code);
            this._questEngine.localization.registerParameter("achievements.details.categoryprogress", "progress", Std.string(this._category._Str_9594()));
            this._questEngine.localization.registerParameter("achievements.details.categoryprogress", "limit", Std.string(this._category._Str_10932()));
            this._questEngine._Str_21694(this._achievementsHeaderContainer, this._category, false);
        }

        function _Str_22606()
        {
            if (this._achievement == null)
            {
                this._achievementContainer.visible = false;
                return;
            }
            this._achievementContainer.visible = true;
            var k= this._Str_16394(this._achievement);
            this._achievementContainer.findChildByName("achievement_name_txt").caption = this._questEngine.localization.getBadgeName(k);
            var _local_2= this._questEngine.localization.getBadgeDesc(k);
            this._achievementContainer.findChildByName("achievement_desc_txt").caption = ((_local_2 == null) ? "" : _local_2);
            this._questEngine.localization.registerParameter("achievements.details.level", "level", (this._achievement._Str_7518 ? Std.string(this._achievement.level) : Std.string((this._achievement.level - 1))));
            this._questEngine.localization.registerParameter("achievements.details.level", "limit", Std.string(this._achievement._Str_20475));
            this._questEngine._Str_19816((!this._achievement._Str_7518), this._achievementContainer, this._achievement._Str_21187, this._achievement._Str_20874);
            this._Str_16547(this._achievementContainer, this._achievement);
            this._inLevelProgressBar.refresh(this._achievement._Str_22939, this._achievement._Str_24142, ((this._achievement.achievementId * 10000) + this._achievement.level), this._achievement._Str_25209);
            this._inLevelProgressBar.visible = ((!(this._achievement._Str_24874 == Achievement._Str_15908)) && (!this._achievement._Str_7518));
        }

        function prepareWindow()
        {
            if (this._window != null)
            {
                return;
            }
            this._window = cast(this._questEngine.getXmlWindow("Achievements"), IFrameWindow);
            this._window.findChildByTag("close").procedure = this.onWindowClose;
            this._window.findChildByName("back_button").procedure = this._Str_24533;
            this._window.center();
            this._window.y = _Str_18715;
            this._categoriesContainer = cast(this._window.findChildByName("categories_cont"), IWindowContainer);
            this._achievementsHeaderContainer = cast(this._window.findChildByName("achievements_header_cont"), IWindowContainer);
            this._achievementsContainer = cast(this._window.findChildByName("achievements_cont"), IWindowContainer);
            this._achievementContainer = cast(this._window.findChildByName("achievement_cont"), IWindowContainer);
            this._categoriesFooterContainer = cast(this._window.findChildByName("categories_footer_cont"), IWindowContainer);
            this._inLevelProgressBar = new ProgressBar(this._questEngine, this._achievementContainer, _Str_17339, "achievements.details.progress", true, _Str_18670);
            this._totalProgressBar = new ProgressBar(this._questEngine, this._categoriesFooterContainer, _Str_17358, "achievements.categories.totalprogress", true, _Str_17128);
        }

        function _Str_12989(k:Int, _arg_2:AchievementCategory):Bool
        {
            var _local_6 = 0;
            var _local_3= cast(this._categoriesContainer.getChildByName(Std.string(k)), IWindowContainer);
            var _local_4= Std.int(Math.ffloor((k / _Str_12149)));
            var _local_5:ASAny = (_local_4 < _Str_18851);
            if (_local_3 == null)
            {
                if (((_arg_2 == null) && (!_local_5)))
                {
                    return true;
                }
                _local_3 = cast(this._questEngine.getXmlWindow("AchievementCategory"), IWindowContainer);
                _local_3.name = Std.string(k);
                this._categoriesContainer.addChild(_local_3);
                _local_3.findChildByName("category_region").procedure = this._Str_16433;
                _local_3.x = ((_local_3.width + _Str_18016) * (k % _Str_12149));
                _local_3.y = Std.int(((_local_3.height + _Str_16554) * Math.ffloor((k / _Str_12149))) + _Str_16714);
            }
            _local_3.findChildByName("category_region").id = k;
            _local_3.findChildByName("category_region").visible = (!(_arg_2 == null));
            _local_3.findChildByName("category_bg_inact").visible = (_arg_2 == null);
            _local_3.findChildByName("category_bg_act").visible = (!(_arg_2 == null));
            _local_3.findChildByName("category_bg_act_hover").visible = false;
            _local_3.findChildByName("header_txt").visible = (!(_arg_2 == null));
            _local_3.findChildByName("completion_txt").visible = (!(_arg_2 == null));
            _local_3.findChildByName("category_pic_bitmap").visible = (!(_arg_2 == null));
            _local_3.findChildByName("unseen_count_border").visible = false;
            if (_arg_2 != null)
            {
                _local_3.findChildByName("header_txt").caption = this._questEngine._Str_21442(_arg_2.code);
                _local_3.findChildByName("completion_txt").caption = ((Std.string(_arg_2._Str_9594()) + "/") + Std.string(_arg_2._Str_10932()));
                this._questEngine._Str_21694(_local_3, _arg_2, true);
                _local_6 = this._Str_24797(_arg_2.code);
                if (_local_6 > 0)
                {
                    _local_3.findChildByName("unseen_count_border").visible = true;
                    _local_3.findChildByName("unseen_count").caption = Std.string(_local_6);
                }
                _local_3.visible = true;
            }
            else
            {
                _local_3.visible = _local_5;
            }
            return false;
        }

        function _Str_19385(k:Int, _arg_2:Achievement):Bool
        {
            var _local_3= Std.int(k / this._Str_17014);
            var _local_4:ASAny = (_local_3 < _Str_18502);
            if (((_arg_2 == null) && (!_local_4)))
            {
                return true;
            }
            var _local_5= Std.downcast(this._questEngine.getXmlWindow("Achievement") , IWindowContainer);
            this._achievementsContainer.addChild(_local_5);
            _local_5.x = ((_local_5.width + (this._Str_18649 ? 5 : 0)) * (k % this._Str_17014));
            Logger.log([((((((("Refreshing " + Std.string(k)) + " where count is ") + Std.string(this._category.achievements.length)) + ", row=") + Std.string(_local_3)) + ", column=") + Std.string(k % this._Str_17014))]);
            _local_5.y = ((_local_5.height * _local_3) + _Str_18343);
            _local_5.findChildByName("bg_region").procedure = this._Str_25399;
            var _local_6= _local_5.findChildByName("bg_region");
            _local_6.id = k;
            _local_6.visible = (!(_arg_2 == null));
            var _local_7= _local_5.findChildByName("bg_unselected_bitmap");
            var _local_8= _local_5.findChildByName("bg_selected_bitmap");
            this.refreshBadgeImage(_local_5, _arg_2);
            _local_7.color = ASCompat.toUInt(((!(_arg_2 == null)) && this._unseenAchievements.exists(_arg_2.achievementId )) ? _Str_18435 : 0xFFFFFF);
            if (_arg_2 != null)
            {
                _local_7.visible = (!(_arg_2 == this._achievement));
                _local_8.visible = (_arg_2 == this._achievement);
                _local_5.visible = true;
            }
            else
            {
                if (_local_4)
                {
                    _local_8.visible = false;
                    _local_7.visible = true;
                    _local_5.visible = true;
                }
                else
                {
                    _local_5.visible = false;
                }
            }
            return false;
        }

        function onWindowClose(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                this.close();
            }
        }

        function _Str_16433(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3= _arg_2.id;
            Logger.log([("Category index: " + Std.string(_local_3))]);
            if (k.type == WindowMouseEvent.CLICK)
            {
                this._Str_17738(this._categories._Str_16947[_local_3]);
            }
            else
            {
                if (k.type == WindowMouseEvent.OUT)
                {
                    this._Str_21751(-999);
                }
                else
                {
                    if (k.type == WindowMouseEvent.OVER)
                    {
                        this._Str_21751(_local_3);
                    }
                }
            }
        }

        function _Str_17738(k:AchievementCategory)
        {
            this._category = k;
            this._achievement = this._category.achievements[0];
            Logger.log([("Category: " + this._category.code)]);
            this.refresh();
            this._questEngine.send(new EventLogMessageComposer("Achievements", this._category.code, "Category selected"));
        }

        public function _Str_23567(k:String)
        {
            var _local_2:AchievementCategory = ((this._categories != null) ? this._categories._Str_16342(k) : null);
            if (_local_2 != null)
            {
                this._Str_17738(_local_2);
            }
            else
            {
                this._pendingCategorySelect = k;
            }
        }

        function _Str_21751(k:Int)
        {
            var _local_3 = false;
            var _local_4:IWindowContainer = null;
            var _local_5:IWindow = null;
            var _local_2 = 0;
            while (_local_2 < this._categoriesContainer.numChildren)
            {
                _local_3 = (_local_2 == k);
                _local_4 = cast(this._categoriesContainer.getChildAt(_local_2), IWindowContainer);
                _local_4.findChildByName("category_bg_act").visible = ((!_local_3) && (_local_2 < this._categories._Str_16947.length));
                _local_4.findChildByName("category_bg_act_hover").visible = _local_3;
                _local_5 = _local_4.findChildByName("hover_container");
                _local_5.x = (_local_3 ? 0 : 1);
                _local_5.y = (_local_3 ? 0 : 1);
                _local_2++;
            }
        }

        function _Str_25399(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            var _local_3= _arg_2.id;
            this._achievement = this._category.achievements[_local_3];
            this.refresh();
            this._questEngine.send(new EventLogMessageComposer("Achievements", Std.string(this._achievement.achievementId), "Achievement selected"));
        }

        function _Str_24533(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3:Array<ASAny> = null;
            var _local_4:Achievement = null;
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            if (this._category != null)
            {
                _local_3 = [];
                final _iter_ = this._unseenAchievements; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_4  = _tmp_;
                    if (_local_4.category != this._category.code)
                    {
                        _local_3.push(_local_4);
                    }
                }
                this._unseenAchievements = new ASDictionary<ASAny,ASAny>();
                if (checkNullIteratee(_local_3)) for (_tmp_ in _local_3)
                {
_local_4  = _tmp_;
                    this._unseenAchievements[_local_4.achievementId] = _local_4;
                }
                this._Str_18521();
            }
            this._category = null;
            this._achievement = null;
            this.refresh();
        }

        function refreshBadgeImage(k:IWindowContainer, _arg_2:Achievement)
        {
            var _local_3= Std.downcast(k.findChildByName("achievement_pic_bitmap") , IWidgetWindow);
            var _local_4= Std.downcast(_local_3.widget , IBadgeImageWidget);
            if (_arg_2 == null)
            {
                _local_3.visible = false;
                return;
            }
            cast(cast(_local_3.rootWindow, IWindowContainer).findChildByName("bitmap"), IStaticBitmapWrapperWindow).assetUri = "common_loading_icon";
            _local_4.badgeId = this._Str_16394(_arg_2);
            _local_4.greyscale = (!_arg_2._Str_10438);
            _local_3.visible = true;
        }

        function _Str_16547(k:IWindowContainer, _arg_2:Achievement)
        {
            var _local_3= Std.downcast(k.findChildByName("achievement_pic_bitmap") , IWidgetWindow);
            var _local_4= Std.downcast(_local_3.widget , IBadgeImageWidget);
            cast(cast(_local_3.rootWindow, IWindowContainer).findChildByName("bitmap"), IStaticBitmapWrapperWindow).assetUri = "common_loading_icon";
            _local_4.badgeId = this._Str_16394(_arg_2);
            _local_4.greyscale = (!_arg_2._Str_10438);
            _local_3.visible = true;
        }

        function _Str_19817(k:TimerEvent)
        {
            this._badgeRefreshTimer.reset();
            this.refresh();
        }

        function _Str_20234(k:TimerEvent)
        {
            this._achievement = this._pendingLevel;
            this._categories.update(this._pendingLevel);
            this._pendingLevel = null;
            this.refresh();
        }

        public function onBadgeImageReady(k:BadgeImageReadyEvent)
        {
            if (this._window == null)
            {
                return;
            }
            this._badgeImages[k.badgeId] = k.badgeImage;
            if (!this._badgeRefreshTimer.running)
            {
                this._badgeRefreshTimer.start();
            }
        }

        public function update(k:UInt)
        {
            if (this._inLevelProgressBar != null)
            {
                this._inLevelProgressBar.updateView();
            }
            if (this._totalProgressBar != null)
            {
                this._totalProgressBar.updateView();
            }
        }

        function _Str_16394(k:Achievement):String
        {
            return k._Str_7518 ? k.badgeId : this._questEngine.localization.getPreviousLevelBadgeId(k.badgeId);
        }

        function _Str_26271(k:Int):Int
        {
            return ASCompat.toInt(this._badgeYPositionFixes[k] ? ASCompat.toInt(this._badgeYPositionFixes[k] ): 0);
        }

        var _Str_17014(get,never):Int;
function  get__Str_17014():Int
        {
            if (this._Str_18649)
            {
                return _Str_10474 - 1;
            }
            return _Str_10474;
        }

        var _Str_18649(get,never):Bool;
function  get__Str_18649():Bool
        {
            return (!(this._category == null)) && (this._category.achievements.length > (_Str_16007 * _Str_10474));
        }

        function _Str_25504(badgeId:String):Bool
        {
            var isSkipped = false;
            var unseendSkippedBadgesIds:Array<ASAny> = (cast this._questEngine.getProperty("toolbar.unseen_notification.skipped_badge_ids").split(","));
            (unseendSkippedBadgesIds : ASAny).forEach(function (k:ASAny):ASAny
            {
                if (ASCompat.stringSearch(badgeId, k) != -1)
                {
                    isSkipped = true;
                }

return ASCompat.undefinedValue();             }, null);
            return isSkipped;
        }

        public function getAchievementLevel(k:String, _arg_2:String):Int
        {
            var _local_3:AchievementCategory = null;
            var _local_4:Achievement = null;
            if (this._categories != null)
            {
                _local_3 = this._categories._Str_16342(k);
                if (_local_3 != null)
                {
                    final _iter_ = _local_3.achievements; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                    {
_local_4  = _tmp_;
                        if (_local_4.badgeId.indexOf(_arg_2) == 0)
                        {
                            return Std.int(_local_4._Str_7518 ? _local_4.level : Std.int(Math.max(0, (_local_4.level - 1))));
                        }
                    }
                }
            }
            return 0;
        }
    }

