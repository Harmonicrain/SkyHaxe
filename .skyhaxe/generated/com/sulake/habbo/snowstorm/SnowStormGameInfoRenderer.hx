package com.sulake.habbo.snowstorm
;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.components.ITextWindow;

    /** Waiting-room detail/team screen from sw_ginfo1t..4t. */
     final class SnowStormGameInfoRenderer
    {
        var _shell:SnowStormLobbyWindow;
        var _state:SnowStormViewState;
        var _services:SnowStormViewServices;
        var _instance:ASObject;
        var _join:ASObject;

        public function new(shell:SnowStormLobbyWindow,
                                                   state:SnowStormViewState,
                                                   services:SnowStormViewServices)
        { this._shell = shell; this._state = state; this._services = services; }

        public function show(instance:ASObject, join:ASObject, ticketCost:Int)
        {
            if (instance == null || join == null) return;
            this._instance = instance; this._join = join; this._state.ticketCost = ticketCost;
            this.render();
        }

        function render()
        {
var team = 0, players:Array<ASAny>  = null,                 slot = 0;            var teams= Std.int(Math.max(1, Math.min(4, ASCompat.toInt(this._join.teamCount))));
            var localId= ASCompat.toInt(this._services.localUserId());
            var ownTeam= this.findTeam(localId);
            var owner= localId == ASCompat.toInt(this._instance.ownerUserId);

            this._shell.clearBindings();
            this._shell.bindText("gs_header_gameChsn", ASCompat.toString(this._instance.name));
            this._shell.bindText("gs_button_buytickets", this._services.text("gs_button_buytickets"));
            this._shell.bindAction("gs_button_buytickets", this.openTickets);
            this._shell.bindText("gs_button_leavegame", this._services.text("gs_button_leavegame"));
            this._shell.bindAction("gs_button_leavegame", this.leave);
            if (owner && ownTeam >= 0 && ASCompat.toInt(this._instance.state) == 0)
                this._shell.bindAction("gs_link_gameInfo", this.start);
            else if (ASCompat.toInt(this._instance.state) > 0 && ownTeam < 0)
                this._shell.bindAction("gs_link_gameInfo", this.watch);

            for (_tmp_ in 0...teams)
            {
team= _tmp_;
                if (ASCompat.toInt(this._instance.state) == 0 && team != ownTeam)
                    this._shell.bindAction("gs_link_team" + Std.string(team + 1), this.joinTeam, team);
players= this.teamPlayers(team);
                slot= 0;while (slot < players.length)
                    {if (owner && ASCompat.toInt(players[slot].userId) != localId && ASCompat.toInt(this._instance.state) == 0)
                        this._shell.bindAction("bb_kick" + Std.string(team + 1) + "_" + Std.string(slot + 1),
                            this.kick, players[slot]);
slot++;
};
            }
            this._shell.renderWindow("ss_ginfo" + Std.string(teams) + "t");
            this.renderHeader(owner, ownTeam);
            this.renderTeams(teams, owner, localId, ownTeam);
            this.refreshTicketBalance();
        }

        function renderHeader(owner:Bool, ownTeam:Int)
        {
var label:String  = null;            var area:ASObject = this._shell.elementById("gs_area_gameInfo");
            if (area == null) return;
            this._shell.surface.assignBitmap(ASCompat.dynamicAs(area.window , IBitmapWrapperWindow), "sw_gameinfo_bg_1");
            var icon= ASCompat.toInt(this._instance.rowKind) == 1 ? "sw_ico_flag" :
                (ASCompat.toInt(this._instance.state) == 0 ? "sw_ico_thumb" : "sw_ico_bounce");
            this._shell.addPiece(icon, ASCompat.toInt(area.x + 5), ASCompat.toInt(area.y + 8), icon == "sw_ico_flag" ? 24 : 20,
                icon == "sw_ico_bounce" ? 15 : (icon == "sw_ico_thumb" ? 19 : 24));
            this._shell.addText(ASCompat.toString(this._instance.ownerName), ASCompat.toInt(area.x + 32), ASCompat.toInt(area.y + 3),
                ASCompat.toInt(ASCompat.toNumber(area.w) - 35), 13, 0, false);
            this._shell.addText(this.stateText(), ASCompat.toInt(area.x + 32), ASCompat.toInt(area.y + 19),
                ASCompat.toInt(ASCompat.toNumber(area.w) - 35), 13, 0, false);
            this._shell.addText(this._services.mapName(ASCompat.toInt(this._instance.mapId)) + " · " +
                this.duration(ASCompat.toInt(this._instance.lengthChoice)), ASCompat.toInt(area.x + 32), ASCompat.toInt(area.y + 35),
                ASCompat.toInt(ASCompat.toNumber(area.w) - 35), 13, 0, false);

            var action:ASObject = this._shell.elementById("gs_link_gameInfo");
            if (action != null)
            {
label= owner && ownTeam >= 0 && ASCompat.toInt(this._instance.state) == 0
                    ? this._services.text("gs_button_start") :
                    (ASCompat.toInt(this._instance.state) > 0 && ownTeam < 0
                        ? this._services.text("gs_button_spectate") : "");
                action.actionWindow.visible = label != "";
                if (label != "")
                {
                    this._shell.surface.assignBitmap(ASCompat.dynamicAs(action.window , IBitmapWrapperWindow),
                        owner ? "sw_lnk_px_1" : "sw_bg_px");
                    this._shell.addText(label, ASCompat.toInt(action.x + 6), ASCompat.toInt(action.y + 1),
                        ASCompat.toInt(ASCompat.toNumber(action.w) - 18), 13, 0, true, "right", true);
                    this._shell.addPiece("sw_arr", ASCompat.toInt(ASCompat.toNumber(action.x + action.w) - 12), ASCompat.toInt(action.y + 4), 7, 8);
                }
            }
        }

        function renderTeams(teams:Int, owner:Bool, localId:Int, ownTeam:Int)
        {
var team = 0, area:ASObject  = null, players:Array<ASAny>  = null, names:String  = null,                 slot = 0, kick:ASObject  = null, join:ASObject  = null, visible = false;            for (_tmp_ in 0...teams)
            {
team= _tmp_;
area= this._shell.elementById("gs_area_team" + Std.string(team + 1));
                if (area == null) continue;
                this._shell.addPiece("sw_ico_team" + Std.string(team + 1), ASCompat.toInt(area.x + 5), ASCompat.toInt(area.y + 6), 17, 26);
players= this.teamPlayers(team);
names= "";
                slot= 0;while (slot < players.length)
                {
                    if (slot > 0) names += "\n";
                    names += ASCompat.toInt(players[slot].userId) < 0
                        ? (this._services.text("gs_bot_name") : ASAny).replace(
                            "%index%", Std.string(-ASCompat.toInt(players[slot].userId)))
                        : ASCompat.toString(players[slot].name);
kick= this._shell.elementById("bb_kick" + Std.string(team + 1) + "_" + Std.string(slot + 1));
                    if (kick != null) kick.actionWindow.visible = owner && ASCompat.toInt(players[slot].userId) != localId
                        && ASCompat.toInt(this._instance.state) == 0;
slot++;
                }
                this._shell.addText(names, ASCompat.toInt(area.x + 30), ASCompat.toInt(area.y + 2), ASCompat.toInt(ASCompat.toNumber(area.w) - 35),
                    Std.int(Math.max(16, players.length * 16)), 0, false);
join= this._shell.elementById("gs_link_team" + Std.string(team + 1));
                if (join != null)
                {
visible= ASCompat.toInt(this._instance.state) == 0 && team != ownTeam;
                    join.actionWindow.visible = visible;
                    if (visible)
                    {
                        this._shell.addText(this._services.text("bb_link_join"), ASCompat.toInt(join.x + 6),
                            ASCompat.toInt(join.y + 1), ASCompat.toInt(ASCompat.toNumber(join.w) - 18), 13, 0, true, "right", true);
                        this._shell.addPiece("sw_arr", ASCompat.toInt(ASCompat.toNumber(join.x + join.w) - 12), ASCompat.toInt(join.y + 4), 7, 8);
                    }
                    if (owner && ASCompat.toInt(this._instance.state) == 0
                            && players.length < this.teamCapacity(teams))
                        this._shell.addButton(this._services.text("gs_button_addbot"),
                            ASCompat.toInt(join.x + 4), ASCompat.toInt(ASCompat.toNumber(join.y) - 1), 68, 18, this.addBot, team);
                }
            }
        }

        public function refreshTicketBalance()
        {
            var descriptor:ASObject = this._shell == null ? null : this._shell.elementById("gs_numtickets");
            var field:ITextWindow = descriptor == null ? null : ASCompat.dynamicAs(descriptor.window , ITextWindow);
            if (field != null) field.text = this._state.balanceText;
        }

        function teamPlayers(teamId:Int):Array<ASAny>
        {
var team:ASObject  = null;            if (this._join == null || this._join.teams == null) return [];
            final _iter_:ASAny = this._join.teams; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
{team = _tmp_;
                if (ASCompat.toInt(team.teamId) == teamId) return team.players == null ? [] : team.players;
};
            return [];
        }
        function findTeam(userId:Int):Int
        {
var team:ASObject  = null, player:ASObject  = null;            if (userId <= 0) return -1;
            final _iter_:ASAny = this._join.teams; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
{team = _tmp_;
                final _iter_:ASAny = team.players; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
{player = _tmp_;
                    if (ASCompat.toInt(player.userId) == userId) return ASCompat.toInt(team.teamId);
}};
            return -1;
        }
        function stateText():String
        {
            if (ASCompat.toInt(this._instance.state) == 0) return this._services.text("gs_state_created");
            if (ASCompat.toInt(this._instance.state) == 1) return this._services.text("gs_state_countdown");
            return this._services.text("gs_state_started");
        }
        function duration(choice:Int):String
        { return choice == 1 ? "2:00" : (choice == 2 ? "3:00" : "5:00"); }
        function joinTeam(value:ASObject)
        { this._services.emit(SnowStormViewEvent.JOIN_TEAM, {instanceId:this._instance.id, teamId:ASCompat.toInt(value)}); }
        function kick(value:ASObject)
        {
            this._services.emit(ASCompat.toInt(value.userId) < 0 ? SnowStormViewEvent.REMOVE_BOT : SnowStormViewEvent.KICK,
                {instanceId:this._instance.id, userId:value.userId});
        }
        function addBot(value:ASObject)
        { this._services.emit(SnowStormViewEvent.ADD_BOT, {instanceId:this._instance.id, teamId:ASCompat.toInt(value)}); }
        function teamCapacity(teams:Int):Int
        { return teams == 1 ? 12 : (teams == 2 ? 6 : (teams == 3 ? 4 : 3)); }
        function start(data:ASObject=null)
        {
            if (!this.hasOpposition())
            {
                this._services.emit(SnowStormViewEvent.REDRAW,
                    {error:this._services.text("sw_error_need_opposition")});
                return;
            }
            this._services.emit(SnowStormViewEvent.START, {instanceId:this._instance.id});
        }
        function hasOpposition():Bool
        {
var team = 0;            var teams= Std.int(Math.max(1, Math.min(4, ASCompat.toInt(this._join.teamCount))));
            if (teams == 1) return this.teamPlayers(0).length >= 2;
            var occupied= 0;
            for (_tmp_ in 0...teams)
{team= _tmp_;
                if (this.teamPlayers(team).length > 0) occupied++;
};
            return occupied >= 2;
        }
        function watch(data:ASObject=null)
        { this._services.emit(SnowStormViewEvent.WATCH, {instanceId:this._instance.id}); }
        function leave(data:ASObject=null)
        { this._services.emit(SnowStormViewEvent.LEAVE, {instanceId:this._instance.id}); }
        function openTickets(data:ASObject=null) { this._services.openTickets(); }

        public function dispose()
        { this._instance = null; this._join = null; this._shell = null; this._state = null; this._services = null; }
    }

