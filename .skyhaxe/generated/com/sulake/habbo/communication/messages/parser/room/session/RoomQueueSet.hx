package com.sulake.habbo.communication.messages.parser.room.session
;
    import com.sulake.core.utils.Map;

     class RoomQueueSet
    {
        var _name:String;
        var _target:Int = 0;
        var _queues:Map;

        public function new(k:String, _arg_2:Int)
        {
            this._name = k;
            this._target = _arg_2;
            this._queues = new Map();
        }

        public var name(get,never):String;
public function  get_name():String
        {
            return this._name;
        }

        public var target(get,never):Int;
public function  get_target():Int
        {
            return this._target;
        }

        public var queueTypes(get,never):Array<ASAny>;
public function  get_queueTypes():Array<ASAny>
        {
            return this._queues.getKeys();
        }

        public function getQueueSize(k:String):Int
        {
            return ASCompat.toInt(this._queues.getValue(k));
        }

        public function addQueue(k:String, _arg_2:Int)
        {
            this._queues.add(k, _arg_2);
        }
    }

