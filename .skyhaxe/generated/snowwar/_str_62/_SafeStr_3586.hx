package snowwar._str_62
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class _SafeStr_3586 extends SnowWarGameObjectData 
    {
        public static inline final NUM_OF_VARIABLES= 7;

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

        public var _SafeStr_18034(get,never):Int;
public function  get__SafeStr_18034():Int
        {
            return getVariable(4);
        }

        public var _SafeStr_18035(get,never):Int;
public function  get__SafeStr_18035():Int
        {
            return getVariable(5);
        }

        public var _SafeStr_18032(get,never):Int;
public function  get__SafeStr_18032():Int
        {
            return getVariable(6);
        }
    }

