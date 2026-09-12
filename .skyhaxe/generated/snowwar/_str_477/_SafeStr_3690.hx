package snowwar._str_477
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class _SafeStr_3690 implements IMessageComposer 
    {
        var _SafeStr_5824:Array<ASAny>;

        public function new(k:Int, _arg_2:Int)
        {
            this._SafeStr_5824 = [];
            this._SafeStr_5824.push(k);
            this._SafeStr_5824.push(_arg_2);
        }

        public function getMessageArray():Array<ASAny>
        {
            return this._SafeStr_5824;
        }

        public function dispose()
        {
            this._SafeStr_5824 = null;
        }
    }

