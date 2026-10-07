package com.sulake.habbo.ui.widget.memenu.chatsettings
;
    import com.sulake.habbo.ui.widget.memenu.IMeMenuView;
    import com.sulake.habbo.ui.widget.memenu.MeMenuWidget;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetStoreSettingsMessage;
    import com.sulake.core.window.components.ICheckBoxWindow;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowMouseEvent;

     class MeMenuChatSettingsView implements IMeMenuView 
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
            var k= new RoomWidgetStoreSettingsMessage(RoomWidgetStoreSettingsMessage.RWSSM_STORE_CHAT);
            var _local_2= Std.downcast(this._window.findChildByName("prefer_old_chat_checkbox") , ICheckBoxWindow);
            k._Str_12967 = ((!(_local_2 == null)) && _local_2.Selected);
            this._widget.messageListener.processWidgetMessage(k);
            this._window.dispose();
            this._window = null;
            this._widget = null;
        }

        function createWindow(k:String)
        {
            var _local_2= Std.downcast(this._widget.assets.getAssetByName("memenu_chat_settings") , XmlAsset);
            if (_local_2 != null)
            {
                this._window = Std.downcast(this._widget.windowManager.buildFromXML(((_local_2.content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            }
            if (this._window == null)
            {
                throw new ASError("Failed to construct sound settings window from XML!");
            }
            this._window.name = k;
            var _local_3 = 0;
            var _local_4:IWindow = null;
            while (_local_3 < this._window.numChildren)
            {
                _local_4 = this._window.getChildAt(_local_3);
                _local_4.addEventListener(WindowMouseEvent.CLICK, this.onButtonClicked);
                _local_3++;
            }
            cast(this._window.findChildByName("prefer_old_chat_checkbox"), ICheckBoxWindow).Selected = this._widget.handler.container.freeFlowChat.isDisabledInPreferences;
        }

        function onButtonClicked(k:WindowMouseEvent)
        {
            var _local_2= k.target ;
            var _local_3= _local_2.name;
            switch (_local_3)
            {
                case "back_btn":
                    this._widget._Str_4568(MeMenuWidget.ME_MENU_SETTINGS_VIEW);
                    return;
            }
        }

        public var window(get,never):IWindowContainer;
public function  get_window():IWindowContainer
        {
            return this._window;
        }

        public function _Str_6111(k:String, _arg_2:Int)
        {
        }
public function new(){}
    }

