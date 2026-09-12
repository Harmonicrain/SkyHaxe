package snowwar._str_400
;
	import com.sulake.core.communication.messages.IMessageComposer;

     class _SafeStr_2507 implements IMessageComposer 
    {
        var _SafeStr_5824:Array<ASAny>;

        public function new(k:String)
        {
            this._SafeStr_5824 = [];
            this._SafeStr_5824.push(k);
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

