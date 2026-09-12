package com.sulake.habbo.ui.widget.roomtools
;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.ui.handler.RoomToolsWidgetHandler;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.communication.messages.incoming.navigator.GuestRoomData;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;

     class RoomToolsHistory 
    {
        static inline final _Str_5133= 5;
        static inline final _Str_2942= 2;

        var _windowManager:IHabboWindowManager;
        var _assets:IAssetLibrary;
        var _window:IWindowContainer;
        var _handler:RoomToolsWidgetHandler;
        var _items:Vector<IWindowContainer>;

        public function new(k:IHabboWindowManager, _arg_2:IAssetLibrary, _arg_3:RoomToolsWidgetHandler)
        {
            this._items = new Vector<IWindowContainer>();
            this._handler = _arg_3;
            this._assets = _arg_2;
            this._windowManager = k;
            this._window = Std.downcast(k.buildFromXML(((_arg_2.getAssetByName("room_tools_history_xml").content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
        }

        public function populate(k:Vector<GuestRoomData>)
        {
            var _local_2:IWindow = null;
            var _local_3:GuestRoomData = null;
            var _local_4:IWindowContainer = null;
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_3  = _tmp_;
                _local_4 = Std.downcast(this._windowManager.buildFromXML(((this._assets.getAssetByName("room_tools_history_item_xml").content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
                this._window.addChild(_local_4);
                _local_4.findChildByName("room_name").caption = _local_3.roomName;
                if (_local_2 != null)
                {
                    _local_4.y = (_local_2.bottom + _Str_2942);
                }
                else
                {
                    _local_4.y = _Str_5133;
                }
                _local_4.x = _Str_5133;
                _local_4.id = _local_3.flatId;
                _local_4.procedure = this.onClick;
                _local_2 = _local_4;
                this._items.push(_local_4);
            }
            if (_local_2 != null)
            {
                this._window.height = (_local_2.bottom + (2 * _Str_5133));
            }
        }

        public function dispose()
        {
            var k:IWindowContainer = null;
            final _iter_ = this._items; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                k.procedure = null;
                k.dispose();
            }
            this._items = null;
            this._windowManager = null;
            this._handler = null;
            this._assets = null;
            this._window.dispose();
            this._window = null;
        }

        function onClick(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this._handler.goToPrivateRoom(_arg_2.id);
        }

        public var window(get,never):IWindowContainer;
public function  get_window():IWindowContainer
        {
            return this._window;
        }
    }

