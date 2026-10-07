package com.sulake.habbo.ui.handler
;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.ui.IRoomWidgetHandlerContainer;
    import com.sulake.habbo.ui.widget.camera.CameraWidget;
    import com.sulake.habbo.communication.messages.incoming.camera.CameraStorageUrlMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.camera.CameraPurchaseOKMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.camera.CameraPublishStatusMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.camera.CompetitionStatusMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.camera.InitCameraMessageEvent;
    import com.sulake.habbo.ui.RoomDesktop;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
    import com.sulake.habbo.toolbar.events.HabboToolbarEvent;
    import com.sulake.habbo.communication._enum.perk.PerkEnum;
    import com.sulake.habbo.communication.messages.outgoing.camera.RequestCameraConfigurationComposer;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;
    import flash.events.Event;
    import com.sulake.habbo.communication.messages.outgoing.camera.PurchasePhotoMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.camera.PublishPhotoMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.camera.PhotoCompetitionMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.camera.RenderRoomMessageComposer;

     class CameraWidgetHandler implements IRoomWidgetHandler implements  IDisposable 
    {
        var _disposed:Bool = false;
        var _container:IRoomWidgetHandlerContainer = null;
        var _widget:CameraWidget;
        var _cameraStorageUrlMessageEvent:CameraStorageUrlMessageEvent;
        var _cameraPurchaseOKMessageEvent:CameraPurchaseOKMessageEvent;
        var _cameraPublishStatusMessageEvent:CameraPublishStatusMessageEvent;
        var _competitionStatusMessageEvent:CompetitionStatusMessageEvent;
        var _initCameraMessageEvent:InitCameraMessageEvent;
        var _roomDesktop:RoomDesktop;
        var _creditPrice:Int = 999;
        var _ducketPrice:Int = 999;
        var _publishDucketPrice:Int = 999;

        public function new(k:RoomDesktop)
        {
            this._roomDesktop = k;
        }

        public var creditPrice(get,never):Int;
public function  get_creditPrice():Int
        {
            return this._creditPrice;
        }

        public var ducketPrice(get,never):Int;
public function  get_ducketPrice():Int
        {
            return this._ducketPrice;
        }

        public var publishDucketPrice(get,never):Int;
public function  get_publishDucketPrice():Int
        {
            return this._publishDucketPrice;
        }

        public var type(get,never):String;
public function  get_type():String
        {
            return RoomWidgetEnum.CAMERA;
        }

        public var roomDesktop(get,never):RoomDesktop;
public function  get_roomDesktop():RoomDesktop
        {
            return this._roomDesktop;
        }

        
        public var container(get,set):IRoomWidgetHandlerContainer;
public function  set_container(k:IRoomWidgetHandlerContainer):IRoomWidgetHandlerContainer        {
            if (((this._container != null) && (this._container.toolbar != null)))
            {
                this._container.toolbar.events.removeEventListener(HabboToolbarEvent.HTE_ICON_CAMERA, this.onCameraRequested);
            }
            this._container = k;
            if (((this._container != null) && (this._container.toolbar != null)))
            {
                this._container.toolbar.events.addEventListener(HabboToolbarEvent.HTE_ICON_CAMERA, this.onCameraRequested);
            }
            this._cameraStorageUrlMessageEvent = new CameraStorageUrlMessageEvent(this.onCameraStorageUrlEvent);
            this._cameraPurchaseOKMessageEvent = new CameraPurchaseOKMessageEvent(this.onPurchaseOK);
            this._cameraPublishStatusMessageEvent = new CameraPublishStatusMessageEvent(this.onPublishStatus);
            this._competitionStatusMessageEvent = new CompetitionStatusMessageEvent(this.onCompetitionStatus);
            this._initCameraMessageEvent = new InitCameraMessageEvent(this.onInitCameraEvent);
            this._container.connection.addMessageEvent(this._cameraStorageUrlMessageEvent);
            this._container.connection.addMessageEvent(this._cameraPurchaseOKMessageEvent);
            this._container.connection.addMessageEvent(this._cameraPublishStatusMessageEvent);
            this._container.connection.addMessageEvent(this._competitionStatusMessageEvent);
            this._container.connection.addMessageEvent(this._initCameraMessageEvent);
return k;
        }

        public function sendInitCameraMessage()
        {
            if (this._container.sessionDataManager.isPerkAllowed(PerkEnum.CAMERA))
            {
                this._container.connection.send(new RequestCameraConfigurationComposer());
            }
        }

        function onInitCameraEvent(k:InitCameraMessageEvent)
        {
            this._creditPrice = k.getParser().getCreditPrice();
            this._ducketPrice = k.getParser().getDucketPrice();
            this._publishDucketPrice = k.getParser().getPublishDucketPrice();
        }

        function onPurchaseOK(k:CameraPurchaseOKMessageEvent)
        {
            if (this._widget != null)
            {
                this._widget._Str_25644();
            }
        }

        function onPublishStatus(k:CameraPublishStatusMessageEvent)
        {
            if (this._widget != null)
            {
                this._widget._Str_12205(k);
            }
        }

        function onCompetitionStatus(k:CompetitionStatusMessageEvent)
        {
            if (this._widget != null)
            {
                this._widget.competitionStatus(k);
            }
        }

        function onCameraStorageUrlEvent(k:CameraStorageUrlMessageEvent)
        {
            if (this._widget == null)
            {
                return;
            }
            var _local_2= k.getParser().url;
            this._widget._Str_16763(_local_2);
        }
public function  get_container():IRoomWidgetHandlerContainer
        {
            return this._container;
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
            return [];
        }

        public function processEvent(k:Event)
        {
        }

        public function update()
        {
        }

        public function dispose()
        {
            if (((this._container != null) && (this.container.connection != null)))
            {
                this._container.connection.removeMessageEvent(this._cameraStorageUrlMessageEvent);
                this._container.connection.removeMessageEvent(this._cameraPurchaseOKMessageEvent);
                this._container.connection.removeMessageEvent(this._cameraPublishStatusMessageEvent);
                this._container.connection.removeMessageEvent(this._competitionStatusMessageEvent);
                this._container.connection.removeMessageEvent(this._initCameraMessageEvent);
            }
            this._disposed = true;
            this._container = null;
            this._roomDesktop = null;
            this._widget = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var widget(never,set):CameraWidget;
public function  set_widget(k:CameraWidget):CameraWidget        {
            return this._widget = k;
        }

        function onCameraRequested(k:HabboToolbarEvent)
        {
            if (k.type == HabboToolbarEvent.HTE_ICON_CAMERA)
            {
                if (this._widget != null)
                {
                    this._widget.startTakingPhoto(k.iconName);
                }
            }
        }

        public function addListenerToStage(k:String, _arg_2:ASFunction)
        {
            this._roomDesktop.addListenerToStage(k, _arg_2);
        }

        public function removeListenerFromStage(k:String, _arg_2:ASFunction)
        {
            this._roomDesktop.removeListenerFromStage(k, _arg_2);
        }

        public function confirmPhotoPurchase()
        {
            this._container.connection.send(new PurchasePhotoMessageComposer());
        }

        public function confirmPhotoPublish()
        {
            this._container.connection.send(new PublishPhotoMessageComposer());
        }

        public function confirmPhotoCompetitionSubmit()
        {
            this._container.connection.send(new PhotoCompetitionMessageComposer());
        }

        public function collectPhotoData():RenderRoomMessageComposer
        {
            if (this._roomDesktop == null)
            {
                return null;
            }
            return Std.downcast(this._roomDesktop.roomEngine.getRenderRoomMessage(this._widget._Str_14786(), this._roomDesktop.roomBackgroundColor) , RenderRoomMessageComposer);
        }

        public function sendPhotoData(k:RenderRoomMessageComposer)
        {
            this._container.connection.send(k);
        }
    }

