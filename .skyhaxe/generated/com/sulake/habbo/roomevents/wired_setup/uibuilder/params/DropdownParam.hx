package com.sulake.habbo.roomevents.wired_setup.uibuilder.params
;
    import com.sulake.habbo.roomevents.wired_setup.common.advanced_dropdown.ExpandableDropdownOption;

     class DropdownParam
    {
        var _caption:String;
        var _options:Vector<ExpandableDropdownOption>;
        var _showMoreLocalization:String;
        var _onChangeCallback:ASFunction;

        public function new(_arg_1:String, _arg_2:Vector<ExpandableDropdownOption> = null, _arg_3:ASFunction = null, _arg_4:String = "")
        {
            this._caption = _arg_1;
            this._options = _arg_2;
            this._onChangeCallback = _arg_3;
            this._showMoreLocalization = _arg_4;
        }

        public var onChangeCallback(get,never):ASFunction;
public function  get_onChangeCallback():ASFunction { return this._onChangeCallback; }
        public var caption(get,never):String;
public function  get_caption():String { return this._caption; }
        public var options(get,never):Vector<ExpandableDropdownOption>;
public function  get_options():Vector<ExpandableDropdownOption> { return this._options; }
        public var showMoreLocalization(get,never):String;
public function  get_showMoreLocalization():String { return this._showMoreLocalization; }
    }

