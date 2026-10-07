package org.openvideoads.regions.config
;
    import org.openvideoads.base.Debuggable;
    import org.openvideoads.util.StringUtils;
    import flash.display.Bitmap;
    import flash.display.Loader;

     class BaseRegionConfig extends Debuggable 
    {
        var _Str_19957:String;
        var _style:String = null;
        var _id:String = null;
        var _border:String = null;
        var _Str_10333:Int = -1;
        var _Str_17448:Int = -1;
        var _Str_16588:String = null;
        var _background:String = null;
        var _Str_20337:String = null;
        var _Str_18917:ASAny = null;
        var _backgroundImage:String = null;
        var _Str_17542:String = null;
        var _backgroundColor:String = null;
        var _Str_20596:String = null;
        var _closeButton:CloseButtonConfig;
        var _Str_11028:Float = -1;
        var _Str_20720:String = "5 5 5 5";
        var _Str_12703:Float = 1;
        var _Str_4544:String = null;
        var _image:ASAny = null;
        var _Str_6712:ASAny = null;

        public function new(k:ASObject=null)
        {
            this._closeButton = new CloseButtonConfig();
            super();
            this.setup(k);
        }

        public function setup(k:ASObject)
        {
            if (k != null)
            {
                if (k.id != /*undefined*/null)
                {
                    this.id = k.id;
                }
                if (k.stylesheet != /*undefined*/null)
                {
                    this.stylesheet = k.stylesheet;
                }
                if (k.style != /*undefined*/null)
                {
                    this.style = k.style;
                }
                if (k.border != /*undefined*/null)
                {
                    this.border = k.border;
                }
                if (k.borderRadius != /*undefined*/null)
                {
                    this.borderRadius = ASCompat.toInt(k.borderRadius);
                }
                if (k.borderColor != /*undefined*/null)
                {
                    this.borderColor = k.borderColor;
                }
                if (k.borderWidth != /*undefined*/null)
                {
                    this.borderWidth = ASCompat.toInt(k.borderWidth);
                }
                if (k.backgroundGradient != /*undefined*/null)
                {
                    this.backgroundGradient = k.backgroundGradient;
                }
                if (k.background != /*undefined*/null)
                {
                    this.background = k.background;
                }
                if (k.backgroundImage != /*undefined*/null)
                {
                    this.backgroundImage = StringUtils._Str_20351(k.backgroundImage, "%27");
                }
                if (k.backgroundRepeat != /*undefined*/null)
                {
                    this.backgroundRepeat = k.backgroundRepeat;
                }
                if (k.backgroundColor != /*undefined*/null)
                {
                    this.backgroundColor = k.backgroundColor;
                }
                if (k.closeButton != /*undefined*/null)
                {
                    if (Std.is(k.closeButton , CloseButtonConfig))
                    {
                        this._closeButton = k.closeButton;
                    }
                    else
                    {
                        this._closeButton = new CloseButtonConfig(k.closeButton);
                    }
                }
                if (k.padding != /*undefined*/null)
                {
                    this.padding = k.padding;
                }
                if (k.opacity != /*undefined*/null)
                {
                    this.opacity = ASCompat.toNumber(k.opacity);
                }
                if (k.html != /*undefined*/null)
                {
                    this.html = StringUtils._Str_20351(k.html, "'");
                }
                if (k.image != /*undefined*/null)
                {
                    this.image = k.image;
                }
                if (k.swf != /*undefined*/null)
                {
                    this.swf = k.swf;
                }
            }
        }

        
        public var id(get,set):String;
public function  set_id(k:String):String        {
            return this._id = k;
        }
public function  get_id():String
        {
            return this._id;
        }

        
        public var style(get,set):String;
public function  set_style(k:String):String        {
            return this._style = k;
        }
public function  get_style():String
        {
            return this._style;
        }

        
        public var stylesheet(get,set):String;
public function  set_stylesheet(k:String):String        {
            return this._Str_19957 = k;
        }
public function  get_stylesheet():String
        {
            return this._Str_19957;
        }

        
        public var html(get,set):String;
public function  set_html(k:String):String        {
            return this._Str_4544 = k;
        }
public function  get_html():String
        {
            return this._Str_4544;
        }

        
        public var borderRadius(get,set):Int;
public function  set_borderRadius(k:Int):Int        {
            return this._Str_10333 = k;
        }
public function  get_borderRadius():Int
        {
            return this._Str_10333;
        }

        public function _Str_18926():Bool
        {
            return this._Str_10333 > -1;
        }

        
        public var borderWidth(get,set):Int;
public function  set_borderWidth(k:Int):Int        {
            return this._Str_17448 = k;
        }
public function  get_borderWidth():Int
        {
            return this._Str_17448;
        }

        public function _Str_15962():Bool
        {
            return this._Str_17448 > -1;
        }

        
        public var border(get,set):String;
public function  set_border(k:String):String        {
            return this._border = k;
        }
public function  get_border():String
        {
            return this._border;
        }

        public function _Str_14610():Bool
        {
            return !(this._border == null);
        }

        
        public var borderColor(get,set):String;
public function  set_borderColor(k:String):String        {
            return this._Str_16588 = k;
        }
public function  get_borderColor():String
        {
            return this._Str_16588;
        }

        public function _Str_16762():Bool
        {
            return !(this._Str_16588 == null);
        }

        
        public var background(get,set):String;
public function  set_background(k:String):String        {
            this._background = k;
            return this._Str_20337 = k;
        }
public function  get_background():String
        {
            return this._background;
        }

        public function _Str_18749():Bool
        {
            return !(this._background == null);
        }

        public var _Str_23263(never,set):Bool;
public function  set__Str_23263(k:Bool):Bool        {
            if (k)
            {
                this._Str_11493();
            }
            else
            {
                this._Str_12711();
            }
return k;
        }

        public function _Str_11493()
        {
            this._background = "transparent";
            this._backgroundColor = "transparent";
        }

        public function _Str_12711()
        {
            this._background = this._Str_20337;
            this._backgroundColor = this._Str_20596;
        }

        
        public var backgroundRepeat(get,set):String;
public function  set_backgroundRepeat(k:String):String        {
            return this._Str_17542 = k;
        }
public function  get_backgroundRepeat():String
        {
            return this._Str_17542;
        }

        public function _Str_25893():Bool
        {
            return !(this._Str_17542 == null);
        }

        
        public var backgroundGradient(get,set):ASAny;
public function  set_backgroundGradient(k:ASAny):ASAny        {
            return this._Str_18917 = k;
        }
public function  get_backgroundGradient():ASAny
        {
            return this._Str_18917;
        }

        public function _Str_16430():Bool
        {
            return !(this._Str_18917 == null);
        }

        
        public var backgroundImage(get,set):String;
public function  set_backgroundImage(k:String):String        {
            return this._backgroundImage = k;
        }
public function  get_backgroundImage():String
        {
            return this._backgroundImage;
        }

        public function _Str_26209():Bool
        {
            return !(this._backgroundImage == null);
        }

        
        public var backgroundColor(get,set):String;
public function  set_backgroundColor(k:String):String        {
            this._backgroundColor = k;
            return this._Str_20596 = k;
        }
public function  get_backgroundColor():String
        {
            return this._backgroundColor;
        }

        public function _Str_15500():Bool
        {
            return !(this._backgroundColor == null);
        }

        
        public var opacity(get,set):Float;
public function  set_opacity(k:Float):Float        {
            return this._Str_11028 = k;
        }
public function  get_opacity():Float
        {
            return this._Str_11028;
        }

        public function _Str_16995():Bool
        {
            return this._Str_11028 > -1;
        }

        
        public var padding(get,set):String;
public function  set_padding(k:String):String        {
            return this._Str_20720 = k;
        }
public function  get_padding():String
        {
            return this._Str_20720;
        }

        
        public var scaleRate(get,set):Float;
public function  set_scaleRate(k:Float):Float        {
            return this._Str_12703 = k;
        }
public function  get_scaleRate():Float
        {
            return this._Str_12703;
        }

        
        public var image(get,set):ASAny;
public function  set_image(k:ASAny):ASAny        {
            return this._image = k;
        }
public function  get_image():ASAny
        {
            return this._image;
        }

        public function _Str_24560():Bool
        {
            return !(this._image == null);
        }

        public function _Str_24467():Bool
        {
            return Std.is(this._image , Bitmap);
        }

        public function _Str_23156():Bool
        {
            return Std.is(this._image , Loader);
        }

        
        public var swf(get,set):ASAny;
public function  set_swf(k:ASAny):ASAny        {
            return this._Str_6712 = k;
        }
public function  get_swf():ASAny
        {
            return this._Str_6712;
        }

        public function _Str_23612():Bool
        {
            return !(this._Str_6712 == null);
        }

        public var properties(get,never):ASObject;
public function  get_properties():ASObject
        {
            var k:ASObject = new ASObject();
            k.id = this.id;
            k.border = this.border;
            k.borderRadius = this.borderRadius;
            k.backgroundGradient = this.backgroundGradient;
            k.backgroundImage = this.backgroundImage;
            k.backgroundColor = this.backgroundColor;
            k.closeButton = this.closeButton;
            k.opacity = this.opacity;
            k.stylesheet = this.stylesheet;
            k.style = this.style;
            k.scaleRate = this.scaleRate;
            k.image = this.image;
            k.swf = this.swf;
            return k;
        }

        
        public var closeButton(get,set):CloseButtonConfig;
public function  set_closeButton(k:CloseButtonConfig):CloseButtonConfig        {
            return this._closeButton = k;
        }
public function  get_closeButton():CloseButtonConfig
        {
            return this._closeButton;
        }

        public function _Str_16602():Bool
        {
            return (this._closeButton != null) ? this._closeButton.enabled : true;
        }
    }

