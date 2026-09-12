package org.openvideoads.vast.config.groupings
;
    import org.openvideoads.base.Debuggable;
    import org.openvideoads.util.StringUtils;
    import org.openvideoads.util.ArrayUtils;
    import org.openvideoads.vast.schedule.ads.templates._Str_4426;
    import org.openvideoads.vast.schedule.ads.templates._Str_3048;
    import org.openvideoads.vast.schedule.ads.templates.*;

     class AdSlotRegionConfig extends Debuggable 
    {
        var _Str_4373:Bool = false;
        var _Str_21590:Bool = false;
        var _width:Int = -1;
        var _height:Int = -1;
        var _Str_21979:Array<ASAny> = null;
        var _Str_2442:ASObject = null;
        var _Str_4160:ASObject;
        var _Str_9188:Bool = false;
        var _Str_20518:Bool = false;
        var _Str_9771:Bool = true;
        var _Str_4491:String = "flash";
        var _Str_8367:Bool = true;
        var _Str_13300:ASAny = null;
        var _Str_9491:CloseButtonConfig = null;

        public function new(k:String="flash", _arg_2:ASObject=null, _arg_3:ASObject=null)
        {
            this._Str_4160 = new ASObject();
            super();
            this._Str_4491 = k;
            if (_arg_2 != null)
            {
                this.initialise(_arg_2, _arg_3);
            }
        }

        public function initialise(k:ASObject, _arg_2:ASObject=null)
        {
            if (k != null)
            {
                if (ASCompat.hasOwnProperty(k, "enable"))
                {
                    this.enable = k.enable;
                }
                if (ASCompat.hasOwnProperty(k, "prefer"))
                {
                    this.prefer = k.prefer;
                }
                if (ASCompat.hasOwnProperty(k, "width"))
                {
                    this.width = k.width;
                }
                if (ASCompat.hasOwnProperty(k, "height"))
                {
                    this.height = k.height;
                }
                if (ASCompat.hasOwnProperty(k, "acceptedAdTypes"))
                {
                    this.acceptedAdTypes = k.acceptedAdTypes;
                }
                if (ASCompat.hasOwnProperty(k, "keepVisibleAfterClick"))
                {
                    this.keepVisibleAfterClick = k.keepVisibleAfterClick;
                }
                if (ASCompat.hasOwnProperty(k, "enableScaling"))
                {
                    this.enableScaling = k.enableScaling;
                }
                if (ASCompat.hasOwnProperty(k, "enforceRecommendedSizing"))
                {
                    this.enforceRecommendedSizing = k.enforceRecommendedSizing;
                }
                if (ASCompat.hasOwnProperty(k, "region"))
                {
                    this.region = k.region;
                }
                if (ASCompat.hasOwnProperty(k, "templates"))
                {
                    this.templates = k.templates;
                }
                if (ASCompat.hasOwnProperty(k, "overlay"))
                {
                    this.overlay = k.overlay;
                }
                if (ASCompat.hasOwnProperty(k, "alwaysMatch"))
                {
                    this.alwaysMatch = k.alwaysMatch;
                }
                if (ASCompat.hasOwnProperty(k, "closeButton"))
                {
                    this._Str_9491 = new CloseButtonConfig(k.closeButton);
                }
                else
                {
                    this._Str_9491 = null;
                }
                if (_arg_2 != null)
                {
                    if (ASCompat.hasOwnProperty(_arg_2, "enable"))
                    {
                        this.enable = _arg_2.enable;
                    }
                    if (ASCompat.hasOwnProperty(_arg_2, "prefer"))
                    {
                        this.prefer = _arg_2.prefer;
                    }
                    if (ASCompat.hasOwnProperty(_arg_2, "width"))
                    {
                        this.width = _arg_2.width;
                    }
                    if (ASCompat.hasOwnProperty(_arg_2, "height"))
                    {
                        this.height = _arg_2.height;
                    }
                    if (ASCompat.hasOwnProperty(_arg_2, "acceptedAdTypes"))
                    {
                        this.acceptedAdTypes = _arg_2.acceptedAdTypes;
                    }
                    if (ASCompat.hasOwnProperty(_arg_2, "keepVisibleAfterClick"))
                    {
                        this.keepVisibleAfterClick = _arg_2.keepVisibleAfterClick;
                    }
                    if (ASCompat.hasOwnProperty(_arg_2, "enableScaling"))
                    {
                        this.enableScaling = _arg_2.enableScaling;
                    }
                    if (ASCompat.hasOwnProperty(_arg_2, "enforceRecommendedSizing"))
                    {
                        this.enforceRecommendedSizing = _arg_2.enforceRecommendedSizing;
                    }
                    if (ASCompat.hasOwnProperty(_arg_2, "region"))
                    {
                        this.region = _arg_2.region;
                    }
                    if (ASCompat.hasOwnProperty(_arg_2, "templates"))
                    {
                        this.templates = _arg_2.templates;
                    }
                    if (ASCompat.hasOwnProperty(_arg_2, "overlay"))
                    {
                        this.overlay = _arg_2.overlay;
                    }
                    if (ASCompat.hasOwnProperty(_arg_2, "alwaysMatch"))
                    {
                        this.alwaysMatch = _arg_2.alwaysMatch;
                    }
                    if (ASCompat.hasOwnProperty(_arg_2, "closeButton"))
                    {
                        this._Str_9491 = new CloseButtonConfig(_arg_2.closeButton);
                    }
                }
            }
        }

        public var displayMode(get,never):String;
public function  get_displayMode():String
        {
            return this._Str_4491;
        }

        
        public var enable(get,set):Bool;
public function  set_enable(k:ASAny):Bool        {
            this._Str_4373 = StringUtils._Str_2810(k);
return k;
        }
public function  get_enable():Bool
        {
            return this._Str_4373;
        }

        public function _Str_26186():Bool
        {
            if (this._Str_9491 != null)
            {
                return this._Str_9491.enabled;
            }
            return false;
        }

        public var buttonConfig(get,never):CloseButtonConfig;
public function  get_buttonConfig():CloseButtonConfig
        {
            return this._Str_9491;
        }

        
        public var overlay(get,set):Bool;
public function  set_overlay(k:ASAny):Bool        {
            this._Str_8367 = StringUtils._Str_2810(k);
return k;
        }
public function  get_overlay():Bool
        {
            return this._Str_8367;
        }

        
        public var prefer(get,set):Bool;
public function  set_prefer(k:ASAny):Bool        {
            this._Str_21590 = StringUtils._Str_2810(k);
return k;
        }
public function  get_prefer():Bool
        {
            return this._Str_21590;
        }

        public function hasSize():Bool
        {
            return this.hasWidthSpecified() && this.hasHeightSpecified();
        }

        public function hasWidthSpecified():Bool
        {
            return this.width > -1;
        }

        
        public var width(get,set):Int;
public function  set_width(k:ASAny):Int        {
            if (Std.is(k , String))
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

        public function hasHeightSpecified():Bool
        {
            return this.height > -1;
        }

        
        public var height(get,set):Int;
public function  set_height(k:ASAny):Int        {
            if (Std.is(k , String))
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

        
        public var enableScaling(get,set):Bool;
public function  set_enableScaling(k:ASAny):Bool        {
            this._Str_20518 = StringUtils._Str_2810(k);
return k;
        }
public function  get_enableScaling():Bool
        {
            return this._Str_20518;
        }

        public function _Str_26192():Bool
        {
            return !(this._Str_13300 == null);
        }

        
        public var alwaysMatch(get,set):Bool;
public function  set_alwaysMatch(k:ASAny):Bool        {
            this._Str_13300 = StringUtils._Str_2810(k);
return k;
        }
public function  get_alwaysMatch():Bool
        {
            if (this._Str_13300 == null)
            {
                if (((this.width < 0) && (this.height < 0)))
                {
                    return true;
                }
                return false;
            }
            return this._Str_13300;
        }

        
        public var enforceRecommendedSizing(get,set):Bool;
public function  set_enforceRecommendedSizing(k:Bool):Bool        {
            return this._Str_9771 = k;
        }
public function  get_enforceRecommendedSizing():Bool
        {
            return this._Str_9771;
        }

        
        public var keepVisibleAfterClick(get,set):Bool;
public function  set_keepVisibleAfterClick(k:Bool):Bool        {
            return this._Str_9188 = k;
        }
public function  get_keepVisibleAfterClick():Bool
        {
            return this._Str_9188;
        }

        
        public var acceptedAdTypes(get,set):Array<ASAny>;
public function  set_acceptedAdTypes(k:ASAny):Array<ASAny>        {
            if (Std.is(k , Array))
            {
                this._Str_21979 = ArrayUtils.toUpperCase(k);
            }
return k;
        }
public function  get_acceptedAdTypes():Array<ASAny>
        {
            return this._Str_21979;
        }

        
        public var region(get,set):ASObject;
public function  set_region(k:ASObject):ASObject        {
            return this._Str_2442 = k;
        }
public function  get_region():ASObject
        {
            return this._Str_2442;
        }

        public function _Str_25238(k:String):String
        {
            var _local_2:String = null;
            if (((!(this._Str_2442 == null)) && (!(k == null))))
            {
                _local_2 = k.toLowerCase();
                if (ASCompat.hasOwnProperty(this._Str_2442, _local_2))
                {
                    return ASCompat.getDynamicProperty(this._Str_2442, _local_2);
                }
            }
            return "auto:bottom";
        }

        
        public var templates(get,set):ASObject;
public function  set_templates(k:ASObject):ASObject        {
            return this._Str_4160 = k;
        }
public function  get_templates():ASObject
        {
            return this._Str_4160;
        }

        public function _Str_23774(k:String):_Str_3048
        {
            var _local_2:String = null;
            if (((!(this._Str_4160 == null)) && (!(k == null))))
            {
                _local_2 = k.toLowerCase();
                if (ASCompat.hasOwnProperty(this._Str_4160, _local_2))
                {
                    return ASCompat.getDynamicProperty(this._Str_4160, _local_2);
                }
            }
            return new _Str_4426();
        }
    }

