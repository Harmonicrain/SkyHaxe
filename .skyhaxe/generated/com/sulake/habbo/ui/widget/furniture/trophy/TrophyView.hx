package com.sulake.habbo.ui.widget.furniture.trophy
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.assets.BitmapDataAsset;
    import flash.display.BitmapData;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.events.WindowMouseEvent;

     class TrophyView implements ITrophyView 
    {
        static final _Str_18501:Array<ASAny> = ["trophy_bg_gold", "trophy_bg_silver", "trophy_bg_bronze"];
        static final _Str_16117:Array<ASAny> = [4293707079, 4291411404, 4290279476];

        var _widget:ITrophyFurniWidget;
        var _window:IWindowContainer;

        public function new(k:ITrophyFurniWidget)
        {
            this._widget = k;
        }

        public function dispose()
        {
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            this._widget = null;
        }

        public function showInterface():Bool
        {
            var _local_3:IWindow = null;
            var _local_4:IWindowContainer = null;
            var _local_5:ITextWindow = null;
            var _local_6:ITextWindow = null;
            var _local_7:ITextWindow = null;
            var _local_8:BitmapDataAsset = null;
            var _local_9:BitmapData = null;
            var _local_10:IBitmapWrapperWindow = null;
            var k= this._widget.assets.getAssetByName("trophy");
            var _local_2= cast(k, XmlAsset);
            if (_local_2 == null)
            {
                return false;
            }
            if (this._window == null)
            {
                this._window = Std.downcast(this._widget.windowManager.buildFromXML(((_local_2.content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            }
            this._window.center();
            _local_3 = this._window.findChildByName("close");
            if (_local_3 != null)
            {
                _local_3.addEventListener(WindowMouseEvent.CLICK, this.onMouseEvent);
            }
            _local_4 = Std.downcast(this._window.findChildByName("title_bg") , IWindowContainer);
            if (_local_4 != null)
            {
                _local_4.color = ASCompat.toUInt(_Str_16117[this._widget.color]);
            }
            _local_5 = Std.downcast(this._window.findChildByName("greeting") , ITextWindow);
            if (_local_5 != null)
            {
                _local_5.text = new compat.RegExp("\\\\r", "g").replace(this._widget.message, "\n");
            }
            _local_6 = Std.downcast(this._window.findChildByName("date") , ITextWindow);
            if (_local_6 != null)
            {
                _local_6.text = this._widget.date;
            }
            _local_7 = Std.downcast(this._window.findChildByName("name") , ITextWindow);
            if (_local_7 != null)
            {
                _local_7.text = this._widget.name;
            }
            _local_8 = Std.downcast(this._widget.assets.getAssetByName(_Str_18501[this._widget.color]) , BitmapDataAsset);
            _local_10 = Std.downcast(this._window.findChildByName("trophy_bg") , IBitmapWrapperWindow);
            if (_local_8 != null)
            {
                _local_9 = ASCompat.dynamicAs(_local_8.content , BitmapData);
                _local_10.bitmap = _local_9;
            }
            return true;
        }

        public function _Str_7493()
        {
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
        }

        function onMouseEvent(k:WindowMouseEvent)
        {
            this._Str_7493();
        }
    }




