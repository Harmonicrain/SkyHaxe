package com.sulake.habbo.ui.widget.furniture.backgroundcolor
;
    import com.sulake.core.window.IWindowContainer;
    import flash.display.BitmapData;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.geom.Point;

     class BackgroundColorWidgetSlider 
    {
        static inline final _Str_2809= 0;
        static inline final _Str_2856= 0xFF;

        var _widget:BackgroundColorFurniWidget;
        var _Str_2571:IWindowContainer;
        var _Str_4513:String;
        var _Str_2764:BitmapData;
        var _Str_2751:BitmapData;
        var _Str_3236:Int = 0;
        var _Str_12640:Int = 0;

        public function new(k:BackgroundColorFurniWidget, _arg_2:String, _arg_3:IWindowContainer, _arg_4:Int=0)
        {
            var _local_5:BitmapDataAsset = null;
            this._widget = k;
            this._Str_4513 = _arg_2;
            this._Str_2571 = _arg_3;
            _local_5 = cast(k.assets.getAssetByName("dimmer_slider_base"), BitmapDataAsset);
            this._Str_2764 = cast(_local_5.content, BitmapData);
            _local_5 = cast(k.assets.getAssetByName("dimmer_slider_button"), BitmapDataAsset);
            this._Str_2751 = cast(_local_5.content, BitmapData);
            this._Str_4995();
            this.setValue(_arg_4);
        }

        public function dispose()
        {
            this._widget = null;
            this._Str_2571 = null;
            this._Str_2764 = null;
            this._Str_2751 = null;
        }

        public function setValue(k:Int)
        {
            if (this._Str_2571 == null)
            {
                return;
            }
            var _local_2= this._Str_2571.findChildByName("slider_button");
            if (_local_2 != null)
            {
                _local_2.x = this._Str_5687(k);
            }
        }

        function _Str_5687(k:Int):Int
        {
            return Std.int((this._Str_3236 * ((k - _Str_2809) / (_Str_2856 - _Str_2809))));
        }

        function getValue(k:Float):Int
        {
            return Std.int(((k / this._Str_3236) * (_Str_2856 - _Str_2809))) + _Str_2809;
        }

        function _Str_5862(k:WindowEvent, _arg_2:IWindow)
        {
            this._widget._Str_25701(this._Str_4513, this.getValue(_arg_2.x));
        }

        function _Str_4995()
        {
            var k:IWindowContainer = null;
            var _local_2:IBitmapWrapperWindow = null;
            if (this._Str_2571 == null)
            {
                return;
            }
            _local_2 = Std.downcast(this._Str_2571.findChildByName("slider_base") , IBitmapWrapperWindow);
            if (((!(_local_2 == null)) && (!(this._Str_2764 == null))))
            {
                _local_2.bitmap = new BitmapData(this._Str_2764.width, this._Str_2764.height, true, 0xFFFFFF);
                _local_2.bitmap.copyPixels(this._Str_2764, this._Str_2764.rect, new Point(0, 0), null, null, true);
            }
            k = Std.downcast(this._Str_2571.findChildByName("slider_movement_area") , IWindowContainer);
            if (k != null)
            {
                _local_2 = Std.downcast(k.findChildByName("slider_button") , IBitmapWrapperWindow);
                if (((!(_local_2 == null)) && (!(this._Str_2751 == null))))
                {
                    _local_2.bitmap = new BitmapData(this._Str_2751.width, this._Str_2751.height, true, 0xFFFFFF);
                    _local_2.bitmap.copyPixels(this._Str_2751, this._Str_2751.rect, new Point(0, 0), null, null, true);
                    _local_2.procedure = this._Str_5862;
                    this._Str_3236 = (k.width - _local_2.width);
                }
            }
        }
    }


