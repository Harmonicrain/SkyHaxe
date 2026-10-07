package snowwar._str_62
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class _SafeStr_3587 extends SnowWarGameObjectData 
    {
        public static inline final NUM_OF_VARIABLES= 11;
        public static inline final _SafeStr_13247= 0;
        public static inline final _SafeStr_13245= 1;
        public static inline final _SafeStr_13243= 2;

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

        public var _SafeStr_18036(get,never):Int;
public function  get__SafeStr_18036():Int
        {
            return getVariable(4);
        }

        public var _SafeStr_18037(get,never):Int;
public function  get__SafeStr_18037():Int
        {
            return getVariable(5);
        }

        public var _SafeStr_18038(get,never):Int;
public function  get__SafeStr_18038():Int
        {
            return getVariable(6);
        }

        public var _SafeStr_18039(get,never):Int;
public function  get__SafeStr_18039():Int
        {
            return getVariable(7);
        }

        public var _SafeStr_18040(get,never):Int;
public function  get__SafeStr_18040():Int
        {
            return getVariable(8);
        }

        public var _SafeStr_18041(get,never):Int;
public function  get__SafeStr_18041():Int
        {
            return getVariable(9);
        }

        public var _SafeStr_18042(get,never):Int;
public function  get__SafeStr_18042():Int
        {
            return getVariable(10);
        }
    }

