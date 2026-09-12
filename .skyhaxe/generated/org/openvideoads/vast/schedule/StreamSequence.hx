package org.openvideoads.vast.schedule
;
    import org.openvideoads.base.Debuggable;
    import org.openvideoads.vast.VASTController;
    import org.openvideoads.vast.schedule.ads.AdSchedule;
    import org.openvideoads.vast.schedule.ads.AdSlot;
    import org.openvideoads.util.Timestamp;
    import org.openvideoads.vast.tracking._Str_4278;

     class StreamSequence extends Debuggable 
    {
        var _Str_2335:VASTController = null;
        var _Str_2426:Array<ASAny>;
        var _Str_20060:Int = 0;
        var _Str_17395:Int = 0;
        var _Str_17900:Int = -1;
        var _Str_2846:String = null;
        var _Str_24215:Int = 1;
        var _Str_17771:Int = -1;

        public function new(k:VASTController=null, _arg_2:Array<ASAny>=null, _arg_3:AdSchedule=null, _arg_4:Int=-1, _arg_5:String=null, _arg_6:Int=1, _arg_7:String=null)        {
            this._Str_2426 = new Array<ASAny>();
            super();
            if (_arg_2 != null)
            {
                this.initialise(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6);
            }
            else
            {
                this._Str_2335 = k;
            }
        }

        public function initialise(k:VASTController, _arg_2:Array<ASAny>=null, _arg_3:AdSchedule=null, _arg_4:Int=-1, _arg_5:String=null, _arg_6:Int=1, _arg_7:String=null)
        {
            this._Str_2335 = k;
            this._Str_24215 = _arg_6;
            this._Str_17900 = _arg_4;
            if (_arg_5 != null)
            {
                this._Str_2846 = _arg_5;
            }
            if (((!(_arg_2 == null)) && (!(_arg_3 == null))))
            {
                this._Str_20060 = this.build(_arg_2, _arg_3, _arg_7);
            }
        }

        public var _Str_26088(get,never):VASTController;
public function  get__Str_26088():VASTController
        {
            return this._Str_2335;
        }

        public var length(get,never):Int;
public function  get_length():Int
        {
            return this._Str_2426.length;
        }

        public function _Str_21989(k:Int):Stream
        {
            return this._Str_2426[k];
        }

        public var _Str_25986(get,never):Int;
public function  get__Str_25986():Int
        {
            return this._Str_20060;
        }

        public function _Str_26180():Bool
        {
            return this._Str_17900 > -1;
        }

        public var _Str_26217(get,never):Int;
public function  get__Str_26217():Int
        {
            return this._Str_17900;
        }

        public function hasBaseURL():Bool
        {
            return !(this._Str_2846 == null);
        }

        public var baseURL(get,never):String;
public function  get_baseURL():String
        {
            return this._Str_2846;
        }

        public function _Str_25991(k:Int)
        {
            this._Str_17395 = k;
        }

        public var _Str_25953(get,never):Int;
public function  get__Str_25953():Int
        {
            return this._Str_17395;
        }

        public function _Str_26190()
        {
            this._Str_17395 = -1;
        }

        public function _Str_26061():Int
        {
            var k = 0;
            while (k < this._Str_2426.length)
            {
                if (this._Str_2426[k].isStream())
                {
                    return k;
                }
                k++;
            }
            return 0;
        }

        public function _Str_6899(k:Int):Stream
        {
            if (this._Str_2426 != null)
            {
                if (k < this._Str_2426.length)
                {
                    return this._Str_2426[k];
                }
            }
            return null;
        }

        public function _Str_20064(k:Int)
        {
            if (this._Str_2426 != null)
            {
                if (((k > -1) && (k < this._Str_2426.length)))
                {
                    this._Str_2426[k].resetAllTrackingPoints();
                }
            }
        }

        public function _Str_21668(k:Int, _arg_2:Int)
        {
            if (k < this._Str_2426.length)
            {
                this._Str_2426[k].duration = _arg_2;
            }
        }

        public function _Str_21270(k:Int, _arg_2:Bool=false, _arg_3:Bool=false):Int
        {
            var _local_4 = 0;
            var _local_5 = 0;
            while (_local_5 < this._Str_2426.length)
            {
                if (!Std.is(this._Str_2426[_local_5] , AdSlot))
                {
                    if (this._Str_2426[_local_5].originatingStreamIndex == k)
                    {
                        return _local_5 - _local_4;
                    }
                    if ((ASCompat.toBool(this._Str_2426[_local_5].isSlice()) && _arg_2))
                    {
                        _local_4++;
                    }
                }
                else
                {
                    if ((ASCompat.toBool(this._Str_2426[_local_5].isMidRoll()) && _arg_3))
                    {
                        _local_4++;
                    }
                }
                _local_5++;
            }
            return -1;
        }

        function _Str_18931():ASObject
        {
            var k:ASObject = new ASObject();
            k.usedAdDuration = 0;
            k.remainingActiveShowDuration = 0;
            k.usedActiveShowDuration = 0;
            k.totalActiveShowDuration = 0;
            k.associatedStreamIndex = 0;
            k.atStart = false;
            k.hasOffsetStartTime = false;
            return k;
        }

        public function _Str_3329(k:Stream, _arg_2:Bool=true)
        {
            if (_arg_2)
            {
                k.declareTrackingPoints(0);
            }
            this._Str_2426.push(k);
        }

        public function _Str_9140(k:Array<ASAny>, _arg_2:ASObject, _arg_3:String, _arg_4:Int, _arg_5:AdSlot=null):Int
        {
            var _local_6= Timestamp._Str_4110(ASCompat.toNumber(_arg_2.usedActiveShowDuration));
            var _local_7= true;
            if (((!(k[ASCompat.toInt(_arg_2.associatedStreamIndex)].startTime == /*undefined*/null)) && (!(k[ASCompat.toInt(_arg_2.associatedStreamIndex)].startTime == null))))
            {
                _local_7 = (!(k[ASCompat.toInt(_arg_2.associatedStreamIndex)].startTime == _local_6));
            }
            this._Str_3329(new Stream(this, this._Str_2335, this._Str_2426.length, (((_arg_3 + _arg_2.associatedStreamIndex) + "-") + Std.string(this._Str_2426.length)), k[ASCompat.toInt(_arg_2.associatedStreamIndex)].id, ((_local_7 && this._Str_2335.config.adsConfig.hasPostMidRollSeekPosition()) ? this._Str_2335.config.adsConfig.postMidRollSeekPositionAsTimestamp() : _local_6), ASCompat.toString(_arg_2.totalActiveShowDuration), ASCompat.toString(_arg_2.totalActiveShowDuration), true, (k[ASCompat.toInt(_arg_2.associatedStreamIndex)].hasBaseURL() ? k[ASCompat.toInt(_arg_2.associatedStreamIndex)].baseURL : this._Str_2846), "any", "any", -1, k[ASCompat.toInt(_arg_2.associatedStreamIndex)].playOnce, k[ASCompat.toInt(_arg_2.associatedStreamIndex)].metaData, k[ASCompat.toInt(_arg_2.associatedStreamIndex)].autoPlay, k[ASCompat.toInt(_arg_2.associatedStreamIndex)].provider, k[ASCompat.toInt(_arg_2.associatedStreamIndex)].player, null, ASCompat.toInt(_arg_2.associatedStreamIndex), _local_7, k[ASCompat.toInt(_arg_2.associatedStreamIndex)].customProperties, k[ASCompat.toInt(_arg_2.associatedStreamIndex)].fireTrackingEvents, false, _arg_5));
            _arg_2.usedActiveShowDuration = (_arg_2.usedActiveShowDuration + _arg_2.remainingActiveShowDuration);
            var _local_8= ASCompat.toInt(_arg_4 + _arg_2.remainingActiveShowDuration);
            return _local_8;
        }

        public function build(k:Array<ASAny>, _arg_2:AdSchedule, _arg_3:String=null):Int
        {
            var _local_9:AdSlot = null;
            var _local_10 = 0;
            var _local_11 = 0;
            var _local_12 = 0;
            var _local_13 = 0;
            var _local_14 = 0;
            var _local_15 = 0;
            var _local_16 = 0;
            var _local_17 = 0;
            var _local_18 = 0;
            var _local_4= _arg_2._Str_12339;
            var _local_5= new Array<ASAny>();
            var _local_6 = 0;
            var _local_7:ASObject = this._Str_18931();
            var _local_8:ASObject = this._Str_18931();
            if (_arg_2._Str_19527())
            {
                _local_9 = null;
                _local_10 = 0;
                while (_local_10 < _local_4.length)
                {
                    if (_local_8.associatedStreamIndex != _local_4[_local_10].associatedStreamIndex)
                    {
                        _local_7.remainingActiveShowDuration = (ASCompat.toNumber(_local_7.totalActiveShowDuration) - ASCompat.toNumber(_local_7.usedActiveShowDuration));
                        if (_local_7.remainingActiveShowDuration > 0)
                        {
                            _local_6 = (_local_6 + this._Str_9140(k, _local_7, "show-e-", _local_6, _local_9));
                            _local_7.remainingActiveShowDuration = 0;
                            _local_7.usedActiveShowDuration = _local_7.totalActiveShowDuration;
                            _local_7.associatedStreamIndex = (_local_7.associatedStreamIndex + 1);
                            _local_11 = ASCompat.toInt(_local_7.associatedStreamIndex);
                            while (((_local_11 < _local_4[_local_10].associatedStreamIndex) && (_local_11 < k.length)))
                            {
                                this._Str_3329(new Stream(this, this._Str_2335, _local_11, ((("show-k-" + Std.string(_local_12)) + "-") + Std.string(this._Str_2426.length)), k[_local_11].id, k[_local_11].startTime, Timestamp._Str_3314(k[_local_11].duration), Timestamp._Str_3314(k[_local_11].duration), k[_local_11].reduceLength, (k[_local_11].hasBaseURL() ? k[_local_11].baseURL : this._Str_2846), "any", "any", -1, k[_local_11].playOnce, k[_local_11].metaData, k[_local_11].autoPlay, k[_local_11].provider, k[_local_11].player, null, _local_11, false, k[_local_11].customProperties, k[_local_11].fireTrackingEvents, false, _local_9));
                                _local_6 = (_local_6 + Timestamp.timestampToSeconds(k[_local_11].duration));
                                _local_7.associatedStreamIndex = _local_11;
                                _local_11++;
                            }
                        }
                        _local_8 = _local_7;
                        _local_7 = this._Str_18931();
                        _local_7.associatedStreamIndex = _local_4[_local_10].associatedStreamIndex;
                    }
                    if (k.length > 0)
                    {
                        _local_7.totalActiveShowDuration = Timestamp.timestampToSeconds(k[ASCompat.toInt(_local_4[_local_10].associatedStreamIndex)].duration);
                        if (((_local_7.usedActiveShowDuration == 0) && (Timestamp.timestampToSeconds(k[ASCompat.toInt(_local_4[_local_10].associatedStreamIndex)].startTime) > 0)))
                        {
                            _local_7.usedActiveShowDuration = Timestamp.timestampToSeconds(k[ASCompat.toInt(_local_4[_local_10].associatedStreamIndex)].startTime);
                            _local_7.hasOffsetStartTime = true;
                        }
                    }
                    if (((!_local_4[_local_10].isLinear()) && ASCompat.toBool(_local_4[_local_10].isActive())))
                    {
                        _local_4[_local_10].associatedStreamIndex = this._Str_2426.length;
                    }
                    else
                    {
                        if ((ASCompat.toBool(_local_4[_local_10].isLinear()) && ASCompat.toBool(_local_4[_local_10].isActive())))
                        {
                            if (_local_4[_local_10].isPreRoll())
                            {
                                if (!_local_4[_local_10].isCopy())
                                {
                                    if (_local_7.associatedStreamIndex != _local_8.associatedStreamIndex)
                                    {
                                        if (((_local_8.usedActiveShowDuration > 0) && (_local_8.usedActiveShowDuration < _local_8.totalActiveShowDuration)))
                                        {
                                            _local_8.remainingActiveShowDuration = (ASCompat.toNumber(_local_8.totalActiveShowDuration) - ASCompat.toNumber(_local_8.usedActiveShowDuration));
                                            _local_6 = (_local_6 + this._Str_9140(k, _local_8, "show-a-", _local_6, _local_9));
                                            _local_8.associatedStreamIndex = (_local_8.associatedStreamIndex + 1);
                                        }
                                        _local_12 = ASCompat.toInt(_local_8.associatedStreamIndex);
                                        while (((_local_12 < _local_4[_local_10].associatedStreamIndex) && (_local_12 < k.length)))
                                        {
                                            this._Str_3329(new Stream(this, this._Str_2335, _local_12, ((("show-b-" + Std.string(_local_12)) + "-") + Std.string(this._Str_2426.length)), k[_local_12].id, k[_local_12].startTime, Timestamp._Str_3314(k[_local_12].duration), Timestamp._Str_3314(k[_local_12].duration), k[_local_12].reduceLength, (k[_local_12].hasBaseURL() ? k[_local_12].baseURL : this._Str_2846), "any", "any", -1, k[_local_12].playOnce, k[_local_12].metaData, k[_local_12].autoPlay, k[_local_12].provider, k[_local_12].player, null, _local_12, false, k[_local_12].customProperties, k[_local_12].fireTrackingEvents, false, _local_9));
                                            _local_6 = (_local_6 + Timestamp.timestampToSeconds(k[_local_12].duration));
                                            _local_8.associatedStreamIndex = _local_12;
                                            _local_12++;
                                        }
                                    }
                                }
                            }
                            else
                            {
                                if (_local_4[_local_10].isMidRoll())
                                {
                                    _local_9 = null;
                                    if (!_local_4[_local_10].isCopy())
                                    {
                                        if (((!(_local_8 == _local_7)) && (_local_8.usedActiveShowDuration < _local_8.totalActiveShowDuration)))
                                        {
                                            _local_8.remainingActiveShowDuration = (ASCompat.toNumber(_local_8.totalActiveShowDuration) - ASCompat.toNumber(_local_8.usedActiveShowDuration));
                                            _local_6 = (_local_6 + this._Str_9140(k, _local_8, "show-c-", _local_6, _local_9));
                                            _local_8.associatedStreamIndex = (_local_8.associatedStreamIndex + 1);
                                        }
                                        if (k.length > 0)
                                        {
                                            _local_13 = ASCompat.toInt(_local_8.associatedStreamIndex);
                                            while (((_local_13 < _local_4[_local_10].associatedStreamIndex) && (_local_13 < k.length)))
                                            {
                                                this._Str_3329(new Stream(this, this._Str_2335, _local_13, ((("show-cf-" + Std.string(_local_13)) + "-") + Std.string(this._Str_2426.length)), k[_local_13].id, k[_local_13].startTime, Timestamp._Str_3314(k[_local_13].duration), Timestamp._Str_3314(k[_local_13].duration), k[_local_13].reduceLength, (k[_local_13].hasBaseURL() ? k[_local_13].baseURL : this._Str_2846), "any", "any", -1, k[_local_13].playOnce, k[_local_13].metaData, k[_local_13].autoPlay, k[_local_13].provider, k[_local_13].player, null, _local_13, false, k[_local_13].customProperties, k[_local_13].fireTrackingEvents, false, _local_9));
                                                _local_6 = (_local_6 + Timestamp.timestampToSeconds(k[_local_13].duration));
                                                _local_8.associatedStreamIndex = _local_13;
                                                _local_13++;
                                            }
                                            _local_14 = ASCompat.toInt(ASCompat.toNumber(_local_4[_local_10].getStartTimeAsSeconds()) - ASCompat.toNumber(_local_7.usedActiveShowDuration));
                                            this._Str_3329(new Stream(this, this._Str_2335, this._Str_2426.length, ((("show-d-" + _local_4[_local_10].associatedStreamIndex) + "-") + Std.string(this._Str_2426.length)), k[ASCompat.toInt(_local_4[_local_10].associatedStreamIndex)].id, Timestamp._Str_4110(ASCompat.toNumber(_local_7.usedActiveShowDuration)), Std.string(_local_14), ASCompat.toString(_local_7.totalActiveShowDuration), true, (k[ASCompat.toInt(_local_4[_local_10].associatedStreamIndex)].hasBaseURL() ? k[ASCompat.toInt(_local_4[_local_10].associatedStreamIndex)].baseURL : this._Str_2846), "any", "any", -1, k[ASCompat.toInt(_local_4[_local_10].associatedStreamIndex)].playOnce, k[ASCompat.toInt(_local_4[_local_10].associatedStreamIndex)].metaData, k[ASCompat.toInt(_local_4[_local_10].associatedStreamIndex)].autoPlay, k[ASCompat.toInt(_local_4[_local_10].associatedStreamIndex)].provider, k[ASCompat.toInt(_local_4[_local_10].associatedStreamIndex)].player, null, ASCompat.toInt(_local_4[_local_10].associatedStreamIndex), true, k[ASCompat.toInt(_local_4[_local_10].associatedStreamIndex)].customProperties, k[ASCompat.toInt(_local_4[_local_10].associatedStreamIndex)].fireTrackingEvents, _local_7.hasOffsetStartTime, _local_9));
                                            _local_7.usedActiveShowDuration = (_local_7.usedActiveShowDuration + _local_14);
                                            _local_6 = (_local_6 + _local_14);
                                        }
                                    }
                                }
                                else
                                {
                                    _local_9 = null;
                                    if (k.length > 0)
                                    {
                                        if (!_local_4[_local_10].isCopy())
                                        {
                                            if (_local_7.associatedStreamIndex != _local_8.associatedStreamIndex)
                                            {
                                                if (((_local_8.usedActiveShowDuration > 0) && (_local_8.usedActiveShowDuration < _local_8.totalActiveShowDuration)))
                                                {
                                                    _local_8.remainingActiveShowDuration = (ASCompat.toNumber(_local_8.totalActiveShowDuration) - ASCompat.toNumber(_local_8.usedActiveShowDuration));
                                                    _local_6 = (_local_6 + this._Str_9140(k, _local_8, "show-h-", _local_6, _local_9));
                                                }
                                                _local_15 = ASCompat.toInt((_local_10 == 0) ? ASCompat.toInt(_local_8.associatedStreamIndex ): ASCompat.toInt(_local_8.associatedStreamIndex + 1));
                                                _local_16 = _local_15;
                                                while (((_local_16 < _local_4[_local_10].associatedStreamIndex) && (_local_16 < k.length)))
                                                {
                                                    this._Str_3329(new Stream(this, this._Str_2335, _local_16, ((("show-hf-" + Std.string(_local_16)) + "-") + Std.string(this._Str_2426.length)), k[_local_16].id, k[_local_16].startTime, Timestamp._Str_3314(k[_local_16].duration), Timestamp._Str_3314(k[_local_16].duration), k[_local_16].reduceLength, (k[_local_16].hasBaseURL() ? k[_local_16].baseURL : this._Str_2846), "any", "any", -1, k[_local_16].playOnce, k[_local_16].metaData, k[_local_16].autoPlay, k[_local_16].provider, k[_local_16].player, null, _local_16, false, k[_local_16].customProperties, k[_local_16].fireTrackingEvents, false, _local_9));
                                                    _local_6 = (_local_6 + Timestamp.timestampToSeconds(k[_local_16].duration));
                                                    _local_8.associatedStreamIndex = _local_16;
                                                    _local_16++;
                                                }
                                            }
                                            _local_7.remainingActiveShowDuration = (ASCompat.toNumber(_local_7.totalActiveShowDuration) - ASCompat.toNumber(_local_7.usedActiveShowDuration));
                                            if (_local_7.remainingActiveShowDuration > 0)
                                            {
                                                _local_6 = (_local_6 + this._Str_9140(k, _local_7, "show-e-", _local_6, _local_9));
                                                if ((_local_10 + 1) < _local_4.length)
                                                {
                                                    _local_7.associatedStreamIndex = (_local_7.associatedStreamIndex + 1);
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            _local_4[_local_10].streamStartTime = 0;
                            _local_4[_local_10].parent = this;
                            this._Str_3329(_local_4[_local_10]);
                            _local_7.usedAdDuration = (_local_7.usedAdDuration + _local_4[_local_10].getDurationAsInt());
                            _local_6 = ASCompat.toInt(_local_6 + _local_4[_local_10].getDurationAsInt());
                        }
                        else
                        {
                            _arg_2._Str_12339[_local_10].associatedStreamStartTime = _local_6;
                        }
                    }
                    _local_10++;
                }
                if (_local_7.usedActiveShowDuration < _local_7.totalActiveShowDuration)
                {
                    _local_7.remainingActiveShowDuration = (ASCompat.toNumber(_local_7.totalActiveShowDuration) - ASCompat.toNumber(_local_7.usedActiveShowDuration));
                    _local_6 = (_local_6 + this._Str_9140(k, _local_7, "show-f-", _local_6, _local_9));
                }
                if ((_local_7.associatedStreamIndex + 1) < k.length)
                {
                    _local_17 = ASCompat.toInt(_local_7.associatedStreamIndex + 1);
                    while (_local_17 < k.length)
                    {
                        this._Str_3329(new Stream(this, this._Str_2335, _local_17, ("show-g-" + Std.string(_local_17)), k[_local_17].id, k[_local_17].startTime, Timestamp._Str_3314(k[_local_17].duration), Timestamp._Str_3314(k[_local_17].duration), k[_local_17].reduceLength, (k[_local_17].hasBaseURL() ? k[_local_17].baseURL : this._Str_2846), "any", "any", -1, k[_local_17].playOnce, k[_local_17].metaData, k[_local_17].autoPlay, k[_local_17].provider, k[_local_17].player, null, _local_17, false, k[_local_17].customProperties, k[_local_17].fireTrackingEvents, false, _local_9));
                        _local_6 = (_local_6 + Timestamp.timestampToSeconds(k[_local_17].duration));
                        _local_17++;
                    }
                }
            }
            else
            {
                _local_18 = 0;
                while (_local_18 < k.length)
                {
                    this._Str_3329(new Stream(this, this._Str_2335, _local_18, ("show-h-" + Std.string(_local_18)), k[_local_18].id, k[_local_18].startTime, Timestamp._Str_3314(k[_local_18].duration), Timestamp._Str_3314(k[_local_18].duration), k[_local_18].reduceLength, (k[_local_18].hasBaseURL() ? k[_local_18].baseURL : this._Str_2846), "any", "any", -1, k[_local_18].playOnce, k[_local_18].metaData, k[_local_18].autoPlay, k[_local_18].provider, k[_local_18].player, null, _local_18, false, k[_local_18].customProperties, k[_local_18].fireTrackingEvents, false, _local_9));
                    _local_6 = (_local_6 + Timestamp.timestampToSeconds(k[_local_18].duration));
                    _local_18++;
                }
            }
            if (((!(_arg_3 == null)) && (this._Str_2426.length > 0)))
            {
                this._Str_2426[0].previewImage = _arg_3;
            }
            this._Str_17615();
            return _local_6;
        }

        function _Str_17615()
        {
            var _local_3:Stream = null;
            var _local_4 = 0;
            var k= -1;
            var _local_2= -1;
            if (this._Str_2426.length > 0)
            {
                _local_4 = 0;
                while (_local_4 < this._Str_2426.length)
                {
                    this._Str_2426[_local_4].index = _local_4;
                    if (((!(this._Str_2426[_local_4].originatingStreamIndex == k)) && (k > -1)))
                    {
                        _local_3 = this._Str_2426[(_local_4 - 1)];
                        _local_3._Str_17460 = true;
                    }
                    if (_local_4 > 0)
                    {
                        this._Str_2335._Str_20598((_local_4 - 1), this._Str_2426[(_local_4 - 1)]);
                    }
                    k = ASCompat.toInt(this._Str_2426[_local_4].originatingStreamIndex);
                    if (Std.is(this._Str_2426[_local_4] , AdSlot))
                    {
                        if (cast(this._Str_2426[_local_4], AdSlot).isPreRoll())
                        {
                            if (_local_2 == -1)
                            {
                                _local_2 = _local_4;
                            }
                        }
                    }
                    else
                    {
                        if (_local_2 > -1)
                        {
                            cast(this._Str_2426[_local_4], Stream)._Str_21235 = this._Str_2426[_local_2];
                            _local_2 = -1;
                        }
                    }
                    _local_4++;
                }
                _local_3 = this._Str_2426[(this._Str_2426.length - 1)];
                _local_3._Str_17460 = true;
                this._Str_2335._Str_20598((this._Str_2426.length - 1), _local_3);
            }
        }

        public function processTimeEvent(k:Int, _arg_2:_Str_4278, _arg_3:Bool=true)
        {
            if (((k > -1) && (k < this._Str_2426.length)))
            {
                this._Str_2426[k].processTimeEvent(_arg_2, _arg_3);
                this._Str_17771 = k;
            }
        }

        public function resetRepeatableTrackingPoints(k:Int)
        {
            if (k < this._Str_2426.length)
            {
                this._Str_2426[k].resetRepeatableTrackingPoints();
            }
        }

        public function _Str_8776(k:Float):Stream
        {
            var _local_2 = 0;
            var _local_3 = 0;
            while (_local_3 < this._Str_2426.length)
            {
                _local_2 = ASCompat.toInt(_local_2 + this._Str_2426[_local_3].getDurationAsInt());
                if (_local_2 > k)
                {
                    return this._Str_2426[_local_3];
                }
                _local_3++;
            }
            return null;
        }

        public function _Str_25979(k:Float)
        {
            var _local_2= this._Str_8776(k);
            if (_local_2 != null)
            {
                _local_2.processPauseStream();
            }
        }

        public function _Str_25973(k:Int)
        {
            if (k < this._Str_2426.length)
            {
                this._Str_2426[k].processPauseStream();
            }
        }

        public function _Str_26255(k:Float)
        {
            var _local_2= this._Str_8776(k);
            if (_local_2 != null)
            {
                _local_2.processResumeStream();
            }
        }

        public function _Str_26036(k:Int)
        {
            if (k < this._Str_2426.length)
            {
                this._Str_2426[k].processResumeStream();
            }
        }

        public function _Str_26229(k:Float)
        {
            var _local_2= this._Str_8776(k);
            if (_local_2 != null)
            {
                _local_2.processStopStream();
            }
        }

        public function _Str_24894(k:Int)
        {
            if (k < this._Str_2426.length)
            {
                this._Str_2426[k].processStopStream();
            }
        }

        public function processFullScreenEvent(k:Float)
        {
            var _local_2= this._Str_8776(k);
            if (_local_2 != null)
            {
                _local_2.processFullScreenEvent();
            }
        }

        public function _Str_20593(k:Int)
        {
            if (k < this._Str_2426.length)
            {
                this._Str_2426[k].processFullScreenEvent();
            }
        }

        public function _Str_23855(k:Int)
        {
            if (k < this._Str_2426.length)
            {
                this._Str_2426[k].processFullScreenExitEvent();
            }
        }

        public function processMuteEvent(k:Float)
        {
            var _local_2= this._Str_8776(k);
            if (_local_2 != null)
            {
                _local_2.processMuteEvent();
            }
        }

        public function _Str_22938(k:Int)
        {
            if (k < this._Str_2426.length)
            {
                this._Str_2426[k].processMuteEvent();
            }
        }

        public function processUnmuteEvent(k:Float)
        {
            var _local_2= this._Str_8776(k);
            if (_local_2 != null)
            {
                _local_2.processUnmuteEvent();
            }
        }

        public function _Str_25589(k:Int)
        {
            if (k < this._Str_2426.length)
            {
                this._Str_2426[k].processUnmuteEvent();
            }
        }
    }

