package com.sulake.habbo.ui.widget.furniture.credit
;
    import com.sulake.habbo.ui.widget.RoomWidgetBase;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.ui.widget.events._Str_4899;
    import flash.events.IEventDispatcher;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window._enum.WindowType;
    import com.sulake.habbo.window._enum.HabboWindowStyle;
    import com.sulake.core.window._enum.WindowParam;
    import flash.geom.Rectangle;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetCreditFurniRedeemMessage;
    import com.sulake.habbo.utils.HabboWebTools;
    import com.sulake.core.window.events.WindowEvent;

     class CreditFurniWidget extends RoomWidgetBase
    {
        static inline final _Str_4126:Float = 100;
        static inline final _Str_4162:Float = 100;

        var _window:IWindowContainer;
        var _Str_10662:Int = -1;
        var _value:Float = Math.NaN;
		var _furniType:String;

        public function new(k:IRoomWidgetHandler, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary, _arg_4:IHabboLocalizationManager)
        {
            super(k, _arg_2, _arg_3, _arg_4);
        }

        override public function dispose()
        {
            this._Str_2718();
            super.dispose();
        }

        override public function registerUpdateEvents(k:IEventDispatcher)
        {
            if (k == null)
            {
                return;
            }
            k.addEventListener(_Str_4899.RWCFUE_CREDIT_FURNI_UPDATE, this.onObjectUpdate);
            super.registerUpdateEvents(k);
        }

        override public function unregisterUpdateEvents(k:IEventDispatcher)
        {
            if (k == null)
            {
                return;
            }
            k.removeEventListener(_Str_4899.RWCFUE_CREDIT_FURNI_UPDATE, this.onObjectUpdate);
        }

        function onObjectUpdate(k:_Str_4899)
        {
            this._Str_2718();
            this._Str_10662 = k.objectId;
            this._value = k._Str_22599;
			this._furniType = k.furniType;
            this.showInterface();
        }

        function showInterface()
        {
            var _local_3:IWindow = null;
            if (this._Str_10662 == -1)
            {
                return;
            }
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
			
			/*var currency:String = "credits";
			var parts:Array = this._furniType.split("_");
			
			if (parts[0] == "PF")
			{
				if (parts.length >= 2)
				{
					currency = ("achievements.activitypoint.0");
					this._value = parts[1];
				}
			}
			else if (parts[0] == "DF")
			{
				if (parts.length >= 3 )
				{
					currency = ("achievements.activitypoint." + parts[1]);
					this._value = parts[2];
				}
			}
			
			this._furniType = localizations.getLocalization(currency);*/
			
            windowManager.registerLocalizationParameter("widgets.furniture.credit.redeem.value", "value", Std.string(this._value));
			windowManager.registerLocalizationParameter("widgets.furniture.credit.redeem.value", "type", this._furniType);
			
            var k= assets.getAssetByName("credit_redeem");
            var _local_2= cast(k, XmlAsset);
            if (_local_2 == null)
            {
                return;
            }
            this._window = Std.downcast(windowManager.createWindow("creditfurniui_container", "", WindowType.WINDOW_TYPE_CONTAINER, HabboWindowStyle.DEFAULT, (ASCompat.toInt(WindowParam.WINDOW_PARAM_EXPAND_TO_ACCOMMODATE_CHILDREN )| ASCompat.toInt(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR)), new Rectangle(_Str_4126, _Str_4162, 2, 2), null, 0) , IWindowContainer);
            this._window.buildFromXML(new com.sulake.core.utils.xml.XML(_local_2.content));
            this._window.background = true;
            this._window.color = 33554431;
            _local_3 = this._window.findChildByName("cancel");
            if (_local_3 != null)
            {
                _local_3.addEventListener(WindowMouseEvent.CLICK, this.onMouseEvent);
            }
            _local_3 = this._window.findChildByName("exchange");
            if (_local_3 != null)
            {
                _local_3.addEventListener(WindowMouseEvent.CLICK, this.onMouseEvent);
            }
            _local_3 = this._window.findChildByName("link");
            if (_local_3 != null)
            {
                _local_3.addEventListener(WindowMouseEvent.CLICK, this.onMouseEvent);
            }
            _local_3 = this._window.findChildByTag("close");
            if (_local_3 != null)
            {
                _local_3.procedure = this.onWindowClose;
            }
            this._window.addEventListener(WindowMouseEvent.CLICK, this.onMouseEvent);
        }

        function _Str_2718()
        {
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            this._Str_10662 = -1;
            this._value = 0;
        }

        function _Str_25731()
        {
            var k:RoomWidgetCreditFurniRedeemMessage = null;
            if (this._Str_10662 == -1)
            {
                return;
            }
            if (messageListener != null)
            {
                k = new RoomWidgetCreditFurniRedeemMessage(RoomWidgetCreditFurniRedeemMessage.RWFCRM_REDEEM, this._Str_10662);
                messageListener.processWidgetMessage(k);
                this._Str_2718();
            }
        }

        function onMouseEvent(k:WindowMouseEvent)
        {
            var _local_4:String = null;
            var _local_2= k.target ;
            var _local_3= _local_2.name;
            switch (_local_3)
            {
                case "link":
                    _local_4 = localizations.getLocalization("widget.furni.info.url");
                    if (_local_4.indexOf("http") == 0)
                    {
                        HabboWebTools.navigateToURL(_local_4, "habboMain");
                    }
                    return;
                case "exchange":
                    this._Str_25731();
                    return;
                case "cancel"
                   | "close":
                    this._Str_2718();
                    return;
            }
        }

        function onWindowClose(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this._Str_2718();
        }
    }

