package snowwar._str_62
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class SnowWarGameObjectData 
    {
        public static inline final OBJECT_TYPE_SNOWBALL= 1;
        public static inline final OBJECT_TYPE_TREE= 2;
        public static inline final OBJECT_TYPE_SNOWBALL_PILE= 3;
        public static inline final OBJECT_TYPE_SNOWBALL_MACHINE= 4;
        public static inline final OBJECT_TYPE_HUMAN= 5;

        var _variables:Array<ASAny>;

        public function new(k:Int, _arg_2:Int)
        {
            this._variables = [];
            this.setVariable(0, k);
            this.setVariable(1, _arg_2);
        }

        public static function create(k:Int, _arg_2:Int):SnowWarGameObjectData
        {
            switch (k)
            {
                case OBJECT_TYPE_SNOWBALL:
                    return new _SafeStr_3587(k, _arg_2);
                case OBJECT_TYPE_SNOWBALL_MACHINE:
                    return new _SafeStr_3585(k, _arg_2);
                case OBJECT_TYPE_SNOWBALL_PILE:
                    return new _SafeStr_3586(k, _arg_2);
                case OBJECT_TYPE_HUMAN:
                    return new HumanGameObjectData(k, _arg_2);
                case OBJECT_TYPE_TREE:
                    return new _SafeStr_3584(k, _arg_2); //TreeGameObject
                default:
                    return null;
            }
        }

        public var type(get,never):Int;
public function  get_type():Int
        {
            return this.getVariable(0);
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this.getVariable(1);
        }

        public function getVariable(k:Int):Int
        {
            return ASCompat.toInt(this._variables[k]);
        }

        function setVariable(k:Int, _arg_2:Int)
        {
            this._variables[k] = _arg_2;
        }

        function parseVariables(k:IMessageDataWrapper, _arg_2:Int)
        {
            var _local_3= 2;
            while (_local_3 < _arg_2)
            {
                this._variables.push(k.readInteger());
                _local_3++;
            }
        }

        public function parse(k:IMessageDataWrapper)
        {
        }
    }

