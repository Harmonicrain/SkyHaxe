package com.sulake.habbo.toolbar.memenu.chatsettings
;
    import com.sulake.habbo.toolbar.memenu.MeMenuSettingsMenuView;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.toolbar.ToolbarView;
    import com.sulake.core.window.components.ICheckBoxWindow;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowMouseEvent;

     class MeMenuChatSettingsView 
    {
        var _widget:MeMenuSettingsMenuView;
        var _window:IWindowContainer;
        var _toolbarView:ToolbarView;


        public function init(k:MeMenuSettingsMenuView, _arg_2:ToolbarView)
        {
            this._widget = k;
            this._toolbarView = _arg_2;
            this.createWindow();
        }

        public function dispose()
        {
            if (this._window == null)
            {
                return;
            }
            var k= Std.downcast(this._window.findChildByName("prefer_old_chat_checkbox") , ICheckBoxWindow);
            this._widget.window.visible = true;
            this._widget.widget.toolbar.freeFlowChat.isDisabledInPreferences = ((!(k == null)) && k.Selected);
            this._window.dispose();
            this._window = null;
            this._widget = null;
        }

        function createWindow()
        {
            var k= Std.downcast(this._widget.widget.toolbar.assets.getAssetByName("me_menu_chat_settings_xml") , XmlAsset);
            this._window = Std.downcast(this._widget.widget.toolbar.windowManager.buildFromXML(((k.content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            this._window.x = (this._toolbarView.window.width + 10);
            this._window.y = (this._toolbarView.window.bottom - this._window.height);
            this._widget.window.visible = false;
            var _local_2 = 0;
            var _local_3:IWindow = null;
            while (_local_2 < this._window.numChildren)
            {
                _local_3 = this._window.getChildAt(_local_2);
                _local_3.addEventListener(WindowMouseEvent.CLICK, this.onButtonClicked);
                _local_2++;
            }
            cast(this._window.findChildByName("prefer_old_chat_checkbox"), ICheckBoxWindow).Selected = this._widget.widget.toolbar.freeFlowChat.isDisabledInPreferences;
        }

        function onButtonClicked(k:WindowMouseEvent)
        {
            var _local_2= k.target ;
            var _local_3= _local_2.name;
            switch (_local_3)
            {
                case "back_btn":
                    this.dispose();
                    return;
                case "prefer_old_chat_checkbox":
                    this._widget.widget.toolbar.freeFlowChat.isDisabledInPreferences = cast(this._window.findChildByName("prefer_old_chat_checkbox"), ICheckBoxWindow).Selected;
                    if (!this._widget.widget.toolbar.freeFlowChat.isDisabledInPreferences)
                    {
                        if (this._widget.widget.toolbar._Str_12052.chatContainer != null)
                        {
                            this._widget.widget.toolbar._Str_12052.chatContainer.setDisplayObject(this._widget.widget.toolbar.freeFlowChat.displayObject);
                        }
                    }
                    else
                    {
                        this._widget.widget.toolbar.freeFlowChat.clear();
                    }
                    return;
            }
        }

        public var window(get,never):IWindowContainer;
public function  get_window():IWindowContainer
        {
            return this._window;
        }
public function new(){}
    }

