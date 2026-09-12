package org.openvideoads.vast.config
;
    import org.openvideoads.vast.config.groupings.AbstractStreamsConfig;
    import org.openvideoads.vast.config.groupings.AdsConfigGroup;
    import org.openvideoads.vast.config.groupings._Str_5516;
    import org.openvideoads.vast.config.groupings.ShowsConfigGroup;
    import org.openvideoads.vast.config.groupings.DebugConfigGroup;
    import org.openvideoads.vast.config.groupings._Str_7514;
    import org.openvideoads.vast.config.groupings.PlayerConfigGroup;
    import org.openvideoads.vast.config.groupings.analytics.AnalyticsConfigGroup;
    import org.openvideoads.vast.playlist._Str_4575;
    import org.openvideoads.vast.server.config.AdServerConfig;
    import org.openvideoads.vast.config.groupings.ProvidersConfigGroup;

     class Config extends AbstractStreamsConfig implements _Str_2741 
    {
        var _Str_2462:AdsConfigGroup;
        var _Str_6000:_Str_5516;
        var _Str_2622:ShowsConfigGroup;
        var _Str_4509:DebugConfigGroup;
        var _Str_9223:_Str_7514;
        var _Str_2860:PlayerConfigGroup;
        var _Str_5933:AnalyticsConfigGroup;
        var _Str_19053:Bool = false;
        var _Str_19317:Bool = false;

        public function new(k:ASObject=null, _arg_2:_Str_2741=null)
        {
            this._Str_2462 = new AdsConfigGroup();
            this._Str_6000 = new _Str_5516();
            this._Str_2622 = new ShowsConfigGroup();
            this._Str_4509 = new DebugConfigGroup();
            this._Str_9223 = new _Str_7514();
            this._Str_2860 = new PlayerConfigGroup();
            this._Str_5933 = new AnalyticsConfigGroup();
            super(k, _arg_2);
            if (((!(k == null)) || (!(_arg_2 == null))))
            {
                this.initialise(k, _arg_2);
            }
        }

        override public function initialise(k:ASObject=null, _arg_2:_Str_2741=null, _arg_3:Bool=false)
        {
            super.initialise(k, _arg_2);
            if (k != null)
            {
                if (k.shows != /*undefined*/null)
                {
                    this.shows = k.shows;
                }
                else
                {
                    this._Str_2622.initialise(null, this);
                }
                if (k.regions != /*undefined*/null)
                {
                    this.regions = k.regions;
                }
                else
                {
                    this._Str_6000.initialise(null, this);
                }
                if (k.tagParams != /*undefined*/null)
                {
                    this.adsConfig.tagParams = k.tagParams;
                }
                if (k.ads != /*undefined*/null)
                {
                    this.ads = k.ads;
                }
                else
                {
                    this._Str_2462.initialise(null, this);
                }
                if (k.tag != /*undefined*/null)
                {
                    this.adsConfig.tag = k.tag;
                }
                if (k.providers != /*undefined*/null)
                {
                    this.providers = k.providers;
                }
                if (k.debug != /*undefined*/null)
                {
                    this.debug = k.debug;
                }
                else
                {
                    this._Str_4509.initialise(null, this);
                }
                if (k.player != /*undefined*/null)
                {
                    this.player = k.player;
                }
                else
                {
                    this._Str_2860.initialise(null, this);
                }
                if (k.analytics != /*undefined*/null)
                {
                    this.analytics = k.analytics;
                }
                else
                {
                    this._Str_5933.initialise(null, this);
                }
                if (k.supportExternalPlaylistLoading != /*undefined*/null)
                {
                    if (Std.is(k.supportExternalPlaylistLoading , String))
                    {
                        this.supportExternalPlaylistLoading = ((k.supportExternalPlaylistLoading.toUpperCase() == "TRUE") ? true : false);
                    }
                    else
                    {
                        this.supportExternalPlaylistLoading = k.supportExternalPlaylistLoading;
                    }
                }
                if (k.autoPlayOnExternalLoad != /*undefined*/null)
                {
                    if (Std.is(k.autoPlayOnExternalLoad , String))
                    {
                        this.autoPlayOnExternalLoad = ((k.autoPlayOnExternalLoad.toUpperCase() == "TRUE") ? true : false);
                    }
                    else
                    {
                        this.autoPlayOnExternalLoad = k.autoPlayOnExternalLoad;
                    }
                }
                if (this._Str_2860 != null)
                {
                    if (this._Str_2860._Str_18778())
                    {
                        this._Str_2462._Str_19379(ASCompat.toInt(this._Str_2860.height));
                    }
                    if (this._Str_2860._Str_16865())
                    {
                        this._Str_2462._Str_20939(ASCompat.toInt(this._Str_2860.width));
                    }
                }
            }
            this.onOVAConfigLoaded();
        }

        public function _Str_26353()
        {
            if (this._Str_2462._Str_6073() == false)
            {
                this._Str_2462._Str_3144();
            }
            if (this._Str_6000._Str_6073() == false)
            {
                this._Str_6000._Str_3144();
            }
            if (this._Str_2622._Str_6073() == false)
            {
                this._Str_2622._Str_3144();
            }
            if (this._Str_4509._Str_6073() == false)
            {
                this._Str_4509._Str_3144();
            }
            if (this._Str_9223._Str_6073() == false)
            {
                this._Str_9223._Str_3144();
            }
            if (this._Str_5933._Str_6073() == false)
            {
                this._Str_5933._Str_3144();
            }
            if (this._Str_2860._Str_6073() == false)
            {
                this._Str_2860._Str_3144();
            }
        }

        override public function setLoadedListener(k:_Str_2741)
        {
            _Str_4686 = k;
            this.onOVAConfigLoaded();
        }

        override public function onOVAConfigLoaded()
        {
            if ((((((((!this._Str_2462.isOVAConfigLoading()) && (!this._Str_6000.isOVAConfigLoading())) && (!this._Str_2622.isOVAConfigLoading())) && (!this._Str_4509.isOVAConfigLoading())) && (!this._Str_9223.isOVAConfigLoading())) && (!this._Str_5933.isOVAConfigLoading())) && (!this._Str_2860.isOVAConfigLoading())))
            {
                if (_Str_4686 != null)
                {
                    _Str_4686.onOVAConfigLoaded();
                }
            }
        }

        override public function isOVAConfigLoading():Bool
        {
            return (((this._Str_2462.isOVAConfigLoading() || this._Str_6000.isOVAConfigLoading()) || this._Str_2622.isOVAConfigLoading()) || this._Str_4509.isOVAConfigLoading()) || this._Str_9223.isOVAConfigLoading();
        }

        public function _Str_25879(k:_Str_4575)
        {
            this._Str_2622.streams = k._Str_10087();
        }

        public function _Str_18778():Bool
        {
            if (this._Str_2860 != null)
            {
                return this._Str_2860._Str_18778();
            }
            return false;
        }

        public function _Str_16865():Bool
        {
            if (this._Str_2860 != null)
            {
                return this._Str_2860._Str_16865();
            }
            return false;
        }

        
        public var playerHeight(get,set):Int;
public function  set_playerHeight(k:Int):Int        {
            if (this._Str_2860 == null)
            {
                this._Str_2860 = new PlayerConfigGroup();
            }
            this._Str_2860.height = k;
            if (this._Str_2462 != null)
            {
                this._Str_2462._Str_19379(ASCompat.toInt(this._Str_2860.height));
            }
return k;
        }
public function  get_playerHeight():Int
        {
            if (this._Str_2860 != null)
            {
                return ASCompat.toInt(this._Str_2860.height);
            }
            return -1;
        }

        
        public var playerWidth(get,set):Int;
public function  set_playerWidth(k:Int):Int        {
            if (this._Str_2860 == null)
            {
                this._Str_2860 = new PlayerConfigGroup();
            }
            this._Str_2860.width = k;
            if (this._Str_2462 != null)
            {
                this._Str_2462._Str_20939(ASCompat.toInt(this._Str_2860.width));
            }
return k;
        }
public function  get_playerWidth():Int
        {
            if (this._Str_2860 != null)
            {
                return ASCompat.toInt(this._Str_2860.width);
            }
            return -1;
        }

        
        public var supportExternalPlaylistLoading(get,set):Bool;
public function  set_supportExternalPlaylistLoading(k:Bool):Bool        {
            return this._Str_19053 = k;
        }
public function  get_supportExternalPlaylistLoading():Bool
        {
            return this._Str_19053;
        }

        
        public var autoPlayOnExternalLoad(get,set):Bool;
public function  set_autoPlayOnExternalLoad(k:Bool):Bool        {
            return this._Str_19317 = k;
        }
public function  get_autoPlayOnExternalLoad():Bool
        {
            return this._Str_19317;
        }

        public function _Str_12146():Bool
        {
            return this._Str_2462._Str_12146();
        }

        public var millisecondDelayOnCompanionInjection(get,never):Int;
public function  get_millisecondDelayOnCompanionInjection():Int
        {
            return this._Str_2462.millisecondDelayOnCompanionInjection;
        }

        
        public var analytics(get,set):AnalyticsConfigGroup;
public function  set_analytics(k:ASAny):AnalyticsConfigGroup        {
            if (Std.is(k , AnalyticsConfigGroup))
            {
                this._Str_5933 = k;
                this._Str_5933.initialise(null, this, true);
            }
            else
            {
                this._Str_5933.initialise(k, this, true);
            }
return k;
        }
public function  get_analytics():AnalyticsConfigGroup
        {
            return this._Str_5933;
        }

        public var tag(never,set):String;
public function  set_tag(k:String):String        {
            if (this._Str_2462 != null)
            {
                this._Str_2462.tag = k;
            }
return k;
        }

        public var tagParams(never,set):ASObject;
public function  set_tagParams(k:ASObject):ASObject        {
            if (this._Str_2462 != null)
            {
                this._Str_2462.tagParams = k;
            }
return k;
        }

        public function _Str_21394():Bool
        {
            return this._Str_2622.enableProxies;
        }

        public function _Str_20773():Bool
        {
            return this._Str_2462.enableProxies;
        }

        public function canSkipOnLinearAd():Bool
        {
            return this._Str_2462.canSkipOnLinearAd();
        }

        public function getLinearVPAIDRegionID():String
        {
            return this._Str_2462.vpaidConfig.getLinearRegion((!this._Str_2860.shouldHideControlsOnLinearPlayback(true)));
        }

        public function getNonLinearVPAIDRegionID():String
        {
            return this._Str_2462.vpaidConfig.nonLinearRegion;
        }

        public function vpaidMaxDurationTimeoutEnabled():Bool
        {
            return this._Str_2462.vpaidMaxDurationTimeoutEnabled();
        }

        public var vpaidMaxDurationTimeout(get,never):Int;
public function  get_vpaidMaxDurationTimeout():Int
        {
            return this._Str_2462.vpaidMaxDurationTimeout;
        }

        public function controlEnabledForLinearAdType(k:String, _arg_2:Bool):Bool
        {
            return this._Str_2860.controlEnabledForLinearAdType(k, _arg_2);
        }

        public var scheduleAds(get,never):Bool;
public function  get_scheduleAds():Bool
        {
            return this._Str_2462.activelySchedule;
        }

        public var shows(never,set):ASObject;
public function  set_shows(k:ASObject):ASObject        {
            if (k.player != /*undefined*/null)
            {
                k.player = this.player;
            }
            this._Str_2622.initialise(k, this);
return k;
        }

        
        public var _Str_21867(get,set):ShowsConfigGroup;
public function  get__Str_21867():ShowsConfigGroup
        {
            return this._Str_2622;
        }
public function  set__Str_21867(k:ShowsConfigGroup):ShowsConfigGroup        {
            return this._Str_2622 = k;
        }

        public function _Str_26049():Bool
        {
            return this._Str_2622._Str_21533();
        }

        public var regions(never,set):ASObject;
public function  set_regions(k:ASObject):ASObject        {
            this._Str_6000 = new _Str_5516();
            this._Str_6000.initialise(k, this);
return k;
        }

        public var _Str_23104(get,never):_Str_5516;
public function  get__Str_23104():_Str_5516
        {
            return this._Str_6000;
        }

        override public function  set_player(k:ASObject):ASObject        {
            if (this._Str_2860 == null)
            {
                this._Str_2860 = new PlayerConfigGroup();
            }
            this._Str_2860.initialise(k, this);
return k;
        }

        
        public var _Str_4565(get,set):PlayerConfigGroup;
public function  set__Str_4565(k:PlayerConfigGroup):PlayerConfigGroup        {
            return this._Str_2860 = k;
        }
public function  get__Str_4565():PlayerConfigGroup
        {
            return this._Str_2860;
        }

        public var ads(never,set):ASObject;
public function  set_ads(k:ASObject):ASObject        {
            if (k != null)
            {
                if (k.player != /*undefined*/null)
                {
                    k.player = this.player;
                }
                this._Str_2462.initialise(k, this);
            }
return k;
        }

        public var adsConfig(get,never):AdsConfigGroup;
public function  get_adsConfig():AdsConfigGroup
        {
            return this._Str_2462;
        }

        public var _Str_26185(get,never):_Str_7514;
public function  get__Str_26185():_Str_7514
        {
            return this._Str_9223;
        }

        public var pauseOnClickThrough(get,never):Bool;
public function  get_pauseOnClickThrough():Bool
        {
            return this._Str_2462.pauseOnClickThrough;
        }

        public function _Str_21050():Bool
        {
            return this._Str_2462.setDurationFromMetaData;
        }

        public function _Str_19637():Bool
        {
            return this._Str_2622.setDurationFromMetaData;
        }

        public function operateWithoutStreamDuration():Bool
        {
            return this._Str_2622.mustOperateWithoutDuration();
        }

        public var adServerConfig(get,never):AdServerConfig;
public function  get_adServerConfig():AdServerConfig
        {
            return this._Str_2462.adServerConfig;
        }

        public var debug(never,set):ASObject;
public function  set_debug(k:ASObject):ASObject        {
            this._Str_4509 = new DebugConfigGroup();
            this._Str_4509.initialise(k, this);
return k;
        }

        public function _Str_26135():Bool
        {
            return this._Str_2622._Str_21533();
        }

        
        public var streams(get,set):Array<ASAny>;
public function  set_streams(k:Array<ASAny>):Array<ASAny>        {
            return this._Str_2622.streams = k;
        }
public function  get_streams():Array<ASAny>
        {
            return this._Str_2622.streams;
        }

        public function _Str_21649(k:Array<ASAny>)
        {
            this._Str_2622._Str_21649(k);
        }

        public var previewImage(get,never):String;
public function  get_previewImage():String
        {
            if (this._Str_2622 != null)
            {
                return this._Str_2622._Str_12928();
            }
            return null;
        }

        public function _Str_8478():Bool
        {
            return this._Str_2462._Str_8478();
        }

        public var companionDivIDs(get,never):Array<ASAny>;
public function  get_companionDivIDs():Array<ASAny>
        {
            return this._Str_2462.companionDivIDs;
        }

        public var displayCompanions(get,never):Bool;
public function  get_displayCompanions():Bool
        {
            return this._Str_2462.displayCompanions;
        }

        public var restoreCompanions(get,never):Bool;
public function  get_restoreCompanions():Bool
        {
            return this._Str_2462.restoreCompanions;
        }

        public var _Str_7826(get,never):Bool;
public function  get__Str_7826():Bool
        {
            return this._Str_2462._Str_7826;
        }

        public var _Str_22059(get,never):Bool;
public function  get__Str_22059():Bool
        {
            return this._Str_2462.nativeDisplay == false;
        }

        public var notice(get,never):ASObject;
public function  get_notice():ASObject
        {
            return this._Str_2462.notice;
        }

        public var showNotice(get,never):Bool;
public function  get_showNotice():Bool
        {
            return this._Str_2462.showNotice();
        }

        public var _Str_16561(get,never):Bool;
public function  get__Str_16561():Bool
        {
            return this._Str_2462._Str_16561;
        }

        public var _Str_8392(get,never):Array<ASAny>;
public function  get__Str_8392():Array<ASAny>
        {
            return this._Str_2462.schedule;
        }

        override public function hasProviders():Bool
        {
            return this._Str_2622.hasProviders() && this._Str_2462.hasProviders();
        }

        override public function setDefaultProviders()
        {
            _Str_3337 = new ProvidersConfigGroup();
            this._Str_2622.setDefaultProviders();
            this._Str_2462.setDefaultProviders();
        }

        public function ensureProvidersAreSet()
        {
            if (_Str_3337 == null)
            {
                _Str_3337 = new ProvidersConfigGroup();
            }
            if (!this._Str_2622.hasProviders())
            {
                this._Str_2622.setDefaultProviders();
            }
            if (!this._Str_2462.hasProviders())
            {
                this._Str_2462.setDefaultProviders();
            }
        }

        public function _Str_25978(k:String, _arg_2:String)
        {
            if (_Str_3337 == null)
            {
                _Str_3337 = new ProvidersConfigGroup();
                _Str_3337.httpProvider = k;
                _Str_3337.rtmpProvider = _arg_2;
            }
            if (!this._Str_2622.hasProviders())
            {
                this._Str_2622.setDefaultProviders();
                this._Str_2622.httpProvider = k;
                this._Str_2622.rtmpProvider = _arg_2;
            }
            if (!this._Str_2462.hasProviders())
            {
                this._Str_2462.setDefaultProviders();
                this._Str_2462.httpProvider = k;
                this._Str_2462.rtmpProvider = _arg_2;
            }
        }

        override public function  set_rtmpProvider(k:String):String        {
            _Str_4721.rtmpProvider = k;
            this._Str_2622.rtmpProvider = k;
            return this._Str_2462.rtmpProvider = k;
        }

        override public function  set_httpProvider(k:String):String        {
            _Str_4721.httpProvider = k;
            this._Str_2622.httpProvider = k;
            return this._Str_2462.httpProvider = k;
        }

        public function _Str_26245():ProvidersConfigGroup
        {
            return this._Str_2622._Str_4721;
        }

        public function _Str_26413():ProvidersConfigGroup
        {
            return this._Str_2462._Str_4721;
        }

        public function _Str_26258(k:String):String
        {
            return this._Str_2622.getProvider(k);
        }

        
        public var _Str_23390(get,set):String;
public function  set__Str_23390(k:String):String        {
            return this._Str_2622.rtmpProvider = k;
        }
public function  get__Str_23390():String
        {
            return this._Str_2622.rtmpProvider;
        }

        
        public var _Str_25128(get,set):String;
public function  set__Str_25128(k:String):String        {
            return this._Str_2622.httpProvider = k;
        }
public function  get__Str_25128():String
        {
            return this._Str_2622.httpProvider;
        }

        public function _Str_26026(k:String):String
        {
            return this._Str_2462.getProvider(k);
        }

        
        public var _Str_24310(get,set):String;
public function  set__Str_24310(k:String):String        {
            return this._Str_2462.rtmpProvider = k;
        }
public function  get__Str_24310():String
        {
            return this._Str_2462.rtmpProvider;
        }

        
        public var _Str_24194(get,set):String;
public function  set__Str_24194(k:String):String        {
            return this._Str_2462.httpProvider = k;
        }
public function  get__Str_24194():String
        {
            return this._Str_2462.httpProvider;
        }

        override public function  get_allowPlaylistControl():Bool
        {
            return this._Str_2622._Str_23304() ? this._Str_2622.allowPlaylistControl : _Str_11903;
        }

        override public function  get_playOnce():Bool
        {
            return this._Str_2462._Str_22516() ? this._Str_2462.playOnce : _Str_4538;
        }

        override public function  get_deliveryType():String
        {
            return this._Str_2622._Str_19939() ? this._Str_2622.deliveryType : (this._Str_2462._Str_19939() ? this._Str_2462.deliveryType : _Str_4101);
        }

        override public function  get_baseURL():String
        {
            return this._Str_2622._Str_20891() ? this._Str_2622.baseURL : (this._Str_2462._Str_20891() ? this._Str_2462.baseURL : _Str_2846);
        }

        override public function  get_streamType():String
        {
            return this._Str_2622._Str_21706() ? this._Str_2622.streamType : (this._Str_2462._Str_21706() ? this._Str_2462.streamType : _Str_4718);
        }

        override public function  get_subscribe():Bool
        {
            return this._Str_2622._Str_21260() ? this._Str_2622.subscribe : (this._Str_2462._Str_21260() ? this._Str_2462.subscribe : _Str_10343);
        }

        override public function  get_bitrate():ASAny
        {
            return this._Str_2622._Str_21448() ? this._Str_2622.bitrate : (this._Str_2462._Str_21448() ? this._Str_2462.bitrate : _Str_4980);
        }

        public var visuallyCueLinearAdClickThrough(get,never):Bool;
public function  get_visuallyCueLinearAdClickThrough():Bool
        {
            return this._Str_2462.visuallyCueLinearAdClickThrough;
        }

        
        public var acceptedLinearAdMimeTypes(get,set):Array<ASAny>;
public function  set_acceptedLinearAdMimeTypes(k:Array<ASAny>):Array<ASAny>        {
            return this._Str_2462.acceptedLinearAdMimeTypes = k;
        }
public function  get_acceptedLinearAdMimeTypes():Array<ASAny>
        {
            return this._Str_2462.acceptedLinearAdMimeTypes;
        }

        
        public var filterOnLinearAdMimeTypes(get,set):Bool;
public function  set_filterOnLinearAdMimeTypes(k:Bool):Bool        {
            return this._Str_2462.filterOnLinearAdMimeTypes = k;
        }
public function  get_filterOnLinearAdMimeTypes():Bool
        {
            return this._Str_2462.filterOnLinearAdMimeTypes;
        }

        public function _Str_16875():Bool
        {
            return this._Str_4509._Str_16875();
        }

        public var debugger(get,never):String;
public function  get_debugger():String
        {
            return this._Str_4509.debugger;
        }

        public function outputingDebug():Bool
        {
            return this._Str_4509.outputingDebug();
        }

        public var _Str_23960(get,never):String;
public function  get__Str_23960():String
        {
            return this._Str_4509.levels;
        }

        public function _Str_18288():Bool
        {
            return this._Str_4509._Str_18288();
        }
    }

