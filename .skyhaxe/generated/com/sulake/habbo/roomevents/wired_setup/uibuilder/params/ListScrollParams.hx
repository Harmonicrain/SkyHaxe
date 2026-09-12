package com.sulake.habbo.roomevents.wired_setup.uibuilder.params
;
     class ListScrollParams
    {
        var _alwaysShowScrollbar:Bool = false;
        var _minHeight:Int = 0;
        var _maxHeight:Int = 0;
        var _stickyFooter:Bool = false;
        var _stickyHeader:Bool = false;

        public function new(_arg_1:Bool, _arg_2:Int, _arg_3:Int, _arg_4:Bool = false, _arg_5:Bool = false)
        {
            this._alwaysShowScrollbar = _arg_1;
            this._minHeight = _arg_2;
            this._maxHeight = _arg_3;
            this._stickyFooter = _arg_4;
            this._stickyHeader = _arg_5;
        }

        public var alwaysShowScrollbar(get,never):Bool;
public function  get_alwaysShowScrollbar():Bool { return this._alwaysShowScrollbar; }
        public var minHeight(get,never):Int;
public function  get_minHeight():Int { return this._minHeight; }
        public var maxHeight(get,never):Int;
public function  get_maxHeight():Int { return this._maxHeight; }
        public var stickyFooter(get,never):Bool;
public function  get_stickyFooter():Bool { return this._stickyFooter; }
        public var stickyHeader(get,never):Bool;
public function  get_stickyHeader():Bool { return this._stickyHeader; }
    }

