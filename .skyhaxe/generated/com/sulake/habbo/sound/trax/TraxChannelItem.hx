package com.sulake.habbo.sound.trax
;
     class TraxChannelItem 
    {
        var _id:Int = 0;
        var _length:Int = 0;

        public function new(id:Int, length:Int)
        {
            this._id = id;
            this._length = length;
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }

        public var length(get,never):Int;
public function  get_length():Int
        {
            return this._length;
        }
    }

