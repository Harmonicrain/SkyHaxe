package com.sulake.core.window.components
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.WindowContext;
    import com.sulake.core.window.WindowController;
    import com.sulake.core.window.utils.PropertyStruct;
    import flash.geom.Rectangle;

     class GradientController extends WindowController
    {
        public static inline final MODE_LINEAR= "linear";
        public static inline final MODE_RADIAL= "radial";
        public static inline final DIRECTION_UP= "up";
        public static inline final DIRECTION_DOWN= "down";
        public static inline final DIRECTION_LEFT= "left";
        public static inline final DIRECTION_RIGHT= "right";
        public static inline final DIRECTION_UP_LEFT= "up_left";
        public static inline final DIRECTION_UP_RIGHT= "up_right";
        public static inline final DIRECTION_DOWN_LEFT= "down_left";
        public static inline final DIRECTION_DOWN_RIGHT= "down_right";

        static inline final DEFAULT_COLOR1:UInt = 0xFFFFFFFF;
        static inline final DEFAULT_COLOR2:UInt = 0xFF000000;
        static final DEFAULT_MODE:String = MODE_LINEAR;
        static final DEFAULT_DIRECTION:String = DIRECTION_DOWN;

        public static final MODES:Array<ASAny> = [MODE_LINEAR, MODE_RADIAL];
        public static final DIRECTIONS:Array<ASAny> = [DIRECTION_UP, DIRECTION_DOWN, DIRECTION_LEFT, DIRECTION_RIGHT, DIRECTION_UP_LEFT, DIRECTION_UP_RIGHT, DIRECTION_DOWN_LEFT, DIRECTION_DOWN_RIGHT];

        var _color1:UInt = DEFAULT_COLOR1;
        var _color2:UInt = DEFAULT_COLOR2;
        var _mode:String = DEFAULT_MODE;
        var _direction:String = DEFAULT_DIRECTION;

        public function new(k:String, type:UInt, style:UInt, param:UInt, context:WindowContext, rectangle:Rectangle, parent:IWindow, procedure:ASFunction = null, properties:Array<ASAny> = null, tags:Array<ASAny> = null, id:UInt = 0)
        {
            super(k, type, style, param, context, rectangle, parent, procedure, properties, tags, id);
        }

        public static function normalizeMode(value:String):String
        {
            return value == MODE_RADIAL ? MODE_RADIAL : MODE_LINEAR;
        }

        public static function normalizeDirection(value:String):String
        {
            return DIRECTIONS.indexOf(value) >= 0 ? value : DEFAULT_DIRECTION;
        }

        
        public var color1(get,set):UInt;
public function  get_color1():UInt
        {
            return this._color1;
        }
public function  set_color1(value:UInt):UInt        {
            if (this._color1 != value)
            {
                this._color1 = value;
                invalidate();
            }
return value;
        }

        
        public var color2(get,set):UInt;
public function  get_color2():UInt
        {
            return this._color2;
        }
public function  set_color2(value:UInt):UInt        {
            if (this._color2 != value)
            {
                this._color2 = value;
                invalidate();
            }
return value;
        }

        
        public var mode(get,set):String;
public function  get_mode():String
        {
            return this._mode;
        }
public function  set_mode(value:String):String        {
            var normalized= normalizeMode(value);
            if (this._mode != normalized)
            {
                this._mode = normalized;
                invalidate();
            }
return value;
        }

        
        public var direction(get,set):String;
public function  get_direction():String
        {
            return this._direction;
        }
public function  set_direction(value:String):String        {
            var normalized= normalizeDirection(value);
            if (this._direction != normalized)
            {
                this._direction = normalized;
                invalidate();
            }
return value;
        }

        override public function  get_properties():Array<ASAny>
        {
            var props= super.properties;
            props.push(createProperty("color1", this._color1));
            props.push(createProperty("color2", this._color2));
            props.push(createProperty("mode", this._mode));
            props.push(new PropertyStruct("direction", this._direction, PropertyStruct.STRING, this._direction != DEFAULT_DIRECTION, DIRECTIONS));
            return props;
        }

        override public function  set_properties(k:Array<ASAny>):Array<ASAny>        {
var prop:PropertyStruct  = null;            var changed= false;
            var stringValue:String = null;
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
prop = _tmp_;
                switch (prop.key)
                {
                    case "color1":
                        if (this._color1 != ASCompat.toUInt(prop.value))
                        {
                            this._color1 = ASCompat.toUInt(prop.value);
                            changed = true;
                        }
                        
                    case "color2":
                        if (this._color2 != ASCompat.toUInt(prop.value))
                        {
                            this._color2 = ASCompat.toUInt(prop.value);
                            changed = true;
                        }
                        
                    case "mode":
                        stringValue = normalizeMode(ASCompat.toString(prop.value));
                        if (this._mode != stringValue)
                        {
                            this._mode = stringValue;
                            changed = true;
                        }
                        
                    case "direction":
                        stringValue = normalizeDirection(ASCompat.toString(prop.value));
                        if (this._direction != stringValue)
                        {
                            this._direction = stringValue;
                            changed = true;
                        }
                        
                }
            }
            if (changed)
            {
                invalidate();
            }
            return super.properties = k;
        }
    }

