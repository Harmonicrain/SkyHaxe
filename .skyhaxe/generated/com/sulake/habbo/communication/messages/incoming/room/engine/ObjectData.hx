package com.sulake.habbo.communication.messages.incoming.room.engine
;
    import com.sulake.habbo.room.IStuffData;
    import com.sulake.habbo.room.object.data.LegacyStuffData;

     class ObjectData
    {
        var _id:Int = 0;
        var _state:Int = 0;
        var _data:IStuffData;

        public function new(k:Int, _arg_2:Int, _arg_3:IStuffData)
        {
            this._data = new LegacyStuffData();
            this._id = k;
            this._state = _arg_2;
            this._data = _arg_3;
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
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
    }

