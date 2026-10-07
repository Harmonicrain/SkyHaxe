package snowwar._str_373
;
	import com.sulake.core.communication.messages.IMessageComposer;

     class _SafeStr_3665 implements IMessageComposer 
    {
        var _SafeStr_18269:Bool = false;

        public function new(k:Bool=true)
        {
            this._SafeStr_18269 = k;
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._SafeStr_18269];
        }

        public function dispose()
        {
        }
    }

