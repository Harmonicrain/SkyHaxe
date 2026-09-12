package org.openvideoads.vast.model
;
    import org.openvideoads.base.Debuggable;
    import org.openvideoads.util.StringUtils;

     class MediaFile extends Debuggable 
    {
        var _Str_577:AdNetworkResource = null;
        var _id:String;
        var _Str_18599:String;
        var _Str_6705:String;
        var _scale:Bool = false;
        var _Str_6419:Bool = true;
        var _Str_2230:String;
        var _Str_15448:Int = -1;
        var _width:String;
        var _height:String;
        var _Str_4949:String = null;
        var _Str_5000:String = null;
        var _Str_3543:TrackedVideoAd = null;


        public function unload()
        {
        }

        
        public var id(get,set):String;
public function  set_id(k:String):String        {
            return this._id = k;
        }
public function  get_id():String
        {
            return this._id;
        }

        
        public var _Str_19024(get,set):TrackedVideoAd;
public function  set__Str_19024(k:TrackedVideoAd):TrackedVideoAd        {
            return this._Str_3543 = k;
        }
public function  get__Str_19024():TrackedVideoAd
        {
            return this._Str_3543;
        }

        
        public var url(get,set):AdNetworkResource;
public function  set_url(k:AdNetworkResource):AdNetworkResource        {
            return this._Str_577 = k;
        }
public function  get_url():AdNetworkResource
        {
            return this._Str_577;
        }

        
        public var bandwidth(get,set):String;
public function  set_bandwidth(k:String):String        {
            return this._Str_18599 = k;
        }
public function  get_bandwidth():String
        {
            return this._Str_18599;
        }

        public var duration(get,never):String;
public function  get_duration():String
        {
            if (this._Str_3543 != null)
            {
                return this._Str_3543.duration;
            }
            return "00:00:00";
        }

        public function _Str_26336():Int
        {
            return 0;
        }

        
        public var delivery(get,set):String;
public function  set_delivery(k:String):String        {
            return this._Str_6705 = k;
        }
public function  get_delivery():String
        {
            return this._Str_6705;
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
            return !(this._Str_4949 == null);
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
            return !StringUtils.isEmpty(this._Str_5000);
        }

        public function _parser4():Bool
        {
            if (this._Str_6705 != null)
            {
                return this._Str_6705.toUpperCase() == "PROGRESSIVE";
            }
            return false;
        }

        public function _Str_25975():Bool
        {
            if (this._Str_6705 != null)
            {
                return this._Str_6705.toUpperCase() == "STREAMING";
            }
            return false;
        }

        
        public var scale(get,set):Bool;
public function  set_scale(k:ASAny):Bool        {
            if (k != null)
            {
                this._scale = StringUtils._Str_2810(k);
            }
return k;
        }
public function  get_scale():Bool
        {
            return this._scale;
        }

        
        public var maintainAspectRatio(get,set):Bool;
public function  set_maintainAspectRatio(k:ASAny):Bool        {
            if (k != null)
            {
                this._Str_6419 = StringUtils._Str_2810(k);
            }
return k;
        }
public function  get_maintainAspectRatio():Bool
        {
            return this._Str_6419;
        }

        public function _Str_17899():Bool
        {
            return !(this._Str_2230 == null);
        }

        
        public var mimeType(get,set):String;
public function  set_mimeType(k:String):String        {
            return this._Str_2230 = k;
        }
public function  get_mimeType():String
        {
            return this._Str_2230;
        }

        public function isPermittedMimeType(k:Array<ASAny>):Bool
        {
            if (((this._Str_17899() == false) || (k == null)))
            {
                return true;
            }
            var _local_2 = 0;
            while (_local_2 < k.length)
            {
                if (StringUtils._Str_2576(this._Str_2230, k[_local_2]))
                {
                    return true;
                }
                _local_2++;
            }
            return false;
        }

        public function isInteractive():Bool
        {
            if (this._Str_21162())
            {
                if (StringUtils._Str_2576(this._Str_4949, "VPAID"))
                {
                    if (this._Str_17899())
                    {
                        return StringUtils._Str_2576(this._Str_2230, "APPLICATION/X-SHOCKWAVE-FLASH") || StringUtils._Str_2576(this._Str_2230, "SWF");
                    }
                    if (this._Str_577 != null)
                    {
                        return this._Str_577.isStream() == false;
                    }
                }
            }
            return false;
        }

        
        public var bitRate(get,set):Int;
public function  set_bitRate(k:Int):Int        {
            return this._Str_15448 = k;
        }
public function  get_bitRate():Int
        {
            return this._Str_15448;
        }

        public function hasBitRate():Bool
        {
            return this._Str_15448 > -1;
        }

        
        public var width(get,set):String;
public function  set_width(k:String):String        {
            return this._width = k;
        }
public function  get_width():String
        {
            return this._width;
        }

        
        public var height(get,set):String;
public function  set_height(k:String):String        {
            return this._height = k;
        }
public function  get_height():String
        {
            return this._height;
        }

        public function isMimeType(k:ASAny):Bool
        {
            if (k == null)
            {
                return true;
            }
            if (Std.is(k , Array))
            {
                return this.isPermittedMimeType(k);
            }
            return (k.toUpperCase() == "ANY") || (this._Str_2230.toUpperCase() == k.toUpperCase());
        }

        public function isDeliveryType(k:String):Bool
        {
            if (k == null)
            {
                return true;
            }
            return (k.toUpperCase() == "ANY") || (this._Str_6705.toUpperCase() == k.toUpperCase());
        }

        override public function toJSObject():ASObject
        {
            var k:ASObject = new ASObject();
            k = {
                "id":this._id,
                "uid":_uid,
                "bandwidth":this._Str_18599,
                "delivery":this._Str_6705,
                "scale":this._scale,
                "maintainAspectRatio":this._Str_6419,
                "mimeType":this._Str_2230,
                "bitRate":this._Str_15448,
                "width":this._width,
                "height":this._height,
                "apiFramework":this._Str_4949,
                "urlId":((this._Str_577 != null) ? this._Str_577.id : null),
                "url":((this._Str_577 != null) ? this._Str_577.url : null),
                "adParameters":((this._Str_5000 != null) ? ASCompat.escape(this._Str_5000) : null)
            }
;            return k;
        }

	public function new() { super(); }
    }

