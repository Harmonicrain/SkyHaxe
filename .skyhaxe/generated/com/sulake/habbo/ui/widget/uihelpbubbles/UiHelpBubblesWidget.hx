package com.sulake.habbo.ui.widget.uihelpbubbles
;
    import com.sulake.habbo.ui.widget.RoomWidgetBase;
    import com.sulake.core.runtime.events.ILinkEventTracker;
    import com.sulake.core.runtime.Component;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.toolbar.IHabboToolbar;
    import com.sulake.habbo.friendbar.view.IHabboFriendBarView;
    import com.sulake.habbo.ui.widget.roomtools.RoomToolsWidget;
    import com.sulake.habbo.ui.widget.chatinput.RoomChatInputWidget;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.ui.IRoomDesktop;
    import flash.geom.Rectangle;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window._enum.Direction;
    import flash.geom.Point;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetScriptProceedMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;

     class UiHelpBubblesWidget extends RoomWidgetBase implements ILinkEventTracker
    {
        var _component:Component;
        var _bubbles:Map;
        var _toolBar:IHabboToolbar;
        var _friendBar:IHabboFriendBarView;
        var _roomTools:RoomToolsWidget;
        var _chatInput:RoomChatInputWidget;
        var _bubblesToShow:Array<ASAny>;
        var _bubbleIndex:Int = 0;
        var _localization:IHabboLocalizationManager;

        public function new(k:IRoomWidgetHandler, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary, _arg_4:IHabboLocalizationManager, _arg_5:IHabboFriendBarView, _arg_6:IHabboToolbar, _arg_7:IRoomDesktop, _arg_8:Component)
        {
            super(k, _arg_2, _arg_3, _arg_4);
            this._component = _arg_8;
            this._friendBar = _arg_5;
            this._toolBar = _arg_6;
            this._bubbles = new Map();
            this._localization = _arg_4;
            this._bubblesToShow = [];
            if (_arg_7 != null)
            {
                this._roomTools = Std.downcast(_arg_7.getWidget(RoomWidgetEnum.ROOM_TOOLS) , RoomToolsWidget);
                this._chatInput = Std.downcast(_arg_7.getWidget(RoomWidgetEnum.CHAT_INPUT_WIDGET) , RoomChatInputWidget);
            }
            ASCompat.reinterpretAs(_arg_2 , Component).context.addLinkEventTracker(this);
        }

        override public function dispose()
        {
            var k:_Str_4171 = null;
            if (disposed)
            {
                return;
            }
            if (this._bubbles != null)
            {
                final _iter_ = this._bubbles; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
                {
k  = _tmp_;
                    k.dispose();
                    k = null;
                }
                this._bubbles.dispose();
                this._bubbles = null;
                this._bubblesToShow = null;
            }
            super.dispose();
        }

        function _Str_15620(k:_Str_4171, _arg_2:Bool=false):Rectangle
        {
            var _local_8:Rectangle = null;
            var _local_9:IWindowContainer = null;
            var _local_10:IWindow = null;
            var _local_11:Array<ASAny> = null;
            var _local_12:IWindowContainer = null;
            var _local_13:ITextFieldWindow = null;
            var _local_14:Rectangle = null;
            var _local_15 = 0;
            var _local_16 = 0;
            var _local_17 = 0;
            if (((!(k != null)) || (!(k._Str_5493() != null))))
            {
                return null;
            }
            var _local_3= k.getName();
            if (((_local_3 == "") || (!ASCompat.stringAsBool(_local_3))))
            {
                return null;
            }
            var _local_4= k._Str_5493().height;
            var _local_5= k._Str_5493().width;
            var _local_6= Direction.DOWN;
            var _local_7= -1;
            if (this.toolBar != null)
            {
                _local_10 = this.toolBar._Str_6621(_local_3);
                if (_local_10 != null)
                {
                    _local_8 = new Rectangle();
                    _local_10.getGlobalRectangle(_local_8);
                    k._Str_16079(_local_10);
                }
            }
            if (this._Str_19402 != null)
            {
                if (_local_8 == null)
                {
                    _local_9 = this._Str_19402.getIconLocation(_local_3);
                    if (_local_9 != null)
                    {
                        _local_8 = new Rectangle();
                        _local_9.getGlobalRectangle(_local_8);
                        k._Str_16079(_local_9 );
                    }
                }
            }
            if (_local_8 == null)
            {
                if (this._Str_19331 != null)
                {
                    _local_10 = this._Str_19331.getIconLocation(_local_3);
                    if (_local_10 != null)
                    {
                        _local_8 = new Rectangle();
                        _local_10.getGlobalRectangle(_local_8);
                        k._Str_16079(_local_10);
                    }
                }
            }
            if (_local_8 == null)
            {
                if (((this._Str_20546 != null) && (_local_3 == UiHelpBubbleIconEnum.CHAT_INPUT)))
                {
                    _local_11 = this._Str_20546._Str_23678();
                    if (_local_11.length > 1)
                    {
                        _local_12 = ASCompat.dynamicAs(_local_11[0] , IWindowContainer);
                        _local_13 = ASCompat.dynamicAs(_local_11[1] , ITextFieldWindow);
                    }
                    _local_8 = _local_12.rectangle;
                    if (_local_8 != null)
                    {
                        if ((_arg_2 && (_local_8 != null)))
                        {
                            return _local_8;
                        }
                        _local_8.y = (_local_8.y - (_local_4 - 40));
                        _local_8.x = (_local_8.x + ((_local_8.width / 2) - 10));
                        k._Str_22662(_local_13);
                        k._Str_11739(_local_6, _local_7);
                        return _local_8;
                    }
                }
            }
            if (_local_8 != null)
            {
                if (_arg_2)
                {
                    return _local_8;
                }
                _local_14 = _local_8.clone();
                _local_15 = 15;
                _local_16 = k._Str_5493().desktop.width;
                if ((_local_8.y - (_local_4 + _local_15)) < 50)
                {
                    _local_15 = 0;
                }
                _local_6 = Direction.DOWN;
                _local_7 = 0;
                _local_8.x = (_local_8.x + (_local_8.width / 2));
                _local_8.y = (_local_8.y - (_local_4 + _local_15));
                _local_17 = Std.int(_local_8.right - _local_14.right);
                if (_local_17 >= (_local_5 / 2))
                {
                    _local_17 = Std.int((_local_5 / 2) - 25);
                }
                if (_local_8.y < _local_4)
                {
                    _local_8.y = (_local_8.y + ((_local_8.height + _local_4) + 10));
                    _local_6 = Direction.UP;
                    if (_local_17 <= 30)
                    {
                        _local_17 = Std.int(_local_17 / 3);
                    }
                    _local_7 = _local_17;
                    k._Str_11739(_local_6, _local_7);
                }
                if (_local_8.x < (_local_5 / 2))
                {
                    _local_8.x = 10;
                    _local_7 = Std.int(_local_7 - ((_local_5 / 2) - 30));
                    k._Str_11739(_local_6, _local_7);
                    return _local_8;
                }
                if ((_local_8.x + (_local_5 / 2)) > _local_16)
                {
                    _local_8.x = (_local_16 - (_local_5 / 2));
                    _local_7 = Std.int(_local_5 / 4);
                    k._Str_11739(_local_6, _local_7);
                    return _local_8;
                }
                k._Str_11739(_local_6, _local_7);
            }
            return _local_8;
        }

        public function _Str_17912()
        {
            var _local_5:Point = null;
            if ((((!(this._bubblesToShow != null)) || (this._bubblesToShow.length == 0)) || (this._bubblesToShow.length < (this._bubbleIndex + 1))))
            {
                return;
            }
            var k= ASCompat.dynamicAs(this._bubblesToShow[this._bubbleIndex] , _Str_5419);
            var _local_2:ASAny = (this._bubblesToShow.length > (this._bubbleIndex + 1));
            var _local_3= k.name;
            var _local_4= new _Str_4171(this, k, _local_2);
            if (this._bubbles.hasKey(_local_3))
            {
                this._Str_14683(_local_3);
            }
            var _local_6= this._Str_15620(_local_4);
            this._bubbleIndex++;
            if (_local_6 != null)
            {
                _local_5 = new Point(_local_6.x, _local_6.y);
            }
            if (_local_5 != null)
            {
                _local_4._Str_19842(_local_5);
                _local_4._Str_5493().desktop.addEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this.onDesktopResized);
                _local_4._Str_21122(this._Str_15620(_local_4, true));
                this._Str_25089(_local_3, _local_4);
            }
            else
            {
                _local_4.dispose();
                this._Str_17912();
            }
        }

        function _Str_25089(k:String, _arg_2:_Str_4171)
        {
            if (((!(this._bubbles != null)) || (!(_arg_2 != null))))
            {
                return;
            }
            this._bubbles.add(k, _arg_2);
        }

        public function _Str_14683(k:String)
        {
            if (this._bubbles == null)
            {
                return;
            }
            var _local_2= ASCompat.dynamicAs(this._bubbles.getValue(k) , _Str_4171);
            if (_local_2 == null)
            {
                return;
            }
            this._bubbles.remove(k);
            _local_2.dispose();
            this._Str_17912();
        }

        function onDesktopResized(k:WindowEvent=null)
        {
            var _local_2:_Str_4171 = null;
            var _local_3:Rectangle = null;
            var _local_4:Point = null;
            final _iter_ = this._bubbles; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
            {
_local_2  = _tmp_;
                _local_3 = this._Str_15620(_local_2);
                if (_local_3 != null)
                {
                    _local_4 = new Point(_local_3.x, _local_3.y);
                    _local_2._Str_19842(_local_4);
                    _local_2._Str_21122(this._Str_15620(_local_2, true));
                }
            }
        }

        public function _Str_25030()
        {
            var k:RoomWidgetMessage = new RoomWidgetScriptProceedMessage(RoomWidgetScriptProceedMessage.RWPM_ANSWER);
            if (messageListener != null)
            {
                messageListener.processWidgetMessage(k);
            }
        }

        public var linkPattern(get,never):String;
