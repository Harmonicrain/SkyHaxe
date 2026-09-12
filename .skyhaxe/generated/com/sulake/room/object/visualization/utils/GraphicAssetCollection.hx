package com.sulake.room.object.visualization.utils
;
    import com.sulake.core.utils.Map;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.assets.IAsset;
    import flash.utils.ByteArray;
    import com.sulake.room.utils.XMLValidator;
    import com.sulake.core.assets.BitmapDataAsset;
    import flash.display.BitmapData;

     class GraphicAssetCollection implements IGraphicAssetCollection 
    {
        static inline final PALETTE_ASSET_DISPOSE_THRESHOLD= 10;
        static final PALETTE_ATTRIBUTES:Array<ASAny> = ["id", "source"];
        static inline final USE_LAZY_ASSETS= false;

        var _assets:Map;
        var _library:IAssetLibrary;
        var _palettes:Map;
        var _paletteAssetNames:Array<ASAny>;
        var _paletteXMLs:Map;
        var _referenceCount:Int = 0;
        var _referenceTimeStamp:Int = 0;
        var _lazyAssetTable:ASDictionary<ASAny,ASAny>;

        public function new()
        {
            this._assets = new Map();
            this._palettes = new Map();
            this._paletteXMLs = new Map();
            this._paletteAssetNames = [];
            this._lazyAssetTable = new ASDictionary<ASAny,ASAny>();
        }

        public function dispose()
        {
var k:String  = null, _local_4:String  = null;            var k:String = null;
            var _local_2:GraphicAssetPalette = null;
            var _local_3:GraphicAsset = null;
            var _local_4:String = null;
            if (this._palettes != null)
            {
                final _iter_ = this._palettes; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getKeys())
                {
k = _tmp_;
                    _local_2 = this._palettes.getValue(k);
                    if (_local_2 != null)
                    {
                        _local_2.dispose();
                    }
                }
                this._palettes.reset();
            }
            if (this._paletteXMLs != null)
            {
                this._palettes.reset();
            }
            if (this._paletteAssetNames != null)
            {
                this.disposePaletteAssets();
                this._paletteAssetNames = null;
            }
            if (this._assets != null)
            {
                final _iter_ = this._assets; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getKeys())
                {
k = _tmp_;
                    _local_3 = this._assets.getValue(k);
                    if (_local_3 != null)
                    {
                        _local_3.recycle();
                    }
                }
                this._assets.reset();
            }
            if (this._lazyAssetTable != null)
            {
                final _iter_ = this._lazyAssetTable; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
                {
_local_4 = _tmp_;
                    this._lazyAssetTable.remove(_local_4);
                }
            }
            this._library = null;
        }

        public var assetLibrary(never,set):IAssetLibrary;
