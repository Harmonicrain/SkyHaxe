package com.sulake.habbo.ui.widget.poll
;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetPollMessage;
    import com.sulake.core.window.events.WindowEvent;

     class PollOfferDialog implements IPollDialog
    {
        public static inline final OK= "POLL_OFFER_STATE_OK";
        public static inline final POLL_OFFER_STATE_CANCEL= "POLL_OFFER_STATE_CANCEL";
        public static inline final UNKNOWN= "POLL_OFFER_STATE_UNKNOWN";

        var _disposed:Bool = false;
        var _window:IFrameWindow;
        var _state:String = "POLL_OFFER_STATE_UNKNOWN";
        var _roomPollWidget:RoomPollWidget;
        var _id:Int = -1;

        public function new(k:Int, _arg_2:String, _arg_3:String, _arg_4:RoomPollWidget)
        {
            var _local_6:IWindow = null;
            var _local_7:IWindow = null;
            var _local_8:IWindow = null;
            var _local_9:IWindow = null;
            var _local_10:IItemListWindow = null;
            var _local_11:ITextWindow = null;
            var _local_12:ITextWindow = null;
            this._id = k;
            this._roomPollWidget = _arg_4;
            var _local_5= Std.downcast(this._roomPollWidget.assets.getAssetByName("poll_offer") , XmlAsset);
            if (_local_5 != null)
            {
                this._window = Std.downcast(this._roomPollWidget.windowManager.buildFromXML(((_local_5.content : com.sulake.core.utils.xml.XML) )) , IFrameWindow);
                if (this._window != null)
                {
                    this._window.center();
                    _local_6 = this._window.findChildByName("poll_offer_button_ok");
                    if (_local_6 != null)
                    {
                        _local_6.addEventListener(WindowMouseEvent.CLICK, this._Str_6167);
                    }
                    _local_7 = this._window.findChildByName("poll_offer_button_cancel");
                    if (_local_7 != null)
                    {
                        _local_7.addEventListener(WindowMouseEvent.CLICK, this._Str_26455);
                    }
                    _local_8 = this._window.findChildByName("poll_offer_button_later");
                    if (_local_8 != null)
                    {
                        _local_8.addEventListener(WindowMouseEvent.CLICK, this._Str_22751);
                    }
                    _local_9 = this._window.findChildByName("header_button_close");
                    if (_local_9 != null)
                    {
                        _local_9.addEventListener(WindowMouseEvent.CLICK, this.onCloseHandler);
                    }
                    _local_11 = Std.downcast(this._window.findChildByName("poll_offer_headline") , ITextWindow);
                    if (_local_11 != null)
                    {
                        _local_11.htmlText = _arg_2;
                        _local_10 = Std.downcast(this._window.findChildByName("poll_offer_headline_wrapper") , IItemListWindow);
                        if (_local_10 != null)
                        {
                            this._window.height = Std.int(this._window.height + (_local_10.scrollableRegion.height - _local_10.visibleRegion.height));
                        }
                    }
                    _local_12 = Std.downcast(this._window.findChildByName("poll_offer_summary") , ITextWindow);
                    if (_local_12 != null)
                    {
                        _local_12.htmlText = _arg_3;
                        _local_10 = Std.downcast(this._window.findChildByName("poll_offer_summary_wrapper") , IItemListWindow);
                        if (_local_10 != null)
                        {
                            this._window.height = Std.int(this._window.height + (_local_10.scrollableRegion.height - _local_10.visibleRegion.height));
                        }
                    }
                }
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var state(get,never):String;
public function  get_state():String
        {
            return this._state;
        }

        public function start()
        {
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            this._disposed = true;
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            this._roomPollWidget = null;
        }

        function _Str_6167(k:WindowEvent)
        {
            if (this._state != UNKNOWN)
            {
                return;
            }
            this._state = OK;
            this._roomPollWidget.messageListener.processWidgetMessage(new RoomWidgetPollMessage(RoomWidgetPollMessage.RWPM_START, this._id));
        }

        function _Str_26455(k:WindowEvent)
        {
            if (this._state != UNKNOWN)
            {
                return;
            }
            this._state = POLL_OFFER_STATE_CANCEL;
            this._roomPollWidget.messageListener.processWidgetMessage(new RoomWidgetPollMessage(RoomWidgetPollMessage.RWPM_REJECT, this._id));
            this._roomPollWidget._Str_12823(this._id);
        }

        function _Str_22751(k:WindowEvent)
        {
            if (this._state != UNKNOWN)
            {
                return;
            }
            this._state = POLL_OFFER_STATE_CANCEL;
            this._roomPollWidget._Str_12823(this._id);
        }

        function onCloseHandler(k:WindowEvent)
        {
            if (this._state != UNKNOWN)
            {
                return;
            }
            this._state = POLL_OFFER_STATE_CANCEL;
            this._roomPollWidget.messageListener.processWidgetMessage(new RoomWidgetPollMessage(RoomWidgetPollMessage.RWPM_REJECT, this._id));
            this._roomPollWidget._Str_12823(this._id);
        }
    }

