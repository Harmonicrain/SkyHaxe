package com.sulake.habbo.roomevents.wired_setup.actiontypes
;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;

     class SimpleActionElement extends DefaultElement
    {
        var _code:Int = 0;
        var _negativeCode:Int = 0;

        public function new(_arg_1:Int, _arg_2:Int = -1)
        {
            super();
            this._code = _arg_1;
            this._negativeCode = _arg_2;
        }

        override public function  get_negativeCode():Int
        {
            return this._negativeCode;
        }

        override public function  get_code():Int
        {
            return this._code;
        }

        override public function  get_inputMode():Int
        {
            return DefaultElement.INPUTS_TYPE_UI_BUILDER;
        }
    }

