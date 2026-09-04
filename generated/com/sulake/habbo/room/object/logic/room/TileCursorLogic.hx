package com.sulake.habbo.room.object.logic.room
;
    import com.sulake.room.object.logic.ObjectLogicBase;
    import com.sulake.room.object.IRoomObjectModelController;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.habbo.room.messages.RoomObjectTileCursorUpdateMessage;
    import com.sulake.room.messages.RoomObjectUpdateMessage;

     class TileCursorLogic extends ObjectLogicBase 
    {
        static inline final STATE_ENABLED= 0;
        static inline final STATE_DISABLED= 1;
        static inline final STATE_SHOW_TILE_HEIGHT= 6;

        var _Str_16735:String;
        var _Str_17144:Bool = false;


        override public function initialize(k:com.sulake.core.utils.xml.XML)
        {
            var _local_2:IRoomObjectModelController;
            if (object != null)
            {
                _local_2 = object.getModelController();
                if (_local_2 != null)
                {
                    _local_2.setNumber(RoomObjectVariableEnum.FURNITURE_ALPHA_MULTIPLIER, 1);
                    object.setState(STATE_DISABLED, 0);
                }
            }
        }

        override public function processUpdateMessage(k:RoomObjectUpdateMessage)
        {
            var _local_3:Float;
            var _local_4:Int;
            var _local_2= Std.downcast(k , RoomObjectTileCursorUpdateMessage);
            if (_local_2 == null)
            {
                return;
            }
            if (((!(this._Str_16735 == null)) && (this._Str_16735 == _local_2.sourceEventId)))
            {
                return;
            }
            if (_local_2.toggleVisibility)
            {
                this._Str_17144 = (!this._Str_17144);
            }
            super.processUpdateMessage(k);
            if (object != null)
            {
                if (this._Str_17144)
                {
                    object.setState(STATE_DISABLED, 0);
                }
                else
                {
                    if (!_local_2.visible)
                    {
                        object.setState(STATE_DISABLED, 0);
                    }
                    else
                    {
                        _local_3 = _local_2.height;
                        object.getModelController().setNumber(RoomObjectVariableEnum.TILE_CURSOR_HEIGHT, _local_3);
                        _local_4 = ((_local_3 > 0.8) ? STATE_SHOW_TILE_HEIGHT : STATE_ENABLED);
                        object.setState(_local_4, 0);
                    }
                }
            }
            this._Str_16735 = _local_2.sourceEventId;
        }

	public function new() { super(); }
    }

