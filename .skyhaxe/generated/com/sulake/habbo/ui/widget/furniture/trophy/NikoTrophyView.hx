package com.sulake.habbo.ui.widget.furniture.trophy
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.ITextLinkWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.habbo.utils.HabboWebTools;

     class NikoTrophyView implements ITrophyView 
    {
        var _viewType:Int = 0;
        var _widget:TrophyFurniWidget;
        var _window:IWindowContainer;

        public function new(k:TrophyFurniWidget, _arg_2:Int)
        {
            this._widget = k;
            this._viewType = _arg_2;
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
            var _local_4:ITextWindow = null;
            var _local_5:ITextLinkWindow = null;
            var _local_6:ITextWindow = null;
            var _local_7:IStaticBitmapWrapperWindow = null;
            var _local_8:String = null;
            var k= this._widget.assets.getAssetByName("niko_trophy");
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
            _local_3 = this._window.findChildByName("header_button_close");
            if (_local_3 != null)
            {
                _local_3.addEventListener(WindowMouseEvent.CLICK, this._Str_25125);
            }
            _local_4 = Std.downcast(this._window.findChildByName("html_textbox") , ITextWindow);
            if (_local_4 != null)
            {
                switch (this._viewType)
                {
                    case TrophyFurniWidget._Str_10142:
                        _local_4.text = this._widget.localizations.getLocalization("niko.trophy.description.gold");
                        
                    case TrophyFurniWidget._Str_12649:
                        _local_4.text = this._widget.localizations.getLocalization("niko.trophy.description.silver");
                        
                }
            }
            _local_5 = Std.downcast(this._window.findChildByName("store_link") , ITextLinkWindow);
            if (_local_5 != null)
            {
                _local_5.addEventListener(WindowMouseEvent.CLICK, this._Str_20001);
            }
            _local_6 = Std.downcast(this._window.findChildByName("date") , ITextWindow);
            if (_local_6 != null)
            {
                this._widget.localizations.registerParameter("trophy.niko.date", "date", this._widget.date);
                _local_6.text = this._widget.localizations.getLocalization("trophy.niko.date");
            }
            _local_7 = Std.downcast(this._window.findChildByName("preview_image") , IStaticBitmapWrapperWindow);
            if (_local_7 != null)
            {
                if (this._viewType == TrophyFurniWidget._Str_10142)
                {
                    _local_7.assetUri = "${image.library.url}niko/niko_trophy_gold.png";
                }
                else
                {
                    _local_7.assetUri = "${image.library.url}niko/niko_trophy_silver.png";
                }
            }
            _local_7 = Std.downcast(this._window.findChildByName("store_image") , IStaticBitmapWrapperWindow);
            if (_local_7 != null)
            {
                _local_7.assetUri = (("${image.library.url}niko/" + this._widget.configuration.getProperty("niko.trophy.appstore.image")) + ".png");
            }
            var _local_9= Std.downcast(this._window.findChildByName("appstore_region") , IRegionWindow);
            if (_local_9 != null)
            {
                _local_9.addEventListener(WindowMouseEvent.CLICK, this._Str_20001);
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

        function _Str_20001(k:WindowMouseEvent)
        {
            var _local_2= this._widget.configuration.getProperty("niko.appstore.link.url");
            HabboWebTools.openWebPage(_local_2, "habboMain");
        }

        function _Str_25125(k:WindowMouseEvent)
        {
            this._Str_7493();
        }
    }

