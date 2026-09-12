package org.openvideoads.regions.config
;
    import org.openvideoads.util.StringUtils;
    import org.openvideoads.util.Display;

     class RegionViewConfig extends BaseRegionConfig 
    {
        static var _Str_19960:Array<ASAny> = [{
            "id":"standard-text",
            "html":""
        }];

        var _Str_7287:String = "TOP";
        var _Str_18757:Float = 0;
        var _Str_12474:String = "left";
        var _width:ASAny;
        var _height:ASAny;
        var _Str_5165:Float = -1;
        var _Str_5160:Float = -1;
        var _Str_5202:ASAny = null;
        var _Str_17933:Bool = false;
        var _Str_16388:Bool = true;
        var _Str_18291:Bool = false;
        var _Str_2620:String = null;
        var _Str_17543:String = null;
        var _Str_9188:Bool = false;
        var _Str_17164:Bool = false;
        var _Str_4096:ASAny = 0;
        var _Str_26142:String = null;
        var _Str_11697:Bool = false;
        var _Str_16992:Bool = false;
        var _Str_7726:Bool = true;

        public function new(k:ASObject=null)
        {
            super(k);
        }

        override public function setup(k:ASObject)
        {
            var _local_2:Array<ASAny> = null;
            if (k != null)
            {
                super.setup(k);
                if (k.verticalAlign != /*undefined*/null)
                {
                    if (k.verticalAlign != null)
                    {
                        if (ASCompat.toString(k.verticalAlign).indexOf(":") > -1)
                        {
                            _local_2 = (cast ASCompat.toString(k.verticalAlign).split(":"));
                            if (_local_2.length == 2)
                            {
                                this._Str_7287 = _local_2[0].toUpperCase();
                                this._Str_18757 = ASCompat.parseInt(_local_2[1]);
                            }
                            else
                            {
                                this._Str_7287 = "BOTTOM";
                            }
                        }
                        else
                        {
                            this._Str_7287 = ASCompat.toString(k.verticalAlign).toUpperCase();
                        }
                    }
                }
                if (k.horizontalAlign != /*undefined*/null)
                {
                    this._Str_12474 = k.horizontalAlign;
                }
                if (k.width != /*undefined*/null)
                {
                    this._width = k.width;
                }
                if (k.height != /*undefined*/null)
                {
                    this._height = k.height;
                }
                if (k.expandedWidth != /*undefined*/null)
                {
                    this._Str_5165 = ASCompat.toNumber(k.expandedWidth);
                }
                if (k.expandedHeight != /*undefined*/null)
                {
                    this._Str_5160 = ASCompat.toNumber(k.expandedHeight);
                }
                if (k.autoShow != /*undefined*/null)
                {
                    this._Str_17933 = k.autoShow;
                }
                if (k.clickable != /*undefined*/null)
                {
                    this._Str_16388 = k.clickable;
                }
                if (k.clickToPlay != /*undefined*/null)
                {
                    this._Str_18291 = k.clickToPlay;
                }
                if (k.keepAfterClick != /*undefined*/null)
                {
                    this._Str_9188 = k.keepAfterClick;
                }
                if (k.canScale != /*undefined*/null)
                {
                    this._Str_17164 = k.canScale;
                }
                if (k.additionalHeight != /*undefined*/null)
                {
                    this._Str_4096 = k.additionalHeight;
                }
                if (k.autoSizing != /*undefined*/null)
                {
                    this._Str_11697 = k.autoSizing;
                }
                if (k.useOverrideMargin != /*undefined*/null)
                {
                    this._Str_16992 = k.useOverrideMargin;
                }
                if (k.minimizedHeight != /*undefined*/null)
                {
                    this._Str_5202 = k.minimizedHeight;
                }
                if (k.autoHide != /*undefined*/null)
                {
                    this._Str_7726 = k.autoHide;
                }
            }
        }

        public function isAutoSizing():Bool
        {
            return this._Str_11697;
        }

        
        public var autoSizing(get,set):Bool;
public function  set_autoSizing(k:Bool):Bool        {
            return this._Str_11697 = k;
        }
public function  get_autoSizing():Bool
        {
            return this._Str_11697;
        }

        
        public var autoHide(get,set):ASAny;
public function  set_autoHide(k:ASAny):ASAny        {
            this._Str_7726 = k;
return k;
        }
public function  get_autoHide():ASAny
        {
            return this._Str_7726;
        }

        
        public var width(get,set):ASAny;
public function  set_width(k:ASAny):ASAny        {
            return this._width = k;
        }
public function  get_width():ASAny
        {
            return this._width;
        }

        
        public var height(get,set):ASAny;
public function  set_height(k:ASAny):ASAny        {
            return this._height = k;
        }
public function  get_height():ASAny
        {
            return this._height;
        }

        public function _Str_23701():Bool
        {
            return !(this._Str_5202 == null);
        }

        public function hasMinimizedHeightBasedOnYPosForDisplayMode(k:String):Bool
        {
            if (this._Str_23701())
            {
                if (Std.is(this._Str_5202 , String))
                {
                    if (StringUtils._Str_2576(this._Str_5202, "CONTROLS-YPOS-WHEN-VISIBLE-ALL-MODES"))
                    {
                        return true;
                    }
                    if (StringUtils._Str_2576(k, "FULLSCREEN"))
                    {
                        return StringUtils._Str_2576(this._Str_5202, "CONTROLS-YPOS-WHEN-VISIBLE-FULLSCREEN");
                    }
                    return StringUtils._Str_2576(this._Str_5202, "CONTROLS-YPOS-WHEN-VISIBLE-NORMAL");
                }
            }
            return false;
        }

        
        public var minimizedHeight(get,set):ASAny;
public function  set_minimizedHeight(k:ASAny):ASAny        {
            return this._Str_5202 = k;
        }
public function  get_minimizedHeight():ASAny
        {
            return this._Str_5202;
        }

        public function calculateMinimizedHeight(k:Display):Float
        {
            if (((StringUtils._Str_2576(this._Str_5202, "CONTROLS-YPOS-WHEN-VISIBLE-ALL-MODES") || (k.isNormalMode() && StringUtils._Str_2576(this._Str_5202, "CONTROLS-YPOS-WHEN-VISIBLE-NORMAL"))) || (k._Str_22879() && StringUtils._Str_2576(this._Str_5202, "CONTROLS-YPOS-WHEN-VISIBLE-FULLSCREEN"))))
            {
                if (k._Str_21708)
                {
                    return k._Str_22782;
                }
            }
            return k.displayHeight;
        }

        
        public var expandedHeight(get,set):Float;
public function  set_expandedHeight(k:Float):Float        {
            return this._Str_5160 = k;
        }
public function  get_expandedHeight():Float
        {
            return this._Str_5160;
        }

        
        public var expandedWidth(get,set):Float;
public function  set_expandedWidth(k:Float):Float        {
            return this._Str_5165 = k;
        }
public function  get_expandedWidth():Float
        {
            return this._Str_5165;
        }

        public function hasExpandedSizing():Bool
        {
            return (this._Str_5165 > -1) && (this._Str_5160 > -1);
        }

        
        public var useOverrideMargin(get,set):Bool;
public function  set_useOverrideMargin(k:Bool):Bool        {
            return this._Str_16992 = k;
        }
public function  get_useOverrideMargin():Bool
        {
            return this._Str_16992;
        }

        public function _Str_23622():Bool
        {
            if (this._Str_4096 != null)
            {
                if (Std.is(this._Str_4096 , String))
                {
                    return StringUtils._Str_2576(this._Str_4096, "CONTROLS-HEIGHT-WHEN-NORMAL");
                }
            }
            return false;
        }

        
        public var additionalHeight(get,set):ASAny;
public function  set_additionalHeight(k:ASAny):ASAny        {
            return this._Str_4096 = k;
        }
public function  get_additionalHeight():ASAny
        {
            return this._Str_4096;
        }

        public function _Str_23209():Bool
        {
            return (!(this._Str_4096 == 0)) && (!(this._Str_4096 == null));
        }

        public function _Str_23559(k:Display):Bool
        {
            if (this._Str_4096 != null)
            {
                if (Std.is(this._Str_4096 , String))
                {
                    return StringUtils._Str_2576(this._Str_4096, "CONTROLS-HEIGHT-WHEN-NORMAL") && k.isNormalMode();
                }
            }
            return false;
        }

        public function _Str_20376(k:Display):Float
        {
            if (this._Str_4096 != null)
            {
                if (Std.is(this._Str_4096 , String))
                {
                    if ((StringUtils._Str_2576(this._Str_4096, "CONTROLS-HEIGHT-WHEN-NORMAL") && (!(k == null))))
                    {
                        return k._Str_25295;
                    }
                }
                else
                {
                    return ASCompat.toNumber(this._Str_4096);
                }
            }
            return 0;
        }

        
        public var canScale(get,set):Bool;
public function  set_canScale(k:Bool):Bool        {
            return this._Str_17164 = k;
        }
public function  get_canScale():Bool
        {
            return this._Str_17164;
        }

        
        public var autoShow(get,set):Bool;
public function  set_autoShow(k:Bool):Bool        {
            return this._Str_17933 = k;
        }
public function  get_autoShow():Bool
        {
            return this._Str_17933;
        }

        
        public var keepVisibleAfterClick(get,set):Bool;
public function  set_keepVisibleAfterClick(k:Bool):Bool        {
            return this._Str_9188 = k;
        }
public function  get_keepVisibleAfterClick():Bool
        {
            return this._Str_9188;
        }

        
        public var verticalAlignPosition(get,set):String;
public function  set_verticalAlignPosition(k:String):String        {
            return this._Str_7287 = k;
        }
public function  get_verticalAlignPosition():String
        {
            return this._Str_7287;
        }

        
        public var verticalAlignOffset(get,set):Float;
public function  set_verticalAlignOffset(k:Float):Float        {
            return this._Str_18757 = k;
        }
public function  get_verticalAlignOffset():Float
        {
            return this._Str_18757;
        }

        
        public var horizontalAlign(get,set):String;
public function  set_horizontalAlign(k:String):String        {
            return this._Str_12474 = k;
        }
public function  get_horizontalAlign():String
        {
            return this._Str_12474;
        }

        
        public var clickable(get,set):Bool;
public function  set_clickable(k:Bool):Bool        {
            return this._Str_16388 = k;
        }
public function  get_clickable():Bool
        {
            return this._Str_16388;
        }

        
        public var clickToPlay(get,set):Bool;
public function  set_clickToPlay(k:Bool):Bool        {
            return this._Str_18291 = k;
        }
public function  get_clickToPlay():Bool
        {
            return this._Str_18291;
        }

        
        public var template(get,set):String;
public function  set_template(k:String):String        {
            return this._Str_2620 = k;
        }
public function  get_template():String
        {
            return this._Str_2620;
        }

        public function _Str_18017():Bool
        {
            return !(this._Str_2620 == null);
        }

        
        public var contentTypes(get,set):String;
public function  set_contentTypes(k:String):String        {
            return this._Str_17543 = k;
        }
public function  get_contentTypes():String
        {
            return this._Str_17543;
        }

        public function hasContentTypes():Bool
        {
            return !(this._Str_17543 == null);
        }
    }

