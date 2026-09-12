package com.sulake.habbo.ui
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window._enum.WindowParam;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.runtime.IHabboConfigurationManager;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
    import flash.geom.Rectangle;
    import com.sulake.core.window.components.IDisplayObjectWrapper;
    import com.sulake.habbo.android.AndroidDesktopLayout;

     class DesktopLayoutManager 
    {
        static inline final ROOM_VIEW= "room_view";
        static inline final ROOM_NEW_CHAT= "room_new_chat";
        static inline final ROOM_WIDGET= "room_widget";
        static inline final BOTTOM_MARGIN= 47;

        var _layoutContainer:IWindowContainer;
        var _androidLayout:AndroidDesktopLayout;

        public function new()
        {
            this._androidLayout = AndroidDesktopLayout.create();
        }

        public function dispose()
        {
            if (this._androidLayout != null)
            {
                this._androidLayout.dispose();
                this._androidLayout = null;
            }
            if (this._layoutContainer != null)
            {
                this._layoutContainer.dispose();
            }
        }

        public function setLayout(k:com.sulake.core.utils.xml.XML, _arg_2:IHabboWindowManager, _arg_3:IHabboConfigurationManager)
        {
            var _local_5:IWindow = null;
            var _local_7 = 0;
            if (((k == null) || (_arg_2 == null)))
            {
                throw new ASError("Unable to set room desktop layout.");
            }
            this._layoutContainer = Std.downcast(_arg_2.buildFromXML(k, 0) , IWindowContainer);
            if (this._layoutContainer == null)
            {
                throw new ASError("Failed to build layout from XML.");
            }
            this._layoutContainer.width = this._layoutContainer.desktop.width;
            this._layoutContainer.height = this._layoutContainer.desktop.height;
            var _local_4:IWindowContainer = this._layoutContainer.desktop ;
            _local_4.addChild(this._layoutContainer);
            this._layoutContainer.findChildByTag("room_widget_infostand").y = (this._layoutContainer.findChildByTag("room_widget_infostand").y - BOTTOM_MARGIN);
            var _local_6 = 0;
            while (_local_6 < this._layoutContainer.numChildren)
            {
                _local_5 = this._layoutContainer.getChildAt(_local_6);
                _local_7 = ASCompat.toInt(ASCompat.thisOrDefault(ASCompat.toInt(WindowParam.WINDOW_PARAM_ON_ACCOMMODATE_ALIGN_BOTTOM) , ASCompat.toInt(WindowParam.WINDOW_PARAM_ON_ACCOMMODATE_ALIGN_RIGHT)));
                if (_local_5.testParamFlag(_local_7))
                {
                    _local_5.addEventListener(WindowEvent.WINDOW_EVENT_CHILD_RESIZED, this.trimContainer);
                }
                _local_6++;
            }
        }

        function trimContainer(k:WindowEvent)
        {
            var _local_2= Std.downcast(k.window , IWindowContainer);
            if (_local_2 == null)
            {
                return;
            }
            if (_local_2.numChildren != 1)
            {
                return;
            }
            var _local_3= _local_2.getChildAt(0);
            if (_local_3 == null)
            {
                return;
            }
            _local_2.width = _local_3.width;
            _local_2.height = _local_3.height;
        }

        function getWidgetContainer(k:String, _arg_2:IWindow):IWindowContainer
        {
            var _local_4:String = null;
            var _local_7:IWindowContainer = null;
            var _local_8:IWindowContainer = null;
            if (_arg_2 == null)
            {
                return null;
            }
            if (((k == RoomWidgetEnum.HIGH_SCORE_DISPLAY) || (k == RoomWidgetEnum.WORD_QUIZZ)))
            {
                _local_7 = Std.downcast(this._layoutContainer.getChildByName("background_widgets") , IWindowContainer);
                return _local_7;
            }
            if (k == RoomWidgetEnum.GAMEHALL_BOARD)
            {
                _local_8 = _arg_2.desktop ;
                return _local_8;
            }
            if (k == RoomWidgetEnum.CHAT_INPUT_WIDGET)
            {
                _local_8 = _arg_2.desktop ;
                return _local_8;
            }
            var _local_3= _arg_2.tags;
            var _local_5 = 0;
            while (_local_5 < _local_3.length)
            {
                if (ASCompat.toString(_local_3[_local_5]).indexOf(ROOM_WIDGET) == 0)
                {
                    _local_4 = ASCompat.asString(_local_3[_local_5] );
                    break;
                }
                _local_5++;
            }
            if (_local_4 == null)
            {
                return null;
            }
            var _local_6= Std.downcast(this._layoutContainer.getChildByTag(_local_4) , IWindowContainer);
            return _local_6;
        }

        public function addWidgetWindow(k:String, _arg_2:IWindow):Bool
        {
            if (_arg_2 == null)
            {
                return false;
            }
            if (((this._androidLayout != null) && this._androidLayout.addWidget(k, _arg_2)))
            {
                return true;
            }
            var _local_3= this.getWidgetContainer(k, _arg_2);
            if (_local_3 == null)
            {
                return false;
            }
            if (k == RoomWidgetEnum.CHAT_INPUT_WIDGET)
            {
                _local_3.addChild(_arg_2);
                return true;
            }
            if (k == RoomWidgetEnum.GAMEHALL_BOARD)
            {
                _arg_2.x = 0;
                _arg_2.y = 0;
                _local_3.addChild(_arg_2);
                _arg_2.activate();
                return true;
            }
            _arg_2.x = 0;
            _arg_2.y = 0;
            _local_3.addChild(_arg_2);
            _local_3.width = _arg_2.width;
            _local_3.height = _arg_2.height;
            return true;
        }

        public function removeWidgetWindow(k:String, _arg_2:IWindow)
        {
            if (((this._androidLayout != null) && this._androidLayout.removeWidget(k, _arg_2)))
            {
                return;
            }
            var _local_3= this.getWidgetContainer(k, _arg_2);
            if (_local_3 != null)
            {
                _local_3.removeChild(_arg_2);
            }
        }

        public function addRoomView(k:IWindow):Bool
        {
            if (k == null)
            {
                return false;
            }
            var _local_2= Std.downcast(this._layoutContainer.getChildByTag(ROOM_VIEW) , IWindowContainer);
            if (_local_2 == null)
            {
                return false;
            }
            _local_2.addChild(k);
            return true;
        }

        public var roomViewRect(get,never):Rectangle;
public function  get_roomViewRect():Rectangle
        {
            if (this._layoutContainer == null)
            {
                return null;
            }
            var k= Std.downcast(this._layoutContainer.findChildByTag(ROOM_VIEW) , IWindowContainer);
            if (k == null)
            {
                return null;
            }
            var _local_2= k.rectangle;
            if (_local_2 == null)
            {
                return null;
            }
            _local_2.offset(this._layoutContainer.x, this._layoutContainer.y);
            return _local_2;
        }

        public function getRoomView():IWindow
        {
            if (this._layoutContainer == null)
            {
                return null;
            }
            var k= Std.downcast(this._layoutContainer.findChildByTag(ROOM_VIEW) , IWindowContainer);
            if (((!(k == null)) && (k.numChildren > 0)))
            {
                return k.getChildAt(0);
            }
            return null;
        }

        public function getChatContainer():IDisplayObjectWrapper
        {
            if (this._layoutContainer == null)
            {
                return null;
            }
            return Std.downcast(this._layoutContainer.findChildByTag(ROOM_NEW_CHAT) , IDisplayObjectWrapper);
        }
    }

