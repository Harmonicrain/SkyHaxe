package com.sulake.habbo.window.utils
;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.utils.HabboWebTools;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IButtonWindow;

     class AlertDialogWithLink extends AlertDialog implements IAlertDialogWithLink
    {
        var _Str_17547:String = "";
        var _Str_15928:String = "";

        public function new(k:IHabboWindowManager, _arg_2:com.sulake.core.utils.xml.XML, _arg_3:String, _arg_4:String, _arg_5:String, _arg_6:String, _arg_7:UInt, _arg_8:ASFunction)
        {
            super(k, _arg_2, _arg_3, _arg_4, _arg_7, _arg_8, false);
            this.linkTitle = _arg_5;
            this.linkUrl = _arg_6;
        }

        override function dialogEventProc(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                switch (_arg_2.name)
                {
                    case "_alert_button_link":
                        HabboWebTools.navigateToURL(this._Str_15928, "_empty");
                        return;
                }
            }
            super.dialogEventProc(k, _arg_2);
        }

        
        public var linkTitle(get,set):String;
public function  set_linkTitle(k:String):String        {
            this._Str_17547 = k;
            if (_window != null)
            {
                cast(_window.findChildByTag("LINK"), IButtonWindow).caption = this._Str_17547;
            }
return k;
        }
public function  get_linkTitle():String
        {
            return this._Str_17547;
        }

        
        public var linkUrl(get,set):String;
public function  set_linkUrl(k:String):String        {
            return this._Str_15928 = k;
        }
public function  get_linkUrl():String
        {
            return this._Str_15928;
        }
    }

