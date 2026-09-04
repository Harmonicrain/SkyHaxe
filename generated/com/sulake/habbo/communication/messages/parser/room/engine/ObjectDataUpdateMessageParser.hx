package com.sulake.habbo.communication.messages.parser.room.engine
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.room.IStuffData;
    import com.sulake.habbo.room.object.data.LegacyStuffData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ObjectDataUpdateMessageParser implements IMessageParser
    {
        var _id:Int = 0;
        var _state:Int = 0;
        var _data:IStuffData;


        public var id(get,never):Int;
function  get_id():Int
        {
            return this._id;
        }

        public var state(get,never):Int;
function  get_state():Int
        {
            return this._state;
        }

        public var data(get,never):IStuffData;
function  get_data():IStuffData
        {
            return this._data;
        }

        public function flush():Bool
        {
            this._state = 0;
            this._data = new LegacyStuffData() ;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            if (k == null)
            {
                return false;
            }
            var _local_2= k.readString();
            this._id = ASCompat.toInt(_local_2);
            this._data = ObjectDataParser.parseStuffData(k);
            var _local_3= Std.parseFloat(this._data.getLegacyString());
            if (!Math.isNaN(_local_3))
            {
                this._state = ASCompat.toInt(this._data.getLegacyString());
            }
            return true;
        }

	public function new() {}
    }

