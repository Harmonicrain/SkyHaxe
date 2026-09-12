package snowwar.outgoing
;
	import com.sulake.core.communication.messages.IMessageComposer;

     class _SafeStr_3935 implements IMessageComposer 
    {
        var _SafeStr_5824:Array<ASAny>;

        public function new(k:Int)
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

