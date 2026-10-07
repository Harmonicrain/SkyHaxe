package org.openvideoads.vast.overlay
;
    import flash.events.EventDispatcher;
    import org.openvideoads.vpaid._Str_5844;
    import Globals.flash_utils_getQualifiedClassName as getQualifiedClassName;
    import flash.events.Event;
    import flash.utils.*;

     class VPAIDWrapper extends EventDispatcher implements _Str_5844 
    {
        static inline final WRAPPED_WITH_GET_VPAID= "WRAPPED_WITH_GET_VPAID";
        static inline final STANDARD= "STANDARD";

        var _Str_2492:ASAny;
        var _Str_18659:Int = -1;
        var _Str_18401:Int = -1;
        var _Str_11790:Bool = false;
        var _Str_9253:Float = -1;

        public function new(k:ASAny, _arg_2:Bool=false, _arg_3:Float=-1)
        {
            super();
            this._Str_11790 = _arg_2;
            this._Str_9253 = _arg_3;
            switch (this._Str_23299(k))
            {
                case WRAPPED_WITH_GET_VPAID:
                    this._Str_2492 = k.getVPAID();
                    return;
                default:
                    this._Str_2492 = k;
            }
        }

        function _Str_23299(k:ASAny):String
        {
            var _local_2= ASCompat.describeType(k);
            if (this._Str_24311(k, "getVPAID", _local_2))
            {
                return WRAPPED_WITH_GET_VPAID;
            }
            return STANDARD;
        }

        public var adLinear(get,never):Bool;
public function  get_adLinear():Bool
        {
            if (this._Str_2492 != null)
            {
                return this._Str_2492.adLinear;
            }
            return false;
        }

        public var adExpanded(get,never):Bool;
public function  get_adExpanded():Bool
        {
            if (this._Str_2492 != null)
            {
                return this._Str_2492.adExpanded;
            }
            return false;
        }

        public var _Str_23482(get,never):Float;
public function  get__Str_23482():Float
        {
            if (this._Str_2492 != null)
            {
                return ASCompat.toNumber(this._Str_2492.height);
            }
            return 0;
        }

        public var _Str_25601(get,never):Float;
public function  get__Str_25601():Float
        {
            if (this._Str_2492 != null)
            {
                return ASCompat.toNumber(this._Str_2492.width);
            }
            return 0;
        }

        public var adDuration(get,never):Float;
public function  get_adDuration():Float
        {
            if (this._Str_2492 != null)
            {
                return ASCompat.toNumber(this._Str_2492.adDuration);
            }
            return 0;
        }

        public var adSkippableState(get,never):Bool;
public function  get_adSkippableState():Bool
        {
            if (this._Str_2492 != null)
            {
                return this._Str_2492.adSkippableState;
            }
            return false;
        }

        public var adRemainingTime(get,never):Float;
public function  get_adRemainingTime():Float
        {
            if (this._Str_2492 != null)
            {
                return ASCompat.toNumber(this._Str_2492.adRemainingTime);
            }
            return 0;
        }

        
        public var adVolume(get,set):Float;
public function  get_adVolume():Float
        {
            if (this._Str_2492 != null)
            {
                return ASCompat.toNumber(this._Str_2492.adVolume);
            }
            return 0;
        }
public function  set_adVolume(k:Float):Float        {
            if (this._Str_2492 != null)
            {
                this._Str_2492.adVolume = k;
            }
return k;
        }

        public var adCompanions(get,never):String;
public function  get_adCompanions():String
        {
            if (this._Str_2492 != null)
            {
                return this._Str_2492.adCompanions;
            }
            return null;
        }

        public var adIcons(get,never):Bool;
public function  get_adIcons():Bool
        {
            if (this._Str_2492 != null)
            {
                return this._Str_2492.adIcons;
            }
            return false;
        }

        function _Str_24311(k:ASAny, _arg_2:String, _arg_3:com.sulake.core.utils.xml.XML=null):Bool
        {
            return this._Str_11059(k, _arg_2);
        }

        function _Str_26056(k:ASAny):String
        {
            var _local_2= getQualifiedClassName(k);
            if (_local_2 != null)
            {
                return _local_2.substr(0, _local_2.indexOf("::"));
            }
            return "";
        }

        function _Str_11059(ad:ASAny, methodName:String):Bool
        {
            if (ad != null)
            {
                try
                {
                    return !(ad[methodName] == /*undefined*/null);
                }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                 {
                }
 }            }
            return false;
        }

        public function isV100():Bool
        {
            return this._Str_11059(this._Str_2492, "initVPAIDVersion") && this._Str_11059(this._Str_2492, "init");
        }

        public function isV110():Bool
        {
            return this._Str_11059(this._Str_2492, "handshakeVersion") && this._Str_11059(this._Str_2492, "initAd");
        }

        public function initVPAIDVersion(k:String):String
        {
            if (this._Str_2492 != null)
            {
                return this._Str_2492.initVPAIDVersion(k);
            }
            return "0.0.0";
        }

        public function handshakeVersion(k:String):String
        {
            if (this._Str_2492 != null)
            {
                return this._Str_2492.handshakeVersion(k);
            }
            return "0.0.0";
        }

        public function initAd(k:Float, _arg_2:Float, _arg_3:String, _arg_4:Float, _arg_5:String, _arg_6:String)
        {
            var _local_7 = 0;
            var _local_8 = 0;
            if (this._Str_2492 != null)
            {
                _local_7 = ASCompat.parseInt(ASCompat.toFixed(k, 0));
                _local_8 = ASCompat.parseInt(ASCompat.toFixed(_arg_2, 0));
                this._Str_18659 = _local_7;
                this._Str_18401 = _local_8;
                this._Str_2492.initAd(_local_7, _local_8, _arg_3, _arg_4, _arg_5, _arg_6);
            }
        }

        public function resizeAd(width:Float, height:Float, viewMode:String)
        {
            var fixedWidth = 0;
            var fixedHeight = 0;
            try
            {
                fixedWidth = ASCompat.parseInt(ASCompat.toFixed(width, 0));
                fixedHeight = ASCompat.parseInt(ASCompat.toFixed(height, 0));
                if (((!(this._Str_18659 == fixedWidth)) || (!(this._Str_18401 == fixedHeight))))
                {
                    this._Str_18659 = fixedWidth;
                    this._Str_18401 = fixedHeight;
                    this._Str_2492.resizeAd(fixedWidth, fixedHeight, viewMode);
                }
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
            }
 }        }

        public function startAd()
        {
            if (this._Str_2492 != null)
            {
                if (this._Str_11790)
                {
                    this._Str_2492.adVolume = 0;
                }
                else
                {
                    if (this._Str_9253 > -1)
                    {
                        this._Str_2492.adVolume = this._Str_9253;
                    }
                }
                this._Str_2492.startAd();
            }
        }

        public function stopAd()
        {
            if (this._Str_2492 != null)
            {
                this._Str_2492.stopAd();
            }
        }

        public function pauseAd()
        {
            if (this._Str_2492 != null)
            {
                this._Str_2492.pauseAd();
            }
        }

        public function resumeAd()
        {
            if (this._Str_2492 != null)
            {
                this._Str_2492.resumeAd();
            }
        }

        public function skipAd()
        {
            if (this._Str_2492 != null)
            {
                this._Str_2492.skipAd();
            }
        }

        public function expandAd()
        {
            if (this._Str_2492 != null)
            {
                this._Str_2492.expandAd();
            }
        }

        public function collapseAd()
        {
            if (this._Str_2492 != null)
            {
                this._Str_2492.collapseAd();
            }
        }

        override public function addEventListener(k:String, _arg_2:ASFunction, _arg_3:Bool=false, _arg_4:Int=0, _arg_5:Bool=false)
        {
            if (this._Str_2492 != null)
            {
                this._Str_2492.addEventListener(k, _arg_2, _arg_3, _arg_4, _arg_5);
            }
        }

        override public function removeEventListener(k:String, _arg_2:ASFunction, _arg_3:Bool=false)
        {
            if (this._Str_2492 != null)
            {
                this._Str_2492.removeEventListener(k, _arg_2, _arg_3);
            }
        }

        override public function dispatchEvent(k:Event):Bool
        {
            if (this._Str_2492 != null)
            {
                return this._Str_2492.dispatchEvent(k);
            }
            return false;
        }

        override public function hasEventListener(k:String):Bool
        {
            if (this._Str_2492 != null)
            {
                return this._Str_2492.hasEventListener(k);
            }
            return false;
        }

        override public function willTrigger(k:String):Bool
        {
            if (this._Str_2492 != null)
            {
                return this._Str_2492.willTrigger(k);
            }
            return false;
        }

        public function _Str_12035():ASObject
        {
            var k:ASObject = new ASObject();
ASCompat.setDynamicProperty(            k, "adExpanded", this.adExpanded);
ASCompat.setDynamicProperty(            k, "adLinear", this.adLinear);
ASCompat.setDynamicProperty(            k, "adRemainingTime", this.adRemainingTime);
ASCompat.setDynamicProperty(            k, "adVolume", this.adVolume);
            return k;
        }
    }

