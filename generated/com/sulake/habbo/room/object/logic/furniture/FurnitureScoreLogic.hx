package com.sulake.habbo.room.object.logic.furniture
;
    import com.sulake.habbo.room.messages.RoomObjectDataUpdateMessage;
    import com.sulake.room.messages.RoomObjectUpdateMessage;

     class FurnitureScoreLogic extends FurnitureLogic 
    {
        static inline final UPDATE_INTERVAL= 50;
        static inline final MAX_UPDATE_TIME= 3000;

        var _Str_3295:Int = 0;
        var _Str_5063:Int = 0;
        var _Str_3464:Int = 50;


        override public function processUpdateMessage(k:RoomObjectUpdateMessage)
        {
            var _local_2= Std.downcast(k , RoomObjectDataUpdateMessage);
            if (_local_2 != null)
            {
                this._Str_25381(_local_2.state);
                return;
            }
            super.processUpdateMessage(k);
        }

        function _Str_25381(k:Int)
        {
            var _local_3:Int;
            this._Str_3295 = k;
            var _local_2= object.getState(0);
            if (this._Str_3295 != _local_2)
            {
                _local_3 = (this._Str_3295 - _local_2);
                if (_local_3 < 0)
                {
                    _local_3 = -_local_3;
                }
                if ((_local_3 * UPDATE_INTERVAL) > MAX_UPDATE_TIME)
                {
                    this._Str_3464 = Std.int(MAX_UPDATE_TIME / _local_3);
                }
                else
                {
                    this._Str_3464 = UPDATE_INTERVAL;
                }
                this._Str_5063 = flash.Lib.getTimer();
            }
        }

        override public function update(k:Int)
        {
            var _local_2:Int;
            var _local_3:Int;
            var _local_4:Int;
            var _local_5:Int;
            super.update(k);
            if (object != null)
            {
                _local_2 = object.getState(0);
                if (((!(_local_2 == this._Str_3295)) && (k >= (this._Str_5063 + this._Str_3464))))
                {
                    _local_3 = (k - this._Str_5063);
                    _local_4 = Std.int(_local_3 / this._Str_3464);
                    _local_5 = 1;
                    if (this._Str_3295 < _local_2)
                    {
                        _local_5 = -1;
                    }
                    if (_local_4 > (_local_5 * (this._Str_3295 - _local_2)))
                    {
                        _local_4 = (_local_5 * (this._Str_3295 - _local_2));
                    }
                    object.setState((_local_2 + (_local_5 * _local_4)), 0);
                    this._Str_5063 = (k - (_local_3 - (_local_4 * this._Str_3464)));
                }
            }
        }

	public function new() { super(); }
    }

