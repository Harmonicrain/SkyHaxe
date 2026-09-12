package com.sulake.habbo.communication.messages.parser.room.engine
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.habbo.communication.messages.incoming.room.engine.PublicRoomObjectMessageData;

     class PublicRoomObjectDataParser
    {
        public static function parseObjectData(k:IMessageDataWrapper):PublicRoomObjectMessageData
        {
            var _local_2= k.readBoolean();
            var _local_3= k.readString();
            var _local_4= k.readString();
            var _local_5= k.readInteger();
            var _local_6= k.readInteger();
            var _local_7= k.readInteger();
            var _local_8= 0;
            var _local_9= 0;
            var _local_10= 0;
            if (!_local_2)
            {
                _local_8 = (k.readInteger() * 45);
            }
            else
            {
                _local_9 = k.readInteger();
                _local_10 = k.readInteger();
            }
            return new PublicRoomObjectMessageData(_local_2, _local_3, _local_4, _local_5, _local_6, _local_7, _local_8, _local_9, _local_10);
        }

	public function new() {}
    }

