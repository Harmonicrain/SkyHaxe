package com.sulake.core.assets
;
    import flash.geom.Rectangle;
    import flash.display.BitmapData;
    import flash.geom.Point;
    import flash.display.Loader;
    import flash.display.Bitmap;
    import flash.events.Event;

     class BitmapDataAsset implements ILazyAsset 
    {
        static var _instances:UInt = 0;
        static var _allocatedByteCount:UInt = 0;
        static inline final CLONE_BITMAP_DATA= false;
        static inline final USE_ASYNC_LOADER= false;
        static inline final IMMEDIATE_PREPARE= false;

        public var name:String;
        var _disposed:Bool = false;
        var _rectangle:Rectangle;
        var _unknown:ASObject;
        var _bitmap:BitmapData;
        var _offset:Point;
        var _flipH:Bool = false;
        var _flipV:Bool = false;
        var _decl:AssetTypeDeclaration;
        var _url:String;
        var _loader:Loader;
        var _swapId:Int = -1;
        var _ownsData:Bool = true;

        public function new(_decl:AssetTypeDeclaration, _url:String=null)
        {
            this._offset = new Point(0, 0);
            this._decl = _decl;
            this._url = _url;
            _instances++;
        }

        public static var instances(get,never):UInt;
public static function  get_instances():UInt
        {
            return _instances;
        }

        public static var allocatedByteCount(get,never):UInt;
public static function  get_allocatedByteCount():UInt
        {
            return _allocatedByteCount;
        }


        public var url(get,never):String;
public function  get_url():String
        {
            return this._url;
        }

        public var flipH(get,never):Bool;
public function  get_flipH():Bool
        {
            return this._flipH;
        }

        public var flipV(get,never):Bool;
public function  get_flipV():Bool
        {
            return this._flipV;
        }

        public var offset(get,never):Point;
public function  get_offset():Point
        {
            return this._offset;
        }

        public var content(get,never):ASObject;
public function  get_content():ASObject
        {
            if (this._bitmap == null)
            {
                this.prepareLazyContent();
            }
            return this._bitmap;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var rectangle(get,never):Rectangle;
public function  get_rectangle():Rectangle
        {
            var k:BitmapData = null;
            if (this._rectangle == null)
            {
                k = cast(this.content, BitmapData);
                if (k != null)
                {
                    this._rectangle = k.rect;
                }
            }
            return this._rectangle;
        }

        public var declaration(get,never):AssetTypeDeclaration;
public function  get_declaration():AssetTypeDeclaration
        {
            return this._decl;
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                _instances--;
                if (this._bitmap != null)
                {
                    try
                    {
                        _allocatedByteCount = (_allocatedByteCount - ((this._bitmap.width * this._bitmap.height) * 4));
                        if (this._ownsData)
                        {
                            this._bitmap.dispose();
                        }
                    }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                     {
                    }
 }                }
                if (Std.is(this._unknown , BitmapData))
                {
                    if (this._ownsData)
                    {
                        ASCompat.dynamicAs(this._unknown , BitmapData).dispose();
                    }
                }
                else
                {
                    if (Std.is(this._unknown , Bitmap))
                    {
                        ASCompat.dynamicAs(this._unknown , Bitmap).bitmapData.dispose();
                    }
                    else
                    {
                        if (ASCompat.isByteArray(this._unknown ))
                        {
                            ASCompat.asByteArray(this._unknown ).clear();
                        }
                    }
                }
                this._unknown = null;
                this._bitmap = null;
                this._offset = null;
                this._decl = null;
                this._url = null;
                this._rectangle = null;
                this._disposed = true;
            }
        }

        public function setUnknownContent(unknownContent:ASObject)
        {
            if (unknownContent == null)
            {
            }
            if (this._bitmap != null)
            {
                if (this._bitmap == ASCompat.dynamicAs(unknownContent , BitmapData))
                {
                    return;
                }
                if (this._ownsData)
                {
                    this._bitmap.dispose();
                }
            }
            this._unknown = unknownContent;
            this._bitmap = null;
            if (IMMEDIATE_PREPARE)
            {
                this.prepareLazyContent();
            }
        }

        public function prepareLazyContent()
        {
var unknownContent:ASObject  = null, bitmapContent:Bitmap  = null, unknownBitmap:Bitmap  = null;            if (this._swapId != -1)
            {
                this._swapId = -1;
            }
            if (this._unknown == null)
            {
                return;
            }
            if (Std.is(this._unknown , Class))
            {
unknownContent= Type.createInstance(((this._unknown : Class<Dynamic>) ), []);
bitmapContent= ASCompat.dynamicAs(unknownContent , Bitmap);
                if (bitmapContent != null)
                {
                    if (CLONE_BITMAP_DATA)
                    {
                        this._bitmap = bitmapContent.bitmapData.clone();
                        bitmapContent.bitmapData.dispose();
                    }
                    else
                    {
                        this._bitmap = bitmapContent.bitmapData;
                        bitmapContent.bitmapData = null;
                    }
                    if (this._bitmap != null)
                    {
                        _allocatedByteCount = (_allocatedByteCount + ((this._bitmap.width * this._bitmap.height) * 4));
                        this._unknown = null;
                        return;
                    }
                    unknownContent = new BitmapData(20, 20, true, 0xFF0000);
                }
                this._bitmap = ASCompat.dynamicAs(unknownContent , BitmapData);
                if (this._bitmap != null)
                {
                    this._unknown = null;
                    return;
                }
            }
			
            if (Std.is(this._unknown , Bitmap))
            {
unknownBitmap= cast(this._unknown, Bitmap);
                this._bitmap = unknownBitmap.bitmapData;
                if (this._bitmap != null)
                {
                    this._unknown = null;
                }
                else
                {
                    throw new ASError("Failed to convert Bitmap to BitmapDataAsset!");
                }
            }
			
            if (Std.is(this._unknown , BitmapData))
            {
                this._bitmap = ASCompat.dynamicAs(this._unknown , BitmapData);
                if (this._bitmap != null)
                {
                    this._unknown = null;
                    return;
                }
                throw new ASError("Failed to convert BitmapData to BitmapDataAsset!");
            }
			
            if (Std.is(this._unknown , BitmapDataAsset))
            {
                this._bitmap = cast(this._unknown, BitmapDataAsset)._bitmap;
                this._offset = cast(this._unknown, BitmapDataAsset)._offset;
                this._flipH = cast(this._unknown, BitmapDataAsset)._flipH;
                this._flipV = cast(this._unknown, BitmapDataAsset)._flipV;
                if (this._bitmap != null)
                {
                    this._unknown = null;
                    return;
                }
                throw new ASError("Failed to read content from BitmapDataAsset!");
            }
			
            if (ASCompat.isByteArray(this._unknown ))
            {
                if (USE_ASYNC_LOADER)
                {
                    this._loader = new Loader();
                    this._loader.loadBytes(ASCompat.asByteArray(this._unknown ));
                    this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE, (this.onLoaderComplete : ASAny));
                }
                this._unknown = null;
            }
        }

        function onLoaderComplete(event:Event)
        {
            var loader= ASCompat.dynamicAs(event.currentTarget.loader , Loader);
            var bitmap= Std.downcast(loader.content , Bitmap);
            this._bitmap = bitmap.bitmapData;
            if (((this._loader != null) && (this._loader.contentLoaderInfo != null)))
            {
                this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, (this.onLoaderComplete : ASAny));
            }
            this._loader = null;
        }

        public function setFromOtherAsset(asset:IAsset)
        {
            if (Std.is(asset , BitmapDataAsset))
            {
                this._bitmap = cast(asset, BitmapDataAsset)._bitmap;
                this._offset = cast(asset, BitmapDataAsset)._offset;
            }
            else
            {
                throw new ASError("Provided asset should be of type BitmapDataAsset!");
            }
        }

        public function setParamsDesc(xml:com.sulake.core.utils.xml.XMLList)
        {
var xmlEntry:com.sulake.core.utils.xml.XML  = null, key:String  = null, value:String  = null, values:Array<ASAny> = null;            
            if (checkNullIteratee(xml)) for (_tmp_ in xml)
            {
xmlEntry = _tmp_;
key= ASCompat.xmlListToString(xmlEntry.attribute("key"));
value= ASCompat.xmlListToString(xmlEntry.attribute("value"));
values;
                switch (key)
                {
                    case "offset":
                        values = (cast value.split(","));
                        this._offset.x = ASCompat.parseInt(values[0]);
                        this._offset.y = ASCompat.parseInt(values[1]);
                        
                    case "region":
                        values = (cast value.split(","));
                        if (this._rectangle == null)
                        {
                            this._rectangle = new Rectangle();
                        }
                        this._rectangle.x = ASCompat.parseInt(values[0]);
                        this._rectangle.y = ASCompat.parseInt(values[1]);
                        this._rectangle.width = ASCompat.parseInt(values[2]);
                        this._rectangle.height = ASCompat.parseInt(values[3]);
                        
                    case "flipH":
                        this._flipH = ((value == "1") || (value == "true"));
                        
                    case "flipV":
                        this._flipV = ((value == "1") || (value == "true"));
                        
                }
            }
        }

        public function compress()
        {
            if (((this._bitmap != null) && this._ownsData))
            {
            }
        }

        public function swapToDisk()
        {
        }

        public var ownsData(never,set):Bool;
public function  set_ownsData(ownsData:Bool):Bool        {
            return this._ownsData = ownsData;
        }
    }

