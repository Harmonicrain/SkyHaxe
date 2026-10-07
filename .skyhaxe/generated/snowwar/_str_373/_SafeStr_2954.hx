package snowwar._str_373
;
	import com.sulake.core.communication.messages.IMessageComposer;

     class _SafeStr_2954 implements IMessageComposer 
    {
        var _SafeStr_16356:String;

        public function new(k:String)
        {
            this._SafeStr_16356 = k;
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._SafeStr_16356];
        }

        public function dispose()
        {
            this._SafeStr_16356 = null;
        }
    }

