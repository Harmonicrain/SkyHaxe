package com.sulake.core.communication.wireformat
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import flash.utils.ByteArray;
    import com.hurlant.util.Hex;

    /*internal*/ final class EvaMessageDataWrapper implements IMessageDataWrapper 
    {
        var _id:Int = 0;
        var _data:com.sulake.core.utils.ByteArray;

        public function new(k:Int, _arg_2:com.sulake.core.utils.ByteArray)
        {
            this._id = k;
            this._data = _arg_2;
        }

        public function getID():Int
        {
            return this._id;
        }

        public function readString():String
        {
            return this._data.readUTF();
        }

        public function readInteger():Int
        {
            return this._data.readInt();
        }

        public function readBoolean():Bool
        {
            return this._data.readBoolean();
        }

        public function readShort():Int
        {
            return this._data.readShort();
        }

        public function readByte():Int
        {
            return this._data.readByte();
        }

        public function readFloat():Float
        {
            return this._data.readFloat();
        }

        public function readDouble():Float
        {
            return this._data.readDouble();
        }

        public function readLong():Float
        {
            var high= this._data.readInt();
            var low= this._data.readUnsignedInt();
            return high * 4294967296 + low;
        }

        public var bytesAvailable(get,never):UInt;
public function  get_bytesAvailable():UInt
        {
            return this._data.bytesAvailable;
        }

        public function toString():String
        {
            return (((("id=" + Std.string(this._id)) + ", pos=") + Std.string(this._data.position)) + ", data=") + Hex.fromArray(this._data, true);
        }
    }

