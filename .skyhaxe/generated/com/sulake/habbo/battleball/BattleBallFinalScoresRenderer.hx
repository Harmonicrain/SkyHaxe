package com.sulake.habbo.battleball
;
    import com.sulake.core.window.components.IBitmapWrapperWindow;

    /**
     * The final standings, drawn over the arena so the round the player just finished stays visible
     * behind them.
     *
     * The large/small toggle redraws without asking the server again, so the screen has to survive the
     * round it describes. It does that by taking a snapshot of the finished round -- names, scores,
     * counts -- rather than keeping the model: the arena's model is reset for the next game while
     * these standings are still on screen, and reset empties the scores the standings are made of.
     */
     class BattleBallFinalScoresRenderer
    {
        var _shell:BattleBallLobbyWindow;
        var _state:BattleBallViewState;
        var _services:BattleBallViewServices;

        /** The finished round, as plain values. Nothing here is shared with the live model. */
        var _hasRound:Bool = false;
        var _teams:Int = 2;
        var _joined:Int = 0;
        var _secondsToJoin:Int = 0;
        var _bestName:String = "";
        var _bestScore:Int = 0;
        var _bestTeam:Int = 0;
        var _teamScores:Array<ASAny> = [];
        var _teamRows:Array<ASAny> = [];
        var _scoreTiny:Bool = false;
        var _historical:Bool = false;
        /**
         * Whether the next show() is a new round or a redraw of the one already on screen.
         *
         * A redraw arrives with the live model as its argument -- closing the ticket window raises
         * REDRAW, and the controller answers it by calling showFinalScores() again -- but by then the
         * server has reset the board for the next game, so re-reading that model would blank the very
         * standings being redrawn. Only leaving this screen arms a fresh snapshot.
         */
        var _armed:Bool = true;

        public function new(shell:BattleBallLobbyWindow,
                                                      state:BattleBallViewState,
                                                      services:BattleBallViewServices)
        {
            this._shell = shell; this._state = state; this._services = services;
        }

        /** Buttons on this screen. One-line signals, owned here rather than injected. */
        function rejoinGame(data:ASObject=null) { this._services.emit(BattleBallViewEvent.REJOIN); }
        function leaveGame(data:ASObject=null) { this._services.emit(BattleBallViewEvent.LEAVE); }

        /** Back at the games list: the next round's standings open full size, from their own data. */
        public function resetSize() { this._scoreTiny = false; this._armed = true; }

        /** Leaving the standings for any other screen; the next show() describes a different round. */
        public function invalidate() { this._armed = true; }

        public function dispose()
        {
            this._shell = null; this._state = null; this._services = null;
            this._teamScores = null; this._teamRows = null;
        }

        /** Applies a balance push while the standings and ticket dialog remain open. */
        public function refreshTicketBalance()
        {
            if (this._shell == null || this._state == null) return;
            var counter= this._shell.xmlWindow("bb_ticketAmount_text");
            if (counter != null) counter.caption = this._state.balanceText;
        }

        /**
         * The end-of-round window, bb_score_big_<n>t: final standings per team, the best player, and the
         * choice of joining the next round or stopping. Held until one of those is pressed.
         */
        public function show(model:BattleBallModel, instance:ASObject, ticketCost:Int,
                             bestName:String, bestScore:Int)
        {
            this._state.ticketCost = ticketCost;
            // A redraw of the round already on screen keeps what it captured; only a new round reads
            // the model, which by redraw time has been reset for the next game.
            if (this._armed)
            {
                this._historical = false;
                this.snapshot(model, instance, bestName, bestScore);
                this._armed = false;
                // Standings are an arena modal. Do not inherit the sidebar/lobby position from the
                // screen that happened to be open before the round ended.
                this._shell.centerNext = true;
                this._shell.moved = false;
            }
            this.render();
        }

        /** Draws the same cast score window from a persisted lounge result. */
        public function showHistorical(instance:ASObject, ticketCost:Int)
        {
            this._state.ticketCost = ticketCost;
            if (this._armed)
            {
                this._historical = true;
                this.snapshotHistorical(instance);
                this._armed = false;
                this._shell.centerNext = true;
                this._shell.moved = false;
            }
            this.render();
        }

        function snapshotHistorical(instance:ASObject)
        {
var             team = 0, player:ASObject  = null;            this._hasRound = instance != null;
            this._teams = Std.int(instance == null ? 2 : Std.int(Math.max(2, Math.min(4, ASCompat.toInt(instance.teamCount)))));
            this._joined = 0; this._secondsToJoin = 0; this._bestName = ""; this._bestScore = 0;
            this._bestTeam = Std.int(instance == null ? 0 : Std.int(Math.max(0, ASCompat.toInt(instance.winningTeam))));
            this._teamScores = []; this._teamRows = [];
            var team = 0;
            team= 0;while (team < this._teams)
            {
                this._teamScores.push(instance != null && instance.scores != null
                    && ASCompat.hasOwnProperty(instance.scores, team)? ASCompat.toInt(instance.scores[team]) : 0);
                this._teamRows.push(([] : Array<Dynamic>));
team++;
            }
            if (instance == null || instance.players == null) return;
            final _iter_:ASAny = instance.players; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
player = _tmp_;
                team = ASCompat.toInt(player.teamId);
                if (team < 0 || team >= this._teams) continue;
                this._joined++;
                ((ASCompat.dynamicAs(this._teamRows[team] , Array) : Array<ASAny>)).push({name:ASCompat.toString(player.name), score:ASCompat.toInt(player.score)});
                if (this._bestName == "" || ASCompat.toInt(player.score) > this._bestScore)
                {
                    this._bestName = ASCompat.toString(player.name); this._bestScore = ASCompat.toInt(player.score);
                    this._bestTeam = team;
                }
            }
            team= 0;while (team < this._teams)
                {ASCompat.ASArray.sortOn(((ASCompat.dynamicAs(this._teamRows[team] , Array) : Array<ASAny>)), "score", ASCompat.toInt(ASCompat.ASArray.NUMERIC )| ASCompat.toInt(ASCompat.ASArray.DESCENDING));
team++;
};
        }

        /**
         * Read everything the standings draw out of the model once, while it still holds the finished
         * round. Player names are resolved here too, so the redraw never reaches back for them.
         */
        function snapshot(model:BattleBallModel, instance:ASObject, bestName:String, bestScore:Int)
        {
var             team = 0, entry:ASObject  = null;            this._hasRound = model != null;
            this._teams = Std.int(instance == null ? 2 : Std.int(Math.max(2, Math.min(4, ASCompat.toInt(instance.teamCount)))));
            this._bestName = bestName; this._bestScore = bestScore; this._bestTeam = 0;
            this._joined = 0;
            this._secondsToJoin = Std.int(model == null ? 0 : Std.int(Math.max(0, Std.int(model.displayedTimeRemainingMs / 1000))));
            this._teamScores = [];
            this._teamRows = [];

            var team = 0;
            team= 0;while (team < this._teams)
            {
                this._teamScores.push(model == null ? 0 : ASCompat.toInt(this._services.teamScore(model, team)));
                this._teamRows.push(([] : Array<Dynamic>));
team++;
            }
            if (model == null) return;

            final _iter_:ASObject = model.objects; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
entry = _tmp_;
                if (entry.type != 0) continue;
                this._joined++;
                if (ASCompat.toString(entry.name) == bestName)
                {
                    this._bestName = this._services.playerDisplayName(entry);
                    this._bestTeam = ASCompat.toInt(entry.teamId);
                }
                team = ASCompat.toInt(entry.teamId);
                if (team < 0 || team >= this._teams) continue;
                ((ASCompat.dynamicAs(this._teamRows[team] , Array) : Array<ASAny>)).push({name:this._services.playerDisplayName(entry),
                                                      score:ASCompat.toInt(entry.score)});
            }
            team= 0;while (team < this._teams)
                {ASCompat.ASArray.sortOn(((ASCompat.dynamicAs(this._teamRows[team] , Array) : Array<ASAny>)), "score", ASCompat.toInt(ASCompat.ASArray.NUMERIC )| ASCompat.toInt(ASCompat.ASArray.DESCENDING));
team++;
};
        }

        /** Draw the snapshot. Called on show and again whenever the size toggle flips. */
        function render()
        {
var             slot = 0, area:ASObject  = null, rows:Array<ASAny>  = null,                 line = 0;            this._shell.clearBindings();
            if (!this._historical)
            {
                this._shell.bindText("bb_info_tmToJoin", this._services.text("gs_info_secondstojoin")
                    .replace("%count%", this._secondsToJoin));
                this._shell.bindText("bb_info_joinedPlrs", this._services.text("gs_info_playersjoined")
                    .replace("%count%", this._joined));
            }
            if (this._scoreTiny)
            {
                this._shell.bindAction("bb_link_expand", this.toggleScoreSize);
                this._shell.renderWindow("bb_score_tiny", true);
                this.applyHistoricalVisibility();
                return;
            }

            this._shell.bindText("bb_ticketAmount_text", this._state.balanceText);
            this._shell.bindText("gs_bestplayer_name", this._bestName);
            this._shell.bindText("gs_bestplayer_score", this._bestScore > 0 ? Std.string(this._bestScore) : "");
            this._shell.bindText("bb_button_leaveGam2", this._historical
                ? this.historyBackText() : this._services.text("gs_button_stopplaying"));
            if (!this._historical) this._shell.bindAction("bb_button_playAgn", this.rejoinGame);
            this._shell.bindAction("bb_button_leaveGam2", this.leaveGame);
            this._shell.bindAction("gs_button_buytickets", this._services.openTickets);
            this._shell.bindAction("bb_link_shrink", this.toggleScoreSize);
            var standings= this.standingsOrder();
            var slot = 0;
            var team = 0;
            slot= 0;while (slot < standings.length)
            {
                team = ASCompat.toInt(standings[slot]);
                this._shell.bindText("bb_score_team" + Std.string(slot + 1), ASCompat.toString(this._teamScores[team]));
slot++;
            }
            this._shell.renderWindow("bb_score_big_" + Std.string(this._teams) + "t", true);

            this.applyHistoricalVisibility();

            var badge:ASObject = this._shell.elementById("bb_icon_winner");
            if (badge != null && this._hasRound)
                this._shell.chrome.piece("bb_ico_ball" + Std.string(this._bestTeam + 1),
                    ASCompat.toInt(badge.x + Std.int(ASCompat.toNumber(ASCompat.toNumber(badge.w) - 19) / 2)), ASCompat.toInt(badge.y + Std.int(ASCompat.toNumber(ASCompat.toNumber(badge.h) - 22) / 2)), 19, 22);

            slot= 0;while (slot < standings.length)
            {
                team = ASCompat.toInt(standings[slot]);
                // The authored score windows are rank templates: their cups/lolly already describe
                // first through last place, while their coloured balls are only placeholders. Move
                // the complete team result into score order and restore that team's actual colour.
                this._shell.chrome.assignBitmap(
                    Std.downcast(this._shell.xmlWindow("bb_win_bigScores_ball" + Std.string(slot + 1)) , IBitmapWrapperWindow),
                    "bb_ico_ball" + Std.string(team + 1));
area= this._shell.elementById("bb_area_scores" + Std.string(slot + 1));
                if (area == null) {slot++;continue;};
rows= ASCompat.dynamicAs(this._teamRows[team] , Array);
                line= 0;while (line < rows.length)
                {
                    if ((line + 1) * 16 > area.h) break;
                    this._shell.chrome.text(ASCompat.toString(rows[line].name), ASCompat.toInt(area.x + 4), ASCompat.toInt(area.y + 2 + line * 16),
                        110, 13, 0x1E2A2B, false, "left");
                    this._shell.chrome.text(ASCompat.toString(rows[line].score), ASCompat.toInt(area.x + 116), ASCompat.toInt(area.y + 2 + line * 16),
                        45, 13, 0x1E2A2B, true, "right");
line++;
                }
slot++;
            }
        }

        /** Team ids are protocol identities; score-window positions are finishing places. */
        function standingsOrder():Array<ASAny>
        {
var             team = 0;            var order:Array<ASAny> = [];
            team= 0;while (team < this._teams) {order.push(team);
team++;
};
            ASCompat.ASArray.sort(order, this.compareStandings);
            return order;
        }

        function compareStandings(left:ASObject, right:ASObject):Float
        {
            var leftTeam= ASCompat.toInt(left);
            var rightTeam= ASCompat.toInt(right);
            var difference= ASCompat.toInt(this._teamScores[rightTeam]) - ASCompat.toInt(this._teamScores[leftTeam]);
            return difference == 0 ? leftTeam - rightTeam : difference;
        }

        function applyHistoricalVisibility()
        {
            if (!this._historical) return;
            this._shell.setElementsVisible("bb_button_playAgn", false);
            this._shell.setElementsVisible("bb_info_tmToJoin", false);
            this._shell.setElementsVisible("bb_info_joinedPlrs", false);
            this._shell.setMemberVisible("bb_nextGame", false);
            this._shell.setMemberVisible("bb_ico_star", false);
        }

        function historyBackText():String
        {
            var key= "bb_button_back_to_games";
            var value:String = this._services.text(key);
            return value == key ? "Back to games list" : value;
        }

        /** bb_link_shrink / gs_button_expand swap between the big and tiny score windows. */
        function toggleScoreSize(data:ASObject=null)
        {
            this._scoreTiny = !this._scoreTiny;
            this.render();
        }
    }

