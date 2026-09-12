package com.sulake.habbo.roomevents.wired_setup.uibuilder.params
;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.WiredUIPreset;

     class SectionParam
    {
        public static var EXPAND_MODE_EXPANDED:Int = 0;
        public static var EXPAND_MODE_COLLAPSED:Int = 1;
        public static var EXPAND_MODE_EXPANDED_WITH_TOGGLE:Int = 2;

        public static var DEFAULT:SectionParam = new SectionParam(null, 0);
        public static var COLLAPSED:SectionParam = new SectionParam(null, 1);
        public static var EXPANDED_WITH_TOGGLE:SectionParam = new SectionParam(null, 2);

        var _miscHeaderOptions:Array<ASAny> = [];
        var _expandMode:Int = 0;
        var _sourceTypeSelectorParam:SourceTypeSelectorParam;
        var _headerOptionLeft:WiredUIPreset;
        var _titleYOffset:Int = 0;

        public function new(_arg_1:SourceTypeSelectorParam = null, _arg_2:Int = 0, _arg_3:WiredUIPreset = null, _arg_4:Int = 0)
        {
            this._expandMode = _arg_2;
            this._sourceTypeSelectorParam = _arg_1;
            this._headerOptionLeft = _arg_3;
            this._titleYOffset = _arg_4;
        }

                public var expandMode(get,set):Int;
public function  get_expandMode():Int { return this._expandMode; }
public function  set_expandMode(_arg_1:Int):Int{ return this._expandMode = _arg_1; }
                public var sourceTypeSelectorParam(get,set):SourceTypeSelectorParam;
public function  get_sourceTypeSelectorParam():SourceTypeSelectorParam { return this._sourceTypeSelectorParam; }
public function  set_sourceTypeSelectorParam(_arg_1:SourceTypeSelectorParam):SourceTypeSelectorParam{ return this._sourceTypeSelectorParam = _arg_1; }
        public function addHeaderOption(_arg_1:WiredUIPreset) { this._miscHeaderOptions.push(_arg_1); }
        public var miscHeaderOptions(get,never):Array<ASAny>;
public function  get_miscHeaderOptions():Array<ASAny> { return this._miscHeaderOptions; }
                public var headerOptionLeft(get,set):WiredUIPreset;
public function  get_headerOptionLeft():WiredUIPreset { return this._headerOptionLeft; }
public function  set_headerOptionLeft(_arg_1:WiredUIPreset):WiredUIPreset{ return this._headerOptionLeft = _arg_1; }
                public var titleYOffset(get,set):Int;
public function  get_titleYOffset():Int { return this._titleYOffset; }
public function  set_titleYOffset(_arg_1:Int):Int{ return this._titleYOffset = _arg_1; }
    }

