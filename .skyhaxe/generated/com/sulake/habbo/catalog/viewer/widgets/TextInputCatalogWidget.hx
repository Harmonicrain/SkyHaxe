package com.sulake.habbo.catalog.viewer.widgets
;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.events.WindowKeyboardEvent;
    import com.sulake.habbo.catalog.viewer.widgets.events.TextInputEvent;

     class TextInputCatalogWidget extends CatalogWidget
    {
        var _inputText:ITextFieldWindow;

        public function new(k:IWindowContainer)
        {
            super(k);
        }

        override public function init():Bool
        {
            if (!super.init())
            {
                return false;
            }
            this._inputText = Std.downcast(_window.findChildByName("input_text") , ITextFieldWindow);
            if (this._inputText != null)
            {
                this._inputText.addEventListener(WindowKeyboardEvent.WINDOW_EVENT_KEY_UP, this._Str_23857);
            }
            return true;
        }

        function _Str_23857(k:WindowKeyboardEvent)
        {
            if (this._inputText == null)
            {
                return;
            }
            events.dispatchEvent(new TextInputEvent(this._inputText.text));
        }
    }

