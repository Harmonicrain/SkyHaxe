package com.sulake.habbo.ui.widget.roomchat
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.components.IScrollbarWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window._enum.WindowType;
    import com.sulake.habbo.window._enum.HabboWindowStyle;
    import com.sulake.core.window._enum.WindowParam;
    import flash.geom.Rectangle;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.toolbar.HabboToolbarEnum;
    import flash.display.DisplayObject;
    import flash.display.Stage;
    import flash.events.MouseEvent;

     class RoomChatHistoryViewer implements IDisposable 
    {
        static inline final _Str_16289= 18;
        static inline final _Str_4906= 20;
        public static inline final _Str_14515= 3;

        var _historyPulldown:RoomChatHistoryPulldown;
        var _historyViewerActive:Bool = false;
        var _historyViewerDragStartY:Float = -1;
        var _scrollbarWindow:IScrollbarWindow;
        var _scrollTarget:Float = 1;
        var _disabled:Bool = false;
        var _widget:RoomChatWidget;
        var _isDisposed:Bool = false;
        var _forcedResize:Bool = false;
        var _hysteresisBlockOn:Bool = false;

        public function new(k:RoomChatWidget, _arg_2:IHabboWindowManager, _arg_3:IWindowContainer, _arg_4:IAssetLibrary)
        {
            this._isDisposed = false;
            this._widget = k;
            this._historyPulldown = new RoomChatHistoryPulldown(k, _arg_2, _arg_3, _arg_4);
            this._historyPulldown.state = RoomChatHistoryPulldown.STATE_HIDDEN;
            var _local_5= Std.downcast(_arg_3.getChildByName("chat_contentlist") , IItemListWindow);
            if (_local_5 == null)
            {
                return;
            }
            _arg_3.removeChild(_local_5);
            _arg_3.addChild(_local_5);
            this._scrollbarWindow = Std.downcast(_arg_2.createWindow("chatscroller", "", WindowType.WINDOW_TYPE_SCROLLBAR_VERTICAL, HabboWindowStyle.NULL, (ASCompat.toInt(WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT )| ASCompat.toInt(WindowParam.WINDOW_PARAM_NULL)), new Rectangle((_arg_3.right - _Str_4906), _arg_3.y, _Str_4906, (_arg_3.height - RoomChatHistoryPulldown.PULLDOWN_WINDOW_HEIGHT)), null, 0) , IScrollbarWindow);
            _arg_3.addChild(this._scrollbarWindow);
            this._scrollbarWindow.visible = false;
            this._scrollbarWindow.scrollable = _local_5 ;
        }

        public var disabled(never,set):Bool;
public function  set_disabled(k:Bool):Bool        {
            return this._disabled = k;
        }

        
        public var visible(get,set):Bool;
public function  set_visible(k:Bool):Bool        {
            if (((this._historyPulldown == null) || this._disabled))
            {
                return k;
            }
            this._historyPulldown.state = (k ? RoomChatHistoryPulldown.STATE_VISIBLE : RoomChatHistoryPulldown.STATE_HIDDEN);
return k;
        }

        public var active(get,never):Bool;
public function  get_active():Bool
        {
            return this._historyViewerActive;
        }

        public var _Str_10683(get,never):Float;
public function  get__Str_10683():Float
        {
            return this._historyViewerActive ? _Str_4906 : 0;
        }

        public var _Str_22103(get,never):Float;
public function  get__Str_22103():Float
        {
            return RoomChatHistoryPulldown.PULLDOWN_WINDOW_HEIGHT;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._isDisposed;
        }
public function  get_visible():Bool
        {
            if (this._historyPulldown == null)
            {
                return false;
            }
            return (this._historyPulldown.state == RoomChatHistoryPulldown.STATE_VISIBLE) || (this._historyPulldown.state == RoomChatHistoryPulldown.STATE_FADE_IN);
        }

        public function dispose()
        {
            this._Str_7189();
            if (this._scrollbarWindow != null)
            {
                this._scrollbarWindow.dispose();
                this._scrollbarWindow = null;
            }
            if (this._historyPulldown != null)
            {
                this._historyPulldown.dispose();
                this._historyPulldown = null;
            }
            this._isDisposed = true;
        }

        public function update(k:UInt)
        {
            if (this._historyPulldown != null)
            {
                this._historyPulldown.update(k);
            }
            this._Str_17156();
        }

        public function _Str_24994()
        {
            if (this._historyViewerActive)
            {
                this._Str_7189();
            }
            else
            {
                this._Str_18199();
            }
        }

        public function _Str_7189()
        {
            this._scrollTarget = 1;
            this._Str_21402();
            this._historyViewerActive = false;
            this._Str_20323(false);
            this._historyPulldown.state = RoomChatHistoryPulldown.STATE_HIDDEN;
            if (this._widget != null)
            {
                this._widget._Str_8599();
                this._widget._Str_25376();
                this._widget.handler.container.toolbar.extensionView.extraMargin = 0;
            }
        }

        public function _Str_18199()
        {
            var k:RoomChatItem = null;
            var _local_2 = 0;
            var _local_3:IWindowContainer = null;
            if (((!this._historyViewerActive) && (!this._disabled)))
            {
                this._historyViewerActive = true;
                this._Str_20323(true);
                this._historyPulldown.state = RoomChatHistoryPulldown.STATE_VISIBLE;
                if (this._widget != null)
                {
                    this._widget._Str_20247();
                    this._widget._Str_25298();
                }
            }
        }

        function _Str_20323(k:Bool)
        {
            if (this._scrollbarWindow != null)
            {
                this._scrollbarWindow.visible = k;
                if (k)
                {
                    this._scrollbarWindow.scrollV = 1;
                    this._scrollTarget = 1;
                }
                else
                {
                    this._historyViewerActive = false;
                    this._historyViewerDragStartY = -1;
                }
            }
        }

        public function containerResized(k:Rectangle, _arg_2:Bool=false)
        {
            if (this._scrollbarWindow != null)
            {
                this._scrollbarWindow.x = Std.int((k.x + k.width) - this._scrollbarWindow.width);
                this._scrollbarWindow.y = Std.int(k.y);
                this._scrollbarWindow.height = Std.int(k.height - RoomChatHistoryPulldown.PULLDOWN_WINDOW_HEIGHT);
                if (_arg_2)
                {
                    this._scrollbarWindow.scrollV = this._scrollTarget;
                }
            }
            if (this._historyPulldown != null)
            {
                this._historyPulldown.containerResized(k);
            }
        }

        function _Str_24773(k:Float, _arg_2:Bool=false)
        {
            var _local_3 = Math.NaN;
            var _local_4 = Math.NaN;
            var _local_5 = Math.NaN;
            var _local_6 = 0;
            var _local_7 = false;
            var _local_8 = false;
            if (((this._historyViewerDragStartY > 0) && _arg_2))
            {
                if (this._hysteresisBlockOn)
                {
                    if (Math.abs((k - this._historyViewerDragStartY)) > _Str_14515)
                    {
                        this._hysteresisBlockOn = false;
                    }
                    else
                    {
                        return;
                    }
                }
                if (!this._historyViewerActive)
                {
                    this._widget._Str_23995();
                    this._Str_18199();
                    this._Str_17156();
                }
                if (this._historyViewerActive)
                {
                    this._widget.handler.container.toolbar.extensionView.extraMargin = HabboToolbarEnum._Str_18993;
                    this._Str_17156();
                    _local_4 = (this._scrollbarWindow.scrollable.scrollableRegion.height / this._scrollbarWindow.scrollable.visibleRegion.height);
                    _local_5 = ((k - this._historyViewerDragStartY) / this._scrollbarWindow.height);
                    _local_3 = (this._scrollTarget - (_local_5 / _local_4));
                    _local_3 = Math.max(0, _local_3);
                    _local_3 = Math.min(1, _local_3);
                    _local_6 = Std.int(k - this._historyViewerDragStartY);
                    _local_7 = true;
                    _local_8 = true;
                    if (this._scrollbarWindow.scrollV < (1 - (_Str_16289 / this._scrollbarWindow.scrollable.scrollableRegion.height)))
                    {
                        _local_8 = false;
                    }
                    if ((_local_8 || this._forcedResize))
                    {
                        this._widget._Str_23426(_local_6);
                        _local_7 = false;
                        this._scrollTarget = 1;
                        this._scrollbarWindow.scrollV = 1;
                    }
                    if (_local_7)
                    {
                        this._scrollTarget = _local_3;
                    }
                    this._historyViewerDragStartY = k;
                }
            }
            else
            {
                this._historyViewerDragStartY = -1;
            }
        }

        public function _Str_19757(k:Float, _arg_2:Bool=false)
        {
            var _local_3:DisplayObject = null;
            var _local_4:Stage = null;
            if (this._disabled)
            {
                return;
            }
            this._historyViewerDragStartY = k;
            this._forcedResize = _arg_2;
            this._hysteresisBlockOn = true;
            if (this._scrollbarWindow != null)
            {
                this._scrollTarget = this._scrollbarWindow.scrollV;
            }
            if (this._scrollbarWindow != null)
            {
                _local_3 = this._scrollbarWindow.context.getDesktopWindow().getDisplayObject();
                if (_local_3 != null)
                {
                    _local_4 = _local_3.stage;
                    if (_local_4 != null)
                    {
                        _local_4.addEventListener(MouseEvent.MOUSE_MOVE, (this._Str_3983 : ASAny));
                        _local_4.addEventListener(MouseEvent.MOUSE_UP, (this._Str_1703 : ASAny));
                    }
                }
            }
        }

        public function _Str_21402()
        {
            var k:DisplayObject = null;
            var _local_2:Stage = null;
            this._historyViewerDragStartY = -1;
            if (this._scrollbarWindow != null)
            {
                k = this._scrollbarWindow.context.getDesktopWindow().getDisplayObject();
                if (k != null)
                {
                    _local_2 = k.stage;
                    if (_local_2 != null)
                    {
                        _local_2.removeEventListener(MouseEvent.MOUSE_MOVE, (this._Str_3983 : ASAny));
                        _local_2.removeEventListener(MouseEvent.MOUSE_UP, (this._Str_1703 : ASAny));
                    }
                }
            }
        }

        function _Str_17156()
        {
            if (!this._historyViewerActive)
            {
                return;
            }
            if (this._historyViewerDragStartY < 0)
            {
                return;
            }
            if (this._forcedResize)
            {
                return;
            }
            var k= (this._scrollTarget - this._scrollbarWindow.scrollV);
            if (k == 0)
            {
                return;
            }
            if (Math.abs(k) < 0.01)
            {
                this._scrollbarWindow.scrollV = this._scrollTarget;
            }
            else
            {
                this._scrollbarWindow.scrollV = (this._scrollbarWindow.scrollV + (k / 2));
            }
        }

        function _Str_1703(k:MouseEvent)
        {
            this._Str_21402();
            if (this._widget != null)
            {
                this._widget._Str_20437();
            }
        }

        function _Str_3983(k:MouseEvent)
        {
            this._Str_24773(k.stageY, k.buttonDown);
        }
    }

