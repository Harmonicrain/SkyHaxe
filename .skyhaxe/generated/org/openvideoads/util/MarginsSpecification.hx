package org.openvideoads.util
;
    import org.openvideoads.base.Debuggable;

     class MarginsSpecification extends Debuggable 
    {
        var _normal:ASObject;
        var _Str_3106:ASObject;

        public function new(k:ASObject=null)
        {
            this._normal = {
                "withControls":0,
                "withControlsOverride":-1,
                "withoutControls":0,
                "withoutControlsOverride":-1
            }
;            this._Str_3106 = {
                "withControls":0,
                "withControlsOverride":-1,
                "withoutControls":0,
                "withoutControlsOverride":-1
            }
;            super();
            this.initialise(k);
        }

        public function initialise(k:ASObject)
        {
            if (k != null)
            {
                this._Str_13982(this._normal, k);
                this._Str_13982(this._Str_3106, k);
                if (ASCompat.hasOwnProperty(k, "normal"))
                {
                    this._Str_21243 = k.normal;
                }
                if (ASCompat.hasOwnProperty(k, "fullscreen"))
                {
                    this._Str_19698 = k.fullscreen;
                }
            }
        }

        
        public var _Str_21243(get,set):ASObject;
public function  set__Str_21243(k:ASObject):ASObject        {
            this._Str_13982(this._normal, k);
return k;
        }
public function  get__Str_21243():ASObject
        {
            return this._normal;
        }

        
        public var _Str_19698(get,set):ASObject;
public function  set__Str_19698(k:ASObject):ASObject        {
            this._Str_13982(this._Str_3106, k);
return k;
        }
public function  get__Str_19698():ASObject
        {
            return this._Str_3106;
        }

        public function getWithControlsMargin(k:String, _arg_2:Bool=false):Float
        {
            if (StringUtils._Str_2576(k, "NORMAL"))
            {
                if (_arg_2)
                {
                    if (ASCompat.hasOwnProperty(this._normal, "withControlsOverride"))
                    {
                        if (this._normal.withControlsOverride > -1)
                        {
                            return ASCompat.toNumber(this._normal.withControlsOverride);
                        }
                    }
                }
                if (ASCompat.hasOwnProperty(this._normal, "withControls"))
                {
                    return ASCompat.toNumber(this._normal.withControls);
                }
            }
            else
            {
                if (_arg_2)
                {
                    if (ASCompat.hasOwnProperty(this._Str_3106, "withControlsOverride"))
                    {
                        if (this._Str_3106.withControlsOverride > -1)
                        {
                            return ASCompat.toNumber(this._Str_3106.withControlsOverride);
                        }
                    }
                }
                if (ASCompat.hasOwnProperty(this._Str_3106, "withControls"))
                {
                    return ASCompat.toNumber(this._Str_3106.withControls);
                }
            }
            return 0;
        }

        public function getWithoutControlsMargin(k:String, _arg_2:Bool=false):Float
        {
            if (StringUtils._Str_2576(k, "NORMAL"))
            {
                if (_arg_2)
                {
                    if (ASCompat.hasOwnProperty(this._normal, "withoutControlsOverride"))
                    {
                        if (this._normal.withoutControlsOverride > -1)
                        {
                            return ASCompat.toNumber(this._normal.withoutControlsOverride);
                        }
                    }
                }
                if (ASCompat.hasOwnProperty(this._normal, "withoutControls"))
                {
                    return ASCompat.toNumber(this._normal.withoutControls);
                }
            }
            else
            {
                if (_arg_2)
                {
                    if (ASCompat.hasOwnProperty(this._Str_3106, "withoutControlsOverride"))
                    {
                        if (this._Str_3106.withoutControlsOverride > -1)
                        {
                            return ASCompat.toNumber(this._Str_3106.withoutControlsOverride);
                        }
                    }
                }
                if (ASCompat.hasOwnProperty(this._Str_3106, "withoutControls"))
                {
                    return ASCompat.toNumber(this._Str_3106.withoutControls);
                }
            }
            return 0;
        }

        public function _Str_25936():Float
        {
            return this.getWithControlsMargin("normal");
        }

        public function _Str_26392():Float
        {
            return this.getWithoutControlsMargin("normal");
        }

        public function _Str_26292():Float
        {
            return this.getWithControlsMargin("fullscreen");
        }

        public function _Str_25998():Float
        {
            return this.getWithoutControlsMargin("fullscreen");
        }

        function _Str_13982(k:ASObject, _arg_2:ASObject)
        {
            if (ASCompat.hasOwnProperty(_arg_2, "withControls"))
            {
                k.withControls = _arg_2.withControls;
            }
            if (ASCompat.hasOwnProperty(_arg_2, "withControlsOverride"))
            {
                k.withControlsOverride = _arg_2.withControlsOverride;
            }
            if (ASCompat.hasOwnProperty(_arg_2, "withoutControls"))
            {
                k.withoutControls = _arg_2.withoutControls;
            }
            if (ASCompat.hasOwnProperty(_arg_2, "withoutControlsOverride"))
            {
                k.withoutControlsOverride = _arg_2.withoutControlsOverride;
            }
        }
    }

