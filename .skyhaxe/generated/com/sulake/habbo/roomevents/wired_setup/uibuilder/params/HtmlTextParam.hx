package com.sulake.habbo.roomevents.wired_setup.uibuilder.params
;
     class HtmlTextParam extends TextParam
    {
        public static final DEFAULT:HtmlTextParam = new HtmlTextParam(1);

        var _selectable:Bool = false;

        public function new(_arg_1:Int, _arg_2:Bool = false, _arg_3:Int = 0)
        {
            super(_arg_1, false, _arg_3);
            this._selectable = _arg_2;
        }

        public var selectable(get,never):Bool;
public function  get_selectable():Bool { return this._selectable; }
    }

