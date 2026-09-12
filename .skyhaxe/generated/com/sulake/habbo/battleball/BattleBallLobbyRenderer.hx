package com.sulake.habbo.battleball
;

    /**
     * The games list: rows, their state colouring, paging and the buttons beneath it.
     *
     * A mode of the shared lobby window: it draws through the shell and its chrome, keeps only
     * its own state, and reaches facade behaviour through BattleBallViewServices rather than
     * holding a reference to the view.
     */
     class BattleBallLobbyRenderer
    {
        var _shell:BattleBallLobbyWindow;
        var _state:BattleBallViewState;
        var _services:BattleBallViewServices;
        var _lobbyPage:Int = 0;
        /** Director reserved five 191x40 game slots starting here, one row every 40 pixels. */
        static inline final LOBBY_ROWS= 5;
        static inline final LOBBY_ROW_X= 7;
        static inline final LOBBY_ROW_Y= 131;
        static inline final LOBBY_ROW_WIDTH= 191;
        static inline final LOBBY_ROW_HEIGHT= 40;
        /** Row backgrounds in the cast are 1x33 strips, so a row is inset vertically inside its slot. */
        static inline final LOBBY_ROW_FILL_HEIGHT= 33;
        /**
         * State-driven row artwork, from getInstanceListItemBg in BouncingLoungeMenu Renderer Class.ls.
         * Icons are placed at 3-regPoint.locH, 4-regPoint.locV at their own size, so the offsets below
         * fold in each member's registration point (thumb reg -5,-2; flag reg -1,0; bounce reg 0,0).
         */
        static final ROW_BACKGROUNDS:ASObject = {
            "created": "bb_bg_grn", "started": "bb_bg_red", "finished": "bb_bg_gry", "empty": "bb_bg_emp"
        };

        public function new(shell:BattleBallLobbyWindow, state:BattleBallViewState,
                                 services:BattleBallViewServices)
        {
            this._shell = shell; this._state = state; this._services = services;
        }

        public function dispose()
        {
            this._shell = null; this._state = null; this._services = null;
        }
        /**
         * The original Shockwave games list. Nothing here positions anything: the layout comes from
         * the generated XML, which preserves the window definition still held in the cast, and
         * this only supplies the captions and the actions for the ids that definition declares.
         */
        public function show(instances:Array<ASAny>, ticketCost:Int, skillLevel:Int, error:String="")
        {
var slot = 0;            var games= instances == null ? [] : instances;
            var pages= Std.int(Math.max(1, Math.fceil(games.length / LOBBY_ROWS)));
            this._lobbyPage = Std.int(Math.max(0, Math.min(this._lobbyPage, pages - 1)));

            this._shell.clearBindings();
            this._shell.bindText("bb_txt_pageNumber", Std.string(this._lobbyPage + 1) + "/" + Std.string(pages));
            this._shell.bindText("bb_amount_tickets", this._state.balanceText);
            this._shell.bindAction("bb_arrow_pageBack", this.pageBack);
            this._shell.bindAction("bb_arrow_pageFwd", this.pageForward);
            this._shell.bindAction("bb_button_create", this.openCreate);
            this._shell.bindAction("bb_link_highScr", this.showHighScores);
            this._shell.bindAction("bb_link_gameRul", this.showRules);
            this._shell.bindAction("gs_button_buytickets", this._services.openTickets);

            this._shell.renderWindow("bb_glist");
            for (_tmp_ in 0...LOBBY_ROWS)
{slot= _tmp_;
                this.lobbyRow(slot, games[this._lobbyPage * LOBBY_ROWS + slot]);
};
            // Skill level had its own bb_skillevel window in Shockwave and no slot in this one; drawing it
            // on the light strip put it straight through the Create button, which shares that strip.
            if (error != "") this._shell.chrome.text(error, 7, 351, 191, 13, 0xB03030, true);
        }

        /** Applies an authoritative balance push without rebuilding or repositioning the lobby window. */
        public function refreshTicketBalance()
        {
            if (this._shell == null || this._state == null) return;
            var counter= this._shell.xmlWindow("bb_amount_tickets");
            if (counter != null) counter.caption = this._state.balanceText;
        }
        /**
         * One game slot. Director filled these five 191x40 areas from Lingo, which the cast does not
         * preserve, so the contents are composed from the row assets it does. bb_bg_emp is the only row
         * strip the converter kept -- bb_bg_grn, bb_bg_red and bb_bg_gry all decode empty -- and it is
         * the plain row background anyway: a light face over a dark rule, which every row in the
         * original screenshot shares. Its light face is why the row text is dark rather than white.
         */
        /**
         * One game slot, laid out as BouncingLoungeMenu Renderer Class.ls does it (renderInstanceList /
         * getInstanceListItemBg): a 191x33 row whose background and icon follow the game's state, the
         * name in bold at 32,3, the host's name plain at 32,20, and a right-aligned go link with the
         * bb_arr chevron. Empty rows use bb_bg_emp and show "---" for the host.
         */
        function lobbyRow(slot:Int, game:ASObject)
        {
            var y= LOBBY_ROW_Y + slot * LOBBY_ROW_HEIGHT;
            var state= this.rowState(game);
            this._shell.chrome.piece(ASCompat.getDynamicProperty(ROW_BACKGROUNDS, state), LOBBY_ROW_X, y, LOBBY_ROW_WIDTH, LOBBY_ROW_FILL_HEIGHT);
            if (game == null)
            {
                this._shell.chrome.text("---", LOBBY_ROW_X + 32, y + 20, 96, 13, 0x1E2A2B, false, "left");
                return;
            }
            // The renderer places every state icon at 3-regX, 4-regY, at its own size.
            var icon:String = ASCompat.getDynamicProperty(BattleBallChrome.ROW_ICONS, state);
            this._shell.chrome.piece(icon, LOBBY_ROW_X + ASCompat.toInt(ASCompat.getDynamicProperty(BattleBallChrome.ROW_ICON_X, icon)), y + ASCompat.toInt(ASCompat.getDynamicProperty(BattleBallChrome.ROW_ICON_Y, icon)),
                ASCompat.toInt(ASCompat.getDynamicProperty(BattleBallChrome.ROW_ICON_W, icon)), ASCompat.toInt(ASCompat.getDynamicProperty(BattleBallChrome.ROW_ICON_H, icon)));
            this._shell.chrome.text(ASCompat.toString(game.name), LOBBY_ROW_X + 32, y + 3, 150, 13, 0x1E2A2B, true, "left");
            this._shell.chrome.text(ASCompat.toString(game.ownerName == null ? "" : game.ownerName),
                LOBBY_ROW_X + 32, y + 20, 96, 13, 0x1E2A2B, false, "left");
            // Go link: right-aligned text then the chevron, in a 92x12 block 5px off the row's right edge.
            var goX= LOBBY_ROW_X + LOBBY_ROW_WIDTH - 92 - 5;
            this._shell.chrome.text(this._services.text("gs_button_go_" + state), goX, y + 19, 80, 13, 0x1E2A2B, true, "right", true);
            this._shell.chrome.piece("bb_arr", goX + 84, y + 20, 7, 8);
            var action:ASFunction = state == "created" ? this.joinGame
                : ((state == "started" || state == "finished") ? this.watchGame : null);
            if (action != null)
            {
                this._shell.chrome.hotspot("go_" + game.instanceId, goX, y + 17, 92, 14,
                    action, game.instanceId);
                this._shell.chrome.hotspot("row_" + game.instanceId, LOBBY_ROW_X, y,
                    LOBBY_ROW_WIDTH - 100, LOBBY_ROW_FILL_HEIGHT, action, game.instanceId);
            }
        }
        /** Maps the server's numeric game state onto the renderer's #created/#started/#finished. */
        function rowState(game:ASObject):String
        {
            if (game == null) return "empty";
            var state= ASCompat.toInt(game.state);
            if (state <= 0) return "created";
            return state >= 3 ? "finished" : "started";
        }
        /** Switches the sidebar to the creation form; no game exists until Ready is pressed. */
        function openCreate(data:ASObject=null)
        {
            // Creating a game costs a ticket, and the server refuses without one. Send the player to
            // the shop rather than through a form that can only end in "not enough tickets".
            if (this._state.ticketCost > 0 && this._state.ticketBalance < this._state.ticketCost)
            {
                this._services.openTickets();
                return;
            }
            this._services.showCreate(this._state.ticketCost);
        }
        function pageBack(data:ASObject=null) { if (this._lobbyPage > 0) { this._lobbyPage--; this.redraw(); } }
        function pageForward(data:ASObject=null) { this._lobbyPage++; this.redraw(); }
        /**
         * Shockwave opened habbo.com for this (openNetPage of bb_link_highScores_url). That page is long
         * gone, so it opens the Games Hall leaderboard instead, filtered to BattleBall.
         */
        function showHighScores(data:ASObject=null) { this._services.emit(BattleBallViewEvent.HIGH_SCORES); }
        function showRules(data:ASObject=null) { this._services.emit(BattleBallViewEvent.GAME_RULES); }
        /** Local re-render, no network round trip. */
        function redraw(data:ASObject=null) { this._services.emit(BattleBallViewEvent.REDRAW); }
        function watchGame(id:ASObject) { this._services.emit(BattleBallViewEvent.WATCH,{instanceId:ASCompat.toInt(id)}); }
        function joinGame(id:ASObject)
        {
            if (this._state.ticketCost > 0 && this._state.ticketBalance < this._state.ticketCost)
            {
                this._services.openTickets();
                return;
            }
            this._services.joinGame(id);
        }
    }

