package com.sulake.habbo.quest.rewardtrack.view
;
    import com.sulake.core.assets.IAsset;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.utils.WindowUtils;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.quest.rewardtrack.data.RewardTrack;
    import com.sulake.habbo.quest.rewardtrack.data.RewardTrackPrize;
    import com.sulake.habbo.quest.rewardtrack.data.RewardTrackRewardDisplayWrapper;
    import com.sulake.habbo.quest.rewardtrack.data.RewardTrackTask;
    import com.sulake.habbo.quest.rewardtrack.data.RewardTrackTaskLevel;
    import com.sulake.habbo.quest.rewardtrack.IRewardTrackController;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.window.widgets.IAvatarImageWidget;
    import com.sulake.habbo.window.widgets.IProductIconWidget;

     class RewardTrackView
    {
        static inline final TASK_ROW_HEIGHT= 61;
        static inline final TASK_PROGRESS_WIDTH= 200;
        static inline final LEVEL_PROGRESS_WIDTH= 260;
        static inline final PROGRESS_INCOMPLETE_COLOR:UInt = 0xEBA60C;
        static inline final PROGRESS_COMPLETE_COLOR:UInt = 0x71AF24;
        static inline final MIN_PRIZE_SPACING= 15;
        static inline final FILTER_ALL= 0;
        static inline final FILTER_IN_PROGRESS= 1;
        static inline final FILTER_COMPLETED= 2;
        static inline final TAB_SELECTED_TEXT:UInt = 0xFFFFFF;
        static inline final TAB_NOT_SELECTED_TEXT:UInt = 0x444444;
        static inline final TASK_DEFAULT_COLOR:UInt = 0xF0F0F0;
        static inline final TASK_COMPLETE_COLOR:UInt = 0xE6F4DF;
        static inline final TASK_SELECTED_COLOR:UInt = 0xB7D8F4;

        var _windowManager:IHabboWindowManager;
        var _localizations:IHabboLocalizationManager;
        var _assets:IAssetLibrary;
        var _controller:IRewardTrackController;
        var _window:IFrameWindow;
        var _taskTemplate:IWindow;
        var _levelTemplate:IWindow;
        var _prizeTemplate:IWindow;
        var _premiumPrizeTemplate:IWindow;
        var _pointIndicatorTemplate:IWindow;
        var _ownFigure:String;
        var _ownUserId:Int = 0;
        var _claimTargets:ASDictionary<ASAny,ASAny>;
        var _premiumTargets:ASDictionary<ASAny,ASAny>;
        var _taskTargets:ASDictionary<ASAny,ASAny>;
        var _tabTargets:ASDictionary<ASAny,ASAny>;
        var _currentTrack:RewardTrack;
        var _prizeLayout:RewardTrackPrizeLayout = new RewardTrackPrizeLayout();
        var _prizePage:Int = 0;
        var _selectedTask:RewardTrackTask;
        var _hintInternalLink:String;
        var _taskFilter:Int = 0;
        var _disposed:Bool = false;

        public function new(windowManager:IHabboWindowManager, localizations:IHabboLocalizationManager, assets:IAssetLibrary, controller:IRewardTrackController, ownFigure:String = null, ownUserId:Int = 0)
        {
            this._windowManager = windowManager;
            this._localizations = localizations;
            this._assets = assets;
            this._controller = controller;
            this._ownFigure = ownFigure;
            this._ownUserId = ownUserId;
            this._claimTargets = new ASDictionary<ASAny,ASAny>(true);
            this._premiumTargets = new ASDictionary<ASAny,ASAny>(true);
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function show(track:RewardTrack)
        {
            var windowCreated= false;
            if (track == null || this._disposed)
            {
                return;
            }
            if (this._window == null)
            {
                this.createWindow();
                windowCreated = true;
            }
            if (this._window == null)
            {
                return;
            }
            this.populate(track);
            this._window.visible = true;
            if (windowCreated)
            {
                this._window.center();
            }
            this._window.activate();
        }

        public function taskProgressUpdated(task:RewardTrackTask, hadProgress:Bool, wasComplete:Bool)
        {
            if (this._currentTrack == null || this._window == null || this._disposed)
            {
                return;
            }
            this.refreshTrackSummary(this._currentTrack);
            this.populateMainProgress(this._currentTrack, false);
            this.populatePrizes(this._currentTrack);
            this.refreshTaskProgress(task, hadProgress, wasComplete);
        }

        public function prizeClaimed(prize:RewardTrackPrize)
        {
            if (this._currentTrack == null || this._window == null || this._disposed)
            {
                return;
            }
            this.refreshTrackSummary(this._currentTrack);
            this.populatePrizes(this._currentTrack);
        }

        public function premiumPurchased()
        {
            if (this._currentTrack == null || this._window == null || this._disposed)
            {
                return;
            }
            this.refreshTrackSummary(this._currentTrack);
            this.populateMainProgress(this._currentTrack, false);
            this.populatePrizes(this._currentTrack);
            this.refreshPremiumInfo(this._currentTrack);
            this.populateTaskList(this._currentTrack);
            if (this._selectedTask != null)
            {
                this.populateTaskDetails(this._currentTrack, this._selectedTask);
            }
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            if (this._taskTemplate != null)
            {
                this._taskTemplate.dispose();
                this._taskTemplate = null;
            }
            if (this._levelTemplate != null)
            {
                this._levelTemplate.dispose();
                this._levelTemplate = null;
            }
            if (this._prizeTemplate != null)
            {
                this._prizeTemplate.dispose();
                this._prizeTemplate = null;
            }
            if (this._premiumPrizeTemplate != null)
            {
                this._premiumPrizeTemplate.dispose();
                this._premiumPrizeTemplate = null;
            }
            if (this._pointIndicatorTemplate != null)
            {
                this._pointIndicatorTemplate.dispose();
                this._pointIndicatorTemplate = null;
            }
            this._windowManager = null;
            this._localizations = null;
            this._assets = null;
            this._controller = null;
            this._claimTargets = null;
            this._premiumTargets = null;
            this._taskTargets = null;
            this._tabTargets = null;
            this._currentTrack = null;
            this._selectedTask = null;
            this._ownFigure = null;
            this._disposed = true;
        }

        function createWindow()
        {
            var asset:IAsset = this._assets != null ? this._assets.getAssetByName("reward_track_main_xml") : null;
            if (asset == null)
            {
                return;
            }
            this._window = Std.downcast(this._windowManager.buildFromXML((asset.content : com.sulake.core.utils.xml.XML) , 1) , IFrameWindow);
            if (this._window == null)
            {
                return;
            }
            this._window.procedure = this.onWindowEvent;
            this.captureTemplates();
            this.initializeTabs();
            this.refreshOwnAvatar();
        }

        public function setOwnUser(figure:String, userId:Int)
        {
            this._ownFigure = figure;
            this._ownUserId = userId;
            this.refreshOwnAvatar();
        }

        function refreshOwnAvatar()
        {
            var widgetWindow:IWidgetWindow = this._window != null ? Std.downcast(this._window.findChildByName("own_avatar") , IWidgetWindow) : null;
            var avatarWidget:IAvatarImageWidget = widgetWindow != null ? Std.downcast(widgetWindow.widget , IAvatarImageWidget) : null;
            if (avatarWidget == null)
            {
                return;
            }
            if (this._ownFigure != null && this._ownFigure != "")
            {
                avatarWidget.figure = this._ownFigure;
            }
            if (this._ownUserId > 0)
            {
                avatarWidget.userId = this._ownUserId;
            }
        }

        function captureTemplates()
        {
            var tasks= Std.downcast(this._window.findChildByName("tasks") , IItemListWindow);
            var levels= Std.downcast(this._window.findChildByName("levels") , IItemListWindow);
            var prizeContent= Std.downcast(this._window.findChildByName("prize_content") , IWindowContainer);
            var template:IWindow = null;

            if (tasks != null)
            {
                template = tasks.getListItemByName("task_template");
                if (template != null)
                {
                    this._taskTemplate = template.clone();
                }
                tasks.destroyListItems();
            }
            if (levels != null)
            {
                template = levels.getListItemByName("level_template");
                if (template != null)
                {
                    this._levelTemplate = template.clone();
                }
                levels.destroyListItems();
            }
            if (prizeContent != null)
            {
                template = prizeContent.findChildByName("prize_template");
                if (template != null)
                {
                    this._prizeTemplate = template.clone();
                    prizeContent.removeChild(template);
                    template.dispose();
                }
                template = prizeContent.findChildByName("prize_template_premium");
                if (template != null)
                {
                    this._premiumPrizeTemplate = template.clone();
                    prizeContent.removeChild(template);
                    template.dispose();
                }
            }
            var pointsIndicator= Std.downcast(this._window.findChildByName("points_indicator") , IWindowContainer);
            if (pointsIndicator != null)
            {
                template = pointsIndicator.findChildByName("point_indicator_template");
                if (template != null)
                {
                    this._pointIndicatorTemplate = template.clone();
                    pointsIndicator.removeChild(template);
                    template.dispose();
                }
            }
        }

        function populate(track:RewardTrack)
        {
            var firstTask:RewardTrackTask = null;
            this._currentTrack = track;
            this._window.caption = this.text("reward_track.window.title", "Reward Track");
            this.setText(this._window, "track_title_txt", this.text("reward_track." + track.id + ".name", track.id));
            this.setText(this._window, "track_desc_txt", this.text("reward_track." + track.id + ".desc", ""));
            this.setText(this._window, "track_instructions_txt", this.text("reward_track." + track.id + ".info", ""));
            this.setText(this._window, "points_total_collected_txt", Std.string(track.points));
            this.setText(this._window, "rewards_collected_txt", this.rewardsCollectedText(track));
            this.setText(this._window, "tasks_completion_txt", this.tasksCompletionText(track));

            this.populateMainProgress(track, true);
            this.populateTaskList(track);
            this.populatePrizes(track);
            this.refreshPremiumInfo(track);
            if (this._selectedTask == null || track.getTask(this._selectedTask.id) == null || !this.matchesTaskFilter(this._selectedTask))
            {
                this._selectedTask = this.firstVisibleTask(track);
            }
            firstTask = this._selectedTask;
            if (firstTask != null)
            {
                this.populateTaskDetails(track, firstTask);
            }
            else
            {
                this.clearTaskDetails();
            }
            this.refreshTabs();
        }

        function refreshTrackSummary(track:RewardTrack)
        {
            this.setText(this._window, "points_total_collected_txt", Std.string(track.points));
            this.setText(this._window, "rewards_collected_txt", this.rewardsCollectedText(track));
            this.setText(this._window, "tasks_completion_txt", this.tasksCompletionText(track));
        }

        function refreshTaskProgress(task:RewardTrackTask, hadProgress:Bool, wasComplete:Bool)
        {
            var list:IItemListWindow = null;
            var row:IWindowContainer = null;
            var taskChangedFilterState = false;
            if (task == null || this._currentTrack == null)
            {
                return;
            }
            taskChangedFilterState = hadProgress != (task.progressCount > 0) || wasComplete != this.isTaskComplete(task);
            if (this._taskFilter != FILTER_ALL && taskChangedFilterState)
            {
                this.populateTaskList(this._currentTrack);
            }
            else
            {
                list = Std.downcast(this._window.findChildByName("tasks") , IItemListWindow);
                row = list != null ? Std.downcast(list.getListItemByName("task_" + task.id) , IWindowContainer) : null;
                if (row != null)
                {
                    this.populateTaskRow(row, this._currentTrack, task);
                }
            }
            if (this._selectedTask == task || (this._selectedTask != null && this._selectedTask.id == task.id))
            {
                if (this.matchesTaskFilter(task))
                {
                    this._selectedTask = task;
                    this.populateTaskDetails(this._currentTrack, task);
                }
                else
                {
                    this._selectedTask = this.firstVisibleTask(this._currentTrack);
                    if (this._selectedTask != null)
                    {
                        this.populateTaskDetails(this._currentTrack, this._selectedTask);
                    }
                    else
                    {
                        this.clearTaskDetails();
                    }
                }
            }
            this.refreshTabs();
        }

        function populateTaskList(track:RewardTrack)
        {
            var list= Std.downcast(this._window.findChildByName("tasks") , IItemListWindow);
            var task:RewardTrackTask = null;
            var row:IWindowContainer = null;
            var i = 0;
            if (list == null || this._taskTemplate == null)
            {
                return;
            }
            list.destroyListItems();
            this._taskTargets = new ASDictionary<ASAny,ASAny>(true);
            final _iter_ = track.tasks; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
task  = _tmp_;
                if (!this.matchesTaskFilter(task))
                {
                    continue;
                }
                row = Std.downcast(this._taskTemplate.clone() , IWindowContainer);
                if (row == null)
                {
                    continue;
                }
                row.name = "task_" + task.id;
                row.height = TASK_ROW_HEIGHT;
                row.procedure = this.onWindowEvent;
                this._taskTargets[row] = task;
                this.populateTaskRow(row, track, task);
                list.addListItem(row);
                i++;
            }
            list.arrangeListItems();
        }

        function populateTaskRow(row:IWindowContainer, track:RewardTrack, task:RewardTrackTask)
        {
            var activeLevel= this.activeLevel(task);
            var required= activeLevel != null ? activeLevel.requiredCount : 0;
            var reward= activeLevel != null ? activeLevel.pointsReward : 0;
            this.setText(row, "task_name", this.taskName(track, task));
            this.setText(row, "task_description", this.taskDescription(track, task));
            this.setText(row, "task_progress_txt", Std.string(task.progressCount) + " / " + Std.string(required));
            this.setText(row, "track_reward_txt", Std.string(reward));
            this.setImage(row, "task_image", this.taskIcon(task));
            this.setProgress(row, task.progressCount, required, TASK_PROGRESS_WIDTH);
            this.setTaskRowStyle(row, task == this._selectedTask, this.isTaskComplete(task));
        }

        function populateTaskDetails(track:RewardTrack, task:RewardTrackTask)
        {
var             i = 0;            var levels= Std.downcast(this._window.findChildByName("levels") , IItemListWindow);
            var level:RewardTrackTaskLevel = null;
            var row:IWindowContainer = null;
            var i = 0;
            var hintKey= "reward_track." + track.id + ".task." + task.id + ".hint";
            this.setText(this._window, "task_info_name", this.taskName(track, task));
            this.setText(this._window, "task_info_description", this.taskDescription(track, task));
            this.setText(this._window, "task_hint_text", this.text(hintKey + ".desc", ""));
            this.setHintButton(hintKey);
            this.setImage(this._window, "task_info_img", this.taskIcon(task));
            if (levels == null || this._levelTemplate == null)
            {
                return;
            }
            levels.destroyListItems();
            i= 0;while (i < task.levels.length)
            {
                level = ASCompat.dynamicAs(task.levels[i] , RewardTrackTaskLevel);
                row = Std.downcast(this._levelTemplate.clone() , IWindowContainer);
                if (row == null)
                {
                    i++;continue;
                }
                this.setText(row, "level_name", this.levelText(i + 1));
                this.setText(row, "level_progress_txt", Std.string(Math.min(task.progressCount, level.requiredCount)) + " / " + Std.string(level.requiredCount));
                this.setText(row, "level_reward_txt", Std.string(level.pointsReward));
                this.setProgress(row, task.progressCount, level.requiredCount, LEVEL_PROGRESS_WIDTH);
                this.setVisible(row, "completed_icon", task.progressCount >= level.requiredCount);
                this.setVisible(row, "locked_icon", level.premium && !track.premium);
                levels.addListItem(row);
i++;
            }
            levels.arrangeListItems();
        }

        function clearTaskDetails()
        {
            var levels= Std.downcast(this._window.findChildByName("levels") , IItemListWindow);
            this.setText(this._window, "task_info_name", "");
            this.setText(this._window, "task_info_description", "");
            this.setText(this._window, "task_hint_text", "");
            this._hintInternalLink = "";
            this.setVisible(this._window, "hint_redirect_btn", false);
            this.setImage(this._window, "task_info_img", "");
            if (levels != null)
            {
                levels.destroyListItems();
            }
        }

        function populatePrizes(track:RewardTrack)
        {
            var prizeContent= Std.downcast(this._window.findChildByName("prize_content") , IWindowContainer);
            var prize:RewardTrackPrize = null;
            var prizeWindow:IWindowContainer = null;
            var template:IWindow = null;
            var product:IWidgetWindow = null;
            var pointValues:Array<ASAny> = [];
            var pointCenters:Array<ASAny> = [];
            var center = 0;
            var layout:ASObject = null;
            var i = 0;
            if (prizeContent == null || this._prizeTemplate == null)
            {
                return;
            }
            this._claimTargets = new ASDictionary<ASAny,ASAny>(true);
            this._premiumTargets = new ASDictionary<ASAny,ASAny>(true);
            while (prizeContent.numChildren > 0)
            {
                prizeContent.removeChildAt(0).dispose();
            }
            this.clearPointIndicators();
            final _iter_ = track.prizes; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
prize  = _tmp_;
                if (this._prizeLayout.pageForPoints(prize.requiredPoints) != this._prizePage)
                {
                    continue;
                }
                template = prize.premium ? this._premiumPrizeTemplate : this._prizeTemplate;
                if (template == null)
                {
                    continue;
                }
                prizeWindow = Std.downcast(template.clone() , IWindowContainer);
                if (prizeWindow == null)
                {
                    continue;
                }
                prizeWindow.name = "prize_" + prize.id;
                center = Std.int(Math.fround(this._prizeLayout.xForPoints(prize.requiredPoints, this._prizePage)));
                prizeWindow.x = Std.int(Math.fround(center - (prizeWindow.width / 2)));
                prizeWindow.y = template.y;
                if (pointValues.indexOf(prize.requiredPoints) < 0)
                {
                    pointValues.push(prize.requiredPoints);
                    pointCenters.push(center);
                }
                product = Std.downcast(prizeWindow.findChildByName("product_icon") , IWidgetWindow);
                if (product != null && Std.is(product.widget , IProductIconWidget))
                {
                    cast(product.widget, IProductIconWidget).productInfo = new RewardTrackRewardDisplayWrapper(prize);
                }
                this.configurePrizeWindow(prizeWindow, prize);
                this.setVisible(prizeWindow, "locked_icon", prize.isPremiumLocked(track));
                this.setVisible(prizeWindow, "claimed_icon", prize.claimed);
                if (prize.isClaimable(track))
                {
                    this.registerClaimTarget(prizeWindow, track.id, prize.id);
                }
                else if (prize.isPremiumLocked(track))
                {
                    this.registerPremiumTarget(prizeWindow, track);
                }
                prizeContent.addChild(prizeWindow);
                this.setPrizeDimmed(prizeWindow, !prize.hasEnoughPoints(track));
                i++;
            }
            this.populatePointIndicators(track, pointValues, pointCenters);
            this.refreshPrizeNavigation();
        }

        function refreshPremiumInfo(track:RewardTrack)
        {
            var button:IWindow = this._window != null ? this._window.findChildByName("get_premium_btn") : null;
            var info:IWindow = this._window != null ? this._window.findChildByName("reward_info_not_premium") : null;
            this.setVisible(this._window, "reward_info", ((!track.hasPremiumConfig) || track.premium));
            this.setVisible(this._window, "reward_info_not_premium", (track.hasPremiumConfig && (!track.premium)));
            if (button != null)
            {
                button.procedure = this.onWindowEvent;
            }
            if (info != null)
            {
                info.procedure = this.onWindowEvent;
            }
        }

        function refreshPrizeNavigation()
        {
            var previousButton= this._window.findChildByName("previous_btn");
            var nextButton= this._window.findChildByName("next_btn");
            var multiPage= (this._prizeLayout.pageCount > 1);
            if (previousButton != null)
            {
                previousButton.visible = multiPage;
                if (multiPage)
                {
                    WindowUtils.disableSection(previousButton, (this._prizePage <= 0));
                }
            }
            if (nextButton != null)
            {
                nextButton.visible = multiPage;
                if (multiPage)
                {
                    WindowUtils.disableSection(nextButton, (this._prizePage >= (this._prizeLayout.pageCount - 1)));
                }
            }
        }

        function handlePrizeNavClick(window:IWindow):Bool
        {
            var page = 0;
            if (((window == null) || (this._currentTrack == null)))
            {
                return false;
            }
            if (window.name == "previous_btn")
            {
                page = Std.int(Math.max(0, (this._prizePage - 1)));
            }
            else
            {
                if (window.name == "next_btn")
                {
                    page = Std.int(Math.min((this._prizeLayout.pageCount - 1), (this._prizePage + 1)));
                }
                else
                {
                    return false;
                }
            }
            if (page != this._prizePage)
            {
                this._prizePage = page;
                this.populateMainProgress(this._currentTrack, false);
                this.populatePrizes(this._currentTrack);
            }
            return true;
        }

        function populateMainProgress(track:RewardTrack, resetPage:Bool)
        {
            var rewards= Std.downcast(this._window.findChildByName("rewards") , IWindowContainer);
            var trackContainer:IWindowContainer = rewards != null ? Std.downcast(rewards.findChildByName("track") , IWindowContainer) : null;
            var loadingBar:IWindowContainer = trackContainer != null ? Std.downcast(trackContainer.findChildByName("loading_bar") , IWindowContainer) : null;
            var progress:IWindowContainer = loadingBar != null ? Std.downcast(loadingBar.findChildByName("progress") , IWindowContainer) : null;
            var prizeContent= Std.downcast(this._window.findChildByName("prize_content") , IWindowContainer);
            var maxWidth= loadingBar != null ? loadingBar.width : 602;
            var contentWidth= prizeContent != null ? prizeContent.width : maxWidth;
            this._prizeLayout.rebuild(track, contentWidth, this._prizeTemplate != null ? this._prizeTemplate.width : 80, MIN_PRIZE_SPACING);
            if (resetPage)
            {
                this._prizePage = this._prizeLayout.pageForPoints(track.points);
            }
            this._prizePage = Std.int(Math.max(0, Math.min((this._prizeLayout.pageCount - 1), this._prizePage)));
            var fillWidth= Std.int(Math.fround(this._prizeLayout.xForPoints(track.points, this._prizePage)));
            if (progress == null)
            {
                return;
            }
            fillWidth = Std.int(Math.min(maxWidth, Math.max(0, fillWidth)));
            progress.width = fillWidth;
            this.resizeMainProgressChildren(progress, fillWidth, maxWidth);
        }

        function configurePrizeWindow(prizeWindow:IWindowContainer, prize:RewardTrackPrize)
        {
            var product= Std.downcast(prizeWindow.findChildByName("product_icon") , IWidgetWindow);
            var quantity= prizeWindow.findChildByName("quantity_container");
            var quantityText= Std.downcast(prizeWindow.findChildByName("quantity_text") , ITextWindow);

            if (product != null)
            {
                product.y = prize.rewardAmount > 1 ? 5 : 8;
            }
            if (quantity != null)
            {
                quantity.visible = prize.rewardAmount > 1;
                if (prize.rewardAmount > 1 && quantityText != null)
                {
                    quantityText.caption = Std.string(prize.rewardAmount);
                    quantityText.width = Std.int(Math.fceil(quantityText.textWidth) + 2);
                    quantityText.x = Std.int((quantity.width - quantityText.width) / 2);
                }
            }
        }

        function setPrizeDimmed(prizeWindow:IWindowContainer, dimmed:Bool)
        {
            WindowUtils.disableSection(prizeWindow, dimmed, 0.75);
        }

        function populatePointIndicators(track:RewardTrack, pointValues:Array<ASAny>, pointCenters:Array<ASAny>)
        {
var             i = 0;            var pointsIndicator= Std.downcast(this._window.findChildByName("points_indicator") , IWindowContainer);
            var marker:IWindowContainer = null;
            var prize:RewardTrackPrize = null;
            var i = 0;
            var value = 0;
            if (pointsIndicator == null || this._pointIndicatorTemplate == null)
            {
                return;
            }
            i= 0;while (i < pointValues.length)
            {
                value = ASCompat.toInt(pointValues[i]);
                marker = Std.downcast(this._pointIndicatorTemplate.clone() , IWindowContainer);
                if (marker == null)
                {
                    i++;continue;
                }
                marker.name = "point_indicator_" + Std.string(value);
                marker.x = ASCompat.toInt(pointCenters[i]) - Std.int(marker.width / 2);
                marker.visible = true;
                this.setText(marker, "points_txt", Std.string(value));
                this.setImage(marker, "available_icon", track.points >= value ? "reward_track_available_icon" : "reward_track_not_available_icon");
                prize = this.findClaimablePrizeAtPoints(track, value);
                if (prize != null)
                {
                    this.registerClaimTarget(marker, track.id, prize.id);
                }
                else if (this.findPremiumLockedPrizeAtPoints(track, value) != null)
                {
                    this.registerPremiumTarget(marker, track);
                }
                pointsIndicator.addChild(marker);
i++;
            }
        }

        function clearPointIndicators()
        {
            var pointsIndicator= Std.downcast(this._window.findChildByName("points_indicator") , IWindowContainer);
            if (pointsIndicator == null)
            {
                return;
            }
            while (pointsIndicator.numChildren > 0)
            {
                pointsIndicator.removeChildAt(0).dispose();
            }
        }

        function registerClaimTarget(window:IWindow, trackId:String, rewardId:String)
        {
            var target:ASObject = {"trackId":trackId, "rewardId":rewardId};
            this.registerClaimTargetRecursive(window, target);
        }

        function registerClaimTargetRecursive(window:IWindow, target:ASObject)
        {
var                 i = 0;            var container:IWindowContainer = null;
            var i = 0;
            if (window == null || target == null || this._claimTargets == null)
            {
                return;
            }
            this._claimTargets[window] = target;
            window.procedure = this.onWindowEvent;
            container = Std.downcast(window , IWindowContainer);
            if (container != null)
            {
                i= 0;while (i < container.numChildren)
                {
                    this.registerClaimTargetRecursive(container.getChildAt(i), target);
i++;
                }
            }
        }

        function registerPremiumTarget(window:IWindow, track:RewardTrack)
        {
            this.registerPremiumTargetRecursive(window, track);
        }

        function registerPremiumTargetRecursive(window:IWindow, track:RewardTrack)
        {
var                 i = 0;            var container:IWindowContainer = null;
            var i = 0;
            if (window == null || track == null || this._premiumTargets == null)
            {
                return;
            }
            this._premiumTargets[window] = track;
            window.procedure = this.onWindowEvent;
            container = Std.downcast(window , IWindowContainer);
            if (container != null)
            {
                i= 0;while (i < container.numChildren)
                {
                    this.registerPremiumTargetRecursive(container.getChildAt(i), track);
i++;
                }
            }
        }

        function setProgress(container:IWindowContainer, value:Int, required:Int, maxWidth:Int)
        {
            var progress= Std.downcast(container.findChildByName("progress") , IWindowContainer);
            var ratio= required <= 0 ? 0 : Math.min(1, Math.max(0, value / required));
            var fillWidth= required <= 0 ? 0 : Std.int(Math.min(maxWidth, Math.max(value > 0 ? 1 : 0, (Math.min(value, required) / required) * maxWidth)));
            if (progress != null)
            {
                progress.width = fillWidth;
                this.resizeProgressChildren(progress, fillWidth);
                this.setProgressColor(progress, ratio >= 1);
            }
        }

        function resizeProgressChildren(progress:IWindowContainer, fillWidth:Int)
        {
var             i = 0;            var child:IWindow = null;
            var i = 0;
            if (progress == null)
            {
                return;
            }
            i= 0;while (i < progress.numChildren)
            {
                child = progress.getChildAt(i);
                if (child != null)
                {
                    child.width = Std.int(Math.max(0, fillWidth - child.x));
                }
i++;
            }
        }

        function setProgressColor(progress:IWindowContainer, complete:Bool)
        {
            var loadingBar= progress.findChildByName("loading_bar");
            if (loadingBar != null)
            {
                loadingBar.color = complete ? PROGRESS_COMPLETE_COLOR : PROGRESS_INCOMPLETE_COLOR;
            }
        }

        function resizeMainProgressChildren(progress:IWindowContainer, fillWidth:Int, maxWidth:Int)
        {
            var shape= progress.findChildByName("shape");
            var shapeWidth= fillWidth >= maxWidth - 4 ? maxWidth : fillWidth + 4;
            if (shape != null)
            {
                shape.width = Std.int(Math.max(0, Math.min(maxWidth, shapeWidth)));
            }
        }

        function setText(container:IWindowContainer, name:String, value:String)
        {
            var text= Std.downcast(container.findChildByName(name) , ITextWindow);
            if (text != null)
            {
                text.caption = value != null ? value : "";
            }
        }

        function setImage(container:IWindowContainer, name:String, assetUri:String)
        {
            var bitmap= Std.downcast(container.findChildByName(name) , IStaticBitmapWrapperWindow);
            if (bitmap != null)
            {
                bitmap.assetUri = assetUri;
            }
        }

        function setVisible(container:IWindowContainer, name:String, visible:Bool)
        {
            var window= container.findChildByName(name);
            if (window != null)
            {
                window.visible = visible;
            }
        }

        function setHintButton(hintKey:String)
        {
            var button= Std.downcast(this._window.findChildByName("hint_redirect_btn") , IButtonWindow);
            var buttonText= this.text(hintKey + ".button_text", "");
            this._hintInternalLink = this.text(hintKey + ".internal_link", "");
            if (button == null)
            {
                return;
            }
            button.visible = this._hintInternalLink != "" && buttonText != "";
            button.caption = buttonText;
            button.procedure = this.onWindowEvent;
        }

        function setTaskRowStyle(row:IWindowContainer, selected:Bool, completed:Bool)
        {
            var border= row.findChildByName("task_border");
            if (border != null)
            {
                border.color = selected ? TASK_SELECTED_COLOR : (completed ? TASK_COMPLETE_COLOR : TASK_DEFAULT_COLOR);
            }
        }

        function findClaimablePrizeAtPoints(track:RewardTrack, points:Int):RewardTrackPrize
        {
            var prize:RewardTrackPrize = null;
            if (track == null)
            {
                return null;
            }
            final _iter_ = track.prizes; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
prize  = _tmp_;
                if (!prize.premium && prize.requiredPoints == points && prize.isClaimable(track))
                {
                    return prize;
                }
            }
            return null;
        }

        function findPremiumLockedPrizeAtPoints(track:RewardTrack, points:Int):RewardTrackPrize
        {
            var prize:RewardTrackPrize = null;
            if (track == null)
            {
                return null;
            }
            final _iter_ = track.prizes; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
prize  = _tmp_;
                if (prize.requiredPoints == points && prize.isPremiumLocked(track))
                {
                    return prize;
                }
            }
            return null;
        }

        function finalLevel(task:RewardTrackTask):RewardTrackTaskLevel
        {
            return task.levels.length > 0 ? ASCompat.dynamicAs(task.levels[task.levels.length - 1] , RewardTrackTaskLevel) : null;
        }

        function activeLevel(task:RewardTrackTask):RewardTrackTaskLevel
        {
            var level:RewardTrackTaskLevel = null;
            if (task == null)
            {
                return null;
            }
            final _iter_ = task.levels; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
level  = _tmp_;
                if (level != null && task.progressCount < level.requiredCount)
                {
                    return level;
                }
            }
            return this.finalLevel(task);
        }

        function taskName(track:RewardTrack, task:RewardTrackTask):String
        {
            return this.text("reward_track." + track.id + ".task." + task.id + ".name", task.id);
        }

        function taskDescription(track:RewardTrack, task:RewardTrackTask):String
        {
            return this.text("reward_track." + track.id + ".task." + task.id + ".desc", task.actionType);
        }

        function taskIcon(task:RewardTrackTask):String
        {
            if (task == null || task.actionType == null || task.actionType == "")
            {
                return "reward_track_task_list";
            }
            return "reward_track_tasks_" + task.actionType.toLowerCase();
        }

        function tasksCompletionText(track:RewardTrack):String
        {
            var task:RewardTrackTask = null;
            var completed= 0;
            final _iter_ = track.tasks; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
task  = _tmp_;
                if (this.isTaskComplete(task))
                {
                    completed++;
                }
            }
            return this.replaceTokens(this.text("reward_track.tasks.progress", "%completed% / %total% completed"), completed, track.tasks.length);
        }

        function rewardsCollectedText(track:RewardTrack):String
        {
            var prize:RewardTrackPrize = null;
            var completed= 0;
            final _iter_ = track.prizes; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
prize  = _tmp_;
                if (prize.claimed)
                {
                    completed++;
                }
            }
            return this.replaceTokens(this.text("reward_track.profile.rewards_collected", "%completed% / %total% rewards collected"), completed, track.prizes.length);
        }

        function levelText(level:Int):String
        {
            var value= this.text("reward_track.levels.level", "Level %level%");
            if (value.indexOf("%level%") >= 0)
            {
                return value.split("%level%").join(Std.string(level));
            }
            return value + " " + Std.string(level);
        }

        function replaceTokens(value:String, completed:Int, total:Int):String
        {
            value = value.split("%completed%").join(Std.string(completed));
            value = value.split("%total%").join(Std.string(total));
            return value;
        }

        function isTaskComplete(task:RewardTrackTask):Bool
        {
            var _final= this.finalLevel(task);
            return _final != null && task.progressCount >= _final.requiredCount;
        }

        function matchesTaskFilter(task:RewardTrackTask):Bool
        {
            if (task == null)
            {
                return false;
            }
            if (this._taskFilter == FILTER_IN_PROGRESS)
            {
                return task.progressCount > 0 && !this.isTaskComplete(task);
            }
            if (this._taskFilter == FILTER_COMPLETED)
            {
                return this.isTaskComplete(task);
            }
            return true;
        }

        function firstVisibleTask(track:RewardTrack):RewardTrackTask
        {
            var task:RewardTrackTask = null;
            if (track == null)
            {
                return null;
            }
            final _iter_ = track.tasks; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
task  = _tmp_;
                if (this.matchesTaskFilter(task))
                {
                    return task;
                }
            }
            return null;
        }

        function text(key:String, fallback:String):String
        {
            var value= this._localizations != null ? this._localizations.getLocalization(key, fallback) : fallback;
            return value != null && value != "" ? value : fallback;
        }

        function onWindowEvent(event:WindowEvent, window:IWindow)
        {
            if (event.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            if (this.handleClaimClick(window))
            {
                return;
            }
            if (this.handlePremiumClick(window))
            {
                return;
            }
            if (this.handleTaskClick(window))
            {
                return;
            }
            if (this.handleTaskHintClick(window))
            {
                return;
            }
            if (this.handleTabClick(window))
            {
                return;
            }
            if (this.handlePrizeNavClick(window))
            {
                return;
            }
            if (window != null && window.tags.indexOf("close") >= 0)
            {
                this._window.visible = false;
            }
        }

        function handleClaimClick(window:IWindow):Bool
        {
            var target:ASObject = null;
            while (window != null)
            {
                target = this._claimTargets != null ? this._claimTargets[window] : null;
                if (target != null)
                {
                    if (this._controller != null)
                    {
                        this._controller.claimReward(target.trackId, target.rewardId);
                    }
                    return true;
                }
                window = window.parent;
            }
            return false;
        }

        function handlePremiumClick(window:IWindow):Bool
        {
            var track:RewardTrack = null;
            while (window != null)
            {
                if (window.name == "get_premium_btn" || window.name == "reward_info_not_premium")
                {
                    track = this._currentTrack;
                }
                else
                {
                    track = this._premiumTargets != null ? ASCompat.dynamicAs(this._premiumTargets[window] , RewardTrack) : null;
                }
                if (track != null)
                {
                    if (this._controller != null)
                    {
                        this._controller.openPremiumPurchaseConfirmation(track);
                    }
                    return true;
                }
                window = window.parent;
            }
            return false;
        }

        function handleTaskClick(window:IWindow):Bool
        {
            var task:RewardTrackTask = null;
            while (window != null)
            {
                task = this._taskTargets != null ? ASCompat.dynamicAs(this._taskTargets[window] , RewardTrackTask) : null;
                if (task != null)
                {
                    this._selectedTask = task;
                    if (this._currentTrack != null)
                    {
                        this.populateTaskList(this._currentTrack);
                        this.populateTaskDetails(this._currentTrack, task);
                    }
                    return true;
                }
                window = window.parent;
            }
            return false;
        }

        function handleTaskHintClick(window:IWindow):Bool
        {
            while (window != null)
            {
                if (window.name == "hint_redirect_btn")
                {
                    if (this._hintInternalLink != null && this._hintInternalLink != "" && this._controller != null)
                    {
                        this._controller.openTaskHintLink(this._hintInternalLink);
                    }
                    return true;
                }
                window = window.parent;
            }
            return false;
        }

        function initializeTabs()
        {
var             filter = 0;            var tabs= Std.downcast(this._window.findChildByName("tab_selection") , IItemListWindow);
            var filter = 0;
            var tab:IWindow = null;
            this._tabTargets = new ASDictionary<ASAny,ASAny>(true);
            if (tabs == null)
            {
                return;
            }
            filter= 0;while (filter < tabs.numListItems && filter < 3)
            {
                tab = tabs.getListItemAt(filter);
                if (tab != null)
                {
                    tab.name = this.tabName(filter);
                    tab.procedure = this.onWindowEvent;
                    this._tabTargets[tab] = filter;
                }
filter++;
            }
            this.refreshTabs();
        }

        function handleTabClick(window:IWindow):Bool
        {
            var filter:ASObject = null;
            while (window != null)
            {
                filter = this._tabTargets != null ? this._tabTargets[window] : null;
                if (filter != null)
                {
                    this.setTaskFilter(ASCompat.toInt(filter));
                    return true;
                }
                window = window.parent;
            }
            return false;
        }

        function setTaskFilter(filter:Int)
        {
            if (filter == this._taskFilter)
            {
                return;
            }
            this._taskFilter = filter;
            if (this._currentTrack != null)
            {
                this.populateTaskList(this._currentTrack);
                if (this._selectedTask == null || !this.matchesTaskFilter(this._selectedTask))
                {
                    this._selectedTask = this.firstVisibleTask(this._currentTrack);
                }
                if (this._selectedTask != null)
                {
                    this.populateTaskDetails(this._currentTrack, this._selectedTask);
                }
                else
                {
                    this.clearTaskDetails();
                }
            }
            this.refreshTabs();
        }

        function refreshTabs()
        {
var             filter = 0;            var tabs:IItemListWindow = this._window != null ? Std.downcast(this._window.findChildByName("tab_selection") , IItemListWindow) : null;
            var filter = 0;
            var tab:IWindowContainer = null;
            var active = false;
            var text:ITextWindow = null;
            if (tabs == null)
            {
                return;
            }
            filter= 0;while (filter < tabs.numListItems && filter < 3)
            {
                tab = Std.downcast(tabs.getListItemAt(filter) , IWindowContainer);
                if (tab == null)
                {
                    filter++;continue;
                }
                active = filter == this._taskFilter;
                this.setVisible(tab, "selected_view", active);
                this.setVisible(tab, "notselected_shape", !active);
                text = Std.downcast(tab.findChildByName("button_text") , ITextWindow);
                if (text != null)
                {
                    text.textColor = active ? TAB_SELECTED_TEXT : TAB_NOT_SELECTED_TEXT;
                }
filter++;
            }
        }

        function tabName(filter:Int):String
        {
            if (filter == FILTER_IN_PROGRESS)
            {
                return "tab_in_progress";
            }
            if (filter == FILTER_COMPLETED)
            {
                return "tab_completed";
            }
            return "tab_all";
        }
    }

