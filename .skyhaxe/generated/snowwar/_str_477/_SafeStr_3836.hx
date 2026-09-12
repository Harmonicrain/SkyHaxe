package snowwar._str_477
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class _SafeStr_3836 implements IMessageComposer 
    {
        var _SafeStr_5824:Array<ASAny>;

        public function new(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Int, _arg_5:Int, _arg_6:Int)
        {
            this._SafeStr_5824 = [];
            this._SafeStr_5824.push(k);
            this._SafeStr_5824.push(_arg_2);
            this._SafeStr_5824.push(_arg_3);
            this._SafeStr_5824.push(_arg_4);
            this._SafeStr_5824.push(_arg_5);
            this._SafeStr_5824.push(_arg_6);
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

