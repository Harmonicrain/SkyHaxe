package org.openvideoads.vast.config.groupings
;
    import org.openvideoads.vast.config._Str_2741;
    import org.openvideoads.vast.server.config.AdServerConfig;
    import org.openvideoads.util.ArrayUtils;
    import org.openvideoads.vast.server.config._Str_6024;
    import org.openvideoads.util.Timestamp;
    import org.openvideoads.util.StringUtils;

     class AdsConfigGroup extends AbstractStreamsConfig implements _Str_2741 
    {
        var _Str_3384:AdServerConfig = null;
        var _Str_3204:Array<ASAny> = null;
        var _Str_2621:Array<ASAny>;
        var _Str_11226:AdNoticeConfig;
        var _Str_9996:ClickSignConfig;
        var _Str_17994:SurveyConfig;
        var _Str_6011:SkipAdConfig;
        var _Str_4936:CompanionsConfigGroup;
        var _Str_5258:VPAIDConfig;
        var _Str_13007:OverlaysConfig;
        var _Str_20654:String = "*";
        var _Str_21454:Bool = true;
        var _Str_20374:Bool = true;
        var _Str_20727:Bool = true;
        var _Str_11973:Bool = false;
        var _Str_4352:Array<ASAny>;
        var _Str_18821:String = null;
        var _Str_19748:Bool = false;
        var _Str_20521:Bool = false;
        var _Str_19263:Bool = false;
        var _Str_4857:ASObject = null;
        var _Str_5061:Array<ASAny> = null;
        var _Str_7343:AdMetaDataConfigGroup;
        var _Str_22194:Bool = true;
        var _Str_9470:Int = -1;
        var _Str_10909:Bool = true;
        var _Str_20228:Bool = false;
        var _Str_21804:Int = 0;

        public function new(k:ASObject=null, _arg_2:_Str_2741=null)
        {
            this._Str_2621 = new Array<ASAny>();
            this._Str_11226 = new AdNoticeConfig();
            this._Str_9996 = new ClickSignConfig();
            this._Str_17994 = new SurveyConfig();
            this._Str_6011 = new SkipAdConfig();
            this._Str_4936 = new CompanionsConfigGroup();
            this._Str_5258 = new VPAIDConfig();
            this._Str_13007 = new OverlaysConfig();
            this._Str_4352 = new Array<ASAny>();
            this._Str_7343 = new AdMetaDataConfigGroup();
            _Str_6569 = true;
            super(k, _arg_2);
        }

        override public function initialise(k:ASObject=null, _arg_2:_Str_2741=null, _arg_3:Bool=false)
        {
            _Str_3654();
            super.initialise(k, _arg_2);
            if (k != null)
            {
                if (k.activelySchedule != /*undefined*/null)
                {
                    if (Std.is(k.activelySchedule , String))
                    {
                        this.activelySchedule = ((k.activelySchedule.toUpperCase() == "TRUE") ? true : false);
                    }
                    else
                    {
                        this.activelySchedule = k.activelySchedule;
                    }
                }
                if (k.resetTrackingOnReplay != /*undefined*/null)
                {
                    if (Std.is(k.resetTrackingOnReplay , String))
                    {
                        this.resetTrackingOnReplay = (k.resetTrackingOnReplay.toUpperCase() == "TRUE");
                    }
                    else
                    {
                        this.resetTrackingOnReplay = k.resetTrackingOnReplay;
                    }
                }
                if (ASCompat.hasOwnProperty(k, "skipAd"))
                {
                    this.skipAd = new SkipAdConfig(k.skipAd);
                }
                if (ASCompat.hasOwnProperty(k, "overlays"))
                {
                    this.overlays = k.overlays;
                }
                if (k.playOnce != /*undefined*/null)
                {
                    if (Std.is(k.playOnce , String))
                    {
                        this.playOnce = ((k.playOnce.toUpperCase() == "TRUE") ? true : false);
                    }
                    else
                    {
                        this.playOnce = k.playOnce;
                    }
                }
                if (ASCompat.hasOwnProperty(k, "survey"))
                {
                    this._Str_5168 = new SurveyConfig(k.survey);
                }
                if (k.enforceMidRollPlayback != /*undefined*/null)
                {
                    if (Std.is(k.enforceMidRollPlayback , String))
                    {
                        this.enforceMidRollPlayback = ((k.enforceMidRollPlayback.toUpperCase() == "TRUE") ? true : false);
                    }
                    else
                    {
                        this.enforceMidRollPlayback = k.enforceMidRollPlayback;
                    }
                }
                if (k.enforceLinearInteractiveAdScaling != /*undefined*/null)
                {
                    if (Std.is(k.enforceLinearInteractiveAdScaling , String))
                    {
                        this.enforceLinearInteractiveAdScaling = ((k.enforceLinearInteractiveAdScaling.toUpperCase() == "TRUE") ? true : false);
                    }
                    else
                    {
                        this.enforceLinearInteractiveAdScaling = k.enforceLinearInteractiveAdScaling;
                    }
                }
                if (k.enforceLinearVideoAdScaling != /*undefined*/null)
                {
                    if (Std.is(k.enforceLinearVideoAdScaling , String))
                    {
                        this.enforceLinearVideoAdScaling = ((k.enforceLinearVideoAdScaling.toUpperCase() == "TRUE") ? true : false);
                    }
                    else
                    {
                        this.enforceLinearVideoAdScaling = k.enforceLinearVideoAdScaling;
                    }
                }
                if (k.enforceLinearAdsOnPlaylistSelection != /*undefined*/null)
                {
                    if (Std.is(k.enforceLinearAdsOnPlaylistSelection , String))
                    {
                        this.enforceLinearAdsOnPlaylistSelection = ((k.enforceLinearAdsOnPlaylistSelection.toUpperCase() == "TRUE") ? true : false);
                    }
                    else
                    {
                        this.enforceLinearAdsOnPlaylistSelection = k.enforceLinearAdsOnPlaylistSelection;
                    }
                }
                if (k.linearScaling != /*undefined*/null)
                {
                    this.linearScaling = k.linearScaling;
                }
                if (k.notice != /*undefined*/null)
                {
                    this.notice = k.notice;
                }
                if (k.visuallyCueLinearAdClickThrough != /*undefined*/null)
                {
                    if (Std.is(k.visuallyCueLinearAdClickThrough , String))
                    {
                        this.visuallyCueLinearAdClickThrough = ((k.visuallyCueLinearAdClickThrough.toUpperCase() == "TRUE") ? true : false);
                    }
                    else
                    {
                        this.visuallyCueLinearAdClickThrough = k.visuallyCueLinearAdClickThrough;
                    }
                }
                if (k.pauseOnClickThrough != /*undefined*/null)
                {
                    if (Std.is(k.pauseOnClickThrough , String))
                    {
                        this.pauseOnClickThrough = ((k.pauseOnClickThrough.toUpperCase() == "TRUE") ? true : false);
                    }
                    else
                    {
                        this.pauseOnClickThrough = k.pauseOnClickThrough;
                    }
                }
                if (k.nativeDisplay != /*undefined*/null)
                {
                    if (Std.is(k.nativeDisplay , String))
                    {
                        this.nativeDisplay = ((k.nativeDisplay.toUpperCase() == "TRUE") ? true : false);
                    }
                    else
                    {
                        this.nativeDisplay = k.nativeDisplay;
                    }
                }
                if (k.clickSign != /*undefined*/null)
                {
                    this.clickSignConfig = new ClickSignConfig(k.clickSign);
                }
                if (k.companions != /*undefined*/null)
                {
                    this._Str_21117 = new CompanionsConfigGroup(k.companions);
                }
                if (k.allowDomains != /*undefined*/null)
                {
                    this.allowDomains = k.allowDomains;
                }
                if (k.schedule != /*undefined*/null)
                {
                    if (Std.is(k.schedule , Array))
                    {
                        this.schedule = k.schedule;
                    }
                    else
                    {
                        this.schedule = ArrayUtils._Str_8734(k.schedule);
                    }
                }
                if (k.tagParams != /*undefined*/null)
                {
                    this.tagParams = k.tagParams;
                }
                if (k.postMidRollSeekPosition != /*undefined*/null)
                {
                    if (Std.is(k.postMidRollSeekPosition , String))
                    {
                        this._Str_9470 = ASCompat.parseInt(k.postMidRollSeekPosition);
                    }
                    else
                    {
                        this._Str_9470 = ASCompat.toInt(k.postMidRollSeekPosition);
                    }
                }
                if (k.tag != /*undefined*/null)
                {
                    this.tag = k.tag;
                }
                if (k.vpaid != /*undefined*/null)
                {
                    this.vpaid = k.vpaid;
                }
                if (k.holdingClipUrl != /*undefined*/null)
                {
                    this.holdingClipUrl = k.holdingClipUrl;
                }
                if (k.metaData != /*undefined*/null)
                {
                    this._Str_24147(k.metaData);
                }
                if (k.acceptedLinearAdMimeTypes != /*undefined*/null)
                {
                    this.acceptedLinearAdMimeTypes = k.acceptedLinearAdMimeTypes;
                }
                if (k.filterOnLinearAdMimeTypes != /*undefined*/null)
                {
                    if (Std.is(k.filterOnLinearAdMimeTypes , String))
                    {
                        this.filterOnLinearAdMimeTypes = ((k.filterOnLinearAdMimeTypes.toUpperCase() == "TRUE") ? true : false);
                    }
                    else
                    {
                        this.filterOnLinearAdMimeTypes = k.filterOnLinearAdMimeTypes;
                    }
                }
                if (k.shortenLinearAdDurationPercentage != /*undefined*/null)
                {
                    this.shortenLinearAdDurationPercentage = ASCompat.toInt(k.shortenLinearAdDurationPercentage);
                }
                if (k.streamers != /*undefined*/null)
                {
                    if (Std.is(k.streamers , Array))
                    {
                        this.streamers = k.streamers;
                    }
                    else
                    {
                        this.streamers = ArrayUtils._Str_8734(k.streamers);
                    }
                }
                if (k.server != /*undefined*/null)
                {
                    if (k.server.type != /*undefined*/null)
                    {
                        this.adServerConfig = _Str_6024._Str_5664(k.server.type);
                        this.adServerConfig.initialise(k.server);
                    }
                }
                if (k.servers != /*undefined*/null)
                {
                    this._Str_19290 = k.servers;
                }
                this._Str_19888();
            }
            _Str_3144();
        }

        public var overlays(never,set):ASObject;
public function  set_overlays(k:ASObject):ASObject        {
            this._Str_21384 = new OverlaysConfig(k);
return k;
        }

        
        public var _Str_21384(get,set):OverlaysConfig;
public function  set__Str_21384(k:OverlaysConfig):OverlaysConfig        {
            return this._Str_13007 = k;
        }
public function  get__Str_21384():OverlaysConfig
        {
            return this._Str_13007;
        }

        
        public var _Str_5168(get,set):SurveyConfig;
public function  set__Str_5168(k:SurveyConfig):SurveyConfig        {
            return this._Str_17994 = k;
        }
public function  get__Str_5168():SurveyConfig
        {
            return this._Str_17994;
        }

        
        public var shortenLinearAdDurationPercentage(get,set):Int;
public function  set_shortenLinearAdDurationPercentage(k:Int):Int        {
            return this._Str_21804 = k;
        }
public function  get_shortenLinearAdDurationPercentage():Int
        {
            return this._Str_21804;
        }

        
        public var postMidRollSeekPosition(get,set):Int;
public function  set_postMidRollSeekPosition(k:Int):Int        {
            return this._Str_9470 = k;
        }
public function  get_postMidRollSeekPosition():Int
        {
            return this._Str_9470;
        }

        public function postMidRollSeekPositionAsTimestamp():String
        {
            return Timestamp._Str_4110(this._Str_9470);
        }

        public function hasPostMidRollSeekPosition():Bool
        {
            return this._Str_9470 > -1;
        }

        
        public var enforceMidRollPlayback(get,set):Bool;
public function  set_enforceMidRollPlayback(k:Bool):Bool        {
            return this._Str_20228 = k;
        }
public function  get_enforceMidRollPlayback():Bool
        {
            return this._Str_20228;
        }

        
        public var holdingClipUrl(get,set):String;
public function  set_holdingClipUrl(k:String):String        {
            return this.vpaidConfig.holdingClipUrl = k;
        }
public function  get_holdingClipUrl():String
        {
            return this.vpaidConfig.holdingClipUrl;
        }

        
        public var _Str_21117(get,set):CompanionsConfigGroup;
public function  set__Str_21117(k:CompanionsConfigGroup):CompanionsConfigGroup        {
            return this._Str_4936 = k;
        }
public function  get__Str_21117():CompanionsConfigGroup
        {
            return this._Str_4936;
        }

        
        public var skipAd(get,set):SkipAdConfig;
public function  set_skipAd(k:SkipAdConfig):SkipAdConfig        {
            this._Str_6011 = new SkipAdConfig(k);
return k;
        }
public function  get_skipAd():SkipAdConfig
        {
            return this._Str_6011;
        }

        public function isSkipAdButtonEnabled():Bool
        {
            if (this._Str_6011 != null)
            {
                return this._Str_6011.enabled;
            }
            return false;
        }

        public var _Str_25982(get,never):String;
public function  get__Str_25982():String
        {
            if (this._Str_6011 != null)
            {
                return this._Str_6011.image;
            }
            return "not-defined";
        }

        public function _Str_24147(k:ASObject)
        {
            this._Str_19959 = new AdMetaDataConfigGroup(k);
        }

        
        public var _Str_19959(get,set):AdMetaDataConfigGroup;
public function  set__Str_19959(k:AdMetaDataConfigGroup):AdMetaDataConfigGroup        {
            return this._Str_7343 = k;
        }
public function  get__Str_19959():AdMetaDataConfigGroup
        {
            return this._Str_7343;
        }

        public function _Str_19879(k:String="", _arg_2:String="0", _arg_3:Int=-1):String
        {
            if (this._Str_7343 != null)
            {
                return this._Str_7343._Str_19879(k, _arg_2, _arg_3);
            }
            return "";
        }

        public function _Str_19524(k:String="", _arg_2:String="0", _arg_3:Int=-1):String
        {
            if (this._Str_7343 != null)
            {
                return this._Str_7343._Str_19524(k, _arg_2, _arg_3);
            }
            return "";
        }

        function _Str_19888(k:String=null)
        {
            var _local_2:ASObject = null;
            var _local_3:ASObject = null;
            var _local_4 = 0;
            if (this._Str_2621 != null)
            {
                _local_3 = new ASObject();
                _local_4 = 0;
                while (_local_4 < this._Str_2621.length)
                {
                    if (k != null)
                    {
                        this._Str_2621[_local_4].tag = k;
                    }
                    if (this._Str_2621[_local_4].commonAdTag != /*undefined*/null)
                    {
                        if (ASCompat.hasOwnProperty(_local_3, this._Str_2621[_local_4].commonAdTag.uid)== false)
                        {
                            _local_3[this._Str_2621[_local_4].commonAdTag.uid] = _Str_6024._Str_5664(this._Str_2621[_local_4].commonAdTag.server.type);
                            _local_3[this._Str_2621[_local_4].commonAdTag.uid].initialise(this._Str_2621[_local_4].commonAdTag.server);
                        }
                        this._Str_2621[_local_4].server = _local_3[this._Str_2621[_local_4].commonAdTag.uid];
                    }
                    else
                    {
                        if (this._Str_2621[_local_4].tag != /*undefined*/null)
                        {
                            if (this._Str_4857 != null)
                            {
                                this._Str_2621[_local_4].server = {
                                    "type":"direct",
                                    "tag":this._Str_2621[_local_4].tag,
                                    "customProperties":this._Str_4857
                                }
;                            }
                            else
                            {
                                this._Str_2621[_local_4].server = {
                                    "type":"direct",
                                    "tag":this._Str_2621[_local_4].tag
                                }
;                            }
                        }
                        if (this._Str_2621[_local_4].server == /*undefined*/null)
                        {
                            this._Str_2621[_local_4].server = this._Str_25127();
                        }
                        else
                        {
                            _local_2 = this._Str_2621[_local_4].server;
                            if (this._Str_2621[_local_4].server.id == /*undefined*/null)
                            {
                                if (this._Str_2621[_local_4].server.type != /*undefined*/null)
                                {
                                    this._Str_2621[_local_4].server = _Str_6024._Str_5664(this._Str_2621[_local_4].server.type);
                                    if (this._Str_2621[_local_4].server == null)
                                    {
                                        _local_4++;continue;
                                    }
                                }
                                else
                                {
                                    this._Str_2621[_local_4].server = this._Str_23778();
                                }
                            }
                            else
                            {
                                this._Str_2621[_local_4].server = this._Str_22583(this._Str_2621[_local_4].server.id);
                            }
                            if (_local_2 != null)
                            {
                                this._Str_2621[_local_4].server.initialise(_local_2);
                            }
                        }
                    }
                    if (ASCompat.hasOwnProperty(this._Str_2621[_local_4], "encodeVars"))
                    {
                        this._Str_2621[_local_4].server.encodeVars = StringUtils._Str_2810(this._Str_2621[_local_4].encodeVars);
                    }
                    if (this._Str_17325())
                    {
                        this._Str_2621[_local_4].server.acceptedLinearAdMimeTypes = this.acceptedLinearAdMimeTypes;
                    }
_local_4++;
                }
            }
        }

        public function _Str_19379(k:Int)
        {
            var _local_2 = 0;
            while (_local_2 < this._Str_2621.length)
            {
                if (Std.is(this._Str_2621[_local_2].server , AdServerConfig))
                {
                    this._Str_2621[_local_2].server.playerHeight = k;
                }
                _local_2++;
            }
        }

        public function _Str_20939(k:Int)
        {
            var _local_2 = 0;
            while (_local_2 < this._Str_2621.length)
            {
                if (Std.is(this._Str_2621[_local_2].server , AdServerConfig))
                {
                    this._Str_2621[_local_2].server.playerWidth = k;
                }
                _local_2++;
            }
        }

        public var _Str_16561(get,never):Bool;
public function  get__Str_16561():Bool
        {
            if (this._Str_9996 != null)
            {
                return this._Str_9996.enabled;
            }
            return true;
        }

        public var tag(never,set):String;
public function  set_tag(k:String):String        {
            if (this._Str_2621.length == 0)
            {
                this._Str_2621 = [{
                    "position":"pre-roll",
                    "tag":k
                }];
            }
            this._Str_19888(k);
return k;
        }

        public function hasStreamers():Bool
        {
            return !(this._Str_5061 == null);
        }

        
        public var streamers(get,set):Array<ASAny>;
public function  set_streamers(k:Array<ASAny>):Array<ASAny>        {
            var _local_2 = 0;
            this._Str_5061 = new Array<ASAny>();
            if (k != null)
            {
                _local_2 = 0;
                while (_local_2 < k.length)
                {
                    this._Str_5061.push(new AdStreamerConfig(k[_local_2]));
                    _local_2++;
                }
            }
return k;
        }
public function  get_streamers():Array<ASAny>
        {
            return this._Str_5061;
        }

        
        public var adServerConfig(get,set):AdServerConfig;
public function  set_adServerConfig(k:AdServerConfig):AdServerConfig        {
            return this._Str_3384 = k;
        }
public function  get_adServerConfig():AdServerConfig
        {
            if (this._Str_3384 == null)
            {
                if (this._Str_3204 != null)
                {
                    return this._Str_3204[0];
                }
            }
            return this._Str_3384;
        }

        
        public var _Str_19290(get,set):Array<ASAny>;
public function  set__Str_19290(k:Array<ASAny>):Array<ASAny>        {
            var _local_3:AdServerConfig = null;
            this._Str_3204 = new Array<ASAny>();
            var _local_2 = 0;
            while (_local_2 < k.length)
            {
                if (k[_local_2].type != /*undefined*/null)
                {
                    _local_3 = _Str_6024._Str_5664(k[_local_2].type);
                    _local_3.initialise(k[_local_2]);
                    if (this._Str_4857 != null)
                    {
                        _local_3.initialise({"tagParams":this._Str_4857});
                    }
                    this._Str_3204.push(_local_3);
                }
                _local_2++;
            }
return k;
        }
public function  get__Str_19290():Array<ASAny>
        {
            return this._Str_3204;
        }

        public function _Str_25127():AdServerConfig
        {
            var k = 0;
            if (this._Str_3204 != null)
            {
                if (this._Str_3204.length > 0)
                {
                    k = this._Str_19450();
                    if (cast(this._Str_3204[k], AdServerConfig).oneAdPerRequest)
                    {
                        return this._Str_3204[k].clone();
                    }
                    return this._Str_3204[k];
                }
            }
            return new AdServerConfig();
        }

        public function _Str_23778():AdServerConfig
        {
            if (this._Str_3204 != null)
            {
                if (this._Str_3204.length > 0)
                {
                    return this._Str_3204[this._Str_19450()].clone();
                }
            }
            return this._Str_24415();
        }

        public function _Str_24415():AdServerConfig
        {
            if (this._Str_3204 != null)
            {
                if (this._Str_3204.length > 0)
                {
                    return this._Str_3204[0].clone();
                }
            }
            return new AdServerConfig();
        }

        function _Str_19450():Int
        {
            var k = 0;
            if (this._Str_3204 != null)
            {
                if (this._Str_3204.length > 0)
                {
                    k = 0;
                    while (k < this._Str_3204.length)
                    {
                        if (this._Str_3204[k].defaultAdServer)
                        {
                            return k;
                        }
                        k++;
                    }
                }
            }
            return 0;
        }

        public function _Str_22583(k:String):AdServerConfig
        {
            var _local_2 = 0;
            if (this._Str_3204 != null)
            {
                _local_2 = 0;
                while (_local_2 < this._Str_3204.length)
                {
                    if (this._Str_3204[_local_2].matchesId(k))
                    {
                        return this._Str_3204[_local_2];
                    }
                    _local_2++;
                }
            }
            return new AdServerConfig();
        }

        
        public var resetTrackingOnReplay(get,set):Bool;
public function  set_resetTrackingOnReplay(k:Bool):Bool        {
            return this._Str_22194 = k;
        }
public function  get_resetTrackingOnReplay():Bool
        {
            return this._Str_22194;
        }

        
        public var pauseOnClickThrough(get,set):Bool;
public function  set_pauseOnClickThrough(k:Bool):Bool        {
            return this._Str_20727 = k;
        }
public function  get_pauseOnClickThrough():Bool
        {
            return this._Str_20727;
        }

        public function vpaidMaxDurationTimeoutEnabled():Bool
        {
            return this._Str_5258.enableMaxDurationTimeout;
        }

        public var vpaidMaxDurationTimeout(get,never):Int;
public function  get_vpaidMaxDurationTimeout():Int
        {
            return this._Str_5258.maxDurationTimeout;
        }

        
        public var tagParams(get,set):ASObject;
public function  set_tagParams(k:ASObject):ASObject        {
            return this._Str_4857 = k;
        }
public function  get_tagParams():ASObject
        {
            return this._Str_4857;
        }

        public function _Str_26028():Bool
        {
            return !(this._Str_18821 == null);
        }

        
        public var linearScaling(get,set):String;
public function  set_linearScaling(k:String):String        {
            return this._Str_18821 = k;
        }
public function  get_linearScaling():String
        {
            return this._Str_18821;
        }

        
        public var enforceLinearInteractiveAdScaling(get,set):Bool;
public function  set_enforceLinearInteractiveAdScaling(k:Bool):Bool        {
            return this._Str_19748 = k;
        }
public function  get_enforceLinearInteractiveAdScaling():Bool
        {
            return this._Str_19748;
        }

        
        public var enforceLinearVideoAdScaling(get,set):Bool;
public function  set_enforceLinearVideoAdScaling(k:Bool):Bool        {
            return this._Str_20521 = k;
        }
public function  get_enforceLinearVideoAdScaling():Bool
        {
            return this._Str_20521;
        }

        
        public var enforceLinearAdsOnPlaylistSelection(get,set):Bool;
public function  set_enforceLinearAdsOnPlaylistSelection(k:Bool):Bool        {
            return this._Str_19263 = k;
        }
public function  get_enforceLinearAdsOnPlaylistSelection():Bool
        {
            return this._Str_19263;
        }

        public var replayOverlays(get,never):Bool;
public function  get_replayOverlays():Bool
        {
            return this._Str_13007.replay;
        }

        
        public var allowDomains(get,set):String;
public function  set_allowDomains(k:String):String        {
            return this._Str_20654 = k;
        }
public function  get_allowDomains():String
        {
            return this._Str_20654;
        }

        
        public var activelySchedule(get,set):Bool;
public function  set_activelySchedule(k:Bool):Bool        {
            return this._Str_21454 = k;
        }
public function  get_activelySchedule():Bool
        {
            return this._Str_21454;
        }

        public function _Str_8478():Bool
        {
            return this._Str_4936._Str_8478();
        }

        public var companionDivIDs(get,never):Array<ASAny>;
public function  get_companionDivIDs():Array<ASAny>
        {
            return this._Str_4936.companionDivIDs;
        }

        public var displayCompanions(get,never):Bool;
public function  get_displayCompanions():Bool
        {
            return this._Str_4936.displayCompanions;
        }

        public var _Str_7826(get,never):Bool;
public function  get__Str_7826():Bool
        {
            if (this.nativeDisplay == false)
            {
                return true;
            }
            return this._Str_4936.nativeDisplay == false;
        }

        
        public var nativeDisplay(get,set):Bool;
public function  set_nativeDisplay(k:Bool):Bool        {
            return this._Str_10909 = k;
        }
public function  get_nativeDisplay():Bool
        {
            return this._Str_10909;
        }

        public var restoreCompanions(get,never):Bool;
public function  get_restoreCompanions():Bool
        {
            return this._Str_4936.restoreCompanions;
        }

        public var millisecondDelayOnCompanionInjection(get,never):Int;
public function  get_millisecondDelayOnCompanionInjection():Int
        {
            return this._Str_4936.millisecondDelayOnCompanionInjection;
        }

        public function _Str_12146():Bool
        {
            return this._Str_4936._Str_12146();
        }

        public var additionalParamsForSWFCompanions(get,never):Array<ASAny>;
public function  get_additionalParamsForSWFCompanions():Array<ASAny>
        {
            return this._Str_4936.additionalParamsForSWFCompanions;
        }

        public function showNotice():Bool
        {
            if (this._Str_11226 != null)
            {
                return this._Str_11226.show;
            }
            return false;
        }

        
        public var notice(get,set):ASObject;
public function  set_notice(k:ASObject):ASObject        {
            this._Str_11226 = new AdNoticeConfig(k);
return k;
        }
public function  get_notice():ASObject
        {
            return this._Str_11226;
        }

        
        public var rtmpSubscribe(get,set):Bool;
public function  set_rtmpSubscribe(k:Bool):Bool        {
            if (_Str_3337 == null)
            {
                _Str_3337 = new ProvidersConfigGroup();
            }
            return _Str_3337.rtmpSubscribe = k;
        }
public function  get_rtmpSubscribe():Bool
        {
            if (_Str_3337 != null)
            {
                return _Str_3337.rtmpSubscribe;
            }
            return false;
        }

        public function canSkipOnLinearAd():Bool
        {
            return this._Str_6011.enabled;
        }

        public var skipAdConfig(get,never):SkipAdConfig;
public function  get_skipAdConfig():SkipAdConfig
        {
            return this._Str_6011;
        }

        public var vpaid(never,set):ASObject;
public function  set_vpaid(k:ASObject):ASObject        {
            this.vpaidConfig = new VPAIDConfig(k);
return k;
        }

        
        public var vpaidConfig(get,set):VPAIDConfig;
public function  set_vpaidConfig(k:VPAIDConfig):VPAIDConfig        {
            return this._Str_5258 = k;
        }
public function  get_vpaidConfig():VPAIDConfig
        {
            return this._Str_5258;
        }

        function _Str_26090(k:String):Bool
        {
            if (StringUtils._Str_2576(k, "PRE-ROLL"))
            {
                return true;
            }
            if (StringUtils._Str_2576(k, "MID-ROLL"))
            {
                return true;
            }
            if (StringUtils._Str_2576(k, "POST-ROLL"))
            {
                return true;
            }
            return false;
        }

        
        public var schedule(get,set):Array<ASAny>;
public function  set_schedule(schedule:Array<ASAny>):Array<ASAny>        {
var prop:String  = null;            var processedSchedule:Array<ASAny> = null;
            var i = 0;
            var pres:Array<ASAny> = null;
            var mids:Array<ASAny> = null;
            var posts:Array<ASAny> = null;
            var k = 0;
            var commonAdTag:ASObject = null;
            var j = 0;
            var newObject:ASObject = null;
            var prop:String = null;
            if (schedule != null)
            {
                processedSchedule = new Array<ASAny>();
                i = 0;
                while (i < schedule.length)
                {
                    if (ASCompat.hasOwnProperty(schedule[i], "notice"))
                    {
                        if (Std.is(schedule[i].notice , AdNoticeConfig) == false)
                        {
                            schedule[i].notice = new AdNoticeConfig(schedule[i]["notice"]);
                        }
                    }
                    else
                    {
                        schedule[i].notice = this.notice;
                    }
                    if ((ASCompat.hasOwnProperty(schedule[i], "interval") && ASCompat.hasOwnProperty(schedule[i], "repeat")))
                    {
                        if (((schedule[i].interval > 0) && (schedule[i].repeat > 0)))
                        {
                            commonAdTag = null;
                            if ((ASCompat.hasOwnProperty(schedule[i], "oneAdPerRequest") && ASCompat.hasOwnProperty(schedule[i], "tag")))
                            {
                                if (schedule[i].oneAdPerRequest == false)
                                {
                                    commonAdTag = {
                                        "uid":i,
                                        "server":{
                                            "type":"direct",
                                            "tag":schedule[i].tag,
                                            "oneAdPerRequest":false
                                        }
                                    }
;                                }
                            }
                            if (ASCompat.hasOwnProperty(schedule[i], "server"))
                            {
                                if (schedule[i].server != null)
                                {
                                    if (ASCompat.hasOwnProperty(schedule[i].server, "oneAdPerRequest"))
                                    {
                                        if (schedule[i].server.oneAdPerRequest == false)
                                        {
                                            commonAdTag = {
                                                "uid":i,
                                                "server":schedule[i].server
                                            }
;                                            if (commonAdTag.server.type == /*undefined*/null)
                                            {
                                                commonAdTag.server.type = "direct";
                                            }
                                        }
                                    }
                                }
                            }
                            j = 0;
                            while (j < schedule[i].repeat)
                            {
                                newObject = new ASObject();
                                newObject.copyCount = j;
                                newObject.startTime = Timestamp._Str_24782(schedule[i].startTime, ASCompat.toNumber(ASCompat.toNumber(schedule[i].interval) * j));
                                if (commonAdTag != null)
                                {
ASCompat.setDynamicProperty(                                    newObject, "commonAdTag", commonAdTag);
                                }
                                final _iter_:ASAny = schedule[i]; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.___keys())
                                {
prop = _tmp_;
                                    if (commonAdTag != null)
                                    {
                                        if ((((prop == "server") || (prop == "tag")) || (prop == "oneAdPerRequest")))
                                        {
                                            continue;
                                        }
                                    }
                                    if ((((!(prop == "interval")) && (!(prop == "startTime"))) && (!(prop == "repeat"))))
                                    {
ASCompat.setDynamicProperty(                                        newObject, prop, schedule[i][prop]);
                                    }
                                }
                                processedSchedule.push(newObject);
                                j = (j + 1);
                            }
                        }
                    }
                    else
                    {
                        if (ASCompat.hasOwnProperty(schedule[i], "oneAdPerRequest"))
                        {
                            if (ASCompat.hasOwnProperty(schedule[i], "tag"))
                            {
                                schedule[i].server = {
                                    "type":"direct",
                                    "tag":schedule[i].tag,
                                    "oneAdPerRequest":schedule[i].oneAdPerRequest
                                }
;                                Reflect.deleteField(schedule[i], "tag");
                                Reflect.deleteField(schedule[i], "oneAdPerRequest");
                            }
                            else
                            {
                                if (ASCompat.hasOwnProperty(schedule[i], "server"))
                                {
                                    schedule[i].server.oneAdPerRequest = schedule[i].oneAdPerRequest;
                                    Reflect.deleteField(schedule[i], "oneAdPerRequest");
                                }
                            }
                        }
                        processedSchedule.push(schedule[i]);
                    }
                    i = (i + 1);
                }
                pres = new Array<ASAny>();
                mids = new Array<ASAny>();
                posts = new Array<ASAny>();
                k = 0;
                while (k < processedSchedule.length)
                {
                    if (StringUtils._Str_2576(processedSchedule[k].position, "pre-roll"))
                    {
                        pres.push(processedSchedule[k]);
                    }
                    else
                    {
                        if (StringUtils._Str_2576(processedSchedule[k].position, "post-roll"))
                        {
                            posts.push(processedSchedule[k]);
                        }
                        else
                        {
                            mids.push(processedSchedule[k]);
                        }
                    }
                    k = (k + 1);
                }
                ASCompat.ASArray.sort(mids, function (k:ASObject, _arg_2:ASObject):Float
                {
                    var _local_3 = 0;
                    var _local_4 = 0;
                    if (k.startTime != /*undefined*/null)
                    {
                        if (_arg_2.startTime != /*undefined*/null)
                        {
                            _local_3 = Timestamp.timestampToSeconds(k.startTime);
                            _local_4 = Timestamp.timestampToSeconds(_arg_2.startTime);
                            if (_local_3 > _local_4)
                            {
                                return 1;
                            }
                            if (_local_3 < _local_4)
                            {
                                return -1;
                            }
                            return 0;
                        }
                        return -1;
                    }
                    return -1;
                });
                this._Str_2621 = pres;
                this._Str_2621 = this._Str_2621.concat(mids);
                this._Str_2621 = this._Str_2621.concat(posts);
            }
            else
            {
                this._Str_2621 = null;
            }
return schedule;
        }
