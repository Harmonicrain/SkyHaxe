package com.sulake.habbo.utils
;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.events.WindowEvent;

     class InfoText
    {
        var _input:ITextFieldWindow;
        var _includeInfo:Bool = false;
        var _infoText:String = "";

        public function new(k:ITextFieldWindow, _arg_2:String=null)
        {
            this._input = k;
            if (_arg_2 != null)
            {
                this._includeInfo = true;
                this._infoText = _arg_2;
                this._input.text = _arg_2;
            }
            this._input.addEventListener(WindowEvent.WINDOW_EVENT_FOCUSED, this.onFocus);
        }

        public function dispose()
        {
            if (this._input != null)
            {
                this._input.dispose();
                this._input = null;
            }
        }

        public function goBackToInitialState()
        {
            this._input.text = this._infoText;
            this._includeInfo = true;
        }

        public function getText():String
        {
            return this._includeInfo ? "" : this._input.text;
        }

        public function setText(k:String)
        {
            this._includeInfo = false;
            this._input.text = k;
        }

        public var input(get,never):ITextFieldWindow;
public function  get_input():ITextFieldWindow
        {
            return this._input;
        }

        function onFocus(k:WindowEvent)
        {
            if (!this._includeInfo)
            {
                return;
            }
            this._input.text = "";
            this._includeInfo = false;
        }
    }

