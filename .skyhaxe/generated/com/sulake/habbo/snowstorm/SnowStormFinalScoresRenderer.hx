package com.sulake.habbo.snowstorm
;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.components.ITextWindow;
    import flash.display.BitmapData;
    import flash.geom.Matrix;

    /** Immutable live/historical standings using the original one-through-four-team layouts. */
     final class SnowStormFinalScoresRenderer
    {
        var _shell:SnowStormLobbyWindow;
        var _state:SnowStormViewState;
        var _services:SnowStormViewServices;
        var _result:ASObject;
        var _historical:Bool = false;
        var _bestImage:BitmapData;

        public function new(shell:SnowStormLobbyWindow,
                                                      state:SnowStormViewState,
                                                      services:SnowStormViewServices)
        { this._shell = shell; this._state = state; this._services = services; }

        public function show(result:ASObject, historical:Bool=false, bestImage:BitmapData=null)
        {
            if (result == null || result.teams == null || result.players == null) return;
            if (this._bestImage != null) this._bestImage.dispose();
            this._bestImage = bestImage;
            this._result = this.snapshot(result);
            this._historical = historical;
            this.render();
        }

        function render()
        {
            var teamCount= Std.int(Math.max(1, Math.min(4, ASCompat.toNumber(this._result.teams.length))));
            this._shell.clearBindings();
            this._shell.bindText("gs_button_buytickets", this._services.text("gs_button_buytickets"));
            this._shell.bindAction("gs_button_buytickets", this.openTickets);
            this._shell.bindText("gs_button_leaveGame2", this._historical
                ? this._services.text("generic.close")
                : this._services.text("gs_button_stopplaying"));
            this._shell.bindAction("gs_button_leaveGame2", this.close);
            this._shell.bindText("gs_button_rejoin", this._services.text("gs_button_rejoin"));
            if (!this._historical) this._shell.bindAction("gs_button_rejoin", this.rejoin);
            this._shell.renderWindow("ss_score_big_" + Std.string(teamCount) + "t", true);
            this.renderTeams(teamCount);
            this.renderBestPlayer();
            this.refreshTicketBalance();
            var rejoin:ASObject = this._shell.elementById("gs_button_rejoin");
            if (rejoin != null) rejoin.actionWindow.visible = !this._historical;
            var time:ASObject = this._shell.elementById("gs_timetojoin");
            if (time != null && Std.is(time.window , ITextWindow))
                cast(time.window, ITextWindow).text = this._historical ? "" : this._services.text("gs_next_game");
        }

        function renderTeams(teamCount:Int)
        {
var             index = 0, team:ASObject  = null, area:ASObject  = null, players:Array<ASAny>  = null, names:String  = null, scores:String  = null,                 p = 0, score:ASObject  = null, icon:ASObject  = null, prize:ASObject  = null;            var teams:Array<ASAny> = this._result.teams.concat();
            ASCompat.ASArray.sortOn(teams, ["placement", "teamId"], [ASCompat.ASArray.NUMERIC, ASCompat.ASArray.NUMERIC]);
            index= 0;while (index < teams.length)
            {
team= teams[index];
area= this._shell.elementById("bb_area_scores" + Std.string(index + 1));
                if (area == null) {index++;continue;};
                this._shell.addPiece("sw_ico_team" + Std.string(ASCompat.toInt(team.teamId) + 1), ASCompat.toInt(area.x + 5),
                    ASCompat.toInt(area.y + 6), 17, 26);
players= this.teamPlayers(ASCompat.toInt(team.teamId));
                ASCompat.ASArray.sortOn(players, ["placement", "userId"], [ASCompat.ASArray.NUMERIC, ASCompat.ASArray.NUMERIC]);
names= ""; scores= "";
                p= 0;while (p < players.length)
                {
                    if (p > 0) { names += "\n"; scores += "\n"; }
                    names += ASCompat.toString(players[p].name); scores += ASCompat.toString(players[p].score);
p++;
                }
                this._shell.addText(names, ASCompat.toInt(area.x + 30), ASCompat.toInt(ASCompat.toNumber(area.y) - 3), ASCompat.toInt(ASCompat.toNumber(area.w) - 70),
                    Std.int(Math.max(16, players.length * 16)), 0, false);
                this._shell.addText(scores, ASCompat.toInt(ASCompat.toNumber(area.x + area.w) - 42), ASCompat.toInt(ASCompat.toNumber(area.y) - 3), 36,
                    Std.int(Math.max(16, players.length * 16)), 0, false, "right");
score= this._shell.elementById("gs_scores_score_team" + Std.string(index + 1));
                if (score != null && Std.is(score.window , ITextWindow)) cast(score.window, ITextWindow).text = ASCompat.toString(team.score);
icon= this._shell.elementById("gs_scores_icon_team" + Std.string(index + 1));
                if (icon != null)
                    this._shell.surface.assignBitmap(icon.window, "sw_ico_team" + Std.string(ASCompat.toInt(team.teamId) + 1));
prize= this._shell.elementById("gs_scores_prize_team" + Std.string(index + 1));
                if (prize != null) prize.actionWindow.visible = ASCompat.toInt(team.placement) == 1;
index++;
            }
        }

        function renderBestPlayer()
        {
var player:ASObject  = null;            var best:ASObject = null;
            final _iter_:ASAny = this._result.players; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
{player = _tmp_;
                if (best == null || ASCompat.toInt(player.score) > ASCompat.toInt(best.score) ||
                    (ASCompat.toInt(player.score) == ASCompat.toInt(best.score) && ASCompat.toInt(player.userId) < ASCompat.toInt(best.userId))) best = player;
};
            this.setText("gs_bestplayer_name", best == null ? "" : ASCompat.toString(best.name));
            this.setText("gs_bestplayer_score", best == null ? "0" : ASCompat.toString(best.score));
            this.setText("gs_joinedplayers", this._result.players.length + " " +
                this._services.text("gs_players_joined"));
            var descriptor:ASObject = this._shell.elementById("bb_icon_winner");
            var target:IBitmapWrapperWindow = descriptor == null ? null
                : ASCompat.dynamicAs(descriptor.window , IBitmapWrapperWindow);
            if (target != null && this._bestImage != null)
                this.assignPortrait(target, this._bestImage);
            else if (target != null)
                this._shell.surface.assignBitmap(target, "guide_tie");
        }

        function assignPortrait(target:IBitmapWrapperWindow, source:BitmapData)
        {
            var bounds= source.getColorBoundsRect(0xFF000000, 0, false);
            if (bounds == null || bounds.isEmpty()) return;
            var scale= Math.min(1, Math.min(target.width / bounds.width, target.height / bounds.height));
            var matrix= new Matrix(scale, 0, 0, scale,
                Std.int((target.width - bounds.width * scale) / 2) - bounds.x * scale,
                target.height - bounds.height * scale - bounds.y * scale);
            var fitted= new BitmapData(target.width, target.height, true, 0);
            fitted.draw(source, matrix, null, null, null, false);
            target.disposesBitmap = true;
            target.bitmap = fitted;
            target.color = 0xFFFFFF;
            target.invalidate();
        }

        public function refreshTicketBalance()
        { this.setText("gs_numtickets", this._state.balanceText); }

        function setText(id:String, value:String)
        {
            var descriptor:ASObject = this._shell == null ? null : this._shell.elementById(id);
            if (descriptor != null && Std.is(descriptor.window , ITextWindow))
                cast(descriptor.window, ITextWindow).text = value;
        }

        function teamPlayers(teamId:Int):Array<ASAny>
        {
var player:ASObject  = null;            var values:Array<ASAny> = [];
            final _iter_:ASAny = this._result.players; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
{player = _tmp_;
                if (ASCompat.toInt(player.teamId) == teamId) values.push(player);
};
            return values;
        }

        function snapshot(source:ASObject):ASObject
        {
var key:String  = null, team:ASObject  = null, player:ASObject  = null;            var result:ASObject = {};
            if (checkNullIteratee(source)) for (_tmp_ in source.___keys()) {key = _tmp_;
ASCompat.setDynamicProperty(result, key, ASCompat.getDynamicProperty(source, key));
};
            result.teams = ([] : Array<Dynamic>); result.players = ([] : Array<Dynamic>);
            final _iter_:ASAny = source.teams; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
{team = _tmp_;
                result.teams.push({teamId:ASCompat.toInt(team.teamId), score:ASCompat.toInt(team.score), placement:ASCompat.toInt(team.placement)});
};
            final _iter_:ASAny = source.players; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
{player = _tmp_;
                result.players.push({userId:ASCompat.toInt(player.userId), name:ASCompat.toString(player.name), teamId:ASCompat.toInt(player.teamId),
                    score:ASCompat.toInt(player.score), placement:ASCompat.toInt(player.placement), winner:ASCompat.toBool(player.winner)});
};
            return result;
        }

        function openTickets(data:ASObject=null) { this._services.openTickets(); }
        function close(data:ASObject=null)
        { this._services.emit(this._historical ? SnowStormViewEvent.REDRAW : SnowStormViewEvent.LEAVE); }
        function rejoin(data:ASObject=null)
        { this._services.emit(SnowStormViewEvent.REJOIN); }

        public function dispose()
        {
            if (this._bestImage != null) this._bestImage.dispose();
            this._bestImage = null; this._result = null;
            this._shell = null; this._state = null; this._services = null;
        }
    }

