package com.sulake.habbo.room.object.logic.furniture
;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.habbo.room.events.RoomObjectWidgetRequestEvent;
    import flash.events.MouseEvent;
    import com.sulake.room.events.RoomSpriteMouseEvent;
    import com.sulake.room.utils.IRoomGeometry;

     class FurnitureInternalLinkLogic extends FurnitureLogic 
    {
        var _showStateOneOnceRendered:Bool = false;
        var _updateCount:Int = 0;


        override public function initialize(k:com.sulake.core.utils.xml.XML)
        {
            super.initialize(k);
            if (k == null)
            {
                return;
            }
            var _local_2= k.child("action");
            if (_local_2.length() != 0)
            {
                object.getModelController().setString(RoomObjectVariableEnum.FURNITURE_INTERNAL_LINK, _local_2.attribute("link").toString());
                if (com.sulake.core.utils.xml.XML.equalsStringOperands(_local_2.attribute("startState") , "1"))
                {
                    this._showStateOneOnceRendered = true;
                }
            }
        }

        override public function getEventTypes():Array<ASAny>
        {
            return getAllEventTypes(super.getEventTypes(), [RoomObjectWidgetRequestEvent.INERNAL_LINK]);
        }

        override public function useObject()
        {
            if (((!(eventDispatcher == null)) && (!(object == null))))
            {
                eventDispatcher.dispatchEvent(new RoomObjectWidgetRequestEvent(RoomObjectWidgetRequestEvent.INERNAL_LINK, object));
            }
        }

        override public function update(k:Int)
        {
            super.update(k);
            if (!this._showStateOneOnceRendered)
            {
                return;
            }
            this._updateCount++;
            if ((this._showStateOneOnceRendered && (this._updateCount == 20)))
            {
                this._Str_6210(1);
            }
        }

        public function _Str_6210(k:Int)
        {
            if (object == null)
            {
                return;
            }
            var _local_2= object.getModelController();
            if (_local_2 != null)
            {
                _local_2.setNumber(RoomObjectVariableEnum.FURNITURE_AUTOMATIC_STATE_INDEX, k, false);
            }
        }

        override public function mouseEvent(k:RoomSpriteMouseEvent, _arg_2:IRoomGeometry)
        {
            if (k == null)
            {
                return;
            }
            if (((k.type == MouseEvent.DOUBLE_CLICK) && this._showStateOneOnceRendered))
            {
                this._Str_6210(0);
            }
            super.mouseEvent(k, _arg_2);
        }

	public function new() { super(); }
    }

