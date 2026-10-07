package snowwar._str_496
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class Game2GameResult 
    {
        public static inline final _SafeStr_18779= 0;
        public static inline final _SafeStr_18780= 1;
        public static inline final _SafeStr_18781= 2;

        var _SafeStr_18782:Bool = false;
        var _SafeStr_18052:Int = 0;
        var _SafeStr_18783:Int = 0;

        public function new(k:IMessageDataWrapper)
        {
            this._SafeStr_18782 = k.readBoolean();
            this._SafeStr_18052 = k.readInteger();
            this._SafeStr_18783 = k.readInteger();
        }

        public var _SafeStr_18784(get,never):Bool;
public function  get__SafeStr_18784():Bool
        {
            return this._SafeStr_18782;
        }

        public var resultType(get,never):Int;
public function  get_resultType():Int
        {
            return this._SafeStr_18052;
        }

        public var _SafeStr_18785(get,never):Int;
public function  get__SafeStr_18785():Int
        {
            return this._SafeStr_18783;
        }
    }









