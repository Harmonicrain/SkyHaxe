package com.sulake.habbo.phonenumber
;
    import com.sulake.core.window.components.IFrameWindow;
    import flash.utils.Timer;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;
    import flash.events.TimerEvent;
    import com.sulake.core.window.components.ILabelWindow;

     class VerificationCodeInputView 
    {
        static inline final _Str_7625= 10;

        var _component:HabboPhoneNumber;
        var _window:IFrameWindow;
        var _inputTextNeedsClearing:Bool = true;
        var _waitTimer:Timer;

        public function new(k:HabboPhoneNumber)
        {
            this._component = k;
            this.createWindow();
        }

        public function dispose()
        {
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            if (this._waitTimer != null)
            {
                this._waitTimer.reset();
                this._waitTimer = null;
            }
            this._component = null;
        }

        public function _Str_16661(k:Int)
        {
            this._component.windowManager.alert("${generic.alert.title}", (("${phone.number.verify.error." + Std.string(k)) + "}"), 0, null);
            cast(this._window.findChildByName("verification_code_input"), ITextFieldWindow).textColor = 0xFF0000;
            this._window.findChildByName("verification_code_input").enable();
            this._inputTextNeedsClearing = true;
        }

        function createWindow()
        {
            if (this._window != null)
            {
                return;
            }
            this._window = cast(this._component.windowManager.buildFromXML(new com.sulake.core.utils.xml.XML(this._component.assets.getAssetByName("phonenumber_verify_xml").content)), IFrameWindow);
            this._window.center();
            if (this._window.findChildByName("wait_link") != null)
            {
                this._window.findChildByName("wait_link").procedure = this._Str_13227;
            }
            this._window.findChildByName("ok_button").procedure = this._Str_13227;
            if (this._window.findChildByName("header_button_close") != null)
            {
                this._window.findChildByName("header_button_close").visible = false;
            }
            this._window.findChildByName("verification_code_input").procedure = this._Str_13227;
            this._window.findChildByName("did_not_receive_code_link").procedure = this._Str_13227;
            this._window.findChildByName("ok_button").disable();
            this._window.findChildByName("verification_code_input").enable();
            if ((this._component._Str_20480 - flash.Lib.getTimer()) <= 0)
            {
                this._Str_15400();
            }
            else
            {
                this._Str_25063();
            }
            cast(this._window.findChildByName("verification_code_input"), ITextFieldWindow).maxChars = _Str_7625;
            this._inputTextNeedsClearing = true;
        }

        function _Str_13227(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            switch (_arg_2.name)
            {
                case "header_button_close"
                   | "wait_link":
                    this._component._Str_16951(true);
                    return;
                case "did_not_receive_code_link":
                    this._component._Str_24068();
                    return;
                case "ok_button":
                    this._component._Str_24369(this._window.findChildByName("verification_code_input").caption);
                    this._window.findChildByName("ok_button").disable();
                    this._window.findChildByName("verification_code_input").disable();
                    return;
                case "verification_code_input":
                    if (this._inputTextNeedsClearing)
                    {
                        this._window.findChildByName("verification_code_input").caption = "";
                        this._inputTextNeedsClearing = false;
                    }
                    this._window.findChildByName("ok_button").enable();
                    cast(this._window.findChildByName("verification_code_input"), ITextFieldWindow).textColor = 0;
                    return;
            }
        }

        public function _Str_15400()
        {
            this._window.findChildByName("did_not_receive_code_link").visible = true;
            this._window.findChildByName("retry_wait_label").visible = false;
        }

        public function _Str_25063(k:Int=0)
        {
            this._window.findChildByName("did_not_receive_code_link").visible = false;
            this._window.findChildByName("retry_wait_label").visible = true;
            this.onWaitTimer();
            this._waitTimer = new Timer(1000);
            this._waitTimer.addEventListener(TimerEvent.TIMER, (this.onWaitTimer : ASAny));
            this._waitTimer.start();
        }

        function onWaitTimer(k:TimerEvent=null)
        {
            var _local_2= this._component.localizationManager.getLocalization("phone.number.verify.wait.remaining", "");
            var _local_3= Std.int(Math.max(0, ((this._component._Str_20480 - flash.Lib.getTimer()) / 1000)));
            _local_2 = ASCompat.stringReplace(_local_2, "{0}", _local_3);
            Std.downcast(this._window.findChildByName("retry_wait_label") , ILabelWindow).text = _local_2;
            if (_local_3 == 0)
            {
                if (this._waitTimer != null)
                {
                    this._waitTimer.stop();
                }
                this._waitTimer = null;
                this._Str_15400();
            }
        }
    }






