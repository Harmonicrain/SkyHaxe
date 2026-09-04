package com.sulake.room.renderer.utils
;
    import flash.display.Bitmap;
    import flash.geom.Point;
    import flash.display.BitmapData;

     class ExtendedSprite extends Bitmap 
    {
        var _threshold:Int = 128;
        var _Str_24201:Point;
        var _tag:String = "";
        var _identifier:String = "";
        var _clickHandling:Bool = false;
        var _skipMouseHandling:Bool = false;
        var _varyingDepth:Bool = false;
        var _bitmapData:ExtendedBitmapData = null;
        var _width:Int = 0;
        var _height:Int = 0;
        var _updateID1:Int = -1;
        var _updateID2:Int = -1;
        var _Str_21169:Int = 0;
        var _Str_19420:Int = 0;

        public function new()        {
            super();
            this._Str_24201 = new Point();
            cacheAsBitmap = false;
        }

        
        public var alphaTolerance(get,set):Int;
function  get_alphaTolerance():Int
        {
            return this._threshold;
        }
function  set_alphaTolerance(k:Int):Int        {
            return this._threshold = k;
        }

        
        public var skipMouseHandling(get,set):Bool;
function  get_skipMouseHandling():Bool
        {
            return this._skipMouseHandling;
        }
function  set_skipMouseHandling(k:Bool):Bool        {
            return this._skipMouseHandling = k;
        }

        
        public var tag(get,set):String;
function  get_tag():String
        {
            return this._tag;
        }
function  set_tag(k:String):String        {
            return this._tag = k;
        }

        
        public var identifier(get,set):String;
function  get_identifier():String
        {
            return this._identifier;
        }
function  set_identifier(k:String):String        {
            return this._identifier = k;
        }

        
        public var varyingDepth(get,set):Bool;
function  get_varyingDepth():Bool
        {
            return this._varyingDepth;
        }
function  set_varyingDepth(k:Bool):Bool        {
            return this._varyingDepth = k;
        }

        
        public var clickHandling(get,set):Bool;
function  get_clickHandling():Bool
        {
            return this._clickHandling;
        }
function  set_clickHandling(k:Bool):Bool        {
            return this._clickHandling = k;
        }

        
        public var _Str_14797(get,set):Int;
function  get__Str_14797():Int
        {
            return this._Str_21169;
        }
function  set__Str_14797(k:Int):Int        {
            return this._Str_21169 = k;
        }

        
        public var _Str_13379(get,set):Int;
function  get__Str_13379():Int
        {
            return this._Str_19420;
        }
function  set__Str_13379(k:Int):Int        {
            return this._Str_19420 = k;
        }

        public function dispose()
        {
            if (this._bitmapData != null)
            {
                this._bitmapData.dispose();
                this._bitmapData = null;
            }
        }

        override function  set_bitmapData(k:BitmapData):BitmapData        {
            var _local_2:ExtendedBitmapData;
            if (k == bitmapData)
            {
                return k;
            }
            if (this._bitmapData != null)
            {
                this._bitmapData.dispose();
                this._bitmapData = null;
            }
            if (k != null)
            {
                this._width = k.width;
                this._height = k.height;
                _local_2 = Std.downcast(k , ExtendedBitmapData);
                if (_local_2 != null)
                {
                    _local_2._Str_9215();
                    this._bitmapData = _local_2;
                }
            }
            else
            {
                this._width = 0;
                this._height = 0;
                this._updateID1 = -1;
                this._updateID2 = -1;
            }
            return super.bitmapData = k;
        }

        public function _Str_17574(k:Int, _arg_2:Int):Bool
        {
            if (((!(k == this._updateID1)) || (!(_arg_2 == this._updateID2))))
            {
                this._updateID1 = k;
                this._updateID2 = _arg_2;
                return true;
            }
            if (((!(this._bitmapData == null)) && this._bitmapData.disposed))
            {
                return true;
            }
            return false;
        }

        override public function hitTestPoint(k:Float, _arg_2:Float, _arg_3:Bool=false):Bool
        {
            return this.hitTest(Std.int(k), Std.int(_arg_2));
        }

        public function hitTest(k:Int, _arg_2:Int):Bool
        {
            if (((this._threshold > 0xFF) || (bitmapData == null)))
            {
                return false;
            }
            if (((((k < 0) || (_arg_2 < 0)) || (k >= this._width)) || (_arg_2 >= this._height)))
            {
                return false;
            }
            return this.hitTestBitmapData(k, _arg_2);
        }

        function hitTestBitmapData(k:Int, _arg_2:Int):Bool
        {
            var _local_4:UInt;
            var _local_3 = false;
            try
            {
                _local_4 = bitmapData.getPixel32(k, _arg_2);
                _local_4 = (_local_4 >> 24);
                _local_3 = (_local_4 > (this._threshold : UInt));
            }
            catch(e:ASError)
            {
            }
            return _local_3;
        }
    }

