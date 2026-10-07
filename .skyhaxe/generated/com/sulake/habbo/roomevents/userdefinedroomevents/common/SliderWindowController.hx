package com.sulake.habbo.roomevents.userdefinedroomevents.common
;
    import com.sulake.core.runtime.events.EventDispatcherWrapper;
    import com.sulake.core.window.IWindowContainer;
    import flash.display.BitmapData;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.core.assets.IAssetLibrary;
    import flash.events.Event;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.components.IContainerButtonWindow;
    import flash.geom.Point;
    import com.sulake.core.assets.BitmapDataAsset;

     class SliderWindowController extends EventDispatcherWrapper 
    {
        var _currentValue:Float = 0;
        var _sliderContainer:IWindowContainer;
        var _sliderActive:Bool = false;
        var _sliderBase:BitmapData;
        var _sliderButton:BitmapData;
        var _referenceWidth:Int = 0;
        var _minValue:Float = 0;
        var _maxValue:Float = 1;
        var _snapInterval:Float = 0;

        public function new(k:HabboUserDefinedRoomEvents, _arg_2:IWindowContainer, _arg_3:IAssetLibrary, _arg_4:Float=0, _arg_5:Float=1, _arg_6:Float=0)
        {
            super();
            this._sliderContainer = cast(k.getXmlWindow("ude_slider"), IWindowContainer);
            _arg_2.addChild(this._sliderContainer);
            this._minValue = _arg_4;
            this._maxValue = _arg_5;
            this._snapInterval = _arg_6;
            this._currentValue = 0;
            this._Str_6048(_arg_3);
            this._Str_4995();
        }

        override public function dispose()
        {
            super.dispose();
            this._sliderContainer = null;
            this._sliderBase = null;
            this._sliderButton = null;
        }

        public function setValue(k:Float, _arg_2:Bool=true)
        {
            k = Math.max(this._minValue, k);
            k = Math.min(this._maxValue, k);
            this._currentValue = k;
            if (_arg_2)
            {
                this._Str_23202();
            }
            dispatchEvent(new Event(Event.CHANGE));
        }

        public function getValue():Float
        {
            return this._currentValue;
        }

        public var min(never,set):Float;
public function  set_min(k:Float):Float        {
            return this._minValue = k;
        }

        public var max(never,set):Float;
public function  set_max(k:Float):Float        {
            return this._maxValue = k;
        }

        function _Str_23202()
        {
            if (this._sliderContainer == null)
            {
                return;
            }
            var k= this._sliderContainer.findChildByName("slider_button");
            if (k != null)
            {
                k.x = this._Str_5687(this._currentValue);
            }
            k.parent.invalidate();
        }

        function _Str_5687(k:Float):Int
        {
            return Std.int((this._referenceWidth * ((k - this._minValue) / (this._maxValue - this._minValue))));
        }

        function _Str_23515(k:Float):Float
        {
            return ((k / this._referenceWidth) * (this._maxValue - this._minValue)) + this._minValue;
        }

        function _Str_22507(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3 = Math.NaN;
            var _local_4 = Math.NaN;
            if (k.type == WindowMouseEvent.DOWN)
            {
                this._sliderActive = true;
            }
            if (this._sliderActive)
            {
                if (((k.type == WindowMouseEvent.UP) || (k.type == WindowMouseEvent.UP_OUTSIDE)))
                {
                    this._sliderActive = false;
                }
            }
            if (((!this._sliderActive) || (!(k.type == WindowEvent.WINDOW_EVENT_RELOCATED))))
            {
                return;
            }
            if (this._snapInterval != 0)
            {
                _local_3 = this._Str_23515(_arg_2.x);
                _local_4 = (Math.fround((_local_3 / this._snapInterval)) * this._snapInterval);
                this.setValue(_local_4, false);
            }
        }

        function _Str_23487(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3 = Math.NaN;
            if (k.type == WindowMouseEvent.CLICK)
            {
                this._sliderActive = false;
                if (this._snapInterval != 0)
                {
                    _local_3 = (this._currentValue + this._snapInterval);
                    this.setValue(_local_3);
                }
            }
        }

        function _Str_24057(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3 = Math.NaN;
            if (k.type == WindowMouseEvent.CLICK)
            {
                this._sliderActive = false;
                if (this._snapInterval != 0)
                {
                    _local_3 = (this._currentValue - this._snapInterval);
                    this.setValue(_local_3);
                }
            }
        }

        function _Str_4995()
        {
            var k:IWindowContainer = null;
            var _local_2:IBitmapWrapperWindow = null;
            var _local_3:IContainerButtonWindow = null;
            var _local_4:IContainerButtonWindow = null;
            if (this._sliderContainer == null)
            {
                return;
            }
            _local_2 = Std.downcast(this._sliderContainer.findChildByName("slider_base") , IBitmapWrapperWindow);
            if (((!(_local_2 == null)) && (!(this._sliderBase == null))))
            {
                _local_2.bitmap = new BitmapData(this._sliderBase.width, this._sliderBase.height, true, 0xFFFFFF);
                _local_2.bitmap.copyPixels(this._sliderBase, this._sliderBase.rect, new Point(0, 0), null, null, true);
            }
            k = Std.downcast(this._sliderContainer.findChildByName("slider_movement_area") , IWindowContainer);
            if (k != null)
            {
                _local_2 = Std.downcast(k.findChildByName("slider_button") , IBitmapWrapperWindow);
                if (((!(_local_2 == null)) && (!(this._sliderButton == null))))
                {
                    _local_2.bitmap = new BitmapData(this._sliderButton.width, this._sliderButton.height, true, 0xFFFFFF);
                    _local_2.bitmap.copyPixels(this._sliderButton, this._sliderButton.rect, new Point(0, 0), null, null, true);
                    _local_2.procedure = this._Str_22507;
                    this._referenceWidth = (k.width - _local_2.width);
                }
            }
            _local_4 = Std.downcast(this._sliderContainer.findChildByName("slider_button_left") , IContainerButtonWindow);
            if (_local_4 != null)
            {
                _local_4.procedure = this._Str_24057;
            }
            _local_3 = Std.downcast(this._sliderContainer.findChildByName("slider_button_right") , IContainerButtonWindow);
            if (_local_3 != null)
            {
                _local_3.procedure = this._Str_23487;
            }
        }

        function _Str_6048(k:IAssetLibrary)
        {
            var _local_2:BitmapDataAsset = null;
            if (k == null)
            {
                return;
            }
            _local_2 = cast(k.getAssetByName("slider_bg_png"), BitmapDataAsset);
            this._sliderBase = cast(_local_2.content, BitmapData);
            _local_2 = cast(k.getAssetByName("slider_obj_png"), BitmapDataAsset);
            this._sliderButton = cast(_local_2.content, BitmapData);
        }
    }


