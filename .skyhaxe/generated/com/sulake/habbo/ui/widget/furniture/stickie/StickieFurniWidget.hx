package com.sulake.habbo.ui.widget.furniture.stickie
;
    import com.sulake.habbo.ui.widget.RoomWidgetBase;
    import com.sulake.core.window.IWindowContainer;
    import flash.display.BitmapData;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.ui.widget.events.RoomWidgetStickieDataUpdateEvent;
    import flash.events.IEventDispatcher;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window._enum.WindowType;
    import com.sulake.habbo.window._enum.HabboWindowStyle;
    import com.sulake.core.window._enum.WindowParam;
    import flash.geom.Rectangle;
    import com.sulake.core.window.events.WindowEvent;
    import flash.geom.Point;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetStickieSendUpdateMessage;

     class StickieFurniWidget extends RoomWidgetBase
    {
        static inline final _Str_16242= 14;
        static inline final FIELD_MAX_CHARS= 500;
        static inline final _Str_4126:Float = 100;
        static inline final _Str_4162:Float = 100;

        var _window:IWindowContainer;
        var _objectId:Int = -1;
        var _objectType:String;
        var _text:String;
        var _colorHex:String;
        var _controller:Bool = false;
        var _Str_14561:BitmapData;
        var _Str_18958:String = "stickieui_container";

        public function new(k:IRoomWidgetHandler, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary=null)
        {
            super(k, _arg_2, _arg_3);
        }

        var window(get,never):IWindowContainer;
function  get_window():IWindowContainer
        {
            return this._window;
        }

        override public function dispose()
        {
            if (disposed)
            {
                return;
            }
            this._Str_2718();
            if (this._Str_14561 != null)
            {
                this._Str_14561.dispose();
            }
            super.dispose();
        }

        override public function registerUpdateEvents(k:IEventDispatcher)
        {
            if (k == null)
            {
                return;
            }
            k.addEventListener(RoomWidgetStickieDataUpdateEvent.RWSDUE_STICKIE_DATA, this.onObjectUpdate);
            super.registerUpdateEvents(k);
        }

        override public function unregisterUpdateEvents(k:IEventDispatcher)
        {
            if (k == null)
            {
                return;
            }
            k.removeEventListener(RoomWidgetStickieDataUpdateEvent.RWSDUE_STICKIE_DATA, this.onObjectUpdate);
        }

        function onObjectUpdate(k:RoomWidgetStickieDataUpdateEvent)
        {
            this._Str_2718(false);
            this._objectId = k.objectId;
            this._objectType = k.objectType;
            this._text = k.text;
            this._colorHex = k.colorHex;
            this._controller = k.controller;
            this.showInterface();
        }

        function showInterface()
        {
            var _local_3:ITextFieldWindow = null;
            var _local_4:BitmapDataAsset = null;
            var _local_5:BitmapData = null;
            var _local_6:IBitmapWrapperWindow = null;
            var _local_7:String = null;
            if (this._objectId == -1)
            {
                return;
            }
            var k= assets.getAssetByName("stickie");
            if (k == null)
            {
                return;
            }
            var _local_2= cast(k, XmlAsset);
            if (_local_2 == null)
            {
                return;
            }
            if (this._window == null)
            {
                this._window = Std.downcast(windowManager.createWindow(this._Str_18958, "", WindowType.WINDOW_TYPE_CONTAINER, HabboWindowStyle.DEFAULT, (ASCompat.toInt(WindowParam.WINDOW_PARAM_EXPAND_TO_ACCOMMODATE_CHILDREN )| ASCompat.toInt(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR)), new Rectangle(_Str_4126, _Str_4162, 2, 2), null, 0) , IWindowContainer);
                this._window.buildFromXML(new com.sulake.core.utils.xml.XML(_local_2.content));
            }
            _local_3 = Std.downcast(this._window.findChildByName("text") , ITextFieldWindow);
            if (_local_3 != null)
            {
                _local_3.text = this._text;
                _local_3.addEventListener(WindowEvent.WINDOW_EVENT_CHANGE, this._Str_24865);
            }
            _local_6 = Std.downcast(this._window.findChildByTag("bg") , IBitmapWrapperWindow);
            if (_local_6 != null)
            {
                _local_7 = ASCompat.stringReplace(this._objectType, "post_it", "stickie");
                if ((assets.hasAsset(_local_7) && Std.is(assets.getAssetByName(_local_7) , BitmapDataAsset)))
                {
                    _local_4 = Std.downcast(assets.getAssetByName(_local_7) , BitmapDataAsset);
                }
                else
                {
                    _local_4 = Std.downcast(assets.getAssetByName("stickie_blanco") , BitmapDataAsset);
                    _local_6.color = ASCompat.toUInt(("0xFF" + this._colorHex));
                }
                _local_5 = ASCompat.dynamicAs(_local_4.content , BitmapData);
                if (this._Str_14561 != null)
                {
                    _local_5 = this._Str_14561;
                }
                _local_6.bitmap = new BitmapData(_local_6.width, _local_6.height, true, 0);
                _local_6.bitmap.copyPixels(_local_5, _local_5.rect, new Point(0, 0));
            }
            _local_6 = Std.downcast(this._window.findChildByTag("close_button") , IBitmapWrapperWindow);
            if (_local_6 != null)
            {
                _local_4 = Std.downcast(assets.getAssetByName("stickie_close") , BitmapDataAsset);
                _local_5 = ASCompat.dynamicAs(_local_4.content , BitmapData);
                _local_6.bitmap = new BitmapData(_local_6.width, _local_6.height, true, 0);
                _local_6.bitmap.copyPixels(_local_5, _local_5.rect, new Point(0, 0));
                _local_6.addEventListener(WindowMouseEvent.CLICK, this.onMouseEvent);
            }
            _local_6 = Std.downcast(this._window.findChildByTag("delete_button") , IBitmapWrapperWindow);
            if (((!(_local_6 == null)) && this._controller))
            {
                _local_4 = Std.downcast(assets.getAssetByName("stickie_remove") , BitmapDataAsset);
                _local_5 = ASCompat.dynamicAs(_local_4.content , BitmapData);
                _local_6.bitmap = new BitmapData(_local_6.width, _local_6.height, true, 0);
                _local_6.bitmap.copyPixels(_local_5, _local_5.rect, new Point(0, 0));
                _local_6.addEventListener(WindowMouseEvent.CLICK, this.onMouseEvent);
            }
            this._Str_22258((this._controller && (this._objectType == "post_it")));
        }

        function _Str_2718(k:Bool=true)
        {
            if (k)
            {
                this.sendUpdate();
            }
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            this._objectId = -1;
            this._text = null;
            this._controller = false;
        }

        function _Str_22258(k:Bool)
        {
            var _local_2:IWindow = null;
            var _local_3:Array<ASAny> = ["blue", "purple", "green", "yellow"];
            var _local_4 = 0;
            while (_local_4 <= _local_3.length)
            {
                _local_2 = this._window.findChildByName(_local_3[_local_4]);
                if (_local_2 != null)
                {
                    if (k)
                    {
                        _local_2.visible = true;
                        _local_2.addEventListener(WindowMouseEvent.CLICK, this.onMouseEvent);
                    }
                    else
                    {
                        _local_2.visible = false;
                    }
                }
                _local_4++;
            }
        }

        function _Str_9532():Bool
        {
            var k= Std.downcast(this._window.findChildByName("text") , ITextFieldWindow);
            if (k == null)
            {
                return false;
            }
            if (this._text == k.text)
            {
                return false;
            }
            this._text = k.text;
            return true;
        }

        function sendUpdate()
        {
            var k:RoomWidgetStickieSendUpdateMessage = null;
            if (this._objectId == -1)
            {
                return;
            }
            if (!this._Str_9532())
            {
                return;
            }
            if (messageListener != null)
            {
                k = new RoomWidgetStickieSendUpdateMessage(RoomWidgetStickieSendUpdateMessage.RWSUM_STICKIE_SEND_UPDATE, this._objectId, this._text, this._colorHex);
                messageListener.processWidgetMessage(k);
            }
        }

        function sendSetColor(k:UInt)
        {
            var _local_3:RoomWidgetStickieSendUpdateMessage = null;
            if (this._objectId == -1)
            {
                return;
            }
            this._Str_9532();
            var _local_2= ASCompat.toRadix(k, 16).toUpperCase();
            if (_local_2.length > 6)
            {
                _local_2 = _local_2.substring((_local_2.length - 6), _local_2.length);
            }
            if (_local_2 == this._colorHex)
            {
                return;
            }
            this._colorHex = _local_2;
            if (messageListener != null)
            {
                _local_3 = new RoomWidgetStickieSendUpdateMessage(RoomWidgetStickieSendUpdateMessage.RWSUM_STICKIE_SEND_UPDATE, this._objectId, this._text, this._colorHex);
                messageListener.processWidgetMessage(_local_3);
            }
            this.showInterface();
        }

        function sendDelete()
        {
            var k:RoomWidgetStickieSendUpdateMessage = null;
            if (this._objectId == -1)
            {
                return;
            }
            if (((!(messageListener == null)) && this._controller))
            {
                k = new RoomWidgetStickieSendUpdateMessage(RoomWidgetStickieSendUpdateMessage.RWSUM_STICKIE_SEND_DELETE, this._objectId);
                messageListener.processWidgetMessage(k);
            }
        }

        function _Str_24865(k:WindowEvent)
        {
            var _local_2:ITextFieldWindow = null;
            _local_2 = Std.downcast(this._window.findChildByName("text") , ITextFieldWindow);
            if (_local_2 == null)
            {
                return;
            }
            _local_2.maxChars = FIELD_MAX_CHARS;
            if (_local_2.numLines < _Str_16242)
            {
                return;
            }
            _local_2.text = _local_2.text.substring(0, (_local_2.text.length - 1));
            _local_2.maxChars = _local_2.length;
        }

        function onMouseEvent(k:WindowMouseEvent)
        {
            var _local_2= k.target ;
            var _local_3= _local_2.name;
            switch (_local_3)
            {
                case "blue"
                   | "purple"
                   | "green"
                   | "yellow":
                    this.sendSetColor(_local_2.color);
                    return;
                case "close":
                    this._Str_2718();
                    return;
                case "delete":
                    this.sendDelete();
                    this._Str_2718(false);
                    return;
            }
        }
    }

