package com.sulake.habbo.room.object.logic.furniture
;
    import com.sulake.habbo.room.object.logic.MovingObjectLogic;
    import com.sulake.room.messages.RoomObjectUpdateMessage;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.habbo.room.events.RoomObjectRoomAdEvent;
    import com.sulake.habbo.room.events.RoomObjectStateChangedEvent;
    import com.sulake.room.events.RoomObjectMouseEvent;
    import com.sulake.habbo.room.events.RoomObjectWidgetRequestEvent;
    import com.sulake.room.object.IRoomObjectController;
    import com.sulake.room.utils.XMLValidator;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.room.object.IRoomObjectModelController;
    import com.sulake.room.events.RoomObjectEvent;
    import flash.events.MouseEvent;
    import com.sulake.room.events.RoomSpriteMouseEvent;
    import com.sulake.room.utils.IRoomGeometry;
    import com.sulake.habbo.room.messages.RoomObjectDataUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectHeightUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectItemDataUpdateMessage;
    import com.sulake.room.utils.IVector3d;
    import com.sulake.habbo.room.messages.RoomObjectMoveUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectSelectedMessage;

     class FurnitureLogic extends MovingObjectLogic 
    {
        static inline final BOUNCE_STEPS= 8;
        static final BOUNCE_STEP_HEIGHT:Float = (1 / 16);//0.0625

        var _mouseOver:Bool = false;
        var _sizeX:Float = 0;
        var _sizeY:Float = 0;
        var _sizeZ:Float = 0;
        var _centerX:Float = 0;
        var _centerY:Float = 0;
        var _centerZ:Float = 0;
        var _directionInitialized:Bool = false;
        var _bouncingStep:Int = 0;
        var _storedRotateMessage:RoomObjectUpdateMessage;
        var _locationOffset:Vector3d;
        var _directions:Array<ASAny>;

        public function new()
        {
            this._locationOffset = new Vector3d();
            this._directions = [];
            super();
        }

        override public function getEventTypes():Array<ASAny>
        {
            var k:Array<ASAny> = [RoomObjectRoomAdEvent.RORAE_ROOM_AD_TOOLTIP_SHOW, RoomObjectRoomAdEvent.RORAE_ROOM_AD_TOOLTIP_HIDE, RoomObjectRoomAdEvent.RORAE_ROOM_AD_FURNI_DOUBLE_CLICK, RoomObjectStateChangedEvent.STATE_CHANGE, RoomObjectMouseEvent.ROE_MOUSE_CLICK, RoomObjectRoomAdEvent.RORAE_ROOM_AD_FURNI_CLICK, RoomObjectMouseEvent.ROE_MOUSE_DOWN];
            if (widget != null)
            {
                k.push(RoomObjectWidgetRequestEvent.OPEN_WIDGET);
                k.push(RoomObjectWidgetRequestEvent.CLOSE_WIDGET);
            }
            if (contextMenu != null)
            {
                k.push(RoomObjectWidgetRequestEvent.OPEN_FURNI_CONTEXT_MENU);
                k.push(RoomObjectWidgetRequestEvent.CLOSE_FURNI_CONTEXT_MENU);
            }
            return getAllEventTypes(super.getEventTypes(), k);
        }

        override public function dispose()
        {
            super.dispose();
            this._storedRotateMessage = null;
            this._directions = null;
        }

        override public function  set_object(k:IRoomObjectController):IRoomObjectController        {
            super.object = k;
            if (((!(k == null)) && (k.getLocation().length > 0)))
            {
                this._directionInitialized = true;
            }
return k;
        }

        override public function initialize(k:com.sulake.core.utils.xml.XML)
        {
            var _local_9:com.sulake.core.utils.xml.XML = null;
            var _local_10:com.sulake.core.utils.xml.XML = null;
            var _local_11 = 0;
            if (k == null)
            {
                return;
            }
            this._sizeX = 0;
            this._sizeY = 0;
            this._sizeZ = 0;
            this._directions = [];
            var _local_2= k.child("model").child("dimensions");
            if (_local_2.length() == 0)
            {
                return;
            }
            var _local_3= _local_2.attribute("x");
            if (_local_3.length() == 1)
            {
                this._sizeX = ASCompat.toNumber(ASCompat.xmlListToString(_local_3));
            }
            _local_3 = _local_2.attribute("y");
            if (_local_3.length() == 1)
            {
                this._sizeY = ASCompat.toNumber(ASCompat.xmlListToString(_local_3));
            }
            _local_3 = _local_2.attribute("z");
            if (_local_3.length() == 1)
            {
                this._sizeZ = ASCompat.toNumber(ASCompat.xmlListToString(_local_3));
            }
            this._centerX = (this._sizeX / 2);
            this._centerY = (this._sizeY / 2);
            _local_3 = _local_2.attribute("centerZ");
            if (_local_3.length() == 1)
            {
                this._centerZ = ASCompat.toNumber(ASCompat.xmlListToString(_local_3));
            }
            else
            {
                this._centerZ = (this._sizeZ / 2);
            }
            var _local_4= k.child("model").child("directions").child("direction");
            var _local_5:Array<ASAny> = ["id"];
            var _local_6 = 0;
            while (_local_6 < _local_4.length())
            {
                _local_10 = _local_4.at(_local_6);
                if (XMLValidator.checkRequiredAttributes(_local_10, _local_5))
                {
                    _local_11 = ASCompat.parseInt(_local_10.attribute("id").toString());
                    this._directions.push(_local_11);
                }
                _local_6++;
            }
            ASCompat.ASArray.sortWithOptions(this._directions, ASCompat.ASArray.NUMERIC);
            if (((object == null) || (object.getModelController() == null)))
            {
                return;
            }
            var _local_7= k.child("customvars").child("variable");
            var _local_8:Array<ASAny> = [];
            if (checkNullIteratee(_local_7)) for (_tmp_ in _local_7)
            {
_local_9  = _tmp_;
                _local_8.push(_local_9.attribute("name").toString());
            }
            object.getModelController().setStringArray(RoomObjectVariableEnum.FURNITURE_CUSTOM_VARIABLES, _local_8, true);
            object.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_SIZE_X, this._sizeX, true);
            object.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_SIZE_Y, this._sizeY, true);
            if (!object.getModelController().hasNumber(RoomObjectVariableEnum.FURNITURE_SIZE_Z))
            {
                object.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_SIZE_Z, this._sizeZ);
            }
            object.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_CENTER_X, this._centerX, true);
            object.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_CENTER_Y, this._centerY, true);
            object.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_CENTER_Z, this._centerZ, true);
            object.getModelController().setNumberArray(RoomObjectVariableEnum.FURNITURE_ALLOWED_DIRECTIONS, this._directions, true);
            object.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_ALPHA_MULTIPLIER, 1);
        }

        function getAdClickUrl(k:IRoomObjectModelController):String
        {
            return k.getString(RoomObjectVariableEnum.FURNITURE_AD_URL);
        }

        function handleAdClick(k:Int, _arg_2:String, _arg_3:String)
        {
            if (eventDispatcher != null)
            {
                eventDispatcher.dispatchEvent(new RoomObjectRoomAdEvent(RoomObjectRoomAdEvent.RORAE_ROOM_AD_FURNI_CLICK, object));
            }
        }

        override public function mouseEvent(k:RoomSpriteMouseEvent, _arg_2:IRoomGeometry)
        {
            var _local_4:RoomObjectEvent = null;
            if (((k == null) || (_arg_2 == null)))
            {
                return;
            }
            if (object == null)
            {
                return;
            }
            var _local_3= Std.downcast(object.getModel() , IRoomObjectModelController);
            if (_local_3 == null)
            {
                return;
            }
            var _local_5= this.getAdClickUrl(_local_3);
            switch (k.type)
            {
                case MouseEvent.MOUSE_MOVE:
                    if (eventDispatcher != null)
                    {
                        _local_4 = new RoomObjectMouseEvent(RoomObjectMouseEvent.ROE_MOUSE_MOVE, object, k.eventId, k.altKey, k.ctrlKey, k.shiftKey, k.buttonDown);
                        Std.downcast(_local_4 , RoomObjectMouseEvent).localX = Std.int(k.localX);
                        Std.downcast(_local_4 , RoomObjectMouseEvent).localY = Std.int(k.localY);
                        Std.downcast(_local_4 , RoomObjectMouseEvent).spriteOffsetX = k.spriteOffsetX;
                        Std.downcast(_local_4 , RoomObjectMouseEvent).spriteOffsetY = k.spriteOffsetY;
                        eventDispatcher.dispatchEvent(_local_4);
                    }
                    return;
                case MouseEvent.ROLL_OVER:
                    if (!this._mouseOver)
                    {
                        if ((((!(eventDispatcher == null)) && (!(_local_5 == null))) && (_local_5.indexOf("http") == 0)))
                        {
                            eventDispatcher.dispatchEvent(new RoomObjectRoomAdEvent(RoomObjectRoomAdEvent.RORAE_ROOM_AD_TOOLTIP_SHOW, object));
                        }
                        if (eventDispatcher != null)
                        {
                            _local_4 = new RoomObjectMouseEvent(RoomObjectMouseEvent.ROE_MOUSE_ENTER, object, k.eventId, k.altKey, k.ctrlKey, k.shiftKey, k.buttonDown);
                            Std.downcast(_local_4 , RoomObjectMouseEvent).localX = Std.int(k.localX);
                            Std.downcast(_local_4 , RoomObjectMouseEvent).localY = Std.int(k.localY);
                            Std.downcast(_local_4 , RoomObjectMouseEvent).spriteOffsetX = k.spriteOffsetX;
                            Std.downcast(_local_4 , RoomObjectMouseEvent).spriteOffsetY = k.spriteOffsetY;
                            eventDispatcher.dispatchEvent(_local_4);
                        }
                        this._mouseOver = true;
                    }
                    return;
                case MouseEvent.ROLL_OUT:
                    if (this._mouseOver)
                    {
                        if ((((!(eventDispatcher == null)) && (!(_local_5 == null))) && (_local_5.indexOf("http") == 0)))
                        {
                            eventDispatcher.dispatchEvent(new RoomObjectRoomAdEvent(RoomObjectRoomAdEvent.RORAE_ROOM_AD_TOOLTIP_HIDE, object));
                        }
                        if (eventDispatcher != null)
                        {
                            _local_4 = new RoomObjectMouseEvent(RoomObjectMouseEvent.ROE_MOUSE_LEAVE, object, k.eventId, k.altKey, k.ctrlKey, k.shiftKey, k.buttonDown);
                            Std.downcast(_local_4 , RoomObjectMouseEvent).localX = Std.int(k.localX);
                            Std.downcast(_local_4 , RoomObjectMouseEvent).localY = Std.int(k.localY);
                            Std.downcast(_local_4 , RoomObjectMouseEvent).spriteOffsetX = k.spriteOffsetX;
                            Std.downcast(_local_4 , RoomObjectMouseEvent).spriteOffsetY = k.spriteOffsetY;
                            eventDispatcher.dispatchEvent(_local_4);
                        }
                        this._mouseOver = false;
                    }
                    return;
                case MouseEvent.DOUBLE_CLICK:
                    this.useObject();
                    return;
                case MouseEvent.CLICK:
                    if (eventDispatcher != null)
                    {
                        _local_4 = new RoomObjectMouseEvent(RoomObjectMouseEvent.ROE_MOUSE_CLICK, object, k.eventId, k.altKey, k.ctrlKey, k.shiftKey, k.buttonDown);
                        Std.downcast(_local_4 , RoomObjectMouseEvent).localX = Std.int(k.localX);
                        Std.downcast(_local_4 , RoomObjectMouseEvent).localY = Std.int(k.localY);
                        Std.downcast(_local_4 , RoomObjectMouseEvent).spriteOffsetX = k.spriteOffsetX;
                        Std.downcast(_local_4 , RoomObjectMouseEvent).spriteOffsetY = k.spriteOffsetY;
                        eventDispatcher.dispatchEvent(_local_4);
                    }
                    if ((((!(eventDispatcher == null)) && (!(_local_5 == null))) && (_local_5.indexOf("http") == 0)))
                    {
                        eventDispatcher.dispatchEvent(new RoomObjectRoomAdEvent(RoomObjectRoomAdEvent.RORAE_ROOM_AD_TOOLTIP_HIDE, object));
                    }
                    if (((!(eventDispatcher == null)) && (!(_local_5 == null))))
                    {
                        this.handleAdClick(object.getId(), object.getType(), _local_5);
                    }
                    if ((((!(eventDispatcher == null)) && (!(object == null))) && (!(contextMenu == null))))
                    {
                        eventDispatcher.dispatchEvent(new RoomObjectWidgetRequestEvent(RoomObjectWidgetRequestEvent.OPEN_FURNI_CONTEXT_MENU, object));
                    }
                    return;
                case MouseEvent.MOUSE_DOWN:
                    if (eventDispatcher != null)
                    {
                        _local_4 = new RoomObjectMouseEvent(RoomObjectMouseEvent.ROE_MOUSE_DOWN, object, k.eventId, k.altKey, k.ctrlKey, k.shiftKey, k.buttonDown);
                        eventDispatcher.dispatchEvent(_local_4);
                    }
                    return;
            }
        }

        override public function useObject()
        {
            var k:IRoomObjectModelController = null;
            var _local_2:String = null;
            if (object != null)
            {
                k = Std.downcast(object.getModel() , IRoomObjectModelController);
                if (k != null)
                {
                    _local_2 = this.getAdClickUrl(k);
                    if ((((!(eventDispatcher == null)) && (!(_local_2 == null))) && (_local_2.length > 0)))
                    {
                        eventDispatcher.dispatchEvent(new RoomObjectRoomAdEvent(RoomObjectRoomAdEvent.RORAE_ROOM_AD_FURNI_DOUBLE_CLICK, object, null, _local_2));
                    }
                }
                if (eventDispatcher != null)
                {
                    if (widget != null)
                    {
                        eventDispatcher.dispatchEvent(new RoomObjectWidgetRequestEvent(RoomObjectWidgetRequestEvent.OPEN_WIDGET, object));
                    }
                    eventDispatcher.dispatchEvent(new RoomObjectStateChangedEvent(RoomObjectStateChangedEvent.STATE_CHANGE, object));
                }
            }
        }

        function _Str_9796(k:RoomObjectDataUpdateMessage)
        {
            var _local_2= object.getModelController();
            object.setState(k.state, 0);
            if (_local_2 != null)
            {
                if (k.data != null)
                {
                    k.data.writeRoomObjectModel(_local_2);
                }
                if (!Math.isNaN(k.extra))
                {
                    _local_2.setString(RoomObjectVariableEnum.FURNITURE_EXTRAS, Std.string(k.extra));
                }
                _local_2.setNumber(RoomObjectVariableEnum.FURNITURE_STATE_UPDATE_TIME, lastUpdateTime);
            }
        }

        function handleHeightUpdateMessage(k:RoomObjectHeightUpdateMessage)
        {
            var _local_2= object.getModelController();
            if (_local_2 != null)
            {
                _local_2.setNumber(RoomObjectVariableEnum.FURNITURE_SIZE_Z, k.height);
            }
        }

        function handleItemDataUpdateMessage(k:RoomObjectItemDataUpdateMessage)
        {
            var _local_2= object.getModelController();
            if (_local_2 != null)
            {
                _local_2.setString(RoomObjectVariableEnum.FURNITURE_ITEMDATA, k.itemData);
            }
        }

        override public function processUpdateMessage(k:RoomObjectUpdateMessage)
        {
            var _local_6:IVector3d = null;
            var _local_7:IVector3d = null;
            var _local_8:String = null;
            var _local_2= Std.downcast(k , RoomObjectDataUpdateMessage);
            if (_local_2 != null)
            {
                this._Str_9796(_local_2);
                return;
            }
            var _local_3= Std.downcast(k , RoomObjectHeightUpdateMessage);
            if (_local_3 != null)
            {
                this.handleHeightUpdateMessage(_local_3);
                return;
            }
            var _local_4= Std.downcast(k , RoomObjectItemDataUpdateMessage);
            if (_local_4 != null)
            {
                this.handleItemDataUpdateMessage(_local_4);
                return;
            }
            this._mouseOver = false;
            if (((!(k.dir == null)) && (!(k.loc == null))))
            {
                if (!Std.is(k , RoomObjectMoveUpdateMessage))
                {
                    _local_6 = object.getDirection();
                    _local_7 = object.getLocation();
                    if ((((((((!(_local_6 == null)) && (!(_local_6.x == k.dir.x))) && this._directionInitialized) && (!(_local_7 == null))) && (_local_7.x == k.loc.x)) && (_local_7.y == k.loc.y)) && (_local_7.z == k.loc.z)))
                    {
                        this._bouncingStep = 1;
                        this._storedRotateMessage = new RoomObjectUpdateMessage(k.loc, k.dir);
                        k = null;
                    }
                }
                this._directionInitialized = true;
            }
            var _local_5= Std.downcast(k , RoomObjectSelectedMessage);
            if (((((!(contextMenu == null)) && (!(_local_5 == null))) && (!(eventDispatcher == null))) && (!(object == null))))
            {
                _local_8 = (_local_5.selected ? RoomObjectWidgetRequestEvent.OPEN_FURNI_CONTEXT_MENU : RoomObjectWidgetRequestEvent.CLOSE_FURNI_CONTEXT_MENU);
                eventDispatcher.dispatchEvent(new RoomObjectWidgetRequestEvent(_local_8, object));
            }
            super.processUpdateMessage(k);
        }

        override function getLocationOffset():IVector3d
        {
            if (this._bouncingStep > 0)
            {
                this._locationOffset.x = 0;
                this._locationOffset.y = 0;
                if (this._bouncingStep <= (BOUNCE_STEPS / 2))
                {
                    this._locationOffset.z = (BOUNCE_STEP_HEIGHT * this._bouncingStep);
                }
                else
                {
                    if (this._bouncingStep <= BOUNCE_STEPS)
                    {
                        if (this._storedRotateMessage != null)
                        {
                            super.processUpdateMessage(this._storedRotateMessage);
                            this._storedRotateMessage = null;
                        }
                        this._locationOffset.z = (BOUNCE_STEP_HEIGHT * (BOUNCE_STEPS - this._bouncingStep));
                    }
                }
                return this._locationOffset;
            }
            return null;
        }

        override public function update(k:Int)
        {
            super.update(k);
            if (this._bouncingStep > 0)
            {
                this._bouncingStep++;
                if (this._bouncingStep > BOUNCE_STEPS)
                {
                    this._bouncingStep = 0;
                }
            }
        }

        override public function tearDown()
        {
            if (((!(widget == null)) && (object.getModelController().getNumber(RoomObjectVariableEnum.FURNITURE_REAL_ROOM_OBJECT) == 1)))
            {
                eventDispatcher.dispatchEvent(new RoomObjectWidgetRequestEvent(RoomObjectWidgetRequestEvent.CLOSE_WIDGET, object));
            }
            super.tearDown();
        }
    }

