package com.sulake.habbo.session.events
;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.session.IRoomSession;

     class RoomSessionQueueEvent extends RoomSessionEvent 
    {
        public static inline final RSQE_QUEUE_STATUS= "RSQE_QUEUE_STATUS";
        public static inline final C= "c";
        public static inline final D= "d";
        public static inline final QUEUE_TARGET_VISITOR= 2;
        public static inline final QUEUE_TARGET_SPECTATOR= 1;

        var _name:String;
        var _target:Int = 0;
        var _queues:Map;
        var _isActive:Bool = false;
        var _activeQueue:String;

        public function new(k:IRoomSession, _arg_2:String, _arg_3:Int, _arg_4:Bool=false, _arg_5:Bool=false, _arg_6:Bool=false)
        {
            super(RSQE_QUEUE_STATUS, k, _arg_5, _arg_6);
            this._name = _arg_2;
            this._target = _arg_3;
            this._queues = new Map();
            this._isActive = _arg_4;
        }

        public var isActive(get,never):Bool;
public function  get_isActive():Bool
        {
            return this._isActive;
        }

        public var queueSetName(get,never):String;
public function  get_queueSetName():String
        {
            return this._name;
        }

        public var queueSetTarget(get,never):Int;
public function  get_queueSetTarget():Int
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

