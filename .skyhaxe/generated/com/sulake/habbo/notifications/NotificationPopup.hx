package com.sulake.habbo.notifications
;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class NotificationPopup 
    {
        static inline final _Str_24604= 20;

        var _window:IFrameWindow;
        var _localizationManager:IHabboLocalizationManager;
        var _Str_3834:Array<ASAny>;

        public function new(k:Array<ASAny>, _arg_2:IAssetLibrary, _arg_3:IHabboWindowManager)
        {
            var _local_8:String = null;
            var _local_9:IWindowContainer = null;
            var _local_10:ITextWindow = null;
            if (((!(_arg_3 != null)) || (!(_arg_2 != null))))
            {
                return;
            }
            this._Str_3834 = k;
            var _local_4= Std.downcast(_arg_2.getAssetByName("motd_notification_xml") , XmlAsset);
            if (_local_4 == null)
            {
                return;
            }
            this._window = Std.downcast(_arg_3.buildFromXML(((_local_4.content : com.sulake.core.utils.xml.XML) )) , IFrameWindow);
            if (this._window == null)
            {
                return;
            }
            this._window.procedure = this.eventHandler;
            this._window.center();
            var _local_5= Std.downcast(_arg_2.getAssetByName("motd_notification_item_xml") , XmlAsset);
            if (_local_5 == null)
            {
                return;
            }
            var _local_6= Std.downcast(_arg_3.buildFromXML(((_local_5.content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            var _local_7= Std.downcast(this._window.findChildByName("message_list") , IItemListWindow);
            final _iter_ = this._Str_3834; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_8  = _tmp_;
                _local_9 = Std.downcast(_local_6.clone() , IWindowContainer);
                _local_10 = Std.downcast(_local_9.findChildByName("message_text") , ITextWindow);
                _local_10.text = _local_8;
                _local_9.height = Std.int(_local_10.textHeight + NotificationPopup._Str_24604);
                _local_7.addListItem(_local_9);
            }
        }

        public function dispose()
        {
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            this._localizationManager = null;
        }

        function eventHandler(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            switch (_arg_2.name)
            {
                case "close"
                   | "header_button_close":
                    this.dispose();
                    return;
            }
        }
    }

