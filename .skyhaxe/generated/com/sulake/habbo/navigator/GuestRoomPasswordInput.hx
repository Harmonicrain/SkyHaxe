package com.sulake.habbo.navigator
;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.habbo.communication.messages.incoming.navigator.GuestRoomData;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.IPasswordFieldWindow;
    import flash.geom.Point;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.events.WindowMouseEvent;

     class GuestRoomPasswordInput 
    {
        var _navigator:IHabboTransitionalNavigator;
        var _window:IFrameWindow;
        var _roomData:GuestRoomData;

        public function new(k:IHabboTransitionalNavigator)
        {
            this._navigator = k;
        }

        public function show(k:GuestRoomData, _arg_2:Point=null)
        {
            this._roomData = k;
            if (this._roomData == null)
            {
                return;
            }
            this.createWindow();
            if (this._window == null)
            {
                return;
            }
            if (_arg_2 != null)
            {
                _arg_2.offset((-this._window.width / 2), (-this._window.height / 2));
                this._window.setGlobalPosition(_arg_2);
            }
            this._window.visible = true;
            this._window.activate();
            var _local_3= Std.downcast(this._window.findChildByName("room_name") , ITextWindow);
            if (((!(_local_3 == null)) && (!(k == null))))
            {
                _local_3.text = k.roomName;
            }
            var _local_4= Std.downcast(this._window.findChildByName("password_input") , IPasswordFieldWindow);
            if (_local_4 != null)
            {
                _local_4.text = "";
            }
            this._Str_5311("${navigator.password.info}");
        }

        function createWindow()
        {
            if (this._window != null)
            {
                return;
            }
            var k= Std.downcast(this._navigator.assets.getAssetByName("password_input_xml") , XmlAsset);
            this._window = Std.downcast(this._navigator.windowManager.buildFromXML(((k.content : com.sulake.core.utils.xml.XML) ), 2) , IFrameWindow);
            if (this._window == null)
            {
                return;
            }
            var _local_2= Std.downcast(this._window.findChildByName("try") , IButtonWindow);
            if (_local_2 != null)
            {
                _local_2.addEventListener(WindowMouseEvent.CLICK, this._Str_24102);
            }
            var _local_3= this._window.findChildByName("cancel_region");
            if (_local_3 != null)
            {
                _local_3.addEventListener(WindowMouseEvent.CLICK, this.close);
            }
            var _local_4= this._window.findChildByTag("close");
            if (_local_4 != null)
            {
                _local_4.addEventListener(WindowMouseEvent.CLICK, this.close);
            }
        }

        public function _Str_15400()
        {
            this.show(this._roomData);
            this._Str_5311("${navigator.password.retryinfo}");
        }

        function _Str_5311(k:String)
        {
            if (this._window == null)
            {
                return;
            }
            var _local_2= Std.downcast(this._window.findChildByName("info") , ITextWindow);
            if (_local_2 == null)
            {
                return;
            }
            _local_2.caption = k;
        }

        public function dispose()
        {
            if (this._window != null)
            {
                this._window.dispose();
            }
            this._window = null;
            this._navigator = null;
            this._roomData = null;
        }

        function _Str_24102(k:WindowMouseEvent)
        {
            var _local_2= Std.downcast(this._window.findChildByName("password_input") , IPasswordFieldWindow);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= _local_2.text;
            this._navigator.goToRoom(this._roomData.flatId, true, _local_3);
            this.hide();
        }

        function close(k:WindowMouseEvent)
        {
            if (this._window == null)
            {
                return;
            }
            this._window.dispose();
            this._window = null;
        }

        function hide(k:WindowMouseEvent=null)
        {
            if (this._window == null)
            {
                return;
            }
            this._window.visible = false;
        }
    }



