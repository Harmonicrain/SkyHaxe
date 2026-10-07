package com.sulake.habbo.room.object.logic.furniture
;
    import com.sulake.habbo.room.object.data.VoteResultStuffData;
    import com.sulake.habbo.room.messages.RoomObjectDataUpdateMessage;
    import com.sulake.room.messages.RoomObjectUpdateMessage;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;

     class FurnitureVoteCounterLogic extends FurnitureMultistateLogic 
    {
        static inline final UPDATE_INTERVAL= 33;
        static inline final MAX_UPDATE_TIME= 1000;

        var _total:Int = 0;
        var _lastUpdate:Int = 0;
        var _updateInterval__com_sulake_habbo_room_object_logic_furniture_FurnitureVoteCounterLogic/*redefined private*/:Int = 33;


        override public function processUpdateMessage(k:RoomObjectUpdateMessage)
        {
            var _local_3:VoteResultStuffData = null;
            super.processUpdateMessage(k);
            var _local_2= Std.downcast(k , RoomObjectDataUpdateMessage);
            if (_local_2 != null)
            {
                _local_3 = Std.downcast(_local_2.data , VoteResultStuffData);
                if (_local_3 != null)
                {
                    this.updateTotal(_local_3.result);
                }
            }
        }

        var currentTotal(get,never):Int;
function  get_currentTotal():Int
        {
            return Std.int(object.getModelController().getNumber(RoomObjectVariableEnum.FURNITURE_VOTE_COUNTER_COUNT));
        }

        function updateTotal(k:Int)
        {
            var _local_2 = 0;
            this._total = k;
            if (this._lastUpdate == 0)
            {
                object.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_VOTE_COUNTER_COUNT, k);
                this._lastUpdate = flash.Lib.getTimer();
                return;
            }
            if (this._total != this.currentTotal)
            {
                _local_2 = Std.int(Math.abs((this._total - this.currentTotal)));
                if ((_local_2 * UPDATE_INTERVAL) > MAX_UPDATE_TIME)
                {
                    this._updateInterval__com_sulake_habbo_room_object_logic_furniture_FurnitureVoteCounterLogic = Std.int(MAX_UPDATE_TIME / _local_2);
                }
                else
                {
                    this._updateInterval__com_sulake_habbo_room_object_logic_furniture_FurnitureVoteCounterLogic = UPDATE_INTERVAL;
                }
                this._lastUpdate = flash.Lib.getTimer();
            }
        }

        override public function update(k:Int)
        {
            var _local_2 = 0;
            var _local_3 = 0;
            var _local_4 = 0;
            super.update(k);
            if (object != null)
            {
                if (((!(this.currentTotal == this._total)) && (k >= (this._lastUpdate + this._updateInterval__com_sulake_habbo_room_object_logic_furniture_FurnitureVoteCounterLogic))))
                {
                    _local_2 = (k - this._lastUpdate);
                    _local_3 = Std.int(_local_2 / this._updateInterval__com_sulake_habbo_room_object_logic_furniture_FurnitureVoteCounterLogic);
                    _local_4 = 1;
                    if (this._total < this.currentTotal)
                    {
                        _local_4 = -1;
                    }
                    if (_local_3 > (_local_4 * (this._total - this.currentTotal)))
                    {
                        _local_3 = (_local_4 * (this._total - this.currentTotal));
                    }
                    object.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_VOTE_COUNTER_COUNT, (this.currentTotal + (_local_4 * _local_3)));
                    this._lastUpdate = (k - (_local_2 - (_local_3 * this._updateInterval__com_sulake_habbo_room_object_logic_furniture_FurnitureVoteCounterLogic)));
                }
            }
        }

	public function new() { super(); }
    }

