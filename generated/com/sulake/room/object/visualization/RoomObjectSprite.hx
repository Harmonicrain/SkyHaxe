package com.sulake.room.object.visualization
;
    import flash.display.BitmapData;
    import flash.geom.Point;
    import com.sulake.room.object._enum.AlphaTolerance;
    import com.sulake.room.object._enum.RoomObjectSpriteType;

     final class RoomObjectSprite implements IRoomObjectSprite 
    {
        static var _globalInstanceId:Int = 0;

        var _asset:BitmapData = null;
        var _assetName:String = "";
        var _libraryAssetName:String = "";
        var _assetPosture:String = null;
        var _assetGesture:String = null;
        var _visible:Bool = true;
        var _tag:String = "";
        var _alpha:Int = 0xFF;
        var _color:Int = 0xFFFFFF;
        var _blendMode:String = "normal";
        var _flipH:Bool = false;
        var _flipV:Bool = false;
        var _direction:Int = 0;
        var _offset:Point;
        var _width:Int = 0;
        var _height:Int = 0;
        var _relativeDepth:Float = 0;
        var _planeId:Int = 0;
        var _varyingDepth:Bool = false;
        var _alphaTolerance:Int = 0;
        var _clickHandling:Bool = false;
        var _updateID:Int = 0;
        var _instanceId:Int = 0;
        var _filters:Array<ASAny> = null;
        var _skipMouseHandling:Bool = false;
        var _spriteType:Int = 0;
        var _objectType:String;

        public function new()
        {
            this._offset = new Point(0, 0);
            this._alphaTolerance = AlphaTolerance.MATCH_OPAQUE_PIXELS;
            this._spriteType = RoomObjectSpriteType.DEFAULT;
            this._instanceId = _globalInstanceId++;
        }

        public function dispose()
        {
            this._asset = null;
            this._width = 0;
            this._height = 0;
        }

        
        public var asset(get,set):BitmapData;
function  get_asset():BitmapData
        {
            return this._asset;
        }

        
        public var assetName(get,set):String;
function  get_assetName():String
        {
            return this._assetName;
        }

        
        public var assetPosture(get,set):String;
function  get_assetPosture():String
        {
            return this._assetPosture;
        }
function  set_assetPosture(k:String):String        {
            return this._assetPosture = k;
        }

        
        public var _Str_22618(get,set):String;
function  get__Str_22618():String
        {
            return this._assetGesture;
        }
function  set__Str_22618(k:String):String        {
            return this._assetGesture = k;
        }

        
        public var visible(get,set):Bool;
function  get_visible():Bool
        {
            return this._visible;
        }

        
        public var tag(get,set):String;
function  get_tag():String
        {
            return this._tag;
        }

        
        public var alpha(get,set):Int;
function  get_alpha():Int
        {
            return this._alpha;
        }

        
        public var color(get,set):Int;
function  get_color():Int
        {
            return this._color;
        }

        
        public var blendMode(get,set):String;
function  get_blendMode():String
        {
            return this._blendMode;
        }

        
        public var flipV(get,set):Bool;
function  get_flipV():Bool
        {
            return this._flipV;
        }

        
        public var flipH(get,set):Bool;
function  get_flipH():Bool
        {
            return this._flipH;
        }

        
        public var direction(get,set):Int;
function  get_direction():Int
        {
            return this._direction;
        }

        
        public var offsetX(get,set):Int;
function  get_offsetX():Int
        {
            return Std.int(this._offset.x);
        }

        
        public var offsetY(get,set):Int;
function  get_offsetY():Int
        {
            return Std.int(this._offset.y);
        }

        public var width(get,never):Int;
function  get_width():Int
        {
            return this._width;
        }

        public var height(get,never):Int;
function  get_height():Int
        {
            return this._height;
        }

        
        public var relativeDepth(get,set):Float;
function  get_relativeDepth():Float
        {
            return this._relativeDepth;
        }

        
        public var varyingDepth(get,set):Bool;
function  get_varyingDepth():Bool
        {
            return this._varyingDepth;
        }

        
        public var clickHandling(get,set):Bool;
function  get_clickHandling():Bool
        {
            return this._clickHandling;
        }

        public var instanceId(get,never):Int;
function  get_instanceId():Int
        {
            return this._instanceId;
        }

        public var updateId(get,never):Int;
function  get_updateId():Int
        {
            return this._updateID;
        }

        
        public var filters(get,set):Array<ASAny>;
function  get_filters():Array<ASAny>
        {
            return this._filters;
        }

        
        public var spriteType(get,set):Int;
function  get_spriteType():Int
        {
            return this._spriteType;
        }

        
        public var objectType(get,set):String;
function  get_objectType():String
        {
            return this._objectType;
        }
function  set_objectType(k:String):String        {
            return this._objectType = k;
        }

        
        public var planeId(get,set):Int;
function  get_planeId():Int
        {
            return this._planeId;
        }
function  set_planeId(k:Int):Int        {
            return this._planeId = k;
        }
function  set_spriteType(k:Int):Int        {
            return this._spriteType = k;
        }
function  set_asset(k:BitmapData):BitmapData        {
            if (k == this._asset)
            {
                return k;
            }
            if (k != null)
            {
                this._width = k.width;
                this._height = k.height;
            }
            this._asset = k;
            this._updateID++;
return k;
        }
function  set_assetName(k:String):String        {
            if (k == this._assetName)
            {
                return k;
            }
            this._assetName = k;
            this._updateID++;
return k;
        }
function  set_visible(k:Bool):Bool        {
            if (k == this._visible)
            {
                return k;
            }
            this._visible = k;
            this._updateID++;
return k;
        }
function  set_tag(k:String):String        {
            if (k == this._tag)
            {
                return k;
            }
            this._tag = k;
            this._updateID++;
return k;
        }
function  set_alpha(k:Int):Int        {
            k = (k & 0xFF);
            if (k == this._alpha)
            {
                return k;
            }
            this._alpha = k;
            this._updateID++;
return k;
        }
function  set_color(k:Int):Int        {
            k = (k & 0xFFFFFF);
            if (k == this._color)
            {
                return k;
            }
            this._color = k;
            this._updateID++;
return k;
        }
function  set_blendMode(k:String):String        {
            if (k == this._blendMode)
            {
                return k;
            }
            this._blendMode = k;
            this._updateID++;
return k;
        }
function  set_filters(k:Array<ASAny>):Array<ASAny>        {
            if (k == this._filters)
            {
                return k;
            }
            this._filters = k;
            this._updateID++;
return k;
        }

        
        public var skipMouseHandling(get,set):Bool;
function  get_skipMouseHandling():Bool
        {
            return this._skipMouseHandling;
        }
function  set_skipMouseHandling(k:Bool):Bool        {
            if (k == this._skipMouseHandling)
            {
                return k;
            }
            this._skipMouseHandling = k;
            this._updateID++;
return k;
        }
function  set_flipH(k:Bool):Bool        {
            if (k == this._flipH)
            {
                return k;
            }
            this._flipH = k;
            this._updateID++;
return k;
        }
function  set_flipV(k:Bool):Bool        {
            if (k == this._flipV)
            {
                return k;
            }
            this._flipV = k;
            this._updateID++;
return k;
        }
function  set_direction(k:Int):Int        {
            return this._direction = k;
        }
function  set_offsetX(k:Int):Int        {
            if (k == this._offset.x)
            {
                return k;
            }
            this._offset.x = k;
            this._updateID++;
return k;
        }
function  set_offsetY(k:Int):Int        {
            if (k == this._offset.y)
            {
                return k;
            }
            this._offset.y = k;
            this._updateID++;
return k;
        }
function  set_relativeDepth(k:Float):Float        {
            if (k == this._relativeDepth)
            {
                return k;
            }
            this._relativeDepth = k;
            this._updateID++;
return k;
        }
function  set_varyingDepth(k:Bool):Bool        {
            if (k == this._varyingDepth)
            {
                return k;
            }
            this._varyingDepth = k;
            this._updateID++;
return k;
        }
function  set_clickHandling(k:Bool):Bool        {
            if (this._clickHandling == k)
            {
                return k;
            }
            this._clickHandling = k;
            this._updateID++;
return k;
        }

        
        public var alphaTolerance(get,set):Int;
function  get_alphaTolerance():Int
        {
            return this._alphaTolerance;
        }
function  set_alphaTolerance(k:Int):Int        {
            if (this._alphaTolerance == k)
            {
                return k;
            }
            this._alphaTolerance = k;
            this._updateID++;
return k;
        }

        
        public var libraryAssetName(get,set):String;
function  get_libraryAssetName():String
        {
            return this._libraryAssetName;
        }
function  set_libraryAssetName(k:String):String        {
            return this._libraryAssetName = k;
        }
    }

