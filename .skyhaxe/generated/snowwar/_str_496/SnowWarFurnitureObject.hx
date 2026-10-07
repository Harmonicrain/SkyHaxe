package snowwar._str_496
;
    import com.sulake.habbo.room.IStuffData;
    import com.sulake.habbo.communication.messages.parser.room.engine.ObjectDataParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class SnowWarFurnitureObject 
    {
        var _name:String;
        var _id:Int = 0;
        var _x:Int = 0;
        var _y:Int = 0;
        var _width:Int = 0;
        var _length:Int = 0;
        var _height:Int = 0;
        var _direction:Int = 0;
        var _altitude:Int = 0;
        var _walkable:Bool = false;
        var _extradata:IStuffData;


        public function parse(k:IMessageDataWrapper)
        {
            this._name = k.readString();
            this._id = k.readInteger();
            this._x = k.readInteger();
            this._y = k.readInteger();
            this._width = k.readInteger();
            this._length = k.readInteger();
            this._height = k.readInteger();
            this._direction = k.readInteger();
            this._altitude = k.readInteger();
            this._walkable = k.readBoolean();
            this._extradata = ObjectDataParser.parseStuffData(k);
        }

        public var name(get,never):String;
public function  get_name():String
        {
            return this._name;
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }

        public var x(get,never):Int;
public function  get_x():Int
        {
            return this._x;
        }

        public var y(get,never):Int;
public function  get_y():Int
        {
            return this._y;
        }

        public var width(get,never):Int;
public function  get_width():Int
        {
            return this._width;
        }

        public var length(get,never):Int;
public function  get_length():Int
        {
            return this._length;
        }

        public var height(get,never):Int;
public function  get_height():Int
        {
            return this._height;
        }

        public var direction(get,never):Int;
public function  get_direction():Int
        {
            return this._direction;
        }

        public var altitude(get,never):Int;
public function  get_altitude():Int
        {
            return this._altitude;
        }

        public var walkable(get,never):Bool;
public function  get_walkable():Bool
        {
            return this._walkable;
        }

        public var extradata(get,never):IStuffData;
public function  get_extradata():IStuffData
        {
            return this._extradata;
        }
public function new(){}
    }


















