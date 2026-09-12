package com.sulake.habbo.communication.messages.parser.room.engine
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class HeightMapMessageParser implements IMessageParser 
    {
        static inline final STACKING_BLOCKED= 0x4000;
        static inline final HEIGHT_MASK= 16383;

        var _data:Vector<Int>;
        var _width:Int = 0;
        var _height:Int = 0;


        public static function decodeTileHeight(k:Int):Float
        {
            return (k < 0) ? -1 : ((k & HEIGHT_MASK) / 0x0100);
        }

        public static function decodeIsStackingBlocked(k:Int):Bool
        {
            return ASCompat.toBool((k & STACKING_BLOCKED));
        }

        public static function decodeIsRoomTile(k:Int):Bool
        {
            return k >= 0;
        }


        public var width(get,never):Int;
public function  get_width():Int
        {
            return this._width;
        }

        public var height(get,never):Int;
public function  get_height():Int
        {
            return this._height;
        }

        public function getTileHeight(k:Int, _arg_2:Int):Float
        {
            if (((((k < 0) || (k >= this._width)) || (_arg_2 < 0)) || (_arg_2 >= this._height)))
            {
                return -1;
            }
            return decodeTileHeight(this._data[((_arg_2 * this._width) + k)]);
        }

        public function getStackingBlocked(k:Int, _arg_2:Int):Bool
        {
            if (((((k < 0) || (k >= this._width)) || (_arg_2 < 0)) || (_arg_2 >= this._height)))
            {
                return true;
            }
            return decodeIsStackingBlocked(this._data[((_arg_2 * this._width) + k)]);
        }

        public function isRoomTile(k:Int, _arg_2:Int):Bool
        {
            if (((((k < 0) || (k >= this._width)) || (_arg_2 < 0)) || (_arg_2 >= this._height)))
            {
                return false;
            }
            return decodeIsRoomTile(this._data[((_arg_2 * this._width) + k)]);
        }

        public function flush():Bool
        {
            this._data = null;
            this._width = 0;
            this._height = 0;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            if (k == null)
            {
                return false;
            }
            this._width = k.readInteger();
            var _local_2= k.readInteger();
            this._height = Std.int(_local_2 / this._width);
            this._data = new Vector<Int>(_local_2);
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._data[_local_3] = k.readShort();
                _local_3++;
            }
            return true;
        }

	public function new() {}
    }