public function  set_assetLibrary(k:IAssetLibrary):IAssetLibrary        {
            return this._library = k;
        }

        public function _Str_9215()
        {
            this._referenceCount++;
            this._referenceTimeStamp = flash.Lib.getTimer();
        }

        public function _Str_19942()
        {
            this._referenceCount--;
            if (this._referenceCount <= 0)
            {
                this._referenceCount = 0;
                this._referenceTimeStamp = flash.Lib.getTimer();
                this.disposePaletteAssets(false);
            }
        }

        public function _Str_20679():Int
        {
            return this._referenceCount;
        }

        public function _Str_21431():Int
        {
            return this._referenceTimeStamp;
        }

        public function _Str_13182(k:com.sulake.core.utils.xml.XML):Bool
        {
            if (k == null)
            {
                return false;
            }
            var _local_2= k.child("asset");
            if (_local_2 == null)
            {
                return false;
            }
            var _local_3= k.child("palette");
            if (_local_3 != null)
            {
                this.definePalettes(_local_3);
            }
            if (USE_LAZY_ASSETS)
            {
                this.defineAssetsLazy(_local_2);
            }
            else
            {
                this.defineAssets(_local_2);
            }
            return true;
        }

        function defineAssetsLazy(k:com.sulake.core.utils.xml.XMLList)
        {
            var _local_2:com.sulake.core.utils.xml.XML = null;
            var _local_3:String = null;
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_2  = _tmp_;
                _local_3 = _local_2.attribute("name").toString();
                if (_local_3.length > 0)
                {
                    this._lazyAssetTable[_local_3] = _local_2;
                }
            }
        }

        function defineAssets(k:com.sulake.core.utils.xml.XMLList)
        {
            var _local_4:com.sulake.core.utils.xml.XML = null;
            var _local_5:String = null;
            var _local_6:String = null;
            var _local_7 = false;
            var _local_8 = false;
            var _local_9 = false;
            var _local_10 = 0;
            var _local_11 = 0;
            var _local_12:IAsset = null;
            var _local_13 = false;
            var _local_14:IGraphicAsset = null;
            var _local_2= k.length();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                _local_4 = k.at(_local_3);
                _local_5 = _local_4.attribute("name").toString();
                if (_local_5.length > 0)
                {
                    _local_6 = null;
                    _local_7 = false;
                    _local_8 = false;
                    _local_9 = false;
                    _local_10 = 0;
                    _local_11 = 0;
                    _local_10 = -ASCompat.toInt(ASCompat.xmlListToString(_local_4.attribute("x")));
                    _local_11 = -ASCompat.toInt(ASCompat.xmlListToString(_local_4.attribute("y")));
                    _local_6 = _local_4.attribute("source").toString();
                    if (ASCompat.toInt(ASCompat.xmlListToString(_local_4.attribute("flipH"))) > 0)
                    {
                        if (_local_6.length > 0)
                        {
                            _local_7 = true;
                        }
                    }
                    if (ASCompat.toInt(ASCompat.xmlListToString(_local_4.attribute("flipV"))) > 0)
                    {
                        if (_local_6.length > 0)
                        {
                            _local_8 = true;
                        }
                    }
                    _local_9 = (!(ASCompat.toInt(ASCompat.xmlListToString(_local_4.attribute("usesPalette"))) == 0));
                    if (_local_6.length == 0)
                    {
                        _local_6 = _local_5;
                    }
                    _local_12 = this._library.getAssetByName(_local_6);
                    if (_local_12 != null)
                    {
                        _local_13 = this.createAsset(_local_5, _local_6, _local_12, _local_7, _local_8, _local_10, _local_11, _local_9);
                        if (!_local_13)
                        {
                            _local_14 = this.getAsset(_local_5);
                            if (((!(_local_14 == null)) && (!(_local_14.assetName == _local_14.libraryAssetName))))
                            {
                                _local_13 = this.replaceAsset(_local_5, _local_6, _local_12, _local_7, _local_8, _local_10, _local_11, _local_9);
                            }
                        }
                    }
                }
                _local_3++;
            }
        }

        function definePalettes(k:com.sulake.core.utils.xml.XMLList)
        {
            var _local_2:com.sulake.core.utils.xml.XML = null;
            var _local_3:String = null;
            var _local_4:String = null;
            var _local_5:IAsset = null;
            var _local_6:com.sulake.core.utils.ByteArray = null;
            var _local_7 = 0;
            var _local_8 = 0;
            var _local_9:String = null;
            var _local_10:GraphicAssetPalette = null;
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_2  = _tmp_;
                if (XMLValidator.checkRequiredAttributes(_local_2, PALETTE_ATTRIBUTES))
                {
                    _local_3 = _local_2.attribute("id").toString();
                    _local_4 = _local_2.attribute("source").toString();
                    if (this._palettes.getValue(_local_3)== null)
                    {
                        _local_5 = this._library.getAssetByName(_local_4);
                        if (Std.is(_local_5.content , Class))
                        {
                            _local_6 = ASCompat.asByteArray(Type.createInstance(((_local_5.content : Class<Dynamic>) ), []) );
                        }
                        else
                        {
                            _local_6 = ASCompat.asByteArray(_local_5.content );
                        }
                        _local_7 = 0xFFFFFF;
                        _local_8 = 0xFFFFFF;
                        _local_9 = _local_2.attribute("color1").toString();
                        if (_local_9.length > 0)
                        {
                            _local_7 = ASCompat.parseInt(_local_9, 16);
                            _local_8 = _local_7;
                        }
                        _local_9 = _local_2.attribute("color2").toString();
                        if (_local_9.length > 0)
                        {
                            _local_8 = ASCompat.parseInt(_local_9, 16);
                        }
                        _local_10 = new GraphicAssetPalette(_local_6, _local_7, _local_8);
                        this._palettes.setProperty(_local_3, _local_10);
                        this._paletteXMLs.setProperty(_local_3, _local_2);
                    }
                }
            }
        }

        function createAsset(k:String, _arg_2:String, _arg_3:IAsset, _arg_4:Bool, _arg_5:Bool, _arg_6:Float, _arg_7:Float, _arg_8:Bool):Bool
        {
            if (this._assets.getValue(k)!= null)
            {
                return false;
            }
            if (this._lazyAssetTable[k])
            {
                return false;
            }
            var _local_9= GraphicAsset._Str_2363(k, _arg_2, _arg_3, _arg_4, _arg_5, Std.int(_arg_6), Std.int(_arg_7), _arg_8);
            this._assets.setProperty(k, _local_9);
            return true;
        }

        function replaceAsset(k:String, _arg_2:String, _arg_3:IAsset, _arg_4:Bool, _arg_5:Bool, _arg_6:Float, _arg_7:Float, _arg_8:Bool):Bool
        {
            var _local_9:GraphicAsset = this._assets.remove(k);
            if (_local_9 != null)
            {
                _local_9.recycle();
            }
            else
            {
                this._lazyAssetTable.remove(k);
            }
            return this.createAsset(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8);
        }

        public function getAsset(k:String):IGraphicAsset
        {
            var _local_4:String = null;
            var _local_5 = false;
            var _local_6 = false;
            var _local_7 = false;
            var _local_8 = 0;
            var _local_9 = 0;
            var _local_10:IAsset = null;
            var _local_11:IGraphicAsset = null;
            var _local_2:IGraphicAsset = this._assets.getValue(k);
            if (_local_2 != null)
            {
                return _local_2;
            }
            var _local_3:com.sulake.core.utils.xml.XML = this._lazyAssetTable[k];
            if (_local_3 != null)
            {
                this._lazyAssetTable.remove(k);
                _local_4 = null;
                _local_5 = false;
                _local_6 = false;
                _local_7 = false;
                _local_8 = 0;
                _local_9 = 0;
                _local_8 = -ASCompat.toInt(ASCompat.xmlListToString(_local_3.attribute("x")));
                _local_9 = -ASCompat.toInt(ASCompat.xmlListToString(_local_3.attribute("y")));
                _local_4 = _local_3.attribute("source").toString();
                if (ASCompat.toInt(ASCompat.xmlListToString(_local_3.attribute("flipH"))) > 0)
                {
                    if (_local_4.length > 0)
                    {
                        _local_5 = true;
                    }
                }
                if (ASCompat.toInt(ASCompat.xmlListToString(_local_3.attribute("flipV"))) > 0)
                {
                    if (_local_4.length > 0)
                    {
                        _local_6 = true;
                    }
                }
                _local_7 = (!(ASCompat.toInt(ASCompat.xmlListToString(_local_3.attribute("usesPalette"))) == 0));
                if (_local_4.length == 0)
                {
                    _local_4 = k;
                }
                _local_10 = this._library.getAssetByName(_local_4);
                if (_local_10 != null)
                {
                    if (this.createAsset(k, _local_4, _local_10, _local_5, _local_6, _local_8, _local_9, _local_7))
                    {
                        return this._assets.getValue(k);
                    }
                    _local_11 = this.getAsset(k);
                    if (((!(_local_11 == null)) && (!(_local_11.assetName == _local_11.libraryAssetName))))
                    {
                        if (!this.replaceAsset(k, _local_4, _local_10, _local_5, _local_6, _local_8, _local_9, _local_7))
                        {
                            return null;
                        }
                    }
                }
            }
            return null;
        }

        public function getAssetWithPalette(k:String, _arg_2:String):IGraphicAsset
        {
            var _local_5:IGraphicAsset = null;
            var _local_6:String = null;
            var _local_7:BitmapDataAsset = null;
            var _local_8:BitmapData = null;
            var _local_9:GraphicAssetPalette = null;
            var _local_10:BitmapData = null;
            var _local_3= ((k + "@") + _arg_2);
            var _local_4= this.getAsset(_local_3);
            if (_local_4 == null)
            {
                _local_5 = this.getAsset(k);
                if (((_local_5 == null) || (!_local_5.usesPalette)))
                {
                    return _local_5;
                }
                _local_6 = ((_local_5.libraryAssetName + "@") + _arg_2);
                _local_7 = this.getLibraryAsset(_local_6);
                if (_local_7 == null)
                {
                    _local_8 = ASCompat.dynamicAs(_local_5.asset.content , BitmapData);
                    if (_local_8 != null)
                    {
                        _local_9 = this.getPalette(_arg_2);
                        if (_local_9 != null)
                        {
                            _local_10 = _local_8.clone();
                            _local_9.colorizeBitmap(_local_10);
                            _local_7 = this.addLibraryAsset(_local_6, _local_10);
                            if (_local_7 == null)
                            {
                                _local_10.dispose();
                                return null;
                            }
                        }
                        else
                        {
                            return _local_5;
                        }
                    }
                }
                this._paletteAssetNames.push(_local_3);
                this.createAsset(_local_3, _local_6, _local_7, _local_5.flipH, _local_5.flipV, _local_5._Str_20249, _local_5._Str_19351, false);
                _local_4 = this.getAsset(_local_3);
            }
            return _local_4;
        }

        public function _Str_21825():Array<ASAny>
        {
            return this._palettes.getKeys();
        }

        public function _Str_20963(k:String):Array<ASAny>
        {
            var _local_2= this.getPalette(k);
            if (_local_2 != null)
            {
                return [_local_2._Str_5845, _local_2._Str_6659];
            }
            return null;
        }

        public function _Str_17888(k:String):com.sulake.core.utils.xml.XML
        {
            return this._paletteXMLs.getValue(k);
        }

        function getPalette(k:String):GraphicAssetPalette
        {
            var _local_2:GraphicAssetPalette = this._palettes.getValue(k);
            return _local_2;
        }

        public function addAsset(k:String, _arg_2:BitmapData, _arg_3:Bool, _arg_4:Int=0, _arg_5:Int=0, _arg_6:Bool=false, _arg_7:Bool=false):Bool
        {
            var _local_9:BitmapData = null;
            if (((k == null) || (_arg_2 == null)))
            {
                return false;
            }
            if (this._library == null)
            {
                return false;
            }
            var _local_8= this.getLibraryAsset(k);
            if (_local_8 == null)
            {
                _local_8 = new BitmapDataAsset(this._library.getAssetTypeDeclarationByClass(BitmapDataAsset));
                this._library.setAsset(k, _local_8);
                _local_8.setUnknownContent(_arg_2);
                return this.createAsset(k, k, _local_8, _arg_6, _arg_7, _arg_4, _arg_5, false);
            }
            if (_arg_3)
            {
                _local_9 = ASCompat.dynamicAs(_local_8.content , BitmapData);
                if (((!(_local_9 == null)) && (!(_local_9 == _arg_2))))
                {
                    _local_9.dispose();
                }
                _local_8.setUnknownContent(_arg_2);
                return true;
            }
            return false;
        }

        public function disposeAsset(k:String)
        {
            var _local_3:BitmapDataAsset = null;
            var _local_2:GraphicAsset = this._assets.remove(k);
            if (_local_2 != null)
            {
                _local_3 = this.getLibraryAsset(_local_2.libraryAssetName);
                if (_local_3 != null)
                {
                    this._library.removeAsset(_local_3);
                    _local_3.dispose();
                }
                _local_2.recycle();
            }
            else
            {
                this._lazyAssetTable.remove(k);
            }
        }

        function getLibraryAsset(k:String):BitmapDataAsset
        {
            var _local_2= Std.downcast(this._library.getAssetByName(k) , BitmapDataAsset);
            return _local_2;
        }

        function addLibraryAsset(k:String, _arg_2:BitmapData):BitmapDataAsset
        {
            var _local_3= this.getLibraryAsset(k);
            if (_local_3 == null)
            {
                _local_3 = new BitmapDataAsset(this._library.getAssetTypeDeclarationByClass(BitmapDataAsset));
                this._library.setAsset(k, _local_3);
                _local_3.setUnknownContent(_arg_2);
                return _local_3;
            }
            return null;
        }

        function disposePaletteAssets(k:Bool=true)
        {
            var _local_2:String = null;
            if (this._paletteAssetNames != null)
            {
                if ((k || (this._paletteAssetNames.length > PALETTE_ASSET_DISPOSE_THRESHOLD)))
                {
                    final _iter_ = this._paletteAssetNames; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                    {
_local_2  = _tmp_;
                        this.disposeAsset(_local_2);
                    }
                    this._paletteAssetNames = [];
                }
            }
        }
    }

