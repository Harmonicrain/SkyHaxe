package com.sulake.habbo.roomevents.wired_setup.uibuilder.params
;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.WiredUIPreset;

     class RadioButtonParam
    {
        var _id:Int = 0;
        var _text:String;
        var _iconAssetName:String;
        var _extra1:WiredUIPreset;
        var _extra2:WiredUIPreset;
        var _newLine:Bool = false;

        public function new(_arg_1:Int, _arg_2:String, _arg_3:WiredUIPreset = null, _arg_4:WiredUIPreset = null, _arg_5:Bool = false)
        {
            this._id = _arg_1;
            this._text = _arg_2;
            this._extra1 = _arg_3;
            this._extra2 = _arg_4;
            this._newLine = _arg_5;
        }

        public var id(get,never):Int;
public function  get_id():Int { return this._id; }
        public var text(get,never):String;
public function  get_text():String { return this._text; }
                public var iconAssetName(get,set):String;
public function  get_iconAssetName():String { return this._iconAssetName; }
public function  set_iconAssetName(_arg_1:String):String{ return this._iconAssetName = _arg_1; }
                public var extra1(get,set):WiredUIPreset;
public function  get_extra1():WiredUIPreset { return this._extra1; }
public function  set_extra1(_arg_1:WiredUIPreset):WiredUIPreset{ return this._extra1 = _arg_1; }
                public var extra2(get,set):WiredUIPreset;
public function  get_extra2():WiredUIPreset { return this._extra2; }
public function  set_extra2(_arg_1:WiredUIPreset):WiredUIPreset{ return this._extra2 = _arg_1; }
                public var newLine(get,set):Bool;
public function  get_newLine():Bool { return this._newLine; }
public function  set_newLine(_arg_1:Bool):Bool{ return this._newLine = _arg_1; }
    }

