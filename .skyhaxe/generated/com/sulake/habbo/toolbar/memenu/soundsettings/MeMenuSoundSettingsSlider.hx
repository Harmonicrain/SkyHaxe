package com.sulake.habbo.toolbar.memenu.soundsettings
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowEvent;

     class MeMenuSoundSettingsSlider 
    {
        var _settingsItem:ASAny;
        var _sliderContainer:IWindowContainer;
        var _referenceWidth:Int = 0;
        var _minValue:Float = 0;
        var _maxValue:Float = 1;

        public function new(settingsItem:ASAny, _arg_2:IWindowContainer, _arg_3:IAssetLibrary, minValue:Float=0, maxValue:Float=1)
        {
            this._settingsItem = settingsItem;
            this._sliderContainer = _arg_2;
            this._minValue = minValue;
            this._maxValue = maxValue;
            this.displaySlider();
        }

        public function dispose()
        {
            this._settingsItem = null;
            this._sliderContainer = null;
        }

        public function setValue(value:Float)
        {
            if (this._sliderContainer == null)
            {
                return;
            }
            var sliderWindow= this._sliderContainer.findChildByName("slider_button");
            if (sliderWindow != null)
            {
                sliderWindow.x = this.getSliderPosition(value);
            }
        }

        function getSliderPosition(k:Float):Int
        {
            return Std.int((this._referenceWidth * ((k - this._minValue) / (this._maxValue - this._minValue))));
        }

        function getValue(index:Float):Float
        {
            return ((index / this._referenceWidth) * (this._maxValue - this._minValue)) + this._minValue;
        }

        function buttonProcedure(event:WindowEvent, window:IWindow)
        {
            if (event.type != WindowEvent.WINDOW_EVENT_RELOCATED)
            {
                return;
            }
            this._settingsItem.saveVolume(this.getValue(window.x), false);
        }

        function displaySlider()
        {
var sliderWindow:IWindowContainer  = null;            if (this._sliderContainer == null)
            {
                return;
            }
            var window= Std.downcast(this._sliderContainer.findChildByName("slider_movement_area") , IWindowContainer);
            if (window != null)
            {
sliderWindow= Std.downcast(window.findChildByName("slider_button") , IWindowContainer);
                if (sliderWindow != null)
                {
                    sliderWindow.procedure = this.buttonProcedure;
                    this._referenceWidth = (window.width - sliderWindow.width);
                }
            }
        }
    }

