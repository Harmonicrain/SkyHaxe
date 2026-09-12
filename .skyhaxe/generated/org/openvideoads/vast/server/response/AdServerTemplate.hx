package org.openvideoads.vast.server.response
;
    import org.openvideoads.base.Debuggable;
    import org.openvideoads.util.TransformingLoader;
    import org.openvideoads.vast.server.request.AdServerRequest;
    import org.openvideoads.vast.server.config.AdServerConfig;
    import org.openvideoads.util.StringUtils;
    import org.openvideoads.util.TimedTransformingLoader;
    import flash.events.Event;
    import flash.events.ErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.events.IOErrorEvent;
    import org.openvideoads.events._Str_5692;
    import flash.net.URLRequest;
    import org.openvideoads.vast.analytics._Str_2408;
    import org.openvideoads.vast.model.VideoAd;
    import flash.events.*;

     class AdServerTemplate extends Debuggable 
    {
        var _Str_17167:Bool = false;
        var _Str_5528:Array<ASAny> = null;
        var _Str_2459:_Str_3802 = null;
        var _Str_6188:String = "";
        var _Str_2518:Array<ASAny>;
        var _Str_8445:Bool = false;
        var _Str_3081:TransformingLoader = null;
        var _Str_6552:Array<ASAny>;
        var _Str_3439:AdServerRequest = null;
        var _Str_10889:Bool = false;
        var _Str_3507:AdServerRequest = null;
        var _Str_5101:Bool = false;

        public function new(k:_Str_3802=null, _arg_2:AdServerRequest=null, _arg_3:Bool=false, _arg_4:Array<ASAny>=null)
        {
            this._Str_2518 = new Array<ASAny>();
            this._Str_6552 = new Array<ASAny>();
            super();
            this._Str_17167 = _arg_3;
            this._Str_5528 = _arg_4;
            if (k != null)
            {
                this._Str_2459 = k;
            }
            if (_arg_2 != null)
            {
                this.load(_arg_2);
            }
        }

        public function load(k:AdServerRequest, _arg_2:Bool=false)
        {
        }

        public function unload()
        {
            if (this._Str_3081 != null)
            {
                this._Str_3081.close();
            }
        }

        public function _Str_24781()
        {
            this._Str_2518 = new Array<ASAny>();
        }

        
        public var isMaster(get,set):Bool;
public function  set_isMaster(k:Bool):Bool        {
            return this._Str_10889 = k;
        }
public function  get_isMaster():Bool
        {
            return this._Str_10889;
        }

        
        public var _Str_17208(get,set):AdServerRequest;
public function  set__Str_17208(k:AdServerRequest):AdServerRequest        {
            this._Str_3439 = k;
            if (this._Str_3439 != null)
            {
                this._Str_5101 = this._Str_3439.forceImpressionServing();
            }
return k;
        }
public function  get__Str_17208():AdServerRequest
        {
            return this._Str_3439;
        }

        function _Str_5664():AdServerConfig
        {
            if (this._Str_3439 != null)
            {
                return this._Str_3439.config;
            }
            return null;
        }

        function _Str_12713(k:String):Bool
        {
            if (this._Str_3439 != null)
            {
                if (this._Str_3439.config != null)
                {
                    return this._Str_3439.config.isAcceptedLinearAdMimeType(k);
                }
            }
            return true;
        }

        function _Str_26123():Array<ASAny>
        {
            if (this._Str_3439 != null)
            {
                if (this._Str_3439.config != null)
                {
                    return this._Str_3439.config.acceptedLinearAdMimeTypes;
                }
            }
            return null;
        }

        public var forceImpressionServing(get,never):Bool;
public function  get_forceImpressionServing():Bool
        {
            return this._Str_5101;
        }

        function _Str_14997():Bool
        {
            if (this._Str_3439 != null)
            {
                return this._Str_3439._Str_14997();
            }
            return true;
        }

        function _Str_13492():Bool
        {
            return this._Str_17167;
        }

        function getReplacementAdId(k:String):String
        {
            return null;
        }

        function _Str_23772(k:Array<ASAny>):Array<ASAny>
        {
            var _local_2 = 0;
            var _local_3:String = null;
            if (k != null)
            {
                _local_2 = 0;
                while (_local_2 < k.length)
                {
                    _local_3 = this.getReplacementAdId(k[_local_2].adType);
                    if (_local_3 != null)
                    {
                        k[_local_2].id = _local_3;
                    }
                    _local_2++;
                }
            }
            return k;
        }

        function _Str_23044()
        {
            var k:ASObject = null;
            if (this._Str_5528 != null)
            {
                final _iter_ = this._Str_5528; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
k  = _tmp_;
                    k.assigned = false;
                }
            }
        }

        public function _Str_18666():AdServerConfig
        {
            if (this._Str_3439 != null)
            {
                return this._Str_3439.config;
            }
            return null;
        }

        public function _Str_15107(k:String)
        {
            this._Str_6552.push(k);
        }

        public function _Str_12680(k:String)
        {
            var _local_2= this._Str_6552.indexOf(k);
            if (((_local_2 > -1) && (_local_2 < this._Str_6552.length)))
            {
                this._Str_6552[_local_2] = null;
            }
        }

        function _Str_15072():Bool
        {
            var k = 0;
            if (this._Str_6552.length > 0)
            {
                k = 0;
                while (k < this._Str_6552.length)
                {
                    if (this._Str_6552[k] != null)
                    {
                        return false;
                    }
                    k++;
                }
            }
            return true;
        }

        function loadTemplateData(k:AdServerRequest)
        {
            var _local_2:String = null;
            if (k != null)
            {
                this._Str_3507 = k;
                _local_2 = this._Str_3507.formRequest();
                if (StringUtils.isEmpty(_local_2) == false)
                {
                    if (this._Str_2459 != null)
                    {
                        this._Str_2459.onAdCallStarted(k);
                    }
                    this._Str_3081 = new TimedTransformingLoader((k.timeoutInSeconds * 1000));
                    if (k._Str_22402())
                    {
                        this._Str_3081.transformers = k.config.transformers;
                    }
                    this._Str_3081.addEventListener(Event.COMPLETE, (this.templateLoaded : ASAny));
                    this._Str_3081.addEventListener(ErrorEvent.ERROR, (this.errorHandler : ASAny));
                    this._Str_3081.addEventListener(SecurityErrorEvent.SECURITY_ERROR, (this.errorHandler : ASAny));
                    this._Str_3081.addEventListener(IOErrorEvent.IO_ERROR, (this.errorHandler : ASAny));
                    this._Str_3081.addEventListener(_Str_5692._Str_5406, (this.timeoutHandler : ASAny));
                    this._Str_3081.load(new URLRequest(_local_2));
                    if (this._Str_2459 != null)
                    {
                        if (this._Str_2459.analyticsProcessor != null)
                        {
                            this._Str_2459.analyticsProcessor._Str_7633(_Str_2408.FIRED, this._Str_3507, this._Str_3507.isWrapped());
                        }
                    }
                }
                else
                {
                    this.errorHandler(new Event("Empty ad tag - ignored"));
                }
            }
        }

        function _Str_17582()
        {
            if (this._Str_2459 != null)
            {
                if (((!(this._Str_2459.analyticsProcessor == null)) && (!(this._Str_3507 == null))))
                {
                    this._Str_2459.analyticsProcessor._Str_7633(_Str_2408.COMPLETE, this._Str_3507, this._Str_3507.isWrapped());
                }
            }
        }

        function templateLoaded(k:Event)
        {
            this._Str_17582();
            this._Str_6919(_uid);
        }

        function errorHandler(k:Event)
        {
            this._Str_6067(_uid, k);
        }

        function timeoutHandler(k:Event)
        {
            this._Str_8677(_uid, k);
        }

        public function _Str_22097():Bool
        {
            if (this._Str_3439 != null)
            {
                return this._Str_3439._Str_19881();
            }
            return false;
        }

        function _Str_12764():Bool
        {
            return (this.isMaster && (this.hasAds() == false)) && this._Str_22097();
        }

        public function _Str_13744()
        {
            if (this._Str_3081 != null)
            {
                try
                {
                    this._Str_3081.close();
                    this._Str_3081 = null;
                }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                 {
                }
 }            }
        }

        public function _Str_6919(k:String)
        {
            if (this._Str_2459 != null)
            {
                this._Str_2459.onAdCallComplete(this._Str_3507, this.hasAds());
            }
            this._Str_13744();
            this._Str_12680(k);
            if (this._Str_15072())
            {
                if (this._Str_12764())
                {
                    this._Str_10465();
                }
                else
                {
                    if (this._Str_2459 != null)
                    {
                        this._Str_2459.onTemplateLoaded(this);
                    }
                }
            }
        }

        public function _Str_6067(k:String, _arg_2:Event)
        {
            if (this._Str_2459 != null)
            {
                this._Str_2459.onAdCallComplete(this._Str_3507, false);
                if (((!(this._Str_2459.analyticsProcessor == null)) && (!(this._Str_3507 == null))))
                {
                    this._Str_2459.analyticsProcessor._Str_7633(_Str_2408.ERROR, this._Str_3507, this._Str_3507.isWrapped(), _arg_2.toString());
                }
            }
            this._Str_13744();
            this._Str_12680(k);
            if (this._Str_15072())
            {
                if (this._Str_12764())
                {
                    this._Str_10465();
                }
                else
                {
                    if (this._Str_2459 != null)
                    {
                        this._Str_2459.onTemplateLoadError(_arg_2);
                    }
                }
            }
        }

        public function _Str_8677(k:String, _arg_2:Event)
        {
            if (this._Str_2459 != null)
            {
                this._Str_2459.onAdCallComplete(this._Str_3507, false);
                if (((!(this._Str_2459.analyticsProcessor == null)) && (!(this._Str_3507 == null))))
                {
                    this._Str_2459.analyticsProcessor._Str_7633(_Str_2408.TIMEOUT, this._Str_3507, this._Str_3507.isWrapped());
                }
            }
            this._Str_13744();
            this._Str_12680(k);
            if (this._Str_15072())
            {
                if (this._Str_12764())
                {
                    this._Str_10465();
                }
                else
                {
                    if (this._Str_2459 != null)
                    {
                        this._Str_2459._Str_5807(_arg_2);
                    }
                }
            }
        }

        public function _Str_16343(k:String, _arg_2:Event)
        {
            if (this._Str_2459 != null)
            {
                if (((!(this._Str_2459.analyticsProcessor == null)) && (!(this._Str_3507 == null))))
                {
                    this._Str_2459.analyticsProcessor._Str_7633(_Str_2408.DEFERRED, this._Str_3507, this._Str_3507.isWrapped());
                }
            }
            this._Str_13744();
            this._Str_12680(k);
            if (this._Str_15072())
            {
                if (this._Str_12764())
                {
                    this._Str_10465();
                }
                else
                {
                    if (this._Str_2459 != null)
                    {
                        this._Str_2459._Str_5916(_arg_2);
                    }
                }
            }
        }

        public function _Str_10465()
        {
            var k= this._Str_3439._Str_25223();
            if (k != null)
            {
                this._Str_2518 = new Array<ASAny>();
                if (this._Str_2459 != null)
                {
                    this._Str_2459.onAdCallFailover(this._Str_3439, k);
                    if (((!(this._Str_2459.analyticsProcessor == null)) && (!(this._Str_3507 == null))))
                    {
                        this._Str_2459.analyticsProcessor._Str_7633(_Str_2408.FAILOVER, k, k.isWrapped());
                    }
                }
                this._Str_17167 = k._Str_20400;
                this._Str_23044();
                this.load(k, true);
            }
            else
            {
                this._Str_6067(_uid, new Event("Unexpeced error - No ad server request to failover to - signaling error"));
            }
        }

        
        public var _Str_13562(get,set):Bool;
