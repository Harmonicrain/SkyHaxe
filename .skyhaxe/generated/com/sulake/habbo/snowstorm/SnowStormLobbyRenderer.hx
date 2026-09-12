package com.sulake.habbo.snowstorm
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.components.ITextWindow;

    /** Original five-row SnowStorm lounge list, backed by the generated sw_glist layout. */
     final class SnowStormLobbyRenderer
    {
        static inline final ROWS= 5;

        var _shell:SnowStormLobbyWindow;
        var _state:SnowStormViewState;
        var _services:SnowStormViewServices;
        var _instances:Array<ASAny> = [];
        var _page:Int = 0;

        public function new(shell:SnowStormLobbyWindow,
                                                state:SnowStormViewState,
                                                services:SnowStormViewServices)
        { this._shell = shell; this._state = state; this._services = services; }

        public function show(instances:Array<ASAny>, ticketCost:Int, skillLevel:Int)
        {
var row = 0, index = 0;            this._instances = instances == null ? [] : instances.copy();
            this._state.ticketCost = ticketCost;
            var pages= Std.int(Math.max(1, Math.fceil(this._instances.length / ROWS)));
            this._page = Std.int(Math.max(0, Math.min(this._page, pages - 1)));

            this._shell.clearBindings();
            this._shell.bindText("gs_button_create", this._services.text("gs_button_creategame"));
            this._shell.bindAction("gs_button_create", this.showCreate);
            this._shell.bindText("gs_link_highScr", this._services.text("gs_link_highscores"));
            this._shell.bindAction("gs_link_highScr", this.emitHighScores);
            this._shell.bindText("gs_link_gameRul", this._services.text("gs_link_gamerules"));
            this._shell.bindAction("gs_link_gameRul", this.emitRules);
            this._shell.bindText("gs_button_buytickets", this._services.text("gs_button_buytickets"));
            this._shell.bindAction("gs_button_buytickets", this.openTickets);
            this._shell.bindAction("gs_arrow_pageBack", this.previousPage);
            this._shell.bindAction("gs_arrow_pageFwd", this.nextPage);
            for (_tmp_ in 0...ROWS)
            {
row= _tmp_;
index= this._page * ROWS + row;
                if (index < this._instances.length)
                    this._shell.bindAction("gs_area_gameList" + Std.string(row + 1), this.selectRow,
                        this._instances[index]);
            }
            this._shell.renderWindow("ss_glist");
            this.renderRows();
            this.refreshTicketBalance();
            this.updatePaging(pages);
        }

        public function refreshTicketBalance()
        {
            if (this._shell == null || this._state == null) return;
            var descriptor:ASObject = this._shell.elementById("gs_numtickets");
            var field:ITextWindow = descriptor == null ? null : ASCompat.dynamicAs(descriptor.window , ITextWindow);
            if (field != null) field.text = this._state.balanceText;
        }

        public function resetPage()
        { this._page = 0; }

        function renderRows()
        {
var row = 0, descriptor:ASObject  = null, index = 0, value:ASObject  = null, member:String  = null;            for (_tmp_ in 0...ROWS)
            {
row= _tmp_;
descriptor= this._shell.elementById("gs_area_gameList" + Std.string(row + 1));
                if (descriptor == null) continue;
index= this._page * ROWS + row;
value= index < this._instances.length ? this._instances[index] : null;
member= this.rowMember(value);
                this._shell.surface.assignBitmap(ASCompat.dynamicAs(descriptor.window , IBitmapWrapperWindow), member);
                if (value == null)
                {
                    this._shell.addText("---", ASCompat.toInt(descriptor.x + 32), ASCompat.toInt(descriptor.y + 7),
                        ASCompat.toInt(ASCompat.toNumber(descriptor.w) - 35), 13, 0, false);
                    descriptor.actionWindow.disable();
                    continue;
                }
                this.addRowIcon(value, ASCompat.toInt(descriptor.x), ASCompat.toInt(descriptor.y));
                this._shell.addText(ASCompat.toString(value.name), ASCompat.toInt(descriptor.x + 32), ASCompat.toInt(descriptor.y + 2),
                    105, 13, 0, true);
                this._shell.addText(this.duration(ASCompat.toInt(value.lengthChoice)), ASCompat.toInt(descriptor.x + 137),
                    ASCompat.toInt(descriptor.y + 2), 51, 13, 0, false, "right");
                this._shell.addText(this.playerCaption(value), ASCompat.toInt(descriptor.x + 32), ASCompat.toInt(descriptor.y + 14),
                    76, 13, 0, false);
                this._shell.addText(this.actionText(value), ASCompat.toInt(descriptor.x + 109), ASCompat.toInt(descriptor.y + 13),
                    70, 13, 0, true, "right", true);
                this._shell.addPiece("sw_arr", ASCompat.toInt(descriptor.x + 181), ASCompat.toInt(descriptor.y + 17), 7, 8);
            }
        }

        function addRowIcon(value:ASObject, x:Int, y:Int)
        {
            if (ASCompat.toInt(value.rowKind) == 1)
                this._shell.addPiece("sw_ico_flag", x + 4, y + 1, 24, 24);
            else if (ASCompat.toInt(value.state) == 0)
                this._shell.addPiece("sw_ico_thumb", x + 8, y + 4, 18, 19);
            else
                this._shell.addPiece("sw_ico_bounce", x + 3, y + 6, 20, 15);
        }

        function rowMember(value:ASObject):String
        {
            if (value == null) return "sw_bg_emp3";
            if (ASCompat.toInt(value.rowKind) == 1) return "sw_bg_gry4";
            return ASCompat.toInt(value.state) == 0 ? "sw_bg_grn4" : "sw_bg_red4";
        }

        function actionText(value:ASObject):String
        {
            if (ASCompat.toInt(value.rowKind) == 1) return this._services.text("gs_button_go_finished");
            if (ASCompat.toInt(value.state) == 0) return this._services.text("gs_button_go_created");
            return this._services.text("gs_button_go_started");
        }

        function playerCaption(value:ASObject):String
        {
            if (ASCompat.toInt(value.rowKind) == 1 && Std.is(value.playerNames , Array) && value.playerNames.length > 0)
                return value.playerNames.join(", ");
            return value.ownerName == null ? "" : ASCompat.toString(value.ownerName);
        }

        function selectRow(value:ASObject)
        {
            if (value == null) return;
            if (ASCompat.toInt(value.rowKind) == 1)
                this._services.emit(SnowStormViewEvent.FINISHED_SCORES,
                    {instanceId:value.id, resultId:value.resultId});
            else if (ASCompat.toInt(value.state) == 0)
                this._services.emit(SnowStormViewEvent.JOIN, {instanceId:value.id});
            else
                this._services.emit(SnowStormViewEvent.WATCH, {instanceId:value.id});
        }

        function previousPage(data:ASObject=null)
        { if (this._page > 0) { this._page--; this._services.redraw(); } }
        function nextPage(data:ASObject=null)
        { if ((this._page + 1) * ROWS < this._instances.length) { this._page++; this._services.redraw(); } }

        function updatePaging(pages:Int)
        {
            var page:ASObject = this._shell.elementById("gs_txt_pageNumber");
            var field:ITextWindow = page == null ? null : ASCompat.dynamicAs(page.window , ITextWindow);
            if (field != null) field.text = Std.string(this._page + 1) + "/" + Std.string(pages);
            this.setEnabled("gs_arrow_pageBack", this._page > 0);
            this.setEnabled("gs_arrow_pageFwd", this._page + 1 < pages);
        }

        function setEnabled(id:String, enabled:Bool)
        {
            var descriptor:ASObject = this._shell.elementById(id);
            var actionWindow:IWindow = descriptor == null ? null : ASCompat.dynamicAs(descriptor.actionWindow , IWindow);
            if (actionWindow == null) return;
            var visual= ASCompat.dynamicAs(descriptor.window , IWindow);
            if (enabled) actionWindow.enable(); else actionWindow.disable();
            // AIR blend values are normalized to 0..1. The previous Director-style 100/55 values
            // were both clamped opaque, leaving unavailable arrows looking fully active.
            var blend= enabled ? 1 : 0.55;
            actionWindow.blend = blend;
            if (visual != null && visual != actionWindow) visual.blend = blend;
        }

        function duration(choice:Int):String
        { return choice == 1 ? "2:00" : (choice == 2 ? "3:00" : "5:00"); }
        function showCreate(data:ASObject=null)
        { this._services.emit(SnowStormViewEvent.SHOW_CREATE); }
        function emitHighScores(data:ASObject=null)
        { this._services.emit(SnowStormViewEvent.HIGH_SCORES); }
        function emitRules(data:ASObject=null)
        { this._services.emit(SnowStormViewEvent.GAME_RULES); }
        function openTickets(data:ASObject=null) { this._services.openTickets(); }

        public function dispose()
        { this._instances = []; this._shell = null; this._state = null; this._services = null; }
    }

