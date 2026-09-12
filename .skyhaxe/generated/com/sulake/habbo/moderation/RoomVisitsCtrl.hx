package com.sulake.habbo.moderation
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.IWindowContainer;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import com.sulake.habbo.communication.messages.outgoing.moderator.GetRoomVisitsMessageComposer;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.communication.messages.incoming.moderation.RoomVisitsData;
    import com.sulake.habbo.communication.messages.incoming.moderation.RoomVisitData;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;

     class RoomVisitsCtrl implements IDisposable implements  ITrackedWindow 
    {
        static var ROOM_ROW_POOL:Array<ASAny> = [];
        static var ROOM_ROW_POOL_MAX_SIZE:Int = 200;

        var _main:ModerationManager;
        var _frame:IFrameWindow;
        var _list:IItemListWindow;
        var _userId:Int = 0;
        var _rooms:Array<ASAny>;
        var _disposed:Bool = false;
        var _row:IWindowContainer;
        var _resizeTimer:Timer;
        var _roomRows:Array<ASAny>;

        public function new(k:ModerationManager, _arg_2:Int)
        {
            this._roomRows = [];
            this._main = k;
            this._userId = _arg_2;
        }

        public static function getFormattedTime(k:Int, _arg_2:Int):String
        {
            return (padToTwoDigits(k) + ":") + padToTwoDigits(_arg_2);
        }

        public static function padToTwoDigits(k:Int):String
        {
            return (k < 10) ? ("0" + Std.string(k)) : ("" + Std.string(k));
        }


        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function show()
        {
            this._resizeTimer = new Timer(300, 1);
            this._resizeTimer.addEventListener(TimerEvent.TIMER, (this.onResizeTimer : ASAny));
            this._main.moderationMessageHandler.addRoomVisitsListener(this);
            this._main.connection.send(new GetRoomVisitsMessageComposer(this._userId));
            this._frame = cast(this._main.getXmlWindow("roomvisits_frame"), IFrameWindow);
            this._list = cast(this._frame.findChildByName("visits_list"), IItemListWindow);
            this._row = Std.downcast(this._list.getListItemAt(0) , IWindowContainer);
            this._list.removeListItems();
            this._frame.procedure = this.onWindow;
            var k= this._frame.findChildByTag("close");
            k.procedure = this.onClose;
        }

        public function onRoomVisits(k:RoomVisitsData)
        {
            if (k.userId != this._userId)
            {
                return;
            }
            if (this._disposed)
            {
                return;
            }
            this._rooms = k.rooms;
            this._frame.caption = ("Room visits: " + k.userName);
            this.populate();
            this.onResizeTimer(null);
            this._frame.visible = true;
            this._main.moderationMessageHandler.removeRoomVisitsListener(this);
        }

        public function getType():Int
        {
            return WindowTracker._Str_14197;
        }

        public function getId():String
        {
            return "" + Std.string(this._userId);
        }

        public function getFrame():IFrameWindow
        {
            return this._frame;
        }

        function populate()
        {
            var _local_2:RoomVisitData = null;
            var k= true;
            final _iter_ = this._rooms; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                this.populateRoomRow(_local_2, k);
                k = (!k);
            }
        }

        function populateRoomRow(k:RoomVisitData, _arg_2:Bool)
        {
            var _local_3= this.getRoomRowWindow();
            var _local_4= (_arg_2 ? 0xFFA2D6EA : 0xFFFFFFFF);
            _local_3.color = _local_4;
            var _local_5= _local_3.findChildByName("room_name_txt");
            _local_5.caption = k.roomName;
            new OpenRoomTool(this._frame, this._main, _local_5, k.roomId);
            _local_5.color = _local_4;
            var _local_6= cast(_local_3.findChildByName("time_txt"), ITextWindow);
            _local_6.text = getFormattedTime(k.enterHour, k.enterMinute);
            var _local_7= cast(_local_3.findChildByName("view_room_txt"), ITextWindow);
            new OpenRoomInSpectatorMode(this._main, _local_7, k.roomId);
            _local_7.color = _local_4;
            this.addRoomRowToList(_local_3, this._list);
        }

        function addRoomRowToList(k:IWindowContainer, _arg_2:IItemListWindow)
        {
            _arg_2.addListItem(k);
            this._roomRows.push(k);
        }

        function getRoomRowWindow():IWindowContainer
        {
            if (ROOM_ROW_POOL.length > 0)
            {
                return ASCompat.dynamicAs(ROOM_ROW_POOL.pop() , IWindowContainer);
            }
            return cast(this._row.clone(), IWindowContainer);
        }

        function storeRoomRowWindow(k:IWindowContainer)
        {
            var _local_2:IWindow = null;
            var _local_3:IWindow = null;
            if (ROOM_ROW_POOL.length < ROOM_ROW_POOL_MAX_SIZE)
            {
                _local_2 = k.findChildByName("room_name_txt");
                _local_2.procedure = null;
                _local_3 = k.findChildByName("view_room_txt");
                _local_3.procedure = null;
                k.width = this._row.width;
                k.height = this._row.height;
                ROOM_ROW_POOL.push(k);
            }
            else
            {
                k.dispose();
            }
        }

        function onClose(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this.dispose();
        }

        function onWindow(k:WindowEvent, _arg_2:IWindow)
        {
            if (((!(k.type == WindowEvent.WINDOW_EVENT_RESIZED)) || (!((_arg_2 : ASAny) == (this._frame : ASAny)))))
            {
                return;
            }
            if (!this._resizeTimer.running)
            {
                this._resizeTimer.reset();
                this._resizeTimer.start();
            }
        }

        function onResizeTimer(k:TimerEvent)
        {
            var _local_2= cast(this._list.parent, IWindowContainer);
            var _local_3= _local_2.getChildByName("scroller") ;
            var _local_4:ASAny = (this._list.scrollableRegion.height > this._list.height);
            var _local_5= 17;
            if (_local_3.visible)
            {
                if (!_local_4)
                {
                    _local_3.visible = false;
                    this._list.width = (this._list.width + _local_5);
                }
            }
            else
            {
                if (_local_4)
                {
                    _local_3.visible = true;
                    this._list.width = (this._list.width - _local_5);
                }
            }
        }

        public function dispose()
        {
            var k:IWindowContainer = null;
            if (this._disposed)
            {
                return;
            }
            this._disposed = true;
            if (this._list != null)
            {
                this._list.removeListItems();
                this._list.dispose();
                this._list = null;
            }
            if (this._frame != null)
            {
                this._frame.destroy();
                this._frame = null;
            }
            this._main = null;
            if (this._resizeTimer != null)
            {
                this._resizeTimer.stop();
                this._resizeTimer.removeEventListener(TimerEvent.TIMER, (this.onResizeTimer : ASAny));
                this._resizeTimer = null;
            }
            final _iter_ = this._roomRows; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                this.storeRoomRowWindow(k);
            }
            if (this._row != null)
            {
                this._row.dispose();
                this._row = null;
            }
            this._roomRows = [];
        }
    }

