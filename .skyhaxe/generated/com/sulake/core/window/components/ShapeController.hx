package com.sulake.core.window.components
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.WindowContext;
    import com.sulake.core.window.WindowController;
    import com.sulake.core.window.utils.PropertyStruct;
    import com.sulake.core.window.utils.IIterator;
    import com.sulake.core.window.iterators.ContainerIterator;
    import flash.geom.Rectangle;

     class ShapeController extends WindowController implements IWindowContainer
    {
        public static inline final SHAPE_RECTANGLE= "rectangle";
        public static inline final SHAPE_ROUND_RECTANGLE= "round_rectangle";
        public static inline final SHAPE_ELLIPSE= "ellipse";
        public static inline final SHAPE_RHOMBUS= "rhombus";
        public static final SHAPES:Array<ASAny> = ["rectangle", "round_rectangle", "ellipse", "rhombus"];

        var _constructed:Bool = false;
        var _shape:String = SHAPE_RECTANGLE;
        var _radius:Float = 0;
        var _strokeColor:UInt = 0xFF000000;
        var _strokeHsvShade:Float = 0;
        var _strokeThickness:Float = 0;

        public function new(k:String, _arg_2:UInt, _arg_3:UInt, _arg_4:UInt, _arg_5:WindowContext, _arg_6:Rectangle, _arg_7:IWindow, _arg_8:ASFunction=null, _arg_9:Array<ASAny>=null, _arg_10:Array<ASAny>=null, _arg_11:UInt=0)
        {
            super(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10, _arg_11);
            _drawable = true;
            this._constructed = true;
        }

        public var iterator(get,never):IIterator;
public function  get_iterator():IIterator
        {
            return new ContainerIterator(this);
        }

        function safeInvalidate()
        {
            if (!this._constructed)
            {
                return;
            }
            invalidate();
        }

        public static function normalizeShape(value:String):String
        {
            return ((SHAPES.indexOf(value) >= 0) ? value : SHAPE_RECTANGLE);
        }

        
        public var shape(get,set):String;
public function  get_shape():String
        {
            return this._shape;
        }
public function  set_shape(value:String):String        {
            var normalized= normalizeShape(value);
            if (this._shape != normalized)
            {
                this._shape = normalized;
                this.safeInvalidate();
            }
return value;
        }

        
        public var radius(get,set):Float;
public function  get_radius():Float
        {
            return this._radius;
        }
public function  set_radius(value:Float):Float        {
            var normalized= (Math.isNaN(value) ? 0 : Math.max(0, value));
            if (this._radius != normalized)
            {
                this._radius = normalized;
                this.safeInvalidate();
            }
return value;
        }

        
        public var strokeColor(get,set):UInt;
public function  get_strokeColor():UInt
        {
            return this._strokeColor;
        }
public function  set_strokeColor(value:UInt):UInt        {
            if (this._strokeColor != value)
            {
                this._strokeColor = value;
                this.safeInvalidate();
            }
return value;
        }

        
        public var strokeHsvShade(get,set):Float;
public function  get_strokeHsvShade():Float
        {
            return this._strokeHsvShade;
        }
public function  set_strokeHsvShade(value:Float):Float        {
            var normalized= (Math.isNaN(value) ? 0 : value);
            if (this._strokeHsvShade != normalized)
            {
                this._strokeHsvShade = normalized;
                this.safeInvalidate();
            }
return value;
        }

        
        public var strokeThickness(get,set):Float;
public function  get_strokeThickness():Float
        {
            return this._strokeThickness;
        }
public function  set_strokeThickness(value:Float):Float        {
            var normalized= (Math.isNaN(value) ? 0 : Math.max(0, value));
            if (this._strokeThickness != normalized)
            {
                this._strokeThickness = normalized;
                this.safeInvalidate();
            }
return value;
        }

        override public function  get_properties():Array<ASAny>
        {
            var props= super.properties;
            props.push(new PropertyStruct("shape", this._shape, PropertyStruct.STRING));
            props.push(new PropertyStruct("radius", this._radius, PropertyStruct.NUMBER));
            props.push(new PropertyStruct("stroke_color", this._strokeColor, PropertyStruct.UINT));
            props.push(new PropertyStruct("stroke_hsv_shade", this._strokeHsvShade, PropertyStruct.NUMBER));
            props.push(new PropertyStruct("stroke_thickness", this._strokeThickness, PropertyStruct.NUMBER));
            return props;
        }

        override public function  set_properties(k:Array<ASAny>):Array<ASAny>        {
var prop:PropertyStruct  = null;            var stringValue:String = null;
            var numberValue = Math.NaN;
            var uintValue:UInt = 0;
            var changed = false;
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
prop = _tmp_;
                switch (prop.key)
                {
                    case "shape":
                        stringValue = normalizeShape(ASCompat.toString(prop.value));
                        if (this._shape != stringValue)
                        {
                            this._shape = stringValue;
                            changed = true;
                        }
                        
                    case "radius":
                        numberValue = ASCompat.toNumber(prop.value);
                        numberValue = (Math.isNaN(numberValue) ? 0 : Math.max(0, numberValue));
                        if (this._radius != numberValue)
                        {
                            this._radius = numberValue;
                            changed = true;
                        }
                        
                    case "stroke_color":
                        uintValue = ASCompat.toUInt(prop.value);
                        if (this._strokeColor != uintValue)
                        {
                            this._strokeColor = uintValue;
                            changed = true;
                        }
                        
                    case "stroke_hsv_shade":
                        numberValue = ASCompat.toNumber(prop.value);
                        numberValue = (Math.isNaN(numberValue) ? 0 : numberValue);
                        if (this._strokeHsvShade != numberValue)
                        {
                            this._strokeHsvShade = numberValue;
                            changed = true;
                        }
                        
                    case "stroke_thickness":
                        numberValue = ASCompat.toNumber(prop.value);
                        numberValue = (Math.isNaN(numberValue) ? 0 : Math.max(0, numberValue));
                        if (this._strokeThickness != numberValue)
                        {
                            this._strokeThickness = numberValue;
                            changed = true;
                        }
                        
                }
            }
            if (changed)
            {
                this.safeInvalidate();
            }
            return super.properties = k;
        }
    }

