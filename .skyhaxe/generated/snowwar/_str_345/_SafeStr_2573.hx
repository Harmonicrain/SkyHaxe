package snowwar._str_345
;
	import com.sulake.core.communication.messages.IMessageComposer;
	
     class _SafeStr_2573 implements IMessageComposer 
    {
        var _SafeStr_7917:Int = 0;

        public function new(k:Int)
        {
            this._SafeStr_7917 = k;
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._SafeStr_7917];
        }

        public function dispose()
        {
        }
    }

