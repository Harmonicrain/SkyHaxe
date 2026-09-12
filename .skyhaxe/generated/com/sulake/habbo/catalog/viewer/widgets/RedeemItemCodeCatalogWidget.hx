package com.sulake.habbo.catalog.viewer.widgets
;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowKeyboardEvent;
    import flash.ui.Keyboard;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class RedeemItemCodeCatalogWidget extends CatalogWidget
    {
        var _redeemButton:IButtonWindow;
        var _codeField:ITextFieldWindow;

        public function new(k:IWindowContainer)
        {
            super(k);
        }

        override public function dispose()
        {
            super.dispose();
            if (this._redeemButton != null)
            {
                this._redeemButton.removeEventListener(WindowMouseEvent.CLICK, this._Str_19160);
                this._redeemButton = null;
            }
            if (this._codeField != null)
            {
                this._codeField.removeEventListener(WindowKeyboardEvent.WINDOW_EVENT_KEY_DOWN, this._Str_10572);
                this._codeField = null;
            }
        }

        override public function init():Bool
        {
            if (!super.init())
            {
                return false;
            }
            this._redeemButton = Std.downcast(_window.findChildByName("redeem") , IButtonWindow);
            if (this._redeemButton != null)
            {
                this._redeemButton.addEventListener(WindowMouseEvent.CLICK, this._Str_19160);
            }
            this._codeField = Std.downcast(_window.findChildByName("voucher_code") , ITextFieldWindow);
            if (this._codeField != null)
            {
                this._codeField.addEventListener(WindowKeyboardEvent.WINDOW_EVENT_KEY_DOWN, this._Str_10572);
            }
            return true;
        }

        function _Str_19160(k:WindowMouseEvent)
        {
            this.redeem();
        }

        function _Str_10572(k:WindowEvent=null, _arg_2:IWindow=null)
        {
            var _local_3= Std.downcast(k , WindowKeyboardEvent);
            if (_local_3.charCode == Keyboard.ENTER)
            {
                this.redeem();
            }
        }

        function redeem()
        {
            var voucher:String = null;
            var input= _window.findChildByName("voucher_code");
            if (input != null)
            {
                voucher = input.caption;
                if (voucher.length > 0)
                {
                    page.viewer.catalog.redeemVoucher(voucher);
                    input.caption = "";
                }
                else
                {
                    page.viewer.catalog.windowManager.alert("${catalog.voucher.empty.title}", "${catalog.voucher.empty.desc}", 0, function (k:com.sulake.habbo.window.utils.IAlertDialog, _arg_2:WindowEvent)
                    {
                        k.dispose();
                    });
                }
            }
        }
    }

