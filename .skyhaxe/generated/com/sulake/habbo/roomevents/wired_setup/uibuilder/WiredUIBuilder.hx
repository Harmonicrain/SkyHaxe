package com.sulake.habbo.roomevents.wired_setup.uibuilder
;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.ListScrollParams;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.main_layout.FramePreset;
    import flash.system.Capabilities;

    /**
     * Preset accumulator (May WiredUIBuilder). Collects top-level presets via
     * addElements and delegates the real layout to PresetManager.createFramePreset.
     */
     class WiredUIBuilder
    {
        var _presetManager:PresetManager;
        var _onClose:ASFunction;
        var _holderKey:String;
        var _code:Int = 0;
        var _frame:FramePreset;
        var _elements:Array<ASAny>;
        var _resizable:Bool = false;
        var _initialWidth:Int = 0;

        public function new(_arg_1:PresetManager, _arg_2:ASFunction, _arg_3:String, _arg_4:Int, _arg_5:Bool = false)
        {
            this._presetManager = _arg_1;
            this._onClose = _arg_2;
            this._resizable = _arg_5;
            this._holderKey = _arg_3;
            this._code = _arg_4;
            this._elements = [];
        }

        public function addElements( rest:Array<ASAny> = null)
        {
if (rest == null) rest = [];
var _local_2:ASAny  = null;            if (checkNullIteratee(rest)) for (_tmp_ in rest)
            {
_local_2 = _tmp_;
                this._elements.push(_local_2);
            }
        }

        public var frame(get,never):FramePreset;
public function  get_frame():FramePreset
        {
            return this._frame;
        }

        public function build(_arg_1:Float = 1, _arg_2:Bool = false)
        {
            var _local_3:ListScrollParams = null;
            if (_arg_2)
            {
                _local_3 = new ListScrollParams(false, 0, Std.int(Capabilities.screenResolutionY / 1.8), true, true);
            }
            this._frame = this._presetManager.createFramePreset(this._elements, this._onClose, this._holderKey, this._code, this._resizable, true, _local_3);
            this._elements = null;
            this._initialWidth = this._frame.window.width;
            this._frame.resizeToWidth(Std.int(this._initialWidth * _arg_1));
        }

        public var initialWidth(get,never):Int;
public function  get_initialWidth():Int
        {
            return this._initialWidth;
        }
    }

