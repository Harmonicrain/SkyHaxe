package com.sulake.habbo.room.object.visualization.furniture
;
    import flash.display.BitmapData;
    import com.sulake.room.object.visualization.utils.IGraphicAsset;
    import flash.display.Bitmap;
    import flash.geom.ColorTransform;
    import flash.geom.Matrix;

     class IsometricImageFurniVisualization extends FurnitureAnimatedVisualization
    {
        static inline final THUMBNAIL= "THUMBNAIL";

        var _thumbnailAssetNameSmall:String = null;
        var _thumbnailAssetNameNormal:String = null;
        var _hasOutline:Bool = false;
        var _thumbnailImageSmall:BitmapData;
        var _thumbnailImageNormal:BitmapData;
        var _thumbnailDirection:Int = 0;
        var _thumbnailChanged:Bool = false;


        public var hasOutline(never,set):Bool;
function  set_hasOutline(k:Bool):Bool        {
            return this._hasOutline = k;
        }

        public var hasThumbnailImage(get,never):Bool;
function  get_hasThumbnailImage():Bool
        {
            return !(this._thumbnailImageNormal == null);
        }

        public function setThumbnailImages(k:BitmapData, _arg_2:BitmapData=null)
        {
            this._thumbnailImageNormal = k;
            this._thumbnailImageSmall = ((_arg_2 != null) ? _arg_2 : k);
            this._thumbnailChanged = true;
        }

        override function updateModel(k:Float):Bool
        {
            var _local_2= super.updateModel(k);
            if (object == null)
            {
                return _local_2;
            }
            if (((!this._thumbnailChanged) && (this._thumbnailDirection == direction)))
            {
                return _local_2;
            }
            this.refreshThumbnail();
            return true;
        }

        function refreshThumbnail()
        {
            if (assetCollection == null)
            {
                return;
            }
            if (this._thumbnailImageNormal != null)
            {
                this.addThumbnailAsset(this._thumbnailImageNormal, 64);
                this.addThumbnailAsset(this._thumbnailImageSmall, 32);
            }
            else
            {
                assetCollection.disposeAsset(this.getThumbnailAssetName(64));
                assetCollection.disposeAsset(this.getThumbnailAssetName(32));
            }
            this._thumbnailChanged = false;
            this._thumbnailDirection = direction;
        }

        function addThumbnailAsset(k:BitmapData, _arg_2:Int)
        {
            var _local_4:String;
            var _local_5:IGraphicAsset;
            var _local_6:BitmapData;
            var _local_7:String;
            var _local_3 = 0;
            while (_local_3 < spriteCount)
            {
                if (getSpriteTag(_arg_2, direction, _local_3) == THUMBNAIL)
                {
                    _local_4 = (getSpriteAssetNameWithoutFrame(_arg_2, _local_3, false) + getFrameNumber(_arg_2, _local_3));
                    _local_5 = getAsset(_local_4, _local_3);
                    if (_local_5 != null)
                    {
                        _local_6 = this.generateTransformedThumbnail(k, _local_5);
                        _local_7 = this.getThumbnailAssetName(_arg_2);
                        assetCollection.disposeAsset(_local_7);
                        assetCollection.addAsset(_local_7, _local_6, true, _local_5.offsetX, _local_5.offsetY);
                    }
                    return;
                }
                _local_3++;
            }
        }

        function generateTransformedThumbnail(k:BitmapData, _arg_2:IGraphicAsset):BitmapData
        {
            var _local_6:BitmapData;
            var _local_7:Bitmap;
            var _local_8:ColorTransform;
            var _local_3= 1.1;
            var _local_4= new Matrix();
            var _local_5= (_arg_2.width / k.width);
            switch (direction)
            {
                case 2:
                    _local_4.a = _local_5;
                    _local_4.b = (-0.5 * _local_5);
                    _local_4.c = 0;
                    _local_4.d = (_local_5 * _local_3);
                    _local_4.tx = 0;
                    _local_4.ty = ((0.5 * _local_5) * k.width);
                    
                case 0
                   | 4:
                    _local_4.a = _local_5;
                    _local_4.b = (0.5 * _local_5);
                    _local_4.c = 0;
                    _local_4.d = (_local_5 * _local_3);
                    _local_4.tx = 0;
                    _local_4.ty = 0;
                    
                default:
                    _local_4.a = _local_5;
                    _local_4.b = 0;
                    _local_4.c = 0;
                    _local_4.d = _local_5;
                    _local_4.tx = 0;
                    _local_4.ty = 0;
            }
            if (this._hasOutline)
            {
                _local_6 = new BitmapData((_arg_2.width + 2), (_arg_2.height + 2), true, 0);
                _local_7 = new Bitmap(k);
                _local_8 = new ColorTransform();
                _local_8.color = 0;
                _local_6.draw(_local_7, _local_4, _local_8);
                _local_4.tx = (_local_4.tx + 1);
                _local_4.ty--;
                _local_6.draw(_local_7, _local_4, _local_8);
                _local_4.ty = (_local_4.ty + 2);
                _local_6.draw(_local_7, _local_4, _local_8);
                _local_4.tx = (_local_4.tx + 1);
                _local_4.ty--;
                _local_6.draw(_local_7, _local_4, _local_8);
                _local_4.tx--;
                _local_6.draw(_local_7, _local_4);
            }
            else
            {
                _local_6 = new BitmapData(_arg_2.width, _arg_2.height, true, 0);
                _local_6.draw(k, _local_4);
            }
            return _local_6;
        }

        override function getSpriteAssetName(k:Int, _arg_2:Int):String
        {
            if (((this._thumbnailImageNormal == null) || (!(getSpriteTag(k, direction, _arg_2) == THUMBNAIL))))
            {
                return super.getSpriteAssetName(k, _arg_2);
            }
            return this.getThumbnailAssetName(k);
        }

        function getThumbnailAssetName(k:Int):String
        {
            if (this._thumbnailAssetNameSmall == null)
            {
                this._thumbnailAssetNameSmall = this.getFullThumbnailAssetName(object.getId(), 32);
                this._thumbnailAssetNameNormal = this.getFullThumbnailAssetName(object.getId(), 64);
            }
            return (k == 32) ? this._thumbnailAssetNameSmall : this._thumbnailAssetNameNormal;
        }

        function getFullThumbnailAssetName(k:Int, _arg_2:Int):String
        {
            return ((((type + "_") + k) + "_thumb_") + _arg_2);
        }

	public function new() { super(); }
    }

