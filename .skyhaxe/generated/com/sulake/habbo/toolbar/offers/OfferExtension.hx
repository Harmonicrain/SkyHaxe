package com.sulake.habbo.toolbar.offers
;
    import com.sulake.habbo.catalog.offers.IOfferExtension;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.toolbar.HabboToolbar;
    import com.sulake.habbo.catalog.offers.IOfferCenter;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.toolbar.ToolbarDisplayExtensionIds;
    import com.sulake.habbo.toolbar.ExtensionFixedSlotsEnum;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.catalog.IHabboCatalog;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class OfferExtension implements IOfferExtension implements  IDisposable 
    {
        var _disposed:Bool = false;
        var _window:IWindowContainer;
        var _toolbar:HabboToolbar;
        var _offerCenter:IOfferCenter;
        var _list:IItemListWindow;

        public function new(k:HabboToolbar, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary, _arg_4:IHabboCatalog)
        {
            this._toolbar = k;
            this._window = Std.downcast(_arg_2.buildFromXML(((_arg_3.getAssetByName("offer_extension_xml").content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            this._window.procedure = this.windowProcedure;
            this._window.visible = false;
            this._list = Std.downcast(this._window.findChildByName("list") , IItemListWindow);
            this._offerCenter = _arg_4.getOfferCenter(this);
            k.extensionView.attachExtension(ToolbarDisplayExtensionIds.VIDEO_OFFERS, this.window, ExtensionFixedSlotsEnum._Str_17982);
            this.refresh();
        }

        function windowProcedure(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            switch (_arg_2.name)
            {
                case "start_video":
                    this._offerCenter.showVideo();
                    return;
                case "check_rewards":
                    this._offerCenter._Str_19222();
                    return;
            }
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            this._list = null;
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            this._toolbar = null;
            this._disposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var window(get,never):IWindowContainer;
public function  get_window():IWindowContainer
        {
            return this._window;
        }

        public function _Str_18053()
        {
            if (this._window != null)
            {
                this._window.visible = true;
                this._window.findChildByName("check_rewards").visible = true;
                this.refresh();
            }
        }

        public function _Str_14237(k:Bool)
        {
            var _local_2:IWindow = null;
            if (this._window != null)
            {
                this._window.visible = (this._window.visible || k);
                _local_2 = this._window.findChildByName("start_video");
                _local_2.visible = k;
                if (this._offerCenter._Str_16243)
                {
                    _local_2.disable();
                    _local_2.color = 0x999999;
                }
                else
                {
                    _local_2.enable();
                    _local_2.color = 12932417;
                }
                this.refresh();
            }
        }

        function refresh()
        {
            this._list.arrangeListItems();
            this._window.visible = (this._list.getListItemAt(0).visible || this._list.getListItemAt(1).visible);
            this._toolbar.extensionView.refreshItemWindow();
        }
    }

