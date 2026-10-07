package snowwar._str_345
;
	import com.sulake.core.communication.messages.IMessageComposer;

     class _SafeStr_2577 implements IMessageComposer 
    {
        var _SafeStr_6000:Int = 0;

        public function new(k:Int)
        {
            this._SafeStr_6000 = k;
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._SafeStr_6000];
        }

        public function dispose()
        {
        }
    }

