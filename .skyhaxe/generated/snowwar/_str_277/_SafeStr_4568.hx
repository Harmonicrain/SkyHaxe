package snowwar._str_277
;
    import com.sulake.core.communication.messages.IMessageParser;
    import snowwar._str_496.Game2PlayerData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class _SafeStr_4568 implements IMessageParser 
    {
        var _SafeStr_14869:Game2PlayerData;

        public function flush():Bool
        {
            if (this._SafeStr_14869 != null)
            {
                this._SafeStr_14869.dispose();
                this._SafeStr_14869 = null;
            }
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._SafeStr_14869 = new Game2PlayerData();
            this._SafeStr_14869.parse(k);
            return true;
        }

        public var player(get,never):Game2PlayerData;
public function  get_player():Game2PlayerData
        {
            return this._SafeStr_14869;
        }

	public function new() {}
    }

