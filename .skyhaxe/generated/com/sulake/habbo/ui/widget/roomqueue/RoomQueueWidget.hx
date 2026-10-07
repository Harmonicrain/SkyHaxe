package com.sulake.habbo.ui.widget.roomqueue
;
    import com.sulake.habbo.ui.widget.RoomWidgetBase;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.runtime.IHabboConfigurationManager;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.ui.widget.events.RoomWidgetRoomQueueUpdateEvent;
    import flash.events.IEventDispatcher;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetRoomQueueMessage;

     class RoomQueueWidget extends RoomWidgetBase
    {
        var _window:IFrameWindow;
        var _config:IHabboConfigurationManager;
        var _queuePosition:Int = 0;
        var _hasClub:Bool = false;
        var _activeTarget:String;
        var _isChangePossible:Bool = false;
        var _isClubQueue:Bool = false;

        public function new(k:IRoomWidgetHandler, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary, _arg_4:IHabboLocalizationManager, _arg_5:IHabboConfigurationManager)
        {
            super(k, _arg_2, _arg_3, _arg_4);
            this._config = _arg_5;
        }

        override public function dispose()
        {
            this.removeWindow();
            this._config = null;
            super.dispose();
        }

        override public function registerUpdateEvents(k:IEventDispatcher)
        {
            if (k == null)
            {
                return;
            }
            k.addEventListener(RoomWidgetRoomQueueUpdateEvent.RWRQUE_VISITOR_QUEUE_STATUS, this.onQueueStatus);
            k.addEventListener(RoomWidgetRoomQueueUpdateEvent.RWRQUE_SPECTATOR_QUEUE_STATUS, this.onQueueStatus);
            super.registerUpdateEvents(k);
        }

        override public function unregisterUpdateEvents(k:IEventDispatcher)
        {
            if (k == null)
            {
                return;
            }
            k.removeEventListener(RoomWidgetRoomQueueUpdateEvent.RWRQUE_VISITOR_QUEUE_STATUS, this.onQueueStatus);
            k.removeEventListener(RoomWidgetRoomQueueUpdateEvent.RWRQUE_SPECTATOR_QUEUE_STATUS, this.onQueueStatus);
        }

        function removeWindow()
        {
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
        }

        function onQueueStatus(k:RoomWidgetRoomQueueUpdateEvent)
        {
            if (k == null)
            {
                return;
            }
            if (k.isActive)
            {
                this._activeTarget = k.type;
                this._isChangePossible = false;
                this._queuePosition = k.position;
            }
            else
            {
                this._isChangePossible = true;
            }
            this._hasClub = k.hasHabboClub;
            this._isClubQueue = k.isClubQueue;
            localizations.registerParameter("room.queue.position", "position", Std.string(this._queuePosition));
            localizations.registerParameter("room.queue.position.hc", "position", Std.string(this._queuePosition));
            localizations.registerParameter("room.queue.spectator.position", "position", Std.string(this._queuePosition));
            localizations.registerParameter("room.queue.spectator.position.hc", "position", Std.string(this._queuePosition));
            this.showInterface();
        }

        function createWindow():Bool
        {
            if (this._window != null)
            {
                return true;
            }
            var k= Std.downcast(assets.getAssetByName("room_queue") , XmlAsset);
            this._window = Std.downcast(windowManager.buildFromXML(((k.content : com.sulake.core.utils.xml.XML) )) , IFrameWindow);
            if (this._window == null)
            {
                return false;
            }
            this._window.visible = false;
            var _local_2= this._window.findChildByTag("close");
            if (_local_2 != null)
            {
                _local_2.addEventListener(WindowMouseEvent.CLICK, this.exitQueue);
            }
            _local_2 = this._window.findChildByName("cancel_button");
            if (_local_2 != null)
            {
                _local_2.addEventListener(WindowMouseEvent.CLICK, this.exitQueue);
            }
            _local_2 = this._window.findChildByName("link_text");
            if (_local_2 != null)
            {
                _local_2.addEventListener(WindowMouseEvent.CLICK, this.openLink);
            }
            _local_2 = this._window.findChildByName("change_button");
            if (_local_2 != null)
            {
                _local_2.addEventListener(WindowMouseEvent.CLICK, this.changeQueue);
            }
            this._window.center();
            return true;
        }

        function showInterface()
        {
            if (!this.createWindow())
            {
                return;
            }
            var k= Std.downcast(this._window.findChildByName("info_text") , ITextWindow);
            var _local_2= Std.downcast(this._window.findChildByName("change_button") , IButtonWindow);
            var _local_3= this._window.findChildByName("spectator_info");
            if ((((!(k == null)) && (!(_local_2 == null))) && (!(_local_3 == null))))
            {
                switch (this._activeTarget)
                {
                    case RoomWidgetRoomQueueUpdateEvent.RWRQUE_VISITOR_QUEUE_STATUS:
                        k.caption = (this._isClubQueue ? "${room.queue.position.hc}" : "${room.queue.position}");
                        _local_2.caption = "${room.queue.spectatormode}";
                        _local_3.visible = this._isChangePossible;
                        
                    case RoomWidgetRoomQueueUpdateEvent.RWRQUE_SPECTATOR_QUEUE_STATUS:
                        k.caption = (this._isClubQueue ? "${room.queue.spectator.position.hc}" : "${room.queue.spectator.position}");
                        _local_2.caption = "${room.queue.back}";
                        _local_3.visible = false;
                        
                }
                _local_2.visible = this._isChangePossible;
            }
            var _local_4= Std.downcast(this._window.findChildByName("club_container") , IWindowContainer);
            if (_local_4 != null)
            {
                _local_4.visible = (!this._hasClub);
            }
            this._window.visible = true;
        }

        function exitQueue(k:WindowMouseEvent)
        {
            if (messageListener == null)
            {
                return;
            }
            var _local_2= new RoomWidgetRoomQueueMessage(RoomWidgetRoomQueueMessage.RWRQM_EXIT_QUEUE);
            messageListener.processWidgetMessage(_local_2);
            this.removeWindow();
        }

        function openLink(k:WindowMouseEvent)
        {
            messageListener.processWidgetMessage(new RoomWidgetRoomQueueMessage(RoomWidgetRoomQueueMessage.RWRQM_CLUB_LINK));
        }

        function changeQueue(k:WindowMouseEvent)
        {
            var _local_2:RoomWidgetRoomQueueMessage = null;
            if (messageListener == null)
            {
                return;
            }
            if (this._activeTarget == RoomWidgetRoomQueueUpdateEvent.RWRQUE_VISITOR_QUEUE_STATUS)
            {
                _local_2 = new RoomWidgetRoomQueueMessage(RoomWidgetRoomQueueMessage.RWRQM_CHANGE_TO_SPECTATOR_QUEUE);
            }
            else
            {
                _local_2 = new RoomWidgetRoomQueueMessage(RoomWidgetRoomQueueMessage.RWRQM_CHANGE_TO_VISITOR_QUEUE);
            }
            messageListener.processWidgetMessage(_local_2);
            this.removeWindow();
        }
    }

