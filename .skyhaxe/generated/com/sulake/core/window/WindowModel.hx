package com.sulake.core.window
;
    import com.sulake.core.runtime.IDisposable;
    import flash.geom.Rectangle;
    import flash.geom.ColorTransform;
    import com.sulake.core.window._enum.WindowState;
    import flash.geom.Point;

     class WindowModel implements IDisposable 
    {
        var _offsetX:Int = 0;
        var _offsetY:Int = 0;
        var _x:Int = 0;
        var _y:Int = 0;
        var _w:Int = 0;
        var _h:Int = 0;
        var _initialRect:Rectangle;
        var _previousRect:Rectangle;
        var _minimizedRect:Rectangle;
        var _maximizedRect:Rectangle;
        var _context:WindowContext;
        var _background:Bool = false;
        var _fillColor:UInt = 0xFFFFFF;
        var _dynamicStyleColorTransform:ColorTransform;
        var _alphaColor:UInt = 0;
        var _mouseThreshold:UInt = 10;
        var _clipping:Bool = true;
        var _visible:Bool = true;
        var _blend:Float = 1;
        var _param:UInt = 0;
        var _state:UInt = 0;
        var _style:UInt = 0;
        var _type:UInt = 0;
        var _caption:String = "";
        var _name:String;
        var _id:UInt = 0;
        var _tags:Array<ASAny>;
        var _disposed:Bool = false;
        var _dynamicStyle:String = "";

        public function new(k:UInt, _arg_2:String, _arg_3:UInt, _arg_4:UInt, _arg_5:UInt, _arg_6:WindowContext, _arg_7:Rectangle, _arg_8:Array<ASAny>=null, _arg_9:String="")
        {
            this._id = k;
            this._name = _arg_2;
            this._type = _arg_3;
            this._param = _arg_5;
            this._state = WindowState.DEFAULT;
            this._style = _arg_4;
            this._tags = _arg_8;
            this._context = _arg_6;
            this._dynamicStyle = _arg_9;
            this._x = Std.int(_arg_7.x);
            this._y = Std.int(_arg_7.y);
            this._w = Std.int(_arg_7.width);
            this._h = Std.int(_arg_7.height);
            this._initialRect = _arg_7.clone();
            this._previousRect = _arg_7.clone();
        }

        
public var x(get,set):Int;
public function  get_x():Int
        {
            return this._x;
        }

        
public var y(get,set):Int;
public function  get_y():Int
        {
            return this._y;
        }

        
public var width(get,set):Int;
public function  get_width():Int
        {
            return this._w;
        }

        
public var height(get,set):Int;
public function  get_height():Int
        {
            return this._h;
        }

        
public var position(get,set):Point;
public function  get_position():Point
        {
            return new Point(this._x, this._y);
        }

        
public var rectangle(get,set):Rectangle;
public function  get_rectangle():Rectangle
        {
            return new Rectangle(this._x, this._y, this._w, this._h);
        }

        public var context(get,never):IWindowContext;
public function  get_context():IWindowContext
        {
            return this._context;
        }

        
public var mouseThreshold(get,set):UInt;
public function  get_mouseThreshold():UInt
        {
            return this._mouseThreshold;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        
public var background(get,set):Bool;
public function  get_background():Bool
        {
            return this._background;
        }

        
public var clipping(get,set):Bool;
public function  get_clipping():Bool
        {
            return this._clipping;
        }

        
public var visible(get,set):Bool;
public function  get_visible():Bool
        {
            return this._visible;
        }

        
public var color(get,set):UInt;
public function  get_color():UInt
        {
            return this._fillColor;
        }

        
public var alpha(get,set):UInt;
public function  get_alpha():UInt
        {
            return ASCompat.toInt(this._alphaColor )>>> 24;
        }

        
public var blend(get,set):Float;
public function  get_blend():Float
        {
            return this._blend;
        }

        public var param(get,never):UInt;
public function  get_param():UInt
        {
            return this._param;
        }

        
public var state(get,set):UInt;
public function  get_state():UInt
        {
            return this._state;
        }

        
public var style(get,set):UInt;
public function  get_style():UInt
        {
            return this._style;
        }

        
public var type(get,set):UInt;
public function  get_type():UInt
        {
            return this._type;
        }

        
public var caption(get,set):String;
public function  get_caption():String
        {
            return this._caption;
        }

        
public var name(get,set):String;
public function  get_name():String
        {
            return this._name;
        }

        
public var id(get,set):Int;
public function  get_id():Int
        {
            return ASCompat.toInt(this._id);
        }

        
public var tags(get,set):Array<ASAny>;
public function  get_tags():Array<ASAny>
        {
            return (this._tags != null) ? this._tags : (this._tags = []);
        }

        public var left(get,never):Int;
public function  get_left():Int
        {
            return this._x;
        }

        public var top(get,never):Int;
public function  get_top():Int
        {
            return this._y;
        }

        public var right(get,never):Int;
public function  get_right():Int
        {
            return this._x + this._w;
        }

        public var bottom(get,never):Int;
public function  get_bottom():Int
        {
            return this._y + this._h;
        }

        public var renderingX(get,never):Int;
public function  get_renderingX():Int
        {
            return this._offsetX + this._x;
        }

        public var renderingY(get,never):Int;
public function  get_renderingY():Int
        {
            return this._offsetY + this._y;
        }

        public var renderingWidth(get,never):Int;
public function  get_renderingWidth():Int
        {
            return Std.int(this._w + Math.abs(this.etchingPoint.x));
        }

        public var renderingHeight(get,never):Int;
public function  get_renderingHeight():Int
        {
            return Std.int(this._h + Math.abs(this.etchingPoint.y));
        }

        public var renderingRectangle(get,never):Rectangle;
public function  get_renderingRectangle():Rectangle
        {
            return new Rectangle(this.renderingX, this.renderingY, this.renderingWidth, this.renderingHeight);
        }

        public var etchingPoint(get,never):Point;
public function  get_etchingPoint():Point
        {
            return new Point(0, 0);
        }

        
public var dynamicStyle(get,set):String;
public function  get_dynamicStyle():String
        {
            return this._dynamicStyle;
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                this._disposed = true;
                this._context = null;
                this._state = WindowState.DISPOSED;
                this._tags = null;
                this._x = (this._y = (this._w = (this._h = 0)));
            }
        }

        public function invalidate(k:Rectangle=null)
        {
        }

        public function getInitialWidth():Int
        {
            return Std.int(this._initialRect.width);
        }

        public function getInitialHeight():Int
        {
            return Std.int(this._initialRect.height);
        }

        public function getPreviousWidth():Int
        {
            return Std.int(this._previousRect.width);
        }

        public function getPreviousHeight():Int
        {
            return Std.int(this._previousRect.height);
        }

        public function getMinimizedWidth():Int
        {
            return Std.int((this._minimizedRect != null) ? Std.int(this._minimizedRect.width ): 0);
        }

        public function getMinimizedHeight():Int
        {
            return Std.int((this._minimizedRect != null) ? Std.int(this._minimizedRect.height ): 0);
        }

        public function getMaximizedWidth():Int
        {
            return Std.int((this._maximizedRect != null) ? Std.int(this._maximizedRect.width ): ASCompat.MAX_INT);
        }

        public function getMaximizedHeight():Int
        {
            return Std.int((this._maximizedRect != null) ? Std.int(this._maximizedRect.height ): ASCompat.MAX_INT);
        }

        public function testTypeFlag(k:UInt, _arg_2:UInt=0):Bool
        {
            if (_arg_2 > 0)
            {
                return ((ASCompat.toInt(this._type )& ASCompat.toInt(_arg_2)) ^ ASCompat.toInt(k)) == 0;
            }
            return ((ASCompat.toInt(this._type )& ASCompat.toInt(k)) : UInt) == k;
        }

        public function testStateFlag(k:UInt, _arg_2:UInt=0):Bool
        {
            if (_arg_2 > 0)
            {
                return ((ASCompat.toInt(this._state )& ASCompat.toInt(_arg_2)) ^ ASCompat.toInt(k)) == 0;
            }
            return ((ASCompat.toInt(this._state )& ASCompat.toInt(k)) : UInt) == k;
        }

        public function testStyleFlag(k:UInt, _arg_2:UInt=0):Bool
        {
            if (_arg_2 > 0)
            {
                return ((ASCompat.toInt(this._style )& ASCompat.toInt(_arg_2)) ^ ASCompat.toInt(k)) == 0;
            }
            return ((ASCompat.toInt(this._style )& ASCompat.toInt(k)) : UInt) == k;
        }

        public function testParamFlag(k:UInt, _arg_2:UInt=0):Bool
        {
            if (_arg_2 > 0)
            {
                return ((ASCompat.toInt(this._param )& ASCompat.toInt(_arg_2)) ^ ASCompat.toInt(k)) == 0;
            }
            return ((ASCompat.toInt(this._param )& ASCompat.toInt(k)) : UInt) == k;
        }
public 
function  set_x(k:Int):Int{throw "Accessor unavailable on base instance: x"; return k;
}public 
function  set_y(k:Int):Int{throw "Accessor unavailable on base instance: y"; return k;
}public 
function  set_id(k:Int):Int{throw "Accessor unavailable on base instance: id"; return k;
}public 
function  set_name(k:String):String{throw "Accessor unavailable on base instance: name"; return k;
}public 
function  set_width(k:Int):Int{throw "Accessor unavailable on base instance: width"; return k;
}public 
function  set_height(k:Int):Int{throw "Accessor unavailable on base instance: height"; return k;
}public 
function  set_position(k:Point):Point{throw "Accessor unavailable on base instance: position"; return k;
}public 
function  set_rectangle(k:Rectangle):Rectangle{throw "Accessor unavailable on base instance: rectangle"; return k;
}public 
function  set_background(k:Bool):Bool{throw "Accessor unavailable on base instance: background"; return k;
}public 
function  set_color(k:UInt):UInt{throw "Accessor unavailable on base instance: color"; return k;
}public 
function  set_alpha(k:UInt):UInt{throw "Accessor unavailable on base instance: alpha"; return k;
}public 
function  set_blend(k:Float):Float{throw "Accessor unavailable on base instance: blend"; return k;
}public 
function  set_visible(k:Bool):Bool{throw "Accessor unavailable on base instance: visible"; return k;
}public 
function  set_type(k:UInt):UInt{throw "Accessor unavailable on base instance: type"; return k;
}public 
function  set_caption(k:String):String{throw "Accessor unavailable on base instance: caption"; return k;
}public 
function  set_tags(k:Array<ASAny>):Array<ASAny>{throw "Accessor unavailable on base instance: tags"; return k;
}public 
function  set_mouseThreshold(k:UInt):UInt{throw "Accessor unavailable on base instance: mouseThreshold"; return k;
}public 
function  set_state(k:UInt):UInt{throw "Accessor unavailable on base instance: state"; return k;
}public 
function  set_style(k:UInt):UInt{throw "Accessor unavailable on base instance: style"; return k;
}public 
function  set_dynamicStyle(k:String):String{throw "Accessor unavailable on base instance: dynamicStyle"; return k;
}public 
function  set_clipping(k:Bool):Bool{throw "Accessor unavailable on base instance: clipping"; return k;
}    }

