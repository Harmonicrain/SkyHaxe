package com.sulake.habbo.ui.widget.furniture.video
;
    import com.sulake.habbo.ui.widget.RoomWidgetBase;
    import com.vimeo.api.VimeoPlayer;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.ui.handler.FurnitureVimeoDisplayWidgetHandler;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IDisplayObjectWrapper;
    import flash.events.MouseEvent;
    import flash.display.DisplayObject;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowKeyboardEvent;

     class VimeoDisplayWidget extends RoomWidgetBase
    {
        static inline final _Str_16140= "9a106b76302cbce891b714afdc6a0c93";

        var _player:VimeoPlayer;
        var _window:IWindowContainer;
        var _roomObject:IRoomObject;

        public function new(k:IRoomWidgetHandler, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary, _arg_4:IHabboLocalizationManager)
        {
            super(k, _arg_2, _arg_3, _arg_4);
            this.ownHandler.widget = this;
        }

        var ownHandler(get,never):FurnitureVimeoDisplayWidgetHandler;
function  get_ownHandler():FurnitureVimeoDisplayWidgetHandler
        {
            return Std.downcast(_handler , FurnitureVimeoDisplayWidgetHandler);
        }

        override public function  get_mainWindow():IWindow
        {
            return this._window;
        }

        public function show(k:IRoomObject, _arg_2:Bool, _arg_3:Int)
        {
            this._roomObject = k;
            this.createWindow(_arg_2, _arg_3);
            this._window.visible = true;
        }

        function createWindow(k:Bool, _arg_2:Int)
        {
            if (this._window != null)
            {
                return;
            }
            this._window = Std.downcast(windowManager.buildFromXML(new com.sulake.core.utils.xml.XML(assets.getAssetByName("vimeo_viewer_xml").content)) , IWindowContainer);
            this._window.findChildByName("video_id_editor").visible = k;
            this._window.findChildByName("video_wrapper").visible = (_arg_2 > 0);
            this._window.procedure = this.windowProcedure;
            this._window.center();
            var _local_3= cast(this._window.findChildByName("video_wrapper"), IDisplayObjectWrapper);
            this._player = new VimeoPlayer(_Str_16140, _arg_2, _local_3.width, _local_3.height);
            _local_3.setDisplayObject(this._player);
            this._player.addEventListener(MouseEvent.MOUSE_UP, (this._Str_11921 : ASAny));
            this._player.addEventListener(MouseEvent.MOUSE_MOVE, (this._Str_11921 : ASAny));
        }

        function _Str_11921(k:MouseEvent)
        {
            if (this._window != null)
            {
                cast(k.target, DisplayObject).stage.dispatchEvent(k);
            }
        }

        function windowProcedure(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3 = 0;
            switch (k.type)
            {
                case WindowMouseEvent.CLICK:
                    switch (_arg_2.name)
                    {
                        case "header_button_close":
                            this.hide(this._roomObject);
                            
                    }
                    return;
                case WindowEvent.WINDOW_EVENT_RESIZE:
                    switch (_arg_2.name)
                    {
                        case "video_wrapper":
                            if (this._player != null)
                            {
                                this._player.setSize(_arg_2.width, _arg_2.height);
                            }
                            
                    }
                    return;
                case WindowKeyboardEvent.WINDOW_EVENT_KEY_DOWN:
                    if (cast(k, WindowKeyboardEvent).charCode == 13)
                    {
                        _local_3 = ASCompat.toInt(this._window.findChildByName("video_id").caption);
                        this.ownHandler._Str_18970(this._roomObject, _local_3);
                        this._window.findChildByName("video_wrapper").visible = (_local_3 > 0);
                        this._player.loadVideo(_local_3);
                    }
                    return;
            }
        }

        public function hide(k:IRoomObject)
        {
            if (this._roomObject != k)
            {
                return;
            }
            if (this._player != null)
            {
                this._player.destroy();
                this._player = null;
            }
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            this._roomObject = null;
        }
    }

