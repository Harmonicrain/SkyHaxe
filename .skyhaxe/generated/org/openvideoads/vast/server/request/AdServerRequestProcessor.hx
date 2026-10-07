package org.openvideoads.vast.server.request
;
    import org.openvideoads.base.Debuggable;
    import org.openvideoads.vast.server.response._Str_3802;
    import org.openvideoads.vast.server.response.AdServerTemplate;
    import flash.events.Event;
    import org.openvideoads.vast.model.VideoAdServingTemplate;
    import org.openvideoads.vast.schedule.ads.AdSlot;
    import org.openvideoads.vast.server.config.AdServerConfig;
    import org.openvideoads.vast.analytics._Str_2408;
    import org.openvideoads.vast.server.events.TemplateEvent;

     class AdServerRequestProcessor extends Debuggable implements _Str_3802 
    {
        var _Str_2922:_Str_3802 = null;
        var _Str_3057:ASDictionary<ASAny,ASAny>;
        var _Str_6352:Array<ASAny>;
        var _Str_26267:Array<ASAny> = null;
        var _Str_9195:Array<ASAny> = null;
        var _Str_16421:Int = 0;
        var _Str_8965:Int = 0;
        var _Str_20279:AdServerRequest = null;
        var _Str_4160:Array<ASAny>;
        var _Str_8822:AdServerTemplate = null;
        var _Str_7407:AdServerTemplate;
        var _Str_13031:Bool = false;
        var _Str_17984:Bool = false;
        var _Str_17572:Bool = false;
        var _Str_13685:Event = null;
        var _Str_14296:Event = null;
        var _Str_19273:Bool = false;

        public function new(k:_Str_3802, _arg_2:Array<ASAny>, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            var _local_6:String = null;
            this._Str_3057 = new ASDictionary<ASAny,ASAny>();
            this._Str_6352 = new Array<ASAny>();
            this._Str_4160 = new Array<ASAny>();
            this._Str_7407 = new VideoAdServingTemplate();
            super();
            this._Str_2922 = k;
            this._Str_19273 = _arg_4;
            var _local_5 = 0;
            while (_local_5 < _arg_2.length)
            {
                if (((_arg_3 == false) && cast(_arg_2[_local_5], AdSlot).loadOnDemand))
                {
                }
                else
                {
                    if (_arg_2[_local_5].hasAdServerConfigured())
                    {
                        _local_6 = cast(_arg_2[_local_5].adServerConfig, AdServerConfig)._Str_23380();
                        if (this._Str_3057[_local_6] == null)
                        {
                            this._Str_3057[_local_6] = new AdServerRequestGroup(_arg_2[_local_5].adServerConfig.serverType, _arg_2[_local_5].adServerConfig.oneAdPerRequest);
                            this._Str_6352.push(_local_6);
                        }
                        this._Str_3057[_local_6].addAdSlot(_arg_2[_local_5]);
                    }
                }
                _local_5++;
            }
        }

        public function unload()
        {
            var k = 0;
            while (k < this._Str_4160.length)
            {
                this._Str_4160[k].unload();
                k++;
            }
            if (this._Str_7407 != null)
            {
                this._Str_7407.unload();
            }
        }

        public var analyticsProcessor(get,never):_Str_2408;
public function  get_analyticsProcessor():_Str_2408
        {
            if (this._Str_2922 != null)
            {
                return this._Str_2922.analyticsProcessor;
            }
            return null;
        }

        function _Str_22407()
        {
            this._Str_13031 = false;
            this._Str_17984 = false;
            this._Str_17572 = false;
            this._Str_13685 = null;
            this._Str_14296 = null;
        }

        public function start()
        {
            this._Str_22407();
            this._Str_4160 = new Array<ASAny>();
            if (this._Str_6352.length > 0)
            {
                this._Str_19779(0);
            }
            else
            {
                this._Str_19191();
            }
        }

        public function _Str_25262():Bool
        {
            if (this._Str_8822 != null)
            {
                if (this._Str_8822._Str_22097())
                {
                    this.unload();
                    this._Str_8822._Str_24781();
                    this._Str_8822._Str_10465();
                    this._Str_7407 = new VideoAdServingTemplate();
                    this._Str_4160 = new Array<ASAny>();
                    return true;
                }
            }
            return false;
        }

        public var _Str_25999(get,never):AdServerRequest;
public function  get__Str_25999():AdServerRequest
        {
            return this._Str_20279;
        }

        function _Str_20115(k:AdServerRequest)
        {
            k.callOnDemand = this._Str_19273;
            this._Str_8822 = k._Str_19422(this);
            this._Str_20279 = k;
        }

        function _Str_19779(k:Int=0)
        {
            this._Str_16421 = k;
            if (this._Str_3057[this._Str_6352[k]].oneAdPerRequest)
            {
                this._Str_9195 = this._Str_3057[this._Str_6352[k]].getAdServerRequests();
                this._Str_8965 = 0;
                this._Str_20115(this._Str_9195[this._Str_8965]);
            }
            else
            {
                this._Str_9195 = null;
                if (this._Str_3057[this._Str_6352[k]].getSingleAdServerRequest() != null)
                {
                    this._Str_20115(this._Str_3057[this._Str_6352[k]].getSingleAdServerRequest());
                }
                else
                {
                    this._Str_17919();
                }
            }
        }

        function _Str_17919()
        {
            if ((this._Str_16421 + 1) < this._Str_6352.length)
            {
                this._Str_19779((this._Str_16421 + 1));
            }
            else
            {
                this._Str_19191();
            }
        }

        function _Str_25583()
        {
            var k:AdServerRequest = null;
            if ((this._Str_8965 + 1) < this._Str_9195.length)
            {
                this._Str_8965++;
                k = this._Str_9195[this._Str_8965];
                this._Str_8822 = k._Str_19422(this);
            }
            else
            {
                this._Str_17919();
            }
        }

        function _Str_19191()
        {
            var k = 0;
            while (k < this._Str_4160.length)
            {
                this._Str_7407._Str_11882(this._Str_4160[k]);
                k++;
            }
            this._Str_7407._Str_13562 = true;
            if (this._Str_2922 != null)
            {
                if ((this._Str_17984 && (!this._Str_13031)))
                {
                    this._Str_2922.onTemplateLoadError(new TemplateEvent(TemplateEvent._Str_14592, ((this._Str_14296 != null) ? this._Str_14296.toString() : null)));
                }
                else
                {
                    if ((this._Str_17572 && (!this._Str_13031)))
                    {
                        this._Str_2922._Str_5807(new TemplateEvent(TemplateEvent._Str_6699, ((this._Str_13685 != null) ? this._Str_13685.toString() : null)));
                    }
                    else
                    {
                        this._Str_2922.onTemplateLoaded(this._Str_7407);
                    }
                }
            }
        }

        function _Str_13348()
        {
            if (this._Str_9195 != null)
            {
                this._Str_25583();
            }
            else
            {
                this._Str_17919();
            }
        }

        public function onTemplateLoaded(k:AdServerTemplate)
        {
            this._Str_13031 = true;
            this._Str_4160.push(k);
            this._Str_13348();
        }

        public function onTemplateLoadError(k:Event)
        {
            this._Str_17984 = true;
            this._Str_14296 = k;
            this._Str_13348();
        }

        public function _Str_5807(k:Event)
        {
            this._Str_17572 = true;
            this._Str_13685 = k;
            this._Str_13348();
        }

        public function _Str_5916(k:Event)
        {
            this._Str_13348();
        }

        public function onAdCallStarted(k:AdServerRequest)
        {
            if (this._Str_2922 != null)
            {
                this._Str_2922.onAdCallStarted(k);
            }
        }

        public function onAdCallFailover(k:AdServerRequest, _arg_2:AdServerRequest)
        {
            if (this._Str_2922 != null)
            {
                this._Str_2922.onAdCallFailover(k, _arg_2);
            }
        }

        public function onAdCallComplete(k:AdServerRequest, _arg_2:Bool)
        {
            if (this._Str_2922 != null)
            {
                this._Str_2922.onAdCallComplete(k, _arg_2);
            }
        }
    }

