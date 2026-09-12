package org.openvideoads.vast.model
;
    import org.openvideoads.util.NetworkResource;
    import org.openvideoads.vast.config.groupings.AdSlotRegionConfig;
    import org.openvideoads.util.StringUtils;
    import org.openvideoads.vast.events._Str_2833;
    import org.openvideoads.vast.events._Str_3019;

     class NonLinearVideoAd extends TrackedVideoAd 
    {
        var _width:Int = -1;
        var _height:Int = -1;
        var _Str_5165:Int = -1;
        var _Str_5160:Int = -1;
        var _Str_3532:String;
        var _Str_4009:String;
        var _Str_4949:String;
        var _Str_577:NetworkResource;
        var _Str_3366:String;
        var _Str_5280:Array<ASAny>;
        var _Str_9031:AdSlotRegionConfig = null;
        var _Str_26030:Float = -1;
        var _Str_26041:Float = -1;
        var _Str_4218:Bool = false;
        var _Str_5000:String = null;

        public function new()
        {
            this._Str_5280 = new Array<ASAny>();
            super();
        }

        override public function unload()
        {
            var k = 0;
            super.unload();
            if (this._Str_20657())
            {
                k = 0;
                while (k < this._Str_5280.length)
                {
                    cast(this._Str_5280[k], NetworkResource).close();
                    k++;
                }
            }
        }

        public function _Str_25923(k:Array<ASAny>):Bool
        {
            if (this._Str_4009 == null)
            {
                return true;
            }
            var _local_2 = 0;
            while (_local_2 < k.length)
            {
                if (StringUtils._Str_2576(this._Str_4009, k[_local_2]))
                {
                    return true;
                }
                _local_2++;
            }
            return false;
        }

        
        public var width(get,set):Int;
public function  set_width(k:ASAny):Int        {
            if (ASCompat.typeOf(k) == "string")
            {
                this._width = ASCompat.parseInt(k);
            }
            else
            {
                this._width = ASCompat.toInt(k);
            }
return ASCompat.toInt(k);
        }
public function  get_width():Int
        {
            return this._width;
        }

        public function _Str_17410():Bool
        {
            return this._width > -1;
        }

        
        public var height(get,set):Int;
public function  set_height(k:ASAny):Int        {
            if (ASCompat.typeOf(k) == "string")
            {
                this._height = ASCompat.parseInt(k);
            }
            else
            {
                this._height = ASCompat.toInt(k);
            }
return ASCompat.toInt(k);
        }
public function  get_height():Int
        {
            return this._height;
        }

        public function _Str_17902():Bool
        {
            return this._height > -1;
        }

        
        public var expandedWidth(get,set):Int;
public function  set_expandedWidth(k:ASAny):Int        {
            if (ASCompat.typeOf(k) == "string")
            {
                this._Str_5165 = ASCompat.parseInt(k);
            }
            else
            {
                this._Str_5165 = ASCompat.toInt(k);
            }
return ASCompat.toInt(k);
        }
public function  get_expandedWidth():Int
        {
            return this._Str_5165;
        }

        public function _Str_23123():Bool
        {
            return this._Str_5165 > -1;
        }

        
        public var expandedHeight(get,set):Int;
public function  set_expandedHeight(k:ASAny):Int        {
            if (ASCompat.typeOf(k) == "string")
            {
                this._Str_5160 = ASCompat.parseInt(k);
            }
            else
            {
                this._Str_5160 = ASCompat.toInt(k);
            }
return ASCompat.toInt(k);
        }
public function  get_expandedHeight():Int
        {
            return this._Str_5160;
        }

        public function _Str_22467():Bool
        {
            return this._Str_5160 > -1;
        }

        public function _Str_16096():Bool
        {
            return this._Str_23123() && this._Str_22467();
        }

        public function _Str_3654()
        {
            this._Str_4218 = false;
        }

        public function _Str_3144()
        {
            this._Str_4218 = true;
        }

        public var loaded(get,never):Bool;
public function  get_loaded():Bool
        {
            return this._Str_4218;
        }

        
        public var resourceType(get,set):String;
public function  set_resourceType(k:String):String        {
            this._Str_3532 = ((k != null) ? k.toUpperCase() : k);
return k;
        }
public function  get_resourceType():String
        {
            return this._Str_3532;
        }

        
        public var creativeType(get,set):String;
public function  set_creativeType(k:String):String        {
            this._Str_4009 = ((k != null) ? k.toUpperCase() : k);
return k;
        }
public function  get_creativeType():String
        {
            var k = 0;
            if (this._Str_4009 != null)
            {
                k = this._Str_4009.indexOf("/");
                if (((k > -1) && ((k + 1) < this._Str_4009.length)))
                {
                    return this._Str_4009.substr((k + 1));
                }
            }
            return this._Str_4009;
        }

        public var _Str_26441(get,never):String;
public function  get__Str_26441():String
        {
            return this._Str_4009;
        }

        public function _Str_24710():Bool
        {
            return !(this._Str_4009 == null);
        }

        
        public var apiFramework(get,set):String;
public function  set_apiFramework(k:String):String        {
            return this._Str_4949 = k;
        }
public function  get_apiFramework():String
        {
            return this._Str_4949;
        }

        public function _Str_21162():Bool
        {
            return !StringUtils.isEmpty(this._Str_4949);
        }

        public function isInteractive():Bool
        {
            return false;
        }

        
        public var url(get,set):NetworkResource;
public function  set_url(k:NetworkResource):NetworkResource        {
            return this._Str_577 = k;
        }
public function  get_url():NetworkResource
        {
            return this._Str_577;
        }

        
        public var adParameters(get,set):String;
public function  set_adParameters(k:String):String        {
            return this._Str_5000 = k;
        }
public function  get_adParameters():String
        {
            return this._Str_5000;
        }

        public function _Str_16651():Bool
        {
            return !(this._Str_5000 == null);
        }

        public function _Str_4309():Bool
        {
            if (this._Str_577 != null)
            {
                return this._Str_577._Str_4309();
            }
            return false;
        }

        
        public var codeBlock(get,set):String;
public function  set_codeBlock(k:String):String        {
            return this._Str_3366 = k;
        }
public function  get_codeBlock():String
        {
            return this._Str_3366;
        }

        public function _Str_3937():Bool
        {
            if (this._Str_3366 != null)
            {
                return StringUtils.trim(this._Str_3366).length > 0;
            }
            return false;
        }

        public function isEmpty():Bool
        {
            return (!this._Str_4309()) && (!this._Str_3937());
        }

        public function getContentFormat():String
        {
            if (this._Str_4309())
            {
                return "URL";
            }
            return "CODE";
        }

        public function contentType():String
        {
            if (this._Str_8352())
            {
                if (this.isInteractive())
                {
                    return "VPAID";
                }
                return "SWF";
            }
            if (this._Str_15494())
            {
                return "HTML";
            }
            if (this._Str_18935())
            {
                return "TEXT";
            }
            if (this.isIFrame())
            {
                return "IFRAME";
            }
            if (this.isScript())
            {
                return "SCRIPT";
            }
            return "IMAGE";
        }

        public var content(get,never):String;
public function  get_content():String
        {
            if (this._Str_3937())
            {
                return this._Str_3366;
            }
            if (this._Str_4309())
            {
                return this._Str_577.getQualifiedStreamAddress();
            }
            return "";
        }

        public function rawContentAsObject():ASObject
        {
            return ({
                "type":this.contentType(),
                "format":(this._Str_3937() ? "CODE" : "URL"),
                "content":this.content
            });
        }

        public function _Str_15494():Bool
        {
            return this._Str_22959() || (this._Str_11827() && this._Str_24969());
        }

        public function _Str_8352():Bool
        {
            return this._Str_11827() && this._Str_22114();
        }

        public function isScript():Bool
        {
            return this._Str_23361() || (this._Str_11827() && this._Str_24291());
        }

        public function _Str_20097():Bool
        {
            return this._Str_11827() && this.window7();
        }

        public function _Str_18935():Bool
        {
            return this._Str_24510();
        }

        public function isIFrame():Bool
        {
            return this._Str_22749();
        }

        public function _Str_24510():Bool
        {
            if (this._Str_3532 != null)
            {
                return this._Str_3532.toUpperCase() == "TEXT";
            }
            return false;
        }

        public function _Str_22959():Bool
        {
            if (this._Str_3532 != null)
            {
                return this._Str_3532.toUpperCase() == "HTML";
            }
            return false;
        }

        public function _Str_23361():Bool
        {
            if (this._Str_3532 != null)
            {
                return this._Str_3532.toUpperCase() == "SCRIPT";
            }
            return false;
        }

        public function _Str_22749():Bool
        {
            if (this._Str_3532 != null)
            {
                return this._Str_3532.toUpperCase() == "IFRAME";
            }
            return false;
        }

        public function _Str_11827():Bool
        {
            if (this._Str_3532 != null)
            {
                return this._Str_3532.toUpperCase() == "STATIC";
            }
            return false;
        }

        public function _Str_19521():Bool
        {
            return this._Str_11827() && (this._Str_24710() == false);
        }

        public function _Str_22114():Bool
        {
            if (this.creativeType != null)
            {
                return (((this.creativeType.toUpperCase() == "APPLICATION/SWF") || (this.creativeType.toUpperCase() == "SWF")) || (this.creativeType.toUpperCase() == "APPLICATION/X-SHOCKWAVE-FLASH")) || (this.creativeType.toUpperCase() == "X-SHOCKWAVE-FLASH");
            }
            return false;
        }

        public function _Str_26206():Bool
        {
            if (this.creativeType != null)
            {
                return this.creativeType.toUpperCase() == "TEXT";
            }
            return false;
        }

        public function _Str_24969():Bool
        {
            if (this.creativeType != null)
            {
                return (this.creativeType.toUpperCase() == "HTML") || (this.creativeType.toUpperCase() == "TEXT/HTML");
            }
            return false;
        }

        public function _Str_24291():Bool
        {
            if (this.creativeType != null)
            {
                return (this.creativeType.toUpperCase() == "TEXT/JAVASCRIPT") || (this.creativeType.toUpperCase() == "JAVASCRIPT");
            }
            return false;
        }

        public function window7():Bool
        {
            return (((((((this.creativeType == "IMAGE/JPEG") || (this.creativeType == "JPEG")) || (this.creativeType == "IMAGE/JPG")) || (this.creativeType == "JPG")) || (this.creativeType == "IMAGE/GIF")) || (this.creativeType == "GIF")) || (this.creativeType == "IMAGE/PNG")) || (this.creativeType == "PNG");
        }

        public function hasAccompanyingVideoAd():Bool
        {
            if (parentAdContainer != null)
            {
                return parentAdContainer.hasLinearAd();
            }
            return false;
        }

        public function _Str_18832(k:Int, _arg_2:Int, _arg_3:Int):Bool
        {
            if (this._Str_6420(k, _arg_2))
            {
                return _arg_3 == _index;
            }
            return false;
        }

        public function _Str_16909(k:Int, _arg_2:Int, _arg_3:String):Bool
        {
            if (this._Str_6420(k, _arg_2))
            {
                if (((!(_arg_3 == null)) && (!(this._Str_3532 == null))))
                {
                    return this._Str_3532.toUpperCase() == _arg_3.toUpperCase();
                }
            }
            return false;
        }

        public function _Str_16856(k:Int, _arg_2:Int, _arg_3:String, _arg_4:String=null):Bool
        {
            if (this._Str_6420(k, _arg_2))
            {
                if (((!(_arg_3 == null)) && (!(this._Str_4009 == null))))
                {
                    return (this._Str_4009.toUpperCase() == _arg_3.toUpperCase()) && (this._Str_3532.toUpperCase() == _arg_4.toUpperCase());
                }
                return this._Str_3532.toUpperCase() == _arg_4.toUpperCase();
            }
            return false;
        }

        public function _Str_6420(k:Int, _arg_2:Int):Bool
        {
            if (((k == -1) && (_arg_2 == -1)))
            {
                return true;
            }
            if (k == -1)
            {
                return _arg_2 == this._height;
            }
            if (k == this._width)
            {
                return _arg_2 == this._height;
            }
            return false;
        }

        public function matchesAcceptedAdTypes(k:Array<ASAny>):Bool
        {
            if (k != null)
            {
                if (k.length > 0)
                {
                    return k.indexOf(this.contentType()) > -1;
                }
            }
            return true;
        }

        public function matchesSizeAndAcceptedAdTypes(k:Int, _arg_2:Int, _arg_3:Array<ASAny>):Bool
        {
            if (this.matchesAcceptedAdTypes(_arg_3))
            {
                return this._Str_6420(k, _arg_2);
            }
            return false;
        }

        public function deriveScoreBasedOnEstimatedSizeAndAcceptedAdTypes(k:Int, _arg_2:Int, _arg_3:Array<ASAny>):Int
        {
            if (this.matchesAcceptedAdTypes(_arg_3))
            {
                if (scale == false)
                {
                    if (this._Str_18935())
                    {
                        return 0;
                    }
                    if (((this._height > _arg_2) || (this._width > k)))
                    {
                        return -1;
                    }
                    if (this._width > 0)
                    {
                        return k - this._width;
                    }
                    return -1;
                }
                return 0;
            }
            return -1;
        }

        
        public var activeDisplayRegion(get,set):AdSlotRegionConfig;
public function  set_activeDisplayRegion(k:AdSlotRegionConfig):AdSlotRegionConfig        {
            return this._Str_9031 = k;
        }
public function  get_activeDisplayRegion():AdSlotRegionConfig
        {
            return this._Str_9031;
        }

        public function hasActiveDisplayRegion():Bool
        {
            return !(this._Str_9031 == null);
        }

        public function getActiveDisplayRegionID():String
        {
            if (this.hasActiveDisplayRegion())
            {
                return this._Str_9031._Str_25238(this.contentType());
            }
            return "auto:bottom";
        }

        public function clearActiveDisplayRegion()
        {
            this.activeDisplayRegion = null;
        }

        public function getRawContent():String
        {
            if (this._Str_4309())
            {
                return this._Str_577.url;
            }
            return this._Str_3366;
        }

        public function getContent():String
        {
            if (this.hasActiveDisplayRegion())
            {
                return this._Str_9031._Str_23774(this.contentType()).getContent(this);
            }
            return "";
        }

        public var enforceRecommendedSizing(get,never):Bool;
public function  get_enforceRecommendedSizing():Bool
        {
            if (this.hasActiveDisplayRegion())
            {
                return this._Str_9031.enforceRecommendedSizing;
            }
            return false;
        }

        public function start(k:_Str_3019, _arg_2:ASAny=null)
        {
            this.activeDisplayRegion = _arg_2;
            triggerTrackingEvent(TrackingEvent.CREATIVEVIEW);
            triggerTrackingEvent(TrackingEvent.START);
            if (k.controller != null)
            {
                k.controller.onDisplayNonLinearAd(new _Str_2833(_Str_2833._Str_3831, this, k._Str_3073.adSlot, _arg_2));
            }
        }

        public function stop(k:_Str_3019, _arg_2:ASAny=null)
        {
            triggerTrackingEvent(TrackingEvent.COMPLETE);
            if (k.controller != null)
            {
                k.controller.onHideNonLinearAd(new _Str_2833(_Str_2833._Str_2703, this, k._Str_3073.adSlot, this.activeDisplayRegion));
            }
            this.activeDisplayRegion = null;
        }

        public function _Str_25878(k:NetworkResource)
        {
            if (k != null)
            {
                this._Str_5280.push(k);
            }
        }

        public function _Str_21348(k:Array<ASAny>)
        {
            if (k != null)
            {
                this._Str_5280 = this._Str_5280.concat(k);
            }
        }

        public function _Str_20657():Bool
        {
            return this._Str_5280.length > 0;
        }

        public function _Str_22894()
        {
            var k = 0;
            if (this._Str_20657())
            {
                k = 0;
                while (k < this._Str_5280.length)
                {
                    this._Str_5280[k].call();
                    k++;
                }
            }
        }

        public function clicked()
        {
            this._Str_22894();
            triggerTrackingEvent(TrackingEvent.ACCEPTINVITATION);
        }

        public function close()
        {
            triggerTrackingEvent(TrackingEvent.CLOSE);
        }

        override public function clone(k:ASAny=null):ASAny
        {
            var _local_2:NonLinearVideoAd = null;
            if (k == null)
            {
                _local_2 = new NonLinearVideoAd();
            }
            else
            {
                _local_2 = k;
            }
            _local_2.width = this._width;
            _local_2.height = this._height;
            _local_2.expandedWidth = this._Str_5165;
            _local_2.expandedHeight = this._Str_5160;
            _local_2.recommendedMinDuration = _Str_6407;
            _local_2.resourceType = this._Str_3532;
            _local_2.creativeType = this._Str_4009;
            _local_2.apiFramework = this._Str_4949;
            _local_2.url = this._Str_577;
            _local_2.codeBlock = this._Str_3366;
            _local_2.scale = _scale;
            _local_2._Str_21348(this._Str_5280);
            return super.clone(_local_2);
        }

        override public function toJSObject():ASObject
        {
            var k:ASObject = super.toJSObject();
            k.width = this._width;
            k.height = this._height;
            k.expandedWidth = this._Str_5165;
            k.expandedHeight = this._Str_5160;
            k.scale = _scale;
            k.resourceType = this._Str_3532;
            k.creativeType = this._Str_4009;
            k.apiFramework = this._Str_4949;
            k.url = ((this._Str_577 != null) ? this._Str_577.url : "");
            k.codeblock = this._Str_3366;
            return k;
        }
    }

