package com.sulake.core.utils;

import openfl.utils.ByteArray as OpenFLByteArray;
import openfl.utils.Endian;

/**
 * Flash-compatible ByteArray boundary.
 *
 * OpenFL defaults to platform endianness on non-Flash targets. Flash/AIR
 * ByteArray always starts big-endian, which the Habbo wire format assumes.
 */
@:forward
abstract ByteArray(OpenFLByteArray) {
    public inline function new(length:Int = 0) {
        this = new OpenFLByteArray(length);
        this.endian = Endian.BIG_ENDIAN;
    }

    @:from
    public static inline function fromOpenFL(value:OpenFLByteArray):ByteArray {
        value.endian = Endian.BIG_ENDIAN;
        return cast value;
    }

    @:to
    public inline function toOpenFL():OpenFLByteArray {
        return this;
    }

    @:arrayAccess
    public inline function get(index:Int):Int {
        return this[index];
    }

    @:arrayAccess
    public inline function set(index:Int, value:Int):Int {
        this[index] = value;
        return value;
    }

    /** Keep converted IEncryption results inside the SkyHaxe ByteArray contract. */
    public inline function writeBytes(bytes:ByteArray, offset:Int = 0, length:Int = 0):Void {
        this.writeBytes(bytes.toOpenFL(), offset, length);
    }

    /** AS3 coerces Number arguments to uint; Haxe otherwise rejects large decimal PNG constants. */
    public inline function writeUnsignedInt(value:Dynamic):Void {
        this.writeUnsignedInt(cast ASCompat.toUInt(value));
    }
}
