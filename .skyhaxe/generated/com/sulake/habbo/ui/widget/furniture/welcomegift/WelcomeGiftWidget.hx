package com.sulake.habbo.ui.widget.furniture.welcomegift
;
    import com.sulake.habbo.ui.widget.RoomWidgetBase;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window._enum.WindowParam;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.assets.BitmapDataAsset;
    import flash.display.BitmapData;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetFurniActionMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetChangeEmailMessage;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.habbo.ui.widget.events._Str_5438;
    import com.sulake.habbo.ui.widget.events._Str_6843;
    import flash.events.IEventDispatcher;

     class WelcomeGiftWidget extends RoomWidgetBase
    {
        static inline final _Str_10705= "welcome_gift_email_unverified";
        static inline final _Str_13122= "welcome_gift_email_verified";
        static inline final _Str_16369= "welcome_gift_email_change";
        static inline final _Str_23012= 4;

        var _Str_580:Bool = false;
        var _view:IWindowContainer;
        var _Str_4540:String;
        var _Str_14637:String;
        var _isVerified:Bool = false;
        var _Str_5694:Bool = false;
        var _furniId:Int = 0;

        public function new(k:IRoomWidgetHandler, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary, _arg_4:IHabboLocalizationManager)
        {
            super(k, _arg_2, _arg_3, _arg_4);
        }

        override public function  get_disposed():Bool
        {
            return this._Str_580;
        }

        override public function dispose()
        {
            if (this._Str_580)
            {
                return;
            }
            if (this._view != null)
            {
                this._view.dispose();
            }
            super.dispose();
            this._Str_580 = true;
        }

        function _Str_23801()
        {
            if (this._view != null)
            {
                this._view.dispose();
            }
            this._view = Std.downcast(this._Str_13142("welcome_gift_widget") , IWindowContainer);
            this._view.center();
            this.setBitmap("image_bg", "yellow_highlight");
            this.setBitmap("gift_image", "giftbox_full");
            if (this._isVerified)
            {
                this._Str_6469(WelcomeGiftWidget._Str_13122);
            }
            else
            {
                this._Str_6469(WelcomeGiftWidget._Str_10705);
            }
        }

        function _Str_13142(k:String):IWindow
        {
            var _local_2= Std.downcast(assets.getAssetByName(k) , XmlAsset);
            if (_local_2 == null)
            {
                return null;
            }
            return windowManager.buildFromXML(((_local_2.content : com.sulake.core.utils.xml.XML) ));
        }

        function disposeView()
        {
            if (this._view != null)
            {
                this._view.dispose();
                this._view = null;
            }
        }

        function _Str_6469(k:String)
        {
            var _local_6:ITextFieldWindow = null;
            if (this._view == null)
            {
                return;
            }
            var _local_2= Std.downcast(this._view.findChildByName("state_content") , IWindowContainer);
            while (_local_2.numChildren > 0)
            {
                _local_2.removeChildAt(0);
            }
            var _local_3= this._Str_13142(k);
            if (_local_3 == null)
            {
                Logger.log([("invalid welcome gift widget state: " + k)]);
                return;
            }
            _local_2.addChild(_local_3);
            _local_2.height = _local_3.height;
            switch (k)
            {
                case WelcomeGiftWidget._Str_10705:
                    this._Str_8459(this._view.findChildByName("edit"), this._Str_23358);
                    this.setBitmap("email_icon", "email_icon");
                    this._Str_4180("title", "${welcome.gift.title.email.unverified}");
                    this._Str_4180("text", "${welcome.gift.text.email.unverified}");
                    this._view.findChildByName("edit_text").visible = this._Str_5694;
                    this._view.findChildByName("edit").setParamFlag(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR, this._Str_5694);
                    
                case WelcomeGiftWidget._Str_13122:
                    this.setBitmap("email_icon", "ok_icon");
                    this._Str_4180("title", "${welcome.gift.title.email.verified}");
                    this._Str_4180("text", "${welcome.gift.text.email.verified}");
                    
                case WelcomeGiftWidget._Str_16369:
                    this._Str_8459(this._view.findChildByName("cancel_email_change"), this._Str_23425);
                    this._Str_8459(this._view.findChildByName("save_email"), this._Str_23235);
                    this.setBitmap("email_icon", "email_icon");
                    this._Str_19208("save_email", this._Str_5694);
                    _local_6 = Std.downcast(this._view.findChildByName("email_input") , ITextFieldWindow);
                    _local_6.caption = this._Str_4540;
                    _local_6.focus();
                    _local_6.setSelection(0, ASCompat.MAX_INT);
                    
            }
            var _local_4= this._view.findChildByName("email");
            if (_local_4 != null)
            {
                _local_4.caption = this._Str_4540;
            }
            var _local_5= this._view.findChildByName("open");
            if (_local_5 != null)
            {
                if (this._isVerified)
                {
                    _local_5.enable();
                }
                else
                {
                    _local_5.disable();
                }
            }
            this._Str_8459(this._view.findChildByName("close"), this.close);
            this._Str_8459(this._view.findChildByTag("close"), this.close);
            this._Str_8459(this._view.findChildByName("open"), this._Str_23940);
        }

        function _Str_4180(k:String, _arg_2:String)
        {
            if (this._view == null)
            {
                return;
            }
            var _local_3= this._view.findChildByName(k);
            if (_local_3 != null)
            {
                _local_3.caption = _arg_2;
            }
        }

        function setBitmap(k:String, _arg_2:String)
        {
            var _local_3= Std.downcast(this._view.findChildByName(k) , IBitmapWrapperWindow);
            var _local_4= Std.downcast(_assets.getAssetByName(_arg_2) , BitmapDataAsset);
            if (((!(_local_3 != null)) || (!(_local_4 != null))))
            {
                return;
            }
            var _local_5= ASCompat.dynamicAs(_local_4.content , BitmapData);
            if (_local_3.bitmap != null)
            {
                _local_3.bitmap.dispose();
            }
            _local_3.bitmap = _local_5.clone();
        }

        function _Str_8459(k:IWindow, _arg_2:ASFunction)
        {
            if (k != null)
            {
                k.addEventListener(WindowMouseEvent.CLICK, _arg_2);
            }
        }

        function close(k:WindowMouseEvent)
        {
            this.disposeView();
        }

        function _Str_23358(k:WindowMouseEvent)
        {
            this._Str_6469(WelcomeGiftWidget._Str_16369);
        }

        function _Str_23940(k:WindowMouseEvent)
        {
            messageListener.processWidgetMessage(new RoomWidgetFurniActionMessage(RoomWidgetFurniActionMessage.RWFAM_OPEN_WELCOME_GIFT, this._furniId, 0));
            this.disposeView();
        }

        function _Str_23425(k:WindowMouseEvent)
        {
            this._Str_6469((this._isVerified ? WelcomeGiftWidget._Str_13122 : WelcomeGiftWidget._Str_10705));
        }

        function _Str_23235(k:WindowMouseEvent)
        {
            if (!this._Str_5694)
            {
                return;
            }
            var _local_2= Std.downcast(this._view.findChildByName("email_input") , ITextFieldWindow);
            this._view.findChildByName("cancel_email_change").setParamFlag(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR, false);
            this._Str_19208("save_email", false);
            _local_2.editable = false;
            _local_2.selectable = false;
            this._Str_14637 = _local_2.text;
            messageListener.processWidgetMessage(new RoomWidgetChangeEmailMessage(this._Str_14637));
        }

        function _Str_19208(k:String, _arg_2:Bool)
        {
            if (this._view == null)
            {
                return;
            }
            var _local_3= Std.downcast(this._view.findChildByName(k) , IButtonWindow);
            if (_local_3 != null)
            {
                if (_arg_2)
                {
                    _local_3.enable();
                }
                else
                {
                    _local_3.disable();
                }
            }
        }

        override public function registerUpdateEvents(k:IEventDispatcher)
        {
            if (k == null)
            {
                return;
            }
            k.addEventListener(_Str_5438.RWWGUE_WELCOME_GIFT_WIDGET_STATUS, this.updateEventHandler);
            k.addEventListener(_Str_6843.RWCERE_CHANGE_EMAIL_RESULT, this._Str_21802);
            super.registerUpdateEvents(k);
        }

        override public function unregisterUpdateEvents(k:IEventDispatcher)
        {
            if (k == null)
            {
                return;
            }
            k.removeEventListener(_Str_5438.RWWGUE_WELCOME_GIFT_WIDGET_STATUS, this.updateEventHandler);
            k.removeEventListener(_Str_6843.RWCERE_CHANGE_EMAIL_RESULT, this._Str_21802);
        }

        function updateEventHandler(k:_Str_5438)
        {
            switch (k.type)
            {
                case _Str_5438.RWWGUE_WELCOME_GIFT_WIDGET_STATUS:
                    this._Str_4540 = k.email;
                    this._isVerified = k.isVerified;
                    this._Str_5694 = k._Str_17916;
                    if (k._Str_10512)
                    {
                        this._furniId = k.furniId;
                        this._Str_23801();
                    }
                    else
                    {
                        this.updateView();
                    }
                    return;
            }
        }

        function updateView()
        {
            if (this._view == null)
            {
                return;
            }
            if (this._isVerified)
            {
                this._Str_6469(WelcomeGiftWidget._Str_13122);
            }
            else
            {
                this._Str_6469(WelcomeGiftWidget._Str_10705);
            }
        }

        function _Str_21802(k:_Str_6843)
        {
            if (k.result == 0)
            {
                this._Str_4540 = this._Str_14637;
                this._Str_6469(WelcomeGiftWidget._Str_10705);
            }
            else
            {
                if (k.result == WelcomeGiftWidget._Str_23012)
                {
                    this._Str_5694 = false;
                }
                this._Str_24136(k.result);
            }
        }

        function _Str_24136(k:Int)
        {
            if (this._view == null)
            {
                return;
            }
            this._Str_6469(WelcomeGiftWidget._Str_16369);
            var _local_2= this._view.findChildByName("email_input_container");
            if (_local_2 != null)
            {
                _local_2.color = 0xFFFF8888;
            }
            this._Str_4180("email_input", this._Str_14637);
            this._Str_4180("email_change_instructions", ((("$" + "{welcome.gift.email.error.") + Std.string(k)) + "}"));
        }
    }

