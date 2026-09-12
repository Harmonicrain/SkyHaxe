package com.sulake.core.window.theme
;
    import com.sulake.core.window.utils.PropertyStruct;
    import com.sulake.core.window.utils.*;

     class PropertyMap implements IPropertyMap 
    {
        var _map:ASDictionary<ASAny,ASAny>;

        public function new()
        {
            this._map = new ASDictionary<ASAny,ASAny>();
        }

        function add(key:String, value:ASObject, type:String, range:Array<ASAny>=null)
        {
            this._map[key] = new PropertyStruct(key, value, type, false, range);
        }

        public function addBoolean(key:String, value:Bool)
        {
            this.add(key, value, PropertyStruct.BOOLEAN);
        }

        public function addInt(key:String, value:Int)
        {
            this.add(key, value, PropertyStruct.INT);
        }

        public function addUint(key:String, value:UInt)
        {
            this.add(key, value, PropertyStruct.UINT);
        }

        public function addHex(key:String, value:UInt)
        {
            this.add(key, value, PropertyStruct.HEX);
        }

        public function addNumber(key:String, value:Float)
        {
            this.add(key, value, PropertyStruct.NUMBER);
        }

        public function addString(key:String, value:String)
        {
            this.add(key, value, PropertyStruct.STRING);
        }

        public function addEnumeration(key:String, value:String, range:Array<ASAny>)
        {
            this.add(key, value, PropertyStruct.STRING, range);
        }

        public function addArray(key:String, value:Array<ASAny>)
        {
            this.add(key, value, PropertyStruct.ARRAY);
        }

        public function get(key:String):PropertyStruct
        {
            return this._map[key];
        }

        public function clone():PropertyMap
        {
var key:String  = null;            var copy= new PropertyMap();
            final _iter_ = this._map; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
            {
key = _tmp_;
                copy._map[key] = this._map[key];
            }
            return copy;
        }
    }

