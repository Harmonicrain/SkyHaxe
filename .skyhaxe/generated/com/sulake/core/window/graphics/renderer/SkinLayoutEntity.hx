package com.sulake.core.window.graphics.renderer
;
    import com.sulake.core.window.utils.IChildEntity;
    import flash.geom.Rectangle;

     class SkinLayoutEntity implements IChildEntity 
    {
        public static final SCALE_TYPE_FIXED:UInt = (0 << 0);
        public static final SCALE_TYPE_MOVE:UInt = (1 << 0);
        public static final SCALE_TYPE_STRECH:UInt = (1 << 1);
        public static final SCALE_TYPE_TILED:UInt = (1 << 2);
        public static final SCALE_TYPE_CENTER:UInt = (1 << 3);

        public static inline final COLORIZE_METHOD_MULTIPLY= "multiply";
        public static inline final COLORIZE_METHOD_HSV_LAYER= "hsv_layer";

        var _id:UInt = 0;
        var _name:String;
        public var color:UInt = 0;
        public var blend:UInt = 0;
        public var scaleH:UInt = 0;
        public var scaleV:UInt = 0;
        public var region:Rectangle;
        public var colorize:Bool = false;
        public var colorizeMethod:String = COLORIZE_METHOD_MULTIPLY;
        public var shade:Float = 0;

        public function new(id:UInt, name:String)
        {
            this._id = id;
            this._name = name;
        }

        public var id(get,never):UInt;
public function  get_id():UInt
        {
            return this._id;
        }

        public var name(get,never):String;
public function  get_name():String
        {
            return this._name;
        }

        public var tags(get,never):Array<ASAny>;
public function  get_tags():Array<ASAny>
        {
            return null;
        }

        public function dispose()
        {
            this.region = null;
        }
    }