public function  get_linkPattern():String
        {
            return "helpBubble/";
        }

        public function linkReceived(k:String)
        {
            var _local_4 = 0;
            var _local_5:_Str_5419 = null;
            var _local_6 = 0;
            var _local_7:String = null;
            var _local_8:String = null;
            if (this._bubbles == null)
            {
                this._bubbles = new Map();
            }
            if (this._bubblesToShow == null)
            {
                this._bubblesToShow = [];
            }
            var _local_2:Array<ASAny> = (cast k.split("/"));
            var _local_3= _local_2.length;
            if (_local_3 < 3)
            {
                return;
            }
            if (_local_2[1] == "add")
            {
                _local_4 = 0;
                _local_6 = 2;
                while (_local_6 < _local_3)
                {
                    _local_4++;
                    if (_local_4 == 1)
                    {
                        _local_5 = new _Str_5419();
                        _local_7 = _local_2[_local_6];
                        _local_8 = (UiHelpBubbleIconEnum : ASAny)[_local_7];
                        if (!ASCompat.stringAsBool(_local_8))
                        {
                            _local_8 = _local_7;
                        }
                        _local_5.name = _local_8;
                        _local_5._Str_16803 = true;
                    }
                    if (_local_4 == 2)
                    {
                        _local_5.text = this._localization.getLocalization(_local_2[_local_6], _local_2[_local_6]);
                        _local_4 = 0;
                        this._bubblesToShow.push(_local_5);
                    }
                    _local_6++;
                }
                this._Str_17912();
            }
            else
            {
                if (_local_2[1] == "remove")
                {
                    this._Str_14683(_local_2[2]);
                }
            }
        }

        public var toolBar(get,never):IHabboToolbar;
public function  get_toolBar():IHabboToolbar
        {
            return this._toolBar;
        }

        public var _Str_19402(get,never):IHabboFriendBarView;
public function  get__Str_19402():IHabboFriendBarView
        {
            return this._friendBar;
        }

        public var _Str_19331(get,never):RoomToolsWidget;
public function  get__Str_19331():RoomToolsWidget
        {
            return this._roomTools;
        }

        public var _Str_20546(get,never):RoomChatInputWidget;
public function  get__Str_20546():RoomChatInputWidget
        {
            return this._chatInput;
        }
    }

