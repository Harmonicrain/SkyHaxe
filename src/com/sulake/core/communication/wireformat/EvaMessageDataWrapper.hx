package com.sulake.core.communication.wireformat;

import com.sulake.core.communication.messages.IMessageDataWrapper;
import js.html.TextDecoder;
import js.lib.ArrayBuffer;
import js.lib.DataView;
import js.lib.Uint8Array;

/** HTML5 equivalent of the clean client's big-endian EvaMessageDataWrapper. */
class EvaMessageDataWrapper implements IMessageDataWrapper {
    public var bytesAvailable(get, never):Int;

    final id:Int;
    final buffer:ArrayBuffer;
    final data:DataView;
    var position:Int;

    public function new(id:Int, buffer:ArrayBuffer, position:Int = 6) {
        this.id = id;
        this.buffer = buffer;
        data = new DataView(buffer);
        this.position = position;
    }

    public function getID():Int return id;

    public function readString():String {
        var length = data.getUint16(position, false);
        position += 2;
        require(length);
        var result = new TextDecoder().decode(new Uint8Array(buffer, position, length));
        position += length;
        return result;
    }

    public function readInteger():Int {
        require(4);
        var result = data.getInt32(position, false);
        position += 4;
        return result;
    }

    public function readBoolean():Bool {
        require(1);
        return data.getUint8(position++) != 0;
    }

    public function readShort():Int {
        require(2);
        var result = data.getInt16(position, false);
        position += 2;
        return result;
    }

    public function readByte():Int {
        require(1);
        return data.getInt8(position++);
    }

    public function readFloat():Float {
        require(4);
        var result = data.getFloat32(position, false);
        position += 4;
        return result;
    }

    public function readDouble():Float {
        require(8);
        var result = data.getFloat64(position, false);
        position += 8;
        return result;
    }

    public function readLong():Float {
        var high = readInteger();
        require(4);
        var low = data.getUint32(position, false);
        position += 4;
        return high * 4294967296.0 + low;
    }

    function get_bytesAvailable():Int return data.byteLength - position;

    function require(length:Int):Void {
        if (length < 0 || position + length > data.byteLength)
            throw 'Packet $id truncated at $position; need $length bytes, ${bytesAvailable} remain';
    }
}
