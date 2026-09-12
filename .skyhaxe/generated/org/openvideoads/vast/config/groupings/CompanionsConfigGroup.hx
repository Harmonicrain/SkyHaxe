package org.openvideoads.vast.config.groupings
;
    import org.openvideoads.base.Debuggable;
    import org.openvideoads.util.ArrayUtils;

     class CompanionsConfigGroup extends Debuggable 
    {
        var _Str_6910:Array<ASAny>;
        var _Str_18863:Bool = true;
        var _Str_21492:Bool = true;
        var _Str_10909:Bool = true;
        var _Str_18241:Int = 0;
        var _Str_13667:Array<ASAny>;

        public function new(k:ASObject=null)
        {
            this._Str_6910 = new Array<ASAny>();
            this._Str_13667 = new Array<ASAny>();
            super();
            if (k != null)
            {
                this.initialise(k);
            }
        }

        public function initialise(k:ASObject=null)
        {
            if (k.regions != /*undefined*/null)
            {
                if (Std.is(k.regions , String))
                {
                    this.companionDivIDs = ArrayUtils._Str_8734(k.regions);
                }
                else
                {
                    this.companionDivIDs = k.regions;
                }
            }
            if (k.enable != /*undefined*/null)
            {
                if (Std.is(k.enable , String))
                {
                    this.displayCompanions = (k.enable.toUpperCase() == "TRUE");
                }
                else
                {
                    this.displayCompanions = k.enable;
                }
            }
            if (k.html5 != /*undefined*/null)
            {
                if (Std.is(k.html5 , String))
                {
                    this.nativeDisplay = (!(k.html5.toUpperCase() == "TRUE"));
                }
                else
                {
                    this.nativeDisplay = (!k.html5);
                }
            }
            if (k.nativeDisplay != /*undefined*/null)
            {
                if (Std.is(k.nativeDisplay , String))
                {
                    this.nativeDisplay = (k.nativeDisplay.toUpperCase() == "TRUE");
                }
                else
                {
                    this.nativeDisplay = k.nativeDisplay;
                }
            }
            if (k.restore != /*undefined*/null)
            {
                if (Std.is(k.restore , String))
                {
                    this.restoreCompanions = (k.restore.toUpperCase() == "TRUE");
                }
                else
                {
                    this.restoreCompanions = k.restore;
                }
            }
            if (k.additionalParamsForSWFCompanions != /*undefined*/null)
            {
                if (Std.is(k.additionalParamsForSWFCompanions , Array))
                {
                    this._Str_13667 = k.additionalParamsForSWFCompanions;
                }
            }
            if (k.millisecondDelayOnInjection != /*undefined*/null)
            {
                if (Std.is(k.millisecondDelayOnInjection , String))
                {
                    this.millisecondDelayOnCompanionInjection = ASCompat.toInt(k.millisecondDelayOnInjection);
                }
                else
                {
                    this.millisecondDelayOnCompanionInjection = ASCompat.toInt(k.millisecondDelayOnInjection);
                }
            }
        }

        public function _Str_8478():Bool
        {
            return this._Str_6910.length > 0;
        }

        
        public var companionDivIDs(get,set):Array<ASAny>;
public function  set_companionDivIDs(k:Array<ASAny>):Array<ASAny>        {
            var _local_2 = 0;
            if (k != null)
            {
                _local_2 = 0;
                while (_local_2 < k.length)
                {
                    if (ASCompat.hasOwnProperty(k[_local_2], "width"))
                    {
                        if (Std.is(k[_local_2].width , String))
                        {
                            k[_local_2].width = ASCompat.toNumber(k[_local_2].width);
                        }
                    }
                    if (ASCompat.hasOwnProperty(k[_local_2], "height"))
                    {
                        if (Std.is(k[_local_2].height , String))
                        {
                            k[_local_2].height = ASCompat.toNumber(k[_local_2].height);
                        }
                    }
                    _local_2++;
                }
            }
            return this._Str_6910 = k;
        }
public function  get_companionDivIDs():Array<ASAny>
        {
            return this._Str_6910;
        }

        
        public var displayCompanions(get,set):Bool;
public function  set_displayCompanions(k:Bool):Bool        {
            return this._Str_18863 = k;
        }
public function  get_displayCompanions():Bool
        {
            if (this._Str_18863 == false)
            {
                return this._Str_18863;
            }
            return this._Str_8478();
        }

        
        public var nativeDisplay(get,set):Bool;
public function  set_nativeDisplay(k:Bool):Bool        {
            return this._Str_10909 = k;
        }
public function  get_nativeDisplay():Bool
        {
            return this._Str_10909;
        }

        
        public var restoreCompanions(get,set):Bool;
public function  set_restoreCompanions(k:Bool):Bool        {
            return this._Str_21492 = k;
        }
public function  get_restoreCompanions():Bool
        {
            return this._Str_21492;
        }

        
        public var millisecondDelayOnCompanionInjection(get,set):Int;
public function  set_millisecondDelayOnCompanionInjection(k:Int):Int        {
            return this._Str_18241 = k;
        }
public function  get_millisecondDelayOnCompanionInjection():Int
        {
            return this._Str_18241;
        }

        public function _Str_12146():Bool
        {
            return this._Str_18241 > 0;
        }

        
        public var additionalParamsForSWFCompanions(get,set):Array<ASAny>;
public function  set_additionalParamsForSWFCompanions(k:Array<ASAny>):Array<ASAny>        {
            return this._Str_13667 = k;
        }
public function  get_additionalParamsForSWFCompanions():Array<ASAny>
        {
            return this._Str_13667;
        }
    }

