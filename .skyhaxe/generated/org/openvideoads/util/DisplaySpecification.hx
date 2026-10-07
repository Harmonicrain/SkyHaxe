package org.openvideoads.util
;
    import org.openvideoads.base.Debuggable;

     class DisplaySpecification extends Debuggable 
    {
        public static inline final LINEAR= "linear";
        public static inline final NONLINEAR= "nonLinear";

        var _mode:String = null;
        var _width:Int = 0;
        var _height:Int = 0;
        var _Str_19252:Bool = false;
        var _Str_11897:Bool = false;
        var _Str_8374:MarginsSpecification;
        var _Str_3430:ASObject;

        public function new(k:ASAny)
        {
            this._Str_8374 = new MarginsSpecification();
            this._Str_3430 = {
                "stream":new ControlsSpecification(),
                "vpaid":new ControlsSpecification({
                    "visible":false,
                    "enabled":false
                })
            }
;            super();
            if (Std.is(k , String))
            {
                this._mode = k;
            }
            else
            {
                this.initialise(k);
            }
        }

        public function initialise(k:ASObject)
        {
            if (ASCompat.hasOwnProperty(k, "width"))
            {
                if (Std.is(k.width , String))
                {
                    this.width = ASCompat.parseInt(k.width);
                }
                else
                {
                    this.width = ASCompat.toInt(k.width);
                }
            }
            if (ASCompat.hasOwnProperty(k, "width"))
            {
                if (Std.is(k.height , String))
                {
                    this.height = ASCompat.parseInt(k.height);
                }
                else
                {
                    this.height = ASCompat.toInt(k.height);
                }
            }
            if (ASCompat.hasOwnProperty(k, "hideLogo"))
            {
                if (Std.is(k.height , String))
                {
                    this.hideLogo = StringUtils._Str_2576(k.hideLogo, "TRUE");
                }
                else
                {
                    this.hideLogo = k.hideLogo;
                }
            }
            if (ASCompat.hasOwnProperty(k, "scalable"))
            {
                this.scalable = StringUtils._Str_2810(k.scalable);
            }
            if (ASCompat.hasOwnProperty(k, "controls"))
            {
                this.controls = k.controls;
            }
            if (ASCompat.hasOwnProperty(k, "margins"))
            {
                this.margins = k.margins;
            }
        }

        
        public var width(get,set):Int;
public function  set_width(k:Int):Int        {
            return this._width = k;
        }
public function  get_width():Int
        {
            return this._width;
        }

        
        public var height(get,set):Int;
public function  set_height(k:Int):Int        {
            return this._height = k;
        }
public function  get_height():Int
        {
            return this._height;
        }

        
        public var scalable(get,set):Bool;
public function  set_scalable(k:Bool):Bool        {
            return this._Str_11897 = k;
        }
public function  get_scalable():Bool
        {
            return this._Str_11897;
        }

        
        public var hideLogo(get,set):Bool;
public function  set_hideLogo(k:Bool):Bool        {
            return this._Str_19252 = k;
        }
public function  get_hideLogo():Bool
        {
            return this._Str_19252;
        }

        
        public var controls(get,set):ASObject;
public function  set_controls(k:ASObject):ASObject        {
            if (k != null)
            {
                this._Str_3430.stream.initialise(k);
                this._Str_3430.vpaid.initialise(k);
                if (ASCompat.hasOwnProperty(k, "stream"))
                {
                    this._Str_3430.stream.initialise(k.stream);
                }
                if (ASCompat.hasOwnProperty(k, "vpaid"))
                {
                    this._Str_3430.vpaid.initialise(k.vpaid);
                }
            }
return k;
        }
public function  get_controls():ASObject
        {
            return this._Str_3430;
        }

        
        public var _Str_25819(get,set):ControlsSpecification;
public function  set__Str_25819(k:ControlsSpecification):ControlsSpecification        {
            this._Str_3430.stream = k;
return k;
        }
public function  get__Str_25819():ControlsSpecification
        {
            return this._Str_3430.stream;
        }

        
        public var _Str_23791(get,set):ControlsSpecification;
public function  set__Str_23791(k:ControlsSpecification):ControlsSpecification        {
            this._Str_3430.vpaid = k;
return k;
        }
public function  get__Str_23791():ControlsSpecification
        {
            return this._Str_3430.vpaid;
        }

        public function shouldDisableControlsDuringLinearAds(k:Bool=false):Bool
        {
            if (k)
            {
                return this._Str_3430.vpaid.enabled == false;
            }
            return this._Str_3430.stream.enabled == false;
        }

        public function shouldManageControlsDuringLinearAds(k:Bool=false):Bool
        {
            if (k)
            {
                return this._Str_3430.vpaid.manage;
            }
            return this._Str_3430.stream.manage;
        }

        public function controlEnabledForLinearAdType(k:String, _arg_2:Bool):Bool
        {
            if (this.shouldManageControlsDuringLinearAds(_arg_2) == false)
            {
                return true;
            }
            if (_arg_2)
            {
                return this._Str_3430.vpaid.controlEnabled(k);
            }
            return this._Str_3430.stream.controlEnabled(k);
        }

        public function hideControlsOnLinearPlayback(k:Bool=false):Bool
        {
            if (this.shouldManageControlsDuringLinearAds(k))
            {
                if (k)
                {
                    return this._Str_3430.vpaid.visible == false;
                }
                return this._Str_3430.stream.visible == false;
            }
            return false;
        }

        public function _Str_26198(k:Bool=false):Bool
        {
            if (this.shouldManageControlsDuringLinearAds(k))
            {
                if (k)
                {
                    return this._Str_3430.vpaid.visible == false;
                }
                return this._Str_3430.stream.visible == false;
            }
            return false;
        }

        public var margins(never,set):ASObject;
public function  set_margins(k:ASObject):ASObject        {
            if (this._Str_8374 == null)
            {
                this._Str_8374 = new MarginsSpecification(k);
            }
            else
            {
                this._Str_8374.initialise(k);
            }
return k;
        }

        
        public var marginsSpecification(get,set):MarginsSpecification;
public function  set_marginsSpecification(k:MarginsSpecification):MarginsSpecification        {
            return this._Str_8374 = k;
        }
public function  get_marginsSpecification():MarginsSpecification
        {
            return this._Str_8374;
        }

        public function toString():String
        {
            return ((((("{ mode: " + this._mode) + ", width: ") + Std.string(this.width)) + ", height: ") + Std.string(this.height)) + " }";
        }
    }

