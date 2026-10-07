package com.sulake.habbo.room.object.logic.furniture
;
    import com.sulake.habbo.ui.widget.enums.ContextMenuEnum;
    import com.sulake.habbo.room.events.RoomObjectWidgetRequestEvent;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.habbo.room.object.data.StringArrayStuffData;
    import com.sulake.habbo.room.messages.RoomObjectDataUpdateMessage;
    import com.sulake.room.messages.RoomObjectUpdateMessage;

     class FurnitureFriendFurniLogic extends FurnitureMultistateLogic 
    {
        static inline final STATE_UNINITIALIZED= -1;
        static inline final STATE_UNLOCKED= 0;
        static inline final STATE_LOCKED= 1;

        var _state:Int = -1;


        var engravingDialogType(get,never):Int;
function  get_engravingDialogType():Int
        {
            return 0;
        }

        override public function  get_contextMenu():String
        {
            return (this._state == STATE_UNLOCKED) ? ContextMenuEnum.FRIEND_FURNITURE : ContextMenuEnum.DUMMY;
        }

        override public function getEventTypes():Array<ASAny>
        {
            return getAllEventTypes(super.getEventTypes(), [RoomObjectWidgetRequestEvent.FRIEND_FURNITURE_ENGRAVING]);
        }

        override public function initialize(k:com.sulake.core.utils.xml.XML)
        {
            super.initialize(k);
            object.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_FRIENDFURNI_ENGRAVING_TYPE, this.engravingDialogType);
        }

        override public function processUpdateMessage(k:RoomObjectUpdateMessage)
        {
            var _local_3:StringArrayStuffData = null;
            var _local_2= Std.downcast(k , RoomObjectDataUpdateMessage);
            if (_local_2 != null)
            {
                _local_3 = Std.downcast(_local_2.data , StringArrayStuffData);
                if (_local_3 != null)
                {
                    this._state = _local_3.state;
                }
                else
                {
                    this._state = _local_2.state;
                }
            }
            super.processUpdateMessage(k);
        }

        override public function useObject()
        {
            if (((!(eventDispatcher == null)) && (!(object == null))))
            {
                if (this._state == STATE_LOCKED)
                {
                    eventDispatcher.dispatchEvent(new RoomObjectWidgetRequestEvent(RoomObjectWidgetRequestEvent.FRIEND_FURNITURE_ENGRAVING, object));
                }
                else
                {
                    super.useObject();
                }
            }
        }

	public function new() { super(); }
    }

