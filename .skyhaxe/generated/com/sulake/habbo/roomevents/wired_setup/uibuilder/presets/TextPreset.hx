package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
;
    import com.sulake.core.runtime.exceptions.Exception;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class TextPreset extends WiredUIPreset
    {
        var _param:TextParam;
        var _window:ITextWindow;

        public function new(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:String, _arg_5:TextParam)
        {
            super(_arg_1, _arg_2, _arg_3);
            this._param = _arg_5;
            this._window = this.createView();
            if (this._param.fontSize != -1)
            {
                this._window.fontSize = this._param.fontSize;
            }
            if (this._param.textColor != 0)
            {
                this._window.textColor = this._param.textColor;
            }
            this._window.text = _arg_4;
            this.initializeMode(_arg_5);
        }

        function initializeMode(_arg_1:TextParam)
        {
            if (_arg_1.mode == TextParam.MODE_MULTILINE)
            {
                this._window.multiline = true;
                this._window.wordWrap = true;
                this._window.maxLines = _arg_1.maxLines;
                if (_arg_1.alignment != null)
                {
                    this._window.autoSize = _arg_1.alignment;
                }
            }
            if (_arg_1.mode == TextParam.MODE_OVERFLOW)
            {
                this._window.overflowReplace = "...";
                this._window.autoSize = "none";
            }
        }

        function createView():ITextWindow
        {
            var _local_1= _style.createTextView(this._param.bold);
            _local_1.underline = this._param.underline;
            return _local_1;
        }

        
        public var text(get,set):String;
public function  get_text():String
        {
            return this._window.text;
        }
public function  set_text(_arg_1:String):String        {
            return this._window.text = _arg_1;
        }

        override public function hasStaticWidth():Bool
        {
            return this.canStretch;
        }

        override public function  get_staticWidth():Int
        {
            if (this.canStretch)
            {
                return this._window.width;
            }
            throw new Exception("Non stretching text has no static width");
        }

        override public function  get_window():IWindow
        {
            return this._window;
        }

        override public function resizeToWidth(_arg_1:Int)
        {
            super.resizeToWidth(_arg_1);
            if (!this.canStretch)
            {
                this._window.width = _arg_1;
            }
        }

        public var canStretch(get,never):Bool;
public function  get_canStretch():Bool
        {
            return this._param.mode == TextParam.MODE_STRETCH;
        }

        public var width(get,never):Int;
public function  get_width():Int
        {
            return this._window.width;
        }

        public var fontSize(get,never):Int;
public function  get_fontSize():Int
        {
            return ASCompat.toInt(this._window .fontSize);
        }

        override public function dispose()
        {
            if (disposed)
            {
                return;
            }
            super.dispose();
            this._window.dispose();
            this._window = null;
            this._param = null;
        }
    }

