package com.sulake.habbo.groups
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.outgoing.users.GetHabboGroupDetailsMessageComposer;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class GroupCreatedWindowCtrl implements IDisposable 
    {
        var _manager:HabboGroupsManager;
        var _window:IFrameWindow;
        var _groupId:Int = 0;

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

        public function show(k:Int)
        {
            this._groupId = k;
            this.prepareWindow();
            this._window.visible = true;
            this._window.activate();
        }

        function prepareWindow()
        {
            if (this._window != null)
            {
                return;
            }
            this._window = cast(this._manager.getXmlWindow("group_created_window"), IFrameWindow);
            this._window.findChildByTag("close").procedure = this.onClose;
            this._window.findChildByName("ok_button").procedure = this.onClose;
            this._window.center();
        }

        function onClose(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                this.close();
                this._manager.send(new GetHabboGroupDetailsMessageComposer(this._groupId, false));
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

