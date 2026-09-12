package com.sulake.habbo.room.messages
;
    import com.sulake.room.messages.RoomObjectUpdateMessage;
    import com.sulake.habbo.room.IStuffData;

     class RoomObjectDataUpdateMessage extends RoomObjectUpdateMessage 
    {
        var _state:Int = 0;
        var _data:IStuffData = null;
        var _extra:Float = Math.NaN;

        public function new(k:Int, _arg_2:IStuffData, _arg_3:Float=null)
{
            if (_arg_3 == null) _arg_3 = Math.NaN;
            super(null, null);
            this._state = k;
            this._data = _arg_2;
            this._extra = _arg_3;
        }

        public var state(get,never):Int;
public function  get_state():Int
        {
            return this._state;
        }

        public var data(get,never):IStuffData;
public function  get_data():IStuffData
        {
            return this._data;
        }

        public var extra(get,never):Float;
public function  get_extra():Float
        {
            return this._extra;
        }
    }

