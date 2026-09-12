package com.sulake.habbo.communication.messages.parser.room.engine
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.room.engine.PublicRoomObjectMessageData;

     class PublicRoomObjectsMessageParser implements IMessageParser
    {
        var _roomId:Int = 0;
        var _roomCategory:Int = 0;
        var _objects:Vector<PublicRoomObjectMessageData>;

        public var roomId(get,never):Int;
public function  get_roomId():Int
        {
            return this._roomId;
        }

        public var roomCategory(get,never):Int;
public function  get_roomCategory():Int
        {
            return this._roomCategory;
        }

        public var objects(get,never):Vector<PublicRoomObjectMessageData>;
public function  get_objects():Vector<PublicRoomObjectMessageData>
        {
            return this._objects;
        }

        public function flush():Bool
        {
            this._roomId = 0;
            this._roomCategory = 0;
            this._objects = new Vector<PublicRoomObjectMessageData>();
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._roomId = k.readInteger();
            this._roomCategory = k.readInteger();
            this._objects = new Vector<PublicRoomObjectMessageData>();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._objects.push(PublicRoomObjectDataParser.parseObjectData(k));
                _local_3++;
            }
            return true;
        }

	public function new() {}
    }

