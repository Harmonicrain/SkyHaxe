package com.sulake.habbo.quest
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.habbo.communication.messages.incoming.inventory.achievements.AchievementResolution;
    import com.sulake.core.window.components.IItemGridWindow;
    import com.sulake.habbo.communication.messages.outgoing.game.lobby.GetResolutionAchievementsMessageComposer;
    import com.sulake.habbo.communication.messages.incoming.notifications.AchievementLevelUpData;
    import com.sulake.habbo.communication.messages.incoming.inventory.achievements.Achievement;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.communication.messages.outgoing.game.lobby.ResetResolutionAchievementMessageComposer;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.widgets.ICountdownWidget;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.window.widgets.IBadgeImageWidget;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;

     class AchievementsResolutionController implements IDisposable 
    {
        static inline final HEADER_BUTTON_CLOSE= "header_button_close";
        static inline final SAVE_BUTTON= "save_button";
        static inline final CANCEL_BUTTON= "cancel_button";
        static inline final OK_BUTTON= "ok_button";
        static inline final DISABLED_REASON= "disabled.reason";

        var _questEngine:HabboQuestEngine;
        var _window:IFrameWindow;
        var _progressView:AchievementResolutionProgressView;
        var _completedView:AchievementResolutionCompletedView;
        var _stuffId:Int = 0;
        var _achievements:Vector<AchievementResolution>;
        var _selectedAchievementId:Int = -1;
        var _endTime:Int = -1;

        public function new(k:HabboQuestEngine)
        {
            this._questEngine = k;
        }

        public function dispose()
        {
            var k:IItemGridWindow = null;
            this._questEngine = null;
            if (this._window != null)
            {
                k = Std.downcast(this._window.findChildByName("achievements") , IItemGridWindow);
                if (k != null)
                {
                    k.destroyGridItems();
                }
                if (this._progressView != null)
                {
                    this._progressView.dispose();
                    this._progressView = null;
                }
                if (this._completedView != null)
                {
                    this._completedView.dispose();
                    this._completedView = null;
                }
                this._window.dispose();
                this._window = null;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._questEngine == null;
        }

        public function _Str_23538(k:Int, _arg_2:Vector<AchievementResolution>, _arg_3:Int)
        {
            this._stuffId = k;
            this._achievements = _arg_2;
            this._endTime = _arg_3;
            if (_arg_2.length == 0)
            {
                return;
            }
            this.refresh();
            this._window.visible = true;
            this._selectedAchievementId = this._achievements[0].achievementId;
            this._Str_23858();
            this._Str_20512(this._selectedAchievementId);
        }

        public function _Str_24205(k:Int, _arg_2:Int, _arg_3:String, _arg_4:Int, _arg_5:Int, _arg_6:Int)
        {
            if (this._progressView == null)
            {
                this._progressView = new AchievementResolutionProgressView(this);
            }
            this._progressView.show(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6);
        }

        public function _Str_25733(k:String, _arg_2:String)
        {
            if (this._completedView == null)
            {
                this._completedView = new AchievementResolutionCompletedView(this);
            }
            this._completedView.show(_arg_2, k);
        }

        public function onLevelUp(k:AchievementLevelUpData)
        {
            if ((((this._progressView != null) && this._progressView.visible) && (k.type == this._progressView.achievementId)))
            {
                this._questEngine.send(new GetResolutionAchievementsMessageComposer(this._progressView.stuffId, 0));
            }
        }

        public function _Str_12011(k:Achievement)
        {
            if ((((this._progressView != null) && this._progressView.visible) && (k.achievementId == this._progressView.achievementId)))
            {
                this._questEngine.send(new GetResolutionAchievementsMessageComposer(this._progressView.stuffId, 0));
            }
        }

        public function _Str_23910(stuffId:Int)
        {
            var title:String = null;
            var summary:String = null;
            if ((((this._progressView != null) && this._progressView.visible) && (stuffId == this._progressView.stuffId)))
            {
                title = "${resolution.reset.confirmation.title}";
                summary = "${resolution.reset.confirmation.text}";
                this._questEngine.windowManager.confirm(title, summary, 0, function (k:com.sulake.habbo.window.utils.IConfirmDialog, _arg_2:WindowEvent)
                {
                    k.dispose();
                    if (_arg_2.type == WindowEvent.WINDOW_EVENT_OK)
                    {
                        _questEngine.send(new ResetResolutionAchievementMessageComposer(stuffId));
                        _questEngine.send(new GetResolutionAchievementsMessageComposer(_progressView.stuffId, 0));
                    }
                });
            }
        }

        function refresh()
        {
            if (this._window == null)
            {
                this.prepareWindow();
            }
            var k= cast(this._window.findChildByName("countdown_widget"), IWidgetWindow);
            var _local_2= cast(k.widget, ICountdownWidget);
            _local_2.seconds = this._endTime;
            _local_2.running = true;
        }

        function prepareWindow()
        {
            if (this._window != null)
            {
                return;
            }
            this._window = cast(this._questEngine.getXmlWindow("AchievementsResolutions"), IFrameWindow);
            this._window.findChildByTag("close").procedure = this.onWindowClose;
            this._window.center();
            this._window.visible = true;
            this.addClickListener(HEADER_BUTTON_CLOSE);
            this.addClickListener(SAVE_BUTTON);
            this.addClickListener(CANCEL_BUTTON);
        }

        function onWindowClose(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                this.close();
            }
        }

        function addClickListener(k:String)
        {
            var _local_2= this._window.findChildByName(k);
            if (_local_2 != null)
            {
                _local_2.addEventListener(WindowMouseEvent.CLICK, this.onMouseClick);
            }
        }

        function onMouseClick(event:WindowMouseEvent)
        {
            var title:String = null;
            var summary:String = null;
            switch (event.target.name)
            {
                case HEADER_BUTTON_CLOSE
                   | CANCEL_BUTTON:
                    this.close();
                    return;
                case OK_BUTTON:
                    return;
                case SAVE_BUTTON:
                    title = "${resolution.confirmation.title}";
                    summary = "${resolution.confirmation.text}";
                    this.close();
                    this._questEngine.windowManager.confirm(title, summary, 0, function (k:com.sulake.habbo.window.utils.IConfirmDialog, _arg_2:WindowEvent)
                    {
                        k.dispose();
                        if (_arg_2.type == WindowEvent.WINDOW_EVENT_OK)
                        {
                            _questEngine.send(new GetResolutionAchievementsMessageComposer(_stuffId, _selectedAchievementId));
                        }
                        else
                        {
                            _window.visible = true;
                        }
                    });
                    return;
            }
        }

        public function isVisible():Bool
        {
            return (this._window != null) && this._window.visible;
        }

        public function close()
        {
            if (this._window != null)
            {
                this._window.visible = false;
            }
        }

        function _Str_23858()
        {
            var _local_3:AchievementResolution = null;
            var _local_4:IWindowContainer = null;
            var k= Std.downcast(this._window.findChildByName("achievements") , IItemGridWindow);
            k.destroyGridItems();
            var _local_2= this._questEngine.getXmlWindow("AchievementSimple");
            final _iter_ = this._achievements; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                _local_4 = Std.downcast(_local_2.clone() , IWindowContainer);
                _local_4.id = _local_3.achievementId;
                this.refreshBadgeImage(_local_4, _local_3);
                _local_4.findChildByName("bg_region").procedure = this._Str_25036;
                _local_4.findChildByName("bg_selected_bitmap").visible = false;
                k.addGridItem(_local_4);
            }
        }

        function _Str_22239(k:Int, _arg_2:Bool)
        {
            var _local_3= Std.downcast(this._window.findChildByName("achievements") , IItemGridWindow);
            var _local_4= Std.downcast(_local_3.getGridItemByID(k) , IWindowContainer);
            if (_local_4 != null)
            {
                _local_4.findChildByName("bg_selected_bitmap").visible = _arg_2;
            }
        }

        function _Str_20512(k:Int)
        {
            if (this._selectedAchievementId != -1)
            {
                this._Str_22239(this._selectedAchievementId, false);
            }
            var _local_2= this._Str_23000(k);
            if (_local_2 == null)
            {
                return;
            }
            this._selectedAchievementId = k;
            this._Str_22239(this._selectedAchievementId, true);
            this._window.findChildByName("achievement.name").caption = this._questEngine.localization.getBadgeName(_local_2.badgeId);
            this._window.findChildByName("achievement.description").caption = this._questEngine.localization.getBadgeDesc(_local_2.badgeId);
            this._window.findChildByName("achievement.level").caption = Std.string(_local_2.level);
            this._questEngine.localization.registerParameter("resolution.achievement.target.value", "level", Std.string(_local_2._Str_20240));
            this._Str_16547(_local_2);
            if (_local_2.enabled)
            {
                this.enable();
            }
            else
            {
                this.disable(_local_2.state);
            }
        }

        function disable(k:Int)
        {
            this._window.setVisibleChildren(false, [SAVE_BUTTON]);
            this._window.setVisibleChildren(true, [DISABLED_REASON]);
            this._window.findChildByName(DISABLED_REASON).caption = (("${resolution.disabled." + Std.string(k)) + "}");
        }

        public function enable()
        {
            this._window.setVisibleChildren(true, [SAVE_BUTTON]);
            this._window.setVisibleChildren(false, [DISABLED_REASON]);
        }

        function _Str_25036(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this._Str_20512(_arg_2.parent.id);
        }

        function refreshBadgeImage(k:IWindowContainer, _arg_2:AchievementResolution)
        {
            var _local_3= Std.downcast(k.findChildByName("achievement_pic_bitmap") , IWidgetWindow);
            var _local_4= Std.downcast(_local_3.widget , IBadgeImageWidget);
            if (_arg_2 == null)
            {
                _local_3.visible = false;
                return;
            }
            cast(cast(_local_3.rootWindow, IWindowContainer).findChildByName("bitmap"), IStaticBitmapWrapperWindow).assetUri = "common_loading_icon";
            _local_4.badgeId = _arg_2.badgeId;
            _local_4.greyscale = (!_arg_2.enabled);
            _local_3.visible = true;
        }

        function _Str_16547(k:AchievementResolution)
        {
            var _local_2= Std.downcast(this._window.findChildByName("achievement_badge") , IWidgetWindow);
            var _local_3= Std.downcast(_local_2.widget , IBadgeImageWidget);
            cast(cast(_local_2.rootWindow, IWindowContainer).findChildByName("bitmap"), IStaticBitmapWrapperWindow).assetUri = "common_loading_icon";
            _local_3.badgeId = k.badgeId;
            _local_3.greyscale = (!k.enabled);
            _local_2.visible = true;
        }

        function _Str_23000(k:Int):AchievementResolution
        {
            var _local_2:AchievementResolution = null;
            final _iter_ = this._achievements; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.achievementId == k)
                {
                    return _local_2;
                }
            }
            return null;
        }

        public var questEngine(get,never):HabboQuestEngine;
public function  get_questEngine():HabboQuestEngine
        {
            return this._questEngine;
        }
    }