public function  get_schedule():Array<ASAny>
        {
            return this._Str_2621;
        }

        
        public var acceptedLinearAdMimeTypes(get,set):Array<ASAny>;
public function  set_acceptedLinearAdMimeTypes(k:Array<ASAny>):Array<ASAny>        {
            return this._Str_4352 = k;
        }
public function  get_acceptedLinearAdMimeTypes():Array<ASAny>
        {
            return this._Str_4352;
        }

        
        public var filterOnLinearAdMimeTypes(get,set):Bool;
public function  set_filterOnLinearAdMimeTypes(k:Bool):Bool        {
            return this._Str_11973 = k;
        }
public function  get_filterOnLinearAdMimeTypes():Bool
        {
            return this._Str_11973;
        }

        public function _Str_17325():Bool
        {
            if (this._Str_4352 != null)
            {
                return this._Str_4352.length > 0;
            }
            return false;
        }

        
        public var visuallyCueLinearAdClickThrough(get,set):Bool;
public function  set_visuallyCueLinearAdClickThrough(k:Bool):Bool        {
            return this._Str_20374 = k;
        }
public function  get_visuallyCueLinearAdClickThrough():Bool
        {
            return this._Str_20374;
        }

        
        public var clickSignConfig(get,set):ClickSignConfig;
public function  set_clickSignConfig(k:ClickSignConfig):ClickSignConfig        {
            return this._Str_9996 = k;
        }
public function  get_clickSignConfig():ClickSignConfig
        {
            return this._Str_9996;
        }
    }

