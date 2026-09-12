package com.sulake.habbo.ui.handler
;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.ui.IRoomWidgetHandlerContainer;
    import com.sulake.habbo.ui.widget.furniture.externalimage.ExternalImageWidget;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;
    import com.sulake.habbo.room.events.RoomEngineUseProductEvent;
    import com.sulake.habbo.room.events.RoomEngineTriggerWidgetEvent;
    import flash.events.Event;
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;
    import com.sulake.habbo.session._enum.RoomControllerLevel;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;

     class ExternalImageWidgetHandler implements IRoomWidgetHandler 
    {
        var _disposed:Bool = false;
        var _container:IRoomWidgetHandlerContainer;
        var _widget:ExternalImageWidget;


        
        public var container(get,set):IRoomWidgetHandlerContainer;
public function  set_container(k:IRoomWidgetHandlerContainer):IRoomWidgetHandlerContainer        {
            return this._container = k;
        }
public function  get_container():IRoomWidgetHandlerContainer
        {
            return this._container;
        }

        public var widget(never,set):ExternalImageWidget;
public function  set_widget(k:ExternalImageWidget):ExternalImageWidget        {
            return this._widget = k;
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
            return [RoomEngineUseProductEvent.ROSM_USE_PRODUCT_FROM_INVENTORY];
        }

        public function processEvent(k:Event)
        {
            var _local_4:RoomEngineUseProductEvent = null;
            if (this._container.roomEngine == null)
            {
                return;
            }
            if (Std.is(k , RoomEngineUseProductEvent))
            {
                _local_4 = Std.downcast(k , RoomEngineUseProductEvent);
                if (_local_4.type == RoomEngineUseProductEvent.ROSM_USE_PRODUCT_FROM_INVENTORY)
                {
                    this._widget.showWithFurniID(_local_4.objectId);
                }
            }
            var _local_2= Std.downcast(k , RoomEngineTriggerWidgetEvent);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= this._container.roomEngine.getRoomObject(_local_2.roomId, _local_2.objectId, _local_2.category);
            switch (k.type)
            {
                case RoomEngineTriggerWidgetEvent.OPEN_WIDGET:
                    if (_local_3 != null)
                    {
                        this._widget.showWithRoomObject(_local_3);
                    }
                    return;
                case RoomEngineTriggerWidgetEvent.CLOSE_WIDGET:
                    this._widget.hide();
                    return;
            }
        }

        public function deleteCard(k:Int)
        {
            if (((!(this._container == null)) && (!(this._container.roomEngine == null))))
            {
                this._container.roomEngine.deleteRoomObject(k, RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM);
            }
        }

        public function isRoomOwner():Bool
        {
            return this._container.roomSession.isRoomOwner;
        }

        public function hasRightsToRemove():Bool
        {
            return this._container.roomSession.roomControllerLevel >= RoomControllerLevel.ROOM_OWNER;
        }

        public function sendMessage(k:IMessageComposer)
        {
            this._container.connection.send(k);
        }

        public function update()
        {
        }

        public function dispose()
        {
            this._container = null;
            this._disposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var type(get,never):String;
public function  get_type():String
        {
            return RoomWidgetEnum.EXTERNAL_IMAGE;
        }

        public var storiesImageUrlBase(get,never):String;
public function  get_storiesImageUrlBase():String
        {
            return this._container.config.getProperty("stories.image_url_base");
        }

        public var storiesImageShareUrl(get,never):String;
public function  get_storiesImageShareUrl():String
        {
            return this._container.config.getProperty("stories.image.sharing_url_base");
        }

        public var extraDataServiceUrl(get,never):String;
public function  get_extraDataServiceUrl():String
        {
            return this._container.config.getProperty("extra_data_service_url");
        }

        public function isSelfieReportingEnabled():Bool
        {
            return this._container.config.getProperty("stories.report.selfie.enabled") == "true";
        }
public function new(){}
    }

