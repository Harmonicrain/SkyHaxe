package snowwar._str_400
;
	import com.sulake.core.communication.messages.IMessageComposer;

     class _SafeStr_3813 implements IMessageComposer 
    {
        var _SafeStr_5824:Array<ASAny>;

        public function new()
        {
            this._SafeStr_5824 = [];
        }

        public function getMessageArray():Array<ASAny>
        {
            return this._SafeStr_5824;
        }

        public function dispose()
        {
            this._SafeStr_5824 = [];
        }
    }

