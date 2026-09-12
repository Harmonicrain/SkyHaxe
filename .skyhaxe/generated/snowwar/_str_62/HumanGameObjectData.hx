package snowwar._str_62
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class HumanGameObjectData extends SnowWarGameObjectData 
    {
        public static inline final NUM_OF_VARIABLES= 19;

        var _name:String;
        var _mission:String;
        var _figure:String;
        var _sex:String;

        public function new(k:Int, _arg_2:Int)
        {
            super(k, _arg_2);
        }

        public var name(get,never):String;
public function  get_name():String
        {
            return this._name;
        }

        public var mission(get,never):String;
public function  get_mission():String
        {
            return this._mission;
        }

        public var figure(get,never):String;
public function  get_figure():String
        {
            return this._figure;
        }

        public var sex(get,never):String;
public function  get_sex():String
        {
            return this._sex;
        }

        override public function parse(k:IMessageDataWrapper)
        {
            parseVariables(k, NUM_OF_VARIABLES);
            this._name = k.readString();
            this._mission = k.readString();
            this._figure = k.readString();
            this._sex = k.readString();
            Logger.log([("Parsed human game object data, variables:" + ASCompat.toString(_variables))]);
        }

        public var x(get,never):Int;
public function  get_x():Int
        {
            return getVariable(2);
        }

        public var y(get,never):Int;
public function  get_y():Int
        {
            return getVariable(3);
        }

        public var _SafeStr_12581(get,never):Int;
public function  get__SafeStr_12581():Int
        {
            return getVariable(4);
        }

        public var _SafeStr_12582(get,never):Int;
public function  get__SafeStr_12582():Int
        {
            return getVariable(5);
        }

        public var _SafeStr_12583(get,never):Int;
public function  get__SafeStr_12583():Int
        {
            return getVariable(6);
        }

        public var _SafeStr_12584(get,never):Int;
public function  get__SafeStr_12584():Int
        {
            return getVariable(7);
        }

        public var _SafeStr_12585(get,never):Int;
public function  get__SafeStr_12585():Int
        {
            return getVariable(8);
        }

        public var _SafeStr_12586(get,never):Int;
public function  get__SafeStr_12586():Int
        {
            return getVariable(9);
        }

        public var _SafeStr_12587(get,never):Int;
public function  get__SafeStr_12587():Int
        {
            return getVariable(10);
        }

        public var _SafeStr_12588(get,never):Int;
public function  get__SafeStr_12588():Int
        {
            return getVariable(11);
        }

        public var _SafeStr_12589(get,never):Int;
public function  get__SafeStr_12589():Int
        {
            return getVariable(12);
        }

        public var _SafeStr_12590(get,never):Int;
public function  get__SafeStr_12590():Int
        {
            return getVariable(13);
        }

        public var _SafeStr_12591(get,never):Int;
public function  get__SafeStr_12591():Int
        {
            return getVariable(14);
        }

        public var _SafeStr_12592(get,never):Int;
public function  get__SafeStr_12592():Int
        {
            return getVariable(15);
        }

        public var score(get,never):Int;
public function  get_score():Int
        {
            return getVariable(16);
        }

        public var team(get,never):Int;
public function  get_team():Int
        {
            return getVariable(17);
        }

        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return getVariable(18);
        }
    }

