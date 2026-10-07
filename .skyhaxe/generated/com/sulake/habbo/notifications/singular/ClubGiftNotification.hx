package com.sulake.habbo.notifications.singular
;
    import com.sulake.core.window.components.IBorderWindow;
    import com.sulake.habbo.catalog.IHabboCatalog;
    import com.sulake.habbo.toolbar.IHabboToolbar;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.display.BitmapData;
    import flash.geom.Matrix;
    import com.sulake.habbo.catalog._enum.CatalogPageName;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IIconWindow;

     class ClubGiftNotification 
    {
        static inline final CLUB_GIFT_NOTIFICATION= "club_gift_notification";
        static inline final _Str_4086:UInt = 0xFFFFFF;
        static inline final _Str_4030:UInt = 12247545;
        static inline final _Str_5044= 13;
        static inline final _Str_3830= 14;

        var _window:IBorderWindow;
        var _catalog:IHabboCatalog;
        var _toolbar:IHabboToolbar;
        var _linkText:ITextWindow;

        public function new(k:Int, _arg_2:IAssetLibrary, _arg_3:IHabboWindowManager, _arg_4:IHabboCatalog, _arg_5:IHabboToolbar)
        {
            if ((((!(_arg_2 != null)) || (!(_arg_3 != null))) || (!(_arg_4 != null))))
            {
                return;
            }
            this._catalog = _arg_4;
            this._toolbar = _arg_5;
            var _local_6= Std.downcast(_arg_2.getAssetByName("club_gift_notification_xml") , XmlAsset);
            if (_local_6 == null)
            {
                return;
            }
            this._window = Std.downcast(_arg_3.buildFromXML(((_local_6.content : com.sulake.core.utils.xml.XML) )) , IBorderWindow);
            if (this._window == null)
            {
                return;
            }
            this._window.procedure = this.eventHandler;
            this._toolbar.extensionView.attachExtension(CLUB_GIFT_NOTIFICATION, this._window);
            this._linkText = Std.downcast(this._window.findChildByName("cancel_link") , ITextWindow);
            var _local_7= Std.downcast(this._window.findChildByName("cancel_link_region") , IRegionWindow);
            if (_local_7 != null)
            {
                _local_7.addEventListener(WindowMouseEvent.OVER, this.onMouseOver);
                _local_7.addEventListener(WindowMouseEvent.OUT, this.onMouseOut);
            }
            if (this._catalog.getPurse().isVIP)
            {
                this._Str_5997(_Str_3830);
            }
            else
            {
                this._Str_5997(_Str_5044);
            }
        }

        public var visible(get,never):Bool;
public function  get_visible():Bool
        {
            return (this._window != null) && this._window.visible;
        }

        public function dispose()
        {
            if (this._toolbar != null)
            {
                this._toolbar.extensionView.detachExtension(CLUB_GIFT_NOTIFICATION);
            }
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            this._catalog = null;
        }

        function setImage(k:String, _arg_2:BitmapData)
        {
            if (this._window == null)
            {
                return;
            }
            var _local_3= Std.downcast(this._window.findChildByName(k) , IBitmapWrapperWindow);
            if (_local_3 == null)
            {
                return;
            }
            var _local_4= new BitmapData(_local_3.width, _local_3.height, true, 0);
            var _local_5= Std.int((_local_4.width * 0.5) - _arg_2.width);
            var _local_6= Std.int((_local_4.height * 0.5) - _arg_2.height);
            _local_4.draw(_arg_2, new Matrix(2, 0, 0, 2, _local_5, _local_6));
            _local_3.bitmap = _local_4;
        }

        function eventHandler(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            switch (_arg_2.name)
            {
                case "open_catalog_button":
                    if (this._catalog != null)
                    {
                        this._catalog.openCatalogPage(CatalogPageName.CLUB_GIFTS);
                    }
                    this.dispose();
                    return;
                case "cancel_link_region"
                   | "cancel_link":
                    this.dispose();
                    return;
            }
        }

        function onMouseOver(k:WindowMouseEvent)
        {
            this._linkText.textColor = _Str_4030;
        }

        function onMouseOut(k:WindowMouseEvent)
        {
            this._linkText.textColor = _Str_4086;
        }

        function _Str_5997(k:Int)
        {
            var _local_2:IIconWindow = null;
            if (this._window != null)
            {
                _local_2 = Std.downcast(this._window.findChildByName("club_icon") , IIconWindow);
                if (_local_2 != null)
                {
                    _local_2.style = k;
                    _local_2.invalidate();
                }
            }
        }
    }

