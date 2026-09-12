package org.openvideoads.regions.view
;
    import flash.display.Sprite;
    import org.openvideoads.regions.RegionController;
    import org.openvideoads.regions.config.RegionViewConfig;
    import org.openvideoads.util.Display;
    import flash.text.TextField;
    import org.openvideoads.regions.view.button.CloseButton;
    import flash.display.Loader;
    import flash.display.Shape;
    import flash.display.Bitmap;
    import org.openvideoads.regions.view.button._Str_12411;
    import org.openvideoads.regions.view.button._Str_11624;
    import org.openvideoads.regions.view.button._Str_9873;
    import org.openvideoads.util.NumberUtils;
    import org.openvideoads.util.StyleUtils;
    import flash.events.MouseEvent;
    import org.openvideoads.base.Debuggable;
    import flash.system.Security;
    import flash.events.IOErrorEvent;
    import flash.events.Event;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLRequest;
    import flash.system.LoaderContext;
    import flash.system.ApplicationDomain;
    import flash.system.SecurityDomain;
    import org.openvideoads.util.GraphicsUtils;
    import flash.display.BlendMode;
    import flash.text.TextFieldAutoSize;
    import flash.text.AntiAliasType;
    import flash.display.*;

     class RegionView extends Sprite 
    {
        var _controller:RegionController;
        var _Str_2297:RegionViewConfig;
        var _Str_2758:Display;
        var _Str_5857:_Str_5987 = null;
        var _text:TextField;
        var _Str_9713:Sprite;
        var _closeButton:CloseButton = null;
        var _Str_7726:Bool = true;
        var _Str_2450:Loader = null;
        var _border:Sprite;
        var _width:Float = 0;
        var _height:Float = 0;
        var _Str_11697:Bool = false;
        var _Str_3322:_Str_4027 = null;
        var _Str_4922:Shape = null;
        var _Str_3400:Bitmap = null;
        var _Str_11897:Bool = true;
        var _Str_10200:Bool = false;
        var _Str_2623:Bool = false;

        public function new(k:RegionController, _arg_2:RegionViewConfig, _arg_3:Display)
        {
            super();
            visible = false;
            buttonMode = true;
            mouseChildren = true;
            this._controller = k;
            this._Str_2297 = _arg_2;
            this._Str_2758 = _arg_3;
            this._Str_7726 = _arg_2.autoHide;
            if (_arg_2.stylesheet != null)
            {
                this._Str_5857 = new _Str_5987(_arg_2.stylesheet, this._Str_25781);
            }
            if (_arg_2.style != null)
            {
                if (this._Str_5857 == null)
                {
                    this._Str_5857 = new _Str_5987();
                }
                this._Str_5857.parseCSS(_arg_2.style);
            }
            if (this._Str_2297._Str_16602())
            {
                this._Str_24053();
            }
            this._Str_19314();
            if (ASCompat.stringAsBool(this._Str_2297.html))
            {
                this.html = this._Str_2297.html;
            }
            this.resize();
            this._Str_6950();
        }

        public function isAutoSizing():Bool
        {
            return this.autoSizing;
        }

        
        public var autoSizing(get,set):Bool;
public function  set_autoSizing(k:Bool):Bool        {
            if (this._Str_2297 == null)
            {
                this._Str_2297 = new RegionViewConfig();
            }
            return this._Str_2297.autoSizing = k;
        }
public function  get_autoSizing():Bool
        {
            if (this._Str_2297 != null)
            {
                return this._Str_2297.autoSizing;
            }
            return false;
        }

        
        public var scalable(get,set):Bool;
public function  set_scalable(k:Bool):Bool        {
            return this._Str_11897 = k;
        }
public function  get_scalable():Bool
        {
            return this._Str_11897;
        }

        function _Str_24053()
        {
            switch (this._Str_2297.closeButton.type)
            {
                case "STANDARD":
                    this._closeButton = new _Str_12411(null, this);
                    
                case "CROSSHAIR":
                    this._closeButton = new _Str_11624(null, this, this._Str_2297.closeButton);
                    
                case "CUSTOM":
                    this._closeButton = new _Str_9873(null, this, this._Str_2297.closeButton);
                    
                case "SKINNED":
                    
            }
            addChild(this._closeButton);
        }

        override public function  get_width():Float
        {
            if (scaleX > 1)
            {
                return this._width * scaleX;
            }
            return if (ASCompat.floatAsBool(this._width)) this._width; else super.width;
        }

        override public function  set_width(k:Float):Float        {
            this.setSize(k, this._height);
return k;
        }

        public var _Str_26004(never,set):Float;
public function  set__Str_26004(k:Float):Float        {
            if (this._Str_2297 != null)
            {
                this._Str_2297.width = k;
            }
            this.setSize(k, this._height, false);
return k;
        }

        override public function  get_height():Float
        {
            if (scaleY > 1)
            {
                return this._height * scaleY;
            }
            return if (ASCompat.floatAsBool(this._height)) this._height; else super.height;
        }

        override public function  set_height(k:Float):Float        {
            this.setSize(this._width, k);
return k;
        }

        public var _Str_26129(never,set):Float;
public function  set__Str_26129(k:Float):Float        {
            if (this._Str_2297 != null)
            {
                this._Str_2297.height = k;
            }
            this.setSize(this._width, k, false);
return k;
        }

        public function setSize(k:Float, _arg_2:Float, _arg_3:Bool=true)
        {
            this._width = k;
            this._height = _arg_2;
            this.onResize();
            if (_arg_3)
            {
                this._Str_6950();
            }
        }

        
        public var borderRadius(get,set):Int;
public function  set_borderRadius(k:Int):Int        {
            if (this._Str_2297 != null)
            {
                this._Str_2297.borderRadius = k;
            }
return k;
        }
public function  get_borderRadius():Int
        {
            return (this._Str_2297 != null) ? this._Str_2297.borderRadius : -1;
        }

        public function _Str_18926():Bool
        {
            return (this._Str_2297 != null) ? this._Str_2297._Str_18926() : false;
        }

        public function _Str_26285():Int
        {
            if (this._Str_18926() == false)
            {
                return 5;
            }
            return Std.int(NumberUtils._Str_5288(this.borderRadius));
        }

        
        public var borderWidth(get,set):Int;
public function  set_borderWidth(k:Int):Int        {
            if (this._Str_2297 != null)
            {
                this._Str_2297.borderWidth = k;
            }
return k;
        }
public function  get_borderWidth():Int
        {
            return (this._Str_2297 != null) ? this._Str_2297.borderWidth : -1;
        }

        public function _Str_15962():Bool
        {
            return (this._Str_2297 != null) ? this._Str_2297._Str_15962() : false;
        }

        
        public var borderColor(get,set):String;
public function  set_borderColor(k:String):String        {
            if (this._Str_2297 != null)
            {
                this._Str_2297.borderColor = k;
            }
return k;
        }
public function  get_borderColor():String
        {
            return (this._Str_2297 != null) ? this._Str_2297.borderColor : null;
        }

        public function _Str_16762():Bool
        {
            return (this._Str_2297 != null) ? this._Str_2297._Str_16762() : false;
        }

        
        public var border(get,set):String;
public function  set_border(k:String):String        {
            if (this._Str_2297 != null)
            {
                this._Str_2297.border = k;
            }
return k;
        }
public function  get_border():String
        {
            return (this._Str_2297 != null) ? this._Str_2297.border : null;
        }

        public function _Str_14610():Bool
        {
            return (this._Str_2297 != null) ? this._Str_2297._Str_14610() : false;
        }

        public function _Str_26318():Float
        {
            if (this._Str_15962())
            {
                return NumberUtils._Str_5288(this.borderWidth);
            }
            if (this._Str_14610() == false)
            {
                return 0;
            }
            return NumberUtils._Str_5288(StyleUtils._Str_11604(this.border)[0]);
        }

        public function _Str_23277():UInt
        {
            if (this._Str_16762())
            {
                return StyleUtils._Str_12804(this.borderColor);
            }
            if (this._Str_14610())
            {
                return StyleUtils._Str_12804(StyleUtils._Str_11604(this.border)[2]);
            }
            return 0xFFFFFF;
        }

        public function parseCSS(k:String)
        {
            if (this._Str_5857 == null)
            {
                this._Str_5857 = new _Str_5987();
            }
            this._Str_5857.parseCSS(k);
        }

        
        public var background(get,set):String;
public function  set_background(k:String):String        {
            if (this._Str_2297 != null)
            {
                this._Str_2297.background = k;
            }
return k;
        }
public function  get_background():String
        {
            return (this._Str_2297 != null) ? this._Str_2297.background : null;
        }

        public function _Str_18749():Bool
        {
            return (this._Str_2297 != null) ? this._Str_2297._Str_18749() : false;
        }

        
        public var backgroundGradient(get,set):ASAny;
public function  set_backgroundGradient(k:ASAny):ASAny        {
            if (this._Str_2297 != null)
            {
                this._Str_2297.backgroundGradient = k;
            }
return k;
        }
public function  get_backgroundGradient():ASAny
        {
            return (this._Str_2297 != null) ? this._Str_2297.backgroundGradient : null;
        }

        public function _Str_16430():Bool
        {
            return (this._Str_2297 != null) ? this._Str_2297._Str_16430() : false;
        }

        public function _Str_26288():Array<ASAny>
        {
            if (this._Str_16430())
            {
                if (Std.is(this.backgroundGradient , String))
                {
                    switch (this.backgroundGradient)
                    {
                        case "none":
                            return null;
                        case "high":
                            return [1, 0.5, 0.1, 0.3];
                        case "medium":
                            return [0.6, 0.21, 0.21];
                        case "low":
                            return [0.4, 0.15, 0.15];
                    }
                    return [0.4, 0.15, 0.15];
                }
                return this.backgroundGradient;
            }
            return null;
        }

        public function _Str_11493()
        {
            if (this._Str_2297 != null)
            {
                this._Str_2297._Str_11493();
                this._Str_6950();
            }
        }

        public function _Str_12711()
        {
            if (this._Str_2297 != null)
            {
                this._Str_2297._Str_12711();
                this._Str_6950();
            }
        }

        public var _Str_23263(never,set):Bool;
public function  set__Str_23263(k:Bool):Bool        {
            if (this._Str_2297 != null)
            {
                this._Str_2297.backgroundColor = (k ? "transparent" : null);
            }
return k;
        }

        public function _Str_24625():Bool
        {
            if (this._Str_15500() == false)
            {
                return false;
            }
            return this.backgroundColor.toUpperCase() == "TRANSPARENT";
        }

        
        public var backgroundColor(get,set):String;
public function  set_backgroundColor(k:String):String        {
            if (this._Str_2297 != null)
            {
                this._Str_2297.backgroundColor = k;
            }
return k;
        }
public function  get_backgroundColor():String
        {
            return (this._Str_2297 != null) ? this._Str_2297.backgroundColor : null;
        }

        public function _Str_15500():Bool
        {
            return (this._Str_2297 != null) ? this._Str_2297._Str_15500() : false;
        }

        public function _Str_23813():UInt
        {
            var k:Array<ASAny> = null;
            if (this._Str_15500())
            {
                return StyleUtils._Str_12804(this.backgroundColor);
            }
            if (this._Str_18749())
            {
                k = StyleUtils._Str_11604(this.backgroundColor);
                if (ASCompat.toString(k[0]).indexOf("#") == 0)
                {
                    return StyleUtils._Str_12804(k[0]);
                }
            }
            return 0x333333;
        }

        
        public var opacity(get,set):Float;
public function  set_opacity(k:Float):Float        {
            if (this._Str_2297 != null)
            {
                this._Str_2297.opacity = k;
            }
return k;
        }
public function  get_opacity():Float
        {
            return (this._Str_2297 != null) ? this._Str_2297.opacity : 1;
        }

        public function _Str_16995():Bool
        {
            return (this._Str_2297 != null) ? this._Str_2297._Str_16995() : false;
        }

        public function _Str_19536()
        {
            if (this._closeButton != null)
            {
                this._closeButton.visible = false;
            }
        }

        public function _Str_16602():Bool
        {
            return (this._Str_2297 != null) ? this._Str_2297._Str_16602() : false;
        }

        
        public var padding(get,set):String;
public function  set_padding(k:String):String        {
            if (this._Str_2297 != null)
            {
                this._Str_2297.padding = k;
            }
return k;
        }
public function  get_padding():String
        {
            return (this._Str_2297 != null) ? this._Str_2297.padding : null;
        }

        public var template(get,never):String;
public function  get_template():String
        {
            return (this._Str_2297 != null) ? this._Str_2297.template : null;
        }

        public function _Str_18017():Bool
        {
            return (this._Str_2297 != null) ? this._Str_2297._Str_18017() : false;
        }

        public var contentTypes(get,never):String;
public function  get_contentTypes():String
        {
            return (this._Str_2297 != null) ? this._Str_2297.contentTypes : null;
        }

        public function hasContentTypes():Bool
        {
            return (this._Str_2297 != null) ? this._Str_2297.hasContentTypes() : false;
        }

        function _Str_25781()
        {
        }

        public var id(get,never):String;
public function  get_id():String
        {
            return (this._Str_2297 != null) ? this._Str_2297.id : "none";
        }

        function _Str_19314()
        {
            if (this._Str_2297.clickable)
            {
                addEventListener(MouseEvent.ROLL_OVER, (this.onMouseOver : ASAny));
                addEventListener(MouseEvent.ROLL_OUT, (this.onMouseOut : ASAny));
                addEventListener(MouseEvent.CLICK, (this.onClick : ASAny));
            }
        }

        function removeListeners()
        {
            if (this._Str_2297.clickable)
            {
                removeEventListener(MouseEvent.ROLL_OVER, (this.onMouseOver : ASAny));
                removeEventListener(MouseEvent.ROLL_OUT, (this.onMouseOut : ASAny));
                removeEventListener(MouseEvent.CLICK, (this.onClick : ASAny));
            }
        }

        public function _Str_20907():Bool
        {
            var _local_2:ASAny = null;
            var _local_3 = 0;
            var _local_4 = 0;
            var k= this.width;
            if ((this.expanded && this._Str_2297.hasExpandedSizing()))
            {
                this.width = this._Str_2297.expandedWidth;
                return true;
            }
            _local_2 = this._Str_2297.width;
            if (ASCompat.typeOf(_local_2) == "string")
            {
                if (_local_2.indexOf("pct") != -1)
                {
                    _local_3 = Std.int(this._Str_2758.displayWidth);
                    _local_4 = ASCompat.parseInt(_local_2.substring(0, _local_2.indexOf("pct")));
                    this.width = ((_local_3 / 100) * _local_4);
                }
                else
                {
                    this.width = ASCompat.parseInt(_local_2);
                }
            }
            else
            {
                if (Std.is(_local_2 , Float))
                {
                    this.width = ASCompat.toNumber(_local_2);
                }
            }
            return !(this.width == k);
        }

        public function setHeight():Bool
        {
            var _local_2:ASAny = null;
            var _local_3 = 0;
            var _local_4 = 0;
            var _local_5 = Math.NaN;
            var k= this.height;
            if (!this.expanded)
            {
                _local_2 = this._Str_2297.height;
                if (ASCompat.typeOf(_local_2) == "string")
                {
                    if (_local_2.indexOf("pct") != -1)
                    {
                        _local_3 = 0;
                        if ((this._Str_2297._Str_23209() && (this.minimized == false)))
                        {
                            _local_5 = 0;
                            if (this._Str_2297._Str_23622())
                            {
                                if (this._Str_2297._Str_23559(this._Str_2758))
                                {
                                    _local_5 = this._Str_2297._Str_20376(this._Str_2758);
                                }
                            }
                            else
                            {
                                _local_5 = this._Str_2297._Str_20376(this._Str_2758);
                            }
                            _local_3 = Std.int(this._Str_2758.getMarginAdjustedHeight(this._Str_2297.useOverrideMargin) + _local_5);
                        }
                        else
                        {
                            _local_3 = Std.int(this._Str_2758.getMarginAdjustedHeight(this._Str_2297.useOverrideMargin));
                        }
                        _local_4 = ASCompat.parseInt(_local_2.substring(0, _local_2.indexOf("pct")));
                        this.height = ((_local_3 / 100) * _local_4);
                    }
                    else
                    {
                        this.height = ASCompat.parseInt(_local_2);
                    }
                }
                else
                {
                    if (Std.is(_local_2 , Float))
                    {
                        this.height = ASCompat.toNumber(_local_2);
                    }
                }
            }
            return !(this.height == k);
        }

        public function setVerticalAlignment():Bool
        {
            var k= y;
            var _local_2= Std.int(this._Str_2758.displayHeight * scaleY);
            if (Std.is(this._Str_2297.verticalAlignPosition , String))
            {
                if (this._Str_2297.verticalAlignPosition == "TOP")
                {
                    y = (0 + this._Str_2297.verticalAlignOffset);
                }
                else
                {
                    if (this._Str_2297.verticalAlignPosition == "BOTTOM")
                    {
                        y = ((_local_2 - this.height) + this._Str_2297.verticalAlignOffset);
                    }
                    else
                    {
                        if (this._Str_2297.verticalAlignPosition == "CENTER")
                        {
                            y = (((_local_2 - this.height) / 2) + this._Str_2297.verticalAlignOffset);
                        }
                        else
                        {
                            y = ASCompat.toNumber((this._Str_2297.verticalAlignPosition + Std.string(this._Str_2297.verticalAlignOffset)));
                        }
                    }
                }
            }
            else
            {
                y = ASCompat.asNumber(this._Str_2297.verticalAlignPosition );
                y = (y + this._Str_2297.verticalAlignOffset);
            }
            return !(y == k);
        }

        public function _Str_19673():Bool
        {
            var k= x;
            var _local_2:ASAny = this._Str_2297.horizontalAlign;
            var _local_3= Std.int(this._Str_2758.displayWidth * scaleX);
            if (ASCompat.typeOf(_local_2) == "string")
            {
                _local_2 = _local_2.toUpperCase();
                if (_local_2 == "LEFT")
                {
                    x = 0;
                }
                else
                {
                    if (_local_2 == "RIGHT")
                    {
                        x = (_local_3 - this.width);
                    }
                    else
                    {
                        if (_local_2 == "CENTER")
                        {
                            x = ((_local_3 - this.width) / 2);
                        }
                        else
                        {
                            x = ASCompat.toNumber(_local_2);
                        }
                    }
                }
            }
            else
            {
                if (ASCompat.typeOf(_local_2) == "number")
                {
                    x = ASCompat.toNumber(_local_2);
                }
            }
            return !(x == k);
        }

        
        public var minimized(get,set):Bool;
public function  set_minimized(k:Bool):Bool        {
            return this._Str_10200 = k;
        }
public function  get_minimized():Bool
        {
            return this._Str_10200;
        }

        public function minimize()
        {
            this._Str_10200 = true;
            this._Str_11493();
            this.resize();
        }

        public function restore()
        {
            if (this._Str_10200)
            {
                this._Str_10200 = false;
                this._Str_12711();
                this.resize();
            }
        }

        
        public var expanded(get,set):Bool;
public function  set_expanded(k:Bool):Bool        {
            return this._Str_2623 = k;
        }
public function  get_expanded():Bool
        {
            return this._Str_2623;
        }

        public function expand()
        {
            if (this.expanded == false)
            {
                this.expanded = true;
                this.resize(this._Str_2758);
            }
        }

        public function _Str_23314()
        {
            if (this.expanded)
            {
                this.expanded = false;
                this._Str_11493();
                this.resize(this._Str_2758);
            }
        }

        public function resize(k:Display=null)
        {
            var _local_2 = false;
            var _local_3 = false;
            if (k != null)
            {
                this._Str_2758 = k;
                scaleX = (this._Str_2297.canScale ? k.scaleX : 1);
                scaleY = (this._Str_2297.canScale ? k.scaleY : 1);
            }
            if (this._Str_2758 != null)
            {
                _local_2 = this._Str_20907();
                _local_3 = this.setHeight();
                this.setVerticalAlignment();
                this._Str_19673();
                if ((this._Str_22704() && (_local_2 || _local_3)))
                {
                    this._Str_17768();
                }
            }
        }

        
        public var autoHide(get,set):Bool;
public function  set_autoHide(k:Bool):Bool        {
            return this._Str_7726 = k;
        }
public function  get_autoHide():Bool
        {
            return this._Str_7726;
        }

        
        public var html(get,set):String;
public function  set_html(k:String):String        {
            if (this._Str_2297 != null)
            {
                this._Str_2297.html = ((k == null) ? "" : k);
                this.createTextField();
                this._Str_8978();
            }
return k;
        }
public function  get_html():String
        {
            return (this._Str_2297 != null) ? this._Str_2297.html : null;
        }

        public function resizeDimensions(k:Float, _arg_2:Float)
        {
            this._Str_2297.width = k;
            this._Str_2297.height = _arg_2;
            this._Str_20907();
            this.setHeight();
            this.setVerticalAlignment();
            this._Str_19673();
        }

        function _Str_22704():Bool
        {
            if (((!(this._Str_3322 == null)) && (!(this._Str_2450 == null))))
            {
                return this._Str_3322.scale;
            }
            return false;
        }

        function _Str_19104(k:Float, _arg_2:Float)
        {
            var _local_3 = Math.NaN;
            if (this._Str_3322.maintainAspectRatio)
            {
                _local_3 = 1;
                if (((k > this._width) && (Math.abs((k - this._width)) > Math.abs((_arg_2 - this._height)))))
                {
                    _local_3 = (k / this._width);
                }
                else
                {
                    _local_3 = (_arg_2 / this._height);
                }
                this._Str_2450.width = Math.ffloor((k / _local_3));
                this._Str_2450.height = Math.ffloor((_arg_2 / _local_3));
            }
            else
            {
                if (k > this._width)
                {
                    this._Str_2450.width = this._width;
                }
                if (_arg_2 > this._height)
                {
                    this._Str_2450.height = this._height;
                }
            }
        }

        function _Str_17768()
        {
            if (this.scalable)
            {
                if (((!(this._Str_3322 == null)) && (!(this._Str_2450 == null))))
                {
                    this._Str_16801(((((((("enforceRecommendedSizing = " + Std.string(this._Str_3322.enforceRecommendedSizing)) + ", scale = ") + Std.string(this._Str_3322.scale)) + " recommendedWidth = ") + Std.string(this._Str_3322.recommendedWidth)) + " recommendedHeight = ") + Std.string(this._Str_3322.recommendedHeight)), Debuggable._Str_12852);
                    if (this._Str_3322.loaded)
                    {
                        if (this._Str_3322.scale)
                        {
                            if (this._Str_3322.enforceRecommendedSizing)
                            {
                                if (((this._Str_3322.recommendedHeight > this._height) || (this._Str_3322.recommendedWidth > this._width)))
                                {
                                    this._Str_19104(this._Str_3322.recommendedWidth, this._Str_3322.recommendedHeight);
                                }
                            }
                            else
                            {
                                if (((this._Str_2450.height > this._height) || (this._Str_2450.width > this._width)))
                                {
                                    this._Str_19104(this._Str_2450.width, this._Str_2450.height);
                                }
                            }
                            if (this.isAutoSizing())
                            {
                                this.resizeDimensions(this._Str_2450.width, this._Str_2450.height);
                            }
                            else
                            {
                                if (((this._Str_2450.width > 0) && (this._Str_2450.width < this._width)))
                                {
                                    this._Str_2450.x = (0 + Math.ffloor(((this._width - this._Str_2450.width) / 2)));
                                }
                                if (((this._Str_2450.height > 0) && (this._Str_2450.height < this._height)))
                                {
                                    this._Str_2450.y = (0 + Math.ffloor(((this._height - this._Str_2450.height) / 2)));
                                }
                            }
                        }
                    }
                }
            }
        }

        function _Str_22127(url:String, expectedWidth:Float, expectedHeight:Float, recommendedWidth:Float, recommendedHeight:Float, scaleToDeclaredSize:Bool, maintainAspectRatio:Bool, allowDomains:String)
        {
            if (url != null)
            {
                this._Str_13579();
                Security.allowDomain([allowDomains]);
                Security.allowInsecureDomain([allowDomains]);
                this._Str_2450 = new Loader();
                this._Str_2450.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, (function (k:Event)
                {
                } : ASAny));
                this._Str_2450.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, (function (k:Event)
                {
                } : ASAny));
                this._Str_2450.contentLoaderInfo.addEventListener(Event.COMPLETE, (function (k:Event)
                {
                    var _local_2 = Math.NaN;
                    var _local_3 = Math.NaN;
                    _Str_3400 = cast(_Str_2450.content, Bitmap);
                    _Str_3400.x = 0;
                    _Str_3400.y = 0;
                    if (scalable)
                    {
                        _local_2 = (recommendedWidth / _Str_3400.width);
                        _local_3 = (recommendedHeight / _Str_3400.height);
                        if (scaleToDeclaredSize)
                        {
                            _Str_3400.scaleX = _local_2;
                            _Str_3400.scaleY = _local_3;
                        }
                        else
                        {
                            if (_local_2 < _local_3)
                            {
                                if (maintainAspectRatio)
                                {
                                    _Str_3400.scaleX = (_Str_3400.scaleY = _local_2);
                                }
                                else
                                {
                                    _Str_3400.scaleX = _local_2;
                                }
                            }
                            else
                            {
                                if (maintainAspectRatio)
                                {
                                    _Str_3400.scaleX = (_Str_3400.scaleY = _local_3);
                                }
                                else
                                {
                                    _Str_3400.scaleX = _local_3;
                                }
                            }
                        }
                        if (isAutoSizing())
                        {
                            resizeDimensions(_Str_3400.width, _Str_3400.height);
                        }
                    }
                    addChild(_Str_3400);
                    _Str_8978();
                    _Str_3400.visible = true;
                    _Str_2450 = null;
                } : ASAny));
                this._Str_2450.load(new URLRequest(url), new LoaderContext(true, ApplicationDomain.currentDomain, SecurityDomain.currentDomain));
            }
        }

        public function _Str_15552(media:_Str_4027, allowDomains:String, blockMouseActions:Bool=false)
        {
            this._Str_13579();
            Security.allowDomain([allowDomains]);
            Security.allowInsecureDomain([allowDomains]);
            this._Str_2450 = new Loader();
            this._Str_3322 = media;
            this._Str_3322._Str_3654();
            var urlReq= new URLRequest(media._Str_12737);
            this._Str_2450.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, (function (k:Event)
            {
                if (_Str_3322 != null)
                {
                    _Str_3322.signalLoadError("IO Error loading external SWF");
                }
            } : ASAny));
            this._Str_2450.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, (function (k:Event)
            {
                if (_Str_3322 != null)
                {
                    _Str_3322.signalLoadError("Security Error loading external SWF");
                }
            } : ASAny));
            this._Str_2450.contentLoaderInfo.addEventListener(Event.COMPLETE, (function (k:Event)
            {
                _Str_3322._Str_3144();
                _Str_17768();
                _Str_4922 = new Shape();
                _Str_4922.graphics.beginFill(0);
                _Str_4922.graphics.drawRect(0, 0, width, height);
                _Str_4922.graphics.endFill();
                addChild(_Str_4922);
                _Str_2450.visible = true;
                _Str_2450.mask = _Str_4922;
                onFlashContentLoaded();
            } : ASAny));
            this._Str_2450.mouseChildren = (!blockMouseActions);
            this._Str_2450.mouseEnabled = (!blockMouseActions);
            this._Str_2450.visible = false;
            addChild(this._Str_2450);
            this._Str_2450.load(urlReq, new LoaderContext(true, new ApplicationDomain(), SecurityDomain.currentDomain));
            this._Str_8978();
        }

        function onFlashContentLoaded()
        {
        }

        public function _Str_13579()
        {
            if (this._Str_2450 != null)
            {
                try
                {
                    this.removeChild(this._Str_2450);
                    this._Str_2450.unload();
                }
                catch(ae:ArgumentError)
                {
                }
                this._Str_2450 = null;
            }
            else
            {
                if (this._Str_3400 != null)
                {
                    this.removeChild(this._Str_3400);
                    this._Str_3400 = null;
                }
            }
            this._Str_4922 = null;
        }

        function createTextField()
        {
            if (this._text != null)
            {
                removeChild(this._text);
            }
            this._text = GraphicsUtils._Str_20156(false, null, 12, false);
            this._text.blendMode = BlendMode.NORMAL;
            this._text.autoSize = TextFieldAutoSize.CENTER;
            this._text.wordWrap = true;
            this._text.multiline = true;
            this._text.antiAliasType = AntiAliasType.ADVANCED;
            this._text.condenseWhite = true;
            this._text.mouseEnabled = false;
            if (this._Str_5857 != null)
            {
                this._text.styleSheet = this._Str_5857.stylesheet;
            }
            if (this.html != null)
            {
                this._text.htmlText = this.html;
            }
            addChild(this._text);
            this._Str_9713 = this._Str_24058();
            addChild(this._Str_9713);
            this._text.mask = this._Str_9713;
            this._Str_21483();
        }

        function _Str_21483()
        {
            var k:Array<ASAny> = null;
            var _local_2:Array<ASAny> = null;
            var _local_3 = 0;
            if (this._text != null)
            {
                k = new Array<ASAny>();
                if (this.padding.indexOf(" ") > 0)
                {
                    _local_2 = (cast this.padding.split(" "));
                    this._text.y = NumberUtils._Str_5288(_local_2[0]);
                    this._text.x = NumberUtils._Str_5288(_local_2[3]);
                    this._text.height = Math.fround(((this._height - NumberUtils._Str_5288(_local_2[0])) - NumberUtils._Str_5288(_local_2[2])));
                    this._text.width = Math.fround(((this._width - NumberUtils._Str_5288(_local_2[1])) - NumberUtils._Str_5288(_local_2[3])));
                }
                else
                {
                    _local_3 = Std.int(NumberUtils._Str_5288(this.padding));
                    this._text.y = Math.fround(ASCompat.toNumber((_local_3 : ASAny)[0]));
                    this._text.x = Math.fround(ASCompat.toNumber((_local_3 : ASAny)[3]));
                    this._text.height = Math.fround(ASCompat.toNumber(ASCompat.toNumber(this._height - ASCompat.toNumber((_local_3 : ASAny)[0])) - ASCompat.toNumber((_local_3 : ASAny)[2])));
                    this._text.width = Math.fround(ASCompat.toNumber(ASCompat.toNumber(this._width - ASCompat.toNumber((_local_3 : ASAny)[1])) - ASCompat.toNumber((_local_3 : ASAny)[3])));
                }
            }
        }

        function onResize()
        {
            this._Str_8978();
            if (this._Str_9713 != null)
            {
                this._Str_9713.width = this._width;
                this._Str_9713.height = this._height;
            }
            if (this._Str_4922 != null)
            {
                this._Str_4922.width = this._width;
                this._Str_4922.height = this._height;
            }
            this.x = 0;
            this.y = 0;
        }

        function _Str_24846()
        {
            this._Str_21483();
            this._Str_8978();
        }

        function _Str_8978()
        {
            if (this._closeButton != null)
            {
                this._closeButton.calculateLayoutPosition(Std.int(this.width), this.borderRadius);
                if (numChildren > 0)
                {
                    setChildIndex(this._closeButton, (numChildren - 1));
                }
            }
        }

        public function _Str_14359()
        {
            this.hide();
            this._controller.onRegionCloseClicked(this);
        }

        public function show()
        {
            this._Str_19314();
            this.visible = true;
        }

        public function hide()
        {
            this.removeListeners();
            this.visible = false;
        }

        function onMouseOver(k:MouseEvent)
        {
        }

        function onMouseOut(k:MouseEvent)
        {
        }

        function onClick(k:MouseEvent)
        {
            if (this.autoHide)
            {
                this.hide();
            }
            this._controller.onRegionClicked(this, k);
        }

        function _Str_6950()
        {
            this._Str_23746();
            this._Str_25466();
            this._Str_24846();
        }

        function _Str_23746()
        {
            graphics.clear();
            if (this._Str_16995())
            {
                alpha = this.opacity;
            }
            if (this._Str_24625() == false)
            {
                graphics.beginFill(this._Str_23813());
            }
            else
            {
                graphics.beginFill(0, 0);
            }
            GraphicsUtils.drawRoundRectangle(graphics, 0, 0, this._width, this._height, this.borderRadius);
            graphics.endFill();
            if (this.backgroundGradient)
            {
                GraphicsUtils._Str_23331(this, 0, this.backgroundGradient, this.borderRadius);
            }
            else
            {
                GraphicsUtils._Str_17793(this);
            }
        }

        function _Str_24058():Sprite
        {
            var k= new Sprite();
            k.graphics.beginFill(0);
            GraphicsUtils.drawRoundRectangle(k.graphics, 0, 0, this.width, this.height, this.borderRadius);
            return k;
        }

        function _Str_25466()
        {
            if (((this._border != null) && ((this._border.parent : ASAny) == (this : ASAny))))
            {
                removeChild(this._border);
            }
            if (this.borderWidth <= 0)
            {
                return;
            }
            this._border = new Sprite();
            addChild(this._border);
            this._border.graphics.lineStyle(this.borderWidth, this._Str_23277());
            GraphicsUtils.drawRoundRectangle(this._border.graphics, 0, 0, this.width, this.height, this.borderRadius);
        }

        function _Str_16801(k:String, _arg_2:Int=1)
        {
        }

        function _Str_19580(k:ASObject, _arg_2:Int=1)
        {
        }
    }

