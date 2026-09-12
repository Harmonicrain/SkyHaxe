package org.openvideoads.vast.model
;
    import org.openvideoads.util.NetworkResource;
    import org.openvideoads.vast.config.groupings.AdStreamerConfig;

     class AdNetworkResource extends NetworkResource 
    {
        var _Str_5061:Array<ASAny> = null;
        var _Str_9666:AdStreamerConfig = null;
        var _Str_3745:String = null;
        var _Str_14438:String = null;

        public function new(k:String=null, _arg_2:String=null, _arg_3:String=null)
        {
            super(k, _arg_2, _arg_3);
        }

        public function _Str_25939():Bool
        {
            return !(this._Str_5061 == null);
        }

        function _Str_20302():Bool
        {
            var k = 0;
            if (_Str_577 != null)
            {
                if (this._Str_9666 == null)
                {
                    if (this._Str_5061 != null)
                    {
                        k = 0;
                        while (k < this._Str_5061.length)
                        {
                            if (_Str_577.indexOf(cast(this._Str_5061[k], AdStreamerConfig).netConnectionAddress) > -1)
                            {
                                this._Str_9666 = cast(this._Str_5061[k], AdStreamerConfig);
                                return true;
                            }
                            k++;
                        }
                    }
                }
            }
            else
            {
                this._Str_9666 = null;
            }
            return false;
        }

        public var streamers(never,set):Array<ASAny>;
public function  set_streamers(k:Array<ASAny>):Array<ASAny>        {
            this._Str_5061 = k;
            this._Str_9666 = null;
return k;
        }

        override public function  get_netConnectionAddress():String
        {
            var _local_1:String = null;
            if (this._Str_14438 != null)
            {
                return this._Str_14438;
            }
            if (this._Str_20302())
            {
                return this._Str_9666.netConnectionAddress;
            }
            _local_1 = super.netConnectionAddress;
            if (_local_1 != null)
            {
                return _local_1;
            }
            return this._Str_24852();
        }

        function _Str_24852():String
        {
            var k:String = null;
            var _local_2:Array<ASAny> = null;
            if (isRTMP())
            {
                k = _Str_577.substr((_Str_577.indexOf("rtmp://") + 7));
                _local_2 = (cast k.split("/"));
                if (_local_2.length > 2)
                {
                    this._Str_14438 = ((("rtmp://" + _local_2[0]) + "/") + _local_2[1]);
                    return this._Str_14438;
                }
            }
            return null;
        }

        public function _Str_25224():String
        {
            var _local_1:String = null;
            var _local_2:Array<ASAny> = null;
            var k = 0;
            if (isRTMP())
            {
                if (this._Str_3745 == null)
                {
                    if (this._Str_20302())
                    {
                        this._Str_3745 = this._Str_9666._Str_22827(_Str_577, _Str_2230);
                    }
                    else
                    {
                        if (_Str_18045())
                        {
                            this._Str_3745 = _Str_5059("mp4:");
                        }
                        else
                        {
                            if (_Str_17691())
                            {
                                this._Str_3745 = _Str_5059("flv:");
                                this._Str_3745 = new compat.RegExp("flv:", "g").replace(this._Str_3745, "");
                            }
                            else
                            {
                                _local_1 = _Str_577.substr((_Str_577.indexOf("rtmp://") + 7));
                                _local_2 = (cast _local_1.split("/"));
                                if (_local_2.length > 2)
                                {
                                    this._Str_3745 = "";
                                    k = 2;
                                    while (k < _local_2.length)
                                    {
                                        this._Str_3745 = (this._Str_3745 + ("/" + _local_2[k]));
                                        k++;
                                    }
                                    this._Str_3745 = this._Str_3745.substr(1);
                                    if ((((isMimeType("video/x-mp4") || isMimeType("video/mp4")) || isMimeType("mp4")) || _Str_14494(".mp4")))
                                    {
                                        this._Str_3745 = ("mp4:" + this._Str_3745);
                                    }
                                    else
                                    {
                                        if ((((isMimeType("video/x-flv") || isMimeType("video/flv")) || isMimeType("flv")) || _Str_14494(".flv")))
                                        {
                                            this._Str_3745 = new compat.RegExp("\\.flv", "g").replace(this._Str_3745, "");
                                        }
                                    }
                                }
                                else
                                {
                                    this._Str_3745 = _Str_577;
                                }
                            }
                        }
                    }
                }
                return this._Str_3745;
            }
            return null;
        }
    }

