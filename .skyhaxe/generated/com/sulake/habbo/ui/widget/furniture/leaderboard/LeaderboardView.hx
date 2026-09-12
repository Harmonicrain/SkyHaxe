package com.sulake.habbo.ui.widget.furniture.leaderboard
;
    import com.sulake.core.assets.IAsset;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.components.IDropMenuWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.avatar.IAvatarImage;
    import com.sulake.habbo.avatar.IAvatarImageListener;
    import com.sulake.habbo.avatar.IAvatarRenderManager;
    import com.sulake.habbo.avatar._enum.AvatarScaleType;
    import com.sulake.habbo.communication.messages.parser.games.OpenLeaderboardMessageParser;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.utils.HabboFaceFocuser;
    import com.sulake.habbo.window.IHabboWindowManager;
    import flash.display.BitmapData;

     class LeaderboardView implements IAvatarImageListener
    {
        static inline final ICON= "badge_rarity_badges_emblem_unique_extended";
        static inline final MAX_ROWS= 10;
        var _disposed:Bool = false;
        var _windowManager:IHabboWindowManager;
        var _localizations:IHabboLocalizationManager;
        var _assets:IAssetLibrary;
        var _requestCallback:ASFunction;
        var _profileCallback:ASFunction;
        var _avatarRenderManager:IAvatarRenderManager;
        var _window:IWindowContainer;
        var _rowViews:Array<ASAny>;
        var _entries:Array<ASAny>;
        var _ownView:LeaderboardEntryView;
        var _ownEntry:LeaderboardEntry;
        var _template:IWindowContainer;
        var _currentLeaderboardId:Int = 0;
        var _currentGameType:String = "";
        var _currentMetric:String = "";
        var _titleLocalizationCode:String = "";
        var _descriptionLocalizationCode:String = "";
        var _available:Array<ASAny> = [];
        var _currentPeriod:String = "WEEKLY";
        var _currentOffset:Int = 0;
        var _currentLimit:Int = 10;

        public function new(windowManager:IHabboWindowManager, localizations:IHabboLocalizationManager, assets:IAssetLibrary, requestCallback:ASFunction, profileCallback:ASFunction, avatarRenderManager:IAvatarRenderManager)
        {
            this._windowManager = windowManager;
            this._localizations = localizations;
            this._assets = assets;
            this._requestCallback = requestCallback;
            this._profileCallback = profileCallback;
            this._avatarRenderManager = avatarRenderManager;
            this._rowViews = [];
            this._entries = [];
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var window(get,never):IWindowContainer;
public function  get_window():IWindowContainer
        {
            return this._window;
        }

        public function show(data:OpenLeaderboardMessageParser)
        {
            var firstOpen= this._window == null;
            if (this._window == null)
            {
                this.createWindow();
            }
            if (this._window == null)
            {
                return;
            }
            this.updateCurrentState(data);
            this.applyTexts(data);
            this.populateRows(data);
            this._window.visible = true;
            // A refresh, page change or game filter response updates this same window. Re-centring on
            // every response discards the position the player chose and makes the dialog visibly jump.
            if (firstOpen)
            {
                this._window.center();
            }
            this._window.activate();
        }

        public function hide()
        {
            if (this._window != null)
            {
                this._window.visible = false;
            }
        }

        public function dispose()
        {
var view:LeaderboardEntryView  = null;            if (this._disposed)
            {
                return;
            }
            final _iter_ = this._rowViews; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
view = _tmp_;
                view.dispose();
            }
            this._rowViews = [];
            this._entries = [];
            if (this._ownView != null)
            {
                this._ownView.dispose();
                this._ownView = null;
            }
            this._ownEntry = null;
            this._template = null;
            this._requestCallback = null;
            this._profileCallback = null;
            this._avatarRenderManager = null;
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            this._windowManager = null;
            this._localizations = null;
            this._assets = null;
            this._disposed = true;
        }

        public function avatarImageReady(figure:String)
        {
            if (this._disposed || figure == null)
            {
                return;
            }
            this.renderEntryFacesForFigure(figure);
        }

        function createWindow()
        {
            var asset:IAsset = this._assets == null ? null : this._assets.getAssetByName("gamehall_leaderboard_xml");
            if (asset == null || asset.content == null)
            {
                return;
            }
            this._window = Std.downcast(this._windowManager.buildFromXML(new com.sulake.core.utils.xml.XML(asset.content), 1) , IWindowContainer);
            if (this._window == null)
            {
                return;
            }
            this._window.name = "leaderboard";
            var close= this._window.findChildByTag("close");
            if (close != null)
            {
                close.procedure = this.onClose;
            }
            var dropdownRegion= this._window.findChildByName("dropdown_region");
            if (dropdownRegion != null)
            {
                dropdownRegion.procedure = this.onDropdownOpen;
            }
            var dropdownOpener= this._window.findChildByName("dropdown_opener");
            if (dropdownOpener != null)
            {
                dropdownOpener.procedure = this.onDropdownOpen;
            }
            var dropdown= Std.downcast(this._window.findChildByName("hidden_dropdown") , IDropMenuWindow);
            if (dropdown != null)
            {
                dropdown.procedure = this.onDropdownSelection;
            }
            var previous= this._window.findChildByName("previous_btn");
            if (previous != null)
            {
                previous.procedure = this.onPrevious;
            }
            var next= this._window.findChildByName("next_btn");
            if (next != null)
            {
                next.procedure = this.onNext;
            }
            this.prepareRows();
        }

        function prepareRows()
        {
var index = 0, row:IWindowContainer  = null, view:LeaderboardEntryView  = null;            var list= Std.downcast(this._window.findChildByName("ranking_list") , IItemListWindow);
            if (list != null)
            {
                this._template = Std.downcast(list.getListItemByName("entry_template") , IWindowContainer);
                if (this._template != null)
                {
                    list.removeListItem(this._template);
                    this._template.visible = false;
                    for (_tmp_ in 0...MAX_ROWS)
                    {
index= _tmp_;
row= Std.downcast(this._template.clone() , IWindowContainer);
                        row.name = "gamehall_leaderboard_row_" + Std.string(index);
                        list.addListItem(row);
view= new LeaderboardEntryView(row, this._windowManager.assets);
                        if (view.profileRegion != null)
                        {
                            view.profileRegion.id = index;
                            view.profileRegion.procedure = this.onProfileClicked;
                        }
                        this._rowViews.push(view);
                    }
                }
            }
            var own= Std.downcast(this._window.findChildByName("own_container") , IWindowContainer);
            if (own != null)
            {
                this._ownView = new LeaderboardEntryView(own, this._windowManager.assets);
                if (this._ownView.profileRegion != null)
                {
                    this._ownView.profileRegion.id = -1;
                    this._ownView.profileRegion.procedure = this.onProfileClicked;
                }
            }
        }

        function applyTexts(data:OpenLeaderboardMessageParser)
        {
            var title= this.text(this._titleLocalizationCode, this.fallbackTitle(this._currentGameType, this._currentMetric));
            this.setText("hacky_title", title);
            this.setText("title_txt", title);
            this.setText("title_txt_shadow_0", title);
            this.setText("title_txt_shadow_1", title);
            this.setText("title_txt_shadow_2", title);
            this.setText("title_txt_shadow_3", title);
            var hasRows= data != null && data.rows != null && data.rows.length > 0;
            this.setText("rank_type_info", hasRows
                ? this.text(this._descriptionLocalizationCode, "Overview of the best " + title + " players.")
                : this.text("gamehall.leaderboard.empty", "No games have been completed yet. Win a game to appear here!"));
            this.setDropdownOptions();
            this.setButton("previous_btn", this.text("gamehall.leaderboard.previous", "Previous"), this.canGoPrevious());
            this.setButton("next_btn", this.text("gamehall.leaderboard.next", "Next"), this.canGoNext(data));

            var icon= Std.downcast(this._window.findChildByName("rank_type_extended_img") , IStaticBitmapWrapperWindow);
            if (icon != null)
            {
                icon.assetUri = ICON;
            }
        }

        function populateRows(data:OpenLeaderboardMessageParser)
        {
var             index = 0, entry:LeaderboardEntry  = null;            var rows= data == null || data.rows == null ? [] : data.rows;
            this._entries = [];
            index= 0;while (index < this._rowViews.length)
            {
                if (index < rows.length)
                {
entry= new LeaderboardEntry(rows[index]);
                    this._entries[index] = entry;
                    this._rowViews[index].setData(entry, (index % 2) == 0);
                    this.renderEntryFace(this._rowViews[index], entry);
                }
                else
                {
                    this._entries[index] = null;
                    this._rowViews[index].clearFaceBitmap();
                    this._rowViews[index].hide();
                }
index++;
            }
            if (this._ownView != null)
            {
                if (data != null && data.ownRow != null)
                {
                    this._ownEntry = new LeaderboardEntry(data.ownRow);
                    this._ownView.setData(this._ownEntry, true);
                    this.renderEntryFace(this._ownView, this._ownEntry);
                }
                else
                {
                    this._ownEntry = null;
                    this._ownView.clearFaceBitmap();
                    this._ownView.hide();
                }
            }
        }

        function renderEntryFacesForFigure(figure:String)
        {
var             index = 0;            var entry:LeaderboardEntry = null;
            index= 0;while (index < this._rowViews.length)
            {
                entry = index < this._entries.length ? ASCompat.dynamicAs(this._entries[index] , LeaderboardEntry) : null;
                if (entry != null && entry.figure == figure)
                {
                    this.renderEntryFace(this._rowViews[index], entry);
                }
index++;
            }
            if (this._ownEntry != null && this._ownEntry.figure == figure)
            {
                this.renderEntryFace(this._ownView, this._ownEntry);
            }
        }

        function renderEntryFace(view:LeaderboardEntryView, entry:LeaderboardEntry)
        {
            var avatar:IAvatarImage = null;
            var bitmap:BitmapData = null;
            if (view == null)
            {
                return;
            }
            view.clearFaceBitmap();
            if (entry == null || this._avatarRenderManager == null || entry.figure == null || entry.figure.length == 0)
            {
                return;
            }
            avatar = this._avatarRenderManager.createAvatarImage(entry.figure, AvatarScaleType.LARGE, null, this);
            if (avatar == null)
            {
                return;
            }
            bitmap = HabboFaceFocuser.focusUserFace(avatar, "head", 2, 1);
            avatar.dispose();
            if (bitmap != null)
            {
                view.setFaceBitmap(bitmap);
            }
        }

        function setText(name:String, value:String)
        {
            var text= Std.downcast(this._window.findChildByName(name) , ITextWindow);
            if (text != null)
            {
                text.text = value == null ? "" : value;
                text.caption = text.text;
            }
        }

        function setButton(name:String, caption:String, enabled:Bool)
        {
            var button= Std.downcast(this._window.findChildByName(name) , IButtonWindow);
            if (button != null)
            {
                button.caption = caption;
                if (enabled)
                {
                    button.enable();
                }
                else
                {
                    button.disable();
                }
            }
        }

        function text(key:String, fallback:String):String
        {
            if (this._localizations == null)
            {
                return fallback;
            }
            var value= this._localizations.getLocalization(key, fallback);
            return (value == null || value == "" || value == key) ? fallback : value;
        }

        function updateCurrentState(data:OpenLeaderboardMessageParser)
        {
            if (data == null)
            {
                this._currentLeaderboardId = 0;
                this._currentGameType = "";
                this._currentMetric = "";
                this._available = [];
                this._currentPeriod = "WEEKLY";
                this._currentOffset = 0;
                this._currentLimit = MAX_ROWS;
                return;
            }
            this._currentLeaderboardId = data.leaderboardId;
            this._currentGameType = data.gameType == null ? "" : data.gameType;
            this._currentMetric = data.metric == null ? "" : data.metric;
            this._titleLocalizationCode = data.titleLocalizationCode;
            this._descriptionLocalizationCode = data.descriptionLocalizationCode;
            this._available = data.available == null ? [] : data.available;
            this._currentPeriod = data.period == null || data.period == "" ? "WEEKLY" : data.period;
            this._currentOffset = Std.int(Math.max(0, data.offset));
            this._currentLimit = data.limit <= 0 ? MAX_ROWS : data.limit;
        }

        function setDropdownOptions()
        {
            var dropdown= Std.downcast(this._window.findChildByName("hidden_dropdown") , IDropMenuWindow);
            if (dropdown == null)
            {
                return;
            }

            var showSelector= this._available.length > 1;
            var region= this._window.findChildByName("dropdown_region");
            var opener= this._window.findChildByName("dropdown_opener");
            if (region != null) region.visible = showSelector;
            if (opener != null) opener.visible = showSelector;
            dropdown.visible = showSelector;
            dropdown.procedure = null;
            dropdown.populate(this.dropdownOptions());
            dropdown.selection = this.indexForLeaderboard(this._currentLeaderboardId);
            dropdown.procedure = this.onDropdownSelection;
        }

        function dropdownOptions():Array<ASAny>
        {
var definition:ASObject  = null;            var options:Array<ASAny> = [];
            final _iter_ = this._available; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
definition = _tmp_;
                options.push(this.text(ASCompat.toString(definition.menuLocalizationCode),
                    "Show Top " + this.fallbackTitle(ASCompat.toString(definition.gameType), ASCompat.toString(definition.metric))));
            }
            return options;
        }

        function fallbackTitle(gameType:String, metric:String):String
        {
var metricName:String  = null;            var game= gameType == null ? "" : new compat.RegExp("_", "g").replace(gameType.toLowerCase(), " ");
            game = game.length == 0 ? "Leaderboard" : game.charAt(0).toUpperCase() + game.substr(1);
            if (gameType == "ALL") game = "Games Hall";
            if (metric != null && metric.length > 0 && metric != "POINTS")
            {
metricName= new compat.RegExp("_", "g").replace(metric.toLowerCase(), " ");
                game += " " + metricName.charAt(0).toUpperCase() + metricName.substr(1);
            }
            return game;
        }

        function indexForLeaderboard(leaderboardId:Int):Int
        {
var             index = 0;            index= 0;while (index < this._available.length)
            {
                if (ASCompat.toInt(this._available[index].id) == leaderboardId) return index;
index++;
            }
            return 0;
        }

        function canGoPrevious():Bool
        {
            return this._currentOffset > 0;
        }

        function canGoNext(data:OpenLeaderboardMessageParser):Bool
        {
            return data != null && this._currentOffset + this._currentLimit < data.totalRows;
        }

        function onClose(event:WindowEvent, window:IWindow)
        {
            if (event.type == WindowMouseEvent.CLICK)
            {
                this.hide();
            }
        }

        function onDropdownOpen(event:WindowEvent, window:IWindow)
        {
            if (event.type != WindowMouseEvent.CLICK)
            {
                return;
            }

            var dropdown= Std.downcast(this._window.findChildByName("hidden_dropdown") , IDropMenuWindow);
            if (dropdown != null)
            {
                dropdown.openMenu();
                dropdown.activate();
            }
        }

        function onDropdownSelection(event:WindowEvent, window:IWindow)
        {
            if (event.type != WindowEvent.WINDOW_EVENT_SELECTED)
            {
                return;
            }

            var dropdown= Std.downcast(this._window.findChildByName("hidden_dropdown") , IDropMenuWindow);
            if (dropdown == null)
            {
                return;
            }

            if (dropdown.selection < 0 || dropdown.selection >= this._available.length)
            {
                return;
            }
            var leaderboardId= ASCompat.toInt(this._available[dropdown.selection].id);
            if (leaderboardId != this._currentLeaderboardId)
            {
                this.request(leaderboardId, this._currentPeriod, 0, this._currentLimit);
            }
        }

        function onPrevious(event:WindowEvent, window:IWindow)
        {
            if (event.type == WindowMouseEvent.CLICK && this.canGoPrevious())
            {
                this.request(this._currentLeaderboardId, this._currentPeriod, Std.int(Math.max(0, this._currentOffset - this._currentLimit)), this._currentLimit);
            }
        }

        function onNext(event:WindowEvent, window:IWindow)
        {
            if (event.type == WindowMouseEvent.CLICK)
            {
                this.request(this._currentLeaderboardId, this._currentPeriod, this._currentOffset + this._currentLimit, this._currentLimit);
            }
        }

        function onProfileClicked(event:WindowEvent, window:IWindow)
        {
            var entry:LeaderboardEntry = null;
            if (event.type != WindowMouseEvent.CLICK || window == null || this._profileCallback == null)
            {
                return;
            }
            if (window.id == -1)
            {
                entry = this._ownEntry;
            }
            else if (window.id >= 0 && window.id < this._entries.length)
            {
                entry = ASCompat.dynamicAs(this._entries[window.id] , LeaderboardEntry);
            }
            if (entry != null && entry.userId > 0)
            {
                this._profileCallback(entry.userId);
            }
        }

        function request(leaderboardId:Int, period:String, offset:Int, limit:Int)
        {
            if (this._requestCallback != null)
            {
                this._requestCallback(leaderboardId, period == null || period == "" ? "WEEKLY" : period, Math.max(0, offset), limit <= 0 ? MAX_ROWS : limit);
            }
        }
    }

