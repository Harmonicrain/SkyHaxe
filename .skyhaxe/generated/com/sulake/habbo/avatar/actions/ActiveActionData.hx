package com.sulake.habbo.avatar.actions
;
     class ActiveActionData implements IActiveActionData 
    {
        var _actionType:String = "";
        var _actionParameter:String = "";
        var _definition:IActionDefinition;
        var _startFrame:Int = 0;
        var _overridingAction:String;

        public function new(k:String, _arg_2:String="", _arg_3:Int=0)
        {
            this._actionType = k;
            this._actionParameter = _arg_2;
            this._startFrame = _arg_3;
        }

        public var actionType(get,never):String;
public function  get_actionType():String
        {
            return this._actionType;
        }

        
        public var actionParameter(get,set):String;
public function  get_actionParameter():String
        {
            return this._actionParameter;
        }

        
        public var definition(get,set):IActionDefinition;
public function  get_definition():IActionDefinition
        {
            return this._definition;
        }

        public var id(get,never):String;
public function  get_id():String
        {
            if (this._definition == null)
            {
                return "";
            }
            return (this._definition.id + "_") + this._actionParameter;
        }
public function  set_actionParameter(k:String):String        {
            return this._actionParameter = k;
        }
public function  set_definition(k:IActionDefinition):IActionDefinition        {
            return this._definition = k;
        }

        public function dispose()
        {
            this._actionType = null;
            this._actionParameter = null;
            this._definition = null;
        }

        public var startFrame(get,never):Int;
public function  get_startFrame():Int
        {
            return this._startFrame;
        }

        
        public var overridingAction(get,set):String;
public function  get_overridingAction():String
        {
            return this._overridingAction;
        }
public function  set_overridingAction(k:String):String        {
            return this._overridingAction = k;
        }

        public function toString():String
        {
            return (("Action: " + this._actionType) + "  param: ") + this._actionParameter;
        }
    }

