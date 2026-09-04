package com.sulake.core.assets;

import com.sulake.core.utils.xml.XMLList;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.utils.ByteArray.ByteArrayData;

class BitmapDataAsset implements ILazyAsset {
    public static var instances(get, never):Int;
    public static var allocatedByteCount(get, never):Int;

    public var name:String;
    public var url(get, never):Null<String>;
    public var content(get, never):Dynamic;
    public var declaration(get, never):Null<AssetTypeDeclaration>;
    public var disposed(get, never):Bool;
    public var flipH(get, never):Bool;
    public var flipV(get, never):Bool;
    public var offset(get, never):Null<Point>;
    public var rectangle(get, never):Null<Rectangle>;
    public var ownsData(get, set):Bool;

    private static var _instances = 0;
    private static var _allocatedByteCount = 0;

    private var _disposed = false;
    private var _rectangle:Null<Rectangle>;
    private var _unknown:Dynamic;
    private var _bitmap:Null<BitmapData>;
    private var _offset:Null<Point>;
    private var _flipH = false;
    private var _flipV = false;
    private var _declaration:Null<AssetTypeDeclaration>;
    private var _url:Null<String>;
    private var _ownsData = true;
    private var _accountedBytes = 0;

    public function new(declaration:AssetTypeDeclaration, ?url:String) {
        _declaration = declaration;
        _url = url;
        _offset = new Point();
        _instances++;
    }

    private static inline function get_instances():Int return _instances;
    private static inline function get_allocatedByteCount():Int return _allocatedByteCount;
    private inline function get_url():Null<String> return _url;
    private function get_content():Dynamic {
        if (_bitmap == null) prepareLazyContent();
        return _bitmap;
    }
    private inline function get_declaration():Null<AssetTypeDeclaration> return _declaration;
    private inline function get_disposed():Bool return _disposed;
    private inline function get_flipH():Bool return _flipH;
    private inline function get_flipV():Bool return _flipV;
    private inline function get_offset():Null<Point> return _offset;
    private function get_rectangle():Null<Rectangle> {
        if (_rectangle == null && get_content() != null) _rectangle = _bitmap.rect;
        return _rectangle;
    }
    private inline function get_ownsData():Bool return _ownsData;

    private function set_ownsData(value:Bool):Bool {
        if (_ownsData == value) return value;
        _ownsData = value;
        if (_bitmap != null) {
            if (value) accountBitmap(); else unaccountBitmap();
        }
        return value;
    }

    public function setUnknownContent(unknown:Dynamic):Void {
        releaseCurrentBitmap();
        _unknown = unknown;
        _bitmap = null;
        _rectangle = null;
        _ownsData = true;
    }

    public function prepareLazyContent():Void {
        if (_unknown == null || _bitmap != null) return;
        var value:Dynamic = _unknown;
        if (Std.isOfType(value, Class)) value = Type.createInstance(cast value, []);

        if (Std.isOfType(value, Bitmap)) {
            var bitmap:Bitmap = cast value;
            adopt(bitmap.bitmapData, true);
            bitmap.bitmapData = null;
            return;
        }
        if (Std.isOfType(value, BitmapData)) {
            adopt(cast value, true);
            return;
        }
        if (Std.isOfType(value, BitmapDataAsset)) {
            var source:BitmapDataAsset = cast value;
            source.prepareLazyContent();
            borrowFrom(source);
            return;
        }
        if (Std.isOfType(value, ByteArrayData)) {
            throw new haxe.Exception("Encoded bitmap bytes must be decoded by the G2 reader before entering BitmapDataAsset");
        }
        throw new haxe.Exception("Failed to convert content to BitmapDataAsset");
    }

    private function adopt(bitmap:Null<BitmapData>, owns:Bool):Void {
        if (bitmap == null) throw new haxe.Exception("BitmapDataAsset received a Bitmap without BitmapData");
        _bitmap = bitmap;
        _unknown = null;
        _ownsData = owns;
        if (owns) accountBitmap();
    }

    private function borrowFrom(source:BitmapDataAsset):Void {
        _bitmap = cast source.content;
        _unknown = null;
        _ownsData = false;
        _offset = source._offset == null ? null : source._offset.clone();
        _flipH = source._flipH;
        _flipV = source._flipV;
        _rectangle = source._rectangle == null ? null : source._rectangle.clone();
    }

    private function accountBitmap():Void {
        if (_bitmap == null || _accountedBytes != 0) return;
        _accountedBytes = _bitmap.width * _bitmap.height * 4;
        _allocatedByteCount += _accountedBytes;
    }

    private function unaccountBitmap():Void {
        if (_accountedBytes == 0) return;
        _allocatedByteCount -= _accountedBytes;
        _accountedBytes = 0;
    }

    private function releaseCurrentBitmap():Void {
        if (_bitmap != null && _ownsData) {
            unaccountBitmap();
            _bitmap.dispose();
        } else {
            unaccountBitmap();
        }
        _bitmap = null;
    }

    public function setFromOtherAsset(asset:IAsset):Void {
        if (!Std.isOfType(asset, BitmapDataAsset)) {
            throw new haxe.Exception("Provided asset should be of type BitmapDataAsset!");
        }
        releaseCurrentBitmap();
        borrowFrom(cast asset);
    }

    public function setParamsDesc(xml:XMLList):Void {
        for (entry in xml) {
            var key = entry.attribute("key").toString();
            var values = entry.attribute("value").toString().split(",");
            switch key {
                case "offset":
                    requireValues(key, values, 2);
                    _offset.x = parse(values[0]);
                    _offset.y = parse(values[1]);
                case "region":
                    requireValues(key, values, 4);
                    _rectangle = new Rectangle(parse(values[0]), parse(values[1]), parse(values[2]), parse(values[3]));
                case "flipH": _flipH = values[0] == "1" || values[0] == "true";
                case "flipV": _flipV = values[0] == "1" || values[0] == "true";
                default:
            }
        }
    }

    private static function requireValues(key:String, values:Array<String>, count:Int):Void {
        if (values.length < count) throw new haxe.Exception('$key requires $count comma-separated values');
    }

    private static function parse(value:String):Int {
        var result = Std.parseInt(value);
        if (result == null) throw new haxe.Exception('Invalid integer bitmap parameter: $value');
        return result;
    }

    public function dispose():Void {
        if (_disposed) return;
        releaseCurrentBitmap();
        _unknown = null;
        _offset = null;
        _declaration = null;
        _url = null;
        _rectangle = null;
        _disposed = true;
        _instances--;
    }
}
