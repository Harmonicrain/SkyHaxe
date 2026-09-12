package com.sulake.habbo.roomevents.wired_setup.uibuilder.params
;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.WiredUIPreset;

     class CheckboxOptionParam
    {
        var _text:String;
        var _id:Int = -1;
        var _iconAssetName:String;
        var _extra1:WiredUIPreset;
        var _extra2:WiredUIPreset;

        public function new(_arg_1:String, _arg_2:Int = -1, _arg_3:WiredUIPreset = null, _arg_4:WiredUIPreset = null)
        {
            this._text = _arg_1;
            this._id = _arg_2;
            this._extra1 = _arg_3;
            this._extra2 = _arg_4;
        }

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
                public var id(get,set):Int;
public function  get_id():Int { return this._id; }
public function  set_id(_arg_1:Int):Int{ return this._id = _arg_1; }
    }

