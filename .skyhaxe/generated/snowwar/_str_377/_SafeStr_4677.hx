package snowwar._str_377
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class _SafeStr_4677 
    {
        public static inline final _SafeStr_18990= 1;
        public static inline final _SafeStr_18987= 2;
        public static inline final _SafeStr_18988= 3;
        public static inline final _SafeStr_18989= 4;
        public static inline final _SafeStr_18985= 7;
        public static inline final _SafeStr_18983= 8;
        public static inline final _SafeStr_18986= 11;
        public static inline final _SafeStr_18984= 12;

        var _id:Int = 0;

        public function new(k:Int)
        {
            this._id = k;
        }

        public static function create(k:Int):_SafeStr_4677
        {
            switch (k)
            {
                case _SafeStr_18987:
                    return new _SafeStr_4689(k); //2 //PlayerMoveEvent
                case _SafeStr_18988:
                    return new _SafeStr_4691(k); //3 //ThrowBallToPlayerEvent
                case _SafeStr_18989:
                    return new _SafeStr_4688(k); //4
                case _SafeStr_18985:
                    return new _SafeStr_4681(k); //7
                case _SafeStr_18983:
                    return new _SafeStr_4687(k); //8
                case _SafeStr_18986:
                    return new _SafeStr_4679(k); //11
                case _SafeStr_18984:
                    return new _SafeStr_4686(k); //12
                case _SafeStr_18990:
                    return new _SafeStr_4680(k); //1 //RemovePlayerEvent
                default:
                    return null;
            }
        }

        
        public var id(get,set):Int;
public function  get_id():Int
        {
            return this._id;
        }
public function  set_id(k:Int):Int        {
            return this._id = k;
        }

        public function parse(k:IMessageDataWrapper)
        {
        }
    }

