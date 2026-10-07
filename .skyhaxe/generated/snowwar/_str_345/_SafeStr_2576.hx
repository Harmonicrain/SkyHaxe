package snowwar._str_345
;
	import com.sulake.core.communication.messages.IMessageComposer;
	
     class _SafeStr_2576 implements IMessageComposer 
    {
        var _SafeStr_13982:Int = 0;
        var _SafeStr_13983:Int = 0;
        var _SafeStr_13984:Int = 0;

        public function new(k:Int, _arg_2:Int, _arg_3:Int)
        {
            this._SafeStr_13982 = k;
            this._SafeStr_13983 = _arg_2;
            this._SafeStr_13984 = _arg_3;
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._SafeStr_13982, this._SafeStr_13983, this._SafeStr_13984];
        }

        public function dispose()
        {
        }
    }

