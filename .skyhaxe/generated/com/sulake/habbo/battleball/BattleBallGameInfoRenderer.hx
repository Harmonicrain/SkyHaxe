package com.sulake.habbo.battleball
;

    /**
     * Game info: the status block, team panels, tabs and the join/team picker.
     *
     * A mode of the shared lobby window: it draws through the shell and its chrome, keeps only
     * its own state, and reaches facade behaviour through BattleBallViewServices rather than
     * holding a reference to the view.
     */
     class BattleBallGameInfoRenderer
    {
        var _shell:BattleBallLobbyWindow;
        var _state:BattleBallViewState;
        var _services:BattleBallViewServices;
        var _infoInstanceId:Int = -1;
        var _infoTab:String = "teams";
        var _infoModel:BattleBallModel;
        var _infoInstance:ASObject;
        /** Status block background by state, from renderInstanceDetailTop. */
        static final STATUS_BACKGROUNDS:ASObject = {
            "created": "bb_gameinfo_bg_2", "started": "bb_gameinfo_bg_3", "finished": "bb_gameinfo_bg_1"
        };

        public function new(shell:BattleBallLobbyWindow, state:BattleBallViewState,
                                 services:BattleBallViewServices)
        {
            this._shell = shell; this._state = state; this._services = services;
        }

        /** Leaving the list resets which tab opens next, so a new game starts on Teams. */
        public function reset()
        {
            this._infoInstanceId = -1; this._infoTab = "teams";
            this._infoModel = null; this._infoInstance = null;
        }

        public function dispose()
        {
            this._shell = null; this._state = null; this._services = null;
        }
        /**
         * The pre-game window: teams, who is in them, and the start control. This is where a created or
         * joined game waits, exactly as in Shockwave -- the arena only appears once play begins.
         */
        public function show(model:BattleBallModel, instance:ASObject, ticketCost:Int)
        {
var team = 0;            this._state.ticketCost = ticketCost;
            this._infoInstanceId = model == null ? -1 : model.instanceId;
            this._infoModel = model; this._infoInstance = instance;
            var teams= Std.int(instance == null ? 2 : Std.int(Math.max(2, Math.min(4, ASCompat.toInt(instance.teamCount)))));
            var owner= model != null && model.ownerUserId == this._services.localUserId();
            if (this._infoTab == "info") { this.showGameInfoTab(model, instance, owner); return; }

            this._shell.clearBindings();
            this._shell.bindText("bb_header_gameChsn", instance == null ? "" : ASCompat.toString(instance.name));
            this._shell.bindText("bb_amount_tickets", this._state.balanceText);
            this._shell.bindAction("bb_button_leaveGam", this.leaveGame);
            this._shell.bindAction("gs_button_buytickets", this._services.openTickets);
            this._shell.bindAction("bb_tab_gameInfo", this.selectInfoTab);
            if (owner) this._shell.bindAction("bb_link_gameInfo", this.startGame);
            // Every team except the one we are already on: that link would be a no-op, and the original
            // did not offer it. Switching is just joining another team while already in the game.
            var ourTeam= this.teamOf(model, ASCompat.toInt(this._services.localUserId()));
            var joined= model != null && model.localPlayer(ASCompat.toInt(this._services.localUserId())) != null;
            for (_tmp_ in 1...teams + 1)
{team= _tmp_;
                if (!joined || ourTeam != team - 1)
                    this._shell.bindAction("bb_link_team" + Std.string(team), this.joinTeamSlot, team - 1);
};

            this._shell.renderWindow("bb_ginfo" + Std.string(teams) + "t");
            this.drawGameInfoContent(model, instance, teams, owner);
        }
        /**
         * The Game info tab. The cast keeps this as its own window, bb_ginfo_more, carrying a Teams
         * label to switch back -- the two tabs are two windows rather than two panels in one.
         */
        function showGameInfoTab(model:BattleBallModel, instance:ASObject, owner:Bool)
        {
            this._shell.clearBindings();
            this._shell.bindText("bb_header_gameChsn", instance == null ? "" : ASCompat.toString(instance.name));
            this._shell.bindText("bb_amount_tickets", this._state.balanceText);
            this._shell.bindAction("bb_tab_teams", this.selectTeamsTab);
            this._shell.bindAction("bb_button_leaveGam", this.leaveGame);
            this._shell.bindAction("gs_button_buytickets", this._services.openTickets);
            if (owner) this._shell.bindAction("bb_link_gameInfo", this.startGame);
            this._shell.renderWindow("bb_ginfo_more");

            this.drawStatusBlock(model, instance, owner);
            // This window is already complete in the cast -- arena thumbnail, powerups header and the
            // eight in-play slots. Only the arena picture varies, so swap that for the chosen field.
            var thumb:ASObject = this._shell.elementById("bb_arena_thumb");
            var mapId= Std.int(instance == null ? 1 : Std.int(Math.max(1, Math.min(5, ASCompat.toInt(instance.mapId)))));
            if (thumb != null)
                this._shell.chrome.piece("bb2_lvlthumb_" + Std.string(mapId), ASCompat.toInt(thumb.x), ASCompat.toInt(thumb.y), ASCompat.toInt(thumb.w), ASCompat.toInt(thumb.h));
        }
        function selectInfoTab(data:ASObject=null)
        {
            this._infoTab = "info";
            this.show(this._infoModel, this._infoInstance, this._state.ticketCost);
        }
        function selectTeamsTab(data:ASObject=null)
        {
            this._infoTab = "teams";
            this.show(this._infoModel, this._infoInstance, this._state.ticketCost);
        }
        /** The owner, their status line and the start control, shared by both game info tabs. */
        function drawStatusBlock(model:BattleBallModel, instance:ASObject, owner:Bool)
        {
var state:String  = null, icon:String  = null;            var status:ASObject = this._shell.elementById("bb_area_gameInfo");
            if (status != null)
            {
state= model != null && model.state > 0
                    ? (model.state >= 3 ? "finished" : "started") : "created";
                this._shell.chrome.piece(ASCompat.getDynamicProperty(STATUS_BACKGROUNDS, state), ASCompat.toInt(status.x), ASCompat.toInt(status.y), ASCompat.toInt(status.w), ASCompat.toInt(status.h));
icon= ASCompat.getDynamicProperty(BattleBallChrome.ROW_ICONS, state);
                this._shell.chrome.piece(icon, ASCompat.toInt(status.x + ASCompat.toInt(ASCompat.getDynamicProperty(BattleBallChrome.ROW_ICON_X, icon))), ASCompat.toInt(status.y + ASCompat.toInt(ASCompat.getDynamicProperty(BattleBallChrome.ROW_ICON_Y, icon))),
                    ASCompat.toInt(ASCompat.getDynamicProperty(BattleBallChrome.ROW_ICON_W, icon)), ASCompat.toInt(ASCompat.getDynamicProperty(BattleBallChrome.ROW_ICON_H, icon)));
                this._shell.chrome.text(instance == null ? "" : ASCompat.toString(instance.ownerName == null ? instance.name : instance.ownerName),
                    ASCompat.toInt(status.x + 32), ASCompat.toInt(status.y + 4), ASCompat.toInt(ASCompat.toNumber(status.w) - 37), 13, 0x1E2A2B, false, "left");
                this._shell.chrome.text(this._services.text("gs_info_waiting"), ASCompat.toInt(status.x + 32), ASCompat.toInt(status.y + 20), ASCompat.toInt(ASCompat.toNumber(status.w) - 37), 13,
                    0x1E2A2B, false, "left");
                this._shell.chrome.text(this._services.text("gs_info_spectators").replace("%count%", this.countSpectators(model)),
                    ASCompat.toInt(status.x + 32), ASCompat.toInt(status.y + 36), ASCompat.toInt(ASCompat.toNumber(status.w) - 37), 13, 0x1E2A2B, false, "left");
            }
            var start:ASObject = this._shell.elementById("bb_link_gameInfo");
            if (start != null && owner)
            {
                // The link bar ships in three colours and Lingo swapped between them by state. The
                // layout names the neutral grey bb_lnk_px_1; the actionable Start Game bar is the red
                // bb_lnk_px_3, which is what the original showed once a game could be started.
                this._shell.chrome.piece("bb_lnk_px_3", ASCompat.toInt(start.x), ASCompat.toInt(start.y), ASCompat.toInt(start.w), ASCompat.toInt(start.h));
                this._shell.chrome.text(this._services.text("gs_button_startgame"), ASCompat.toInt(start.x), ASCompat.toInt(start.y + 2),
                    ASCompat.toInt(ASCompat.toNumber(start.w) - 16), 13, 0xFFFFFF, true, "right");
                this._shell.chrome.arrow(ASCompat.toInt(ASCompat.toNumber(start.x + start.w) - 12), ASCompat.toInt(start.y + 5), 0xFFFFFF);
            }
        }
        /**
         * One panel per team, filled either from the live game objects or, before joining, from the team
         * summaries the join parameters carry. Kick icons are drawn per occupied slot rather than as a
         * fixed column of six, and only for the player who owns the game.
         */
        function drawTeamPanels(teams:Int, model:BattleBallModel,
                                        summaries:Array<ASAny>, owner:Bool, teamCapacity:Int=0)
        {
var team = 0, area:ASObject  = null, rows = 0, line = 0, object:ASObject  = null, link:ASObject  = null;            for (_tmp_ in 0...teams)
            {
team= _tmp_;
area= this._shell.elementById("bb_area_team" + Std.string(team + 1));
                if (area == null) continue;
                this._shell.chrome.piece("bb_ico_ball" + Std.string(team + 1), ASCompat.toInt(area.x + 2), ASCompat.toInt(area.y + 2), 19, 22);
rows= Std.int(Math.max(1, Std.int((ASCompat.toInt(area.h) - BattleBallLobbyWindow.TEAM_LINK_HEIGHT) / BattleBallLobbyWindow.TEAM_ROW_HEIGHT)));
line= 0;
                if (model != null)
                {
                    final _iter_:ASObject = model.objects; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                    {
object = _tmp_;
                        if (object.type != 0 || object.teamId != team) continue;
                        this._shell.chrome.text(this._services.playerDisplayName(object), ASCompat.toInt(area.x + 26), ASCompat.toInt(area.y + 2 + line * BattleBallLobbyWindow.TEAM_ROW_HEIGHT), 146, 13,
                            0x1E2A2B, false, "left");
                        if (owner && object.userId != this._services.localUserId())
                        {
                            this._shell.chrome.piece("bb_ico_trash", ASCompat.toInt(area.x + 176), ASCompat.toInt(area.y + 1 + line * BattleBallLobbyWindow.TEAM_ROW_HEIGHT), 13, 16);
                            this._shell.chrome.hotspot("kick_" + object.userId, ASCompat.toInt(area.x + 174), ASCompat.toInt(area.y + line * BattleBallLobbyWindow.TEAM_ROW_HEIGHT),
                                17, 16, this.kickPlayer, object.userId);
                        }
                        line++;
                        if (line >= rows) break;
                    }
                }
                else if (summaries != null && summaries[team] != null)
                {
                    this._shell.chrome.text(this._services.text("gs_info_players").replace("%players%", summaries[team].playerCount)
                        .replace("%capacity%", summaries[team].capacity),
                        ASCompat.toInt(area.x + 26), ASCompat.toInt(area.y + 2), 146, 13, 0x1E2A2B, false, "left");
                }
link= this._shell.elementById("bb_link_team" + Std.string(team + 1));
                if (link != null && ASCompat.getDynamicProperty(this._shell.bindings, "bb_link_team" + Std.string(team + 1))!= null)
                {
                    // renderButtonImages: link text right-aligned to 176, then bb_arr at 180,4.
                    this._shell.chrome.text(this._services.text("bb_link_join"), ASCompat.toInt(link.x), ASCompat.toInt(link.y + 3), 176, 13,
                        0x1E2A2B, true, "right", true);
                    this._shell.chrome.piece("bb_arr", ASCompat.toInt(link.x + 180), ASCompat.toInt(link.y + 4), 7, 8);
                }
                // Bots are a port extension, so there is deliberately no cast member for this control.
                // Compose the same b10 three-slice used by the arena HUD and keep it owner-only.
                if (owner && link != null && line < teamCapacity)
                    this._shell.chrome.button("add_bot_team_" + Std.string(team), this._services.text("gs_button_addbot"),
                        ASCompat.toInt(link.x + 4), ASCompat.toInt(ASCompat.toNumber(link.y) - 1), 68, 18, this.addBot, team);
            }
        }
        /**
         * Picking a team happens in the game info window, as it did in Shockwave: clicking a game in the
         * list shows that game's teams and you join through one of its Join Team strips. The separate
         * "choose a team" panel this replaces was prototype scaffolding, not part of the original flow.
         */
        public function showJoinTeams(instanceId:Int, teams:Array<ASAny>)
        {
var team = 0, summary:ASObject  = null;            this._infoInstanceId = instanceId;
            var count= Std.int(teams == null ? 2 : Std.int(Math.max(2, Math.min(4, teams.length))));

            this._shell.clearBindings();
            this._shell.bindText("bb_amount_tickets", this._state.balanceText);
            this._shell.bindText("bb_button_leaveGam", this._services.text("gs_button_cancel"));
            this._shell.bindAction("bb_button_leaveGam", this._services.redraw);
            this._shell.bindAction("gs_button_buytickets", this._services.openTickets);
            for (_tmp_ in 0...count)
            {
team= _tmp_;
summary= teams == null ? null : teams[team];
                if (summary == null || summary.playerCount < summary.capacity)
                    this._shell.bindAction("bb_link_team" + Std.string(team + 1), this.joinTeamSlot, team);
            }

            this._shell.renderWindow("bb_ginfo" + Std.string(count) + "t");
            this.drawTeamPanels(count, null, teams, false);
        }
        public function joinGame(id:ASObject) { this._services.emit(BattleBallViewEvent.JOIN,{instanceId:ASCompat.toInt(id),teamId:0}); }
        function addBot(teamId:ASObject) { this._services.emit(BattleBallViewEvent.ADD_BOT,{teamId:ASCompat.toInt(teamId)}); }
        public function kickPlayer(userId:ASObject) { this._services.emit(BattleBallViewEvent.KICK,{userId:ASCompat.toInt(userId)}); }
        function startGame(data:ASObject=null) { this._services.emit(BattleBallViewEvent.START); }
        function leaveGame(data:ASObject=null) { this._services.emit(BattleBallViewEvent.LEAVE); }
        function drawGameInfoContent(model:BattleBallModel, instance:ASObject, teams:Int, owner:Bool)
        {
            this.drawStatusBlock(model, instance, owner);
            var teamCapacity= Std.int(instance == null
                ? this._shell.teamRowCapacity(teams)
                : Std.int(Math.min(this._shell.teamRowCapacity(teams), Math.max(1, ASCompat.toInt(instance.capacity) / teams))));
            this.drawTeamPanels(teams, model, null, owner, teamCapacity);
        }
        function joinTeamSlot(value:ASObject)
        {
            this._services.emit(BattleBallViewEvent.JOIN_TEAM, {instanceId:this._infoInstanceId, teamId:ASCompat.toInt(value)});
        }
        function teamOf(model:BattleBallModel, userId:Int):Int
        {
var object:ASObject  = null;            if (model != null && userId != 0)
{                final _iter_:ASObject = model.objects; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
{object = _tmp_;
                    if (object.type == 0 && object.userId == userId) return ASCompat.toInt(object.teamId);
}};
            return 0;
        }
        function countSpectators(model:BattleBallModel):Int
        {
            return Std.int(model == null ? 0 : Std.int(Math.max(0, model.spectatorCount)));
        }
    }

