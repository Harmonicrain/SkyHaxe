package com.sulake.habbo.notifications.singular
;
    import com.sulake.core.runtime.IUpdateReceiver;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.utils.Map;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.assets.IAsset;
	import com.sulake.habbo.notifications.singular.HabboNotificationItem;
    import com.sulake.habbo.window.IHabboWindowManager;
    import flash.display.BitmapData;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.habbo.session.events.BadgeImageReadyEvent;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.geom.Point;
    import com.sulake.core.window.events.WindowMouseEvent;

     class HabboNotificationItemView implements IUpdateReceiver 
    {
        public static inline final ITEM_HEIGHT= 70;
        public static inline final SIDE_MARGIN= 5;
        static inline final STATE_IDLE= 0;
        static inline final STATE_FADE_IN= 1;
        static inline final STATE_DISPLAY= 2;
        static inline final STATE_FADE_OUT= 3;

        var _window:IWindow;
        var _item:HabboNotificationItem;
        var _hovering:Bool = false;
        var _styleConfig:Map;
        var _viewConfig:Map;
        var _fadeInStart:UInt = 0;
        var _fadeOutStart:UInt = 0;
        var _displayStart:UInt = 0;
        var _margin:Int = 0;
        var _blend:Float = Math.NaN;
        var _resizeMargin:Int = 0;
        var _windowMinHeight:Int = 0;
        var _state:Int = 0;
        var _toggleButtonCallback:ASFunction;
        var _toggleButtonSelected:Bool = false;

        public function new(k:IAsset, _arg_2:IHabboWindowManager, _arg_3:Map, _arg_4:Map, _arg_5:HabboNotificationItem)
        {
            this._styleConfig = _arg_3;
            this._viewConfig = _arg_4;
            var _local_6= Std.downcast(k , XmlAsset);
            if (_local_6 == null)
            {
                return;
            }
            this._window = _arg_2.buildFromXML(((_local_6.content : com.sulake.core.utils.xml.XML) ), 1);
            this._window.tags.push("notificationview");
            this._window.context.getDesktopWindow().addEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this.onRoomViewResized);
            this._window.procedure = this.onWindowEvent;
            this._window.blend = 0;
            this._window.visible = false;
            var _local_7= Std.downcast(cast(this._window, IWindowContainer).findChildByTag("notification_text") , ITextWindow);
            if (_local_7 != null)
            {
                this._resizeMargin = (this._window.height - _local_7.bottom);
            }
            else
            {
                this._resizeMargin = 15;
            }
            this._windowMinHeight = this._window.height;
            this._margin = 4;
            this._blend = 0;
            this._state = STATE_IDLE;
            this.showItem(_arg_5);
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._window == null;
        }

        public var ready(get,never):Bool;
public function  get_ready():Bool
        {
            return this._state == STATE_IDLE;
        }

        public var verticalPosition(get,never):Int;
public function  get_verticalPosition():Int
        {
            return this._margin;
        }

        public var notificationId(get,never):String;
