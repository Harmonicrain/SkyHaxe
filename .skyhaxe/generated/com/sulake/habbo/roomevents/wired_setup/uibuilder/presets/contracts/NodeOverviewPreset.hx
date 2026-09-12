package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.contracts
;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class NodeOverviewPreset extends TradeRuleEditorPreset
    {
        var _onNodeClick:ASFunction;

        public function new(roomEvents:HabboUserDefinedRoomEvents,
            presetManager:PresetManager, style:WiredStyle, title:String,
            onNodeClick:ASFunction = null)
        {
            super(roomEvents, presetManager, style, title, null, null);
            var button= this.addMoreButton;
            button.parent = null;
            button.dispose();
            this.closeRegion.visible = false;
            this._onNodeClick = onNodeClick;
        }

        override function  get_isOneLineMode():Bool { return false; }
        override function  get_showNodeCloseButton():Bool { return false; }
        override function updateCloseButtonVisibility() {}
@:allow(com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.contracts)         override function editNode(view:TradeRuleNodeView)
        {
            if (this._onNodeClick != null) this._onNodeClick(view.node);
        }
    }

