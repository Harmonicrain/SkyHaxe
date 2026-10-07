package com.sulake.habbo.ui.widget.roomchat
;
	import com.sulake.core.window._enum.WindowParam;
    import com.sulake.habbo.ui.widget.RoomWidgetBase;
    import com.sulake.core.runtime.IUpdateReceiver;
    import com.sulake.habbo.ui.widget.roomchat.style.ChatBubbleFactory;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IItemListWindow;
    import flash.geom.Point;
    import com.sulake.core.runtime.Component;
    import com.sulake.core.runtime.IHabboConfigurationManager;
    import com.sulake.habbo.ui.handler.ChatWidgetHandler;
    import com.sulake.core.window._enum.WindowType;
    import com.sulake.habbo.window._enum.HabboWindowStyle;
    import com.sulake.core.window._enum.WindowParam;
    import flash.geom.Rectangle;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.ui.widget.events.RoomWidgetChatUpdateEvent;
    import com.sulake.habbo.ui.widget.events._Str_3040;
    import flash.events.IEventDispatcher;
    import com.sulake.room.utils.RoomEnterEffect;
    import flash.display.BitmapData;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetRoomObjectMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetChatSelectAvatarMessage;
    import com.sulake.core.window.events.WindowMouseEvent;

     class RoomChatWidget extends RoomWidgetBase implements IUpdateReceiver
    {
        static var _chatBubbleFactory:ChatBubbleFactory = null;
        static inline final _Str_3729= 19;
        static inline final _Str_18120= 10;
        static inline final _Str_12991= 20;
        static inline final _Str_11054= 32;
        static inline final _Str_16411= 25;
        static inline final _Str_13238= 4000;
        static inline final _Str_17591= 6000;
        static inline final _Str_17318= 3;
        static inline final _Str_17488= 1;
        static inline final _Str_16314= 8;
        static inline final _Str_15627= 10;
        static inline final _Str_11205= 12;
        static inline final _Str_6970= 0;
        static final _Str_17792:Int = (((_Str_16314 + _Str_6970) * _Str_3729) + _Str_3729);//171
        static final _Str_18733:Int = (((_Str_15627 + _Str_6970) * _Str_3729) + _Str_3729);//209
        static final _Str_17276:Int = (((_Str_11205 + _Str_6970) * _Str_3729) + _Str_3729);//247
        static inline final _Str_6383= 23;
        static inline final _Str_18228= 40;
        static inline final DESKTOP_WINDOW_LAYER:UInt = 1;
        static inline final _Str_17685= 750;
        static inline final _Str_16222= 1000;

        var _Str_10568:Int = 0;
        var _Str_8808:Int = 0;
        var _Str_2496:IWindowContainer;
        var _Str_4396:IItemListWindow;
        var _Str_3454:IWindowContainer;
        var _itemList:Array<ASAny>;
        var _Str_3107:Array<ASAny>;
        var _Str_4125:Array<ASAny>;
        var _Str_11471:Int = 0;
        var _Str_20565:Int = 0;
        var _Str_7136:Float = 1;
        var _baseUrl:String;
        var _Str_7184:Float = 1;
        var _Str_16304:Float = 0;
        var _Str_7165:Point;
        var _Str_2701:RoomChatHistoryViewer;
        var _gpuMode:Bool = false;
        var _Str_17185:Bool = false;
        var _Str_2296:Component = null;
        var _configurationManager:IHabboConfigurationManager;
        var _Str_19219:Int = 150;
        var _Str_3991:Int = 0;
        var _Str_9513:Int = 19;
        var _Str_24033:Int = 100;
        var _Str_25154:Int = 205;
        var _Str_8959:Int = 0;
        var _Str_11243:Int = 0;

        public function new(k:IRoomWidgetHandler, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary, _arg_4:IHabboLocalizationManager, _arg_5:IHabboConfigurationManager, _arg_6:Int, _arg_7:Component)
        {
            this._itemList = new Array<ASAny>();
            this._Str_3107 = new Array<ASAny>();
            this._Str_4125 = new Array<ASAny>();
            this._Str_7165 = new Point();
            super(k, _arg_2, _arg_3, _arg_4);
            Std.downcast(k , ChatWidgetHandler).widget = this;
            this._configurationManager = _arg_5;
            this._Str_11471 = _arg_6;
            var _local_8= _arg_2.getDesktop(DESKTOP_WINDOW_LAYER);
            if (_local_8.height >= _Str_16222)
            {
                this._Str_8959 = _Str_17276;
                this._Str_11243 = _Str_11205;
                Logger.log(["Hi-res chat desktop selected"]);
            }
            else
            {
                if (_local_8.height >= _Str_17685)
                {
                    this._Str_8959 = _Str_18733;
                    this._Str_11243 = _Str_15627;
                    Logger.log(["Mid-res chat desktop selected"]);
                }
                else
                {
                    this._Str_8959 = _Str_17792;
                    this._Str_11243 = _Str_11205;
                    Logger.log(["Lo-res chat desktop selected"]);
                }
            }
            this._Str_3991 = (this._Str_8959 + _Str_6383);
            this._Str_2496 = Std.downcast(_arg_2.createWindow("chat_container", "", WindowType.WINDOW_TYPE_CONTAINER, HabboWindowStyle.DEFAULT, WindowParam.WINDOW_PARAM_NULL, new Rectangle(0, 0, 200, (this._Str_3991 + RoomChatHistoryPulldown.PULLDOWN_WINDOW_HEIGHT)), null, 0) , IWindowContainer);
            this._Str_2496.background = true;
            this._Str_2496.color = 33554431;
            this._Str_2496.tags.push("room_widget_chat");
            this._Str_4396 = Std.downcast(_arg_2.createWindow("chat_contentlist", "", WindowType.WINDOW_TYPE_ITEMLIST_VERTICAL, HabboWindowStyle.NULL, (ASCompat.toInt(WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT )| ASCompat.toInt(WindowParam.WINDOW_PARAM_RELATIVE_SCALE_STRETCH)), new Rectangle(0, 0, 200, this._Str_3991), null, 0) , IItemListWindow);
            this._Str_4396.disableAutodrag = true;
            this._Str_2496.addChild(this._Str_4396);
            this._Str_3454 = Std.downcast(_arg_2.createWindow("chat_active_content", "", WindowType.WINDOW_TYPE_CONTAINER, HabboWindowStyle.NULL, WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT, new Rectangle(0, 0, 200, this._Str_3991), null, 0) , IWindowContainer);
            this._Str_3454.clipping = false;
            this._Str_4396.addListItem(this._Str_3454);
            this._Str_2701 = new RoomChatHistoryViewer(this, _arg_2, this._Str_2496, _arg_3);
            this._baseUrl = _arg_5.getProperty("site.url");
            this._Str_19219 = _arg_5.getInteger("chat.history.item.max.count", 150);
            var _local_9= (_arg_5.getBoolean("chat.history.disabled") || this.isGameSession);
            if (this._Str_2701 != null)
            {
                this._Str_2701.disabled = _local_9;
            }
            if (_arg_7 != null)
            {
                this._Str_2296 = _arg_7;
                this._Str_2296.registerUpdateReceiver(this, 1);
            }
            if (_chatBubbleFactory == null)
            {
                _chatBubbleFactory = new ChatBubbleFactory(_arg_3, _arg_2, new com.sulake.core.utils.xml.XML(_assets.getAssetByName("roomchat_styles_chatstyles_xml").content));
            }
        }

        public static var chatBubbleFactory(get,never):ChatBubbleFactory;
public static function  get_chatBubbleFactory():ChatBubbleFactory
        {
            return _chatBubbleFactory;
        }


        override public function  get_mainWindow():IWindow
        {
            return this._Str_2496;
        }

        public var config(get,never):IHabboConfigurationManager;
public function  get_config():IHabboConfigurationManager
        {
            return this._configurationManager;
        }

        public var handler(get,never):ChatWidgetHandler;
public function  get_handler():ChatWidgetHandler
        {
            return Std.downcast(_handler , ChatWidgetHandler);
        }

        override public function dispose()
        {
            var k:RoomChatItem = null;
            var _local_2 = 0;
            if (disposed)
            {
                return;
            }
            while (this._Str_4125.length > 0)
            {
                k = this._Str_4125.shift();
            }
            this._Str_2701.dispose();
            this._Str_2701 = null;
            while (this._itemList.length > 0)
            {
                k = this._itemList.shift();
                k.dispose();
            }
            while (this._Str_3107.length > 0)
            {
                k = this._Str_3107.shift();
                k.dispose();
            }
            this._Str_2496.dispose();
            if (this._Str_2296 != null)
            {
                this._Str_2296.removeUpdateReceiver(this);
                this._Str_2296 = null;
            }
            super.dispose();
        }

        public function update(k:UInt)
        {
            var _local_2 = 0;
            if (((flash.Lib.getTimer() > this._Str_10568) && (this._Str_10568 > 0)))
            {
                this._Str_10568 = -1;
                this._Str_22131();
            }
            if (this._gpuMode)
            {
                _local_2 = Std.int((k / _Str_16411) * _Str_17318);
                if ((_local_2 + this._Str_8808) > this._Str_9513)
                {
                    _local_2 = (this._Str_9513 - this._Str_8808);
                }
                if (_local_2 > 0)
                {
                    this._Str_20086(_local_2);
                    this._Str_8808 = (this._Str_8808 + _local_2);
                }
                if (this._Str_8808 >= this._Str_9513)
                {
                    this._Str_9513 = _Str_3729;
                    this._Str_8808 = 0;
                    this._Str_21950();
                    this._Str_19076();
                    this._Str_10568 = (flash.Lib.getTimer() + _Str_13238);
                }
            }
            if (this._Str_2701 != null)
            {
                this._Str_2701.update(k);
            }
        }

        override public function registerUpdateEvents(k:IEventDispatcher)
        {
            if (k == null)
            {
                return;
            }
            k.addEventListener(RoomWidgetChatUpdateEvent.RWCUE_EVENT_CHAT, this.onChatMessage);
            k.addEventListener(_Str_3040.RWRVUE_ROOM_VIEW_SIZE_CHANGED, this.onRoomViewUpdate);
            k.addEventListener(_Str_3040.RWRVUE_ROOM_VIEW_POSITION_CHANGED, this.onRoomViewUpdate);
            k.addEventListener(_Str_3040.RWRVUE_ROOM_VIEW_SCALE_CHANGED, this.onRoomViewUpdate);
            super.registerUpdateEvents(k);
        }

        override public function unregisterUpdateEvents(k:IEventDispatcher)
        {
            if (k == null)
            {
                return;
            }
            k.removeEventListener(RoomWidgetChatUpdateEvent.RWCUE_EVENT_CHAT, this.onChatMessage);
            k.removeEventListener(_Str_3040.RWRVUE_ROOM_VIEW_SIZE_CHANGED, this.onRoomViewUpdate);
            k.removeEventListener(_Str_3040.RWRVUE_ROOM_VIEW_POSITION_CHANGED, this.onRoomViewUpdate);
            k.removeEventListener(_Str_3040.RWRVUE_ROOM_VIEW_SCALE_CHANGED, this.onRoomViewUpdate);
        }

        function onChatMessage(k:RoomWidgetChatUpdateEvent)
        {
            if ((RoomEnterEffect.isRunning() && (!(k.chatType == RoomWidgetChatUpdateEvent.CHAT_TYPE_WHISPER))))
            {
                return;
            }
            var _local_2= new RoomChatItem(this, windowManager, assets, this._Str_22070(), localizations, this._baseUrl);
            _local_2._Str_13182(k);
            this.addChatItem(_local_2);
        }

        public function addChatMessage(k:String, _arg_2:String, _arg_3:Int, _arg_4:BitmapData, _arg_5:UInt, _arg_6:Bool)
        {
            var _local_7= new RoomChatItem(this, windowManager, assets, this._Str_22070(), localizations, this._baseUrl);
            _local_7.message = k;
            _local_7.senderName = _arg_2;
            _local_7._Str_7368 = _arg_3;
            _local_7._Str_25766 = _arg_4;
            _local_7._Str_23108 = _arg_5;
            if (_arg_6)
            {
                _local_7.chatType = RoomWidgetChatUpdateEvent.CHAT_TYPE_NOTIFY;
            }
            _local_7._Str_13126();
            this.addChatItem(_local_7);
        }

        function addChatItem(k:RoomChatItem)
        {
            if (this._Str_7184 != 1)
            {
                k._Str_7368 = (k._Str_7368 / this._Str_7184);
            }
            k._Str_7368 = (k._Str_7368 - this._Str_7165.x);
            this._Str_14645(k);
            this._Str_3107.push(k);
            this._Str_19076();
        }

        function onRoomViewUpdate(k:_Str_3040)
        {
            var _local_2= k.rect;
            if (k.scale > 0)
            {
                if (this._Str_16304 == 0)
                {
                    this._Str_16304 = k.scale;
                }
                else
                {
                    this._Str_7184 = (k.scale / this._Str_16304);
                }
            }
            if (k._Str_17974 != null)
            {
                this._Str_7165.x = (this._Str_7165.x + (k._Str_17974.x / this._Str_7184));
                this._Str_7165.y = (this._Str_7165.y + (k._Str_17974.y / this._Str_7184));
            }
            if (k.rect != null)
            {
                if (this._Str_2701 == null)
                {
                    return;
                }
                this._Str_2496.width = Std.int(_local_2.width);
                this._Str_2496.height = Std.int(this._Str_3991 + this._Str_2701._Str_22103);
                this._Str_4396.width = Std.int(this._Str_2496.width - this._Str_2701._Str_10683);
                this._Str_4396.height = this._Str_3991;
                this._Str_4396.x = this._Str_2496.x;
                this._Str_4396.y = this._Str_2496.y;
                this._Str_3454.width = Std.int(this._Str_2496.width - this._Str_2701._Str_10683);
                this._Str_3454.height = this._Str_3991;
                if (this._Str_3910())
                {
                    this._Str_20247();
                }
                this._Str_2701.containerResized(this._Str_2496.rectangle, true);
            }
            this._Str_12615();
        }

        function _Str_19076()
        {
            if (this._gpuMode)
            {
                return;
            }
            if (this._Str_3107.length == 0)
            {
                return;
            }
            while (((this._Str_3107.length > _Str_17488) || (this._Str_3910() && (this._Str_3107.length > 0))))
            {
                this._Str_20317();
            }
            var k = false;
            if (this._itemList.length == 0)
            {
                k = true;
            }
            else
            {
                k = this._Str_16477(this._Str_3107[0]);
            }
            if (k)
            {
                this._Str_20317();
                this._Str_10568 = (flash.Lib.getTimer() + _Str_13238);
            }
            else
            {
                if (((this._itemList.length > 0) && (this._Str_3107.length > 0)))
                {
                    this._Str_9513 = Std.int(this._Str_9323(this._itemList[(this._itemList.length - 1)], this._Str_3107[0]));
                }
                else
                {
                    this._Str_9513 = _Str_3729;
                }
                this._Str_22131();
            }
        }

        function _Str_20317()
        {
            var k:RoomChatItem = null;
            var _local_2:IWindowContainer = null;
            var _local_3 = 0;
            if (this._Str_3107.length == 0)
            {
                return;
            }
            if (this._Str_23927())
            {
                this._Str_8599();
                this._Str_7189();
            }
            if (!this._Str_16477(this._Str_3107[0]))
            {
                this._Str_19863();
                this._Str_20086(Std.int(this._Str_9323(this._itemList[(this._itemList.length - 1)], this._Str_3107[0])));
                if (!this._Str_16477(this._Str_3107[0]))
                {
                    this._Str_3454.height = (this._Str_3454.height + _Str_3729);
                    if (this._Str_2701 != null)
                    {
                        this._Str_2701.containerResized(this._Str_2496.rectangle);
                    }
                }
            }
            k = this._Str_3107.shift();
            if (k != null)
            {
                k._Str_13126();
                _local_2 = k.view;
                if (_local_2 != null)
                {
                    this._Str_3454.addChild(_local_2);
                    k.timeStamp = Std.int(Date.now().getTime());
                    this._itemList.push(k);
                    _local_3 = 0;
                    if (this._itemList.length > 1)
                    {
                        _local_3 = ASCompat.toInt(this._itemList[(this._itemList.length - 2)].screenLevel);
                        if (this._Str_3910())
                        {
                            k.screenLevel = (_local_3 + 1);
                        }
                        else
                        {
                            k.screenLevel = Std.int(_local_3 + Math.max(this._Str_7136, 1));
                        }
                    }
                    else
                    {
                        k.screenLevel = 100;
                    }
                    k.aboveLevels = Std.int(this._Str_7136);
                    if (k.aboveLevels > ((this._Str_11243 + _Str_6970) + 2))
                    {
                        k.aboveLevels = ((this._Str_11243 + _Str_6970) + 2);
                    }
                    this._Str_7136 = 0;
                    this._Str_14645(k);
                    this._Str_19662(k);
                    this._Str_19620(k);
                }
            }
        }

        function _Str_16477(k:RoomChatItem):Bool
        {
            if (this._itemList.length == 0)
            {
                return true;
            }
            var _local_2:RoomChatItem = this._itemList[(this._itemList.length - 1)];
            if (((k == null) || (_local_2 == null)))
            {
                return false;
            }
            if (_local_2.view == null)
            {
                return true;
            }
            if (((this._Str_3454.bottom - ((this._Str_3454.y + _local_2.y) + _local_2.height)) - _Str_6383) <= this._Str_9323(_local_2, k))
            {
                return false;
            }
            return true;
        }

        public function _Str_12615()
        {
            var k = 0;
            var _local_2:RoomChatItem = null;
            var _local_3:IWindowContainer = null;
            if (this._Str_2701 == null)
            {
                return;
            }
            k = (this._itemList.length - 1);
            while (k >= 0)
            {
                _local_2 = this._itemList[k];
                if (_local_2 != null)
                {
                    this._Str_14645(_local_2);
                    this._Str_19662(_local_2);
                }
                k--;
            }
            k = 0;
            while (k < this._itemList.length)
            {
                _local_2 = this._itemList[k];
                if (_local_2 != null)
                {
                    this._Str_19620(_local_2);
                }
                k++;
            }
            k = 0;
            while (k < this._Str_3107.length)
            {
                _local_2 = this._Str_3107[k];
                if (_local_2 != null)
                {
                    this._Str_14645(_local_2);
                }
                k++;
            }
        }

        function _Str_22131()
        {
            if (this._gpuMode)
            {
                return;
            }
            this._Str_19863();
            this._gpuMode = true;
        }

        function _Str_21950()
        {
            this._gpuMode = false;
        }

        function _Str_19863()
        {
            var _local_4:RoomChatItem = null;
            if (this._gpuMode)
            {
                return;
            }
            this._Str_19458();
            this._Str_4125 = new Array<ASAny>();
            var k= Std.int(Date.now().getTime());
            var _local_2 = 0;
            if (this._itemList.length == 0)
            {
                this._Str_7136 = 1;
                return;
            }
            if (this._Str_3910())
            {
                return;
            }
            this._Str_7136++;
            var _local_3= (this._itemList.length - 1);
            while (_local_3 >= 0)
            {
                _local_4 = this._itemList[_local_3];
                if (_local_4.view != null)
                {
                    if ((((_local_4.screenLevel > _Str_6970) || (_local_4.screenLevel == (_local_2 - 1))) || ((k - _local_4.timeStamp) >= _Str_17591)))
                    {
                        _local_4.timeStamp = k;
                        _local_2 = _local_4.screenLevel;
                        _local_4.screenLevel--;
                        this._Str_4125.push(_local_4);
                    }
                }
                _local_3--;
            }
        }

        function _Str_20086(k:Int)
        {
            var _local_3 = false;
            if (this._Str_4125 == null)
            {
                return;
            }
            if (this._Str_4125.length == 0)
            {
                return;
            }
            var _local_2:RoomChatItem = null;
            var _local_4= -1;
            var _local_5= (this._Str_4125.length - 1);
            while (_local_5 >= 0)
            {
                _local_2 = this._Str_4125[_local_5];
                if (_local_2 != null)
                {
                    if (_local_4 == -1)
                    {
                        _local_4 = this._itemList.indexOf(_local_2);
                    }
                    else
                    {
                        _local_4++;
                    }
                    _local_3 = true;
                    if (this._Str_3910())
                    {
                        if (((_local_2.y - k) + _local_2.height) < 0)
                        {
                            _local_3 = false;
                        }
                    }
                    if (_local_4 > 0)
                    {
                        if (this._itemList[(_local_4 - 1)].view != null)
                        {
                            if (((_local_2.y - k) - ASCompat.toNumber(this._itemList[(_local_4 - 1)].y)) < this._Str_9323(this._itemList[(_local_4 - 1)], _local_2))
                            {
                                _local_3 = false;
                            }
                        }
                    }
                    if (_local_3)
                    {
                        _local_2.y = (_local_2.y - k);
                    }
                }
                _local_5--;
            }
        }

        function _Str_14645(k:RoomChatItem)
        {
            var _local_9 = Math.NaN;
            var _local_10 = Math.NaN;
            if (((k == null) || (this._Str_2701 == null)))
            {
                return;
            }
            var _local_2= ((k._Str_7368 + this._Str_7165.x) * this._Str_7184);
            var _local_3= (_local_2 - (k.width / 2));
            var _local_4= (_local_3 + k.width);
            var _local_5= (((-this._Str_2496.width / 2) - _Str_12991) + this._Str_24033);
            var _local_6= ((((this._Str_2496.width / 2) + _Str_12991) - this._Str_2701._Str_10683) - this._Str_25154);
            var _local_7= ((_local_3 >= _local_5) && (_local_3 <= _local_6));
            var _local_8= ((_local_4 >= _local_5) && (_local_4 <= _local_6));
            if ((_local_7 && _local_8))
            {
                _local_9 = _local_3;
                _local_10 = _local_9;
            }
            else
            {
                if (_local_2 >= 0)
                {
                    _local_9 = (_local_6 - k.width);
                }
                else
                {
                    _local_9 = _local_5;
                }
            }
            k.x = ((_local_9 + (this._Str_2496.width / 2)) + this._Str_2496.x);
            if (((_local_2 < _local_5) || (_local_2 > _local_6)))
            {
                k._Str_22279();
            }
            else
            {
                k._Str_23410((_local_3 - _local_9));
            }
        }

        function _Str_19662(k:RoomChatItem)
        {
            var _local_2 = 0;
            var _local_3 = Math.NaN;
            var _local_4 = Math.NaN;
            if (k != null)
            {
                _local_2 = this._itemList.indexOf(k);
                _local_3 = (this._Str_3910() ? 0 : this._Str_7136);
                if (_local_2 == (this._itemList.length - 1))
                {
                    k.y = ((this._Str_23166() - ((_local_3 + 1) * _Str_3729)) - _Str_6383);
                }
                else
                {
                    _local_4 = ASCompat.toNumber(this._itemList[(_local_2 + 1)].aboveLevels);
                    if (_local_4 < 2)
                    {
                        k.y = ASCompat.toNumber(ASCompat.toNumber(this._itemList[(_local_2 + 1)].y) - this._Str_9323(k, this._itemList[(_local_2 + 1)]));
                    }
                    else
                    {
                        k.y = ASCompat.toNumber(ASCompat.toNumber(this._itemList[(_local_2 + 1)].y) - (_local_4 * _Str_3729));
                    }
                }
            }
        }

        function _Str_19620(k:RoomChatItem)
        {
            if (k != null)
            {
                if (k.y < -_Str_11054)
                {
                    if (k.view != null)
                    {
                        this._Str_3454.removeChild(k.view);
                        k.hideView();
                    }
                }
                else
                {
                    if (k.view == null)
                    {
                        k._Str_13126();
                        if (k.view != null)
                        {
                            this._Str_3454.addChild(k.view);
                        }
                    }
                }
            }
        }

        public function _Str_17890():Int
        {
            var k:RoomChatItem = null;
            var _local_2 = 0;
            var _local_3 = 0;
            while (_local_3 < this._itemList.length)
            {
                k = this._itemList[_local_3];
                if (k != null)
                {
                    if (_local_3 == 0)
                    {
                        _local_2 = (_local_2 + _Str_3729);
                    }
                    else
                    {
                        _local_2 = Std.int(_local_2 + this._Str_9323(this._itemList[(_local_3 - 1)], k));
                    }
                    _local_2 = (_local_2 + ((k.aboveLevels - 1) * _Str_3729));
                }
                _local_3++;
            }
            return _local_2;
        }

        function _Str_23166():Float
        {
            if (this._Str_3910())
            {
                return this._Str_3454.height;
            }
            return this._Str_3991 + this._Str_2496.y;
        }

        function _Str_9323(k:RoomChatItem, _arg_2:RoomChatItem):Float
        {
            var _local_3= chatBubbleFactory._Str_24902(k._Str_24439);
            if (k._Str_23373(_local_3, _arg_2.x, k.y, _arg_2.width, _arg_2.height))
            {
                return _Str_3729;
            }
            return _Str_18120;
        }

        function _Str_19458()
        {
            var _local_2:RoomChatItem = null;
            if (this._Str_3910())
            {
                return;
            }
            var k = 0;
            var _local_3 = 0;
            while (this._itemList.length > this._Str_19219)
            {
                _local_2 = this._itemList.shift();
                _local_3 = this._Str_4125.indexOf(_local_2);
                if (_local_3 > -1)
                {
                    this._Str_4125.splice(_local_3, 1);
                }
                if (_local_2.view != null)
                {
                    this._Str_3454.removeChild(_local_2.view);
                    _local_2.hideView();
                }
                _local_2.dispose();
                _local_2 = null;
            }
            var _local_4 = false;
            k = 0;
            while (k < this._itemList.length)
            {
                _local_2 = this._itemList[k];
                if (_local_2 != null)
                {
                    if (_local_2.y <= -_Str_11054)
                    {
                        _local_2.aboveLevels = 1;
                        if (_local_2.view != null)
                        {
                            _local_3 = this._Str_4125.indexOf(_local_2);
                            if (_local_3 > -1)
                            {
                                this._Str_4125.splice(_local_3, 1);
                            }
                            this._Str_3454.removeChild(_local_2.view);
                            _local_2.hideView();
                        }
                    }
                    else
                    {
                        _local_4 = true;
                        break;
                    }
                }
                k++;
            }
            if (this._Str_3107.length > 0)
            {
                _local_4 = true;
            }
            if ((((this._Str_17890() > _Str_3729) && (!_local_4)) && (!this._Str_3910())))
            {
                if (this._Str_2701 != null)
                {
                    this._Str_16224(this._Str_2496.y);
                    this._Str_12615();
                    if (!this._Str_3910())
                    {
                        this._Str_2701._Str_18199();
                    }
                    if (!this._Str_17277())
                    {
                        this._Str_2701.visible = true;
                    }
                }
            }
            else
            {
                if (this._Str_17277())
                {
                    this._Str_2701.visible = false;
                }
            }
        }

        function _Str_22070():String
        {
            return (("chat_" + Std.string(this._Str_11471)) + "_item_") + Std.string(this._Str_20565++);
        }

        public function _Str_22991(k:Int, _arg_2:String, _arg_3:Int, _arg_4:Int, _arg_5:WindowMouseEvent)
        {
            if (_arg_5.shiftKey)
            {
                if (this._Str_2701 != null)
                {
                    this._Str_2701._Str_24994();
                }
                return;
            }
            var _local_6= new RoomWidgetRoomObjectMessage(RoomWidgetRoomObjectMessage.RWROM_GET_OBJECT_INFO, k, _arg_3);
            messageListener.processWidgetMessage(_local_6);
            var _local_7= new RoomWidgetChatSelectAvatarMessage(RoomWidgetChatSelectAvatarMessage.RWCSAM_MESSAGE_SELECT_AVATAR, k, _arg_2, _arg_4);
            messageListener.processWidgetMessage(_local_7);
        }

        public function _Str_24206(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:WindowMouseEvent)
        {
            if (this._Str_17277())
            {
                return;
            }
            if (this._Str_2701 != null)
            {
                this._Str_2701._Str_19757(_arg_4.stageY, true);
            }
        }

        public function _Str_22868(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:WindowMouseEvent)
        {
        }

        public function _Str_25858(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:WindowMouseEvent)
        {
        }

        public function onPulldownMouseDown(k:WindowMouseEvent)
        {
            if (this._Str_2701 != null)
            {
                this._Str_2701._Str_19757(k.stageY, true);
            }
        }

        public function _Str_24607(k:WindowMouseEvent)
        {
            if (this._Str_2701 != null)
            {
                this._Str_2701._Str_7189();
            }
        }

        public function _Str_23426(k:Float)
        {
            var _local_2= ((this._Str_2496.bottom + k) - RoomChatHistoryPulldown.PULLDOWN_WINDOW_HEIGHT);
            this._Str_16224(_local_2);
        }

        public function _Str_16224(k:Float)
        {
            var _local_2= ((this._Str_2496.context.getDesktopWindow().height - RoomChatHistoryPulldown.PULLDOWN_WINDOW_HEIGHT) - _Str_18228);
            k = Math.min(k, _local_2);
            this._Str_3991 = Std.int(k - this._Str_2496.y);
            this._Str_2496.height = (this._Str_3991 + RoomChatHistoryPulldown.PULLDOWN_WINDOW_HEIGHT);
            if (this._Str_2701 != null)
            {
                this._Str_2701.containerResized(this._Str_2496.rectangle);
            }
        }

        public function _Str_8599(k:Bool=true)
        {
            if (this._Str_2701 == null)
            {
                return;
            }
            this._Str_21950();
            this._Str_3991 = (this._Str_8959 + _Str_6383);
            this._Str_2496.height = Std.int(this._Str_3991 + this._Str_2701._Str_22103);
            this._Str_4396.width = Std.int(this._Str_2496.width - this._Str_2701._Str_10683);
            this._Str_4396.height = this._Str_3991;
            this._Str_3454.width = Std.int(this._Str_2496.width - this._Str_2701._Str_10683);
            if (this._Str_3910())
            {
                this._Str_3454.height = (this._Str_17890() + _Str_6383);
            }
            else
            {
                this._Str_3454.height = this._Str_3991;
            }
            this._Str_4396.scrollV = 1;
            if (!this._Str_3910())
            {
                this._Str_2701.containerResized(this._Str_2496.rectangle);
            }
            this._Str_19458();
            if ((this._Str_3910() || k))
            {
                this._Str_12615();
            }
        }

        function _Str_3910():Bool
        {
            return (this._Str_2701 == null) ? false : this._Str_2701.active;
        }

        function _Str_17277():Bool
        {
            return (this._Str_2701 == null) ? false : this._Str_2701.visible;
        }

        public function _Str_7189()
        {
            if (this._Str_2701 != null)
            {
                this._Str_2701._Str_7189();
            }
        }

        function _Str_23927():Bool
        {
            return this._Str_4396.height <= 1;
        }

        public function _Str_23995()
        {
            var _local_4:RoomChatItem = null;
            var k = 0;
            var _local_2 = 0;
            while (_local_2 < this._itemList.length)
            {
                _local_4 = this._itemList[_local_2];
                if (_local_4.y > k)
                {
                    k = Std.int(_local_4.y);
                }
                _local_2++;
            }
            _local_2 = 0;
            while (_local_2 < this._Str_3107.length)
            {
                _local_4 = this._Str_3107[_local_2];
                if (_local_4.y > k)
                {
                    k = Std.int(_local_4.y);
                }
                _local_2++;
            }
            k = (k + _Str_11054);
            k = ((k < 0) ? 0 : k);
            var _local_3= this._Str_2496.bottom;
            this._Str_16224((this._Str_2496.top + k));
            _local_3 = (_local_3 - this._Str_2496.bottom);
            if (Math.abs(_local_3) < RoomChatHistoryViewer._Str_14515)
            {
                this._Str_8599();
                return;
            }
            _local_2 = 0;
            while (_local_2 < this._itemList.length)
            {
                _local_4 = this._itemList[_local_2];
                _local_4.y = (_local_4.y + _local_3);
                _local_2++;
            }
            _local_2 = 0;
            while (_local_2 < this._Str_3107.length)
            {
                _local_4 = this._Str_3107[_local_2];
                _local_4.y = (_local_4.y + _local_3);
                _local_2++;
            }
            this._Str_17185 = true;
        }

        public function _Str_20437()
        {
            this._Str_4396.stopDragging();
            var k:Float = (this._Str_2496.bottom - RoomChatHistoryPulldown.PULLDOWN_WINDOW_HEIGHT);
            if (k < this._Str_8959)
            {
                if (k <= (this._Str_3991 + this._Str_2496.y))
                {
                    if (this._Str_3910())
                    {
                        this._Str_7189();
                    }
                    this._Str_8599();
                    return;
                }
            }
            if ((this._Str_17185 && (!this._Str_3910())))
            {
                this._Str_8599();
                this._Str_17185 = false;
            }
        }

        public function _Str_20247()
        {
            if (this._Str_3910())
            {
                this._Str_3454.height = (this._Str_17890() + _Str_6383);
                this._Str_12615();
            }
        }

        public function _Str_25376()
        {
            var _local_2 = 0;
            var k:RoomChatItem = null;
            _local_2 = 0;
            while (_local_2 < this._itemList.length)
            {
                k = this._itemList[_local_2];
                k._Str_16939();
                _local_2++;
            }
            _local_2 = 0;
            while (_local_2 < this._Str_3107.length)
            {
                k = this._Str_3107[_local_2];
                k._Str_16939();
                _local_2++;
            }
        }

        public function _Str_25298()
        {
            var _local_2 = 0;
            var k:RoomChatItem = null;
            _local_2 = 0;
            while (_local_2 < this._itemList.length)
            {
                k = this._itemList[_local_2];
                k._Str_22093();
                _local_2++;
            }
            _local_2 = 0;
            while (_local_2 < this._Str_3107.length)
            {
                k = this._Str_3107[_local_2];
                k._Str_22093();
                _local_2++;
            }
        }

        public var isGameSession(get,never):Bool;
public function  get_isGameSession():Bool
        {
            return this.handler.container.roomSession.isGameSession;
        }

        public function removeItem(k:RoomChatItem)
        {
            var _local_2 = 0;
            _local_2 = this._itemList.indexOf(k);
            if (_local_2 > -1)
            {
                this._itemList.splice(_local_2, 1);
            }
            _local_2 = this._Str_4125.indexOf(k);
            if (_local_2 > -1)
            {
                this._Str_4125.splice(_local_2, 1);
            }
            if (k.view != null)
            {
                this._Str_3454.removeChild(k.view);
                k.hideView();
            }
            k.dispose();
            this._Str_8599(false);
        }
    }

