package com.sulake.habbo.ui.widget.furniture.ecotronbox
;
    import com.sulake.habbo.ui.widget.RoomWidgetBase;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.ui.widget.events._Str_3072;
    import com.sulake.habbo.ui.widget.events.RoomWidgetRoomObjectUpdateEvent;
    import com.sulake.habbo.ui.widget.events.RoomWidgetPresentDataUpdateEvent;
    import flash.events.IEventDispatcher;
    import flash.display.BitmapData;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.geom.Point;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window._enum.WindowType;
    import com.sulake.habbo.window._enum.HabboWindowStyle;
    import com.sulake.core.window._enum.WindowParam;
    import flash.geom.Rectangle;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetEcotronBoxOpenMessage;

     class EcotronboxFurniWidget extends RoomWidgetBase
    {
        static inline final _Str_4126:Float = 100;
        static inline final _Str_4162:Float = 100;

        var _window:IWindowContainer;
        var _objectId:Int = -1;
        var _text:String;
        var _controller:Bool = false;
        var _Str_3608:Bool = false;
        var _Str_6880:String = "ecotron_box";
        var _Str_10029:Map;

        public function new(k:IRoomWidgetHandler, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary=null)
        {
            this._Str_10029 = new Map();
            super(k, _arg_2, _arg_3);
            this._Str_10029.add("", "ecotronbox_card");
            this._Str_10029.add("ecotron_box", "ecotronbox_card");
            this._Str_10029.add("matic_box", "ecotronbox_card_furnimatic");
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
            k.addEventListener(_Str_3072.RWEBDUE_PACKAGEINFO, this.onObjectUpdate);
            k.addEventListener(_Str_3072.RWEBDUE_CONTENTS, this.onObjectUpdate);
            k.addEventListener(RoomWidgetRoomObjectUpdateEvent.FURNI_REMOVED, this._Str_4159);
            k.addEventListener(RoomWidgetPresentDataUpdateEvent.RWPDUE_PACKAGEINFO, this._Str_20683);
            super.registerUpdateEvents(k);
        }

        override public function unregisterUpdateEvents(k:IEventDispatcher)
        {
            if (k == null)
            {
                return;
            }
            k.removeEventListener(_Str_3072.RWEBDUE_PACKAGEINFO, this.onObjectUpdate);
            k.removeEventListener(_Str_3072.RWEBDUE_CONTENTS, this.onObjectUpdate);
            k.removeEventListener(RoomWidgetPresentDataUpdateEvent.RWPDUE_PACKAGEINFO, this._Str_20683);
            k.removeEventListener(RoomWidgetRoomObjectUpdateEvent.FURNI_REMOVED, this._Str_4159);
        }

        function onObjectUpdate(k:_Str_3072)
        {
            this._Str_2718();
            switch (k.type)
            {
                case _Str_3072.RWEBDUE_PACKAGEINFO:
                    this._Str_3608 = false;
                    this._objectId = k.objectId;
                    this._text = k.text;
                    this._controller = k.controller;
                    this._Str_6880 = k._Str_17878;
                    this.showInterface();
                    return;
                case _Str_3072.RWEBDUE_CONTENTS:
                    if (!this._Str_3608)
                    {
                        return;
                    }
                    this._objectId = k.objectId;
                    this.showInterface();
                    this._Str_9278(k._Str_11625);
                    this._Str_23892(k.text);
                    this._Str_19806(false);
                    return;
            }
        }

        function _Str_4159(k:RoomWidgetRoomObjectUpdateEvent)
        {
            if (k.id == this._objectId)
            {
                this._Str_2718();
            }
        }

        function _Str_20683(k:RoomWidgetPresentDataUpdateEvent)
        {
            switch (k.type)
            {
                case RoomWidgetPresentDataUpdateEvent.RWPDUE_PACKAGEINFO:
                    this._Str_2718();
                    return;
            }
        }

        function _Str_9278(k:BitmapData)
        {
            if (k == null)
            {
                k = new BitmapData(1, 1);
            }
            if (this._window == null)
            {
                return;
            }
            var _local_2= Std.downcast(this._window.findChildByName("ecotronbox_card_preview") , IBitmapWrapperWindow);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= Std.int((_local_2.width - k.width) / 2);
            var _local_4= Std.int((_local_2.height - k.height) / 2);
            if (_local_2.bitmap == null)
            {
                _local_2.bitmap = new BitmapData(_local_2.width, _local_2.height, true, 0xFFFFFF);
            }
            _local_2.bitmap.fillRect(_local_2.bitmap.rect, 0xFFFFFF);
            _local_2.bitmap.copyPixels(k, k.rect, new Point(_local_3, _local_4), null, null, false);
        }

        function _Str_23892(k:String)
        {
            var _local_2:ITextWindow = null;
            _local_2 = Std.downcast(this._window.findChildByName("ecotronbox_card_msg") , ITextWindow);
            if (((!(_local_2 == null)) && (!(k == null))))
            {
                _local_2.caption = k;
            }
        }

        function showInterface()
        {
            var _local_3:ITextWindow = null;
            var _local_4:IWindow = null;
            if (this._objectId < 0)
            {
                return;
            }
            var k= assets.getAssetByName(this._Str_10029.getValue(this._Str_6880));
            var _local_2= cast(k, XmlAsset);
            if (_local_2 == null)
            {
                return;
            }
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            this._window = Std.downcast(windowManager.createWindow("ecotronboxcardui_container", "", WindowType.WINDOW_TYPE_CONTAINER, HabboWindowStyle.DEFAULT, (ASCompat.toInt(WindowParam.WINDOW_PARAM_EXPAND_TO_ACCOMMODATE_CHILDREN )| ASCompat.toInt(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR)), new Rectangle(_Str_4126, _Str_4162, 2, 2), null, 0) , IWindowContainer);
            this._window.buildFromXML(new com.sulake.core.utils.xml.XML(_local_2.content));
            _local_3 = Std.downcast(this._window.findChildByName("ecotronbox_card_date") , ITextWindow);
            if (((!(_local_3 == null)) && (!(this._text == null))))
            {
                _local_3.caption = this._text;
            }
            _local_4 = this._window.findChildByName("ecotronbox_card_btn_close");
            if (_local_4 != null)
            {
                _local_4.addEventListener(WindowMouseEvent.CLICK, this.onMouseEvent);
            }
            this._Str_19806(true);
        }

        function _Str_19806(k:Bool)
        {
            var _local_2:IWindow = null;
            if (this._window == null)
            {
                return;
            }
            _local_2 = this._window.findChildByName("ecotronbox_card_btn_open");
            if (_local_2 != null)
            {
                if ((this._controller && k))
                {
                    _local_2.visible = true;
                    _local_2.addEventListener(WindowMouseEvent.CLICK, this.onMouseEvent);
                }
                else
                {
                    _local_2.visible = false;
                }
            }
        }

        function _Str_2718()
        {
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            if (!this._Str_3608)
            {
                this._objectId = -1;
            }
            this._text = "";
            this._controller = false;
        }

        function _Str_16426()
        {
            var k:RoomWidgetEcotronBoxOpenMessage = null;
            if (((this._Str_3608 || (this._objectId == -1)) || (!this._controller)))
            {
                return;
            }
            this._Str_3608 = true;
            if (messageListener != null)
            {
                k = new RoomWidgetEcotronBoxOpenMessage(RoomWidgetEcotronBoxOpenMessage.RWEBOM_OPEN_ECOTRONBOX, this._objectId);
                messageListener.processWidgetMessage(k);
            }
        }

        function onMouseEvent(k:WindowMouseEvent)
        {
            var _local_2= k.target ;
            var _local_3= _local_2.name;
            switch (_local_3)
            {
                case "ecotronbox_card_btn_open":
                    this._Str_16426();
                    return;
                default:
                    this._Str_3608 = false;
                    this._Str_2718();
            }
        }
    }

