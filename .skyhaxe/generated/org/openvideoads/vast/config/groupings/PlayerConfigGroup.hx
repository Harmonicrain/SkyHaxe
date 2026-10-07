package org.openvideoads.vast.config.groupings
;
    import org.openvideoads.util.ControlsSpecification;
    import org.openvideoads.util.DisplaySpecification;
    import org.openvideoads.vast.config._Str_2741;
    import org.openvideoads.util.MarginsSpecification;

     class PlayerConfigGroup extends _Str_3389 
    {
        var _Str_15349:Int = -1;
        var _Str_21473:Int = -1;
        var _Str_6597:ControlsSpecification;
        var _Str_21329:Bool = false;
        var _Str_21737:Bool = true;
        var _Str_21284:Bool = true;
        var _Str_21401:Bool = false;
        var _Str_3090:ASObject;

        public function new(k:ASObject=null, _arg_2:_Str_2741=null)
        {
            this._Str_6597 = new ControlsSpecification();
            this._Str_3090 = {
                "linear":new DisplaySpecification(DisplaySpecification.LINEAR),
                "nonLinear":new DisplaySpecification(DisplaySpecification.NONLINEAR)
            }
;            super(k, _arg_2);
        }

        override public function initialise(k:ASObject=null, _arg_2:_Str_2741=null, _arg_3:Bool=false)
        {
            _Str_3654();
            super.initialise(k, _arg_2);
            if (k != null)
            {
                if (ASCompat.hasOwnProperty(k, "modes"))
                {
                    if (ASCompat.hasOwnProperty(k.modes, "linear"))
                    {
                        this._Str_3090.linear.initialise(k.modes.linear);
                    }
                    if (ASCompat.hasOwnProperty(k.modes, "nonLinear"))
                    {
                        this._Str_3090.nonLinear.initialise(k.modes.nonLinear);
                    }
                }
                if (ASCompat.hasOwnProperty(k, "width"))
                {
                    this.width = k.width;
                }
                if (ASCompat.hasOwnProperty(k, "height"))
                {
                    this.height = k.height;
                }
                if (ASCompat.hasOwnProperty(k, "controls"))
                {
                    this.controls = k.controls;
                }
                if (ASCompat.hasOwnProperty(k, "margins"))
                {
                    this.margins = k.margins;
                }
                if (ASCompat.hasOwnProperty(k, "setUrlResolversOnAdClips"))
                {
                    if (Std.is(k.setUrlResolversOnAdClips , String))
                    {
                        this.setUrlResolversOnAdClips = ((k.setUrlResolversOnAdClips.toUpperCase() == "TRUE") ? true : false);
                    }
                    else
                    {
                        this.setUrlResolversOnAdClips = k.setUrlResolversOnAdClips;
                    }
                }
                if (ASCompat.hasOwnProperty(k, "showBusyIcon"))
                {
                    if (Std.is(k.showBusyIcon , String))
                    {
                        this.showBusyIcon = ((k.showBusyIcon.toUpperCase() == "TRUE") ? true : false);
                    }
                    else
                    {
                        this.showBusyIcon = k.showBusyIcon;
                    }
                }
                if (ASCompat.hasOwnProperty(k, "applyCommonClipProperties"))
                {
                    if (Std.is(k.applyCommonClipProperties , String))
                    {
                        this.applyCommonClipProperties = ((k.applyCommonClipProperties.toUpperCase() == "TRUE") ? true : false);
                    }
                    else
                    {
                        this.applyCommonClipProperties = k.applyCommonClipProperties;
                    }
                }
            }
            _Str_3144();
        }

        public function _Str_18778():Bool
        {
            return this.height > -1;
        }

        public function _Str_16865():Bool
        {
            return this.width > -1;
        }

        
        public var height(get,set):Int;
public function  set_height(k:ASAny):Int        {
            var _local_2 = 0;
            if (Std.is(k , String))
            {
                _local_2 = ASCompat.parseInt(k);
            }
            else
            {
                _local_2 = ASCompat.toInt(k);
            }
            this._Str_21473 = _local_2;
            this._Str_3090.linear.height = _local_2;
            this._Str_3090.nonLinear.height = _local_2;
return ASCompat.toInt(k);
        }
public function  get_height():Int
        {
            return this._Str_21473;
        }

        
        public var width(get,set):Int;
public function  set_width(k:ASAny):Int        {
            var _local_2 = 0;
            if (Std.is(k , String))
            {
                _local_2 = ASCompat.parseInt(k);
            }
            else
            {
                _local_2 = ASCompat.toInt(k);
            }
            this._Str_15349 = _local_2;
            this._Str_3090.linear.width = _local_2;
            this._Str_3090.nonLinear.width = _local_2;
return ASCompat.toInt(k);
        }
public function  get_width():Int
        {
            return this._Str_15349;
        }

        
        public var _Str_23327(get,set):Bool;
public function  set__Str_23327(k:Bool):Bool        {
            return this._Str_21329 = k;
        }
public function  get__Str_23327():Bool
        {
            return this._Str_21329;
        }

        public var controls(never,set):ASAny;
public function  set_controls(k:ASAny):ASAny        {
            if (Std.is(k , ControlsSpecification))
            {
                this._Str_6597 = k;
                this._Str_3090.linear.controlsConfig = k;
                this._Str_3090.nonLinear.controlsConfig = k;
            }
            else
            {
                this._Str_6597.initialise(k);
                this._Str_3090.linear.initialise({"controls":k});
                this._Str_3090.nonLinear.initialise({"controls":k});
            }
return k;
        }

        public var _Str_26374(get,never):ASObject;
public function  get__Str_26374():ASObject
        {
            return this._Str_3090.linear.controls;
        }

        public var _Str_26119(get,never):ASObject;
public function  get__Str_26119():ASObject
        {
            return this._Str_3090.nonLinear.controls;
        }

        public var _Str_26078(get,never):ControlsSpecification;
public function  get__Str_26078():ControlsSpecification
        {
            return this._Str_6597;
        }

        public function controlEnabledForLinearAdType(k:String, _arg_2:Bool):Bool
        {
            return this._Str_3090.linear.controlEnabledForLinearAdType(k, _arg_2);
        }

        public function _Str_26305():Bool
        {
            if (this._Str_6597 != null)
            {
                return this._Str_6597.hasHeightSpecified();
            }
            return false;
        }

        public function _Str_26126():Float
        {
            if (this._Str_6597 != null)
            {
                return this._Str_6597.height;
            }
            return -1;
        }

        
        public var setUrlResolversOnAdClips(get,set):Bool;
public function  set_setUrlResolversOnAdClips(k:Bool):Bool        {
            return this._Str_21737 = k;
        }
public function  get_setUrlResolversOnAdClips():Bool
        {
            return this._Str_21737;
        }

        
        public var applyCommonClipProperties(get,set):Bool;
public function  set_applyCommonClipProperties(k:Bool):Bool        {
            return this._Str_21401 = k;
        }
public function  get_applyCommonClipProperties():Bool
        {
            return this._Str_21401;
        }

        
        public var showBusyIcon(get,set):Bool;
public function  set_showBusyIcon(k:Bool):Bool        {
            return this._Str_21284 = k;
        }
public function  get_showBusyIcon():Bool
        {
            return this._Str_21284;
        }

        public var margins(never,set):ASAny;
public function  set_margins(k:ASAny):ASAny        {
            if (Std.is(k , MarginsSpecification))
            {
                this._Str_3090.linear.marginsSpecification = k;
                this._Str_3090.nonLinear.marginsSpecification = k;
            }
            else
            {
                this._Str_3090.linear.initialise({"margins":k});
                this._Str_3090.nonLinear.initialise({"margins":k});
            }
return k;
        }

        
        public var modes(get,set):ASObject;
public function  set_modes(k:ASObject):ASObject        {
            return this._Str_3090 = k;
        }
public function  get_modes():ASObject
        {
            return this._Str_3090;
        }

        public function getDisplaySpecification(k:String):DisplaySpecification
        {
            return ASCompat.getDynamicProperty(this._Str_3090, k);
        }

        public function shouldManageControlsDuringLinearAds(k:Bool=false):Bool
        {
            return this._Str_3090.linear.shouldManageControlsDuringLinearAds(k);
        }

        public function shouldDisableControlsDuringLinearAds(k:Bool=false):Bool
        {
            return this._Str_3090.linear.shouldDisableControlsDuringLinearAds(k);
        }

        public function shouldHideControlsOnLinearPlayback(k:Bool=false):Bool
        {
            return this._Str_3090.linear.hideControlsOnLinearPlayback(k);
        }

        
        public var hideLogoOnLinearPlayback(get,set):Bool;
public function  set_hideLogoOnLinearPlayback(k:Bool):Bool        {
            this._Str_3090.linear.hideLogo = k;
return k;
        }
public function  get_hideLogoOnLinearPlayback():Bool
        {
            return this._Str_3090.linear.hideLogo;
        }

        public function toString():String
        {
            var _local_3:DisplaySpecification = null;
            var k= (((("{ defaultWidth: " + Std.string(this._Str_15349)) + ", defaultHeight: ") + Std.string(this._Str_15349)) + " ");
            var _local_2= "";
            final _iter_:ASObject = this._Str_3090; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                k = (k + _local_2);
                k = (k + _local_3.toString());
                _local_2 = ", ";
            }
            return k + " } ";
        }
    }

