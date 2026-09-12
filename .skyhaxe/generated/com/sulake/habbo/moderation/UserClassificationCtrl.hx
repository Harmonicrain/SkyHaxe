package com.sulake.habbo.moderation
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.IWindowContainer;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.userclassification.UserClassificationData;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.habbo.moderation._str_556._Str_10411;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;

     class UserClassificationCtrl implements IDisposable implements  ITrackedWindow 
    {
        static var _Str_8819:Array<ASAny> = [];
        static var _Str_16643:Int = 200;

        var _main:ModerationManager;
        var _frame:IFrameWindow;
        var _list:IItemListWindow;
        var _classificationType:Int = 0;
        var _classifications:Array<ASAny>;
        var _disposed:Bool = false;
        var _row:IWindowContainer;
        var _resizeTimer:Timer;
        var _classificationRows:Array<ASAny>;

        public function new(k:ModerationManager, _arg_2:Int)
        {
            this._classificationRows = [];
            this._main = k;
            this._classificationType = _arg_2;
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
            this._main.moderationMessageHandler.addUserClassificationListener(this);
            this._frame = cast(this._main.getXmlWindow("userclassification_frame"), IFrameWindow);
            this._list = cast(this._frame.findChildByName("userclassification_list"), IItemListWindow);
            this._row = Std.downcast(this._list.getListItemAt(0) , IWindowContainer);
            this._list.removeListItems();
            this._frame.procedure = this.onWindow;
            var k= this._frame.findChildByTag("close");
            k.procedure = this.onClose;
        }

        public function _Str_22627(k:Int, _arg_2:Array<ASAny>)
        {
            if (k != this._classificationType)
            {
                return;
            }
            if (this._disposed)
            {
                return;
            }
            this._classifications = _arg_2;
            this._frame.caption = "";
            this.populate();
            this.onResizeTimer(null);
            this._frame.visible = true;
            this._main.moderationMessageHandler.removeUserClassificationListener(this);
        }

        function populate()
        {
            var _local_2:UserClassificationData = null;
            var k= true;
            final _iter_ = this._classifications; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                this.populateRoomRow(_local_2, k);
                k = (!k);
            }
        }

        function populateRoomRow(k:UserClassificationData, _arg_2:Bool)
        {
            var _local_3= this.getRoomRowWindow();
            var _local_4= (_arg_2 ? 0xFFA2D6EA : 0xFFFFFFFF);
            _local_3.color = _local_4;
            var _local_5= _local_3.findChildByName("user_name_txt");
            _local_5.caption = k.username;
            _local_5.color = _local_4;
            var _local_6= cast(_local_3.findChildByName("visit_room_txt"), ITextWindow);
            _local_6.color = _local_4;
            var _local_7= cast(_local_3.findChildByName("user_classification_txt"), ITextWindow);
            _local_7.text = k.classType;
            if (((!(this._main != null)) || (!this._main.isModerator)))
            {
                _local_7.visible = false;
                _local_6.visible = false;
            }
            this._Str_24423(_local_3, this._list);
            if (((this._main != null) && this._main.isModerator))
            {
                new OpenUserInfo(this._frame, this._main, _local_5, k.userId);
                new _Str_10411(this._main, _local_6, k.userId);
            }
        }

        function _Str_24423(k:IWindowContainer, _arg_2:IItemListWindow)
        {
            _arg_2.addListItem(k);
            this._classificationRows.push(k);
        }

        function getRoomRowWindow():IWindowContainer
        {
            if (_Str_8819.length > 0)
            {
                return ASCompat.dynamicAs(_Str_8819.pop() , IWindowContainer);
            }
            return cast(this._row.clone(), IWindowContainer);
        }

        function _Str_25463(k:IWindowContainer)
        {
            var _local_2:IWindow = null;
            var _local_3:IWindow = null;
            if (_Str_8819.length < _Str_16643)
            {
                _local_2 = k.findChildByName("user_name_txt");
                _local_2.procedure = null;
                _local_3 = k.findChildByName("visit_room_txt");
                _local_3.procedure = null;
                k.width = this._row.width;
                k.height = this._row.height;
                _Str_8819.push(k);
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
            final _iter_ = this._classificationRows; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                this._Str_25463(k);
            }
            if (this._row != null)
            {
                this._row.dispose();
                this._row = null;
            }
            this._classificationRows = [];
        }

        public function getType():Int
        {
            return WindowTracker._Str_14197;
        }

        public function getId():String
        {
            return "" + Std.string(this._classificationType);
        }

        public function getFrame():IFrameWindow
        {
            return this._frame;
        }
    }

