package com.sulake.habbo.communication.messages.parser.room.engine
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class RoomVisualizationSettingsParser implements IMessageParser
    {
        var _wallsHidden:Bool = false;
        var _wallThicknessMultiplier:Float = 1;
        var _floorThicknessMultiplier:Float = 1;


        public var wallsHidden(get,never):Bool;
public function  get_wallsHidden():Bool
        {
            return this._wallsHidden;
        }

        public var wallThicknessMultiplier(get,never):Float;
public function  get_wallThicknessMultiplier():Float
        {
            return this._wallThicknessMultiplier;
        }

        public var floorThicknessMultiplier(get,never):Float;
public function  get_floorThicknessMultiplier():Float
        {
            return this._floorThicknessMultiplier;
        }

        public function flush():Bool
        {
            this._wallsHidden = false;
            this._wallThicknessMultiplier = 1;
            this._floorThicknessMultiplier = 1;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            if (k == null)
            {
                return false;
            }
            this._wallsHidden = k.readBoolean();
            var _local_2= k.readInteger();
            var _local_3= k.readInteger();
            if (_local_2 < -2)
            {
                _local_2 = -2;
            }
            else
            {
                if (_local_2 > 1)
                {
                    _local_2 = 1;
                }
            }
            if (_local_3 < -2)
            {
                _local_3 = -2;
            }
            else
            {
                if (_local_3 > 1)
                {
                    _local_3 = 1;
                }
            }
            this._wallThicknessMultiplier = Math.pow(2, _local_2);
            this._floorThicknessMultiplier = Math.pow(2, _local_3);
            return true;
        }

	public function new() {}
    }

