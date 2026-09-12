package com.sulake.habbo.roomevents.wired_setup.variables
;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.VariableNameSection;

    /** Shared July-compatible state for variable configuration editors. */
     class VariableElement extends DefaultElement implements IWiredVariableElement
    {
        var _initialVariableName:String = "";

        
        public var initialVariableName(get,set):String;
public function  set_initialVariableName(value:String):String        {
            this._initialVariableName = value != null ? value : "";
            if (this.variableNameSection != null)
            {
                this.variableNameSection.variableName = this._initialVariableName;
            }
return value;
        }
public function  get_initialVariableName():String
        {
            return this._initialVariableName;
        }

        public function variableType():Int
        {
            return 0;
        }

        var variableNameSection(get,never):VariableNameSection;
function  get_variableNameSection():VariableNameSection
        {
            return null;
        }

	public function new() { super(); }
    }

