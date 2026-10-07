package com.sulake.habbo.navigator
;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.habbo.communication.messages.incoming.navigator.GuestRoomData;
    import com.sulake.core.window.components.ITextWindow;
    import flash.geom.Point;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.outgoing.room.session.QuitMessageComposer;

     class GuestRoomDoorbell 
    {
        var _navigator:IHabboTransitionalNavigator;
        var _window:IFrameWindow;
        var _roomData:GuestRoomData;
        var _isWaiting:Bool = false;

        public function new(k:IHabboTransitionalNavigator)
        {
            this._navigator = k;
        }

        public function show(k:GuestRoomData, _arg_2:Point=null, _arg_3:Bool=false)
        {
            if (k == null)
            {
                return;
            }
            this._roomData = k;
            this._isWaiting = _arg_3;
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
            var _local_4= Std.downcast(this._window.findChildByName("room_name") , ITextWindow);
            if (_local_4 != null)
            {
                _local_4.text = k.roomName;
            }
            if (this._isWaiting)
            {
                this.setText("info", "${navigator.doorbell.waiting}");
                this.setText("cancel", "${navigator.doorbell.button.cancel.entering}");
                this.showButton("ring", false);
            }
            else
            {
                this.setText("info", "${navigator.doorbell.info}");
                this.setText("cancel", "${generic.cancel}");
                this.showButton("ring", true);
            }
        }

        public function showWaiting()
        {
            this.show(this._roomData, null, true);
        }

        public function showNoAnswer()
        {
            if (this._window == null)
            {
                return;
            }
            this._window.visible = true;
            this._window.activate();
            this.setText("info", "${navigator.doorbell.no.answer}");
            this.showButton("ring", false);
        }

        function showButton(k:String, _arg_2:Bool)
        {
            var _local_3= Std.downcast(this._window.findChildByName(k) , IButtonWindow);
            if (_local_3 == null)
            {
                return;
            }
            _local_3.visible = _arg_2;
        }

        function createWindow()
        {
            if (this._window != null)
            {
                return;
            }
            var k= Std.downcast(this._navigator.assets.getAssetByName("doorbell_xml") , XmlAsset);
            this._window = Std.downcast(this._navigator.windowManager.buildFromXML(((k.content : com.sulake.core.utils.xml.XML) ), 2) , IFrameWindow);
            if (this._window == null)
            {
                return;
            }
            var _local_2= Std.downcast(this._window.findChildByName("ring") , IButtonWindow);
            if (_local_2 != null)
            {
                _local_2.addEventListener(WindowMouseEvent.CLICK, this.ringDoorbell);
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

        function setText(k:String, _arg_2:String)
        {
            if (this._window == null)
            {
                return;
            }
            var _local_3= this._window.findChildByName(k);
            if (_local_3 == null)
            {
                return;
            }
            _local_3.caption = _arg_2;
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

        function ringDoorbell(k:WindowMouseEvent)
        {
            this._navigator.goToRoom(this._roomData.flatId, true);
            this.hide();
        }

        function close(k:WindowMouseEvent)
        {
            if (this._window == null)
            {
                return;
            }
            if ((this._isWaiting && (!(this._navigator == null))))
            {
                this._navigator.send(new QuitMessageComposer());
            }
            this._window.dispose();
            this._window = null;
        }

        public function hide()
        {
            if (this._window == null)
            {
                return;
            }
            this._window.visible = false;
        }
    }



