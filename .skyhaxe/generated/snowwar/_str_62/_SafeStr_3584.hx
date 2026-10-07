package snowwar._str_62
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class _SafeStr_3584 extends SnowWarGameObjectData 
    {
        public static inline final NUM_OF_VARIABLES= 9;

        public function new(k:Int, _arg_2:Int)
        {
            super(k, _arg_2);
        }

        override public function parse(k:IMessageDataWrapper)
        {
            parseVariables(k, NUM_OF_VARIABLES);
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

        public var direction(get,never):Int;
public function  get_direction():Int
        {
            return getVariable(4);
        }

        public var height(get,never):Int;
public function  get_height():Int
        {
            return getVariable(5);
        }

        public var _SafeStr_18032(get,never):Int;
public function  get__SafeStr_18032():Int
        {
            return getVariable(6);
        }

        public var maximumHits(get,never):Int;
public function  get_maximumHits():Int
        {
            return getVariable(7);
        }

        public var hits(get,never):Int;
public function  get_hits():Int
        {
            return getVariable(8);
        }
    }

