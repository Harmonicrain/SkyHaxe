package com.sulake.habbo.window.utils
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.ITextLinkWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.habbo.window.HabboWindowManagerComponent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.utils.HabboWebTools;

     class SimpleAlertDialog implements IDisposable
    {
        static inline final _Str_4658= 10;

        var _disposed:Bool = false;
        var _dialog:IModalDialog;
        var _Str_577:String;
        var _window:IWindowContainer;
        var _list:IItemListWindow;
        var _Str_7458:IItemListWindow;
        var _Str_13821:IItemListWindow;
        var _Str_18789:IWindow;
        var _Str_10246:IWindow;
        var _Str_1676:ITextLinkWindow;
        var _Str_5447:IStaticBitmapWrapperWindow;
        var _Str_13273:ASFunction;
        var _Str_15643:ASFunction;
        var _habboWindowManagerComponent:HabboWindowManagerComponent;

        public function new(k:HabboWindowManagerComponent, _arg_2:String, _arg_3:String, _arg_4:String, _arg_5:String, _arg_6:String, _arg_7:Map, _arg_8:String, _arg_9:ASFunction, _arg_10:ASFunction)
        {
var _local_14:String  = null;            var _local_12:String = null;
            var _local_13:String = null;
            var _local_14:String = null;
            this._Str_13273 = _arg_9;
            this._Str_15643 = _arg_10;
            this._habboWindowManagerComponent = k;
            var _local_11= k.assets.getAssetByName("simple_alert_xml");
            this._dialog = k.buildModalDialogFromXML(((_local_11.content : com.sulake.core.utils.xml.XML) ));
            this._window = cast(this._dialog.rootWindow, IWindowContainer);
            this._list = cast(this._window.findChildByName("list"), IItemListWindow);
            this._Str_7458 = cast(this._window.findChildByName("list_top"), IItemListWindow);
            this._Str_13821 = cast(this._window.findChildByName("list_bottom"), IItemListWindow);
            this._Str_18789 = this._window.findChildByName("message");
            this._Str_10246 = this._window.findChildByName("subtitle");
            this._Str_1676 = cast(this._window.findChildByName("link"), ITextLinkWindow);
            this._Str_5447 = cast(this._window.findChildByName("illustration"), IStaticBitmapWrapperWindow);
            this._window.findChildByName("header_button_close").dispose();
            this._window.procedure = this.windowProcedure;
            this._window.caption = _arg_2;
            this._Str_18789.caption = _arg_4;
            if (_arg_7 != null)
            {
                final _iter_:Array<ASAny> = ([_arg_2, _arg_3, _arg_4, _arg_5] : Array<Dynamic>); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_12  = _tmp_;
                    if ((((!(_local_12 == null)) && (_local_12.substr(0, 2) == "${")) && (_local_12.indexOf("}") > 0)))
                    {
                        _local_13 = _local_12.substring(2, _local_12.indexOf("}"));
                        if (checkNullIteratee(_arg_7)) for (_tmp_ in _arg_7.getKeys())
                        {
_local_14 = _tmp_;
                            k.localization.registerParameter(_local_13, _local_14, _arg_7.getValue(_local_14));
                        }
                    }
                }
            }
            if (((!(_arg_3 == null)) && (!(_arg_3 == ""))))
            {
                this._Str_10246.caption = _arg_3;
            }
            else
            {
                this._Str_10246.dispose();
                this._Str_10246 = null;
            }
            _arg_6 = k.interpolate(_arg_6);
            if ((((!(_arg_5 == null)) && (!(_arg_5 == ""))) && (((!(_arg_6 == null)) && (!(_arg_6 == ""))) || (!(_arg_9 == null)))))
            {
                this._Str_1676.caption = _arg_5;
                this._Str_1676.addEventListener(WindowMouseEvent.CLICK, this._Str_19927);
                this._Str_1676.immediateClickMode = true;
                this._Str_577 = _arg_6;
            }
            else
            {
                this._Str_1676.dispose();
                this._Str_1676 = null;
            }
            if (((!(_arg_8 == null)) && (!(_arg_8 == ""))))
            {
                this._Str_5447.addEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this._Str_19872);
                this._Str_5447.assetUri = _arg_8;
            }
            else
            {
                this._Str_5447.dispose();
                this._Str_5447 = null;
            }
            this.resizeWindow();
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                this.close();
                this._habboWindowManagerComponent = null;
                this._disposed = true;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        function close()
        {
            if (this._Str_15643 != null)
            {
                this._Str_15643();
            }
            if (this._dialog != null)
            {
                if (this._Str_1676 != null)
                {
                    this._Str_1676.removeEventListener(WindowMouseEvent.CLICK, this._Str_19927);
                    this._Str_1676 = null;
                }
                if (this._Str_5447 != null)
                {
                    this._Str_5447.removeEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this._Str_19872);
                    this._Str_5447 = null;
                }
                this._window = null;
                this._list = null;
                this._Str_7458 = null;
                this._Str_13821 = null;
                this._Str_18789 = null;
                this._Str_10246 = null;
                this._Str_13273 = null;
                this._Str_15643 = null;
                this._dialog.dispose();
                this._dialog = null;
            }
        }

        function windowProcedure(k:WindowEvent, _arg_2:IWindow)
        {
            if (((k.type == WindowMouseEvent.CLICK) && (_arg_2.name == "close_button")))
            {
                this.dispose();
            }
        }

        function _Str_19927(k:WindowMouseEvent)
        {
            if (((!(this._Str_577 == null)) && (this._Str_577.length > 0)))
            {
                if (this._Str_577.substr(0, 6) == "event:")
                {
                    this._habboWindowManagerComponent.context.createLinkEvent(this._Str_577.substr(6));
                    this.dispose();
                }
                else
                {
                    HabboWebTools.openWebPage(this._Str_577, "habboMain");
                }
            }
            else
            {
                if (this._Str_13273 != null)
                {
                    this._Str_13273();
                    this.dispose();
                }
            }
        }

        function _Str_19872(k:WindowEvent)
        {
            this._Str_7458.x = (this._Str_5447.width + _Str_4658);
            this._Str_13821.width = this._Str_7458.right;
            this._window.width = (this._Str_7458.right + (2 * _Str_4658));
            this._Str_7458.limits.minHeight = (this._Str_5447.height + _Str_4658);
            this.resizeWindow();
        }

        function resizeWindow()
        {
            this._Str_7458.arrangeListItems();
            this._Str_13821.arrangeListItems();
            this._list.arrangeListItems();
            this._window.height = (this._list.height + 40);
            this._window.center();
        }
    }

