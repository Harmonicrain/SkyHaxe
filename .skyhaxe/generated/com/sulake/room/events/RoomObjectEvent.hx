package com.sulake.room.events
;
    import flash.events.Event;
    import com.sulake.room.object.IRoomObject;

     class RoomObjectEvent extends Event 
    {
        var _object:IRoomObject;

        public function new(k:String, _arg_2:IRoomObject, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            super(k, _arg_3, _arg_4);
            this._object = _arg_2;
        }

        public var object(get,never):IRoomObject;
public function  get_object():IRoomObject
        {
            return this._object;
        }

        public var objectId(get,never):Int;
public function  get_objectId():Int
        {
            if (this._object != null)
            {
                return this._object.getId();
            }
            return -1;
        }

        public var objectType(get,never):String;
public function  get_objectType():String
        {
            if (this._object != null)
            {
                return this._object.getType();
            }
            return null;
        }
    }

