package com.sulake.habbo.window.utils
;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.IWindow;

     class ConfirmDialog extends AlertDialog implements IConfirmDialog
    {
        public function new(k:IHabboWindowManager, _arg_2:com.sulake.core.utils.xml.XML, _arg_3:String, _arg_4:String, _arg_5:UInt, _arg_6:ASFunction, _arg_7:Bool)
        {
            super(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7);
        }

        override function dialogEventProc(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3:WindowEvent = null;
            if (k.type == WindowMouseEvent.CLICK)
            {
                switch (_arg_2.name)
                {
                    case AlertDialog._ALERT_BUTTON_OK:
                        if (_callback != null)
                        {
                            _local_3 = WindowEvent.allocate(WindowEvent.WINDOW_EVENT_OK, null, null);
                            _callback(this, _local_3);
                            _local_3.recycle();
                        }
                        return;
                    case AlertDialog._ALERT_BUTTON_CANCEL
                       | AlertDialog.HEADER_BUTTON_CLOSE:
                        if (_callback != null)
                        {
                            _local_3 = WindowEvent.allocate(WindowEvent.WINDOW_EVENT_CANCEL, null, null);
                            _callback(this, _local_3);
                            _local_3.recycle();
                        }
                        return;
                }
            }
        }
    }

