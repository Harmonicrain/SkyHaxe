package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
;
    import com.sulake.core.runtime.exceptions.Exception;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.NumberInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class NumberInputPreset extends WiredUIPreset
    {
        var _inputView:IWindow;
        var _field:ITextFieldWindow;
        var _param:NumberInputParam;
        var _initialValue:Int = 0;
        var _currentValue:Int = 0;
        var _latestValidValueStr:String;
        var _min:Int = 0;
        var _max:Int = 0;
        var _precision:Int = 0;
        var _endsWithFive:Bool = false;
        var _fieldWidthDelta:Int = 0;
        var _onValueChange:ASFunction;
        var _ignoreListeners:Bool = false;

        public function new(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:NumberInputParam)
        {
            super(_arg_1, _arg_2, _arg_3);
            this._inputView = _arg_3.createTextInputView();
            this._field = Std.downcast(Std.downcast(this._inputView , IWindowContainer).findChildByName("field") , ITextFieldWindow);
            this._param = _arg_4;
            this._fieldWidthDelta = (this._inputView.width - this._field.width);
            if (_arg_4.width >= 0)
            {
                this._inputView.width = (_arg_4.width + this._fieldWidthDelta);
            }
            this._field.restrict = ("0123456789" + ((_arg_4.min < 0) ? "\\-" : "") + ((_arg_4.precision > 0) ? ",." : "") + (_arg_4.nonDecimalNotations ? "xba-fA-F" : ""));
            this._endsWithFive = _arg_4.endsWithFive;
            this._min = this._endsWithFive ? (_arg_4.min * 5) : _arg_4.min;
            this._max = this._endsWithFive ? (_arg_4.max * 5) : _arg_4.max;
            this._precision = _arg_4.precision;
            if (_arg_4.tooltip != null)
            {
                this._field.toolTipCaption = _arg_4.tooltip;
            }
            this.setValue(_arg_4.initialValue);
            this._field.addEventListener(WindowEvent.WINDOW_EVENT_CHANGE, this.onTextChange);
        }

        static function swapChars(_arg_1:String, _arg_2:Int, _arg_3:Int):String
        {
            var _local_5:Array<ASAny> = (cast _arg_1.split(""));
            var _local_4:String = _local_5[_arg_2];
            _local_5[_arg_2] = _local_5[_arg_3];
            _local_5[_arg_3] = _local_4;
            return _local_5.join("");
        }

        static function isValidInt(_arg_1:String):Bool
        {
            var _local_2= new compat.RegExp("^-?\\d+$");
            return _local_2.test(_arg_1);
        }

        public var onValueChange(never,set):ASFunction;
public function  set_onValueChange(_arg_1:ASFunction):ASFunction        {
            return this._onValueChange = _arg_1;
        }

        function displayValue(_arg_1:Int):String
        {
            var _local_3 = 0;
            var _local_2= Std.string(_arg_1);
            if (this._precision > 0)
            {
                while (_local_2.length < (this._precision + 1))
                {
                    _local_2 = ("0" + _local_2);
                }
                _local_2 = (_local_2.substring(0, (_local_2.length - this._precision)) + "." + _local_2.substring(_local_2.length - this._precision));
                while (_local_2.charAt(_local_2.length - 1) == "0")
                {
                    _local_2 = _local_2.substring(0, (_local_2.length - 1));
                }
                if (_local_2.charAt(_local_2.length - 1) == ".")
                {
                    _local_2 = _local_2.substring(0, (_local_2.length - 1));
                }
            }
            if (this._precision < 0)
            {
                _local_3 = 0;
                while (_local_3 > this._precision)
                {
                    _local_2 = (_local_2 + "0");
                    _local_3--;
                }
            }
            return _local_2;
        }

        function setValue(_arg_1:Int)
        {
            this._ignoreListeners = true;
            this._initialValue = _arg_1;
            this._currentValue = _arg_1;
            this._latestValidValueStr = this.displayValue(this._endsWithFive ? (_arg_1 * 5) : _arg_1);
            this._field.text = this._latestValidValueStr;
            this._ignoreListeners = false;
        }

        
        public var value(get,set):Int;
public function  set_value(_arg_1:Int):Int        {
            this.setValue(_arg_1);
return _arg_1;
        }

        public function reset()
        {
            this.setValue(this._param.initialValue);
        }

        function onTextChange(_arg_1:WindowEvent)
        {
            var _local_2 = 0;
            var _local_4:compat.RegExp = null;
            var _local_5 = 0;
            var _local_6 = 0;
            if (this._ignoreListeners)
            {
                return;
            }
            var _local_8= this._field.text;
            if ((_local_8 == "") || ((_local_8 == "-") && (this._param.min < 0)))
            {
                return;
            }
            var _local_3= _local_8.charAt(_local_8.length - 1);
            if ((this._precision == 0) && this._endsWithFive && (_local_3 != "0") && (_local_3 != "5"))
            {
                return;
            }
            if ((this._precision < 0) && (_local_3 == "0"))
            {
                return;
            }
            if (this._param.nonDecimalNotations && ((_local_8.indexOf("0b") == 0) || (_local_8.indexOf("0x") == 0)))
            {
                _local_2 = (_local_8.indexOf("0b") == 0) ? ASCompat.parseInt(_local_8.substr(2), 2) : ASCompat.parseInt(_local_8.substr(2), 16);
                this.setValidValueAndNotify((_local_2 < this._min) ? this._min : ((_local_2 > this._max) ? this._max : _local_2));
                return;
            }
            var _local_9= ASCompat.stringReplace(_local_8, ",", ".");
            if (this._precision > 0)
            {
                if (_local_9.charAt(_local_9.length - 1) == ".")
                {
                    _local_9 = _local_9.substring(0, (_local_9.length - 1));
                }
                _local_4 = new compat.RegExp("^-?([0-9]*[.])?[0-9]+$");
                if (!_local_4.test(_local_9))
                {
                    this._ignoreListeners = true;
                    this._field.text = this._latestValidValueStr;
                    this._ignoreListeners = false;
                    return;
                }
                _local_5 = 0;
                while (_local_5 < this._precision)
                {
                    _local_6 = _local_9.indexOf(".");
                    if (_local_6 == -1)
                    {
                        _local_9 = (_local_9 + "0");
                    }
                    else
                    {
                        _local_9 = swapChars(_local_9, _local_6, (_local_6 + 1));
                        if (_local_9.charAt(_local_9.length - 1) == ".")
                        {
                            _local_9 = _local_9.substring(0, (_local_9.length - 1));
                        }
                    }
                    _local_5++;
                }
            }
            else if (this._precision < 0)
            {
                _local_5 = 0;
                while (_local_5 > this._precision)
                {
                    if ((_local_9 == "0") || (_local_9 == "-0") || (_local_9 == ""))
                    {
                        break;
                    }
                    if (_local_9.charAt(_local_9.length - 1) == "0")
                    {
                        _local_9 = _local_9.substring(0, (_local_9.length - 1));
                    }
                    else
                    {
                        this._ignoreListeners = true;
                        this._field.text = this._latestValidValueStr;
                        this._ignoreListeners = false;
                    }
                    _local_5--;
                }
            }
            var _local_7= this._field;
            if (this._endsWithFive && (_local_9.charAt(_local_9.length - 1) != "0") && (_local_9.charAt(_local_9.length - 1) != "5"))
            {
                _local_7.text = this._latestValidValueStr;
                return;
            }
            _local_2 = ASCompat.toInt(_local_9);
            if ((!Math.isNaN(_local_2)) && isValidInt(_local_9))
            {
                if ((Std.string(_local_2).length <= Std.string(this._param.min).length) && (_local_2 < this._param.min) && (Std.string(this._param.max).length > Std.string(this._param.min).length))
                {
                    return;
                }
                if ((_local_2 >= this._min) && (_local_2 <= this._max))
                {
                    this._latestValidValueStr = _local_7.text;
                }
                else if (_local_2 < this._min)
                {
                    _local_2 = this._min;
                    this._latestValidValueStr = this.displayValue(this._min);
                    _local_7.text = this._latestValidValueStr;
                }
                else
                {
                    _local_2 = this._max;
                    this._latestValidValueStr = this.displayValue(this._max);
                    _local_7.text = this._latestValidValueStr;
                }
                this.setValidValueAndNotify(Std.int(this._endsWithFive ? Std.int(_local_2 / 5) : _local_2));
            }
            else
            {
                _local_7.text = this._latestValidValueStr;
            }
        }

        function setValidValueAndNotify(_arg_1:Int)
        {
            this._currentValue = _arg_1;
            if (this._onValueChange != null)
            {
                this._onValueChange(_arg_1);
            }
        }
public function  get_value():Int
        {
            return this._currentValue;
        }

        public var number(get,never):Float;
public function  get_number():Float
        {
            return ASCompat.toNumber(this._latestValidValueStr);
        }

        override public function hasStaticWidth():Bool
        {
            return this._param.width >= 0;
        }

        override public function  get_staticWidth():Int
        {
            if (this._param.width >= 0)
            {
                return (this._param.width + this._fieldWidthDelta);
            }
            throw new Exception("Number input with -1 width has no static width");
        }

        override public function resizeToWidth(_arg_1:Int)
        {
            super.resizeToWidth(_arg_1);
            var _local_2= (this._param.width >= 0) ? (this._param.width + this._fieldWidthDelta) : _arg_1;
            this._inputView.width = _local_2;
        }

        override public function  get_window():IWindow
        {
            return this._inputView;
        }

        override public function dispose()
        {
            if (disposed)
            {
                return;
            }
            super.dispose();
            this._inputView.dispose();
            this._inputView = null;
            this._param = null;
        }
    }

