package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextAreaParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class TextAreaPreset extends WiredUIPreset
    {
        var _container:IWindowContainer;
        var _inputView:IWindow;
        var _field:ITextFieldWindow;
        var _placeholderPreset:TextPreset;
        var _param:TextAreaParam;
        var _fieldWidthDelta:Int = 0;

        public function new(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:TextAreaParam)
        {
            super(_arg_1, _arg_2, _arg_3);
            this._container = Std.downcast(_arg_2.createLayout("growing_container_view") , IWindowContainer);
            this._inputView = _arg_3.createTextInputView();
            this._field = Std.downcast(Std.downcast(this._inputView , IWindowContainer).findChildByName("field") , ITextFieldWindow);
            this._fieldWidthDelta = (this._inputView.width - this._field.width);
            this._param = _arg_4;
            if (_arg_4.maxCharacters > 0)
            {
                this._field.maxChars = _arg_4.maxCharacters;
            }
            this._field.text = this._param.initialText;
            this._field.multiline = true;
            this._field.wordWrap = _arg_4.wordwrap;
            if (_arg_4.width >= 0)
            {
                this._inputView.width = (_arg_4.width + this._fieldWidthDelta);
            }
            this._inputView.height = _arg_4.height;
            if (_arg_4.maxLines >= 0)
            {
                this._field.maxLines = _arg_4.maxLines;
            }
            this._field.editable = _arg_4.editable;
            this._field.restrict = _arg_4.restrict;
            if (_arg_4.tooltip != null)
            {
                this._field.toolTipCaption = _arg_4.tooltip;
            }
            this._container.addChild(this._inputView);
            if (_arg_4.placeholder != null)
            {
                this._placeholderPreset = _arg_2.createText(_arg_4.placeholder, new TextParam(1));
                this._placeholderPreset.window.blend = 0.5;
                this._placeholderPreset.window.tags.push("HALF_BLEND");
                this._placeholderPreset.window.x = this._field.x;
                this._placeholderPreset.window.y = this._field.y;
                this._container.addChild(this._placeholderPreset.window);
            }
            this._field.addEventListener(WindowEvent.WINDOW_EVENT_CHANGE, this.textHasChanged);
            this.textHasChanged(null);
        }

        function textHasChanged(_arg_1:WindowEvent)
        {
            if (this._placeholderPreset != null)
            {
                this._placeholderPreset.visible = (this._field.length == 0);
            }
            this.updateWarn();
        }

        
        public var text(get,set):String;
public function  get_text():String
        {
            return new compat.RegExp("\\r", "g").replace(new compat.RegExp("\\n\\r", "g").replace(this._field.text, "\n"), "\n");
        }
public function  set_text(_arg_1:String):String        {
            this._field.text = new compat.RegExp("\\n", "g").replace(_arg_1, "\r");
            this.textHasChanged(null);
return _arg_1;
        }

        public function reset()
        {
            this._field.text = "";
            this.textHasChanged(null);
        }

        function shouldShowWarn():Bool
        {
            var _local_2= this._param.maxCharacters;
            if (_local_2 <= 10)
            {
                return false;
            }
            var _local_1= Std.int(Math.min(30, Math.max(6, _local_2 / 5)));
            return this._field.text.length > (_local_2 - _local_1);
        }

        function updateWarn()
        {
            if (this.charLimitWarnArea == null)
            {
                return;
            }
            var _local_1= this.shouldShowWarn();
            this.charLimitWarnArea.visible = _local_1;
            if (_local_1)
            {
                this.limitText.text = (Std.string(this._field.text.length) + "/" + Std.string(this._param.maxCharacters));
            }
        }

        override public function resizeToWidth(_arg_1:Int)
        {
            super.resizeToWidth(_arg_1);
            var _local_2= (this._param.width >= 0) ? (this._param.width + this._fieldWidthDelta) : _arg_1;
            this._inputView.width = _local_2;
            if (this._placeholderPreset != null)
            {
                this._placeholderPreset.resizeToWidth(_local_2 - this._fieldWidthDelta);
            }
        }

        override public function  get_window():IWindow
        {
            return this._container;
        }

        override function  get_childPresets():Array<ASAny>
        {
            return (this._placeholderPreset == null) ? [] : [this._placeholderPreset];
        }

        override public function dispose()
        {
            if (disposed)
            {
                return;
            }
            super.dispose();
            this._container.dispose();
            this._container = null;
            this._placeholderPreset = null;
            this._param = null;
        }

        var charLimitWarnArea(get,never):IWindowContainer;
function  get_charLimitWarnArea():IWindowContainer
        {
            return Std.downcast(this._container.findChildByName("char_limit_warn") , IWindowContainer);
        }

        var limitText(get,never):ITextWindow;
function  get_limitText():ITextWindow
        {
            return Std.downcast(this._container.findChildByName("limit_text") , ITextWindow);
        }
    }

