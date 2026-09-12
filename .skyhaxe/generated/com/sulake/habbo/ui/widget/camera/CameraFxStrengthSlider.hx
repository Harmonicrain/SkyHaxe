package com.sulake.habbo.ui.widget.camera
;
    import com.sulake.core.window.IWindowContainer;
    import flash.display.BitmapData;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.components.IRegionWindow;
    import flash.geom.Point;
    import com.sulake.core.assets.BitmapDataAsset;

     class CameraFxStrengthSlider 
    {
        var _view:CameraPhotoLab;
        var _sliderContainer:IWindowContainer;
        var _sliderBase:BitmapData;
        var _sliderButton:BitmapData;
        var _activeBaseArea:IBitmapWrapperWindow;
        var _sliderBaseWidth:Int = 0;
        var _referenceWidth:Int = 0;
        var _referenceX:Int = 0;

        public function new(k:CameraPhotoLab, _arg_2:IWindowContainer, _arg_3:IAssetLibrary)
        {
            this._view = k;
            this._sliderContainer = _arg_2;
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

        public function disable()
        {
            this._sliderContainer.visible = false;
        }

        public function enable()
        {
            this._sliderContainer.visible = true;
        }

        public function scale():Int
        {
            return this._referenceWidth;
        }

        public function setValue(k:Int)
        {
            var _local_2:IWindow = null;
            if (this._sliderContainer != null)
            {
                _local_2 = this._sliderContainer.findChildByName("slider_button");
                if (_local_2 != null)
                {
                    _local_2.x = k;
                }
            }
        }

        function _Str_5862(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowEvent.WINDOW_EVENT_RELOCATED)
            {
                if (this._activeBaseArea != null)
                {
                    this._activeBaseArea.width = Std.int((_arg_2.x / this._referenceWidth) * this._sliderBaseWidth);
                }
            }
            else
            {
                if (((k.type == WindowMouseEvent.UP) || (k.type == WindowMouseEvent.UP_OUTSIDE)))
                {
                    this._view._Str_21214(_arg_2.x);
                }
            }
        }

        function _Str_22757(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3 = 0;
            if (((k.type == WindowMouseEvent.DOWN) && (_arg_2.name == "shaft_click_area")))
            {
                _local_3 = Std.int(cast(k, WindowMouseEvent).localX - this._referenceX);
                this.setValue(_local_3);
                this._view._Str_21214(_local_3);
            }
        }

        function _Str_4995()
        {
            var k:IWindowContainer = null;
            var _local_2:IBitmapWrapperWindow = null;
            if (this._sliderContainer == null)
            {
                return;
            }
            var _local_3= Std.downcast(this._sliderContainer.findChildByName("shaft_click_area") , IRegionWindow);
            if (_local_3 != null)
            {
                _local_3.procedure = this._Str_22757;
            }
            _local_2 = Std.downcast(this._sliderContainer.findChildByName("slider_base") , IBitmapWrapperWindow);
            if (((!(_local_2 == null)) && (!(this._sliderBase == null))))
            {
                this._sliderBaseWidth = _local_2.width;
                _local_2.bitmap = new BitmapData(this._sliderBase.width, this._sliderBase.height, true, 0xFFFFFF);
                _local_2.bitmap.copyPixels(this._sliderBase, this._sliderBase.rect, new Point(0, 0), null, null, true);
                this._activeBaseArea = _local_2;
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
                    this._referenceX = Std.int((this._sliderBaseWidth - this._referenceWidth) / 2);
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
            _local_2 = cast(k.getAssetByName("camera_fx_slider_bottom_active"), BitmapDataAsset);
            this._sliderBase = cast(_local_2.content, BitmapData);
            _local_2 = cast(k.getAssetByName("camera_fx_slider_button"), BitmapDataAsset);
            this._sliderButton = cast(_local_2.content, BitmapData);
        }
    }


