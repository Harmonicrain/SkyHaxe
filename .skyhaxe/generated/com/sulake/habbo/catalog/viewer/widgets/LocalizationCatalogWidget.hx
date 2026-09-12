package com.sulake.habbo.catalog.viewer.widgets
;
    import com.sulake.habbo.catalog.HabboCatalog;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.catalog.viewer.widgets.events.CatalogWidgetEvent;
    import com.sulake.habbo.catalog.viewer.widgets.events.SelectProductEvent;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window._enum.WindowParam;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.runtime.IHabboConfigurationManager;
    import com.sulake.habbo.catalog._enum.CatalogPageName;
    import com.sulake.habbo.utils.HabboWebTools;
    import com.sulake.habboclient.ExternalVariables;
    import com.sulake.habbo.window.utils.IAlertDialog;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.display.BitmapData;
    import com.sulake.habbo.catalog.viewer.PageLocalization;
    import com.sulake.core.window.components.IHTMLTextWindow;
    import com.sulake.core.window.events.WindowLinkEvent;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.habbo.catalog.viewer.CatalogPage;
    import com.sulake.habbo.catalog._enum.CatalogType;
    import com.sulake.core.assets.BitmapDataAsset;
    import flash.geom.Point;
    import flash.net.URLRequest;
    import com.sulake.core.assets.AssetLoaderStruct;
    import com.sulake.core.assets.loaders.AssetLoaderEvent;
    import flash.text.StyleSheet;
    import com.sulake.core.window.components.ITextWindow;

     class LocalizationCatalogWidget extends CatalogWidget
    {
        var _imageElementMap:ASDictionary<ASAny,ASAny>;
        var _catalog:HabboCatalog;

        public function new(k:IWindowContainer, _arg_2:HabboCatalog)
        {
            super(k);
            this._imageElementMap = new ASDictionary<ASAny,ASAny>();
            this._catalog = _arg_2;
        }

        override public function dispose()
        {
            super.dispose();
            this._catalog = null;
        }

        override public function init():Bool
        {
            if (!super.init())
            {
                return false;
            }
            this._Str_22511();
            this._Str_25677();
            this._Str_7955();
            events.addEventListener(CatalogWidgetEvent.SELECT_PRODUCT, this._Str_25040);
            return true;
        }

        function _Str_25040(k:SelectProductEvent)
        {
            if (k == null)
            {
                return;
            }
        }

        function _Str_7955()
        {
            var k:String = null;
            var _local_2:IWindow = null;
            if (page.hasLinks)
            {
                final _iter_ = page.links; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
k  = _tmp_;
                    _local_2 = _window.findChildByName(k);
                    if (_local_2 != null)
                    {
                        _local_2.setParamFlag(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR);
                        _local_2.mouseThreshold = 0;
                        _local_2.addEventListener(WindowMouseEvent.CLICK, this._Str_18285);
                    }
                }
            }
        }

        function _Str_18285(k:WindowMouseEvent)
        {
            var _local_6:String = null;
            var _local_2= Std.downcast(page.viewer.catalog , HabboCatalog).localization;
            var _local_3:IHabboConfigurationManager = Std.downcast(page.viewer.catalog , HabboCatalog);
            var _local_4= k.target.name;
            var _local_5= "";
            switch (page.layoutCode)
            {
                case "frontpage3":
                    switch (_local_4)
                    {
                        case "ctlg_txt3":
                            if (k.target.caption != "")
                            {
                                _local_5 = page.localization.getTextElementContent(6);
                                page.viewer.catalog.openCatalogPage(_local_5);
                            }
                            
                        case "ctlg_txt7":
                            if (k.target.caption != "")
                            {
                                _local_5 = page.localization.getTextElementContent(10);
                                if (_local_5.indexOf("http") >= 0)
                                {
                                    this.openExternalLink(_local_5);
                                }
                                else
                                {
                                    if (_local_5 == CatalogPageName.CREDITS)
                                    {
                                        HabboWebTools.openWebPageAndMinimizeClient(this._catalog.getProperty(ExternalVariables.WEB_SHOP_RELATIVE_URL));
                                    }
                                    else
                                    {
                                        page.viewer.catalog.openCatalogPage(_local_5);
                                    }
                                }
                            }
                            
                    }
                    return;
                case "info_pixels":
                    switch (_local_4)
                    {
                        case "ctlg_text_5":
                            this._catalog.questEngine.showAchievements();
                            
                        case "ctlg_text_7":
                            _local_5 = page.localization.getTextElementContent(7);
                            page.viewer.catalog.openCatalogPage(_local_5);
                            
                    }
                    return;
                case "info_credits":
                    switch (_local_4)
                    {
                        case "ctlg_text_5":
                            HabboWebTools.openWebPageAndMinimizeClient(this._catalog.getProperty(ExternalVariables.WEB_SHOP_RELATIVE_URL));
                            
                        case "ctlg_text_7":
                            _local_5 = page.localization.getTextElementContent(7);
                            page.viewer.catalog.openCatalogPage(_local_5);
                            
                    }
                    return;
                case "collectibles":
                    switch (_local_4)
                    {
                        case "ctlg_collectibles_link":
                            _local_5 = _local_3.getProperty("link.format.collectibles");
                            this.openExternalLink(_local_5);
                            
                    }
                    return;
                case "club1":
                    switch (_local_4)
                    {
                        case "ctlg_text_5":
                            page.viewer.catalog.openCatalogPage(CatalogPageName.HC_MEMBERSHIP);
                            
                    }
                    return;
                case "club_buy":
                    switch (_local_4)
                    {
                        case "club_link":
                            _local_5 = _local_3.getProperty("link.format.club");
                            this.openExternalLink(_local_5);
                            
                    }
                    return;
                case "mad_money":
                    switch (_local_4)
                    {
                        case "ctlg_madmoney_button":
                            _local_5 = _local_3.getProperty("link.format.madmoney");
                            this.openExternalLink(_local_5);
                            
                    }
                    return;
                case "monkey":
                    switch (_local_4)
                    {
                        case "ctlg_teaserimg_1_region"
                           | "ctlg_special_img_region":
                            _local_5 = _local_2.getLocalization("link.format.monkey", "http://store.apple.com/");
                            this.openExternalLink(_local_5);
                            
                    }
                    return;
                case "niko":
                    switch (_local_4)
                    {
                        case "ctlg_teaserimg_1_region"
                           | "ctlg_special_img_region":
                            _local_5 = _local_2.getLocalization("link.format.niko", "http://itunes.apple.com/us/app/niko/id481670205?mt=8");
                            this.openExternalLink(_local_5);
                            
                    }
                    return;
                default:
                    Logger.log([("[LocalizationCatalogWidget] Unhandled link clicked" + ASCompat.toString([page.layoutCode, _local_4]))]);
            }
        }

        function openExternalLink(k:String)
        {
            if (k != "")
            {
                page.viewer.catalog.windowManager.alert("${catalog.alert.external.link.title}", "${catalog.alert.external.link.desc}", 0, this.onExternalLink);
                HabboWebTools.navigateToURL(k, "habboMain");
            }
        }

        function onExternalLink(k:IAlertDialog, _arg_2:WindowEvent)
        {
            k.dispose();
        }

        function _Str_25677()
        {
            var _local_2:IWindow = null;
            var _local_3:String = null;
            var _local_4:String = null;
            var k:Array<ASAny> = [];
            _window.groupChildrenWithTag("STATIC_IMAGE", k, 10);
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_2  = _tmp_;
                if (Std.is(_local_2 , IBitmapWrapperWindow))
                {
                    _local_3 = _local_2.name;
                    _local_4 = _local_2.name;
                    this._imageElementMap[_local_4] = _local_3;
                    if (page.viewer.catalog.assets.hasAsset(_local_4))
                    {
                        this.setElementImage(_local_3, _local_4);
                    }
                    else
                    {
                        this._Str_21848(_local_4);
                    }
                }
            }
        }

        function _Str_22511()
        {
            var _local_2:String = null;
            var _local_3:String = null;
            var _local_7:IWindow = null;
            var _local_8:BitmapData = null;
            var _local_9:String = null;
            var k = 0;
            this._imageElementMap = new ASDictionary<ASAny,ASAny>();
            this._catalog.mainContainer.findChildByName(PageLocalization.CATALOG_HEADER_DESCRIPTION).caption = "";
            k = 0;
            while (k < page.localization.textCount)
            {
                _local_2 = page.localization.getTextElementName(k, page.layoutCode);
                _local_3 = page.localization.getTextElementContent(k);
                if (_local_2 == PageLocalization.CATALOG_HEADER_DESCRIPTION)
                {
                    _local_7 = this._catalog.mainContainer.findChildByName(_local_2);
                }
                else
                {
                    if (_window != null)
                    {
                        _local_7 = _window.findChildByName(_local_2);
                    }
                }
                if (_local_7 != null)
                {
                    _local_3 = new compat.RegExp("\\r\\n", "g").replace(_local_3, "\n");
                    _local_7.caption = _local_3;
                    if (Std.is(_local_7 , IHTMLTextWindow))
                    {
                        _local_7.addEventListener(WindowLinkEvent.WINDOW_EVENT_LINK, this._Str_25438);
                        this._Str_10740(Std.downcast(_local_7 , IHTMLTextWindow));
                    }
                }
                else
                {
                    Logger.log([((("[LocalizationCatalogWidget] Could not place text in layout:  element: " + _local_2) + ", content: ") + _local_3)]);
                }
                k++;
            }
            k = 0;
            while (k < page.localization.imageCount)
            {
                _local_2 = page.localization.getImageElementName(k, page.layoutCode);
                _local_3 = page.localization.getImageElementContent(k);
                if (_local_2 == "")
                {
                }
                else
                {
                    if (_local_3 == "")
                    {
                    }
                    else
                    {
                        _local_9 = _local_3;
                        this._imageElementMap[_local_9] = _local_2;
                        if (page.viewer.catalog.assets.hasAsset(_local_9))
                        {
                            this.setElementImage(_local_2, _local_9);
                        }
                        else
                        {
                            this._Str_21848(_local_9);
                        }
                    }
                }
                k++;
            }
            var _local_4= this._catalog.currentCatalogNavigator.getNodeById(page.pageId);
            var _local_5= this._catalog.mainContainer.findChildByName(PageLocalization.CATALOG_HEADER_TITLE);
            var _local_6= Std.downcast(this._catalog.mainContainer.findChildByName(PageLocalization.CATALOG_HEADER_ICON) , IStaticBitmapWrapperWindow);
            if (_local_5 != null)
            {
                _local_5.caption = ((_local_4 != null) ? _local_4.localization : ((page.mode == CatalogPage._Str_7035) ? "${catalog.search.header}" : "${catalog.header}"));
            }
            if (((!(_local_6 == null)) && (!(_local_4 == null))))
            {
                _local_6.assetUri = ((page.mode == CatalogPage._Str_7035) ? "common_small_pen" : ((this._catalog.catalogType == CatalogType.BUILDER) ? (this._catalog.imageGalleryHost + "icon_193.png") : ((this._catalog.imageGalleryHost + _local_4.iconName) + ".png")));
            }
        }

        function _Str_25438(k:WindowEvent)
        {
            var _local_2= Std.downcast(k , WindowLinkEvent);
            if (_local_2 != null)
            {
                Logger.log([("=============== HTML LINK: " + _local_2.link)]);
            }
            else
            {
                Logger.log([("=============== BAD HTML LINK: " + k.target)]);
            }
        }

        function setElementImage(k:String, _arg_2:String)
        {
            var _local_3:IWindow = null;
            var _local_4:BitmapDataAsset = null;
            var _local_5:BitmapData = null;
            var _local_6 = 0;
            var _local_7 = 0;
            var _local_8:String = null;
            var _local_9:String = null;
            Logger.log([("[LocalizationCatalogWidget] Set Element Image: " + ASCompat.toString([k, _arg_2]))]);
            if (_window == null)
            {
                Logger.log([("[LocalizationCatalogWidget] Window is null! " + ASCompat.toString([k, _arg_2]))]);
                return;
            }
            if (_window.disposed)
            {
                Logger.log([("[LocalizationCatalogWidget] Window is disposed! " + ASCompat.toString([k, _arg_2, _window.name]))]);
                return;
            }
            if (k == PageLocalization.CATALOG_HEADER_IMAGE)
            {
                _local_3 = this._catalog.mainContainer.findChildByName(k);
            }
            else
            {
                _local_3 = _window.findChildByName(k);
            }
            if (Std.is(_local_3 , IBitmapWrapperWindow))
            {
                _local_4 = Std.downcast(page.viewer.catalog.assets.getAssetByName(_arg_2) , BitmapDataAsset);
                if (_local_4 == null)
                {
                    Logger.log([("[LocalizationCatalogWidget] Asset does not exist (Bitmap window): " + ASCompat.toString([k, _arg_2]))]);
                    return;
                }
                _local_5 = ASCompat.dynamicAs(_local_4.content , BitmapData);
                if (Std.downcast(_local_3 , IBitmapWrapperWindow).bitmap == null)
                {
                    Std.downcast(_local_3 , IBitmapWrapperWindow).bitmap = new BitmapData(_local_3.width, _local_3.height, true, 0xFFFFFF);
                }
                Std.downcast(_local_3 , IBitmapWrapperWindow).bitmap.fillRect(Std.downcast(_local_3 , IBitmapWrapperWindow).bitmap.rect, 0xFFFFFF);
                _local_6 = Std.int((_local_3.width - _local_5.width) / 2);
                _local_7 = Std.int((_local_3.height - _local_5.height) / 2);
                Std.downcast(_local_3 , IBitmapWrapperWindow).bitmap.copyPixels(_local_5, _local_5.rect, new Point(_local_6, _local_7), null, null, true);
            }
            else
            {
                if (Std.is(_local_3 , IStaticBitmapWrapperWindow))
                {
                    _local_8 = this._catalog.getProperty("image.library.catalogue.url");
                    _local_9 = ((_local_8 + _arg_2) + ".gif");
                    Logger.log([("[LocalizationCatalogWidget] Static Image: " + _local_9)]);
                    Std.downcast(_local_3 , IStaticBitmapWrapperWindow).assetUri = _local_9;
                }
                else
                {
                    Logger.log([("[LocalizationCatalogWidget] Could not find element: " + k)]);
                }
            }
        }

        function _Str_21848(k:String)
        {
            var _local_2:String = null;
            var _local_6:IWindow = null;
            var _local_3= Std.downcast(page.viewer.catalog , HabboCatalog).getProperty("image.library.catalogue.url");
            var _local_4:ASAny = (Std.downcast(page.viewer.catalog , HabboCatalog).getProperty("image.library.url") + "Top_Story_Images/");
            var _local_5:String = this._imageElementMap[k];
            if (_local_5 == PageLocalization.CATALOG_HEADER_IMAGE)
            {
                _local_6 = this._catalog.mainContainer.findChildByName(_local_5);
            }
            else
            {
                _local_6 = _window.findChildByName(_local_5);
            }
            if (((_local_6 != null) && (_local_6.tags.indexOf("TOP_STORY") > -1)))
            {
                _local_2 = _local_4;
            }
            else
            {
                _local_2 = _local_3;
            }
            var _local_7:ASAny = ((_local_2 + k) + ".gif");
            Logger.log([("[LocalizationCatalogWidget]  : " + _local_7)]);
            var _local_8= new URLRequest(_local_7);
            var _local_9= page.viewer.catalog.assets.loadAssetFromFile(k, _local_8, "image/gif");
            _local_9.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTCOMPLETE, this._Str_24097);
        }

        function _Str_24097(k:AssetLoaderEvent)
        {
            var _local_3:String = null;
            var _local_4:String = null;
            var _local_2= ASCompat.dynamicAs(k.target , AssetLoaderStruct);
            if (_local_2 != null)
            {
                _local_3 = _local_2.assetName;
                _local_4 = this._imageElementMap[_local_3];
                this.setElementImage(_local_4, _local_3);
            }
        }

        function _Str_10740(k:ITextWindow)
        {
            if (k == null)
            {
                return;
            }
            var _local_2= new StyleSheet();
            var _local_3:ASObject = new ASObject();
            _local_3.color = "#336a95";
            var _local_4:ASObject = new ASObject();
            _local_4.textDecoration = "underline";
            _local_4.color = "#333333";
            var _local_5:ASObject = new ASObject();
            _local_5.color = "#41b7d9";
            var _local_6:ASObject = new ASObject();
            _local_6.textDecoration = "underline";
            _local_2.setStyle("a:link", _local_4);
            _local_2.setStyle("a:hover", _local_3);
            _local_2.setStyle("a:active", _local_5);
            _local_2.setStyle(".visited", _local_6);
            k.styleSheet = _local_2;
        }
    }

