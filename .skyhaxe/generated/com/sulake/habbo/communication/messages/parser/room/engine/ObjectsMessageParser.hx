package com.sulake.habbo.communication.messages.parser.room.engine
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.room.engine.ObjectMessageData;
    import com.sulake.core.utils.Map;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ObjectsMessageParser implements IMessageParser 
    {
        var _objects:Array<ASAny>;

        public function new()
        {
            this._objects = [];
        }

        public function flush():Bool
        {
            this._objects = [];
            return true;
        }

        public function getObjectCount():Int
        {
            return this._objects.length;
        }

        public function getObject(k:Int):ObjectMessageData
        {
            if (((k < 0) || (k >= this.getObjectCount())))
            {
                return null;
            }
            var _local_2= ASCompat.dynamicAs(this._objects[k] , ObjectMessageData);
            if (_local_2 != null)
            {
                _local_2.setReadOnly();
            }
            return _local_2;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var iterator = 0;
            var ownerId = 0;
            var ownerName:String = null;
            var object:ObjectMessageData = null;
            if (k == null)
            {
                return false;
            }
            this._objects = [];
            var owners= new Map();
            var ownersAmount= k.readInteger();
            iterator = 0;
            while (iterator < ownersAmount)
            {
                ownerId = k.readInteger();
                ownerName = k.readString();
                owners.add(ownerId, ownerName);
                iterator++;
            }
            var objects= k.readInteger();
            iterator = 0;
            while (iterator < objects)
            {
                object = ObjectDataParser.parseObjectData(k);
                if (object != null)
                {
                    object.ownerName = owners.getValue(object.ownerId);
                    this._objects.push(object);
                }
                iterator++;
            }
            return true;
        }
    }

