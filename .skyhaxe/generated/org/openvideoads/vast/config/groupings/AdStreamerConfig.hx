package org.openvideoads.vast.config.groupings
;
    import org.openvideoads.base.Debuggable;
    import org.openvideoads.util.StringUtils;
    import org.openvideoads.util.ArrayUtils;

     class AdStreamerConfig extends Debuggable 
    {
        var _Str_8251:String = null;
        var _Str_4685:Array<ASAny> = null;
        var _Str_4813:Array<ASAny> = null;

        public function new(k:ASObject)
        {
            super();
            if (k != null)
            {
                this.initialise(k);
            }
        }

        public function initialise(k:ASObject)
        {
            if (k.netConnectionAddress != /*undefined*/null)
            {
                this._Str_8251 = StringUtils.trim(k.netConnectionAddress);
            }
            if (k.removeFilenameExtensions != /*undefined*/null)
            {
                if (Std.is(k.removeFilenameExtensions , Array))
                {
                    this._Str_4685 = k.removeFilenameExtensions;
                }
                else
                {
                    this._Str_4685 = ArrayUtils._Str_8734(k.removeFilenameExtensions);
                }
            }
            if (k.addFilenamePrefixes != /*undefined*/null)
            {
                if (Std.is(k.addFilenamePrefixes , Array))
                {
                    this._Str_4813 = k.addFilenamePrefixes;
                }
                else
                {
                    this._Str_4813 = ArrayUtils._Str_8734(k.addFilenamePrefixes);
                }
            }
        }

        
        public var netConnectionAddress(get,set):String;
public function  set_netConnectionAddress(k:String):String        {
            return this._Str_8251 = k;
        }
public function  get_netConnectionAddress():String
        {
            return this._Str_8251;
        }

        
        public var removeFilenameExtensions(get,set):Array<ASAny>;
public function  set_removeFilenameExtensions(k:Array<ASAny>):Array<ASAny>        {
            return this._Str_4685 = k;
        }
public function  get_removeFilenameExtensions():Array<ASAny>
        {
            return this._Str_4685;
        }

        
        public var addFilenamePrefixes(get,set):Array<ASAny>;
public function  set_addFilenamePrefixes(k:Array<ASAny>):Array<ASAny>        {
            return this._Str_4813 = k;
        }
public function  get_addFilenamePrefixes():Array<ASAny>
        {
            return this._Str_4813;
        }

        public function _Str_22827(k:String, _arg_2:String="video/x-mp4"):String
        {
            var _local_3:String = null;
            var _local_4:String = null;
            var _local_5 = 0;
            var _local_6 = 0;
            var _local_7 = 0;
            if (this._Str_8251 != null)
            {
                _local_3 = k;
                if (k.indexOf(this._Str_8251) > -1)
                {
                    _local_3 = k.substr(this._Str_8251.length);
                }
                else
                {
                    if (k.indexOf("rtmp://") <= -1)
                    {
                        _local_3 = k;
                    }
                }
                if (_local_3.charAt(0) == "/")
                {
                    _local_3 = _local_3.substr(1);
                }
                if (((!(this._Str_4685 == null)) || (!(this._Str_4813 == null))))
                {
                    _local_4 = null;
                    if (_arg_2 != null)
                    {
                        _local_4 = StringUtils.trim(_arg_2);
                        if (_local_4.indexOf("video/x-") == 0)
                        {
                            _local_4 = _local_4.substr(8);
                        }
                        else
                        {
                            if (_local_4.indexOf("video/") == 0)
                            {
                                _local_4 = _local_4.substr(6);
                            }
                        }
                    }
                    else
                    {
                        if (k.indexOf(".mp4") > -1)
                        {
                            _local_4 = "mp4";
                        }
                        else
                        {
                            if (k.indexOf(".flv") > -1)
                            {
                                _local_4 = "flv";
                            }
                        }
                    }
                    if (_local_4 != null)
                    {
                        if (this._Str_4685 != null)
                        {
                            _local_5 = 0;
                            while (_local_5 < this._Str_4685.length)
                            {
                                if (Std.is(this._Str_4685[_local_5] , String))
                                {
                                    if (StringUtils._Str_2576(this._Str_4685[_local_5], _local_4))
                                    {
                                        _local_6 = _local_3.indexOf(("." + this._Str_4685[_local_5]));
                                        if (_local_6 == -1)
                                        {
                                            _local_6 = _local_3.indexOf(("." + this._Str_4685[_local_5].toUpperCase()));
                                        }
                                        if (_local_6 > -1)
                                        {
                                            _local_3 = _local_3.substr(0, _local_6);
                                            _local_5 = this._Str_4685.length;
                                        }
                                    }
                                }
                                _local_5++;
                            }
                        }
                        if (this._Str_4813 != null)
                        {
                            _local_7 = 0;
                            while (_local_7 < this._Str_4813.length)
                            {
                                if (Std.is(this._Str_4813[_local_7] , String))
                                {
                                    if (StringUtils._Str_2576(this._Str_4813[_local_7], _local_4))
                                    {
                                        if (_local_3.toUpperCase().indexOf((this._Str_4813[_local_7].toUpperCase() + ":")) == -1)
                                        {
                                            _local_3 = ((this._Str_4813[_local_7] + ":") + _local_3);
                                            _local_7 = this._Str_4813.length;
                                        }
                                    }
                                }
                                _local_7++;
                            }
                        }
                    }
                }
            }
            return _local_3;
        }
    }

