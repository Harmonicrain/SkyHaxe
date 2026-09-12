package com.sulake.habbo.roomevents.wired_setup.triggerconfs
;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;

     class SimpleTriggerElement extends DefaultElement
    {
        var _code:Int = 0;

        public function new(_arg_1:Int)
        {
            super();
            this._code = _arg_1;
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

