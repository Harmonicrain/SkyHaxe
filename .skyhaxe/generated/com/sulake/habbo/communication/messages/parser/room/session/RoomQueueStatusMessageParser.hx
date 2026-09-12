package com.sulake.habbo.communication.messages.parser.room.session
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.utils.Map;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class RoomQueueStatusMessageParser implements IMessageParser
    {
        var _queueSets:Map;
        var _activeTarget:Int = 0;

        public function new()
        {
            this._queueSets = new Map();
        }

        public var activeTarget(get,never):Int;
public function  get_activeTarget():Int
        {
            return this._activeTarget;
        }

        public function flush():Bool
        {
            this._queueSets.reset();
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_3 = 0;
            var _local_4:RoomQueueSet = null;
            var _local_6:String = null;
            var _local_7 = 0;
            var _local_8 = 0;
            this._queueSets.reset();
            var _local_2= k.readInteger();
            var _local_5 = 0;
            while (_local_5 < _local_2)
            {
                _local_6 = k.readString();
                _local_7 = k.readInteger();
                if (_local_5 == 0)
                {
                    this._activeTarget = _local_7;
                }
                _local_4 = new RoomQueueSet(_local_6, _local_7);
                _local_3 = k.readInteger();
                _local_8 = 0;
                while (_local_8 < _local_3)
                {
                    _local_4.addQueue(k.readString(), k.readInteger());
                    _local_8++;
                }
                this._queueSets.add(_local_4.target, _local_4);
                _local_5++;
            }
            return true;
        }

        public function getQueueSetTargets():Array<ASAny>
        {
            return this._queueSets.getKeys();
        }

        public function getQueueSet(k:Int):RoomQueueSet
        {
            return ASCompat.dynamicAs(this._queueSets.getValue(k) , RoomQueueSet);
        }
    }

