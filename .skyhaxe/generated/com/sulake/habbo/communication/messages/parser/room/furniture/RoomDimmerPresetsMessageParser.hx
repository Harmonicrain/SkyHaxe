package com.sulake.habbo.communication.messages.parser.room.furniture
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.room.furniture.RoomDimmerPresetsMessageData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class RoomDimmerPresetsMessageParser implements IMessageParser 
    {
        var _selectedPresetId:Int = 0;
        var _presets:Array<ASAny>;

        public function new()
        {
            this._presets = [];
        }

        public var _Str_10888(get,never):Int;
public function  get__Str_10888():Int
        {
            return this._presets.length;
        }

        public var _Str_6226(get,never):Int;
public function  get__Str_6226():Int
        {
            return this._selectedPresetId;
        }

        public function getPreset(k:Int):RoomDimmerPresetsMessageData
        {
            if (((k < 0) || (k >= this._Str_10888)))
            {
                return null;
            }
            return this._presets[k];
        }

        public function flush():Bool
        {
            this._presets = [];
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_4 = 0;
            var _local_5 = 0;
            var _local_6:String = null;
            var _local_7 = 0;
            var _local_8 = 0;
            var _local_9:RoomDimmerPresetsMessageData = null;
            var _local_2= k.readInteger();
            this._selectedPresetId = k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                _local_4 = k.readInteger();
                _local_5 = k.readInteger();
                _local_6 = k.readString();
                _local_7 = ASCompat.parseInt(_local_6.substr(1), 16);
                _local_8 = k.readInteger();
                _local_9 = new RoomDimmerPresetsMessageData(_local_4);
                _local_9.type = _local_5;
                _local_9.color = _local_7;
                _local_9.brightness = _local_8;
                _local_9.setReadOnly();
                this._presets.push(_local_9);
                _local_3++;
            }
            return true;
        }
    }

