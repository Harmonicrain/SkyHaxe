package org.openvideoads.vast.schedule
;
    import org.openvideoads.vast.VASTController;
    import org.openvideoads.vast.schedule.ads.AdSchedule;
    import org.openvideoads.vast.schedule.ads.AdSlot;
    import org.openvideoads.util.Timestamp;

     class DurationlessStreamSequence extends StreamSequence 
    {
        public function new(k:VASTController=null, _arg_2:Array<ASAny>=null, _arg_3:AdSchedule=null, _arg_4:Int=-1, _arg_5:String=null, _arg_6:Int=1, _arg_7:String=null)        {
            super(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7);
        }

        override public function build(k:Array<ASAny>, _arg_2:AdSchedule, _arg_3:String=null):Int
        {
            var _local_4:AdSlot = null;
            var _local_5:Array<ASAny> = null;
            var _local_6 = 0;
            var _local_7 = 0;
            var _local_8 = 0;
            var _local_9 = 0;
            var _local_10 = 0;
            if (_arg_2._Str_19527())
            {
                _local_4 = null;
                _local_5 = _arg_2._Str_12339;
                _local_6 = -1;
                _local_7 = 0;
                while (_local_7 < _local_5.length)
                {
                    if (_local_6 != _local_5[_local_7].associatedStreamIndex)
                    {
                        if (_local_5[_local_7].isActive())
                        {
                            _local_8 = (_local_6 + 1);
                            while (((_local_8 < _local_5[_local_7].associatedStreamIndex) && (_local_8 < k.length)))
                            {
                                _Str_3329(new Stream(this, _Str_2335, _local_8, ((("show-a-" + Std.string(_local_8)) + "-") + Std.string(_Str_2426.length)), k[_local_8].id, k[_local_8].startTime, (k[_local_8].hasDuration() ? Timestamp._Str_3314(k[_local_8].duration) : "0"), (k[_local_8].hasDuration() ? Timestamp._Str_3314(k[_local_8].duration) : "0"), k[_local_8].reduceLength, (k[_local_8].hasBaseURL() ? k[_local_8].baseURL : _Str_2846), "any", "any", -1, k[_local_8].playOnce, k[_local_8].metaData, k[_local_8].autoPlay, k[_local_8].provider, k[_local_8].player, null, _local_8, false, k[_local_8].customProperties, k[_local_8].fireTrackingEvents, false, _local_4));
                                _local_6 = _local_8;
                                _local_8++;
                            }
                        }
                    }
                    if (((!_local_5[_local_7].isLinear()) && ASCompat.toBool(_local_5[_local_7].isActive())))
                    {
                        _local_5[_local_7].associatedStreamIndex = _Str_2426.length;
                    }
                    else
                    {
                        if ((ASCompat.toBool(_local_5[_local_7].isLinear()) && ASCompat.toBool(_local_5[_local_7].isActive())))
                        {
                            if (_local_5[_local_7].isPreRoll())
                            {
                            }
                            else
                            {
                                if (_local_5[_local_7].isMidRoll())
                                {
                                    _local_4 = null;
                                    if (!_local_5[_local_7].isCopy())
                                    {
                                        if (((_local_5[_local_7].associatedStreamIndex < k.length) && (!(_local_6 == _local_5[_local_7].associatedStreamIndex))))
                                        {
                                            _Str_3329(new Stream(this, _Str_2335, ASCompat.toInt(_local_5[_local_7].associatedStreamIndex), ((("show-b-" + _local_5[_local_7].associatedStreamIndex) + "-") + Std.string(_Str_2426.length)), k[ASCompat.toInt(_local_5[_local_7].associatedStreamIndex)].id, k[ASCompat.toInt(_local_5[_local_7].associatedStreamIndex)].startTime, (k[ASCompat.toInt(_local_5[_local_7].associatedStreamIndex)].hasDuration() ? Timestamp._Str_3314(k[ASCompat.toInt(_local_5[_local_7].associatedStreamIndex)].duration) : "0"), (k[ASCompat.toInt(_local_5[_local_7].associatedStreamIndex)].hasDuration() ? Timestamp._Str_3314(k[ASCompat.toInt(_local_5[_local_7].associatedStreamIndex)].duration) : "0"), k[ASCompat.toInt(_local_5[_local_7].associatedStreamIndex)].reduceLength, (k[ASCompat.toInt(_local_5[_local_7].associatedStreamIndex)].hasBaseURL() ? k[ASCompat.toInt(_local_5[_local_7].associatedStreamIndex)].baseURL : _Str_2846), "any", "any", -1, k[ASCompat.toInt(_local_5[_local_7].associatedStreamIndex)].playOnce, k[ASCompat.toInt(_local_5[_local_7].associatedStreamIndex)].metaData, k[ASCompat.toInt(_local_5[_local_7].associatedStreamIndex)].autoPlay, k[ASCompat.toInt(_local_5[_local_7].associatedStreamIndex)].provider, k[ASCompat.toInt(_local_5[_local_7].associatedStreamIndex)].player, null, ASCompat.toInt(_local_5[_local_7].associatedStreamIndex), false, k[ASCompat.toInt(_local_5[_local_7].associatedStreamIndex)].customProperties, k[ASCompat.toInt(_local_5[_local_7].associatedStreamIndex)].fireTrackingEvents, false, _local_4));
                                            _local_6 = ASCompat.toInt(_local_5[_local_7].associatedStreamIndex);
                                        }
                                    }
                                }
                                else
                                {
                                    _local_4 = null;
                                    if (k.length > 0)
                                    {
                                        if (!_local_5[_local_7].isCopy())
                                        {
                                            if (((_local_5[_local_7].associatedStreamIndex < k.length) && (!(_local_6 == _local_5[_local_7].associatedStreamIndex))))
                                            {
                                                _Str_3329(new Stream(this, _Str_2335, ASCompat.toInt(_local_5[_local_7].associatedStreamIndex), ((("show-c-" + _local_5[_local_7].associatedStreamIndex) + "-") + Std.string(_Str_2426.length)), k[ASCompat.toInt(_local_5[_local_7].associatedStreamIndex)].id, k[ASCompat.toInt(_local_5[_local_7].associatedStreamIndex)].startTime, (k[ASCompat.toInt(_local_5[_local_7].associatedStreamIndex)].hasDuration() ? Timestamp._Str_3314(k[ASCompat.toInt(_local_5[_local_7].associatedStreamIndex)].duration) : "0"), (k[ASCompat.toInt(_local_5[_local_7].associatedStreamIndex)].hasDuration() ? Timestamp._Str_3314(k[ASCompat.toInt(_local_5[_local_7].associatedStreamIndex)].duration) : "0"), k[ASCompat.toInt(_local_5[_local_7].associatedStreamIndex)].reduceLength, (k[ASCompat.toInt(_local_5[_local_7].associatedStreamIndex)].hasBaseURL() ? k[ASCompat.toInt(_local_5[_local_7].associatedStreamIndex)].baseURL : _Str_2846), "any", "any", -1, k[ASCompat.toInt(_local_5[_local_7].associatedStreamIndex)].playOnce, k[ASCompat.toInt(_local_5[_local_7].associatedStreamIndex)].metaData, k[ASCompat.toInt(_local_5[_local_7].associatedStreamIndex)].autoPlay, k[ASCompat.toInt(_local_5[_local_7].associatedStreamIndex)].provider, k[ASCompat.toInt(_local_5[_local_7].associatedStreamIndex)].player, null, ASCompat.toInt(_local_5[_local_7].associatedStreamIndex), false, k[ASCompat.toInt(_local_5[_local_7].associatedStreamIndex)].customProperties, k[ASCompat.toInt(_local_5[_local_7].associatedStreamIndex)].fireTrackingEvents, false, _local_4));
                                                _local_6 = ASCompat.toInt(_local_5[_local_7].associatedStreamIndex);
                                            }
                                        }
                                    }
                                }
                            }
                            _local_5[_local_7].streamStartTime = 0;
                            _local_5[_local_7].parent = this;
                            _Str_3329(_local_5[_local_7]);
                        }
                        else
                        {
                            _arg_2._Str_12339[_local_7].associatedStreamStartTime = "00:00:00";
                        }
                    }
                    _local_7++;
                }
                if ((_local_6 + 1) < k.length)
                {
                    _local_9 = (_local_6 + 1);
                    while (_local_9 < k.length)
                    {
                        _Str_3329(new Stream(this, _Str_2335, _local_9, ("show-d-" + Std.string(_local_9)), k[_local_9].id, k[_local_9].startTime, (k[_local_9].hasDuration() ? Timestamp._Str_3314(k[_local_9].duration) : "0"), (k[_local_9].hasDuration() ? Timestamp._Str_3314(k[_local_9].duration) : "0"), k[_local_9].reduceLength, (k[_local_9].hasBaseURL() ? k[_local_9].baseURL : _Str_2846), "any", "any", -1, k[_local_9].playOnce, k[_local_9].metaData, k[_local_9].autoPlay, k[_local_9].provider, k[_local_9].player, null, _local_9, false, k[_local_9].customProperties, k[_local_9].fireTrackingEvents, false, _local_4));
                        _local_9++;
                    }
                }
            }
            else
            {
                _local_10 = 0;
                while (_local_10 < k.length)
                {
                    _Str_3329(new Stream(this, _Str_2335, _local_10, ("show-e-" + Std.string(_local_10)), k[_local_10].id, k[_local_10].startTime, (k[_local_10].hasDuration() ? Timestamp._Str_3314(k[_local_10].duration) : "0"), (k[_local_10].hasDuration() ? Timestamp._Str_3314(k[_local_10].duration) : "0"), k[_local_10].reduceLength, (k[_local_10].hasBaseURL() ? k[_local_10].baseURL : _Str_2846), "any", "any", -1, k[_local_10].playOnce, k[_local_10].metaData, k[_local_10].autoPlay, k[_local_10].provider, k[_local_10].player, null, _local_10, false, k[_local_10].customProperties, k[_local_10].fireTrackingEvents, false, _local_4));
                    _local_10++;
                }
            }
            if (((!(_arg_3 == null)) && (_Str_2426.length > 0)))
            {
                _Str_2426[0].previewImage = _arg_3;
            }
            _Str_17615();
            return -1;
        }
    }

