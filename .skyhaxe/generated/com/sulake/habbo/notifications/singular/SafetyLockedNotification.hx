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
    import com.sulake.core.runtime.Component;
    import com.sulake.habbo.utils.HabboWebTools;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class SafetyLockedNotification 
    {
        static inline final SAFETY_LOCKED_NOTIFICATION= "safety_locked_notification";
        static inline final _Str_4086:UInt = 0xFFFFFF;
        static inline final _Str_4030:UInt = 12247545;

        var _window:IBorderWindow;
        var _catalog:IHabboCatalog;
        var _toolbar:IHabboToolbar;
        var _linkText:ITextWindow;
        var _userId:Int = 0;

        public function new(k:Int, _arg_2:IAssetLibrary, _arg_3:IHabboWindowManager, _arg_4:IHabboCatalog, _arg_5:IHabboToolbar)
        {
            if ((((!(_arg_2 != null)) || (!(_arg_3 != null))) || (!(_arg_4 != null))))
            {
                return;
            }
            this._catalog = _arg_4;
            this._toolbar = _arg_5;
            this._userId = k;
            var _local_6= Std.downcast(_arg_2.getAssetByName("safety_locked_notification_xml") , XmlAsset);
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
            this._toolbar.extensionView.attachExtension(SAFETY_LOCKED_NOTIFICATION, this._window);
            this._linkText = Std.downcast(this._window.findChildByName("unlock_link") , ITextWindow);
            var _local_7= Std.downcast(this._window.findChildByName("unlock_link_region") , IRegionWindow);
            if (_local_7 != null)
            {
                _local_7.addEventListener(WindowMouseEvent.OVER, this.onMouseOver);
                _local_7.addEventListener(WindowMouseEvent.OUT, this.onMouseOut);
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
                this._toolbar.extensionView.detachExtension(SAFETY_LOCKED_NOTIFICATION);
            }
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            this._catalog = null;
        }

        function eventHandler(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3:String = null;
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            switch (_arg_2.name)
            {
                case "unlock_link_region"
                   | "unlock_link":
                    _local_3 = ASCompat.reinterpretAs(this._toolbar , Component).getProperty("link.format.safetylock_unlock");
                    HabboWebTools.openWebPage(_local_3, "habboMain");
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
    }

