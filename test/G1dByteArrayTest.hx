import com.sulake.core.utils.ByteArray;
import openfl.utils.ByteArray as OpenFLByteArray;
import openfl.utils.Endian;

class G1dByteArrayTest {
    public static var assertions(default, null):Int = 0;

    public static function main():Void {
        testFlashDefaultAndNumbers();
        testLittleEndianOverride();
        testUtfAndCopies();
        testLengthPositionAndArrayAccess();
        testCompression();
        testOpenFLBoundary();
        trace('G1D_BYTEARRAY_PASS assertions=$assertions');
    }

    private static function testFlashDefaultAndNumbers():Void {
        var bytes = new ByteArray();
        equal(Endian.BIG_ENDIAN, bytes.endian, "adapter enforces Flash big-endian default");
        bytes.writeByte(-2);
        bytes.writeShort(-1234);
        bytes.writeUnsignedInt(0x89ABCDEF);
        bytes.writeInt(-123456789);
        bytes.writeFloat(1.25);
        bytes.writeDouble(-9.5);
        bytes.writeBoolean(true);
        bytes.writeBoolean(false);

        equal(25, bytes.length, "numeric writes have Flash widths");
        equal(25, bytes.position, "writes advance position");
        equal(0, bytes.bytesAvailable, "nothing remains at end");
        bytes.position = 0;
        equal(-2, bytes.readByte(), "signed byte round trip");
        equal(-1234, bytes.readShort(), "signed short round trip");
        equal(0x89ABCDEF, bytes.readUnsignedInt(), "unsigned int bit pattern round trip");
        equal(-123456789, bytes.readInt(), "signed int round trip");
        near(1.25, bytes.readFloat(), 0.000001, "float round trip");
        near(-9.5, bytes.readDouble(), 0.000000001, "double round trip");
        equal(true, bytes.readBoolean(), "true round trip");
        equal(false, bytes.readBoolean(), "false round trip");
        equal(0, bytes.bytesAvailable, "numeric reads consume all data");

        var network = new ByteArray();
        network.writeInt(0x12345678);
        equal(0x12, network[0], "big-endian most-significant byte first");
        equal(0x78, network[3], "big-endian least-significant byte last");
    }

    private static function testLittleEndianOverride():Void {
        var bytes = new ByteArray();
        bytes.endian = Endian.LITTLE_ENDIAN;
        bytes.writeInt(0x12345678);
        equal(0x78, bytes[0], "little-endian override first byte");
        equal(0x12, bytes[3], "little-endian override final byte");
        bytes.position = 0;
        equal(0x12345678, bytes.readInt(), "little-endian round trip");
    }

    private static function testUtfAndCopies():Void {
        var bytes = new ByteArray();
        bytes.writeUTF("Héllo");
        bytes.writeUTFBytes("世界");
        var lengthAfterWrite = bytes.length;
        bytes.position = 0;
        equal("Héllo", bytes.readUTF(), "length-prefixed UTF-8 round trip");
        equal("世界", bytes.readUTFBytes(bytes.bytesAvailable), "raw UTF-8 round trip");
        equal(lengthAfterWrite, bytes.position, "UTF reads consume exact byte length");

        var source = new ByteArray();
        source.writeUTFBytes("abcdef");
        source.position = 1;
        var target = new ByteArray();
        source.readBytes(target, 2, 3);
        equal(4, source.position, "readBytes advances source position");
        equal(5, target.length, "readBytes honors destination offset");
        equal(0, target[0], "destination gap is zero-filled");
        target.position = 2;
        equal("bcd", target.readUTFBytes(3), "readBytes copies requested slice");

        var copied = new ByteArray();
        copied.writeBytes(target, 2, 3);
        copied.position = 0;
        equal("bcd", copied.readUTFBytes(copied.length), "writeBytes copies requested slice");
    }

    private static function testLengthPositionAndArrayAccess():Void {
        var bytes = new ByteArray();
        bytes.length = 4;
        equal(4, bytes.length, "length can grow storage");
        equal(0, bytes[3], "grown storage is zero-filled");
        bytes[1] = 255;
        equal(255, bytes[1], "indexed byte write/read");
        bytes.position = 3;
        equal(1, bytes.bytesAvailable, "bytesAvailable follows position");
        bytes.length = 2;
        equal(2, bytes.length, "length truncates storage");
        equal(2, bytes.position, "truncation clamps position");
        bytes.clear();
        equal(0, bytes.length, "clear resets length");
        equal(0, bytes.position, "clear resets position");
    }

    private static function testCompression():Void {
        var original = "Habbo-Haxe compression parity — ";
        var bytes = new ByteArray();
        for (_ in 0...32) {
            bytes.writeUTFBytes(original);
        }
        var uncompressedLength = bytes.length;
        bytes.compress();
        equal(true, bytes.length < uncompressedLength, "zlib compression reduces repeated data");
        bytes.uncompress();
        equal(uncompressedLength, bytes.length, "zlib uncompress restores length");
        bytes.position = 0;
        equal([for (_ in 0...32) original].join(""), bytes.readUTFBytes(bytes.length), "zlib restores bytes");

        var raw = new ByteArray();
        raw.writeUTFBytes("raw-deflate-raw-deflate-raw-deflate");
        var rawTextLength = raw.length;
        raw.deflate();
        equal(true, raw.length < rawTextLength, "raw deflate compresses data");
        raw.inflate();
        raw.position = 0;
        equal("raw-deflate-raw-deflate-raw-deflate", raw.readUTFBytes(raw.length), "raw inflate restores bytes");
    }

    private static function testOpenFLBoundary():Void {
        var openfl = new OpenFLByteArray();
        openfl.endian = Endian.LITTLE_ENDIAN;
        var adapted:ByteArray = openfl;
        equal(Endian.BIG_ENDIAN, adapted.endian, "incoming OpenFL ByteArray is normalized");
        var returned:OpenFLByteArray = adapted;
        equal(openfl, returned, "adapter conversion does not copy storage");
    }

    private static function near(expected:Float, actual:Float, epsilon:Float, message:String):Void {
        assertions++;
        if (Math.abs(expected - actual) > epsilon) {
            throw new haxe.Exception('$message: expected $expected, got $actual');
        }
    }

    private static function equal(expected:Dynamic, actual:Dynamic, message:String):Void {
        assertions++;
        if (expected != actual) {
            throw new haxe.Exception('$message: expected ${Std.string(expected)}, got ${Std.string(actual)}');
        }
    }
}
