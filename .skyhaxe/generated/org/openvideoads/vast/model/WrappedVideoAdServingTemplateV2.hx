package org.openvideoads.vast.model
;
    import org.openvideoads.vast.server.config.AdServerConfig;
    import org.openvideoads.vast.server.request.wrapped._Str_6140;
    import org.openvideoads.vast.server.response.AdServerTemplate;
    import flash.events.Event;
    import org.openvideoads.vast.server.request.AdServerRequest;
    import org.openvideoads.util.StringUtils;
    import flash.events.*;

     class WrappedVideoAdServingTemplateV2 extends VideoAdServingTemplate 
    {
        var _Str_5185:String = null;
        var _Str_8143:ASObject = null;
        var _Str_5787:VideoAdServingTemplate;
        var _id:String = null;
        var _Str_6606:String = null;
        var _Str_25531:Array<ASAny>;
        var _Str_3421:Array<ASAny>;
        var _Str_6810:Array<ASAny>;
        var _Str_13427:Array<ASAny>;

        public function new(k:Int, _arg_2:String=null, _arg_3:com.sulake.core.utils.xml.XML=null, _arg_4:VideoAdServingTemplate=null)
        {
            this._Str_25531 = new Array<ASAny>();
            this._Str_3421 = new Array<ASAny>();
            this._Str_6810 = new Array<ASAny>();
            this._Str_13427 = new Array<ASAny>();
            super(_arg_4, null);
            this._Str_5787 = _arg_4;
            this._Str_8143 = _arg_2;
            if (_arg_3 != null)
            {
                this.initialise(k, _arg_3, _arg_2);
            }
        }

        function initialise(k:Int, _arg_2:com.sulake.core.utils.xml.XML, _arg_3:String)
        {
            var _local_4:AdServerConfig = null;
            this.id = ASCompat.xmlListToString(_arg_2.child("adId"));
            this.adSystem = ASCompat.xmlListToString(_arg_2.child("AdSystem"));
            if (_arg_2.child("VASTAdTagURI" )!= /*undefined*/null)
            {
                this._Str_6281 = ASCompat.xmlListToString(_arg_2.child("VASTAdTagURI").text());
            }
            else
            {
                if (_arg_2.child("VASTAdTagURL" )!= /*undefined*/null)
                {
                    if (_arg_2.child("VASTAdTagURL").child("URL" )!= /*undefined*/null)
                    {
                        this._Str_6281 = ASCompat.xmlListToString(_arg_2.child("VASTAdTagURL").child("URL").text());
                    }
                    else
                    {
                        this._Str_6281 = ASCompat.xmlListToString(_arg_2.child("VASTAdTagURL").text());
                    }
                }
            }
            this._Str_13427 = parseInlineAd_V2(k, _arg_3, _arg_2);
            this._Str_23805();
            if (this._Str_17688())
            {
                _local_4 = null;
                if (this._Str_5787 != null)
                {
                    this._Str_5787._Str_15107(_uid);
                    _local_4 = this._Str_5787._Str_18666();
                }
                load(new _Str_6140(this._Str_6281, _local_4));
            }
        }

        override public function hasAds(k:Bool=false):Bool
        {
            if (_Str_2518 == null)
            {
                return false;
            }
            return ((_Str_2518.length + this._Str_3421.length) + this._Str_6810.length) > 0;
        }

        override public function onTemplateLoaded(k:AdServerTemplate)
        {
            _Str_2518 = k.getMergedAds();
            _Str_6919(k.uid);
        }

        override public function onTemplateLoadError(k:Event)
        {
            this._Str_5787._Str_6067(uid, k);
        }

        override function templateLoaded(k:Event)
        {
            _Str_6188 = _Str_3081.data;
            _Str_15022(_Str_6188);
            _Str_17582();
            _Str_6919(_uid);
        }

        override function errorHandler(k:Event)
        {
            this._Str_5787._Str_6067(uid, k);
        }

        override public function onAdCallStarted(k:AdServerRequest)
        {
            this._Str_5787.onAdCallStarted(k);
        }

        override public function onAdCallFailover(k:AdServerRequest, _arg_2:AdServerRequest)
        {
            this._Str_5787.onAdCallFailover(k, _arg_2);
        }

        override public function onAdCallComplete(k:AdServerRequest, _arg_2:Bool)
        {
            this._Str_5787.onAdCallComplete(k, _arg_2);
        }

        function _Str_23712(k:Array<ASAny>):Int
        {
            var _local_2 = 0;
            if (k != null)
            {
                _local_2 = 0;
                while (_local_2 < k.length)
                {
                    if (k[_local_2] != null)
                    {
                        if (k[_local_2].isLinear())
                        {
                            return _local_2;
                        }
                    }
                    _local_2++;
                }
            }
            return -1;
        }

        function _Str_25647(k:Array<ASAny>):Int
        {
            var _local_2 = 0;
            if (k != null)
            {
                _local_2 = 0;
                while (_local_2 < k.length)
                {
                    if (k[_local_2] != null)
                    {
                        if (k[_local_2].isNonLinear())
                        {
                            return _local_2;
                        }
                    }
                    _local_2++;
                }
            }
            return -1;
        }

        function _Str_23548(k:Array<ASAny>):Int
        {
            var _local_2 = 0;
            if (k != null)
            {
                _local_2 = 0;
                while (_local_2 < k.length)
                {
                    if (k[_local_2] != null)
                    {
                        if (k[_local_2].isCompanionOnlyAd())
                        {
                            return _local_2;
                        }
                    }
                    _local_2++;
                }
            }
            return -1;
        }

        function _Str_23805()
        {
            var k = 0;
            if (_Str_2518 != null)
            {
                this._Str_3421 = new Array<ASAny>();
                this._Str_6810 = new Array<ASAny>();
                k = 0;
                while (k < _Str_2518.length)
                {
                    if (_Str_2518[k].isWrapperTemplateAd())
                    {
                        this._Str_3421.push(_Str_2518[k]);
                    }
                    else
                    {
                        this._Str_6810.push(_Str_2518[k]);
                    }
                    k++;
                }
                this._Str_3421 = (this._Str_3421 : ASAny).reverse();
                this._Str_6810 = (this._Str_6810 : ASAny).reverse();
            }
            _Str_2518 = new Array<ASAny>();
        }

        override public function getMergedAds():Array<ASAny>
        {
            var _local_3 = 0;
            var _local_4:VideoAd = null;
            var _local_5 = 0;
            var k= new Array<ASAny>();
            if (this._Str_3421 != null)
            {
                _local_4 = null;
                _local_5 = 0;
                while (_local_5 < this._Str_3421.length)
                {
                    if (this._Str_3421[_local_5].isLinear())
                    {
                        _local_3 = this._Str_23712(_Str_2518);
                        if (_local_3 > -1)
                        {
                            _local_4 = this._Str_3421[_local_5].injectAllTrackingData(_Str_2518[_local_3]);
                            if ((((!(_local_4 == null)) && (cast(_Str_2518[_local_3], VideoAd).hasCompanionAds() == false)) && cast(this._Str_3421[_local_5], VideoAd).hasCompanionAds()))
                            {
                                _local_4._Str_21998(cast(this._Str_3421[_local_5], VideoAd).companionAds);
                            }
                            k.push(_local_4);
                            _Str_2518[_local_3] = null;
                        }
                        else
                        {
                            k.push(this._Str_3421[_local_5]);
                        }
                    }
                    else
                    {
                        if (this._Str_3421[_local_5].isNonLinear())
                        {
                            _local_3 = this._Str_25647(_Str_2518);
                            if (_local_3 > -1)
                            {
                                _local_4 = this._Str_3421[_local_5].injectAllTrackingData(_Str_2518[_local_3]);
                                if ((((!(_local_4 == null)) && (cast(_Str_2518[_local_3], VideoAd).hasCompanionAds() == false)) && cast(this._Str_3421[_local_5], VideoAd).hasCompanionAds()))
                                {
                                    _local_4._Str_21998(cast(this._Str_3421[_local_5], VideoAd).companionAds);
                                }
                                k.push(_local_4);
                                _Str_2518[_local_3] = null;
                            }
                            else
                            {
                                k.push(this._Str_3421[_local_5]);
                            }
                        }
                        else
                        {
                            if (cast(this._Str_3421[_local_5], VideoAd).isCompanionOnlyAd())
                            {
                                _local_3 = this._Str_23548(_Str_2518);
                                if (_local_3 > -1)
                                {
                                    k.push(this._Str_3421[_local_5].injectAllTrackingData(_Str_2518[_local_3]));
                                    _Str_2518[_local_3] = null;
                                }
                            }
                            else
                            {
                                k.push(this._Str_3421[_local_5]);
                            }
                        }
                    }
                    _local_5++;
                }
            }
            var _local_2 = 0;
            while (_local_2 < _Str_2518.length)
            {
                if (_Str_2518[_local_2] != null)
                {
                    if (this._Str_13427.length > 0)
                    {
                        _Str_2518[_local_2].addImpressions(this._Str_13427);
                    }
                    k.push(_Str_2518[_local_2]);
                }
                _local_2++;
            }
            if (this._Str_6810 != null)
            {
                k = k.concat(this._Str_6810);
            }
            return k;
        }

        
        public var id(get,set):String;
public function  set_id(k:String):String        {
            this._id = this.id;
return k;
        }
public function  get_id():String
        {
            return this._id;
        }

        
        public var adSystem(get,set):String;
public function  set_adSystem(k:String):String        {
            return this._Str_6606 = k;
        }
public function  get_adSystem():String
        {
            return this._Str_6606;
        }

        
        public var _Str_6281(get,set):String;
public function  set__Str_6281(k:String):String        {
            return this._Str_5185 = k;
        }
public function  get__Str_6281():String
        {
            return this._Str_5185;
        }

        public function _Str_17688():Bool
        {
            return (!(this._Str_5185 == null)) && (StringUtils.isEmpty(this._Str_5185) == false);
        }

        override function createVideoAd_V2(k:String, _arg_2:com.sulake.core.utils.xml.XML, _arg_3:String, _arg_4:String, _arg_5:String, _arg_6:String, _arg_7:String):VideoAd
        {
            return super.createVideoAd_V2(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7);
        }
    }

