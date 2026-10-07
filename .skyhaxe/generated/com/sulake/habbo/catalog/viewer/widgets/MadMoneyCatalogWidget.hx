package com.sulake.habbo.catalog.viewer.widgets
;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.events.WindowMouseEvent;

     class MadMoneyCatalogWidget extends CatalogWidget
    {
        var _buyButton:IButtonWindow;

        public function new(k:IWindowContainer)
        {
            super(k);
        }

        override public function dispose()
        {
            super.dispose();
            if (this._buyButton != null)
            {
                this._buyButton.removeEventListener(WindowMouseEvent.CLICK, this._Str_5162);
                this._buyButton = null;
            }
        }

        override public function init():Bool
        {
            if (!super.init())
            {
                return false;
            }
            this._buyButton = Std.downcast(_window.findChildByName("ctlg_madmoney_button") , IButtonWindow);
            if (this._buyButton != null)
            {
            }
            return true;
        }

        function _Str_5162(event:WindowMouseEvent)
        {
            page.viewer.catalog.windowManager.alert("TODO", "Fix in MadMoneyCatalogWidget.as", 0, function (k:com.sulake.habbo.window.utils.IAlertDialog, _arg_2:com.sulake.core.window.events.WindowEvent)
            {
                k.dispose();
            });
        }
    }

