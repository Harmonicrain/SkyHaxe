package com.sulake.habbo.roomevents.wired_setup.common
;
    import com.sulake.core.runtime.events.EventDispatcherWrapper;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import flash.events.Event;

    /**
     * Builder slider controller (May SliderWindowControllerNew). Drives the
     * slider_button child inside a style-provided slider container.
     */
     class SliderWindowControllerNew extends EventDispatcherWrapper
    {
        var _value:Float = 0;
        var _sliderContainer:IWindowContainer;
        var _dragging:Bool = false;
        var _min:Float = 0;
        var _max:Float = 1;
        var _step:Float = 0;

        public function new(_arg_1:IWindowContainer, _arg_2:Float = 0, _arg_3:Float = 1, _arg_4:Float = 0)
        {
            super();
            this._sliderContainer = _arg_1;
            this._min = _arg_2;
            this._max = _arg_3;
            this._step = _arg_4;
            this._value = 0;
            this.sliderButton.procedure = this.sliderProcedure;
        }

        override public function dispose()
        {
            super.dispose();
            this._sliderContainer.dispose();
            this._sliderContainer = null;
        }

        public function setValue(_arg_1:Float, _arg_2:Bool = true, _arg_3:Bool = true)
        {
            _arg_1 = Math.max(this._min, _arg_1);
            _arg_1 = Math.min(this._max, _arg_1);
            this._value = _arg_1;
            if (_arg_2)
            {
                this.updateSliderPosition();
            }
            if (_arg_3)
            {
                dispatchEvent(new Event(Event.CHANGE));
            }
        }

        public function getValue():Float
        {
            return this._value;
        }

        public var min(never,set):Float;
public function  set_min(_arg_1:Float):Float        {
            return this._min = _arg_1;
        }

        public var max(never,set):Float;
public function  set_max(_arg_1:Float):Float        {
            return this._max = _arg_1;
        }

        function updateSliderPosition()
        {
            if (this._sliderContainer == null)
            {
                return;
            }
            var _local_1= this._sliderContainer.findChildByName("slider_button");
            if (_local_1 != null)
            {
                _local_1.x = this.getSliderPosition(this._value);
                _local_1.parent.invalidate();
            }
        }

        function getSliderPosition(_arg_1:Float):Int
        {
            return Std.int(this.referenceWidth * ((_arg_1 - this._min) / (this._max - this._min)));
        }

        function getValueAtPosition(_arg_1:Float):Float
        {
            return (((_arg_1 / this.referenceWidth) * (this._max - this._min)) + this._min);
        }

        function sliderProcedure(_arg_1:WindowEvent, _arg_2:IWindow)
        {
            var _local_4 = Math.NaN;
            var _local_3 = Math.NaN;
            if (_arg_1.type == WindowMouseEvent.DOWN)
            {
                this._dragging = true;
            }
            if (this._dragging)
            {
                if ((_arg_1.type == WindowMouseEvent.UP) || (_arg_1.type == WindowMouseEvent.UP_OUTSIDE))
                {
                    this._dragging = false;
                }
            }
            if ((!this._dragging) || (_arg_1.type != WindowEvent.WINDOW_EVENT_RELOCATED))
            {
                return;
            }
            if (this._step != 0)
            {
                _local_4 = this.getValueAtPosition(_arg_2.x);
                _local_3 = (Math.fround(_local_4 / this._step) * this._step);
                this.setValue(_local_3, false);
            }
        }

        public function moveSliderToRight()
        {
            this._dragging = false;
            if (this._step != 0)
            {
                this.setValue(this._value + this._step);
            }
        }

        public function moveSliderToLeft()
        {
            this._dragging = false;
            if (this._step != 0)
            {
                this.setValue(this._value - this._step);
            }
        }

        var referenceWidth(get,never):Int;
function  get_referenceWidth():Int
        {
            return (this.sliderMovementArea.width - this.sliderButton.width);
        }

        var sliderBase(get,never):IStaticBitmapWrapperWindow;
function  get_sliderBase():IStaticBitmapWrapperWindow
        {
            return Std.downcast(this._sliderContainer.findChildByName("slider_base") , IStaticBitmapWrapperWindow);
        }

        var sliderMovementArea(get,never):IWindowContainer;
function  get_sliderMovementArea():IWindowContainer
        {
            return Std.downcast(this._sliderContainer.findChildByName("slider_movement_area") , IWindowContainer);
        }

        var sliderButton(get,never):IStaticBitmapWrapperWindow;
function  get_sliderButton():IStaticBitmapWrapperWindow
        {
            return Std.downcast(this._sliderContainer.findChildByName("slider_button") , IStaticBitmapWrapperWindow);
        }
    }

