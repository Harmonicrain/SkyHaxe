package com.sulake.habbo.moderation
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import flash.net.URLRequest;
    import com.sulake.core.window.events.WindowEvent;

     class OpenExternalLink 
    {
        var _url:String;

        public function new(k:ModerationManager, _arg_2:IWindow, _arg_3:String)
        {
            _arg_2.procedure = this.onClick;
            this._url = _arg_3;
        }

        function onClick(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            flash.Lib.getURL(new URLRequest(this._url), "_blank");
        }
    }

