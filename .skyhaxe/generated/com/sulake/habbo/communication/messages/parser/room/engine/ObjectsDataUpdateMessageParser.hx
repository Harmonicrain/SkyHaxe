package com.sulake.habbo.communication.messages.parser.room.engine
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.room.engine.ObjectData;
    import com.sulake.habbo.room.IStuffData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ObjectsDataUpdateMessageParser implements IMessageParser 
    {
        var _objects:Array<ASAny>;

        public function new()
        {
            this._objects = [];
        }

        public var objectCount(get,never):Int;
public function  get_objectCount():Int
        {
            return this._objects.length;
        }

        public function _Str_24113(k:Int):ObjectData
        {
            if (((k < 0) || (k >= this.objectCount)))
            {
                return null;
            }
            return this._objects[k];
        }

        public function flush():Bool
        {
            this._objects = [];
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_4 = 0;
            var _local_5:IStuffData = null;
            var _local_6 = 0;
            var _local_7 = Math.NaN;
            if (k == null)
            {
                return false;
            }
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                _local_4 = k.readInteger();
                _local_5 = ObjectDataParser.parseStuffData(k);
                _local_6 = 0;
                _local_7 = Std.parseFloat(_local_5.getLegacyString());
                if (!Math.isNaN(_local_7))
                {
                    _local_6 = ASCompat.toInt(_local_5.getLegacyString());
                }
                this._objects.push(new ObjectData(_local_4, _local_6, _local_5));
                _local_3++;
            }
            return true;
        }
    }

