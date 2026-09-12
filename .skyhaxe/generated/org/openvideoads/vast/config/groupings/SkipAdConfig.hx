package org.openvideoads.vast.config.groupings
;
    import org.openvideoads.base.Debuggable;

     class SkipAdConfig extends Debuggable 
    {
        var _Str_2699:Bool = false;
        var _Str_2442:ASObject = null;
        var _image:String = null;
        var _Str_6712:String = null;
        var _Str_4544:String = null;
        var _width:Int = -1;
        var _height:Int = -1;
        var _Str_17493:Int = -1;
        var _Str_15975:Int = -1;
        var _Str_17863:Int = -1;
        var _Str_22181:Bool = false;

        public function new(k:ASObject=null)
        {
            super();
            if (k != null)
            {
                this.initialise(k);
            }
        }

        public function initialise(k:ASObject)
        {
            if (k.enabled != /*undefined*/null)
            {
                if (Std.is(k.enabled , String))
                {
                    this.enabled = ((k.enabled.toUpperCase() == "TRUE") ? true : false);
                }
                else
                {
                    this.enabled = k.enabled;
                }
            }
            if (k.region != /*undefined*/null)
            {
                this._Str_2442 = k.region;
            }
            if (k.image != /*undefined*/null)
            {
                this._image = k.image;
            }
            if (k.swf != /*undefined*/null)
            {
                this._Str_6712 = k.swf;
            }
            if (k.html != /*undefined*/null)
            {
                this._Str_4544 = k.html;
            }
            if (k.skipAdOnClickThrough != /*undefined*/null)
            {
                if (Std.is(k.skipAdOnClickThrough , String))
                {
                    this.skipAdOnClickThrough = ((k.skipAdOnClickThrough.toUpperCase() == "TRUE") ? true : false);
                }
                else
                {
                    this.skipAdOnClickThrough = k.skipAdOnClickThrough;
                }
            }
            if (k.width != /*undefined*/null)
            {
                if (Std.is(k.width , String))
                {
                    this.width = ASCompat.toInt(k.width);
                }
                else
                {
                    this.width = ASCompat.toInt(k.width);
                }
            }
            if (k.height != /*undefined*/null)
            {
                if (Std.is(k.height , String))
                {
                    this.height = ASCompat.toInt(k.height);
                }
                else
                {
                    this.height = ASCompat.toInt(k.height);
                }
            }
            if (k.minimumAdDuration != /*undefined*/null)
            {
                if (Std.is(k.minimumAdDuration , String))
                {
                    this.minimumAdDuration = ASCompat.toInt(k.minimumAdDuration);
                }
                else
                {
                    this.minimumAdDuration = ASCompat.toInt(k.minimumAdDuration);
                }
            }
            if (k.showAfterSeconds != /*undefined*/null)
            {
                if (Std.is(k.showAfterSeconds , String))
                {
                    this.showAfterSeconds = ASCompat.toInt(k.showAfterSeconds);
                }
                else
                {
                    this.showAfterSeconds = ASCompat.toInt(k.showAfterSeconds);
                }
            }
            if (k.showForSeconds != /*undefined*/null)
            {
                if (Std.is(k.showForSeconds , String))
                {
                    this.showForSeconds = ASCompat.toInt(k.showForSeconds);
                }
                else
                {
                    this.showForSeconds = ASCompat.toInt(k.showForSeconds);
                }
            }
        }

        
        public var skipAdOnClickThrough(get,set):Bool;
public function  set_skipAdOnClickThrough(k:Bool):Bool        {
            return this._Str_22181 = k;
        }
public function  get_skipAdOnClickThrough():Bool
        {
            return this._Str_22181;
        }

        public function isTimeDelayed():Bool
        {
            return this._Str_15975 > 0;
        }

        
        public var showAfterSeconds(get,set):Int;
public function  set_showAfterSeconds(k:Int):Int        {
            return this._Str_15975 = k;
        }
public function  get_showAfterSeconds():Int
        {
            return this._Str_15975;
        }

        public function isTimeRestricted():Bool
        {
            return this._Str_17863 > 0;
        }

        
        public var showForSeconds(get,set):Int;
public function  set_showForSeconds(k:Int):Int        {
            return this._Str_17863 = k;
        }
public function  get_showForSeconds():Int
        {
            return this._Str_17863;
        }

        public function isStandardImageButton():Bool
        {
            return (this.isCustomImageButton() == false) && (this._Str_19315() == false);
        }

        public function isCustomImageButton():Bool
        {
            return !(this._image == null);
        }

        public function _Str_19315():Bool
        {
            return !(this._Str_6712 == null);
        }

        public function isHtmlButton():Bool
        {
            return !(this._Str_4544 == null);
        }

        
        public var enabled(get,set):Bool;
public function  set_enabled(k:Bool):Bool        {
            return this._Str_2699 = k;
        }
public function  get_enabled():Bool
        {
            return this._Str_2699;
        }

        
        public var region(get,set):ASObject;
public function  set_region(k:ASObject):ASObject        {
            return this._Str_2442 = k;
        }
public function  get_region():ASObject
        {
            return this._Str_2442;
        }

        public function _Str_26412():Bool
        {
            return !(this._Str_2442 == null);
        }

        
        public var image(get,set):String;
public function  set_image(k:String):String        {
            return this._image = k;
        }
public function  get_image():String
        {
            return this._image;
        }

        
        public var swf(get,set):String;
public function  set_swf(k:String):String        {
            return this._Str_6712 = k;
        }
public function  get_swf():String
        {
            return this._Str_6712;
        }

        
        public var html(get,set):String;
public function  set_html(k:String):String        {
            return this._Str_4544 = k;
        }
public function  get_html():String
        {
            return this._Str_4544;
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

        
        public var minimumAdDuration(get,set):Int;
public function  set_minimumAdDuration(k:Int):Int        {
            return this._Str_17493 = k;
        }
public function  get_minimumAdDuration():Int
        {
            return this._Str_17493;
        }

        public function hasMinimumAdDuration():Bool
        {
            return this._Str_17493 > 0;
        }
    }

