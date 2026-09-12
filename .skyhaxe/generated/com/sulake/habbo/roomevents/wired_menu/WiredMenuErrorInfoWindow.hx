package com.sulake.habbo.roomevents.wired_menu
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;

    /**
     * July's monitor error detail popup. Known official error codes use the
     * July localization; local runtime diagnostics fall back to their bounded
     * name/category rather than exposing exception internals.
     */
     final class WiredMenuErrorInfoWindow implements IDisposable
    {
        var _roomEvents:HabboUserDefinedRoomEvents;
        var _window:IFrameWindow;
        var _disposed:Bool = false;

        public function new(
            roomEvents:HabboUserDefinedRoomEvents)
        {
            this._roomEvents = roomEvents;
        }

        public function show(error:ASObject)
        {
var key:String  = null;            if (error == null || this._disposed)
            {
                return;
            }
            this.ensureWindow();
            if (this._window == null)
            {
                return;
            }
            var name=
                Std.downcast(this._window.findChildByName("error_name") , ITextWindow);
            var text=
                Std.downcast(this._window.findChildByName("error_text") , ITextWindow);
            if (name != null)
            {
                name.text = ASCompat.toString(error.name);
            }
            if (text != null)
            {
key= "wiredmenu.error_info." + Std.string(ASCompat.toInt(error.id));
                text.text = this._roomEvents.localization.getLocalization(
                    key, ASCompat.toString(error.category) + ": " + ASCompat.toString(error.name));
            }
            if (this._window.parent == null)
            {
                this._roomEvents.windowManager.getDesktop(1)
                    .addChild(this._window);
            }
            this._window.center();
            this._window.activate();
        }

        public function hide()
        {
            if (this._window != null && this._window.parent != null)
            {
                Std.downcast(this._window.parent , IWindowContainer)
                    .removeChild(this._window);
            }
        }

        function ensureWindow()
        {
            if (this._window != null)
            {
                return;
            }
            this._window = Std.downcast(this._roomEvents.getXmlWindow(
                "wired_menu_error_info_view") , IFrameWindow);
            if (this._window == null)
            {
                return;
            }
            var close= this._window.findChildByTag("close");
            if (close != null)
            {
                close.addEventListener(
                    WindowMouseEvent.CLICK, this.onClose);
            }
        }

        function onClose(event:WindowMouseEvent)
        {
            this.hide();
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            this.hide();
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            this._roomEvents = null;
            this._disposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }
    }

