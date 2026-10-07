package com.sulake.habbo.communication.messages.parser.room.engine
;
    import com.sulake.habbo.communication.messages.incoming.room.engine.ObjectMessageData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.habbo.room.object.data.StuffDataFactory;
    import com.sulake.habbo.room.IStuffData;

     class ObjectDataParser
    {


        public static function parseObjectData(k:IMessageDataWrapper):ObjectMessageData
        {
            if (k == null)
            {
                return null;
            }
            var _local_2= k.readInteger();
            var _local_3= new ObjectMessageData(_local_2);
            var _local_4= k.readInteger();
            _local_3.type = _local_4;
            _local_3.x = k.readInteger();
            _local_3.y = k.readInteger();
            _local_3.dir = ((k.readInteger() % 8) * 45);
            _local_3.z = ASCompat.toNumber(k.readString());
            _local_3.sizeZ = ASCompat.toNumber(k.readString());
            _local_3.extra = k.readInteger();
            _local_3.data = parseStuffData(k);
            var _local_5= Std.parseFloat(_local_3.data.getLegacyString());
            if (!Math.isNaN(_local_5))
            {
                _local_3.state = ASCompat.toInt(_local_3.data.getLegacyString());
            }
            _local_3.expiryTime = k.readInteger();
            _local_3.usagePolicy = k.readInteger();
            _local_3.ownerId = k.readInteger();
            if (_local_4 < 0)
            {
                _local_3.staticClass = k.readString();
            }
            return _local_3;
        }

        public static function parseStuffData(k:IMessageDataWrapper):IStuffData
        {
            var _local_2= k.readInteger();
            var _local_3= StuffDataFactory.getStuffDataWrapperForType(_local_2);
            _local_3.initializeFromIncomingMessage(k);
            return _local_3;
        }

	public function new() {}
    }

