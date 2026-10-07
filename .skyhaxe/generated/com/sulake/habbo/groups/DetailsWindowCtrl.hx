package com.sulake.habbo.groups
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.communication.messages.incoming.users.HabboGroupDetailsData;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class DetailsWindowCtrl implements IDisposable 
    {
        var _manager:HabboGroupsManager;
        var _window:IFrameWindow;
        var _groupDetailsCtrl:GroupDetailsCtrl;
        var _groupId:Int = 0;

        public function new(k:HabboGroupsManager)
        {
            this._manager = k;
            this._groupDetailsCtrl = new GroupDetailsCtrl(k, true);
        }

        public function dispose()
        {
            this._manager = null;
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            if (this._groupDetailsCtrl != null)
            {
                this._groupDetailsCtrl.dispose();
                this._groupDetailsCtrl = null;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._manager == null;
        }

        public function _Str_18808(k:Int):Bool
        {
            return ((!(this._window == null)) && this._window.visible) && (k == this._groupId);
        }

        public function onGroupDetails(k:HabboGroupDetailsData)
        {
            if (((((!(this._window == null)) && this._window.visible) && (k.groupId == this._groupId)) || k._Str_8199))
            {
                this._groupId = k.groupId;
                this.prepareWindow();
                this._groupDetailsCtrl.onGroupDetails(cast(this._window.findChildByName("group_cont"), IWindowContainer), k);
                if (k._Str_8199)
                {
                    this._window.visible = true;
                    this._window.activate();
                }
            }
        }

        function prepareWindow()
        {
            if (this._window != null)
            {
                return;
            }
            this._window = cast(this._manager.getXmlWindow("group_info_window"), IFrameWindow);
            this._window.findChildByTag("close").procedure = this.onClose;
            this._window.center();
        }

        function onClose(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this.close();
        }

        public function close()
        {
            if (this._window != null)
            {
                this._groupId = 0;
                this._window.visible = false;
            }
        }

        public function onGroupDeactivated(k:Int)
        {
            if (this._groupId == k)
            {
                this.close();
            }
        }
    }

