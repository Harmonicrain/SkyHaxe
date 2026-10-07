package com.sulake.habbo.room.object.logic.furniture
;
    import com.sulake.habbo.room.messages.RoomObjectDataUpdateMessage;
    import com.sulake.room.messages.RoomObjectUpdateMessage;
    import com.sulake.habbo.room.object.data.LegacyStuffData;

     class FurnitureIceStormLogic extends FurnitureMultistateLogic 
    {
        var _nextState:Int = 0;
        var _nextStateExtra:Float = 0;
        var _nextStateTimeStamp:Int = 0;


        override public function processUpdateMessage(k:RoomObjectUpdateMessage)
        {
            if (k == null)
            {
                return;
            }
            var _local_2= Std.downcast(k , RoomObjectDataUpdateMessage);
            if (_local_2 != null)
            {
                this._Str_9796__com_sulake_habbo_room_object_logic_furniture_FurnitureIceStormLogic(_local_2);
                return;
            }
            super.processUpdateMessage(k);
        }

        function _Str_9796__com_sulake_habbo_room_object_logic_furniture_FurnitureIceStormLogic/*redefined private*/(k:RoomObjectDataUpdateMessage)
        {
            var _local_4:LegacyStuffData = null;
            var _local_2= Std.int(k.state / 1000);
            var _local_3= (k.state % 1000);
            if (_local_3 == 0)
            {
                this._nextStateTimeStamp = 0;
                _local_4 = new LegacyStuffData();
                _local_4.setString(Std.string(_local_2));
                k = new RoomObjectDataUpdateMessage(_local_2, _local_4, k.extra);
                super.processUpdateMessage(k);
            }
            else
            {
                this._nextState = _local_2;
                this._nextStateExtra = k.extra;
                this._nextStateTimeStamp = (lastUpdateTime + _local_3);
            }
        }

        override public function update(k:Int)
        {
            var _local_2:LegacyStuffData = null;
            var _local_3:RoomObjectDataUpdateMessage = null;
            if (((this._nextStateTimeStamp > 0) && (k >= this._nextStateTimeStamp)))
            {
                this._nextStateTimeStamp = 0;
                _local_2 = new LegacyStuffData();
                _local_2.setString(Std.string(this._nextState));
                _local_3 = new RoomObjectDataUpdateMessage(this._nextState, _local_2, this._nextStateExtra);
                super.processUpdateMessage(_local_3);
            }
            super.update(k);
        }

	public function new() { super(); }
    }

