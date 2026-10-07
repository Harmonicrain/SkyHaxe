package com.sulake.habbo.groups
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class HcRequiredWindowCtrl implements IDisposable 
    {
        var _manager:HabboGroupsManager;
        var _window:IFrameWindow;

        public function new(k:HabboGroupsManager)
        {
            this._manager = k;
        }

        public function dispose()
        {
            this._manager = null;
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._manager == null;
        }

        public function show(k:Bool)
        {
            this.prepareWindow();
            this._window.findChildByName("info_txt").caption = (k ? "${group.hcrequired.info.manage}" : "${group.hcrequired.info.join}");
            this._window.visible = true;
            this._window.activate();
        }

        function prepareWindow()
        {
            if (this._window != null)
            {
                return;
            }
            this._window = cast(this._manager.getXmlWindow("club_required"), IFrameWindow);
            this._window.findChildByTag("close").procedure = this.onClose;
            this._window.findChildByName("cancel_link_region").procedure = this.onClose;
            this._window.findChildByName("join_button").procedure = this._Str_19126;
            this._window.findChildByName("more_info_link_region").procedure = this._Str_19126;
            this._window.center();
        }

        function onClose(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                this.close();
            }
        }

        function _Str_19126(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                this._manager.openVipPurchase("HcRequiredWindowCtrl");
                this.close();
            }
        }

        public function close()
        {
            if (this._window != null)
            {
                this._window.visible = false;
            }
        }
    }

