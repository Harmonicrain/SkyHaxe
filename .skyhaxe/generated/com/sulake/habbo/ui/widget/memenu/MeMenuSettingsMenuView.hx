package com.sulake.habbo.ui.widget.memenu
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.assets.XmlAsset;
    import flash.external.ExternalInterface;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.utils.HabboWebTools;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class MeMenuSettingsMenuView implements IMeMenuView 
    {
        var _widget:MeMenuWidget;
        var _window:IWindowContainer;


        public function init(k:MeMenuWidget, _arg_2:String)
        {
            this._widget = k;
            this.createWindow(_arg_2);
        }

        public function dispose()
        {
            this._widget = null;
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
        }

        public var window(get,never):IWindowContainer;
public function  get_window():IWindowContainer
        {
            return this._window;
        }

        function createWindow(k:String)
        {
            var _local_2= Std.downcast(this._widget.assets.getAssetByName("memenu_settings_menu") , XmlAsset);
            if (_local_2 != null)
            {
                this._window = Std.downcast(this._widget.windowManager.buildFromXML(((_local_2.content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            }
            if (this._window == null)
            {
                throw new ASError("Failed to construct settings window from XML!");
            }
            this._window.name = k;
            this._window.procedure = this.eventHandler;
            if (((!ExternalInterface.available) || (!(this._widget.config.getProperty("has.identity") == "1"))))
            {
                this._window.findChildByName("character_settings").disable();
            }
            else
            {
                this._window.findChildByName("identity_text").visible = false;
            }
            this._window.findChildByName("chat_settings").visible = true;
        }

        function eventHandler(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            switch (_arg_2.name)
            {
                case "character_settings":
                    HabboWebTools.openAvatars();
                    this._widget.hide();
                    return;
                case "sound_settings":
                    this._widget._Str_4568(MeMenuWidget.ME_MENU_SOUND_SETTINGS);
                    return;
                case "chat_settings":
                    this._widget._Str_4568(MeMenuWidget.ME_MENU_CHAT_SETTINGS);
                    return;
                case "back":
                    this._widget._Str_4568(MeMenuWidget.ME_MENU_TOP_VIEW);
                    return;
            }
        }

        public function _Str_6111(k:String, _arg_2:Int)
        {
        }
public function new(){}
    }

