package com.sulake.habbo.friendbar.landingview.widget
;
    import com.sulake.habbo.friendbar.landingview.interfaces.ILandingViewWidget;
    import com.sulake.habbo.friendbar.landingview.interfaces.ISettingsAwareWidget;
    import com.sulake.core.runtime.IUpdateReceiver;
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.landingview.PromoArticlesMessageEvent;
    import com.sulake.habbo.communication.messages.outgoing.landingview.GetPromoArticlesComposer;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.friendbar.landingview.layout.WidgetContainerLayout;
    import com.sulake.habbo.friendbar.landingview.layout.CommonWidgetSettings;
    import com.sulake.habbo.communication.messages.incoming.landingview.PromoArticleData;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.habbo.utils.HabboWebTools;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;

     class PromoArticleWidget implements ILandingViewWidget implements  ISettingsAwareWidget implements  IUpdateReceiver 
    {
        static final _Str_3981:Float = ((10 * 60) * 1000);//600000
        static inline final _Str_6534:Float = 500;
        static inline final _Str_18540= 10;

        var _landingView:HabboLandingView;
        var _container:IWindowContainer;
        var _currentArticle:Int = 0;
        var _articles:Array<ASAny>;
        var _lastRequestTime:Date;
        var _articlesListener:IMessageEvent;
        var _fadePhase:UInt = 0;

        public function new(k:HabboLandingView)
        {
            this._articles = [];
            this._landingView = k;
        }

        public function initialize()
        {
            this._container = cast(this._landingView.getXmlWindow("promo_article"), IWindowContainer);
            this._container.procedure = this.onMouse;
            this._articlesListener = new PromoArticlesMessageEvent(this.onPromoArticles);
            this._landingView.communicationManager.addHabboConnectionMessageEvent(this._articlesListener);
        }

        public function refresh()
        {
            if (((this._lastRequestTime == null) || ((this._lastRequestTime.getTime() + _Str_3981) < Date.now().getTime())))
            {
                this._landingView.send(new GetPromoArticlesComposer());
                this._lastRequestTime = Date.now();
            }
            else
            {
                this.goToArticle(this._currentArticle);
            }
        }

        public var container(get,never):IWindow;
public function  get_container():IWindow
        {
            return this._container;
        }

        public function dispose()
        {
            if (((this._articlesListener != null) && (this._landingView != null)))
            {
                this._landingView.communicationManager.removeHabboConnectionMessageEvent(this._articlesListener);
                this._articlesListener.dispose();
                this._articlesListener = null;
            }
            if (this._container != null)
            {
                this._container.dispose();
                this._container = null;
            }
            this._landingView = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._landingView == null;
        }

        public var settings(never,set):CommonWidgetSettings;
public function  set_settings(k:CommonWidgetSettings):CommonWidgetSettings        {
            WidgetContainerLayout.applyCommonWidgetSettings(this._container, k);
return k;
        }

        function refreshContent()
        {
            this.setArticleContent();
            this.setNavigationDisks();
        }

        function setArticleContent()
        {
            var article:PromoArticleData = null;
            article = this._articles[this._currentArticle];
            if (article != null)
            {
                this._container.findChildByName("promo_title").caption = article.title;
                this._container.findChildByName("promo_text").caption = article.bodyText;
                this._container.findChildByName("button").visible = (!((article.linkType == PromoArticleData.LINK_TYPE_NO_LINK) || ((article.linkType == PromoArticleData.LINK_TYPE_URL) && (article.linkContent == ""))));
                this._container.findChildByName("button").immediateClickMode = true;
                this._container.findChildByName("button").caption = article.buttonText;
                this._container.findChildByName("promo_image").visible = (!(article.imageUrl == ""));
                try
                {
                    cast(this._container.findChildByName("promo_image"), IStaticBitmapWrapperWindow).assetUri = ("${image.library.url}" + article.imageUrl);
                }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                 {
                    _landingView.context.warning(("Missing image url for promo article with title: " + article.title));
                }
 }            }
        }

        function setNavigationDisks()
        {
            var _local_3:IRegionWindow = null;
            var _local_4:IStaticBitmapWrapperWindow = null;
            var k= cast(this._container.findChildByName("navigation"), IWindowContainer);
            var _local_2 = 0;
            while (_local_2 < _Str_18540)
            {
                _local_3 = cast(k.getChildAt(_local_2), IRegionWindow);
                if (this._articles.length > _local_2)
                {
                    _local_4 = cast(_local_3.getChildAt(0), IStaticBitmapWrapperWindow);
                    _local_4.assetUri = ("progress_disk_flat_" + ((this._currentArticle == _local_2) ? "on" : "off"));
                    _local_3.visible = true;
                }
                else
                {
                    _local_3.visible = false;
                }
                _local_2++;
            }
        }

        function goToArticle(k:Int)
        {
            var _local_2:ASAny = (k == this._currentArticle);
            if (this._articles.length == 0)
            {
                return;
            }
            if (k < 0)
            {
                this._currentArticle = (this._articles.length - 1);
            }
            else
            {
                if (k >= this._articles.length)
                {
                    this._currentArticle = 0;
                }
                else
                {
                    this._currentArticle = k;
                }
            }
            if (_local_2)
            {
                this.refreshContent();
            }
            else
            {
                this.startFade();
            }
        }

        function startFade()
        {
            this._fadePhase = 0;
            this._landingView.registerUpdateReceiver(this, 1);
        }

        function stopFade()
        {
            this._landingView.removeUpdateReceiver(this);
            this.setBlend(1);
        }

        function followLink()
        {
            var k:PromoArticleData = this._articles[this._currentArticle];
            switch (k.linkType)
            {
                case PromoArticleData.LINK_TYPE_URL:
                    HabboWebTools.openWebPage(k.linkContent);
                    return;
                case PromoArticleData.LINK_TYPE_INTERNAL:
                    this._landingView.context.createLinkEvent(k.linkContent);
                    return;
            }
        }

        function onMouse(k:WindowEvent, _arg_2:IWindow)
        {
            if (_arg_2.name == "article_navigation")
            {
                if (k.type == WindowMouseEvent.OVER)
                {
                    this.hoverOverNavigation(_arg_2, true);
                }
                else
                {
                    if (((k.type == WindowMouseEvent.OUT) && (!(_arg_2.id == this._currentArticle))))
                    {
                        this.hoverOverNavigation(_arg_2, false);
                    }
                }
            }
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            switch (_arg_2.name)
            {
                case "button":
                    this.followLink();
                    return;
                case "article_navigation":
                    this.goToArticle(_arg_2.id);
                    return;
            }
        }

        function hoverOverNavigation(k:IWindow, _arg_2:Bool)
        {
            var _local_3= cast(cast(k, IWindowContainer).getChildAt(0), IStaticBitmapWrapperWindow);
            if (_local_3 == null)
            {
                return;
            }
            _local_3.assetUri = ("progress_disk_flat_" + (_arg_2 ? "on" : "off"));
        }

        function onPromoArticles(k:PromoArticlesMessageEvent)
        {
            var _local_2:PromoArticleData = null;
            this._articles = [];
            final _iter_ = k.getParser().articles; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                this._articles.push(_local_2);
            }
            this.refresh();
        }

        function setBlend(k:Float)
        {
            this._container.findChildByName("promo_title").blend = k;
            this._container.findChildByName("promo_text").blend = k;
            this._container.findChildByName("button").blend = k;
            this._container.findChildByName("promo_image").blend = k;
        }

        public function update(k:UInt)
        {
            var _local_2= (this._fadePhase + k);
            if (this._fadePhase < _Str_6534)
            {
                this.setBlend(Math.max(0, (1 - (this._fadePhase / _Str_6534))));
                if (_local_2 >= _Str_6534)
                {
                    this.refreshContent();
                }
            }
            else
            {
                this.setBlend(Math.min(1, ((this._fadePhase - _Str_6534) / _Str_6534)));
            }
            this._fadePhase = _local_2;
            if (this._fadePhase >= (_Str_6534 * 2))
            {
                this.stopFade();
            }
        }
    }

