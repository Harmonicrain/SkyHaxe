package com.sulake.habbo.communication.messages.incoming.room.furniture
;
     class RoomDimmerPresetsMessageData
    {
        var _id:Int = 0;
        var _type:Int = 0;
        var _color:UInt = 0;
        var _Str_3576:UInt = 0;
        var _isReadOnly:Bool = false;

        public function new(k:Int)
        {
            this._id = k;
        }

        public function setReadOnly()
        {
            this._isReadOnly = true;
        }

        public var id(get,never):Int;
function  get_id():Int
        {
            return this._id;
        }

        
        public var type(get,set):Int;
function  get_type():Int
        {
            return this._type;
        }
function  set_type(k:Int):Int        {
            if (!this._isReadOnly)
            {
                this._type = k;
            }
return k;
        }

        
        public var color(get,set):UInt;
function  get_color():UInt
        {
            return this._color;
        }
function  set_color(k:UInt):UInt        {
            if (!this._isReadOnly)
            {
                this._color = k;
            }
return k;
        }

        
        public var brightness(get,set):Int;
function  get_brightness():Int
        {
            return this._Str_3576;
        }
function  set_brightness(k:Int):Int        {
            if (!this._isReadOnly)
            {
                this._Str_3576 = k;
            }
return k;
        }
    }