public function  set__Str_13562(k:Bool):Bool        {
            return this._Str_8445 = k;
        }
public function  get__Str_13562():Bool
        {
            return this._Str_8445;
        }

        
        public var ads(get,set):Array<ASAny>;
public function  set_ads(k:Array<ASAny>):Array<ASAny>        {
            return this._Str_2518 = k;
        }

        public function _Str_24660():Int
        {
            if (this._Str_2518 != null)
            {
                return this._Str_2518.length;
            }
            return 0;
        }
public function  get_ads():Array<ASAny>
        {
            return this._Str_2518;
        }

        public function hasAds(k:Bool=false):Bool
        {
            var _local_2:VideoAd = null;
            if (this._Str_2518 == null)
            {
                return false;
            }
            final _iter_ = this._Str_2518; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.hasAds(k))
                {
                    return true;
                }
            }
            return false;
        }

        public function _Str_18406():String
        {
            return this._Str_6188;
        }

        public function _Str_26330():String
        {
            var k= new com.sulake.core.utils.xml.XML(this._Str_18406());
            var _local_2= new compat.RegExp("\\n", "g");
            var _local_3= _local_2.replace(k.toXMLString(), "\\n");
            return _local_3;
        }

        public function getMergedAds():Array<ASAny>
        {
            return this._Str_2518;
        }

        function _Str_19800(k:Array<ASAny>):Array<ASAny>
        {
            var _local_2:Array<ASAny> = null;
            var _local_3 = 0;
            var _local_4 = 0;
            if (this._Str_5101 == false)
            {
                if (k != null)
                {
                    _local_2 = new Array<ASAny>();
                    _local_3 = 0;
                    _local_4 = 0;
                    while (_local_4 < k.length)
                    {
                        if (cast(k[_local_4], VideoAd).isEmpty() == false)
                        {
                            _local_2.push(k[_local_4]);
                        }
                        else
                        {
                            _local_3++;
                        }
                        _local_4++;
                    }
                    return _local_2;
                }
            }
            return k;
        }

        public function _Str_11882(k:AdServerTemplate, _arg_2:Bool=false, _arg_3:Bool=false)
        {
            if (k.forceImpressionServing)
            {
                this._Str_5101 = true;
            }
            else
            {
                this._Str_5101 = false;
            }
            if (k.hasAds(this._Str_5101))
            {
                if (_arg_2)
                {
                    this._Str_2518 = this._Str_2518.concat(this._Str_23772(this._Str_19800((_arg_3 ? k.getMergedAds() : k.ads))));
                }
                else
                {
                    this._Str_2518 = this._Str_2518.concat(this._Str_19800((_arg_3 ? k.getMergedAds() : k.ads)));
                }
            }
            this._Str_6188 = (this._Str_6188 + k._Str_18406());
        }

        public function filterLinearAdMediaFileByMimeType(k:Array<ASAny>)
        {
        }

        public function _Str_22289(k:String):VideoAd
        {
            var _local_2 = 0;
            if (this._Str_2518 != null)
            {
                _local_2 = 0;
                while (_local_2 < this._Str_2518.length)
                {
                    if (this._Str_2518[_local_2].id == k)
                    {
                        return this._Str_2518[_local_2];
                    }
                    _local_2++;
                }
            }
            return null;
        }

        public function _Str_22948(k:Int):VideoAd
        {
            var _local_2 = 0;
            if (this._Str_2518 != null)
            {
                if (this._Str_2518.length > 0)
                {
                    _local_2 = k;
                    while (_local_2 < this._Str_2518.length)
                    {
                        if (((cast(this._Str_2518[_local_2], VideoAd).isEmpty() == false) && (cast(this._Str_2518[_local_2], VideoAd).isCompanionOnlyAd() == false)))
                        {
                            return this._Str_2518[_local_2];
                        }
                        _local_2++;
                    }
                }
            }
            return null;
        }

        public function _Str_3462(k:VideoAd)
        {
            this._Str_2518.push(k);
        }
    }

