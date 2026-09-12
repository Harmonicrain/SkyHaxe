package com.sulake.habbo.ui.handler
;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.ui.IRoomWidgetHandlerContainer;
    import com.sulake.habbo.window.utils.IConfirmDialog;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
    import com.sulake.habbo.communication.messages.incoming.navigator.GetGuestRoomResultEvent;
    import com.sulake.habbo.window._enum.HabboAlertDialogFlag;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.runtime.Component;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;
    import com.sulake.habbo.room.events.RoomEngineTriggerWidgetEvent;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.room.object.IRoomObjectModel;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.habbo.communication.messages.outgoing.navigator.GetGuestRoomMessageComposer;
    import flash.events.Event;

     class FurnitureRoomLinkHandler implements IRoomWidgetHandler 
    {
        static inline final INTERNALLINK= "internalLink";

        var _container:IRoomWidgetHandlerContainer;
        var _confirmDialog:IConfirmDialog;
        var _communicationManagerMessageEvents:Vector<IMessageEvent>;
        var _communicationManager:IHabboCommunicationManager;
        var _roomIdToEnter:Int = 0;
        var _link:String;

        public function new()
        {
            this._communicationManagerMessageEvents = new Vector<IMessageEvent>();
        }

        public var type(get,never):String;
public function  get_type():String
        {
            return RoomWidgetEnum.ROOM_LINK;
        }

        public var container(never,set):IRoomWidgetHandlerContainer;
public function  set_container(k:IRoomWidgetHandlerContainer):IRoomWidgetHandlerContainer        {
            return this._container = k;
        }

        public var communicationManager(never,set):IHabboCommunicationManager;
public function  set_communicationManager(k:IHabboCommunicationManager):IHabboCommunicationManager        {
            this._communicationManager = k;
            this._communicationManagerMessageEvents.push(this._communicationManager.addHabboConnectionMessageEvent(new GetGuestRoomResultEvent(this.onRoomInfo)));
return k;
        }

        function onRoomInfo(event:IMessageEvent)
        {
            var message:String = null;
            var roomName:String = null;
            var ownerName:String = null;
            var p= cast(event, GetGuestRoomResultEvent).getParser();
            var roomData= p.data;
            if (((roomData != null) && (roomData.flatId == this._roomIdToEnter)))
            {
                this._roomIdToEnter = 0;
                message = "${room.link.confirmation.message}";
                roomName = roomData.roomName;
                ownerName = roomData.ownerName;
                message = this._container.localization.getLocalization("room.link.confirmation.message");
                if (((!(message == null)) && (message.indexOf("%%room_name%%") > -1)))
                {
                    message = ASCompat.stringReplace(message, "%%room_name%%", roomName);
                }
                if (((!(message == null)) && (message.indexOf("%%room_owner%%") > -1)))
                {
                    message = ASCompat.stringReplace(message, "%%room_owner%%", ownerName);
                }
                this._confirmDialog = this._container.windowManager.confirm("${room.link.confirmation.title}", message, (HabboAlertDialogFlag.BUTTON_OK | HabboAlertDialogFlag.BUTTON_CANCEL), function (k:com.sulake.habbo.window.utils.IAlertDialog, _arg_2:WindowEvent)
                {
                    if (((!(_container.roomEngine == null)) && (_arg_2.type == WindowEvent.WINDOW_EVENT_OK)))
                    {
                        if (((!(_link == null)) && (_link.length > 0)))
                        {
                            ASCompat.reinterpretAs(_container.roomEngine , Component).context.createLinkEvent(("navigator/goto/" + _link));
                        }
                    }
                    k.dispose();
                });
            }
        }

        public function getWidgetMessages():Array<ASAny>
        {
            return null;
        }

        public function processWidgetMessage(k:RoomWidgetMessage):RoomWidgetUpdateEvent
        {
            return null;
        }

        public function getProcessedEvents():Array<ASAny>
        {
            return [RoomEngineTriggerWidgetEvent.RETWE_REQUEST_ROOM_LINK];
        }

        public function processEvent(k:Event)
        {
            var _local_2:RoomEngineTriggerWidgetEvent = null;
            var _local_3:IRoomObject = null;
            var _local_4:IRoomObjectModel = null;
            var _local_5:String = null;
            switch (k.type)
            {
                case RoomEngineTriggerWidgetEvent.RETWE_REQUEST_ROOM_LINK:
                    _local_2 = Std.downcast(k , RoomEngineTriggerWidgetEvent);
                    if (((!(k == null)) && (!(this._container.roomEngine == null))))
                    {
                        _local_3 = this._container.roomEngine.getRoomObject(_local_2.roomId, _local_2.objectId, _local_2.category);
                        if (_local_3 != null)
                        {
                            _local_4 = _local_3.getModel();
                            _local_5 = _local_4.getStringToStringMap(RoomObjectVariableEnum.FURNITURE_DATA).getValue(INTERNALLINK);
                            if (((_local_5 == null) || (_local_5.length == 0)))
                            {
                                _local_5 = _local_4.getString(RoomObjectVariableEnum.FURNITURE_INTERNAL_LINK);
                            }
                            if (_local_5 == null)
                            {
                                return;
                            }
                            if (((!(this._container.navigator == null)) && (!(this._container.localization == null))))
                            {
                                if (this._confirmDialog != null)
                                {
                                    this._confirmDialog.dispose();
                                    this._confirmDialog = null;
                                }
                                this._link = _local_5;
                                this._roomIdToEnter = ASCompat.parseInt(_local_5, 10);
                                this._communicationManager.connection.send(new GetGuestRoomMessageComposer(this._roomIdToEnter, false, false));
                            }
                            else
                            {
                                ASCompat.reinterpretAs(this._container.roomEngine , Component).context.createLinkEvent(("navigator/goto/" + _local_5));
                            }
                        }
                    }
                    return;
            }
        }

        public function update()
        {
        }

        public function dispose()
        {
            var k:IMessageEvent = null;
            if (this._communicationManager != null)
            {
                final _iter_ = this._communicationManagerMessageEvents; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
k  = _tmp_;
                    this._communicationManager.removeHabboConnectionMessageEvent(k);
                }
                this._communicationManagerMessageEvents = null;
                this._communicationManager = null;
            }
            if (this._confirmDialog != null)
            {
                this._confirmDialog.dispose();
                this._confirmDialog = null;
            }
            this._container = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._container == null;
        }
    }

