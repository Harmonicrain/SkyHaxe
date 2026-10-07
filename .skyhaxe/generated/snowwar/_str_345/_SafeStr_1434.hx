package snowwar._str_345
;
	import com.sulake.core.communication.messages.IMessageComposer;

     class _SafeStr_1434 implements IMessageComposer 
    {
        var _SafeStr_6182:String;
        var _SafeStr_5817:String;
        var _SafeStr_5072:String;
        var _SafeStr_7863:String;
        var _SafeStr_7864:Int = 0;

        public function new(k:String, _arg_2:String, _arg_3:String, _arg_4:String="", _arg_5:Int=0)
        {
            if ((((k == null) || (_arg_2 == null)) || (_arg_3 == null)))
            {
                Logger.log(["Missing parameter!"]);
            }
            this._SafeStr_6182 = (ASCompat.stringAsBool(k) ? k : "");
            this._SafeStr_5817 = (ASCompat.stringAsBool(_arg_2) ? _arg_2 : "");
            this._SafeStr_5072 = (ASCompat.stringAsBool(_arg_3) ? _arg_3 : "");
            this._SafeStr_7863 = (ASCompat.stringAsBool(_arg_4) ? _arg_4 : "");
            this._SafeStr_7864 = ((_arg_5 != 0) ? _arg_5 : 0);
        }

        public function dispose()
        {
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._SafeStr_6182, this._SafeStr_5817, this._SafeStr_5072, this._SafeStr_7863, this._SafeStr_7864];
        }
    }

