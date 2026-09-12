package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker.tabbuttons
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariableTypes;
    import com.sulake.habbo.roomevents.Util;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker.NewVariablePicker;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker.overview.VariableNode;

     class TabButtonConfigs
    {
        public static inline final ALL_TAB_ID= 0;
        public static inline final RECENT_TAB_ID= 1;
        public static inline final USER_CREATED_TAB_ID= 2;
        public static inline final DYNAMIC_TAB_ID= 3;
        public static inline final INTERNAL_TAB_ID= 4;
        public static inline final SEARCH_TAB_ID= 5;

        var _picker:NewVariablePicker;
        var _tabButtons:Vector<TabButtonConfig>;

        public function new(picker:NewVariablePicker)
        {
            this._picker = picker;
            this._tabButtons = Vector.ofArray([
                new TabButtonConfig(ALL_TAB_ID, "var_picker_all", "wiredfurni.variable_picker.tab.all", this.allFilter),
                new TabButtonConfig(RECENT_TAB_ID, "var_picker_recent", "wiredfurni.variable_picker.tab.recent", this.recentFilter),
                new TabButtonConfig(USER_CREATED_TAB_ID, "var_picker_usermade", "wiredfurni.variable_picker.tab.user_created", this.userCreatedFilter),
                new TabButtonConfig(DYNAMIC_TAB_ID, "var_picker_smart", "wiredfurni.variable_picker.tab.dynamic", this.dynamicFilter),
                new TabButtonConfig(INTERNAL_TAB_ID, "var_picker_internal", "wiredfurni.variable_picker.tab.internal", this.internalFilter),
                new TabButtonConfig(SEARCH_TAB_ID, "var_picker_search", "wiredfurni.variable_picker.tab.search", this.searchFilter)
            ]);
        }

        public var tabButtons(get,never):Vector<TabButtonConfig>;
public function  get_tabButtons():Vector<TabButtonConfig> { return this._tabButtons; }

        function nodesFromVector(values:Vector<WiredVariable>, flatten:Bool = false):VariableNode
        {
var variable:WiredVariable  = null, current:VariableNode  = null, parts:Array<ASAny>  = null,                 index = 0, name:String  = null, child:VariableNode  = null, top:VariableNode  = null;            var root= new VariableNode(null, null);
            if (checkNullIteratee(values)) for (_tmp_ in values)
            {
variable = _tmp_;
current= root;
parts= Util.splitVariableName(variable);
                index= 0;while (index < parts.length)
                {
name= ASCompat.toString(parts[index]);
child= current.getChildNodeByName(name);
                    if (child == null)
                    {
                        child = new VariableNode(index == parts.length - 1 ? variable : null, name);
                        current.addChildNode(child);
                    }
                    current = child;
index++;
                }
            }
            if (flatten)
            {
                final _iter_ = root.children; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_) { top = _tmp_;
top.flatten(true); }
            }
            return root;
        }

        function allFilter():VariableNode { return this.nodesFromVector(this._picker.filteredVariables); }

        function recentFilter():VariableNode
        {
var id:String  = null, variable:WiredVariable  = null;            var values= new Vector<WiredVariable>();
            final _iter_ = this._picker.roomEvents.variablePickerHelper.getHistory(this._picker.variableTarget); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
id = _tmp_;
variable= this._picker.filteredVariableById(id);
                if (variable != null) { values.push(variable); }
            }
            return this.nodesFromVector(values, true);
        }

        function userCreatedFilter():VariableNode
        {
            return this.nodesFromVector(this.byType([WiredVariableTypes.USER_CREATED,
                WiredVariableTypes.USER_CREATED_SPECIAL]));
        }

        function dynamicFilter():VariableNode
        {
            return this.nodesFromVector(this.byType([WiredVariableTypes.DYNAMIC]));
        }

        function internalFilter():VariableNode
        {
            return this.nodesFromVector(this.byType([WiredVariableTypes.INTERNAL]));
        }

        function byType(types:Array<ASAny> = null):Vector<WiredVariable>
        {
if (types == null) types = [];
var variable:WiredVariable  = null;            var output= new Vector<WiredVariable>();
            final _iter_ = this._picker.filteredVariables; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
variable = _tmp_;
                if (types.indexOf(variable.variableType) >= 0) { output.push(variable); }
            }
            return output;
        }

        function searchFilter():VariableNode
        {
var variable:WiredVariable  = null, matches = false, term:String  = null;            var query= this._picker.inputField.text;
            if (query.length == 0) { return this.nodesFromVector(new Vector<WiredVariable>()); }
            var terms:Array<ASAny> = (cast query.split(" "));
            var output= new Vector<WiredVariable>();
            final _iter_ = this._picker.filteredVariables; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
variable = _tmp_;
matches= true;
                if (checkNullIteratee(terms)) for (_tmp_ in terms)
                {
term = _tmp_;
                    if (variable.variableName.toLowerCase().indexOf(term.toLowerCase()) < 0)
                    {
                        matches = false;
                        break;
                    }
                }
                if (matches) { output.push(variable); }
            }
            return this.nodesFromVector(output, true);
        }
    }

