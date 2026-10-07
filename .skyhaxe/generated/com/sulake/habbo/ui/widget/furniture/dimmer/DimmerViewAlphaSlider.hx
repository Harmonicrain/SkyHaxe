package com.sulake.habbo.ui.widget.furniture.dimmer
;
    import com.sulake.core.window.IWindowContainer;
	import com.sulake.habbo.ui.widget.furniture.dimmer.DimmerView;
    import flash.display.BitmapData;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.geom.Point;
    import com.sulake.core.assets.BitmapDataAsset;

     class DimmerViewAlphaSlider 
    {
        var _view:DimmerView;
        var _sliderContainer:IWindowContainer;
        var _sliderBase:BitmapData;
        var _sliderButton:BitmapData;
        var _referenceWidth:Int = 0;
        var _referenceX:Int = 0;
        var _minValue:Int = 0;
        var _maxValue:Int = 0xFF;

        public function new(k:DimmerView, _arg_2:IWindowContainer, _arg_3:IAssetLibrary, _arg_4:Int=0, _arg_5:Int=0xFF)
        {
            this._view = k;
            this._sliderContainer = _arg_2;
            this._minValue = _arg_4;
            this._maxValue = _arg_5;
            this._Str_6048(_arg_3);
            this._Str_4995();
        }

        public function dispose()
        {
            this._view = null;
            this._sliderContainer = null;
            this._sliderBase = null;
            this._sliderButton = null;
        }

        public function setValue(k:Int)
        {
            if (this._sliderContainer == null)
            {
                return;
            }
            var _local_2= this._sliderContainer.findChildByName("slider_button");
            if (_local_2 != null)
            {
                _local_2.x = this._Str_5687(k);
            }
        }

        public var min(never,set):Float;
public function  set_min(k:Float):Float        {
            this._minValue = Std.int(k);
            this.setValue(this._view._Str_7404);
return k;
        }

        public var max(never,set):Float;
public function  set_max(k:Float):Float        {
            this._maxValue = Std.int(k);
            this.setValue(this._view._Str_7404);
return k;
        }

        function _Str_5687(k:Int):Int
        {
            return Std.int((this._referenceWidth * ((k - this._minValue) / (this._maxValue - this._minValue))));
        }

        function getValue(k:Float):Int
        {
            return Std.int(((k / this._referenceWidth) * (this._maxValue - this._minValue))) + this._minValue;
        }

        function _Str_5862(k:WindowEvent, _arg_2:IWindow)
        {
            if (((!(k.type == WindowMouseEvent.UP)) && (!(k.type == WindowMouseEvent.UP_OUTSIDE))))
            {
                return;
            }
            this._view._Str_7404 = this.getValue(_arg_2.x);
        }

        function _Str_4995()
        {
            var k:IWindowContainer = null;
            var _local_2:IBitmapWrapperWindow = null;
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
                    _local_2.procedure = this._Str_5862;
                    this._referenceWidth = (k.width - _local_2.width);
                }
            }
        }

        function _Str_6048(k:IAssetLibrary)
        {
            var _local_2:BitmapDataAsset = null;
            if (k == null)
            {
                return;
            }
            _local_2 = cast(k.getAssetByName("dimmer_slider_base"), BitmapDataAsset);
            this._sliderBase = cast(_local_2.content, BitmapData);
            _local_2 = cast(k.getAssetByName("dimmer_slider_button"), BitmapDataAsset);
            this._sliderButton = cast(_local_2.content, BitmapData);
        }
    }


