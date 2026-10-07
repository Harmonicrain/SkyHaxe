package org.openvideoads.vast.schedule.ads
;
    import org.openvideoads.base.Debuggable;
    import org.openvideoads.vast.server.response._Str_3802;
    import org.openvideoads.vast.VASTController;
    import org.openvideoads.vast.server.request.AdServerRequestProcessor;
    import org.openvideoads.vast.schedule.StreamSequence;
    import org.openvideoads.vast.config.Config;
    import org.openvideoads.vast.server.response.AdServerTemplate;
    import org.openvideoads.vast.analytics._Str_2408;
    import org.openvideoads.vast.schedule._Str_4545;
    import flash.events.Event;
    import org.openvideoads.vast.server.request.AdServerRequest;
    import org.openvideoads.util.StringUtils;
    import org.openvideoads.vast.tracking._Str_4278;

     class AdSchedule extends Debuggable implements _Str_3802 
    {
        var _Str_2407:Array<ASAny>;
        var _Str_2335:VASTController = null;
        var _Str_17771:Int = -1;
        var _Str_14472:AdServerRequestProcessor = null;
        var _Str_2922:_Str_3802 = null;
        var _Str_12448:Bool = false;

        public function new(k:VASTController, _arg_2:StreamSequence, _arg_3:Config=null, _arg_4:AdServerTemplate=null)
        {
            this._Str_2407 = new Array<ASAny>();
            super();
            this._Str_2335 = k;
            if (_arg_3 != null)
            {
                this.build(_arg_3, _arg_2, -1, true);
                if (_arg_4 != null)
                {
                    this.schedule(_arg_4);
                }
            }
        }

        public function unload()
        {
            var k = 0;
            if (this._Str_14472 != null)
            {
                this._Str_14472.unload();
                if (this._Str_6852())
                {
                    k = 0;
                    while (k < this._Str_2407.length)
                    {
                        this._Str_2407[k].unload();
                        k++;
                    }
                }
            }
        }

        public function _Str_26181():Bool
        {
            return this._Str_12448;
        }

        public var analyticsProcessor(get,never):_Str_2408;
public function  get_analyticsProcessor():_Str_2408
        {
            if (this._Str_2335 != null)
            {
                return this._Str_2335.analyticsProcessor;
            }
            return null;
        }

        function _Str_26356(k:Array<ASAny>):Int
        {
            var _local_2 = 0;
            var _local_3 = 0;
            while (_local_3 < k.length)
            {
                if (k[_local_3].isStream())
                {
                    _local_2++;
                }
                _local_3++;
            }
            return _local_2;
        }

        
        public var _Str_12339(get,set):Array<ASAny>;
public function  get__Str_12339():Array<ASAny>
        {
            return this._Str_2407;
        }
public function  set__Str_12339(k:Array<ASAny>):Array<ASAny>        {
            return this._Str_2407 = k;
        }

        public function addAdSlot(k:AdSlot)
        {
            this._Str_2407.push(k);
        }

        public function _Str_6852():Bool
        {
            return (this._Str_2407 != null) && (this._Str_2407.length > 0);
        }

        public function _Str_18822():Bool
        {
            return this._Str_2407.length > 0;
        }

        public function _Str_20425(k:Int)
        {
            var _local_2:AdSlot = null;
            if (this._Str_6852())
            {
                final _iter_ = this._Str_2407; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_2  = _tmp_;
                    if (_local_2.associatedStreamIndex == k)
                    {
                        _local_2.resetAllTrackingPoints();
                    }
                }
            }
        }

        public function _Str_19527():Bool
        {
            var k = 0;
            if (this._Str_18822())
            {
                k = 0;
                while (k < this._Str_2407.length)
                {
                    if (this._Str_2407[k].isLinear())
                    {
                        if (this._Str_12448)
                        {
                            return true;
                        }
                        if (!cast(this._Str_2407[k], AdSlot).videoAd.isEmpty())
                        {
                            return true;
                        }
                    }
                    k++;
                }
            }
            return false;
        }

        public function hasNonLinearAds():Bool
        {
            var k = 0;
            if (this._Str_18822())
            {
                k = 0;
                while (k < this._Str_2407.length)
                {
                    if (this._Str_2407[k].isNonLinear())
                    {
                        if (this._Str_12448)
                        {
                            return true;
                        }
                        if (cast(this._Str_2407[k], AdSlot).isEmpty() == false)
                        {
                            return true;
                        }
                    }
                    k++;
                }
            }
            return false;
        }

        public function _Str_24421(k:Int):Bool
        {
            return k < this.length;
        }

        public function _Str_4198(k:Int):AdSlot
        {
            if (this._Str_24421(k))
            {
                return this._Str_2407[k];
            }
            return null;
        }

        public function _Str_26130(k:Int, _arg_2:String)
        {
            if ((this._Str_6852() && (k < this._Str_2407.length)))
            {
                this._Str_2407[k].id = _arg_2;
            }
        }

        public var length(get,never):Int;
