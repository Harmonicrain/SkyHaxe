package com.sulake.habbo.ui.handler
;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.ui.IRoomWidgetHandlerContainer;
    import com.sulake.habbo.ui.RoomDesktop;
    import com.sulake.habbo.ui.widget.camera.RoomThumbnailCameraWidget;
    import com.sulake.habbo.communication.messages.incoming.camera.ThumbnailStatusMessageEvent;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;
    import flash.events.Event;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
    import com.sulake.habbo.communication.messages.outgoing.camera.RenderRoomThumbnailMessageComposer;
    import com.sulake.habbo.window._enum.HabboAlertDialogFlag;
    import com.sulake.habbo.navigator.IHabboTransitionalNavigator;
    import com.sulake.core.runtime.Component;

     class RoomThumbnailCameraWidgetHandler implements IRoomWidgetHandler implements  IDisposable 
    {
        var _container:IRoomWidgetHandlerContainer = null;
        var _roomDesktop:RoomDesktop;
        var _widget:RoomThumbnailCameraWidget;
        var _thumbnailStatusMessageEvent:ThumbnailStatusMessageEvent;

        public function new(k:RoomDesktop)
        {
            this._roomDesktop = k;
        }

        public var _Str_6647(get,never):RoomDesktop;
public function  get__Str_6647():RoomDesktop
        {
            return this._roomDesktop;
        }

        public function getProcessedEvents():Array<ASAny>
        {
            return [];
        }

        public function getWidgetMessages():Array<ASAny>
        {
            return null;
        }

        public function processWidgetMessage(k:RoomWidgetMessage):RoomWidgetUpdateEvent
        {
            return null;
        }

        public var widget(never,set):RoomThumbnailCameraWidget;
public function  set_widget(k:RoomThumbnailCameraWidget):RoomThumbnailCameraWidget        {
            return this._widget = k;
        }

        
        public var container(get,set):IRoomWidgetHandlerContainer;
public function  set_container(k:IRoomWidgetHandlerContainer):IRoomWidgetHandlerContainer        {
            this._container = k;
            this._thumbnailStatusMessageEvent = new ThumbnailStatusMessageEvent(this._Str_23638);
            this._container.connection.addMessageEvent(this._thumbnailStatusMessageEvent);
return k;
        }

        public function dispose()
        {
            if ((((this._container != null) && (this._container.connection != null)) && (this._thumbnailStatusMessageEvent != null)))
            {
                this._container.connection.removeMessageEvent(this._thumbnailStatusMessageEvent);
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return false;
        }

        public function processEvent(k:Event)
        {
        }

        public function update()
        {
        }

        public var type(get,never):String;
public function  get_type():String
        {
            return RoomWidgetEnum.ROOM_THUMBNAIL_CAMERA;
        }
public function  get_container():IRoomWidgetHandlerContainer
        {
            return this._container;
        }

        public function collectPhotoData():RenderRoomThumbnailMessageComposer
        {
            return cast(this._roomDesktop.roomEngine.getRenderRoomMessage(this._widget.viewPort, this._roomDesktop.roomBackgroundColor, true), RenderRoomThumbnailMessageComposer);
        }

        public function sendPhotoData(k:RenderRoomThumbnailMessageComposer)
        {
            this._container.connection.send(k);
        }

        function _Str_23638(k:ThumbnailStatusMessageEvent)
        {
            var _local_2:IHabboTransitionalNavigator = null;
            var _local_3:String = null;
            var _local_4:Component = null;
            this._widget.destroy();
            if (k.getParser().isOk())
            {
                _local_2 = Std.downcast(this._container.navigator , IHabboTransitionalNavigator);
                if (((!(_local_2 == null)) && (!(_local_2.data.enteredGuestRoom == null))))
                {
                    _local_2.data.setRoomThumbnailRefreshKey(_local_2.data.enteredGuestRoom.flatId, ("" + Std.string(flash.Lib.getTimer())));
                    _local_3 = ((_local_2.getProperty("navigator.thumbnail.url_base") + Std.string(_local_2.data.enteredGuestRoom.flatId)) + ".png");
                    this._container.windowManager.resourceManager.removeAsset(_local_3);
                    if (_local_2.roomInfoViewCtrl != null)
                    {
                        _local_2.roomInfoViewCtrl.reload();
                    }
                    if (_local_2.mainViewCtrl != null)
                    {
                        if (((_local_2.data.guestRoomSearchResults == null) || (!_local_2.mainViewCtrl.reloadRoomList(_local_2.data.guestRoomSearchResults.searchType))))
                        {
                            _local_2.mainViewCtrl.refresh();
                        }
                    }
                }
                _local_4 = ASCompat.reinterpretAs(this._container.windowManager , Component);
                if (_local_4 != null)
                {
                    _local_4.context.createLinkEvent("navigator/refresh");
                }
                this._container.windowManager.alert("${navigator.thumbnail.camera.title}", "${navigator.thumbnail.camera.success}", HabboAlertDialogFlag.BUTTON_OK, null);
            }
            else
            {
                if (k.getParser().isRenderLimitHit())
                {
                    this._container.windowManager.alert("${generic.alert.title}", "${camera.render.count.info}", 0, null);
                }
            }
        }
    }

