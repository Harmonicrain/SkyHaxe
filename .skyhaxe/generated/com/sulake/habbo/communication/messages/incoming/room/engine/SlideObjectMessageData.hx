package com.sulake.habbo.communication.messages.incoming.room.engine
;
    import com.sulake.room.utils.Vector3d;

     class SlideObjectMessageData
    {
        public static inline final MV= "mv";
        public static inline final SLD= "sld";

        var _id:Int = 0;
        var _loc:Vector3d;
        var _target:Vector3d;
        var _moveType:String;
        var _isReadOnly:Bool = false;

        public function new(id:Int, loc:Vector3d, target:Vector3d, moveType:String=null)
        {
            this._id = id;
            this._loc = loc;
            this._target = target;
            this._moveType = moveType;
        }

        public function setReadOnly()
        {
            this._isReadOnly = true;
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }

        
        public var loc(get,set):Vector3d;
public function  get_loc():Vector3d
        {
            return this._loc;
        }
public function  set_loc(k:Vector3d):Vector3d        {
            if (!this._isReadOnly)
            {
                this._loc = k;
            }
return k;
        }

        
        public var target(get,set):Vector3d;
public function  get_target():Vector3d
        {
            return this._target;
        }
public function  set_target(k:Vector3d):Vector3d        {
            if (!this._isReadOnly)
            {
                this._target = k;
            }
return k;
        }

        
        public var _Str_21300(get,set):String;
public function  get__Str_21300():String
        {
            return this._moveType;
        }
public function  set__Str_21300(k:String):String        {
            if (!this._isReadOnly)
            {
                this._moveType = k;
            }
return k;
        }
    }