public function  get_notificationId():String
        {
            return this._item != null ? this._item.notificationId : null;
        }

        function showItem(k:HabboNotificationItem)
        {
var button:IButtonWindow  = null;            var _local_3:BitmapData = null;
            if (k == null)
            {
                return;
            }
            var _local_2= k.content;
            this.setNotificationText(_local_2);
            if (k.style._Str_21712 == null)
            {
                _local_3 = k.style.icon;
                this.setNotificationIcon(_local_3);
            }
            else
            {
                cast(cast(this._window, IWindowContainer).findChildByTag("notification_icon_static"), IStaticBitmapWrapperWindow).assetUri = k.style._Str_21712;
            }
            this._item = k;
            if (k.style.styleName == "wired"
                && k.style.extraData != null
                && ASCompat.inOperator("toggle_callback" , k.style.extraData))
            {
                this._toggleButtonCallback = ASCompat.getDynamicProperty(k.style.extraData, "toggle_callback");
button=
                    Std.downcast(cast(this._window, IWindowContainer).findChildByTag("button") , IButtonWindow);
                if (button != null)
                {
                    button.caption = "${notification.stop}";
                    button.visible = true;
                    button.addEventListener(WindowMouseEvent.CLICK, this.onToggleButtonClicked);
                }
            }
            this.reposition();
            this.startFadeIn();
        }

        function onToggleButtonClicked(event:WindowMouseEvent)
        {
            if (this._state != STATE_DISPLAY || this._toggleButtonCallback == null)
            {
                return;
            }
            this._toggleButtonSelected = !this._toggleButtonSelected;
            var button=
                Std.downcast(cast(this._window, IWindowContainer).findChildByTag("button") , IButtonWindow);
            if (button != null)
            {
                button.caption = this._toggleButtonSelected
                    ? "${notification.resume}" : "${notification.stop}";
            }
            this._toggleButtonCallback(this._toggleButtonSelected);
        }

        public function replaceIcon(k:BadgeImageReadyEvent)
        {
            if (k.badgeId != this._item.style._Str_25821)
            {
                return;
            }
            if (k.badgeImage != null)
            {
                this.setNotificationIcon(k.badgeImage);
            }
        }

        public function update(k:UInt)
        {
var displayTime = 0, staysVisible = false;            var _local_2 = Math.NaN;
            var _local_3 = Math.NaN;
            switch (this._state)
            {
                case STATE_IDLE:
                    return;
                case STATE_FADE_IN:
                    this._fadeInStart = (this._fadeInStart + k);
                    _local_2 = (this._fadeInStart / ASCompat.toNumber(this._viewConfig.getValue("time_fade_in")));
                    if (this._fadeInStart > (ASCompat.toInt(this._viewConfig.getValue("time_fade_in")) : UInt))
                    {
                        this.startDisplay();
                    }
                    this.adjustBlend(_local_2);
                    return;
                case STATE_DISPLAY:
                    this._displayStart = (this._displayStart + k);
displayTime= this._item != null
                        && this._item.style.extraData != null
                        && ASCompat.inOperator("time_display" , this._item.style.extraData
)                        ? ASCompat.toInt(ASCompat.getDynamicProperty(this._item.style.extraData, "time_display"))
                        : ASCompat.toInt(this._viewConfig.getValue("time_display"));
staysVisible= this._item != null
                        && this._item.style.extraData != null
                        && ASCompat.inOperator("stay" , this._item.style.extraData);
                    if (((this._displayStart > (displayTime : UInt)) && (!this._hovering) && !staysVisible))
                    {
                        this.startFadeOut();
                    }
                    return;
                case STATE_FADE_OUT:
                    this._fadeOutStart = (this._fadeOutStart + k);
                    _local_3 = (1 - (this._fadeOutStart / ASCompat.toNumber(this._viewConfig.getValue("time_fade_out"))));
                    this.adjustBlend(_local_3);
                    if (this._fadeOutStart > (ASCompat.toInt(this._viewConfig.getValue("time_fade_in")) : UInt))
                    {
                        this.startIdling();
                    }
                    return;
            }
        }

        public function dispose()
        {
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            if (this._item != null)
            {
                this._item.dispose();
                this._item = null;
            }
        }

        function setNotificationText(k:String)
        {
            var _local_2= Std.downcast(cast(this._window, IWindowContainer).findChildByTag("notification_text") , ITextWindow);
            if (((_local_2 == null) || (k == null)))
            {
                return;
            }
            this._window.height = 0;
            _local_2.text = k;
            _local_2.height = Std.int(_local_2.textHeight + this._resizeMargin);
            if (this._window.height < this._windowMinHeight)
            {
                this._window.height = this._windowMinHeight;
            }
        }

        function setNotificationIcon(k:BitmapData)
        {
            var _local_3:BitmapData = null;
            var _local_4 = 0;
            var _local_5 = 0;
            var _local_6 = 0;
            var _local_2= Std.downcast(cast(this._window, IWindowContainer).findChildByTag("notification_icon") , IBitmapWrapperWindow);
            if (_local_2 == null)
            {
                return;
            }
            if (k == null)
            {
                _local_2.bitmap = null;
                return;
            }
            if (((k.width < _local_2.width) && (k.height < _local_2.height)))
            {
                _local_3 = new BitmapData(_local_2.width, _local_2.height, true, 0);
                _local_5 = Std.int((_local_2.width - k.width) / 2);
                _local_6 = Std.int((_local_2.height - k.height) / 2);
                _local_3.copyPixels(k, k.rect, new Point(_local_5, _local_6));
            }
            else
            {
                if (k.width < k.height)
                {
                    _local_3 = new BitmapData(k.height, k.height, true, 0);
                    _local_4 = Std.int((k.height - k.width) / 2);
                    _local_3.copyPixels(k, k.rect, new Point(_local_4, 0));
                }
                else
                {
                    if (k.width > k.height)
                    {
                        _local_3 = new BitmapData(k.width, k.width, true, 0);
                        _local_4 = Std.int((k.width - k.height) / 2);
                        _local_3.copyPixels(k, k.rect, new Point(0, _local_4));
                    }
                    else
                    {
                        _local_3 = new BitmapData(k.width, k.height);
                        _local_3.copyPixels(k, k.rect, new Point(0, 0));
                    }
                }
            }
            _local_2.bitmap = _local_3;
        }

        function startFadeIn()
        {
            this._fadeInStart = 0;
            this._state = STATE_FADE_IN;
            this._window.visible = true;
        }

        function startFadeOut()
        {
            this._fadeOutStart = 0;
            this._state = STATE_FADE_OUT;
        }

        public function remove()
        {
            if (this._window == null || this._state == STATE_IDLE
                || this._state == STATE_FADE_OUT)
            {
                return;
            }
            this._hovering = false;
            this.startFadeOut();
        }

        function startDisplay()
        {
            this._displayStart = 0;
            this._state = STATE_DISPLAY;
        }

        function startIdling()
        {
            this._state = STATE_IDLE;
            this._window.visible = false;
        }

        public function reposition(k:Int=-1)
        {
            if (this._window == null)
            {
                return;
            }
            var _local_2= this._window.context.getDesktopWindow();
            if (_local_2 == null)
            {
                return;
            }
            if (k != -1)
            {
                this._margin = k;
            }
            this._window.x = ((_local_2.width - this._window.width) - SIDE_MARGIN);
            this._window.y = this._margin;
        }

        public function onWindowEvent(k:WindowEvent, _arg_2:IWindow)
        {
            if (k == null)
            {
                return;
            }
            if (k.type == WindowMouseEvent.OVER)
            {
                this._hovering = true;
            }
            else
            {
                if (k.type == WindowMouseEvent.OUT)
                {
                    this._hovering = false;
                }
                else
                {
                    if (k.type == WindowMouseEvent.CLICK)
                    {
                        if (this._item != null)
                        {
                            this._item._Str_25246();
                            if (!(this._item.style.extraData != null
                                && ASCompat.inOperator("stay" , this._item.style.extraData)))
                            {
                                this.startFadeOut();
                            }
                        }
                    }
                }
            }
        }

        function onRoomViewResized(k:WindowEvent)
        {
            this.reposition();
        }

        function adjustBlend(k:Float)
        {
            this._blend = k;
            if (this._blend > 1)
            {
                this._blend = 1;
            }
            if (this._blend < 0)
            {
                this._blend = 0;
            }
            this._window.blend = this._blend;
        }
    }

