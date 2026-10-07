package org.openvideoads.vast.model
;
    import org.openvideoads.util.Timestamp;

     class LinearVideoAd extends TrackedVideoAd 
    {
        var _Str_2467:String;
        var _Str_2409:Array<ASAny>;
        var _Str_3645:MediaFile = null;

        public function new()
        {
            this._Str_2409 = new Array<ASAny>();
            super();
        }

        override public function unload()
        {
            var k = 0;
            if (this._Str_20050())
            {
                k = 0;
                while (k < this._Str_2409.length)
                {
                    this._Str_2409[k].unload();
                    k++;
                }
            }
        }

        public override function  set_duration(k:String):String        {
            return this._Str_2467 = k;
        }

        override public function  get_duration():String
        {
            return this._Str_2467;
        }

        public function _Str_24711(k:Int)
        {
            this._Str_2467 = Timestamp._Str_4110(k);
        }

        public function _Str_20050():Bool
        {
            if (this._Str_2409 == null)
            {
                return false;
            }
            return this._Str_2409.length > 0;
        }

        public function _Str_26164():Int
        {
            if (this._Str_20050())
            {
                return this._Str_2409.length;
            }
            return 0;
        }

        
        public var mediaFiles(get,set):Array<ASAny>;
public function  set_mediaFiles(k:Array<ASAny>):Array<ASAny>        {
            return this._Str_2409 = k;
        }
public function  get_mediaFiles():Array<ASAny>
        {
            return this._Str_2409;
        }

        public function _Str_26332():MediaFile
        {
            return this._Str_3645;
        }

        public function filterLinearAdMediaFileByMimeType(k:Array<ASAny>)
        {
            var _local_3:Array<ASAny> = null;
            var _local_2 = 0;
            while (_local_2 < this._Str_2409.length)
            {
                if (this._Str_2409[_local_2].isPermittedMimeType(k) == false)
                {
                    _local_3 = this._Str_2409.splice(_local_2, 1);
                }
                else
                {
                    _local_2++;
                }
            }
        }

        public function _Str_19374(k:MediaFile)
        {
            var _local_2:Array<ASAny> = null;
            if (k._parser4())
            {
                _local_2 = [k];
                this._Str_2409 = _local_2.concat(this._Str_2409);
            }
            else
            {
                this._Str_2409.push(k);
            }
        }

        public function isEmpty():Bool
        {
            return this._Str_2409.length == 0;
        }

        public function _Str_25352(k:String, _arg_2:ASAny="any", _arg_3:ASAny=-1, _arg_4:Int=-1, _arg_5:Int=-1, _arg_6:Bool=false):MediaFile
        {
            var _local_7:MediaFile = null;
            var _local_8 = 0;
            var _local_9 = 0;
            var _local_10 = 0;
            var _local_11 = 0;
            var _local_12 = 0;
            var _local_13:Array<ASAny> = null;
            if (((!(this._Str_2409 == null)) && (this._Str_2409.length > 0)))
            {
                _local_7 = null;
                _local_8 = -1;
                _local_9 = -1;
                _local_10 = -1;
                _local_11 = -1;
                if ((Std.is(_arg_3 , String) && (!(_arg_3 == null))))
                {
                    if (_arg_3.indexOf("-") > -1)
                    {
                        _local_13 = (cast ASCompat.toString(_arg_3).split("-"));
                        if (_local_13.length == 2)
                        {
                            _local_10 = ASCompat.parseInt(_local_13[0]);
                            _local_11 = ASCompat.parseInt(_local_13[1]);
                        }
                    }
                    else
                    {
                        _local_10 = (_local_11 = ASCompat.parseInt(_arg_3));
                    }
                }
                _local_12 = 0;
                while (_local_12 < this._Str_2409.length)
                {
                    if ((ASCompat.toBool(this._Str_2409[_local_12].isDeliveryType(k)) && ASCompat.toBool(this._Str_2409[_local_12].isMimeType(_arg_2))))
                    {
                        if ((ASCompat.toBool(this._Str_2409[_local_12].hasBitRate()) && (_local_10 > -1)))
                        {
                            if (!((_local_10 <= this._Str_2409[_local_12].bitRate) && (this._Str_2409[_local_12].bitRate <= _local_11))) {_local_12++;continue;};
                        }
                        if (((_arg_4 == -1) && (_arg_5 == -1)))
                        {
                            _local_7 = this._Str_2409[_local_12];
                            _local_12 = this._Str_2409.length;
                        }
                        else
                        {
                            if (_arg_4 > -1)
                            {
                                if (((_local_8 == -1) || (Math.abs(ASCompat.toNumber(_arg_4 - ASCompat.toNumber(this._Str_2409[_local_12].width))) < _local_8)))
                                {
                                    if (_arg_5 > -1)
                                    {
                                        if (((_local_9 == -1) || (Math.abs(ASCompat.toNumber(_arg_5 - ASCompat.toNumber(this._Str_2409[_local_12].height))) < _local_9)))
                                        {
                                            _local_7 = this._Str_2409[_local_12];
                                            _local_9 = Std.int(Math.abs(ASCompat.toNumber(_arg_5 - ASCompat.toNumber(this._Str_2409[_local_12].height))));
                                            _local_8 = Std.int(Math.abs(ASCompat.toNumber(_arg_4 - ASCompat.toNumber(this._Str_2409[_local_12].width))));
                                        }
                                    }
                                    else
                                    {
                                        _local_7 = this._Str_2409[_local_12];
                                        _local_8 = Std.int(Math.abs(ASCompat.toNumber(_arg_4 - ASCompat.toNumber(this._Str_2409[_local_12].width))));
                                    }
                                }
                            }
                            else
                            {
                                if (((_local_9 == -1) || (Math.abs(ASCompat.toNumber(_arg_5 - ASCompat.toNumber(this._Str_2409[_local_12].height))) < _local_9)))
                                {
                                    _local_7 = this._Str_2409[_local_12];
                                    _local_9 = Std.int(Math.abs(ASCompat.toNumber(_arg_5 - ASCompat.toNumber(this._Str_2409[_local_12].height))));
                                }
                            }
                        }
                    }
_local_12++;
                }
                if (_local_7 != null)
                {
                }
                return _local_7;
            }
            return null;
        }

        public function _Str_25560(k:String, _arg_2:ASAny="any", _arg_3:Int=-1, _arg_4:Int=-1, _arg_5:Bool=false):MediaFile
        {
            var _local_7 = 0;
            var _local_8 = 0;
            var _local_6:MediaFile = null;
            if (((!(this._Str_2409 == null)) && (this._Str_2409.length > 0)))
            {
                _local_7 = 99999999;
                _local_8 = 0;
                while (_local_8 < this._Str_2409.length)
                {
                    if (((_arg_3 == -1) && (_arg_4 == -1)))
                    {
                        if (this._Str_2409[_local_8].bitRate < _local_7)
                        {
                            _local_6 = this._Str_2409[_local_8];
                            _local_7 = ASCompat.toInt(this._Str_2409[_local_8].bitRate);
                        }
                    }
                    else
                    {
                        if (((_arg_3 == -1) && (_arg_4 > -1)))
                        {
                            if (_arg_4 == this._Str_2409[_local_8].height)
                            {
                                if (this._Str_2409[_local_8].bitRate < _local_7)
                                {
                                    _local_6 = this._Str_2409[_local_8];
                                    _local_7 = ASCompat.toInt(this._Str_2409[_local_8].bitRate);
                                }
                            }
                        }
                        else
                        {
                            if (((_arg_3 > -1) && (this._Str_2409[_local_8].width == _arg_3)))
                            {
                                if (this._Str_2409[_local_8].bitRate < _local_7)
                                {
                                    _local_6 = this._Str_2409[_local_8];
                                    _local_7 = ASCompat.toInt(this._Str_2409[_local_8].bitRate);
                                }
                            }
                        }
                    }
                    _local_8++;
                }
            }
            if (_local_6 != null)
            {
            }
            return _local_6;
        }

        public function _Str_25491(k:String, _arg_2:ASAny="any", _arg_3:Int=-1, _arg_4:Int=-1, _arg_5:Bool=false):MediaFile
        {
            var _local_7 = 0;
            var _local_8 = 0;
            var _local_6:MediaFile = null;
            if (((!(this._Str_2409 == null)) && (this._Str_2409.length > 0)))
            {
                _local_7 = -1;
                _local_8 = 0;
                while (_local_8 < this._Str_2409.length)
                {
                    if (((_arg_3 == -1) && (_arg_4 == -1)))
                    {
                        if (this._Str_2409[_local_8].bitRate > _local_7)
                        {
                            _local_6 = this._Str_2409[_local_8];
                            _local_7 = ASCompat.toInt(this._Str_2409[_local_8].bitRate);
                        }
                    }
                    else
                    {
                        if (((_arg_3 == -1) && (_arg_4 > -1)))
                        {
                            if (_arg_4 == this._Str_2409[_local_8].height)
                            {
                                if (this._Str_2409[_local_8].bitRate > _local_7)
                                {
                                    _local_6 = this._Str_2409[_local_8];
                                    _local_7 = ASCompat.toInt(this._Str_2409[_local_8].bitRate);
                                }
                            }
                        }
                        else
                        {
                            if (((_arg_3 > -1) && (this._Str_2409[_local_8].width == _arg_3)))
                            {
                                if (this._Str_2409[_local_8].bitRate > _local_7)
                                {
                                    _local_6 = this._Str_2409[_local_8];
                                    _local_7 = ASCompat.toInt(this._Str_2409[_local_8].bitRate);
                                }
                            }
                        }
                    }
                    _local_8++;
                }
            }
            if (_local_6 != null)
            {
            }
            return _local_6;
        }

        public function _Str_22640(k:String, _arg_2:ASAny="any", _arg_3:Int=-1, _arg_4:Int=-1, _arg_5:Bool=false):MediaFile
        {
            var _local_7 = 0;
            var _local_8 = 0;
            var _local_9:Array<ASAny> = null;
            var _local_10 = 0;
            var _local_11 = 0;
            var _local_12 = 0;
            var _local_6:MediaFile = null;
            if (((!(this._Str_2409 == null)) && (this._Str_2409.length > 0)))
            {
                _local_7 = -1;
                _local_8 = 9999999;
                _local_9 = new Array<ASAny>();
                _local_10 = 0;
                while (_local_10 < this._Str_2409.length)
                {
                    if (((_arg_3 == -1) && (_arg_4 == -1)))
                    {
                        if (this._Str_2409[_local_10].bitRate > _local_7)
                        {
                            _local_7 = ASCompat.toInt(this._Str_2409[_local_10].bitRate);
                            _local_6 = this._Str_2409[_local_10];
                        }
                        if (this._Str_2409[_local_10].bitRate < _local_8)
                        {
                            _local_8 = ASCompat.toInt(this._Str_2409[_local_10].bitRate);
                        }
                        _local_9.push(_local_10);
                    }
                    else
                    {
                        if (((_arg_3 == -1) && (_arg_4 > -1)))
                        {
                            if (_arg_4 == this._Str_2409[_local_10].height)
                            {
                                if (this._Str_2409[_local_10].bitRate > _local_7)
                                {
                                    _local_7 = ASCompat.toInt(this._Str_2409[_local_10].bitRate);
                                    _local_6 = this._Str_2409[_local_10];
                                }
                                if (this._Str_2409[_local_10].bitRate < _local_8)
                                {
                                    _local_8 = ASCompat.toInt(this._Str_2409[_local_10].bitRate);
                                }
                                _local_9.push(_local_10);
                            }
                        }
                        else
                        {
                            if (((_arg_3 > -1) && (this._Str_2409[_local_10].width == _arg_3)))
                            {
                                if (this._Str_2409[_local_10].bitRate > _local_7)
                                {
                                    _local_7 = ASCompat.toInt(this._Str_2409[_local_10].bitRate);
                                    _local_6 = this._Str_2409[_local_10];
                                }
                                if (this._Str_2409[_local_10].bitRate < _local_8)
                                {
                                    _local_8 = ASCompat.toInt(this._Str_2409[_local_10].bitRate);
                                }
                                _local_9.push(_local_10);
                            }
                        }
                    }
                    _local_10++;
                }
                if (((_local_7 > -1) && (_local_8 < 9999999)))
                {
                    _local_11 = Std.int(_local_8 + ((_local_7 - _local_8) / 2));
                    _local_12 = 0;
                    while (_local_12 < _local_9.length)
                    {
                        if (((this._Str_2409[ASCompat.toInt(_local_9[_local_12])].bitRate > _local_8) && (this._Str_2409[ASCompat.toInt(_local_9[_local_12])].bitRate <= _local_11)))
                        {
                            if ((((_local_11 - _local_6.bitRate) < 0) || ((_local_11 - ASCompat.toNumber(this._Str_2409[ASCompat.toInt(_local_9[_local_12])].bitRate)) < (_local_11 - _local_6.bitRate))))
                            {
                                _local_6 = this._Str_2409[ASCompat.toInt(_local_9[_local_12])];
                            }
                            else
                            {
                                _local_6 = this._Str_2409[ASCompat.toInt(_local_9[_local_12])];
                            }
                        }
                        _local_12++;
                    }
                }
            }
            if (_local_6 != null)
            {
            }
            return _local_6;
        }

        public function _Str_17936(k:String, _arg_2:ASAny="any", _arg_3:ASAny=-1, _arg_4:Int=-1, _arg_5:Int=-1, _arg_6:Bool=false):MediaFile
        {
            return this._Str_25352(k, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        public function _Str_10510(k:String, _arg_2:ASAny="any", _arg_3:ASAny=-1, _arg_4:Int=-1, _arg_5:Int=-1, _arg_6:Bool=false):MediaFile
        {
            var _local_7:MediaFile = null;
            if ((Std.is(_arg_3 , String) && (!(_arg_3 == null))))
            {
                _local_7 = null;
                if (_arg_3 != null)
                {
                    switch (_arg_3.toUpperCase())
                    {
                        case "HIGH":
                            return this._Str_25491(k, _arg_2, _arg_4, _arg_5);
                        case "MEDIUM":
                            return this._Str_22640(k, _arg_2, _arg_4, _arg_5);
                        case "LOW":
                            return this._Str_25560(k, _arg_2, _arg_4, _arg_5);
                        default:
                            return this._Str_17936(k, _arg_2, _arg_3, _arg_4, _arg_5);
                    }
                }
                return this._Str_17936(k, _arg_2, -1, _arg_4, _arg_5);
            }
            return this._Str_17936(k, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        public function getStreamToPlay(k:String, _arg_2:ASAny="any", _arg_3:ASAny=-1, _arg_4:Int=-1, _arg_5:Int=-1, _arg_6:Bool=false):AdNetworkResource
        {
            var _local_7:MediaFile = null;
            if (this._Str_3645 == null)
            {
                _local_7 = this._Str_10510(k, _arg_2, _arg_3, _arg_4, _arg_5);
                if (_arg_6)
                {
                    this._Str_3645 = _local_7;
                }
                else
                {
                    if (_local_7 != null)
                    {
                        return _local_7.url;
                    }
                }
            }
            if (this._Str_3645 != null)
            {
                return this._Str_3645.url;
            }
            return null;
        }

        public function canScale(k:String, _arg_2:ASAny="any", _arg_3:ASAny=-1, _arg_4:Int=-1, _arg_5:Int=-1, _arg_6:Bool=false):Bool
        {
            var _local_7:MediaFile = null;
            if (this._Str_3645 == null)
            {
                _local_7 = this._Str_10510(k, _arg_2, _arg_3, _arg_4, _arg_5);
                if (_arg_6)
                {
                    this._Str_3645 = _local_7;
                }
                else
                {
                    if (_local_7 != null)
                    {
                        return _local_7.scale;
                    }
                }
            }
            if (this._Str_3645 != null)
            {
                return this._Str_3645.scale;
            }
            return false;
        }

        public function shouldMaintainAspectRatio(k:String, _arg_2:ASAny="any", _arg_3:ASAny=-1, _arg_4:Int=-1, _arg_5:Int=-1, _arg_6:Bool=false):Bool
        {
            var _local_7:MediaFile = null;
            if (this._Str_3645 == null)
            {
                _local_7 = this._Str_10510(k, _arg_2, _arg_3, _arg_4, _arg_5);
                if (_arg_6)
                {
                    this._Str_3645 = _local_7;
                }
                else
                {
                    if (_local_7 != null)
                    {
                        return _local_7.maintainAspectRatio;
                    }
                }
            }
            if (this._Str_3645 != null)
            {
                return this._Str_3645.maintainAspectRatio;
            }
            return true;
        }

        public function isInteractive(k:String, _arg_2:ASAny="any", _arg_3:ASAny=-1, _arg_4:Int=-1, _arg_5:Int=-1, _arg_6:Bool=false):Bool
        {
            var _local_7:MediaFile = null;
            if (this._Str_3645 == null)
            {
                _local_7 = this._Str_10510(k, _arg_2, _arg_3, _arg_4, _arg_5);
                if (_arg_6)
                {
                    this._Str_3645 = _local_7;
                }
                else
                {
                    if (_local_7 != null)
                    {
                        return _local_7.isInteractive();
                    }
                }
            }
            if (this._Str_3645 != null)
            {
                return this._Str_3645.isInteractive();
            }
            return false;
        }

        public function _Str_26132()
        {
            this._Str_3645 = null;
        }

        public function clicked()
        {
            triggerTrackingEvent(TrackingEvent.ACCEPTINVITATION);
            fireClickTracking();
        }

        function _Str_23930():Array<ASAny>
        {
            var _local_2 = 0;
            var k= new Array<ASAny>();
            if (this._Str_2409 != null)
            {
                _local_2 = 0;
                while (_local_2 < this._Str_2409.length)
                {
                    k.push(this._Str_2409[_local_2].toJSObject());
                    _local_2++;
                }
            }
            return k;
        }

        override public function toJSObject():ASObject
        {
            var k:ASObject = super.toJSObject();
            k.duration = this._Str_2467;
            k.mediaFiles = this._Str_23930();
            return k;
        }
    }

