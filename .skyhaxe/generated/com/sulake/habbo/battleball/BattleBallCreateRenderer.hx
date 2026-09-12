package com.sulake.habbo.battleball
;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.events.WindowEvent;

    /**
     * The creation form: name, arena, teams, duration, powers and the private toggle.
     *
     * A mode of the shared lobby window: it draws through the shell and its chrome, keeps only
     * its own state, and reaches facade behaviour through BattleBallViewServices rather than
     * holding a reference to the view.
     */
     class BattleBallCreateRenderer
    {
        var _shell:BattleBallLobbyWindow;
        var _state:BattleBallViewState;
        var _services:BattleBallViewServices;
        var _createMap:Int = 1;
        var _createTeams:Int = 2;
        var _createDuration:Int = 120;
        var _createTeam:Int = 0;
        var _createName:String = "";
        var _privateGame:Bool = false;
        var _powers:Array<ASAny> = [1,2,3,4,5,6,7,8];
        var _fieldMenuOpen:Bool = false;

        public function new(shell:BattleBallLobbyWindow, state:BattleBallViewState,
                                 services:BattleBallViewServices)
        {
            this._shell = shell; this._state = state; this._services = services;
        }

        public function dispose()
        {
            this._shell = null; this._state = null; this._services = null;
        }
        /** Game creation, shown in place of the list. Creating no longer drops the player into a game. */
        public function show(ticketCost:Int)
        {
            // Default name lives with the form that owns it, not with the button that opened it.
            if (this._createName == "") this._createName = "BattleBall " + Std.string(Date.now().getMinutes()) + Std.string(Date.now().getSeconds());
            this._shell.clearBindings();
            this._shell.bindText("bb_field_gameNaming", this._createName);
            this._shell.bindText("gs_dropmenu_gamefield", this._services.arenaName(this._createMap));
            this._shell.bindAction("gs_dropmenu_gamefield", this.toggleFieldMenu);
            this._shell.bindAction("bb_button_cncl", this._services.redraw);
            this._shell.bindAction("bb_button_rdy", this.createGame);
            this._shell.renderWindow("bb_gcreate");
            this.drawCreateOptions();
            this.drawFieldMenu();
            // The arena selector is a #dropmenu in the layout, not a plain button; it needs the drop
            // arrow at its right edge to read as one.
            var menu:ASObject = this._shell.elementById("gs_dropmenu_gamefield");
            if (menu != null) this._shell.chrome.dropArrow(ASCompat.toInt(ASCompat.toNumber(menu.x + menu.w) - 14), ASCompat.toInt(ASCompat.toNumber(menu.y + Std.int(ASCompat.toNumber(menu.h) / 2)) - 2));
        }
        /**
         * The three team radios and the eight power-up slots. The layout already reserves a rect for
         * each, so only their selected state is drawn here. button.radio.off has no bitmap in the cast
         * at all, so the radios themselves are drawn rather than blitted.
         */
        function drawCreateOptions()
        {
var teams = 0, radio:ASObject  = null, power = 0, slot:ASObject  = null, enabled = false;            for (_tmp_ in 2...5)
            {
teams= _tmp_;
radio= this._shell.elementById("bb_radio_teams" + Std.string(teams) + "x");
                if (radio == null) continue;
                this._shell.chrome.radio("bb_radio_teams" + Std.string(teams), radio, this._createTeams == teams, teams,
                    this.chooseTeams);
            }
            for (_tmp_ in 1...9)
            {
power= _tmp_;
slot= this._shell.elementById("bb2_slot_pwrup_" + Std.string(power));
                if (slot == null) continue;
enabled= this._powers.indexOf(power) >= 0;
                this._shell.chrome.piece("bb2_pwrupbutton_" + Std.string(power) + "_" + (enabled ? "1" : "0"),
                    ASCompat.toInt(slot.x), ASCompat.toInt(slot.y), ASCompat.toInt(slot.w), ASCompat.toInt(slot.h));
                this._shell.chrome.hotspot("power_" + Std.string(power), ASCompat.toInt(slot.x), ASCompat.toInt(slot.y), ASCompat.toInt(slot.w), ASCompat.toInt(slot.h), this.togglePower, power);
            }
        }
        /**
         * The arena selector is a #dropmenu in the layout, so it opens a list rather than cycling on
         * click. The cast names no arenas -- only the five bb2_lvlthumb previews exist -- so the labels
         * come from bb_arena_1..5 in the texts. The round length has no control here at all: the create
         * window declares a name field, this menu, the team radios and the powerup slots, nothing more,
         * so the duration keeps its default rather than being bolted onto this caption.
         */
        function toggleFieldMenu(data:ASObject=null)
        {
            this._fieldMenuOpen = !this._fieldMenuOpen;
            this._services.showCreate(this._state.ticketCost);
        }
        /** The open list, drawn over the window under the closed menu. */
        function drawFieldMenu()
        {
var map = 0, top = 0, selected = false, suffix:String  = null;            if (!this._fieldMenuOpen) return;
            var menu:ASObject = this._shell.elementById("gs_dropmenu_gamefield");
            if (menu == null) return;
            var rowHeight= ASCompat.toInt(menu.h);
            for (_tmp_ in 1...6)
            {
map= _tmp_;
top= ASCompat.toInt(menu.y) + rowHeight * map;
selected= this._createMap == map;
suffix= selected ? "pressed" : "active";
                this._shell.chrome.piece("b10_button_left_" + suffix, ASCompat.toInt(menu.x), top, 6, rowHeight);
                this._shell.chrome.piece("b10_button_middle_" + suffix, ASCompat.toInt(menu.x) + 6, top, ASCompat.toInt(menu.w) - 12, rowHeight);
                this._shell.chrome.piece("b10_button_right_" + suffix, ASCompat.toInt(menu.x) + ASCompat.toInt(menu.w) - 6, top, 6, rowHeight);
                this._shell.chrome.text(this._services.arenaName(map), ASCompat.toInt(menu.x) + 8, top + Std.int((rowHeight - 13) / 2),
                    ASCompat.toInt(menu.w) - 16, 13, 0x000000, selected, "left");
                this._shell.chrome.hotspot("field_" + Std.string(map), ASCompat.toInt(menu.x), top, ASCompat.toInt(menu.w), rowHeight, this.chooseField, map);
            }
        }
        function chooseField(value:ASObject)
        {
            this._createMap = ASCompat.toInt(value);
            this._fieldMenuOpen = false;
            this._services.showCreate(this._state.ticketCost);
        }
        function chooseTeams(value:ASObject)
        {
            this._createTeams = ASCompat.toInt(value);
            // Keep the team we would join inside the new range.
            this._createTeam %= this._createTeams;
            this._services.showCreate(this._state.ticketCost);
        }
        function togglePower(value:ASObject) { var id=ASCompat.toInt(value); var index=this._powers.indexOf(id); if(index>=0)this._powers.splice(index,1);else this._powers.push(id); ASCompat.ASArray.sortWithOptions(this._powers, ASCompat.ASArray.NUMERIC); this._services.showCreate(this._state.ticketCost); }
        function createGame(data:ASObject=null) { this._services.emit(BattleBallViewEvent.CREATE,
            {name:this._createName != "" ? this._createName : "BattleBall",mapId:this._createMap,roundSeconds:this._createDuration,
             teamCount:this._createTeams,teamCapacity:this._shell.teamRowCapacity(this._createTeams),
             selectedTeam:this._createTeam,privateGame:this._privateGame,powers:this._powers.slice(0)}); }
        public function onLobbyInputChange(event:WindowEvent)
        {
            var input:ITextFieldWindow = event == null ? null : Std.downcast(event.window , ITextFieldWindow);
            if (input != null) this._createName = input.text;
        }
    }

