package com.sulake.habbo.catalog.club
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.catalog.HabboCatalog;

     class ClubBenefitsDialog implements IDisposable 
    {
        var _disposed:Bool = false;
        var _benefitsWindow:IWindowContainer;

        public function new(k:HabboCatalog)
        {
            this._benefitsWindow = Std.downcast(k.utils.createWindow("vip_benefits") , IWindowContainer);
            this._benefitsWindow.findChildByName("header_button_close").addEventListener(WindowMouseEvent.CLICK, this.onCloseHandler);
            this._benefitsWindow.center();
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                if (this._benefitsWindow != null)
                {
                    this._benefitsWindow.dispose();
                    this._benefitsWindow = null;
                }
            }
            this._disposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        function onCloseHandler(k:WindowMouseEvent)
        {
            this.dispose();
        }
    }

