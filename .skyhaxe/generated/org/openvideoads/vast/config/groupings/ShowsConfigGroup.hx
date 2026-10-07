package org.openvideoads.vast.config.groupings
;
    import org.openvideoads.vast.config._Str_2741;
    import org.openvideoads.util.ArrayUtils;
    import org.openvideoads.vast.schedule._Str_4545;

     class ShowsConfigGroup extends AbstractStreamsConfig implements _Str_2741 
    {
        var _previewImage:String = null;
        var _Str_3402:Array<ASAny>;
        var _Str_2519:ShowsPlaylistConfigGroup = null;
        var _Str_9912:StreamTimerConfig;

        public function new(k:ASObject=null, _arg_2:_Str_2741=null)
        {
            this._Str_3402 = new Array<ASAny>();
            this._Str_9912 = new StreamTimerConfig();
            super(k, _arg_2);
        }

        override public function initialise(k:ASObject=null, _arg_2:_Str_2741=null, _arg_3:Bool=false)
        {
            _Str_3654();
            super.initialise(k, _arg_2);
            if (k != null)
            {
                if (k != null)
                {
                    if (k.preview != /*undefined*/null)
                    {
                        this._previewImage = k.preview;
                    }
                    if (k.streamTimer != /*undefined*/null)
                    {
                        this._Str_9912 = new StreamTimerConfig(k.streamTimer);
                    }
                    if (k.playlist != /*undefined*/null)
                    {
                        this._Str_2519 = new ShowsPlaylistConfigGroup(k.playlist);
                        this.streams = this._Str_2519._Str_10087();
                    }
                    else
                    {
                        if (k.streams != /*undefined*/null)
                        {
                            if (Std.is(k.streams , String))
                            {
                                this.streams = ArrayUtils._Str_8734(k.streams);
                            }
                            this.streams = k.streams;
                        }
                    }
                }
            }
            _Str_3144();
        }

        override public function isOVAConfigLoading():Bool
        {
            if (_Str_6229())
            {
                return true;
            }
            var k = 0;
            while (k < this._Str_3402.length)
            {
                if (this._Str_3402[k].isOVAConfigLoading())
                {
                    return true;
                }
                k++;
            }
            return false;
        }

        override public function mustOperateWithoutDuration():Bool
        {
            var k = 0;
            if (_Str_6569)
            {
                return true;
            }
            if (this._Str_3402 != null)
            {
                k = 0;
                while (k < this._Str_3402.length)
                {
                    if (Std.is(this._Str_3402[k] , _Str_4545))
                    {
                        if (!this._Str_3402[k].hasDuration())
                        {
                            return true;
                        }
                    }
                    else
                    {
                        if (this._Str_3402[k].duration == /*undefined*/null)
                        {
                            return true;
                        }
                        if (ASCompat.parseInt(this._Str_3402[k].duration) <= 0)
                        {
                            return true;
                        }
                    }
                    k++;
                }
            }
            return false;
        }

        public function _Str_12928():String
        {
            return this._previewImage;
        }

        public function _Str_24712():Bool
        {
            return !(this._Str_12928() == null);
        }

        public function _Str_19861():Bool
        {
            if (this._Str_9912 != null)
            {
                return this._Str_9912.enabled;
            }
            return false;
        }

        public var _Str_26331(get,never):StreamTimerConfig;
public function  get__Str_26331():StreamTimerConfig
        {
            return this._Str_9912;
        }

        public function _Str_23740():String
        {
            if (this._Str_3402.length > 0)
            {
                if (this._Str_3402[0].isLive())
                {
                    return this._Str_3402[0].filename;
                }
            }
            return null;
        }

        public function _Str_21533():Bool
        {
            return this._Str_3402.length > 0;
        }

        public function _Str_21649(k:Array<ASAny>)
        {
            this._Str_3402 = k.concat(this._Str_3402);
        }

        function _Str_24268()
        {
            var k = 0;
            if (this._Str_3402 != null)
            {
                k = 0;
                while (k < this._Str_3402.length)
                {
                    this._Str_3402[k].resolveFilename(this);
                    k++;
                }
            }
        }

        
        public var streams(get,set):Array<ASAny>;
public function  set_streams(k:Array<ASAny>):Array<ASAny>        {
            var _local_2 = 0;
            var _local_3:_Str_4545 = null;
            this._Str_3402 = new Array<ASAny>();
            if (k != null)
            {
                _local_2 = 0;
                while (_local_2 < k.length)
                {
                    _local_3 = new _Str_4545(k[_local_2].file, k[_local_2].file, ((k[_local_2].duration != /*undefined*/null) ? k[_local_2].duration : "00:00:00"), ((k[_local_2].reduceLength != /*undefined*/null) ? k[_local_2].reduceLength : false), ((k[_local_2].deliveryType != /*undefined*/null) ? k[_local_2].deliveryType : "any"), ((k[_local_2].playOnce != /*undefined*/null) ? k[_local_2].playOnce : false), ((k[_local_2].metaData != /*undefined*/null) ? k[_local_2].metaData : true), ((k[_local_2].autoPlay != /*undefined*/null) ? k[_local_2].autoPlay : true), ((k[_local_2].provider != /*undefined*/null) ? k[_local_2].provider : null), ((k[_local_2].player != /*undefined*/null) ? k[_local_2].player : this.player), ((k[_local_2].customProperties != /*undefined*/null) ? k[_local_2].customProperties : null), ((k[_local_2].type != /*undefined*/null) ? k[_local_2].type : null), ((k[_local_2].startTime != /*undefined*/null) ? k[_local_2].startTime : "00:00:00"), fireTrackingEvents);
                    this._Str_3402.push(_local_3);
                    _local_2++;
                }
                this._Str_24268();
            }
return k;
        }
public function  get_streams():Array<ASAny>
        {
            return this._Str_3402;
        }
    }

