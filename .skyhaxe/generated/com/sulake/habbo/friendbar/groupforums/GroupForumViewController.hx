package com.sulake.habbo.friendbar.groupforums
;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.components.ISelectorWindow;
    import com.sulake.habbo.communication.messages.parser.groupforums.ExtendedForumData;
    import com.sulake.core.window.components.ISelectableWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;

     class GroupForumViewController 
    {
        static inline final _Str_13986= 0.5;

        var _controller:GroupForumController;
        var _mainView:GroupForumView;
        var _window:IFrameWindow;
        var _Str_9870:ISelectorWindow;
        var _Str_8356:ISelectorWindow;
        var _Str_9318:ISelectorWindow;
        var _Str_11160:ISelectorWindow;
        var _Str_2381:ExtendedForumData;
        var _Str_6730:Int = 0;
        var _Str_6541:Int = 0;
        var _Str_9497:Int = 0;
        var _Str_9468:Int = 0;

        public function new(k:GroupForumView, _arg_2:Int, _arg_3:Int, _arg_4:ExtendedForumData)
        {
            this._mainView = k;
            this._controller = this._mainView.controller;
            this._Str_2381 = _arg_4;
            this._window = cast(this._controller.windowManager.buildFromXML(new com.sulake.core.utils.xml.XML(Type.createInstance(HabboFriendBarCom.groupforum_forum_settings_xml, []))), IFrameWindow);
            this._window.x = _arg_2;
            var _local_5= this._controller.windowManager.getDesktop(1).width;
            if ((this._window.x + this._window.width) > _local_5)
            {
                this._window.x = (_local_5 - this._window.width);
            }
            this._window.y = _arg_3;
            this._Str_7598();
        }

        static function _Str_4609(k:ISelectorWindow, _arg_2:Int, _arg_3:Int):Int
        {
            var _local_5:ISelectableWindow = null;
            var _local_6:IWindow = null;
            if (_arg_3 < _arg_2)
            {
                _arg_3 = _arg_2;
            }
            var _local_4 = 0;
            while (_local_4 < _arg_2)
            {
                _local_5 = k.getSelectableByName(Std.string(_local_4));
                if (_local_5 != null)
                {
                    _local_5.disable();
                    _local_5.blend = _Str_13986;
                    _local_6 = cast(k.parent, IWindowContainer).findChildByName(("label" + Std.string(_local_4)));
                    if (_local_6 != null)
                    {
                        _local_6.blend = _Str_13986;
                    }
                }
                _local_4++;
            }
            _local_4 = _arg_2;
            while (_local_4 < 4)
            {
                _local_5 = k.getSelectableByName(Std.string(_local_4));
                if (_local_5 != null)
                {
                    _local_5.enable();
                    _local_5.blend = 1;
                    _local_6 = cast(k.parent, IWindowContainer).findChildByName(("label" + Std.string(_local_4)));
                    if (_local_6 != null)
                    {
                        _local_6.blend = 1;
                    }
                    if (_local_4 == _arg_3)
                    {
                        k.setSelected(_local_5);
                    }
                }
                _local_4++;
            }
            return _arg_3;
        }

        static function _Str_6359(k:ISelectorWindow):Int
        {
            var _local_2= k.getSelected();
            if (_local_2 == null)
            {
                return 0;
            }
            return ASCompat.toInt(_local_2.name);
        }


        public function focus(k:ExtendedForumData)
        {
            if (this._Str_2381 != k)
            {
                this._Str_2381 = k;
                this._Str_7598();
            }
            this._window.activate();
        }

        function _Str_7598()
        {
            var k= GroupForumView._Str_14926(this._window, this._Str_2381);
            k.removeEventListener(WindowMouseEvent.CLICK, this._Str_4912);
            k.addEventListener(WindowMouseEvent.CLICK, this._Str_4912);
            var _local_2= this._window.findChildByName("cancel_btn");
            _local_2.removeEventListener(WindowMouseEvent.CLICK, this._Str_4604);
            _local_2.addEventListener(WindowMouseEvent.CLICK, this._Str_4604);
            var _local_3= this._window.findChildByName("header_button_close");
            _local_3.removeEventListener(WindowMouseEvent.CLICK, this._Str_4604);
            _local_3.addEventListener(WindowMouseEvent.CLICK, this._Str_4604);
            var _local_4= this._window.findChildByName("ok_btn");
            _local_4.removeEventListener(WindowMouseEvent.CLICK, this._Str_10704);
            _local_4.addEventListener(WindowMouseEvent.CLICK, this._Str_10704);
            this._Str_9870 = cast(this._window.findChildByName("read_selector"), ISelectorWindow);
            this._Str_9870.addEventListener(WindowMouseEvent.OVER, this._Str_22768);
            this._Str_13970(this._Str_9870);
            this._Str_8356 = cast(this._window.findChildByName("post_message_selector"), ISelectorWindow);
            this._Str_8356.addEventListener(WindowMouseEvent.OVER, this._Str_22910);
            this._Str_13970(this._Str_8356);
            this._Str_9318 = cast(this._window.findChildByName("post_thread_selector"), ISelectorWindow);
            this._Str_9318.addEventListener(WindowMouseEvent.OVER, this._Str_23060);
            this._Str_13970(this._Str_9318);
            this._Str_11160 = cast(this._window.findChildByName("moderate_selector"), ISelectorWindow);
            this._Str_11160.addEventListener(WindowMouseEvent.OVER, this._Str_24316);
            this._Str_13970(this._Str_11160);
            this._Str_6730 = _Str_4609(this._Str_9870, 0, this._Str_2381._Str_24871);
            this._Str_6541 = _Str_4609(this._Str_8356, this._Str_6730, this._Str_2381._Str_25794);
            this._Str_9497 = _Str_4609(this._Str_9318, this._Str_6541, this._Str_2381._Str_24408);
            this._Str_9468 = _Str_4609(this._Str_11160, 2, this._Str_2381._Str_24549);
        }

        public function dispose()
        {
            this._controller._Str_11338 = null;
            this._window.dispose();
            this._window = null;
        }

        function _Str_4912(k:WindowMouseEvent)
        {
            this._controller.context.createLinkEvent(("group/" + Std.string(this._Str_2381.groupId)));
        }

        function _Str_10704(k:WindowMouseEvent)
        {
            this._controller.updateForumSettings(this._Str_2381.groupId, this._Str_6730, this._Str_6541, this._Str_9497, this._Str_9468);
            this.dispose();
        }

        function _Str_4604(k:WindowMouseEvent)
        {
            this.dispose();
        }

        function _Str_13970(k:ISelectorWindow)
        {
            var _local_3:ISelectableWindow = null;
            var _local_2 = 0;
            while ((_local_2 : UInt) < k.numSelectables)
            {
                _local_3 = k.getSelectableAt(_local_2);
                _local_3.removeEventListener(WindowEvent.WINDOW_EVENT_SELECTED, this._Str_20995);
                _local_3.addEventListener(WindowEvent.WINDOW_EVENT_SELECTED, this._Str_20995);
                _local_2++;
            }
        }

        function _Str_20995(k:WindowEvent)
        {
            this._Str_6730 = _Str_6359(this._Str_9870);
            this._Str_6541 = _Str_4609(this._Str_8356, this._Str_6730, _Str_6359(this._Str_8356));
            this._Str_9497 = _Str_4609(this._Str_9318, this._Str_6541, _Str_6359(this._Str_9318));
            this._Str_9468 = _Str_6359(this._Str_11160);
        }

        function _Str_22768(k:WindowMouseEvent)
        {
            this._controller.tracking.trackEventLogOncePerSession("InterfaceExplorer", "hover", "forum.can.read.seen");
        }

        function _Str_22910(k:WindowMouseEvent)
        {
            this._controller.tracking.trackEventLogOncePerSession("InterfaceExplorer", "hover", "forum.can.post.seen");
        }

        function _Str_23060(k:WindowMouseEvent)
        {
            this._controller.tracking.trackEventLogOncePerSession("InterfaceExplorer", "hover", "forum.can.start.thread.seen");
        }

        function _Str_24316(k:WindowMouseEvent)
        {
            this._controller.tracking.trackEventLogOncePerSession("InterfaceExplorer", "hover", "forum.can.moderate.seen");
        }
    }



