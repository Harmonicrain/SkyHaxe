package snowwar._str_277
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class SnowStormIntializedPlayersParser implements IMessageParser 
    {
        var _SafeStr_21868:Int = 0;
        var _SafeStr_21869:Array<ASAny>;

        public var _SafeStr_18960(get,never):Int;
public function  get__SafeStr_18960():Int
        {
            return this._SafeStr_21868;
        }

        public var _SafeStr_18961(get,never):Array<ASAny>;
public function  get__SafeStr_18961():Array<ASAny>
        {
            return this._SafeStr_21869;
        }

        public function flush():Bool
        {
            return false;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._SafeStr_21868 = k.readInteger();
            this._SafeStr_21869 = [];
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._SafeStr_21869.push(k.readInteger());
                _local_3++;
            }
            return true;
        }

	public function new() {}
    }

