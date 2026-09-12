package com.sulake.habbo.toolbar.extensions
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.toolbar.HabboToolbar;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.toolbar.ToolbarDisplayExtensionIds;
    import com.sulake.habbo.toolbar.ExtensionFixedSlotsEnum;
    import com.sulake.habbo.toolbar.extensions.settings.OtherSettingsView;
    import com.sulake.habbo.toolbar.extensions.settings.OtherSettingsView;
    import com.sulake.habbo.toolbar.extensions.settings.SoundSettingsView;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.utils.HabboWebTools;
    import com.sulake.core.window.events.WindowEvent;

     class SettingsExtension implements IDisposable 
    {
        static inline final _Str_2942= 3;
        static inline final _Str_5133= 7;

        var _toolbar:HabboToolbar;
        var _window:IWindowContainer;
        var _buttons:Vector<IWindow>;
        var _disposed:Bool = false;

        public function new(k:HabboToolbar)
        {
            this._buttons = new Vector<IWindow>();
            this._toolbar = k;
            this._window = Std.downcast(this._toolbar.windowManager.buildFromXML(((k.assets.getAssetByName("settings_xml").content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            this._window.procedure = this.windowProcedure;
            this._Str_16134("avatar_settings", this._toolbar.localization.getLocalization("widget.memenu.settings.character", "avatar settings"));
            this._Str_16134("sound", this._toolbar.localization.getLocalization("widget.memenu.settings.audio", "sound settings"));
            this._Str_16134("chat", this._toolbar.localization.getLocalization("widget.memenu.settings.other", "other settings"));
            k.extensionView.attachExtension(ToolbarDisplayExtensionIds.SETTINGS, this._window, ExtensionFixedSlotsEnum._Str_17467);
            this._window.visible = false;
        }

        public var window(get,never):IWindowContainer;
public function  get_window():IWindowContainer
        {
            return this._window;
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            this._toolbar = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        function _Str_16134(k:String, _arg_2:String)
        {
            var _local_3= Std.downcast(this._toolbar.windowManager.buildFromXML(((this._toolbar.assets.getAssetByName("setting_category_xml").content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            this._window.addChild(_local_3);
            _local_3.findChildByName("button_label").caption = _arg_2;
            if (this._buttons.length > 0)
            {
                _local_3.y = (this._buttons[(this._buttons.length - 1)].bottom + _Str_2942);
            }
            else
            {
                _local_3.y = _Str_5133;
            }
            _local_3.x = _Str_5133;
            _local_3.name = k;
            _local_3.procedure = this.windowProcedure;
            this._buttons.push(_local_3);
            this._window.height = (this._buttons[(this._buttons.length - 1)].bottom + _Str_5133);
        }

        function _Str_24026()
        {
            var k= new SoundSettingsView(this._toolbar);
            var _local_2:IWindowContainer = this._toolbar.windowManager.getDesktop(1);
            _local_2.addChild(k.window);
            k.window.x = ((_local_2.width - k.window.width) - 200);
        }

        function _Str_24638()
        {
            var k= new OtherSettingsView(this._toolbar);
            var _local_2:IWindowContainer = this._toolbar.windowManager.getDesktop(1);
            _local_2.addChild(k.window);
            k.window.x = ((_local_2.width - k.window.width) - 200);
        }

        function windowProcedure(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            switch (_arg_2.name)
            {
                case "avatar_settings":
                    HabboWebTools.openAvatars();
                    this._toolbar._Str_14261();
                    return;
                case "sound":
                    this._Str_24026();
                    this._toolbar._Str_14261();
                    return;
                case "chat":
                    this._Str_24638();
                    this._toolbar._Str_14261();
                    return;
            }
        }
    }

