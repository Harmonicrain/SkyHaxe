package com.sulake.room.object.visualization.utils
;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.core.assets.IAsset;
    import flash.display.BitmapData;

     class GraphicAsset implements IGraphicAsset 
    {
        static final _POOL:Vector<GraphicAsset> = new Vector();

        var _assetName:String;
        var _libraryAssetName:String;
        var _asset:BitmapDataAsset;
        var _flipH:Bool = false;
        var _flipV:Bool = false;
        var _usesPalette:Bool = false;
        var _offsetX:Int = 0;
        var _offsetY:Int = 0;
        var _width:Int = 0;
        var _height:Int = 0;
        var _initialized:Bool = false;


        public static function _Str_2363(k:String, _arg_2:String, _arg_3:IAsset, _arg_4:Bool, _arg_5:Bool, _arg_6:Int, _arg_7:Int, _arg_8:Bool=false):GraphicAsset
        {
            var _local_9= ((_POOL.length > 0) ? _POOL.pop() : Type.createInstance(GraphicAsset, []));
            _local_9._assetName = k;
            _local_9._libraryAssetName = _arg_2;
            var _local_10= Std.downcast(_arg_3 , BitmapDataAsset);
            if (_local_10 != null)
            {
                _local_9._asset = _local_10;
                _local_9._initialized = false;
            }
            else
            {
                _local_9._asset = null;
                _local_9._initialized = true;
            }
            _local_9._flipH = _arg_4;
            _local_9._flipV = _arg_5;
            _local_9._offsetX = _arg_6;
            _local_9._offsetY = _arg_7;
            _local_9._usesPalette = _arg_8;
            return _local_9;
        }


        public function recycle()
        {
            this._asset = null;
            _POOL.push(this);
        }

        function initialize()
        {
            var k:BitmapData = null;
            if (((!this._initialized) && (!(this._asset == null))))
            {
                k = ASCompat.dynamicAs(this._asset.content , BitmapData);
                if (k != null)
                {
                    this._width = k.width;
                    this._height = k.height;
                }
                this._initialized = true;
            }
        }

        public var flipV(get,never):Bool;
public function  get_flipV():Bool
        {
            return this._flipV;
        }

        public var flipH(get,never):Bool;
public function  get_flipH():Bool
        {
            return this._flipH;
        }

        public var width(get,never):Int;
public function  get_width():Int
        {
            this.initialize();
            return this._width;
        }

        public var height(get,never):Int;
public function  get_height():Int
        {
            this.initialize();
            return this._height;
        }

        public var assetName(get,never):String;
public function  get_assetName():String
        {
            return this._assetName;
        }

        public var libraryAssetName(get,never):String;
public function  get_libraryAssetName():String
        {
            return this._libraryAssetName;
        }

        public var asset(get,never):IAsset;
public function  get_asset():IAsset
        {
            return this._asset;
        }

        public var usesPalette(get,never):Bool;
public function  get_usesPalette():Bool
        {
            return this._usesPalette;
        }

        public var offsetX(get,never):Int;
public function  get_offsetX():Int
        {
            if (!this._flipH)
            {
                return this._offsetX;
            }
            return -(this.width + this._offsetX);
        }

        public var offsetY(get,never):Int;
public function  get_offsetY():Int
        {
            if (!this._flipV)
            {
                return this._offsetY;
            }
            return -(this.height + this._offsetY);
        }

        public var _Str_20249(get,never):Int;
public function  get__Str_20249():Int
        {
            return this._offsetX;
        }

        public var _Str_19351(get,never):Int;
public function  get__Str_19351():Int
        {
            return this._offsetY;
        }

	public function new() {}
    }

