package com.sulake.habbo.notifications.singular
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.ICheckBoxWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.notifications.HabboNotifications;

     class DiscordActivityDialog implements IDisposable 
    {
        var _habboNotifications:HabboNotifications;
        var _window:IWindowContainer;

        public function new(notifications:HabboNotifications)
        {
            this._habboNotifications = notifications;

            var layoutAsset= this._habboNotifications.assets.getAssetByName("discord_activity_dialog_xml");
            if (layoutAsset == null) {
                Logger.log(["ERROR: Could not find asset discord_activity_dialog_xml"]);
                return;
            }
            this._window = Std.downcast(this._habboNotifications.windowManager.buildFromXML(((layoutAsset.content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            if (this._window == null)
            {
                Logger.log(["ERROR: Could not build discord activity window from XML"]);
                return;
            }
            this._window.procedure = this.windowProcedure;

            this.initCheckboxes();
            this._window.center();
        }

        function initCheckboxes()
        {
            this.setCheckboxSelected("show_habbo_cbx", true);
            this.setCheckboxSelected("share_activity_cbx", true);
            this.setCheckboxSelected("hide_in_hidden_cbx", true);
            this.setCheckboxSelected("allow_joining_cbx", true);
        }

        function setCheckboxSelected(name:String, selected:Bool)
        {
            var checkbox= this._window.findChildByName(name);
            if (checkbox != null && Std.is(checkbox , ICheckBoxWindow))
            {
                if (selected)
                {
                    cast(checkbox, ICheckBoxWindow).select();
                }
            }
        }

        function windowProcedure(event:WindowEvent, target:IWindow)
        {
            if (this.disposed)
            {
                return;
            }
            switch (event.type)
            {
                case WindowMouseEvent.CLICK:
                    switch (target.name)
                    {
                        case "header_button_close"
                           | "funny_button":
                            this.dispose();
                            
                    }
                    return;
            }
        }

        public function dispose()
        {
            if (this.disposed)
            {
                return;
            }
            this._window.dispose();
            this._window = null;
            this._habboNotifications = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._window == null;
        }
    }

