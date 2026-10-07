package com.sulake.habbo.session.furniture
;
    import com.sulake.core.runtime.events.EventDispatcherWrapper;
    import com.sulake.core.utils.Map;
    import com.sulake.core.localization.ICoreLocalizationManager;
    import com.sulake.core.assets.AssetLibrary;
    import flash.net.URLRequest;
    import com.sulake.core.assets.AssetLoaderStruct;
    import com.sulake.core.assets.loaders.AssetLoaderEvent;
    import com.sulake.core.Core;
    import flash.events.Event;
    import com.sulake.habbo.utils.HabboWebTools;
    // The generated tree's import.hx does not reach build-support/platform.
    import ASCompat.checkNullIteratee;

    /**
     * SkyHaxe override (build-support/platform) of the generated FurnitureDataParser (pinned below): identical except
     * that XML furnidata first goes through `parseFast`, a DOM-free scanner that builds the same
     * FurnitureData objects straight from the text. Building the E4X tree for furnidata.xml
     * (~10k furnitypes) cost ~2.4 s of main thread at login, including GC, and incoming room
     * packets queue behind it. Anything outside the simple furnidata shape returns false and
     * the original DOM path runs unchanged. ?furnidataVerify=1 runs both and compares.
     */
    @:build(skyhaxe.GeneratedPin.check(".skyhaxe/generated/com/sulake/habbo/session/furniture/FurnitureDataParser.hx",
        "6c948902f578bb9b96599ff0c271ad0644dbefc109df11b911825c5d875b2c8a"))
     class FurnitureDataParser extends EventDispatcherWrapper
    {
        public static inline final FDP_FURNITURE_DATA_READY= "FDP_furniture_data_ready";

        var _floorItems:Map;
        var _wallItems:Map;
        var _itemIds:Map;
        var _localization:ICoreLocalizationManager;
        var _assetLib:AssetLibrary;

        public function new(k:Map, _arg_2:Map, _arg_3:Map, _arg_4:ICoreLocalizationManager)
        {
            super();
            this._floorItems = k;
            this._wallItems = _arg_2;
            this._itemIds = _arg_3;
            this._localization = _arg_4;
            this._assetLib = new AssetLibrary("FurniDataParserAssetLib");
        }

        override public function dispose()
        {
            super.dispose();
            if (this._assetLib != null)
            {
                this._assetLib.dispose();
                this._assetLib = null;
            }
            this._localization = null;
            this._floorItems = null;
            this._wallItems = null;
            this._itemIds = null;
        }

        public function loadData(k:String)
        {
            var _local_2= this._assetLib.loadAssetFromFile(k, new URLRequest(k), "text/plain");
            _local_2.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTCOMPLETE, this.parseFurnitureData);
            _local_2.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTERROR, this.furnitureDataError);
        }

        function parseFurnitureData(k:AssetLoaderEvent)
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
            #if js
            if (js.Browser.location.search.indexOf("furnidataVerify=1") >= 0)
                FurnitureDataFastParser.verify(data, this.parseFloorItem, this.parseWallItem);
            #end
            var fast = FurnitureDataFastParser.parse(data);
            if (fast != null)
            {
                for (furniData in fast)
                {
                    this.storeItem(furniData);
                    this.registerFurnitureLocalization(furniData);
                }
                dispatchEvent(new Event(FDP_FURNITURE_DATA_READY));
                return;
            }
            var categoryTypes:com.sulake.core.utils.xml.XMLList = null;
            var itemXml:com.sulake.core.utils.xml.XML = null;
            var furniData:FurnitureData = null;
            var xmlData:com.sulake.core.utils.xml.XML = null;
            try
            {
                xmlData = new com.sulake.core.utils.xml.XML(data);
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                Core.error(("XML furni data was malformed: " + data), true, Core.ERROR_CATEGORY_FURNIDATA_DOWNLOAD);
            }
 }            if (xmlData == null)
            {
                return;
            }
            categoryTypes = xmlData.child("roomitemtypes");
            final _iter_ = categoryTypes.child("furnitype"); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
