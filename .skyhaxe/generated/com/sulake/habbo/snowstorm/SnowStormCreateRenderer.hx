package com.sulake.habbo.snowstorm
;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.events.WindowEvent;

    /** CCT-derived creation screen: name, one of seven fields, duration and one-to-four teams. */
     final class SnowStormCreateRenderer
    {
        var _shell:SnowStormLobbyWindow;
        var _state:SnowStormViewState;
        var _services:SnowStormViewServices;
        var _name:String = "SnowStorm";
        var _mapId:Int = 1;
        var _lengthChoice:Int = 1;
        var _teamCount:Int = 2;
        var _selectedTeam:Int = 0;
        var _fieldMenuOpen:Bool = false;

        public function new(shell:SnowStormLobbyWindow,
                                                 state:SnowStormViewState,
                                                 services:SnowStormViewServices)
        { this._shell = shell; this._state = state; this._services = services; }

        public function show(ticketCost:Int)
        {
            this._state.ticketCost = ticketCost;
            this.render();
        }

        function render()
        {
var teams = 0, length = 0;            this._shell.clearBindings();
            this._shell.bindInput("gs_field_gameNaming", this._name, this.onNameChange);
            this._shell.bindText("gs_dropmenu_gamefield", this._services.mapName(this._mapId));
            this._shell.bindAction("gs_dropmenu_gamefield", this.toggleMapMenu);
            for (_tmp_ in 1...5)
{teams= _tmp_;
                this._shell.bindAction("gs_radio_" + Std.string(teams) + "teams", this.selectTeams, teams);
};
            for (_tmp_ in 1...4)
{length= _tmp_;
                this._shell.bindAction("gs_radio_gamelength_" + Std.string(length), this.selectLength, length);
};
            this._shell.bindText("gs_button_rdy", this._services.text("gs_button_ready"));
            this._shell.bindAction("gs_button_rdy", this.submit);
            this._shell.bindText("gs_button_cncl", this._services.text("gs_button_cancel"));
            this._shell.bindAction("gs_button_cncl", this.cancel);
            this._shell.renderWindow("ss_gcreate");
            for (_tmp_ in 1...5)
{teams = _tmp_;
                this.renderRadio("gs_radio_" + Std.string(teams) + "teams", teams == this._teamCount);
};
            for (_tmp_ in 1...4)
{length = _tmp_;
                this.renderRadio("gs_radio_gamelength_" + Std.string(length), length == this._lengthChoice);
};
            this.renderTeamLabel("gs_2teams");
            this.renderTeamLabel("gs_3teams");
            this.renderTeamLabel("gs_4teams");
            this.renderTeamLabel("gs_deathmatch");
            var map:ASObject = this._shell.elementById("gs_dropmenu_gamefield");
            if (map != null)
            {
                this.renderButton(map, this._services.mapName(this._mapId));
                this._shell.surface.dropArrowInto(this._shell.window,
                    ASCompat.toInt(ASCompat.toNumber(map.x + map.w) - 13), ASCompat.toInt(map.y + Std.int(ASCompat.toNumber(ASCompat.toNumber(map.h) - 4) / 2)));
            }
            this.renderButton(this._shell.elementById("gs_button_cncl"),
                this._services.text("gs_button_cancel"));
            this.renderButton(this._shell.elementById("gs_button_rdy"),
                this._services.text("gs_button_ready"));
            this.drawMapMenu();
        }

        function renderRadio(id:String, selected:Bool)
        {
            var descriptor:ASObject = this._shell.elementById(id);
            if (descriptor != null)
                this._shell.surface.radioAt(ASCompat.toInt(descriptor.x), ASCompat.toInt(descriptor.y),
                    ASCompat.toInt(descriptor.w), ASCompat.toInt(descriptor.h), selected);
        }

        function renderButton(descriptor:ASObject, caption:String)
        {
            if (descriptor == null) return;
            this._shell.surface.buttonAt(descriptor.actionWindow, caption,
                ASCompat.toInt(descriptor.x), ASCompat.toInt(descriptor.y), ASCompat.toInt(descriptor.w), ASCompat.toInt(descriptor.h));
        }

        function renderTeamLabel(key:String)
        {
            var descriptor:ASObject = this._shell.elementByKey(key);
            if (descriptor == null) return;
            this._shell.addText(this._services.text(key), ASCompat.toInt(descriptor.x), ASCompat.toInt(descriptor.y),
                ASCompat.toInt(descriptor.w), ASCompat.toInt(descriptor.h), 0, false, "left");
        }

        function drawMapMenu()
        {
var mapId = 0, y = 0, suffix:String  = null;            if (!this._fieldMenuOpen) return;
            var menu:ASObject = this._shell.elementById("gs_dropmenu_gamefield");
            if (menu == null) return;
            var rowHeight= ASCompat.toInt(menu.h);
            for (_tmp_ in 1...8)
            {
mapId= _tmp_;
y= ASCompat.toInt(menu.y) + rowHeight * mapId;
suffix= mapId == this._mapId ? "pressed" : "active";
                this._shell.addPiece("b10_button_left_" + suffix,
                    ASCompat.toInt(menu.x), y, 6, rowHeight);
                this._shell.addPiece("b10_button_middle_" + suffix,
                    ASCompat.toInt(menu.x + 6), y, ASCompat.toInt(ASCompat.toNumber(menu.w) - 12), rowHeight);
                this._shell.addPiece("b10_button_right_" + suffix,
                    ASCompat.toInt(ASCompat.toNumber(menu.x + menu.w) - 6), y, 6, rowHeight);
                this._shell.addText(this._services.mapName(mapId),
                    ASCompat.toInt(menu.x + 8), y + 3, ASCompat.toInt(ASCompat.toNumber(menu.w) - 16), 13, 0,
                    mapId == this._mapId, "left");
                this._shell.addHotspot(ASCompat.toInt(menu.x), y, ASCompat.toInt(menu.w), rowHeight, this.selectMap, mapId);
            }
        }

        function onNameChange(event:WindowEvent)
        {
            var input:ITextFieldWindow = event == null ? null : Std.downcast(event.window , ITextFieldWindow);
            if (input != null) this._name = input.text;
        }

        function toggleMapMenu(data:ASObject=null)
        { this._fieldMenuOpen = !this._fieldMenuOpen; this.render(); }
        function selectMap(value:ASObject)
        { this._mapId = Std.int(Math.max(1, Math.min(7, ASCompat.toInt(value)))); this._fieldMenuOpen = false; this.render(); }
        function selectTeams(value:ASObject)
        {
            this._teamCount = Std.int(Math.max(1, Math.min(4, ASCompat.toInt(value))));
            if (this._selectedTeam >= this._teamCount) this._selectedTeam = 0;
            this.render();
        }
        function selectLength(value:ASObject)
        { this._lengthChoice = Std.int(Math.max(1, Math.min(3, ASCompat.toInt(value)))); this.render(); }

        function submit(data:ASObject=null)
        {
            var name= this._name == null ? "" : new compat.RegExp("^\\s+|\\s+$", "g").replace(this._name, "");
            if (name.length < 1 || name.length > 32)
            {
                this._services.emit(SnowStormViewEvent.REDRAW,
                    {error:this._services.text("sw_error_invalid_name")});
                return;
            }
            if (this._state.ticketBalance < this._state.ticketCost)
            { this._services.openTickets(); return; }
            this._services.emit(SnowStormViewEvent.CREATE, {name:name, mapId:this._mapId,
                lengthChoice:this._lengthChoice, teamCount:this._teamCount,
                selectedTeam:this._selectedTeam});
        }

        function cancel(data:ASObject=null)
        { this._fieldMenuOpen = false; this._services.emit(SnowStormViewEvent.LEAVE); }
        public function dispose()
        { this._shell = null; this._state = null; this._services = null; }
    }

