package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.contracts
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirementNode;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirementRule;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.ButtonPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.WiredUIPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class TradeRuleListEditorPreset extends WiredUIPreset
    {
        public static inline final MAX_RULES= 3;

        var _list:IItemListWindow;
        var _editors:Vector<TradeRuleEditorPreset>;
        var _addButton:ButtonPreset;
        var _onEdit:ASFunction;
        var _onAdd:ASFunction;

        public function new(roomEvents:HabboUserDefinedRoomEvents,
            presetManager:PresetManager, style:WiredStyle,
            onEdit:ASFunction, onAdd:ASFunction)
        {
            super(roomEvents, presetManager, style);
            this._onEdit = onEdit;
            this._onAdd = onAdd;
            this._list = Std.downcast(presetManager.createLayout("vertical_list_view") , IItemListWindow);
            this._list.spacing = style.genericVerticalSpacing;
            this._addButton = presetManager.createButton(
                "${wiredcontracts.payment_add_more}", this.onAddMore);
            this._editors = new Vector<TradeRuleEditorPreset>();
            this._list.addListItem(this._addButton.window);
            this.refreshAddMoreVisibility();
        }

        public var rules(never,set):Vector<TradeRequirementRule>;
public function  set_rules(value:Vector<TradeRequirementRule>):Vector<TradeRequirementRule>        {
var rule:TradeRequirementRule  = null, editor:TradeRuleEditorPreset  = null;            this.removeAllRules();
            if (value.length == 0)
            {
                value = new Vector<TradeRequirementRule>();
                value.push(new TradeRequirementRule(new Vector<TradeRequirementNode>()));
            }
            var index= 1;
            if (checkNullIteratee(value)) for (_tmp_ in value)
            {
rule = _tmp_;
editor= this._presetManager.createRuleEditorPreset(
                    "-", this._onEdit, this._onAdd,
                    index == 1 ? null : this.onRuleRemoved);
                editor.rule = rule.deepCopy();
                this._editors.push(editor);
                this._list.addListItemAt(editor.window, this._list.numListItems - 1);
                editor.resizeToWidth(this._list.width);
                index++;
            }
            this.fixNames();
            this.refreshAddMoreVisibility();
return value;
        }

        public function finalizeRules():Vector<TradeRequirementRule>
        {
var editor:TradeRuleEditorPreset  = null, rule:TradeRequirementRule  = null;            var result= new Vector<TradeRequirementRule>();
            final _iter_ = this._editors; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
editor = _tmp_;
rule= editor.finalizeRule();
                if (rule.nodes.length > 0) result.push(rule);
            }
            return result;
        }

        function onAddMore()
        {
            if (this._editors.length >= MAX_RULES) return;
            var editor= this._presetManager.createRuleEditorPreset(
                "", this._onEdit, this._onAdd,
                this._editors.length == 0 ? null : this.onRuleRemoved);
            editor.rule = new TradeRequirementRule(new Vector<TradeRequirementNode>());
            this._editors.push(editor);
            this._list.addListItemAt(editor.window, this._list.numListItems - 1);
            editor.resizeToWidth(this._list.width);
            this.fixNames();
            this.refreshAddMoreVisibility();
        }

        function refreshAddMoreVisibility()
        {
            this._addButton.disabled = this._editors.length >= MAX_RULES;
        }

        function onRuleRemoved(editor:TradeRuleEditorPreset)
        {
            var index= this._editors.indexOf(editor);
            if (index == -1) return;
            this._list.removeListItemAt(index);
            this._editors.splice(index, 1);
            editor.dispose();
            this.fixNames();
            this.refreshAddMoreVisibility();
        }

        function removeAllRules()
        {
var editor:TradeRuleEditorPreset  = null;            while (this._list.numListItems > 1) this._list.removeListItemAt(0);
            final _iter_ = this._editors; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
{editor = _tmp_;
                editor.dispose();
};
            this._editors = new Vector<TradeRuleEditorPreset>();
            this.refreshAddMoreVisibility();
        }

        function fixNames()
        {
var editor:TradeRuleEditorPreset  = null;            var index= 0;
            final _iter_ = this._editors; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
editor = _tmp_;
                index++;
                editor.updateTitle(this.localizations.getLocalizationWithParams(
                    "wiredcontracts.payment_rule", "", ["i", index]));
            }
        }

        override public function  get_window():IWindow { return this._list; }
        override public function resizeToWidth(width:Int)
        {
var editor:TradeRuleEditorPreset  = null;            super.resizeToWidth(width);
            this._list.width = width;
            final _iter_ = this._editors; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
{editor = _tmp_;
                editor.resizeToWidth(width);
};
            this._addButton.resizeToWidth(width);
        }
        override function  get_childPresets():Array<ASAny>
        {
var editor:TradeRuleEditorPreset  = null;            var children:Array<ASAny> = [];
            final _iter_ = this._editors; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
{editor = _tmp_;
                children.push(editor);
};
            children.push(this._addButton);
            return children;
        }
        override public function dispose()
        {
            if (disposed) return;
            super.dispose();
            this._editors = null;
            this._addButton = null;
            this._onEdit = null;
            this._onAdd = null;
            this._list.dispose();
            this._list = null;
        }
    }

