package org.openvideoads.vast.config.groupings
;
     class VPAIDConfig 
    {
        public static inline final _Str_22107= "reserved-fullscreen-black-no-close-button-non-clickable";
        public static inline final _Str_21227= "reserved-fullscreen-black-no-close-button-non-clickable-minimize-rules";
        public static inline final _Str_20010= "reserved-fullscreen-transparent-no-close-button-non-clickable";
        public static inline final _Str_20698= "reserved-fullscreen-black-no-close-button-non-clickable-with-cb-height";
        public static inline final _Str_19080= "reserved-fullscreen-transparent-no-close-button-non-clickable-bottom-margin-adjusted";

        var _Str_20820:Bool = false;
        var _Str_19204:String = null;
        var _Str_20807:String = "http://lp.longtailvideo.com/5/ova/blank.mp4";
        var _Str_23851:String = "reserved-fullscreen-black-no-close-button-non-clickable";
        var _Str_24504:String = "reserved-fullscreen-black-no-close-button-non-clickable-with-cb-height";
        var _Str_23539:String = "reserved-fullscreen-transparent-no-close-button-non-clickable";
        var _Str_25928:String = "reserved-fullscreen-transparent-no-close-button-non-clickable-bottom-margin-adjusted";
        var _Str_12645:String = null;
        var _Str_15285:String = null;
        var _Str_19854:Int = 90;
        var _Str_21114:Bool = false;
        var _Str_21288:Bool = true;
        var _Str_21436:Bool = true;
        var _Str_21529:Bool = false;
        var _Str_19608:Bool = false;
        var _Str_21663:Bool = false;
        var _Str_20815:String = null;

        public function new(k:ASObject=null)
        {
            if (k != null)
            {
                this.initialise(k);
            }
        }

        public function initialise(k:ASObject)
        {
            var _local_2:compat.RegExp = null;
            if (k.supplyReferrer != /*undefined*/null)
            {
                if (Std.is(k.supplyReferrer , String))
                {
                    this.supplyReferrer = (k.supplyReferrer.toUpperCase() == "TRUE");
                }
                else
                {
                    this.supplyReferrer = k.supplyReferrer;
                }
            }
            if (k.enableLinearScaling != /*undefined*/null)
            {
                if (Std.is(k.enableLinearScaling , String))
                {
                    this.enableLinearScaling = (k.enableLinearScaling.toUpperCase() == "TRUE");
                }
                else
                {
                    this.enableLinearScaling = k.enableLinearScaling;
                }
            }
            if (k.enableNonLinearScaling != /*undefined*/null)
            {
                if (Std.is(k.enableNonLinearScaling , String))
                {
                    this.enableNonLinearScaling = (k.enableNonLinearScaling.toUpperCase() == "TRUE");
                }
                else
                {
                    this.enableNonLinearScaling = k.enableNonLinearScaling;
                }
            }
            if (k.referrer != /*undefined*/null)
            {
                this.referrer = k.referrer;
            }
            if (k.holdingClipUrl != /*undefined*/null)
            {
                this.holdingClipUrl = k.holdingClipUrl;
            }
            if (k.linearRegion != /*undefined*/null)
            {
                this.linearRegion = k.linearRegion;
            }
            if (k.nonLinearRegion != /*undefined*/null)
            {
                this.nonLinearRegion = k.nonLinearRegion;
            }
            if (k.terminateOnLogMessage != /*undefined*/null)
            {
                if (k.terminateOnLogMessage != null)
                {
                    _local_2 = new compat.RegExp("__single-quote__", "g");
                    k.terminateOnLogMessage = k.terminateOnLogMessage.replace(_local_2, "'");
                }
                this.terminateOnLogMessage = k.terminateOnLogMessage;
            }
            if (k.enableMaxDurationTimeout != /*undefined*/null)
            {
                if (Std.is(k.enableMaxDurationTimeout , String))
                {
                    this.enableMaxDurationTimeout = (k.enableMaxDurationTimeout.toUpperCase() == "TRUE");
                }
                else
                {
                    this.enableMaxDurationTimeout = k.enableMaxDurationTimeout;
                }
            }
            if (k.maxDurationTimeout != /*undefined*/null)
            {
                if (Std.is(k.maxDurationTimeout , String))
                {
                    this.maxDurationTimeout = ASCompat.toInt(k.maxDurationTimeout);
                }
                else
                {
                    this.maxDurationTimeout = ASCompat.toInt(k.maxDurationTimeout);
                }
            }
            if (k.pauseOnExpand != /*undefined*/null)
            {
                if (Std.is(k.pauseOnExpand , String))
                {
                    this.pauseOnExpand = (k.pauseOnExpand.toUpperCase() == "TRUE");
                }
                else
                {
                    this.pauseOnExpand = k.pauseOnExpand;
                }
            }
            if (k.resumeOnCollapse != /*undefined*/null)
            {
                if (Std.is(k.resumeOnCollapse , String))
                {
                    this.resumeOnCollapse = (k.resumeOnCollapse.toUpperCase() == "TRUE");
                }
                else
                {
                    this.resumeOnCollapse = k.resumeOnCollapse;
                }
            }
            if (k.testing != /*undefined*/null)
            {
                if (Std.is(k.testing , String))
                {
                    this.testing = (k.testing.toUpperCase() == "TRUE");
                }
                else
                {
                    this.testing = k.testing;
                }
            }
        }

        
        public var supplyReferrer(get,set):Bool;
public function  set_supplyReferrer(k:Bool):Bool        {
            return this._Str_20820 = k;
        }
public function  get_supplyReferrer():Bool
        {
            return this._Str_20820;
        }

        
        public var referrer(get,set):String;
public function  set_referrer(k:String):String        {
            return this._Str_19204 = k;
        }
public function  get_referrer():String
        {
            return this._Str_19204;
        }

        
        public var pauseOnExpand(get,set):Bool;
public function  set_pauseOnExpand(k:Bool):Bool        {
            return this._Str_21529 = k;
        }
public function  get_pauseOnExpand():Bool
        {
            return this._Str_21529;
        }

        
        public var resumeOnCollapse(get,set):Bool;
public function  set_resumeOnCollapse(k:Bool):Bool        {
            return this._Str_19608 = k;
        }
public function  get_resumeOnCollapse():Bool
        {
            return this._Str_19608;
        }

        
        public var terminateOnLogMessage(get,set):String;
public function  get_terminateOnLogMessage():String
        {
            return this._Str_20815;
        }
public function  set_terminateOnLogMessage(k:String):String        {
            return this._Str_20815 = k;
        }

        
        public var enableLinearScaling(get,set):Bool;
public function  set_enableLinearScaling(k:Bool):Bool        {
            return this._Str_21288 = k;
        }
public function  get_enableLinearScaling():Bool
        {
            return this._Str_21288;
        }

        
        public var enableNonLinearScaling(get,set):Bool;
public function  set_enableNonLinearScaling(k:Bool):Bool        {
            return this._Str_21436 = k;
        }
public function  get_enableNonLinearScaling():Bool
        {
            return this._Str_21436;
        }

        
        public var holdingClipUrl(get,set):String;
public function  set_holdingClipUrl(k:String):String        {
            return this._Str_20807 = k;
        }
public function  get_holdingClipUrl():String
        {
            return this._Str_20807;
        }

        
        public var testing(get,set):Bool;
public function  set_testing(k:Bool):Bool        {
            return this._Str_21663 = k;
        }
public function  get_testing():Bool
        {
            return this._Str_21663;
        }

        public function _Str_26193():Bool
        {
            return !(this._Str_12645 == null);
        }

        public var linearRegion(never,set):String;
public function  set_linearRegion(k:String):String        {
            return this._Str_12645 = k;
        }

        public function getLinearRegion(k:Bool):String
        {
            if (this._Str_12645 != null)
            {
                return this._Str_12645;
            }
            if (k)
            {
                return this._Str_23851;
            }
            return this._Str_24504;
        }

        
        public var nonLinearRegion(get,set):String;
public function  set_nonLinearRegion(k:String):String        {
            return this._Str_15285 = k;
        }
public function  get_nonLinearRegion():String
        {
            if (this._Str_15285 != null)
            {
                return this._Str_15285;
            }
            return this._Str_23539;
        }

        public function _Str_26400():Bool
        {
            return !(this._Str_15285 == null);
        }

        
        public var maxDurationTimeout(get,set):Int;
public function  set_maxDurationTimeout(k:Int):Int        {
            return this._Str_19854 = k;
        }
public function  get_maxDurationTimeout():Int
        {
            return this._Str_19854;
        }

        
        public var enableMaxDurationTimeout(get,set):Bool;
public function  set_enableMaxDurationTimeout(k:Bool):Bool        {
            return this._Str_21114 = k;
        }
public function  get_enableMaxDurationTimeout():Bool
        {
            return this._Str_21114;
        }
    }

