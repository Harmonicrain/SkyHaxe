package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker.overview
;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker.NewVariablePicker;

     class VariableNode
    {
        var _variable:WiredVariable;
        var _children:Map = new Map();
        var _name:String;

        public function new(variable:WiredVariable, name:String)
        {
            this._variable = variable;
            this._name = name;
        }

        public var name(get,never):String;
public function  get_name():String { return this._name; }
        public var variable(get,never):WiredVariable;
public function  get_variable():WiredVariable { return this._variable; }
        public var children(get,never):Vector<VariableNode>;
public function  get_children():Vector<VariableNode> { return Vector.ofArray(((cast this._children.getValues()) : Array<VariableNode>)); }
        public var childrenCount(get,never):Int;
public function  get_childrenCount():Int { return ASCompat.toInt(this._children.length); }
        public function getChildNodeByName(value:String):VariableNode { return ASCompat.dynamicAs(this._children.getValue(value) , VariableNode); }
        public function addChildNode(value:VariableNode) { this._children.add(value.name, value); }

        public function flatten(renameLeaf:Bool = false):Bool
        {
var child:VariableNode  = null;            if (this._children.length == 1 && this._variable == null)
            {
child= ASCompat.dynamicAs(this._children.getValues()[0] , VariableNode);
                if (child.flatten())
                {
                    this._variable = child.variable;
                    this._children.dispose();
                    this._children = new Map();
                }
            }
            var leaf= this._variable != null && this._children.length == 0;
            if (renameLeaf && leaf) { this._name = this._variable.variableName; }
            return leaf;
        }

        public function canBeSelected(picker:NewVariablePicker):Bool
        {
            return this._variable != null && (picker.variableFilter == null || ASCompat.toBool(picker.variableFilter(this._variable)));
        }

        public function isDisabled(picker:NewVariablePicker):Bool
        {
var child:VariableNode  = null;            if (this.canBeSelected(picker)) { return false; }
            final _iter_ = this._children.getValues(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
child = _tmp_;
                if (!child.isDisabled(picker)) { return false; }
            }
            return true;
        }
    }

