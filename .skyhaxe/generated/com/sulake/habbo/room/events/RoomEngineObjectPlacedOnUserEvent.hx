package com.sulake.habbo.room.events
;
     class RoomEngineObjectPlacedOnUserEvent extends RoomEngineObjectEvent 
    {
        var _droppedObjectId:Int = 0;
        var _droppedObjectCategory:Int = 0;

        public function new(k:String, _arg_2:Int, _arg_3:Int, _arg_4:Int, _arg_5:Int, _arg_6:Int, _arg_7:Bool=false, _arg_8:Bool=false)
        {
            super(k, _arg_2, _arg_3, _arg_4, _arg_7, _arg_8);
            this._droppedObjectId = this.droppedObjectId;
            this._droppedObjectCategory = _arg_6;
        }

        public var droppedObjectId(get,never):Int;
public function  get_droppedObjectId():Int
        {
            return this._droppedObjectId;
        }

        public var droppedObjectCategory(get,never):Int;
public function  get_droppedObjectCategory():Int
        {
            return this._droppedObjectCategory;
        }
    }

