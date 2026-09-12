package com.sulake.habbo.communication.messages.parser.room.engine
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.room.engine.ObjectMessageData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ObjectAddMessageParser implements IMessageParser
    {
        var _data:ObjectMessageData;


        public function flush():Bool
        {
            this._data = null;
            return true;
        }

        public var data(get,never):ObjectMessageData;
public function  get_data():ObjectMessageData
        {
            var k= this._data;
            if (k != null)
            {
                k.setReadOnly();
            }
            return k;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            if (k == null)
            {
                return false;
            }
            this._data = ObjectDataParser.parseObjectData(k);
            this._data.ownerName = k.readString();
            return true;
        }

	public function new() {}
    }

