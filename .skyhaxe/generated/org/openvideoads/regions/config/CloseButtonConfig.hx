package org.openvideoads.regions.config
;
    import org.openvideoads.base.Debuggable;

     class CloseButtonConfig extends Debuggable 
    {
        var _type:String = "crosshair";
        var _color:String = "#FFFFFF";
        var _Str_2699:Bool = true;
        var _Str_8441:String = null;
        var _width:Int = 15;
        var _height:Int = 15;

        public function new(k:ASObject=null)
        {
            super();
            if (k != null)
            {
                this.initialise(k);
            }
        }

        function initialise(k:ASObject)
        {
            if (k.type != /*undefined*/null)
            {
                this._type = k.type;
            }
            if (k.color != /*undefined*/null)
            {
                this._color = k.color;
            }
            if (k.enabled != /*undefined*/null)
            {
                this._Str_2699 = k.enabled;
            }
            if (k.image != /*undefined*/null)
            {
                this._Str_8441 = k.image;
            }
            if (k.width != /*undefined*/null)
            {
                this._width = ASCompat.toInt(k.width);
            }
            if (k.height != /*undefined*/null)
            {
                this._height = ASCompat.toInt(k.height);
            }
        }

        
        public var type(get,set):String;
public function  set_type(k:String):String        {
            return this._type = k;
        }
public function  get_type():String
        {
            if (this._type != null)
            {
                return this._type.toUpperCase();
            }
            return this._type;
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

        
        public var color(get,set):String;
public function  set_color(k:String):String        {
            return this._color = k;
        }
public function  get_color():String
        {
            return this._color;
        }

        
        public var enabled(get,set):Bool;
public function  set_enabled(k:Bool):Bool        {
            return this._Str_2699 = k;
        }
public function  get_enabled():Bool
        {
            return this._Str_2699;
        }

        
        public var imageURL(get,set):String;
public function  set_imageURL(k:String):String        {
            return this._Str_8441 = k;
        }
public function  get_imageURL():String
        {
            return this._Str_8441;
        }
    }

