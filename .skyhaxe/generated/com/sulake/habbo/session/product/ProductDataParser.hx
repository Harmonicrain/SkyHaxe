package com.sulake.habbo.session.product
;
    import com.sulake.core.runtime.events.EventDispatcherWrapper;
    import com.sulake.core.assets.AssetLibrary;
    import flash.net.URLRequest;
    import com.sulake.core.assets.AssetLoaderStruct;
    import com.sulake.core.assets.loaders.AssetLoaderEvent;
    import flash.events.Event;
    import com.sulake.core.Core;
    import com.sulake.habbo.utils.HabboWebTools;

     class ProductDataParser extends EventDispatcherWrapper 
    {
        public static inline final PDP_PRODUCT_DATA_READY= "PDP_product_data_ready";

        var _products:ASDictionary<ASAny,ASAny>;
        var _assetLib:AssetLibrary;

        public function new(url:String, products:ASDictionary<ASAny,ASAny>)
        {
            super();
            this._products = products;
            this._assetLib = new AssetLibrary("ProductDataParserAssetLib");
            var _local_3= this._assetLib.loadAssetFromFile(url, new URLRequest(url), "text/plain");
            _local_3.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTCOMPLETE, this.parseProductsData);
            _local_3.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTERROR, this.productsDataError);
        }

        override public function dispose()
        {
            super.dispose();
            if (this._assetLib != null)
            {
                this._assetLib.dispose();
                this._assetLib = null;
            }
            this._products = null;
        }

        function parseProductsData(k:Event)
        {
            var _local_2= ASCompat.dynamicAs(k.target , AssetLoaderStruct);
            if (_local_2 == null)
            {
                return;
            }
            if (((_local_2.assetLoader == null) || (_local_2.assetLoader.content == null)))
            {
                return;
            }
            var _local_3= ASCompat.asString(_local_2.assetLoader.content );
            if (_local_3.charAt(0) == "<")
            {
                this._Str_17161(_local_3);
            }
            else
            {
                this.parseLingoFormat(_local_3);
            }
        }

        function _Str_17161(data:String)
        {
            var itemXml:com.sulake.core.utils.xml.XML = null;
            var xmlData:com.sulake.core.utils.xml.XML = null;
            var code:String = null;
            try
            {
                xmlData = new com.sulake.core.utils.xml.XML(data);
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                Core.error(("XML Product data was malformed: " + data), true, Core.ERROR_CATEGORY_PRODUCT_DATA);
            }
 }            if (xmlData == null)
            {
                return;
            }
            var products= xmlData.child("product");
            if (checkNullIteratee(products)) for (_tmp_ in products)
            {
itemXml  = _tmp_;
                code = itemXml.attribute("code").toString();
                this._products[code] = new ProductData(code, ASCompat.xmlListToString(itemXml.child("name")), ASCompat.xmlListToString(itemXml.child("description")));
            }
            dispatchEvent(new Event(PDP_PRODUCT_DATA_READY));
        }

        function parseLingoFormat(k:String)
        {
            var _local_8:String = null;
            var _local_9:Array<ASAny> = null;
            var _local_10:String = null;
            var _local_11:Array<ASAny> = null;
            var _local_12:String = null;
            var _local_13:String = null;
            var _local_14:String = null;
            var _local_15:ProductData = null;
            var _local_2= new Array<ASAny>();
            var _local_3= new compat.RegExp("\\n\\r{1,}|\\n{1,}|\\r{1,}", "mg");
            var _local_4= new compat.RegExp("^\\s+|\\s+$", "g");
            var _local_5= new compat.RegExp("\\[+?((.)*?)\\]", "g");
            k = new compat.RegExp("\"{1,}", "mg").replace(k, "");
            var _local_6:Array<ASAny> = (cast _local_3.split(k));
            var _local_7 = 0;
            if (checkNullIteratee(_local_6)) for (_tmp_ in _local_6)
            {
_local_8  = _tmp_;
                _local_9 = (cast ASCompat.stringMatch(_local_8, _local_5));
                if (checkNullIteratee(_local_9)) for (_tmp_ in _local_9)
                {
_local_10  = _tmp_;
                    _local_10 = new compat.RegExp("\\[{1,}", "mg").replace(_local_10, "");
                    _local_10 = new compat.RegExp("\\]{1,}", "mg").replace(_local_10, "");
                    _local_11 = (cast _local_10.split(","));
                    _local_12 = _local_11.shift();
                    _local_13 = _local_11.shift();
                    _local_14 = _local_11.join(",");
                    _local_15 = new ProductData(_local_12, _local_13, _local_14);
                    this._products[_local_12] = _local_15;
                }
                _local_7++;
            }
            dispatchEvent(new Event(PDP_PRODUCT_DATA_READY));
        }

        function productsDataError(k:AssetLoaderEvent)
        {
            HabboWebTools.logEventLog(("productdata download error " + Std.string(k.status)));
            Core.error("Could not download productdata", true, Core.ERROR_CATEGORY_PRODUCT_DATA);
        }
    }

