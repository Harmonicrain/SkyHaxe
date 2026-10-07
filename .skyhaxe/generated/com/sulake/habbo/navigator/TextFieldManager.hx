package com.sulake.habbo.navigator
;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.events.WindowKeyboardEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.components.ITextWindow;
    import flash.geom.Point;
    import com.sulake.core.window.IWindow;
    import flash.ui.Keyboard;

     class TextFieldManager 
    {
        var _navigator:IHabboTransitionalNavigator;
        var _input:ITextFieldWindow;
        var _includeInfo:Bool = false;
        var _infoText:String = "";
        var _maxTextLen:Int = 0;
        var _onEnter:ASFunction;
        var _invalidText:String = "";
        var _errorPopup:IWindowContainer;
        var _orgTextBackground:Bool = false;
        var _orgTextBackgroundColor:UInt = 0;

        public function new(k:IHabboTransitionalNavigator, _arg_2:ITextFieldWindow, _arg_3:Int=1000, _arg_4:ASFunction=null, _arg_5:String=null)
        {
            this._navigator = k;
            this._input = _arg_2;
            this._maxTextLen = _arg_3;
            _arg_2.maxChars = _arg_3;
            this._onEnter = _arg_4;
            if (_arg_5 != null)
            {
                this._includeInfo = true;
                this._infoText = _arg_5;
                this._input.text = _arg_5;
            }
            Util._Str_6937(this._input, this.onInputClick);
            this._input.addEventListener(WindowKeyboardEvent.WINDOW_EVENT_KEY_DOWN, this.checkEnterPress);
            this._input.addEventListener(WindowEvent.WINDOW_EVENT_CHANGE, this.checkMaxLen);
            this._orgTextBackground = this._input.textBackground;
            this._orgTextBackgroundColor = this._input.textBackgroundColor;
        }

        public function dispose()
        {
            if (this._input != null)
            {
                this._input.dispose();
                this._input = null;
            }
            if (this._errorPopup != null)
            {
                this._errorPopup.dispose();
                this._errorPopup = null;
            }
            this._navigator = null;
        }

        public function checkMandatory(k:String):Bool
        {
            if (!this.isInputValid())
            {
                this.displayError(k);
                return false;
            }
            this.restoreBackground();
            return true;
        }

        public function restoreBackground()
        {
            this._input.textBackground = this._orgTextBackground;
            this._input.textBackgroundColor = this._orgTextBackgroundColor;
        }

        public function displayError(k:String)
        {
            this._input.textBackground = true;
            this._input.textBackgroundColor = 0xFFF18F9B;
            if (this._errorPopup == null)
            {
                this._errorPopup = cast(this._navigator.getXmlWindow("nav_error_popup"), IWindowContainer);
                this._navigator.refreshButton(this._errorPopup, "popup_arrow_down", true, null, 0);
                cast(this._input.parent, IWindowContainer).addChild(this._errorPopup);
            }
            var _local_2= cast(this._errorPopup.findChildByName("error_text"), ITextWindow);
            _local_2.text = k;
            _local_2.width = Std.int(_local_2.textWidth + 5);
            this._errorPopup.findChildByName("border").width = (_local_2.width + 15);
            this._errorPopup.width = (_local_2.width + 15);
            var _local_3= new Point();
            this._input.getLocalPosition(_local_3);
            this._errorPopup.x = Std.int(_local_3.x);
            this._errorPopup.y = Std.int((_local_3.y - this._errorPopup.height) + 3);
            var _local_4= this._errorPopup.findChildByName("popup_arrow_down");
            _local_4.x = Std.int((this._errorPopup.width / 2) - (_local_4.width / 2));
            this._errorPopup.x = Std.int(this._errorPopup.x + ((this._input.width - this._errorPopup.width) / 2));
            this._errorPopup.visible = true;
        }

        public function goBackToInitialState()
        {
            this.clearErrors();
            if (this._infoText != null)
            {
                this._input.text = this._infoText;
                this._includeInfo = true;
            }
            else
            {
                this._input.text = "";
                this._includeInfo = false;
            }
        }

        public function getText():String
        {
            if (this._includeInfo)
            {
                return this._invalidText;
            }
            return this._input.text;
        }

        public function setText(k:String)
        {
            this._includeInfo = false;
            this._input.text = k;
        }

        public function clearErrors()
        {
            this.restoreBackground();
            if (this._errorPopup != null)
            {
                this._errorPopup.visible = false;
            }
        }

        public var input(get,never):ITextFieldWindow;
public function  get_input():ITextFieldWindow
        {
            return this._input;
        }

        function isInputValid():Bool
        {
            return (!this._includeInfo) && (Util.trim(this.getText()).length > 2);
        }

        function onInputClick(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowEvent.WINDOW_EVENT_FOCUSED)
            {
                return;
            }
            if (!this._includeInfo)
            {
                return;
            }
            this._input.text = this._invalidText;
            this._includeInfo = false;
            this.restoreBackground();
        }

        function checkEnterPress(k:WindowKeyboardEvent)
        {
            if (k.charCode == Keyboard.ENTER)
            {
                if (this._onEnter != null)
                {
                    this._onEnter();
                }
            }
        }

        function checkMaxLen(k:WindowEvent)
        {
            var _local_2= this._input.text;
            if (_local_2.length > this._maxTextLen)
            {
                this._input.text = _local_2.substring(0, this._maxTextLen);
            }
        }
    }

