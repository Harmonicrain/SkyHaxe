package com.sulake.habbo.room.messages
;
    import com.sulake.room.messages.RoomObjectUpdateMessage;

     class RoomObjectModelDataUpdateMessage extends RoomObjectUpdateMessage 
    {
        var _numberKey:String;
        var _numberValue:Int = 0;

        public function new(k:String, _arg_2:Int)
        {
            super(null, null);
            this._numberKey = k;
            this._numberValue = _arg_2;
        }

        public var numberKey(get,never):String;
public function  get_numberKey():String
        {
            return this._numberKey;
        }

        public var numberValue(get,never):Int;
public function  get_numberValue():Int
        {
            return this._numberValue;
        }
    }