public function  get_length():Int
        {
            return this._Str_2407.length;
        }

        function _Str_20424(k:ASObject, _arg_2:ASObject):ASObject
        {
            var _local_3:ASObject = new ASObject();
            if (k != null)
            {
                if (ASCompat.hasOwnProperty(k, "show"))
                {
                    _local_3.show = k.show;
                }
                if (ASCompat.hasOwnProperty(k, "region"))
                {
                    _local_3.region = k.region;
                }
                if (ASCompat.hasOwnProperty(k, "message"))
                {
                    _local_3.message = k.message;
                }
                if (ASCompat.hasOwnProperty(k, "type"))
                {
                    _local_3.type = k.type;
                }
            }
            if (_arg_2 != null)
            {
                if (ASCompat.hasOwnProperty(_arg_2, "show"))
                {
                    _local_3.show = _arg_2.show;
                }
                if (ASCompat.hasOwnProperty(_arg_2, "region"))
                {
                    _local_3.region = _arg_2.region;
                }
                if (ASCompat.hasOwnProperty(_arg_2, "message"))
                {
                    _local_3.message = _arg_2.message;
                }
                if (ASCompat.hasOwnProperty(_arg_2, "type"))
                {
                    _local_3.type = _arg_2.type;
                }
            }
            return _local_3;
        }

        function _Str_19154(k:ASAny, _arg_2:ASAny):Bool
        {
            if (_arg_2 != /*undefined*/null)
            {
                return _arg_2;
            }
            if (k != /*undefined*/null)
            {
                return k;
            }
            return false;
        }

        public function _Str_19858(k:Bool=false)
        {
            var _local_2 = 0;
            if (this._Str_18822())
            {
                _local_2 = 0;
                while (_local_2 < this._Str_2407.length)
                {
                    if (((cast(this._Str_2407[_local_2], AdSlot).isEmpty() && (cast(this._Str_2407[_local_2], AdSlot).loadOnDemand == false)) || ((cast(this._Str_2407[_local_2], AdSlot).isEmpty() && (cast(this._Str_2407[_local_2], AdSlot).loadOnDemand == true)) && cast(this._Str_2407[_local_2], AdSlot)._Str_25264())))
                    {
                        this._Str_2407[_local_2].processForcedImpression(k);
                    }
                    _local_2++;
                }
            }
        }

        function _Str_25453(k:ASObject, _arg_2:Int, _arg_3:Bool=false, _arg_4:Int=1, _arg_5:_Str_4545=null):Bool
        {
            if (_arg_5 != null)
            {
                if (!_arg_5.isStream())
                {
                    return false;
                }
            }
            if (k.applyToParts != /*undefined*/null)
            {
                if (Std.is(k.applyToParts , String))
                {
                    if (k.applyToParts.toUpperCase() == "LAST")
                    {
                        return (_arg_2 + 1) == _arg_4;
                    }
                    return false;
                }
                if (Std.is(k.applyToParts , Array))
                {
                    return k.applyToParts.indexOf(_arg_2) > -1;
                }
                return false;
            }
            return true;
        }

        public function _Str_21149(k:String, _arg_2:String, _arg_3:Int, _arg_4:Int):String
        {
            if (k != null)
            {
                return k;
            }
            if (_arg_2 == null)
            {
                return ((("overlay" + ":") + Std.string(_arg_3)) + ".") + Std.string(_arg_4);
            }
            return (((_arg_2 + ":") + Std.string(_arg_3)) + ".") + Std.string(_arg_4);
        }

        public function _Str_23072():Bool
        {
            var k = 0;
            if (this._Str_2407 != null)
            {
                k = 0;
                while (k < this._Str_2407.length)
                {
                    if (cast(this._Str_2407[k], AdSlot).loadOnDemand == false)
                    {
                        return true;
                    }
                    k++;
                }
            }
            return false;
        }

        public function _Str_23849(k:_Str_3802)
        {
            this._Str_2922 = k;
            if (this._Str_2335.config.scheduleAds)
            {
                this._Str_14472 = new AdServerRequestProcessor(this, this._Str_2407);
                this._Str_14472.start();
            }
            else
            {
                if (this._Str_2922 != null)
                {
                    this._Str_2922.onTemplateLoaded(new AdServerTemplate());
                }
            }
        }

        public function onTemplateLoaded(k:AdServerTemplate)
        {
            if (this._Str_2922 != null)
            {
                this._Str_2922.onTemplateLoaded(k);
            }
        }

        public function onTemplateLoadError(k:Event)
        {
            if (this._Str_2922 != null)
            {
                this._Str_2922.onTemplateLoadError(k);
            }
        }

        public function _Str_5807(k:Event)
        {
            if (this._Str_2922 != null)
            {
                this._Str_2922._Str_5807(k);
            }
        }

        public function _Str_5916(k:Event)
        {
            if (this._Str_2922 != null)
            {
                this._Str_2922._Str_5916(k);
            }
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

        public function build(k:Config, _arg_2:StreamSequence, _arg_3:Int=-1, _arg_4:Bool=false)
        {
            var _local_5 = 0;
            var _local_6 = 0;
            var _local_7 = 0;
            var _local_8:_Str_4545 = null;
            var _local_9:ASObject = null;
            var _local_10:AdSlot = null;
            var _local_11 = 0;
            var _local_12:String = null;
            var _local_13:AdSlot = null;
            var _local_14 = 0;
            if (k._Str_8392 != null)
            {
                _local_5 = ((k.streams.length == 0) ? 1 : k.streams.length);
                _local_6 = 0;
                while (_local_6 < _local_5)
                {
                    if (_arg_3 == -1)
                    {
                        _arg_3 = k._Str_8392.length;
                    }
                    _local_7 = 0;
                    while (((_local_7 < k._Str_8392.length) && (_local_7 <= _arg_3)))
                    {
                        _local_8 = ((_local_6 < k.streams.length) ? k.streams[_local_6] : null);
                        if (this._Str_25453(k._Str_8392[_local_7], _local_6, _arg_4, _local_5, _local_8))
                        {
                            _local_9 = k._Str_8392[_local_7];
                            if (Std.is(_local_9.zone , String) == false)
                            {
                                _local_9.zone = ASCompat.toString(_local_9.zone);
                            }
                            if ((ASCompat.toBool(_local_9.zone) && (_local_9.zone.toUpperCase() == "STATIC")))
                            {
                                _local_10 = new _Str_11486(_arg_2, this, this._Str_2335, this._Str_2407.length, _local_6, this._Str_21149(_local_9.id, _local_9.position, _local_7, _local_6), _local_9.zone, _local_9.position, ((_local_9.applyToParts == /*undefined*/null) ? null : _local_9.applyToParts), _local_9.duration, ((_local_9.startTime == /*undefined*/null) ? "00:00:00" : _local_9.startTime), this._Str_20424(k.notice, _local_9.notice), this._Str_19154(k._Str_4565.shouldDisableControlsDuringLinearAds(), _local_9.disableControls), new Array<ASAny>(), ((_local_9.companionDivIDs == /*undefined*/null) ? k.companionDivIDs : _local_9.companionDivIDs), ((_local_9.startPoint == /*undefined*/null) ? null : _local_9.startPoint), ((_local_9.html == /*undefined*/null) ? null : _local_9.html));
                            }
                            else
                            {
                                _local_12 = this._Str_21149(_local_9.id, _local_9.position, _local_7, _local_6);
                                _local_10 = new AdSlot(_arg_2, this, this._Str_2335, this._Str_2407.length, _local_6, _local_12, _local_9.zone, _local_9.position, ((_local_9.applyToParts == /*undefined*/null) ? null : _local_9.applyToParts), _local_9.duration, _local_9.duration, ((_local_9.startTime == /*undefined*/null) ? "00:00:00" : _local_9.startTime), this._Str_20424(k.notice, _local_9.notice), this._Str_19154(k._Str_4565.shouldDisableControlsDuringLinearAds(), _local_9.disableControls), new Array<ASAny>(), ((_local_9.companionDivIDs == /*undefined*/null) ? k.companionDivIDs : _local_9.companionDivIDs), ((_local_9.streamType != /*undefined*/null) ? _local_9.streamType : k.streamType), ((_local_9.deliveryType != /*undefined*/null) ? _local_9.deliveryType : k.deliveryType), ((_local_9.bitrate != /*undefined*/null) ? _local_9.bitrate : k.bitrate), ((_local_9.playOnce != /*undefined*/null) ? _local_9.playOnce : k.playOnce), k.metaData, ((_local_9.autoPlay != /*undefined*/null) ? _local_9.autoPlay : k.autoPlay), ((_local_9.regions != /*undefined*/null) ? _local_9.regions : null), ((_local_9.player != /*undefined*/null) ? _local_9.player : k.adsConfig.player), k._Str_16561, ((_local_9.server != /*undefined*/null) ? _local_9.server : null), null, ((_local_9.loadOnDemand != /*undefined*/null) ? StringUtils._Str_2810(_local_9.loadOnDemand) : false), ((_local_9.refreshOnReplay != /*undefined*/null) ? StringUtils._Str_2810(_local_9.refreshOnReplay) : false), Std.int(ASCompat.hasOwnProperty(_local_9, "maxDisplayCount") ? Std.int(StringUtils._Str_24234(_local_9.maxDisplayCount) ): -1));
                            }
                            _local_11 = ASCompat.toInt((_local_9.repeat == /*undefined*/null) ? 1 : ASCompat.toInt(_local_9.repeat));
                            if (_local_11 > 1)
                            {
                                _local_13 = _local_10;
                                _local_14 = 0;
                                while (_local_14 < _local_11)
                                {
                                    this.addAdSlot(_local_13);
                                    _local_13 = _local_13.clone();
                                    _local_13.key = this._Str_2407.length;
                                    _local_14++;
                                }
                            }
                            else
                            {
                                this.addAdSlot(_local_10);
                            }
                            if (_local_10.loadOnDemand)
                            {
                                this._Str_12448 = true;
                            }
                        }
                        _local_7++;
                    }
                    _local_6++;
                }
                if (this._Str_12448)
                {
                }
            }
        }

        public function _Str_20275()
        {
            var k = 0;
            if (this._Str_2335 != null)
            {
                k = 0;
                while (k < this._Str_2407.length)
                {
                    if (cast(this._Str_2407[k], AdSlot).loadOnDemand)
                    {
                        this._Str_2335._Str_19790(this._Str_2407[k], true);
                    }
                    else
                    {
                        if (((!this._Str_2407[k].isLinear()) && ASCompat.toBool(this._Str_2407[k].hasNonLinearAds())))
                        {
                            this._Str_2335._Str_19790(this._Str_2407[k], false);
                        }
                    }
                    k++;
                }
            }
        }

        public function addNonLinearAdTrackingPoints(k:Bool=true, _arg_2:Bool=false)
        {
            var _local_3 = 0;
            if (this._Str_6852())
            {
                while (_local_3 < this._Str_2407.length)
                {
                    if (this._Str_2407[_local_3].isNonLinear())
                    {
                        this._Str_2407[_local_3].addNonLinearAdTrackingPoints(_local_3, k, true, _arg_2);
                    }
                    _local_3++;
                }
            }
        }

        public function _Str_26032():Array<ASAny>
        {
            var k= new Array<ASAny>();
            var _local_2 = 0;
            while (_local_2 < this._Str_2407.length)
            {
                if ((ASCompat.toBool(this._Str_2407[_local_2].id) && (!(this._Str_2407[_local_2].id == "popup"))))
                {
                    k.push(((this._Str_2407[_local_2].id + "-") + this._Str_2407[_local_2].associatedStreamIndex));
                }
                _local_2++;
            }
            return k;
        }

        public var _Str_26141(get,never):Array<ASAny>;
public function  get__Str_26141():Array<ASAny>
        {
            var _local_3:ASObject = null;
            var k= new Array<ASAny>();
            var _local_2 = 0;
            while (_local_2 < this._Str_2407.length)
            {
                if ((ASCompat.toBool(this._Str_2407[_local_2].id) && (!(this._Str_2407[_local_2].id == "popup"))))
                {
                    _local_3 = new ASObject();
                    _local_3.id = ((this._Str_2407[_local_2].id + "-") + this._Str_2407[_local_2].associatedStreamIndex);
                    _local_3.zone = this._Str_2407[_local_2].zone;
                    k.push(_local_3);
                }
                _local_2++;
            }
            return k;
        }

        public function schedule(k:AdServerTemplate=null)
        {
            var _local_2 = 0;
            if (this._Str_6852())
            {
                _local_2 = 0;
                while (_local_2 < this._Str_2407.length)
                {
                    if (this._Str_2407[_local_2].id != null)
                    {
                        if (k != null)
                        {
                            this._Str_2407[_local_2].videoAd = k._Str_22289(((this._Str_2407[_local_2].id + "-") + this._Str_2407[_local_2].associatedStreamIndex));
                        }
                    }
                    _local_2++;
                }
            }
        }

        public function _Str_26370(k:Int, _arg_2:Int)
        {
            if (this._Str_2407.length < k)
            {
                this._Str_2407[k].registerCompanionClickThrough(_arg_2);
            }
        }

        public function processTimeEvent(k:Int, _arg_2:_Str_4278, _arg_3:Bool=true)
        {
            var _local_4 = 0;
            if (this._Str_6852())
            {
                _local_4 = 0;
                while (_local_4 < this._Str_2407.length)
                {
                    if (((this._Str_2407[_local_4].associatedStreamIndex == k) && (!this._Str_2407[_local_4].isLinear())))
                    {
                        this._Str_2407[_local_4].processTimeEvent(_arg_2, _arg_3, this._Str_2335.config.adsConfig.resetTrackingOnReplay);
                    }
                    _local_4++;
                }
                this._Str_17771 = k;
            }
        }

        public function closeActiveOverlaysAndCompanions(k:Bool=false)
        {
            var _local_2 = 0;
            if (this._Str_6852())
            {
                _local_2 = 0;
                while (_local_2 < this._Str_2407.length)
                {
                    if (this._Str_2407[_local_2].isPlaying())
                    {
                        this._Str_2407[_local_2].closeActiveOverlaysAndCompanions(k);
                    }
                    _local_2++;
                }
            }
        }

        public function _Str_23109(k:Int, _arg_2:Float, _arg_3:Bool=false)
        {
            var _local_4 = 0;
            if (this._Str_6852())
            {
                _local_4 = 0;
                while (_local_4 < this._Str_2407.length)
                {
                    if (((this._Str_2407[_local_4].associatedStreamIndex == k) && (this._Str_2407[_local_4].isLinear() == false)))
                    {
                        if ((ASCompat.toBool(this._Str_2407[_local_4].isPlaying()) && (this._Str_2407[_local_4].shouldBePlaying(_arg_2) == false)))
                        {
                            this._Str_2407[_local_4].closeActiveOverlaysAndCompanions(_arg_3);
                        }
                    }
                    _local_4++;
                }
            }
        }
    }

