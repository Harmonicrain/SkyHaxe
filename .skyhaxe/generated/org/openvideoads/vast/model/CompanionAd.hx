package org.openvideoads.vast.model
;
    import org.openvideoads.util.StringUtils;
    import org.openvideoads.vast.events._Str_3117;
    import org.openvideoads.vast.events._Str_3019;
    import org.openvideoads.util.ArrayUtils;

     class CompanionAd extends NonLinearVideoAd 
    {
        var _Str_13750:String = null;
        var _Str_7470:String = null;
        var _Str_13172:String = "";
        var _Str_17840:Int = -1;
        var _Str_18424:String = null;

        public function new(k:VideoAd=null)
        {
            _Str_4070 = k;
            super();
        }

        
        public var altText(get,set):String;
public function  set_altText(k:String):String        {
            return this._Str_13750 = k;
        }
public function  get_altText():String
        {
            return this._Str_13750;
        }

        
        public var _Str_8601(get,set):String;
public function  set__Str_8601(k:String):String        {
            return this._Str_7470 = k;
        }
public function  get__Str_8601():String
        {
            return this._Str_7470;
        }

        
        public var _Str_20375(get,set):Int;
public function  set__Str_20375(k:Int):Int        {
            return this._Str_17840 = k;
        }
public function  get__Str_20375():Int
        {
            return this._Str_17840;
        }

        
        public var _Str_15576(get,set):String;
public function  set__Str_15576(k:String):String        {
            return this._Str_13172 = k;
        }
public function  get__Str_15576():String
        {
            return this._Str_13172;
        }

        public function _Str_20207(k:String, _arg_2:String)
        {
            this._Str_7470 = k;
            this._Str_13172 = _arg_2;
        }

        public function _Str_24622():Bool
        {
            return !(this._Str_7470 == null);
        }

        public function _Str_21728()
        {
            this._Str_7470 = null;
        }

        public function _Str_7774():String
        {
            if (_Str_4070 != null)
            {
                return _Str_4070.uid;
            }
            return null;
        }

        public function _Str_12152(k:CompanionAd):Bool
        {
            if (k != null)
            {
                if (this == k)
                {
                    return true;
                }
                return (((k.isVAST2 && this.isVAST2) && (!(this.id == null))) && (!StringUtils.isEmpty(this.id))) && (k.id == this.id);
            }
            return false;
        }

        public function suitableForDisplayInDIV(k:ASObject):Bool
        {
            var _local_2 = false;
            var _local_3 = false;
            if (((!(k.resourceType == /*undefined*/null)) && (k.creativeType == /*undefined*/null)))
            {
                _local_3 = _Str_16909(ASCompat.toInt(k.width), ASCompat.toInt(k.height), k.resourceType);
            }
            else
            {
                if (k.index != /*undefined*/null)
                {
                    _local_3 = _Str_18832(ASCompat.toInt(k.width), ASCompat.toInt(k.height), ASCompat.toInt(k.index));
                }
                else
                {
                    if (((!(k.creativeType == /*undefined*/null)) && (!(k.resoruceType == /*undefined*/null))))
                    {
                        _local_3 = _Str_16856(ASCompat.toInt(k.width), ASCompat.toInt(k.height), k.creativeType, k.resourceType);
                    }
                    else
                    {
                        _local_3 = _Str_6420(ASCompat.toInt(k.width), ASCompat.toInt(k.height));
                    }
                }
            }
            if (_local_3)
            {
                _local_2 = true;
            }
            return _local_2;
        }

        function _Str_24602():String
        {
            var k:String = null;
            if (_Str_16651())
            {
                k = _Str_5000;
            }
            if (_Str_5569())
            {
                if (k != null)
                {
                    k = ((((((((("&clickTag=" + ASCompat.escape(this._Str_6447())) + "&") + "clickTAG=") + ASCompat.escape(this._Str_6447())) + "&") + "clicktag=") + ASCompat.escape(this._Str_6447())) + "&") + k);
                }
                else
                {
                    k = ((((((("clickTag=" + ASCompat.escape(this._Str_6447())) + "&") + "clickTAG=") + ASCompat.escape(this._Str_6447())) + "&") + "clicktag=") + ASCompat.escape(this._Str_6447()));
                }
            }
            return k;
        }

        function _Str_25358(k:Array<ASAny>, _arg_2:Bool=true):String
        {
            var _local_7 = 0;
            var _local_3= "";
            var _local_4= "";
            if (this._Str_17410())
            {
                _local_4 = (_local_4 + ((' width="' + this.width) + '"'));
            }
            if (this._Str_17902())
            {
                _local_4 = (_local_4 + ((' height="' + this.height) + '"'));
            }
            _local_3 = (((('<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"' + _local_4) + ' id="companion-') + Std.string(this.index)) + '">');
            _local_3 = (_local_3 + (('<param name="movie" value="' + url.url) + '">'));
            _local_3 = (_local_3 + '<param name="allowScriptAccess" value="always">');
            var _local_5= "";
            if (k != null)
            {
                if (k.length > 0)
                {
                    _local_7 = 0;
                    while (_local_7 < k.length)
                    {
                        if (((!(k[_local_7].name == /*undefined*/null)) && (!(k[_local_7].value == /*undefined*/null))))
                        {
                            _local_3 = (_local_3 + (((('<param name="' + k[_local_7].name) + '" value="') + k[_local_7].value) + '">'));
                            _local_5 = (_local_5 + ((((" " + k[_local_7].name) + '="') + k[_local_7].value) + '"'));
                        }
                        _local_7++;
                    }
                }
            }
            var _local_6= this._Str_24602();
            if (_arg_2)
            {
                if (_local_6 != null)
                {
                    _local_3 = (_local_3 + (('<param name="FlashVars" value="' + _local_6) + '"/>'));
                    _local_3 = (_local_3 + (((((((((('<embed name="companion-' + Std.string(this.index)) + '" src="') + url.url) + '"') + _local_4) + ' allowScriptAccess="always" allowFullScreen="true" pluginspage="http://www.macromedia.com/go/getflashplayer" flashvars="') + _local_6) + '"') + _local_5) + "></embed>"));
                }
                else
                {
                    _local_3 = (_local_3 + (((((((('<embed name="companion-' + Std.string(this.index)) + '" src="') + url.url) + '"') + _local_4) + ' allowScriptAccess="always" allowFullScreen="true" pluginspage="http://www.macromedia.com/go/getflashplayer"') + _local_5) + "></embed>"));
                }
            }
            else
            {
                if (_local_6 != null)
                {
                    _local_3 = (_local_3 + (('<param name="FlashVars" value="' + _local_6) + '"/>'));
                }
            }
            _local_3 = (_local_3 + "</object>");
            return _local_3;
        }

        public function _Str_23484(k:Array<ASAny>, _arg_2:Bool=false, _arg_3:String="companion", _arg_4:Bool=false):String
        {
            var _local_5:String = null;
            var _local_6:String = null;
            if ((((this._Str_18424 == null) || _Str_8352()) || (!(k == null))))
            {
                _local_5 = "";
                if (_Str_15494())
                {
                    if ((_Str_5569() && (!StringUtils._Str_4861(codeBlock, "<A "))))
                    {
                        _local_5 = (('<a href="' + clickThroughs[0].qualifiedHTTPUrl) + '" target="_blank">');
                        _local_5 = (_local_5 + codeBlock);
                        _local_5 = (_local_5 + "</a>");
                    }
                    else
                    {
                        _local_5 = codeBlock;
                    }
                }
                else
                {
                    if ((_Str_20097() || _Str_19521()))
                    {
                        if (_Str_5569())
                        {
                            _local_5 = (('<a href="' + clickThroughs[0].qualifiedHTTPUrl) + '" target="_blank">');
                            _local_5 = (_local_5 + (('<img src="' + url.url) + '" border="0"/>'));
                            _local_5 = (_local_5 + "</a>");
                        }
                        else
                        {
                            _local_5 = (_local_5 + (('<img src="' + url.url) + '" border="0"/>'));
                        }
                    }
                    else
                    {
                        if (isScript())
                        {
                            if (_Str_3937())
                            {
                                _local_5 = codeBlock;
                            }
                            else
                            {
                                if (_Str_4309())
                                {
                                    _local_5 = (_local_5 + (('<script type="text/javascript" src="' + url.url) + '"></script>'));
                                }
                            }
                        }
                        else
                        {
                            if (_Str_8352())
                            {
                                if (_Str_3937())
                                {
                                    _local_5 = codeBlock;
                                }
                                else
                                {
                                    _local_5 = this._Str_25358(k);
                                }
                            }
                            else
                            {
                                if (isIFrame())
                                {
                                    if (_Str_4309())
                                    {
                                        _local_6 = "";
                                        if (this._Str_17410())
                                        {
                                            _local_6 = (_local_6 + ((' width="' + this.width) + '"'));
                                        }
                                        if (this._Str_17902())
                                        {
                                            _local_6 = (_local_6 + ((' height="' + this.height) + '"'));
                                        }
                                        _local_5 = (((('<iframe src="' + url.url) + '" hspace=0 vspace=0 frameborder=0 marginheight=0 marginwidth=0 scrolling=no') + _local_6) + ">");
                                        _local_5 = (_local_5 + "   <p>Your browser does not support iframes.</p>");
                                        _local_5 = (_local_5 + "</iframe>");
                                    }
                                }
                            }
                        }
                    }
                }
                this._Str_18424 = _local_5;
            }
            return this._Str_18424;
        }

        override public function start(k:_Str_3019, _arg_2:ASAny=null)
        {
            if (k.controller.onDisplayCompanionAd(new _Str_3117(_Str_3117._Str_3831, this)))
            {
                triggerTrackingEvent(TrackingEvent.CREATIVEVIEW);
                triggerTrackingEvent(TrackingEvent.START);
            }
        }

        override public function stop(k:_Str_3019, _arg_2:ASAny=null)
        {
            if (k.controller.onHideCompanionAd(new _Str_3117(_Str_3117._Str_2703, this)))
            {
                triggerTrackingEvent(TrackingEvent.STOP);
            }
        }

        override public function clone(k:ASAny=null):ASAny
        {
            var _local_2:CompanionAd = super.clone(new CompanionAd(parentAdContainer));
            _local_2.altText = this._Str_13750;
            _local_2._Str_15576 = this._Str_13172;
            _local_2._Str_8601 = this._Str_7470;
            _local_2._Str_20375 = this._Str_17840;
            _local_2.adParameters = _Str_5000;
            return _local_2;
        }

        override public function toJSObject():ASObject
        {
            var k:ASObject = new ASObject();
            k = {
                "id":_id,
                "adId":_Str_9867,
                "uid":_uid,
                "divId":this._Str_7470,
                "altText":this._Str_13750,
                "width":_width,
                "height":_height,
                "resourceType":_Str_3532,
                "creativeType":_Str_4009,
                "codeBlock":(_Str_3937() ? codeBlock : null),
                "clickThroughs":ArrayUtils._Str_6975(_Str_3772),
                "url":(_Str_4309() ? url.url : null)
            }
;            return k;
        }
    }

