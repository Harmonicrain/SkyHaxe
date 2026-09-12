package com.sulake.habbo.window.utils
;
    import com.sulake.core.window.utils.INotify;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.window._enum.HabboAlertDialogFlag;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.components.IInteractiveWindow;
    import com.sulake.core.window.components.ITextWindow;

     class AlertDialog implements IAlertDialog implements  INotify
    {
        static inline final _ALERT_BUTTON_LIST= "_alert_button_list";
        static inline final _ALERT_BUTTON_OK= "_alert_button_ok";
        static inline final _ALERT_BUTTON_CANCEL= "_alert_button_cancel";
        static inline final _ALERT_BUTTON_CUSTOM= "_alert_button_custom";
        static inline final HEADER_BUTTON_CLOSE= "header_button_close";
        static inline final _ALERT_TEXT_SUMMARY= "_alert_text_summary";
        static var _counter:UInt = 0;

        var _title:String = "";
        var _summary:String = "";
        var _disposed:Bool = false;
        var _callback:ASFunction = null;
        var _window:IFrameWindow;
        var _dialog:IModalDialog;

        public function new(k:IHabboWindowManager, _arg_2:com.sulake.core.utils.xml.XML, _arg_3:String, _arg_4:String, _arg_5:UInt, _arg_6:ASFunction, _arg_7:Bool)
        {
            var _local_9:IWindow = null;
            _counter++;
            if (_arg_7)
            {
                this._dialog = k.buildModalDialogFromXML(_arg_2);
                this._window = Std.downcast(this._dialog.rootWindow , IFrameWindow);
            }
            else
            {
                this._window = Std.downcast(k.buildFromXML(_arg_2, 2) , IFrameWindow);
            }
            if (_arg_5 == (HabboAlertDialogFlag.NULL : UInt))
            {
                _arg_5 = ((HabboAlertDialogFlag.BUTTON_OK | HabboAlertDialogFlag.TEXT_TITLE) | HabboAlertDialogFlag.TEXT_SUMMARY);
            }
            var _local_8= Std.downcast(this._window.findChildByName(_ALERT_BUTTON_LIST) , IItemListWindow);
            if (_local_8 != null)
            {
                if (!((ASCompat.toInt(_arg_5 )& HabboAlertDialogFlag.BUTTON_OK) != 0))
                {
                    _local_9 = _local_8.getListItemByName(_ALERT_BUTTON_OK);
                    _local_9.dispose();
                }
                if (!((ASCompat.toInt(_arg_5 )& HabboAlertDialogFlag.BUTTON_CANCEL) != 0))
                {
                    _local_9 = _local_8.getListItemByName(_ALERT_BUTTON_CANCEL);
                    _local_9.dispose();
                }
                if (!((ASCompat.toInt(_arg_5 )& HabboAlertDialogFlag.BUTTON_CUSTOM) != 0))
                {
                    _local_9 = _local_8.getListItemByName(_ALERT_BUTTON_CUSTOM);
                    _local_9.dispose();
                }
            }
            this._window.procedure = this.dialogEventProc;
            this.title = _arg_3;
            this.summary = _arg_4;
            this.callback = _arg_6;
            this._window.center();
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                if (((this._dialog != null) && (!this._dialog.disposed)))
                {
                    this._dialog.dispose();
                    this._dialog = null;
                    this._window = null;
                }
                if (((this._window != null) && (!this._window.disposed)))
                {
                    this._window.dispose();
                    this._window = null;
                }
                this._callback = null;
                this._disposed = true;
            }
        }

        function dialogEventProc(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3:WindowEvent = null;
            if (k.type == WindowMouseEvent.CLICK)
            {
                switch (_arg_2.name)
                {
                    case _ALERT_BUTTON_OK:
                        if (this._callback != null)
                        {
                            _local_3 = WindowEvent.allocate(WindowEvent.WINDOW_EVENT_OK, null, null);
                            this._callback(this, _local_3);
                            _local_3.recycle();
                        }
                        else
                        {
                            this.dispose();
                        }
                        return;
                    case HEADER_BUTTON_CLOSE
                       | _ALERT_BUTTON_CANCEL:
                        if (this._callback != null)
                        {
                            _local_3 = WindowEvent.allocate(WindowEvent.WINDOW_EVENT_CANCEL, null, null);
                            this._callback(this, _local_3);
                            _local_3.recycle();
                        }
                        else
                        {
                            this.dispose();
                        }
                        return;
                }
            }
        }

        public function getButtonCaption(k:Int):ICaption
        {
            var _local_2:IInteractiveWindow = null;
            if (!this._disposed)
            {
                switch (k)
                {
                    case HabboAlertDialogFlag.BUTTON_OK:
                        _local_2 = Std.downcast(this._window.findChildByName(_ALERT_BUTTON_OK) , IInteractiveWindow);
                        
                    case HabboAlertDialogFlag.BUTTON_CANCEL:
                        _local_2 = Std.downcast(this._window.findChildByName(_ALERT_BUTTON_CANCEL) , IInteractiveWindow);
                        
                    case HabboAlertDialogFlag.BUTTON_CUSTOM:
                        _local_2 = Std.downcast(this._window.findChildByName(_ALERT_BUTTON_CUSTOM) , IInteractiveWindow);
                        
                }
            }
            return (_local_2 != null) ? new AlertDialogCaption(_local_2.caption, _local_2.toolTipCaption, _local_2.visible) : null;
        }

        public function setButtonCaption(k:Int, _arg_2:ICaption)
        {
            var _local_3:IInteractiveWindow = null;
            if (!this._disposed)
            {
                switch (k)
                {
                    case HabboAlertDialogFlag.BUTTON_OK:
                        _local_3 = Std.downcast(this._window.findChildByName(_ALERT_BUTTON_OK) , IInteractiveWindow);
                        
                    case HabboAlertDialogFlag.BUTTON_CANCEL:
                        _local_3 = Std.downcast(this._window.findChildByName(_ALERT_BUTTON_CANCEL) , IInteractiveWindow);
                        
                    case HabboAlertDialogFlag.BUTTON_CUSTOM:
                        _local_3 = Std.downcast(this._window.findChildByName(_ALERT_BUTTON_CUSTOM) , IInteractiveWindow);
                        
                }
            }
            if (_local_3 != null)
            {
                _local_3.caption = _arg_2.text;
            }
        }

        
        public var title(get,set):String;
public function  set_title(k:String):String        {
            this._title = k;
            if (this._window != null)
            {
                this._window.caption = this._title;
            }
return k;
        }
public function  get_title():String
        {
            return this._title;
        }

        
        public var summary(get,set):String;
public function  set_summary(k:String):String        {
            this._summary = k;
            if (this._window != null)
            {
                cast(this._window.findChildByTag("DESCRIPTION"), ITextWindow).text = this._summary;
            }
return k;
        }
public function  get_summary():String
        {
            return this._summary;
        }

        
        public var callback(get,set):ASFunction;
public function  set_callback(k:ASFunction):ASFunction        {
            return this._callback = k;
        }
public function  get_callback():ASFunction
        {
            return this._callback;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }
    }

