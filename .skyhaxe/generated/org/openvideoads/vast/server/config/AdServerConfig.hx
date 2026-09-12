package org.openvideoads.vast.server.config
;
    import org.openvideoads.base.Debuggable;
    import org.openvideoads.vast.server.request.direct._Str_4664;
    import org.openvideoads.util.StringUtils;

     class AdServerConfig extends Debuggable 
    {
        var _id:String = "";
        var _Str_5295:String = "direct";
        var _Str_7775:Bool = false;
        var _Str_14740:Bool = false;
        var _Str_3753:CustomProperties;
        var _Str_6748:String = null;
        var _Str_12926:String = "http://localhost";
        var _Str_15101:Bool = false;
        var _Str_5662:Array<ASAny> = null;
        var _Str_15247:FailoverConditionsConfig = null;
        var _Str_3096:String = null;
        var _Str_5101:Bool = false;
        var _Str_26073:Bool = false;
        var _Str_14150:Bool = false;
        var _Str_11242:Int = -1;
        var _Str_15694:String = "3";
        var _Str_10161:Int = -1;
        var _Str_12360:Int = -1;
        var _Str_15767:String = null;
        var _Str_15081:String = null;
        var _Str_14580:String = null;
        var _Str_18886:String = null;
        var _Str_14298:String = "vast1";
        var _Str_14994:String = null;
        var _Str_15423:String = null;
        var _Str_15473:String = null;
        var _Str_14735:String = null;
        var _Str_13316:String = null;
        var _Str_13878:String = null;
        var _Str_9744:Bool = false;
        var _Str_20883:Bool = false;
        var _Str_4857:ASObject = null;
        var _Str_11530:Int = -1;
        var _Str_17573:Bool = true;
        var _Str_4352:Array<ASAny>;
        var _Str_11973:Bool = false;
        var _Str_22385:Array<ASAny>;
        var _Str_26439:Bool = false;
        var _Str_16412:Bool = false;
        var _Str_3676:Array<ASAny>;

        public function new(k:String=null, _arg_2:ASObject=null)
        {
            this._Str_4352 = new Array<ASAny>();
            this._Str_22385 = new Array<ASAny>();
            this._Str_3676 = new Array<ASAny>();
            super();
            if (k != null)
            {
                this._Str_5295 = k;
            }
            this._Str_3753 = this.defaultCustomProperties;
            this.initialise(_arg_2);
        }

        public function initialise(k:ASObject)
        {
            var _local_2 = 0;
            var _local_3:AdServerConfig = null;
            if (k != null)
            {
                if (k.id != /*undefined*/null)
                {
                    this._id = k.id;
                }
                if (k.type != /*undefined*/null)
                {
                    this._Str_5295 = k.type;
                }
                if (k.apiAddress != /*undefined*/null)
                {
                    this._Str_12926 = k.apiAddress;
                }
                if (k.requestTemplate != /*undefined*/null)
                {
                    this._Str_6748 = k.requestTemplate;
                }
                if (k.allowAdRepetition != /*undefined*/null)
                {
                    this._Str_14740 = k.allowAdRepetition;
                }
                if (k.ensureSingleAdUnitRecordedPerInlineAd != /*undefined*/null)
                {
                    this._Str_17573 = k.ensureSingleAdUnitRecordedPerInlineAd;
                }
                if (k.oneAdPerRequest != /*undefined*/null)
                {
                    this._Str_7775 = k.oneAdPerRequest;
                }
                if (k.customProperties != /*undefined*/null)
                {
                    this._Str_3753._Str_17005(k.customProperties);
                }
                if (k.tagParams != /*undefined*/null)
                {
                    this._Str_3753._Str_17005(k.tagParams);
                    this._Str_4857 = k.tagParams;
                }
                if (k.defaultAdServer != /*undefined*/null)
                {
                    this._Str_15101 = k.defaultAdServer;
                }
                if (k.tag != /*undefined*/null)
                {
                    this._Str_3096 = k.tag;
                }
                if (k.allowVPAID != /*undefined*/null)
                {
                    this._Str_14150 = k.allowVPAID;
                }
                if (k.asVersion != /*undefined*/null)
                {
                    this._Str_15694 = k.asVersion;
                }
                if (k.timeoutInSeconds != /*undefined*/null)
                {
                    if (Std.is(k.timeoutInSeconds , String))
                    {
                        this._Str_11530 = ASCompat.toInt(k.timeoutInSeconds);
                    }
                    else
                    {
                        this._Str_11530 = ASCompat.toInt(k.timeoutInSeconds);
                    }
                }
                if (k.maxDuration != /*undefined*/null)
                {
                    if (Std.is(k.maxDuration , String))
                    {
                        this._Str_11242 = ASCompat.toInt(k.maxDuration);
                    }
                    else
                    {
                        this._Str_11242 = ASCompat.toInt(k.maxDuration);
                    }
                }
                if (k.playerWidth != /*undefined*/null)
                {
                    if (Std.is(k.playerWidth , String))
                    {
                        this._Str_10161 = ASCompat.toInt(k.playerWidth);
                    }
                    else
                    {
                        this._Str_10161 = ASCompat.toInt(k.playerWidth);
                    }
                }
                if (k.playerHeight != /*undefined*/null)
                {
                    if (Std.is(k.playerHeight , String))
                    {
                        this._Str_12360 = ASCompat.toInt(k.playerHeight);
                    }
                    else
                    {
                        this._Str_12360 = ASCompat.toInt(k.playerHeight);
                    }
                }
                if (k.mediaUrl != /*undefined*/null)
                {
                    this._Str_15767 = k.mediaUrl;
                }
                if (k.pageStreamUrl != /*undefined*/null)
                {
                    this._Str_15081 = k.pageStreamUrl;
                }
                if (k.pageUrl != /*undefined*/null)
                {
                    this._Str_14580 = k.pageUrl;
                }
                if (k.format != /*undefined*/null)
                {
                    this._Str_14298 = k.format;
                }
                if (k.partnerId != /*undefined*/null)
                {
                    this._Str_14994 = k.partnerId;
                }
                if (k.mediaId != /*undefined*/null)
                {
                    this._Str_15423 = k.mediaId;
                }
                if (k.mediaTitle != /*undefined*/null)
                {
                    this._Str_15473 = k.mediaTitle;
                }
                if (k.mediaDescription != /*undefined*/null)
                {
                    this._Str_14735 = k.mediaDescription;
                }
                if (k.mediaCategories != /*undefined*/null)
                {
                    this._Str_13316 = k.mediaCategories;
                }
                if (k.mediaKeywords != /*undefined*/null)
                {
                    this._Str_13878 = k.mediaKeywords;
                }
                if (k.forceImpressionServing != /*undefined*/null)
                {
                    this.forceImpressionServing = k.forceImpressionServing;
                }
                if (k.addCacheBuster != /*undefined*/null)
                {
                    this.addCacheBuster = k.addCacheBuster;
                }
                if (k.parseWrappedAdTags != /*undefined*/null)
                {
                    this.parseWrappedAdTags = k.parseWrappedAdTags;
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
                if (k.encodeVars != /*undefined*/null)
                {
                    if (Std.is(k.encodeVars , String))
                    {
                        this.encodeVars = ((k.encodeVars.toUpperCase() == "TRUE") ? true : false);
                    }
                    else
                    {
                        this.encodeVars = k.encodeVars;
                    }
                }
                if (k.failoverConditions != /*undefined*/null)
                {
                    this._Str_15247 = new FailoverConditionsConfig(k.failoverConditions);
                }
                if (k.failoverServers != /*undefined*/null)
                {
                    if (Std.is(k.failoverServers , Array))
                    {
                        this._Str_5662 = new Array<ASAny>();
                        _local_2 = 0;
                        while (_local_2 < k.failoverServers.length)
                        {
                            if (Std.is(k.failoverServers[_local_2] , AdServerConfig))
                            {
                                this._Str_5662.push(k.failoverServers[_local_2]);
                            }
                            else
                            {
                                if (k.failoverServers[_local_2].type != /*undefined*/null)
                                {
                                    _local_3 = _Str_6024._Str_5664(k.failoverServers[_local_2].type);
                                    _local_3.initialise(k.failoverServers[_local_2]);
                                }
                                else
                                {
                                    _local_3 = new _Str_4664(k.failoverServers[_local_2]);
                                }
                                this._Str_5662.push(_local_3);
                            }
                            _local_2++;
                        }
                    }
                }
                if (k.transformers != /*undefined*/null)
                {
                    if (Std.is(k.transformers , String))
                    {
                        this._Str_3676 = [k.transformers];
                    }
                    else
                    {
                        if (Std.is(k.transformers , Array))
                        {
                            this._Str_3676 = k.transformers;
                        }
                    }
                }
            }
        }

        
        public var ensureSingleAdUnitRecordedPerInlineAd(get,set):Bool;
public function  set_ensureSingleAdUnitRecordedPerInlineAd(k:Bool):Bool        {
            return this._Str_17573 = k;
        }
public function  get_ensureSingleAdUnitRecordedPerInlineAd():Bool
        {
            return this._Str_17573;
        }

        
        public var encodeVars(get,set):Bool;
public function  set_encodeVars(k:Bool):Bool        {
            return this._Str_16412 = k;
        }
public function  get_encodeVars():Bool
        {
            return this._Str_16412;
        }

        public function _Str_25364():Bool
        {
            if (this._Str_3676 != null)
            {
                return this._Str_3676.length > 0;
            }
            return false;
        }

        
        public var transformers(get,set):Array<ASAny>;
public function  set_transformers(k:Array<ASAny>):Array<ASAny>        {
            return this._Str_3676 = k;
        }
public function  get_transformers():Array<ASAny>
        {
            return this._Str_3676;
        }

        
        public var timeoutInSeconds(get,set):Int;
public function  set_timeoutInSeconds(k:Int):Int        {
            return this._Str_11530 = k;
        }
public function  get_timeoutInSeconds():Int
        {
            return this._Str_11530;
        }

        var defaultTemplate(get,never):String;
function  get_defaultTemplate():String
        {
            return "";
        }

        var defaultCustomProperties(get,never):CustomProperties;
function  get_defaultCustomProperties():CustomProperties
        {
            return new CustomProperties();
        }

        
        public var template(get,set):String;
public function  get_template():String
        {
            if (this._Str_6748 != null)
            {
                return this._Str_6748;
            }
            return this.defaultTemplate;
        }
public function  set_template(k:String):String        {
            return this._Str_6748 = k;
        }

        
        public var apiServerAddress(get,set):String;
public function  set_apiServerAddress(k:String):String        {
            return this._Str_12926 = k;
        }
public function  get_apiServerAddress():String
        {
            return this._Str_12926;
        }

        
        public var apiAddress(get,set):String;
public function  set_apiAddress(k:String):String        {
            return this.apiServerAddress = k;
        }
public function  get_apiAddress():String
        {
            return this.apiServerAddress;
        }

        
        public var addCacheBuster(get,set):Bool;
public function  set_addCacheBuster(k:Bool):Bool        {
            return this._Str_9744 = k;
        }
public function  get_addCacheBuster():Bool
        {
            return this._Str_9744;
        }

        
        public var parseWrappedAdTags(get,set):Bool;
public function  set_parseWrappedAdTags(k:Bool):Bool        {
            return this._Str_20883 = k;
        }
public function  get_parseWrappedAdTags():Bool
        {
            return this._Str_20883;
        }

        
        public var failoverServers(get,set):Array<ASAny>;
public function  set_failoverServers(k:Array<ASAny>):Array<ASAny>        {
            return this._Str_5662 = k;
        }
public function  get_failoverServers():Array<ASAny>
        {
            return this._Str_5662;
        }

        public function _Str_23936():Bool
        {
            return this._Str_14867 > 0;
        }

        public var _Str_14867(get,never):Int;
public function  get__Str_14867():Int
        {
            if (this._Str_5662 != null)
            {
                return this._Str_5662.length;
            }
            return 0;
        }

        public function _Str_24012(k:Int):AdServerConfig
        {
            if (((this._Str_14867 > k) && (this._Str_14867 > 0)))
            {
                return this._Str_5662[k];
            }
            return null;
        }

        
        public var failoverConditions(get,set):FailoverConditionsConfig;
public function  set_failoverConditions(k:FailoverConditionsConfig):FailoverConditionsConfig        {
            return this._Str_15247 = k;
        }
public function  get_failoverConditions():FailoverConditionsConfig
        {
            return this._Str_15247;
        }

        
        public var forceImpressionServing(get,set):Bool;
public function  set_forceImpressionServing(k:Bool):Bool        {
            return this._Str_5101 = k;
        }
public function  get_forceImpressionServing():Bool
        {
            return this._Str_5101;
        }

        public function _Str_22972():Bool
        {
            return !(this._Str_4857 == null);
        }

        
        public var customProperties(get,set):CustomProperties;
public function  set_customProperties(k:CustomProperties):CustomProperties        {
            return this._Str_3753 = k;
        }
public function  get_customProperties():CustomProperties
        {
            return this._Str_3753;
        }

        
        public var oneAdPerRequest(get,set):Bool;
public function  set_oneAdPerRequest(k:Bool):Bool        {
            return this._Str_7775 = k;
        }
public function  get_oneAdPerRequest():Bool
        {
            return this._Str_7775;
        }

        
        public var defaultAdServer(get,set):Bool;
public function  set_defaultAdServer(k:Bool):Bool        {
            return this._Str_15101 = k;
        }
public function  get_defaultAdServer():Bool
        {
            return this._Str_15101;
        }

        
        public var allowAdRepetition(get,set):Bool;
public function  set_allowAdRepetition(k:Bool):Bool        {
            return this._Str_14740 = k;
        }
public function  get_allowAdRepetition():Bool
        {
            return this._Str_14740;
        }

        
        public var serverType(get,set):String;
public function  set_serverType(k:String):String        {
            return this._Str_5295 = k;
        }
public function  get_serverType():String
        {
            return this._Str_5295;
        }

        public function _Str_23380():String
        {
            return this.serverType + (this.oneAdPerRequest ? "-single" : ("-multiple-" + _uid));
        }

        
        public var type(get,set):String;
public function  set_type(k:String):String        {
            return this.serverType = k;
        }
public function  get_type():String
        {
            return this.serverType;
        }

        
        public var requestTemplate(get,set):String;
public function  set_requestTemplate(k:String):String        {
            return this._Str_6748 = k;
        }
public function  get_requestTemplate():String
        {
            return this._Str_6748;
        }

        
        public var tag(get,set):String;
public function  set_tag(k:String):String        {
            return this._Str_3096 = k;
        }
public function  get_tag():String
        {
            return this._Str_3096;
        }

        
        public var tagParams(get,set):ASObject;
public function  set_tagParams(k:ASObject):ASObject        {
            return this._Str_4857 = k;
        }
public function  get_tagParams():ASObject
        {
            return this._Str_4857;
        }

        
        public var allowVPAID(get,set):Bool;
public function  set_allowVPAID(k:Bool):Bool        {
            return this._Str_14150 = k;
        }
public function  get_allowVPAID():Bool
        {
            return this._Str_14150;
        }

        
        public var maxDuration(get,set):Int;
public function  set_maxDuration(k:Int):Int        {
            return this._Str_11242 = k;
        }
public function  get_maxDuration():Int
        {
            return this._Str_11242;
        }

        
        public var asVersion(get,set):String;
public function  set_asVersion(k:String):String        {
            return this._Str_15694 = k;
        }
public function  get_asVersion():String
        {
            return this._Str_15694;
        }

        
        public var playerWidth(get,set):Int;
public function  set_playerWidth(k:Int):Int        {
            return this._Str_10161 = k;
        }
public function  get_playerWidth():Int
        {
            return this._Str_10161;
        }

        
        public var playerHeight(get,set):Int;
public function  set_playerHeight(k:Int):Int        {
            return this._Str_12360 = k;
        }
public function  get_playerHeight():Int
        {
            return this._Str_12360;
        }

        
        public var mediaUrl(get,set):String;
public function  set_mediaUrl(k:String):String        {
            return this._Str_15767 = k;
        }
public function  get_mediaUrl():String
        {
            return this._Str_15767;
        }

        
        public var pageStreamUrl(get,set):String;
public function  set_pageStreamUrl(k:String):String        {
            return this._Str_15081 = k;
        }
public function  get_pageStreamUrl():String
        {
            return this._Str_15081;
        }

        
        public var streamUrl(get,set):String;
public function  set_streamUrl(k:String):String        {
            return this._Str_18886 = k;
        }
public function  get_streamUrl():String
        {
            return this._Str_18886;
        }

        
        public var pageUrl(get,set):String;
public function  set_pageUrl(k:String):String        {
            return this._Str_14580 = k;
        }
public function  get_pageUrl():String
        {
            return this._Str_14580;
        }

        
        public var format(get,set):String;
public function  set_format(k:String):String        {
            return this._Str_14298 = k;
        }
public function  get_format():String
        {
            return this._Str_14298;
        }

        public function matchesId(k:String):Bool
        {
            if (this._id == null)
            {
                return k == null;
            }
            if (k == null)
            {
                return false;
            }
            return this._id.toUpperCase() == k.toUpperCase();
        }

        
        public var id(get,set):String;
public function  set_id(k:String):String        {
            return this._id = k;
        }
public function  get_id():String
        {
            return this._id;
        }

        
        public var partnerId(get,set):String;
public function  set_partnerId(k:String):String        {
            return this._Str_14994 = k;
        }
public function  get_partnerId():String
        {
            return this._Str_14994;
        }

        
        public var mediaId(get,set):String;
public function  set_mediaId(k:String):String        {
            return this._Str_15423 = k;
        }
public function  get_mediaId():String
        {
            return this._Str_15423;
        }

        
        public var mediaTitle(get,set):String;
public function  set_mediaTitle(k:String):String        {
            return this._Str_15473 = k;
        }
public function  get_mediaTitle():String
        {
            return this._Str_15473;
        }

        
        public var mediaDescription(get,set):String;
public function  set_mediaDescription(k:String):String        {
            return this._Str_14735 = k;
        }
public function  get_mediaDescription():String
        {
            return this._Str_14735;
        }

        
        public var mediaCategories(get,set):String;
public function  set_mediaCategories(k:String):String        {
            return this._Str_13316 = k;
        }
public function  get_mediaCategories():String
        {
            return this._Str_13316;
        }

        
        public var mediaKeywords(get,set):String;
public function  set_mediaKeywords(k:String):String        {
            return this._Str_13878 = k;
        }
public function  get_mediaKeywords():String
        {
            return this._Str_13878;
        }

        
        public var acceptedLinearAdMimeTypes(get,set):Array<ASAny>;
public function  set_acceptedLinearAdMimeTypes(k:Array<ASAny>):Array<ASAny>        {
            return this._Str_4352 = k;
        }
public function  get_acceptedLinearAdMimeTypes():Array<ASAny>
        {
            return this._Str_4352;
        }

        public function _Str_17325():Bool
        {
            if (this._Str_4352 != null)
            {
                return this._Str_4352.length > 0;
            }
            return false;
        }

        public function isAcceptedLinearAdMimeType(k:String):Bool
        {
            if (this._Str_17325() == false)
            {
                return true;
            }
            var _local_2 = 0;
            while (_local_2 < this._Str_4352.length)
            {
                if (StringUtils._Str_2576(this._Str_4352[_local_2], k))
                {
                    return true;
                }
                _local_2++;
            }
            return false;
        }

        
        public var filterOnLinearAdMimeTypes(get,set):Bool;
public function  set_filterOnLinearAdMimeTypes(k:Bool):Bool        {
            return this._Str_11973 = k;
        }
public function  get_filterOnLinearAdMimeTypes():Bool
        {
            return this._Str_11973;
        }

        public function clone():AdServerConfig
        {
            var k= _Str_6024._Str_5664(this._Str_5295);
            k.allowAdRepetition = this._Str_14740;
            k.serverType = this._Str_5295;
            k.oneAdPerRequest = this._Str_7775;
            k.customProperties = this._Str_3753;
            k.template = this._Str_6748;
            k.apiServerAddress = this._Str_12926;
            k.defaultAdServer = this._Str_15101;
            k.forceImpressionServing = this._Str_5101;
            k.requestTemplate = this._Str_6748;
            k.failoverServers = this._Str_5662;
            k.failoverConditions = this._Str_15247;
            k.tag = this._Str_3096;
            k.forceImpressionServing = this._Str_5101;
            k.allowVPAID = this._Str_14150;
            k.maxDuration = this._Str_11242;
            k.asVersion = this._Str_15694;
            k.playerWidth = this._Str_10161;
            k.playerHeight = this._Str_12360;
            k.mediaUrl = this._Str_15767;
            k.pageStreamUrl = this._Str_15081;
            k.pageUrl = this._Str_14580;
            k.streamUrl = this._Str_18886;
            k.format = this._Str_14298;
            k.partnerId = this._Str_14994;
            k.mediaId = this._Str_15423;
            k.mediaTitle = this._Str_15473;
            k.mediaDescription = this._Str_14735;
            k.mediaCategories = this._Str_13316;
            k.mediaKeywords = this._Str_13878;
            k.addCacheBuster = this._Str_9744;
            k.tagParams = this._Str_4857;
            k.timeoutInSeconds = this._Str_11530;
            k.encodeVars = this._Str_16412;
            return k;
        }
    }

