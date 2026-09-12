package com.sulake.habbo.notifications.singular
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.window.utils.IModalDialog;
    import com.sulake.core.utils.Map;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.habbo.utils.HabboWebTools;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
	import com.sulake.habbo.notifications.HabboNotifications;

     class MOTDNotification implements IDisposable 
    {
        var _habboNotifications:HabboNotifications;
        var _dialog:IModalDialog;
        var _type:String;
        var _Str_4071:Map;

        public function new(k:HabboNotifications, _arg_2:String, _arg_3:Map)
        {
            var _local_11:IWindow = null;
            var _local_12:IWindow = null;
            this._habboNotifications = k;
            this._type = _arg_2;
            this._Str_4071 = _arg_3;
            var _local_4= this.getNotificationPart("title", true);
            var _local_5= new compat.RegExp("\\\\r", "g").replace(this.getNotificationPart("message", true), "\r");
            var _local_6= this.getNotificationPart("linkUrl", false);
            var _local_7:String = null;
            var _local_8= ((!(_local_6 == null)) && (_local_6.substr(0, 6) == "event:"));
            if (_local_6 != null)
            {
                _local_7 = this.getNotificationPart("linkTitle", false);
                if (_local_7 == null)
                {
                    _local_7 = _local_6;
                }
            }
            var _local_9= this._habboNotifications.assets.getAssetByName("layout_notification_popup_xml");
            this._dialog = this._habboNotifications.windowManager.buildModalDialogFromXML(((_local_9.content : com.sulake.core.utils.xml.XML) ));
            var _local_10= Std.downcast(this._dialog.rootWindow , IWindowContainer);
            _local_10.procedure = this.windowProcedure;
            _local_10.caption = _local_4;
            if (_local_6 != null)
            {
                if (_local_8)
                {
                    _local_11 = _local_10.findChildByName("action");
                    _local_11.visible = true;
                    _local_11.caption = _local_7;
                }
                else
                {
                    _local_12 = _local_10.findChildByName("link");
                    _local_12.visible = true;
                    _local_12.caption = _local_7;
                }
            }
            _local_10.findChildByName("message").caption = _local_5;
            cast(_local_10.findChildByName("illustration"), IStaticBitmapWrapperWindow).assetUri = this._habboNotifications.getNotificationImageUrl(_arg_3, _arg_2);
        }

        public function dispose()
        {
            if (this.disposed)
            {
                return;
            }
            this._dialog.dispose();
            this._dialog = null;
            this._habboNotifications = null;
            this._type = null;
            this._Str_4071 = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._dialog == null;
        }

        function windowProcedure(k:WindowEvent, _arg_2:IWindow)
        {
            if (this.disposed)
            {
                return;
            }
            switch (k.type)
            {
                case WindowMouseEvent.CLICK:
                    switch (_arg_2.name)
                    {
                        case "header_button_close":
                            this.dispose();
                            
                        case "action":
                            this._habboNotifications.createLinkEvent(this.getNotificationPart("linkUrl", false).substr(6));
                            this.dispose();
                            
                        case "link":
                            HabboWebTools.openWebPage(this.getNotificationPart("linkUrl", false), "habboMain");
                            
                    }
                    return;
                case WindowEvent.WINDOW_EVENT_RESIZED:
                    if (_arg_2.name == "illustration")
                    {
                        _arg_2.parent.limits.minHeight = _arg_2.height;
                    }
                    return;
            }
        }

        function getNotificationPart(k:String, _arg_2:Bool):String
        {
            return this._habboNotifications.getNotificationPart(this._Str_4071, this._type, k, _arg_2);
        }
    }

