package com.sulake.habbo.communication.messages.incoming.navigator
;
     class RoomThumbnailObjectData
    {
        var _Str_6304:Int = 0;
        var _Str_12644:Int = 0;


        public function _Str_20539():RoomThumbnailObjectData
        {
            var k= new RoomThumbnailObjectData();
            k._Str_6304 = this._Str_6304;
            k._Str_12644 = this._Str_12644;
            return k;
        }

        
        public var _Str_12651(get,set):Int;
public function  set__Str_12651(k:Int):Int        {
            return this._Str_6304 = k;
        }

        
        public var _Str_13964(get,set):Int;
public function  set__Str_13964(k:Int):Int        {
            return this._Str_12644 = k;
        }
public function  get__Str_12651():Int
        {
            return this._Str_6304;
        }
public function  get__Str_13964():Int
        {
            return this._Str_12644;
        }
public function new(){}
    }

