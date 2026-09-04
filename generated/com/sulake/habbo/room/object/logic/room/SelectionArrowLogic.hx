package com.sulake.habbo.room.object.logic.room
;
    import com.sulake.room.object.logic.ObjectLogicBase;
    import com.sulake.room.object.IRoomObjectModelController;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.habbo.room.messages.RoomObjectVisibilityUpdateMessage;
    import com.sulake.room.messages.RoomObjectUpdateMessage;

     class SelectionArrowLogic extends ObjectLogicBase 
    {


        override public function initialize(k:com.sulake.core.utils.xml.XML)
        {
            var _local_2:IRoomObjectModelController;
            if (object != null)
            {
                _local_2 = object.getModelController();
                if (_local_2 != null)
                {
                    _local_2.setNumber(RoomObjectVariableEnum.FURNITURE_ALPHA_MULTIPLIER, 1);
                    object.setState(1, 0);
                }
            }
        }

        override public function processUpdateMessage(k:RoomObjectUpdateMessage)
        {
            super.processUpdateMessage(k);
            var _local_2= Std.downcast(k , RoomObjectVisibilityUpdateMessage);
            if (_local_2 != null)
            {
                if (_local_2.type == RoomObjectVisibilityUpdateMessage.ROVUM_ENABLED)
                {
                    if (object != null)
                    {
                        object.setState(0, 0);
                    }
                }
                else
                {
                    if (_local_2.type == RoomObjectVisibilityUpdateMessage.ROVUM_DISABLED)
                    {
                        if (object != null)
                        {
                            object.setState(1, 0);
                        }
                    }
                }
            }
        }

	public function new() { super(); }
    }

