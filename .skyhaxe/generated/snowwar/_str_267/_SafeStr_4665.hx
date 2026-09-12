package snowwar._str_267
;
    import snowwar.SnowWarEngine;
    import snowwar._str_477._SafeStr_3633;
    import com.sulake.core.communication.messages.IMessageComposer;

     class _SafeStr_4665 extends _SafeStr_4664 
    {
        var _offset:Int = 0;
        var _SafeStr_21823:Int = 0;

        public function new(k:SnowWarEngine)
        {
            super(k);
        }

        
        public var offset(get,set):Int;
public function  get_offset():Int
        {
            return this._offset;
        }
public function  set_offset(k:Int):Int        {
            if (((k >= 0) && (k <= this._SafeStr_21823)))
            {
                this._offset = k;
            }
return k;
        }

        
        public var maxOffset(get,set):Int;
public function  get_maxOffset():Int
        {
            return this._SafeStr_21823;
        }
public function  set_maxOffset(k:Int):Int        {
            return this._SafeStr_21823 = k;
        }

        override function getMessageComposer(k:Int, _arg_2:Int, _arg_3:Int):IMessageComposer
        {
            return new _SafeStr_3633(k, this._offset, _arg_2, _arg_3, _SafeStr_22049, _SafeStr_22050);
        }
    }