itemXml  = _tmp_;
                furniData = this.parseFloorItem(itemXml);
                this.storeItem(furniData);
                this.registerFurnitureLocalization(furniData);
            }
            categoryTypes = xmlData.child("wallitemtypes");
            final _iter_ = categoryTypes.child("furnitype"); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
itemXml  = _tmp_;
                furniData = this.parseWallItem(itemXml);
                this.storeItem(furniData);
                this.registerFurnitureLocalization(furniData);
            }
            dispatchEvent(new Event(FDP_FURNITURE_DATA_READY));
        }

        function parseFloorItem(k:com.sulake.core.utils.xml.XML):FurnitureData
        {
            var _local_4:com.sulake.core.utils.xml.XML = null;
            var _local_5:String = null;
            var _local_6:Array<ASAny> = null;
            var _local_7:String = null;
            var _local_8 = 0;
            var _local_11:String = null;
            var _local_2= ASCompat.parseInt(k.attribute("id").toString());
            var _local_3= new Array<ASAny>();
            final _iter_ = k.child("partcolors").child("color"); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_4  = _tmp_;
                _local_11 = ASCompat.xmlToString(_local_4);
                if (_local_11.charAt(0) == "#")
                {
                    _local_11 = ASCompat.stringReplace(_local_11, "#", "");
                    _local_3.push(ASCompat.parseInt(_local_11, 16));
                }
                else
                {
                    _local_3.push(-ASCompat.parseInt(_local_11));
                }
            }
            _local_5 = k.attribute("classname").toString();
            _local_6 = (cast _local_5.split("*"));
            _local_7 = _local_6[0];
            _local_8 = ((_local_6.length > 1) ? ASCompat.parseInt(_local_6[1]) : 0);
            var _local_9:ASAny = (_local_6.length > 1);
            var _local_10= new FurnitureData(FurnitureData.S, _local_2, _local_5, _local_7, ASCompat.xmlListToString(k.child("name")), ASCompat.xmlListToString(k.child("description")), ASCompat.toInt(k.child("revision")), ASCompat.toInt(k.child("xdim")), ASCompat.toInt(k.child("ydim")), 0, _local_3, _local_9, _local_8, ASCompat.xmlListToString(k.child("adurl")), ASCompat.toInt(k.child("offerid")), com.sulake.core.utils.xml.XML.equalsStringOperands(k.child("buyout" ), "1"), ASCompat.toInt(k.child("rentofferid")), com.sulake.core.utils.xml.XML.equalsStringOperands(k.child("rentbuyout" ), "1"), com.sulake.core.utils.xml.XML.equalsStringOperands(k.child("bc" ), "1"), ASCompat.xmlListToString(k.child("customparams")), ASCompat.toInt(k.child("specialtype")), com.sulake.core.utils.xml.XML.equalsStringOperands(k.child("canstandon" ), "1"), com.sulake.core.utils.xml.XML.equalsStringOperands(k.child("cansiton" ), "1"), com.sulake.core.utils.xml.XML.equalsStringOperands(k.child("canlayon" ), "1"), com.sulake.core.utils.xml.XML.equalsStringOperands(k.child("excludeddynamic" ), "1"), ASCompat.xmlListToString(k.child("furniline")), ASCompat.toInt(ASCompat.xmlListToString(k.child("bcofferid"))), com.sulake.core.utils.xml.XML.equalsStringOperands(k.child("tradeable" ), "1"));
            return _local_10;
        }

        function parseWallItem(k:com.sulake.core.utils.xml.XML):FurnitureData
        {
            var _local_2= ASCompat.parseInt(k.attribute("id").toString());
            var _local_3= new FurnitureData(FurnitureData.I, _local_2, k.attribute("classname").toString(), k.attribute("classname").toString(), ASCompat.xmlListToString(k.child("name")), ASCompat.xmlListToString(k.child("description")), ASCompat.toInt(k.child("revision")), 0, 0, 0, null, false, 0, ASCompat.xmlListToString(k.child("adurl")), ASCompat.toInt(k.child("offerid")), com.sulake.core.utils.xml.XML.equalsStringOperands(k.child("buyout" ), "1"), ASCompat.toInt(k.child("rentofferid")), com.sulake.core.utils.xml.XML.equalsStringOperands(k.child("rentbuyout" ), "1"), com.sulake.core.utils.xml.XML.equalsStringOperands(k.child("bc" ), "1"), null, ASCompat.toInt(k.child("specialtype")), false, false, false, com.sulake.core.utils.xml.XML.equalsStringOperands(k.child("excludeddynamic" ), "1"), ASCompat.xmlListToString(k.child("furniline")), ASCompat.toInt(ASCompat.xmlListToString(k.child("bcofferid"))), com.sulake.core.utils.xml.XML.equalsStringOperands(k.child("tradeable" ), "1"));
            return _local_3;
        }

        function parseLingoFormat(k:String)
        {
            var _local_7:String = null;
            var _local_8:Array<ASAny> = null;
            var _local_9:String = null;
            var _local_10:Array<ASAny> = null;
            var _local_11:String = null;
            var _local_12 = 0;
            var _local_13:String = null;
            var _local_14:Array<ASAny> = null;
            var _local_15:String = null;
            var _local_16 = 0;
            var _local_17 = false;
            var _local_18 = 0;
            var _local_19 = 0;
            var _local_20 = 0;
            var _local_21 = 0;
            var _local_22:Array<ASAny> = null;
            var _local_23:Array<ASAny> = null;
            var _local_24 = 0;
            var _local_25:String = null;
            var _local_26:String = null;
            var _local_27:String = null;
            var _local_28 = 0;
            var _local_29 = false;
            var _local_30 = 0;
            var _local_31 = false;
            var _local_32:String = null;
            var _local_33 = 0;
            var _local_34 = false;
            var _local_35 = false;
            var _local_36 = false;
            var _local_37 = false;
            var _local_38 = false;
            var _local_39 = false;
            var _local_40:FurnitureData = null;
            var _local_41:String = null;
            var _local_2= new compat.RegExp("\\n\\r{1,}|\\n{1,}|\\r{1,}", "mg");
            var _local_3= new compat.RegExp("^\\s+|\\s+$", "g");
            var _local_4= new compat.RegExp("\\[+?((.)*?)\\]", "g");
            var _local_5:Array<ASAny> = (cast _local_2.split(k));
            var _local_6 = 0;
            if (checkNullIteratee(_local_5)) for (_tmp_ in _local_5)
            {
_local_7  = _tmp_;
                _local_8 = (cast ASCompat.stringMatch(_local_7, _local_4));
                if (checkNullIteratee(_local_8)) for (_tmp_ in _local_8)
                {
_local_9  = _tmp_;
                    _local_9 = new compat.RegExp("\\[{1,}", "mg").replace(_local_9, "");
                    _local_9 = new compat.RegExp("\\]{1,}", "mg").replace(_local_9, "");
                    _local_10 = (cast _local_9.split('"'));
                    this.removePatternFrom(_local_10, ", ");
                    this.removePatternFrom(_local_10, ",");
                    _local_10.splice(0, 1);
                    _local_10.splice((_local_10.length - 1), 1);
                    if (_local_10.length < 18)
                    {
                        Core.error(("Lingo furni data was malformed: " + k), true, Core.ERROR_CATEGORY_FURNIDATA_DOWNLOAD);
                        return;
                    }
                    _local_11 = _local_10[0];
                    _local_12 = ASCompat.parseInt(_local_10[1]);
                    _local_13 = ASCompat.toString(_local_10[2]);
                    _local_14 = (cast _local_13.split("*"));
                    _local_15 = _local_14[0];
                    _local_16 = ((_local_14.length > 1) ? ASCompat.parseInt(_local_14[1]) : 0);
                    _local_17 = (_local_14.length > 1);
                    _local_18 = ASCompat.parseInt(_local_10[3]);
                    _local_19 = ASCompat.parseInt(_local_10[4]);
                    _local_20 = ASCompat.parseInt(_local_10[5]);
                    _local_21 = ASCompat.parseInt(_local_10[6]);
                    _local_22 = [];
                    _local_23 = _local_10[7].split(",");
                    _local_24 = 0;
                    while (_local_24 < _local_23.length)
                    {
                        _local_41 = _local_23[_local_24];
                        if (_local_41.charAt(0) == "#")
                        {
                            _local_41 = ASCompat.stringReplace(_local_41, "#", "");
                            _local_22.push(ASCompat.parseInt(_local_41, 16));
                        }
                        else
                        {
                            _local_22.push(-ASCompat.parseInt(_local_41));
                        }
                        _local_24++;
                    }
                    _local_25 = _local_10[8];
                    _local_26 = _local_10[9];
                    _local_27 = _local_10[10];
                    _local_28 = ASCompat.parseInt(_local_10[11]);
                    _local_29 = (_local_10[12] == "true");
                    _local_30 = ASCompat.parseInt(_local_10[13]);
                    _local_31 = (_local_10[14] == "true");
                    _local_32 = _local_10[15];
                    _local_33 = ASCompat.parseInt(_local_10[16]);
                    _local_34 = (_local_10[17] == "true");
                    _local_38 = false;
                    _local_39 = (_local_11 == "i");
                    if (_local_39)
                    {
                        _local_35 = false;
                        _local_36 = false;
                        _local_37 = false;
                        if (_local_10.length >= 19)
                        {
                            _local_38 = (_local_10[18] == "1");
                        }
                    }
                    else
                    {
                        _local_35 = (_local_10[18] == "1");
                        _local_36 = (_local_10[19] == "1");
                        _local_37 = (_local_10[20] == "1");
                        if (_local_10.length >= 22)
                        {
                            _local_38 = (_local_10[21] == "1");
                        }
                    }
                    _local_40 = new FurnitureData(_local_11, _local_12, _local_13, _local_15, _local_25, _local_26, _local_18, _local_19, _local_20, _local_21, _local_22, _local_17, _local_16, _local_27, _local_28, _local_29, _local_30, _local_31, _local_34, _local_32, _local_33, _local_35, _local_36, _local_37, _local_38, "", (_local_34 ? _local_28 : -1), false);
                    this.storeItem(_local_40);
                    this.registerFurnitureLocalization(_local_40);
                }
                _local_6++;
            }
            dispatchEvent(new Event(FDP_FURNITURE_DATA_READY));
        }

        function storeItem(k:FurnitureData)
        {
            if (k.type == FurnitureData.S)
            {
                this._floorItems.add(k.id, k);
            }
            else if (k.type == FurnitureData.I)
            {
                this._wallItems.add(k.id, k);
            }
            var _local_2:Array<ASAny> = this._itemIds.getValue(k.className);
            if (_local_2 == null)
            {
                _local_2 = [];
                this._itemIds.add(k.className, _local_2);
            }
            _local_2[k.colourIndex] = k.id;
        }

        function furnitureDataError(k:AssetLoaderEvent)
        {
            HabboWebTools.logEventLog(("furnituredata download error " + Std.string(k.status)));
            Core.error("Could not download furnidata definition", true, Core.ERROR_CATEGORY_FURNIDATA_DOWNLOAD);
        }

        function registerFurnitureLocalization(k:FurnitureData)
        {
            if (this._localization != null)
            {
                if (k.type == FurnitureData.S)
                {
                    this._localization.updateLocalization(("roomItem.name." + Std.string(k.id)), k.localizedName);
                    this._localization.updateLocalization(("roomItem.desc." + Std.string(k.id)), k.description);
                }
                else
                {
                    if (k.type == FurnitureData.I)
                    {
                        this._localization.updateLocalization(("wallItem.name." + Std.string(k.id)), k.localizedName);
                        this._localization.updateLocalization(("wallItem.desc." + Std.string(k.id)), k.description);
                    }
                }
            }
        }

        function removePatternFrom(k:Array<ASAny>, _arg_2:ASObject)
        {
            var _local_3 = 0;
            while (_local_3 < k.length)
            {
                if (k[_local_3] == _arg_2)
                {
                    k.splice(_local_3, 1);
                    _local_3--;
                }
                _local_3++;
            }
        }
    }
