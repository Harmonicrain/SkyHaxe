package com.sulake.habbo.room.object.logic.furniture
;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.habbo.room.events.RoomObjectRoomAdEvent;
    import com.sulake.habbo.room.messages.RoomObjectRoomAdUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectDataUpdateMessage;
    import com.sulake.room.messages.RoomObjectUpdateMessage;
    import com.sulake.habbo.room.object.data.MapStuffData;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnumItemExtradataParameter;
    import flash.events.MouseEvent;
    import com.sulake.room.events.RoomSpriteMouseEvent;
    import com.sulake.room.utils.IRoomGeometry;

     class FurnitureRoomBrandingLogic extends FurnitureLogic 
    {
        public static inline final STATE= "state";
        public static inline final IMAGEURL= "imageUrl";
        public static inline final CLICKURL= "clickUrl";
        public static inline final OFFSETX= "offsetX";
        public static inline final OFFSETY= "offsetY";
        public static inline final OFFSETZ= "offsetZ";

        var _Str_19784:Bool = false;
        var _Str_12652:Bool = false;

        public function new()
        {
            super();
            this._Str_19784 = true;
            this._Str_12652 = false;
        }

        override public function initialize(k:com.sulake.core.utils.xml.XML)
        {
            super.initialize(k);
            if (this._Str_19784)
            {
                object.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_SELECTION_DISABLE, 1);
            }
        }

        override public function getEventTypes():Array<ASAny>
        {
            var k:Array<ASAny> = [RoomObjectRoomAdEvent.RORAE_ROOM_AD_LOAD_IMAGE];
            return getAllEventTypes(super.getEventTypes(), k);
        }

        override public function processUpdateMessage(k:RoomObjectUpdateMessage)
        {
            var _local_2:RoomObjectRoomAdUpdateMessage;
            super.processUpdateMessage(k);
            if (Std.is(k , RoomObjectDataUpdateMessage))
            {
                this.setupImageFromFurnitureData();
            }
            if (Std.is(k , RoomObjectRoomAdUpdateMessage))
            {
                _local_2 = Std.downcast(k , RoomObjectRoomAdUpdateMessage);
                switch (_local_2.type)
                {
                    case RoomObjectRoomAdUpdateMessage.RORUM_ROOM_BILLBOARD_IMAGE_LOADED:
                        object.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_BRANDING_IMAGE_STATUS, 1, false);
                        return;
                    case RoomObjectRoomAdUpdateMessage.RORUM_ROOM_BILLBOARD_IMAGE_LOADING_FAILED:
                        object.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_BRANDING_IMAGE_STATUS, -1);
                        Logger.log([("failed to load billboard image from url " + object.getModelController().getString(RoomObjectVariableEnum.FURNITURE_BRANDING_IMAGE_URL))]);
                        return;
                }
            }
        }

        function setupImageFromFurnitureData():Bool
        {
            var _local_8:MapStuffData;
            var _local_9:Float;
            var _local_10:String;
            var _local_11:String;
            var _local_12:Int;
            var _local_13:String;
            var _local_14:String;
            var k = false;
            if (object != null)
            {
                _local_8 = new MapStuffData();
                _local_8.initializeFromRoomObjectModel(object.getModel());
                _local_9 = ASCompat.parseInt(_local_8.getValue(STATE));
                if (!Math.isNaN(_local_9))
                {
                    _local_12 = Std.int(_local_9);
                    if (object.getState(0) != _local_12)
                    {
                        object.setState(_local_12, 0);
                        k = true;
                    }
                }
                _local_10 = this._Str_21982(_local_8.getValue(IMAGEURL));
                if (_local_10 != null)
                {
                    _local_13 = object.getModelController().getString(RoomObjectVariableEnum.FURNITURE_BRANDING_IMAGE_URL);
                    if (((_local_13 == null) || (!(this._Str_21982(_local_13) == _local_10))))
                    {
                        object.getModelController().setString(RoomObjectVariableEnum.FURNITURE_BRANDING_IMAGE_URL, _local_10, false);
                        object.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_BRANDING_IMAGE_STATUS, 0, false);
                        k = true;
                    }
                }
                _local_11 = _local_8.getValue(CLICKURL);
                if (_local_11 != null)
                {
                    _local_14 = object.getModelController().getString(RoomObjectVariableEnum.FURNITURE_BRANDING_URL);
                    if (((_local_14 == null) || (!(_local_14 == _local_11))))
                    {
                        object.getModelController().setString(RoomObjectVariableEnum.FURNITURE_BRANDING_URL, _local_11);
                        k = true;
                    }
                }
                if (!Math.isNaN(ASCompat.parseInt(_local_8.getValue(OFFSETX))))
                {
                    k = this.updateOffset(RoomObjectVariableEnum.FURNITURE_BRANDING_OFFSET_X, Std.int(object.getModelController().getNumber(RoomObjectVariableEnum.FURNITURE_BRANDING_OFFSET_X)), ASCompat.parseInt(_local_8.getValue(OFFSETX)));
                }
                if (!Math.isNaN(ASCompat.parseInt(_local_8.getValue(OFFSETY))))
                {
                    k = this.updateOffset(RoomObjectVariableEnum.FURNITURE_BRANDING_OFFSET_Y, Std.int(object.getModelController().getNumber(RoomObjectVariableEnum.FURNITURE_BRANDING_OFFSET_Y)), ASCompat.parseInt(_local_8.getValue(OFFSETY)));
                }
                if (!Math.isNaN(ASCompat.parseInt(_local_8.getValue(OFFSETZ))))
                {
                    k = this.updateOffset(RoomObjectVariableEnum.FURNITURE_BRANDING_OFFSET_Z, Std.int(object.getModelController().getNumber(RoomObjectVariableEnum.FURNITURE_BRANDING_OFFSET_Z)), ASCompat.parseInt(_local_8.getValue(OFFSETZ)));
                }
            }
            var _local_2= object.getModelController().getString(RoomObjectVariableEnum.FURNITURE_BRANDING_IMAGE_URL);
            var _local_3= object.getModelController().getString(RoomObjectVariableEnum.FURNITURE_BRANDING_URL);
            var _local_4= Std.int(object.getModelController().getNumber(RoomObjectVariableEnum.FURNITURE_BRANDING_OFFSET_X));
            var _local_5= Std.int(object.getModelController().getNumber(RoomObjectVariableEnum.FURNITURE_BRANDING_OFFSET_Y));
            var _local_6= Std.int(object.getModelController().getNumber(RoomObjectVariableEnum.FURNITURE_BRANDING_OFFSET_Z));
            if (_local_2 != null)
            {
                eventDispatcher.dispatchEvent(new RoomObjectRoomAdEvent(RoomObjectRoomAdEvent.RORAE_ROOM_AD_LOAD_IMAGE, object, _local_2, _local_3));
            }
            var _local_7:ASAny = (((IMAGEURL + "=") + ((_local_2 != null) ? _local_2 : "")) + "\t");
            if (this._Str_12652)
            {
                _local_7 = (_local_7 + (((CLICKURL + "=") + ((_local_3 != null) ? _local_3 : "")) + "\t"));
            }
            _local_7 = (_local_7 + (((OFFSETX + "=") + _local_4) + "\t"));
            _local_7 = (_local_7 + (((OFFSETY + "=") + _local_5) + "\t"));
            _local_7 = (_local_7 + (((OFFSETZ + "=") + _local_6) + "\t"));
            object.getModelController().setString(RoomWidgetEnumItemExtradataParameter.INFOSTAND_EXTRA_PARAM, (RoomWidgetEnumItemExtradataParameter.BRANDING_OPTIONS + _local_7));
            return k;
        }

        function _Str_21982(k:String):String
        {
            return (k != null) ? StringTools.replace(k, "http:", "https:") : null;
        }

        override public function mouseEvent(k:RoomSpriteMouseEvent, _arg_2:IRoomGeometry)
        {
            if (((k == null) || (_arg_2 == null)))
            {
                return;
            }
            if (k.type == MouseEvent.MOUSE_MOVE)
            {
                return;
            }
            switch (k.type)
            {
                case MouseEvent.DOUBLE_CLICK:
                    return;
                default:
                    super.mouseEvent(k, _arg_2);
            }
        }

        function updateOffset(k:String, _arg_2:Int, _arg_3:Int):Bool
        {
            if (((!Math.isNaN(_arg_3)) && (!(_arg_2 == _arg_3))))
            {
                object.getModelController().setNumber(k, _arg_3);
                return true;
            }
            return false;
        }
    }

