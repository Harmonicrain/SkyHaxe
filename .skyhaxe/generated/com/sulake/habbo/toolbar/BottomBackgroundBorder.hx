package com.sulake.habbo.toolbar
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;
    import flash.geom.Point;

     class BottomBackgroundBorder implements IDisposable 
    {
        var _window:IWindowContainer;
        var _disposed:Bool = false;

        public function new(k:HabboToolbar)
        {
            this._window = Std.downcast(k.windowManager.buildFromXML(((k.assets.getAssetByName("bottom_background_border_xml").content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            this._window.procedure = this.onWindowEvent;
            this.updatePosition();
        }

        public function dispose()
        {
            if (this.disposed)
            {
                return;
            }
        }

        function onWindowEvent(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowEvent.WINDOW_EVENT_PARENT_RESIZED)
            {
                this.updatePosition();
            }
        }

        function updatePosition()
        {
            this._window.position = new Point(-10, (this._window.desktop.height - (this._window.height - 3)));
            this._window.width = (this._window.desktop.width + 20);
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }
    }

