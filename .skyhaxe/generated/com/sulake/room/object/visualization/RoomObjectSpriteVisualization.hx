package com.sulake.room.object.visualization
;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.room.object.visualization.utils.IGraphicAssetCollection;
    import com.sulake.room.utils.IRoomGeometry;
    import flash.display.BitmapData;
    import flash.display.BitmapDataChannel;
    import flash.geom.ColorTransform;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
    import flash.display.BlendMode;
    import flash.geom.Point;

     class RoomObjectSpriteVisualization implements IRoomObjectSpriteVisualization 
    {
        static var _globalInstanceId:Int = 0;

        var _layersInUse:Array<ASAny>;
        var _object:IRoomObject;
        var _assetCollection:IGraphicAssetCollection;
        var _objectUpdateID:Int = -1;
        var _modelUpdateID:Int = -1;
        var _currentScale:Int = -1;
        var _instanceId:Int = 0;
        var _updateID:Int = 0;

        public function new()
        {
            this._instanceId = _globalInstanceId++;
            this._layersInUse = [];
            this._object = null;
            this._assetCollection = null;
        }

        public function dispose()
        {
            var k:RoomObjectSprite = null;
            if (this._layersInUse != null)
            {
                while (this._layersInUse.length > 0)
                {
                    k = ASCompat.dynamicAs(this._layersInUse[0] , RoomObjectSprite);
                    if (k != null)
                    {
                        k.dispose();
                    }
                    this._layersInUse.pop();
                }
                this._layersInUse = null;
            }
            this._object = null;
            this.assetCollection = null;
        }

        
        public var assetCollection(get,set):IGraphicAssetCollection;
public function  set_assetCollection(k:IGraphicAssetCollection):IGraphicAssetCollection        {
            if (this._assetCollection != null)
            {
                this._assetCollection._Str_19942();
            }
            this._assetCollection = k;
            if (this._assetCollection != null)
            {
                this._assetCollection._Str_9215();
            }
return k;
        }

        public function setExternalBaseUrls(k:String, _arg_2:String, _arg_3:Bool)
        {
        }
public function  get_assetCollection():IGraphicAssetCollection
        {
            return this._assetCollection;
        }

        public function getUpdateID():Int
        {
            return this._updateID;
        }

        public function getInstanceId():Int
        {
            return this._instanceId;
        }

        function createSprites(k:Int)
        {
            var _local_2:RoomObjectSprite = null;
            while (this._layersInUse.length > k)
            {
                _local_2 = ASCompat.dynamicAs(this._layersInUse[(this._layersInUse.length - 1)] , RoomObjectSprite);
                if (_local_2 != null)
                {
                    _local_2.dispose();
                }
                this._layersInUse.pop();
            }
            while (this._layersInUse.length < k)
            {
                _local_2 = new RoomObjectSprite();
                this._layersInUse.push(_local_2);
            }
        }

        public function addSprite():IRoomObjectSprite
        {
            return this.addSpriteAt(this._layersInUse.length);
        }

        public function addSpriteAt(k:Int):IRoomObjectSprite
        {
            var _local_2:IRoomObjectSprite = new RoomObjectSprite();
            if (k >= this._layersInUse.length)
            {
                this._layersInUse.push(_local_2);
            }
            else
            {
                this._layersInUse.insert(k, _local_2);
            }
            return _local_2;
        }

        public function removeSprite(k:IRoomObjectSprite)
        {
            var _local_2= this._layersInUse.indexOf(k);
            if (_local_2 == -1)
            {
                throw new ASError("Trying to remove non-existing sprite!");
            }
            this._layersInUse.splice(_local_2, 1);
            cast(k, RoomObjectSprite).dispose();
        }

        public var spriteCount(get,never):Int;
public function  get_spriteCount():Int
        {
            return this._layersInUse.length;
        }

        public function getSprite(k:Int):IRoomObjectSprite
        {
            if (((k >= 0) && (k < this._layersInUse.length)))
            {
                return this._layersInUse[k];
            }
            return null;
        }

        
        public var object(get,set):IRoomObject;
public function  get_object():IRoomObject
        {
            return this._object;
        }
public function  set_object(k:IRoomObject):IRoomObject        {
            return this._object = k;
        }

        public function update(k:IRoomGeometry, _arg_2:Int, _arg_3:Bool, _arg_4:Bool)
        {
        }

        function increaseUpdateId()
        {
            this._updateID++;
        }

        function reset()
        {
            this._objectUpdateID = ASCompat.toInt(0xFFFFFFFF);
            this._modelUpdateID = ASCompat.toInt(0xFFFFFFFF);
            this._currentScale = -1;
        }

        public function getSpriteList():Array<ASAny>
        {
            return null;
        }

        public function initialize(k:IRoomObjectVisualizationData):Bool
        {
            return false;
        }

        public var image(get,never):BitmapData;
public function  get_image():BitmapData
        {
            return this.getImage(0, -1);
        }

        public function getImage(bgColor:Int, originalID:Int):BitmapData
        {
var addAlpha:BitmapData  = null;            var tR = Math.NaN;
            var tG = Math.NaN;
            var tB = Math.NaN;
            var color = 0;
            var r = 0;
            var g = 0;
            var b = 0;
            var colorTransform:ColorTransform = null;
            var matrix:Matrix = null;
            var boundingRect= this.boundingRectangle;
            if ((boundingRect.width * boundingRect.height) == 0)
            {
                return null;
            }
            var count= this.spriteCount;
            var objectSprite:IRoomObjectSprite = null;
            var spriteList:Array<ASAny> = [];
            var index = 0;
            var data:BitmapData = null;
            index = 0;
            while (index < count)
            {
                objectSprite = this.getSprite(index);
                if (((!(objectSprite == null)) && objectSprite.visible))
                {
                    data = objectSprite.asset;
                    if (data != null)
                    {
                        spriteList.push(objectSprite);
                    }
                }
                index = (index + 1);
            }
            ASCompat.ASArray.sortOn(spriteList, "relativeDepth", (ASCompat.toInt(ASCompat.ASArray.DESCENDING )| ASCompat.toInt(ASCompat.ASArray.NUMERIC)));
            var bitmapData:BitmapData = null;
            try
            {
                bitmapData = new BitmapData(Std.int(boundingRect.width), Std.int(boundingRect.height), true, bgColor);
            }
            catch(e:ArgumentError)
            {
                Logger.log([("Unable to create BitmapData object! " + e)]);
            }
            if (bitmapData == null)
            {
                return new BitmapData(1, 1, true);
            }
            index = 0;
            while (index < spriteList.length)
            {
                objectSprite = ASCompat.dynamicAs(spriteList[index] , IRoomObjectSprite);
                data = objectSprite.asset;
                if (data != null)
                {
                    color = objectSprite.color;
                    r = (color >> 16);
                    g = ((color >> 8) & 0xFF);
                    b = (color & 0xFF);
                    colorTransform = null;
                    if ((((r < 0xFF) || (g < 0xFF)) || (b < 0xFF)))
                    {
                        tR = (r / 0xFF);
                        tG = (g / 0xFF);
                        tB = (b / 0xFF);
                        colorTransform = new ColorTransform(tR, tG, tB, (objectSprite.alpha / 0xFF));
                    }
                    else
                    {
                        if (objectSprite.alpha < 0xFF)
                        {
                            colorTransform = new ColorTransform(1, 1, 1, (objectSprite.alpha / 0xFF));
                        }
                    }
                    matrix = new Matrix();
                    if (objectSprite.flipH)
                    {
                        matrix.scale(-1, 1);
                        matrix.translate(data.width, 0);
                    }
                    if (objectSprite.flipV)
                    {
                        matrix.scale(1, -1);
                        matrix.translate(0, data.height);
                    }
                    matrix.translate((objectSprite.offsetX - boundingRect.left), (objectSprite.offsetY - boundingRect.top));
                    if ((bgColor == 0) && (objectSprite.blendMode == BlendMode.ADD))
                    {
addAlpha= bitmapData.clone();
                        bitmapData.draw(data, matrix, colorTransform, BlendMode.ADD, null, false);
                        bitmapData.copyChannel(addAlpha, bitmapData.rect, new Point(0, 0), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);
                        addAlpha.dispose();
                    }
                    else
                    {
                        bitmapData.draw(data, matrix, colorTransform, objectSprite.blendMode, null, false);
                    }
                }
                index = (index + 1);
            }
            return bitmapData;
        }

        public var boundingRectangle(get,never):Rectangle;
public function  get_boundingRectangle():Rectangle
        {
            var _local_6:Point = null;
            var k= this.spriteCount;
            var _local_2:IRoomObjectSprite = null;
            var _local_3= new Rectangle();
            var _local_4 = 0;
            var _local_5:BitmapData = null;
            _local_4 = 0;
            while (_local_4 < k)
            {
                _local_2 = this.getSprite(_local_4);
                if (((!(_local_2 == null)) && _local_2.visible))
                {
                    _local_5 = _local_2.asset;
                    if (_local_5 != null)
                    {
                        _local_6 = new Point(_local_2.offsetX, _local_2.offsetY);
                        if (_local_4 == 0)
                        {
                            _local_3.left = _local_6.x;
                            _local_3.top = _local_6.y;
                            _local_3.right = (_local_6.x + _local_2.width);
                            _local_3.bottom = (_local_6.y + _local_2.height);
                        }
                        else
                        {
                            if (_local_6.x < _local_3.left)
                            {
                                _local_3.left = _local_6.x;
                            }
                            if (_local_6.y < _local_3.top)
                            {
                                _local_3.top = _local_6.y;
                            }
                            if ((_local_6.x + _local_2.width) > _local_3.right)
                            {
                                _local_3.right = (_local_6.x + _local_2.width);
                            }
                            if ((_local_6.y + _local_2.height) > _local_3.bottom)
                            {
                                _local_3.bottom = (_local_6.y + _local_2.height);
                            }
                        }
                    }
                }
                _local_4++;
            }
            return _local_3;
        }
    }

