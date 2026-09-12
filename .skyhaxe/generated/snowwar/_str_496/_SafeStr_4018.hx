package snowwar._str_496
;
	import com.sulake.core.communication.messages.IMessageDataWrapper;

     class _SafeStr_4018 
    {
        var _SafeStr_18565:Int = 0;
        var _SafeStr_18580:String;
        var _fieldId:Int = 0;
        var _fieldName:Int = 0;
        var _SafeStr_18581:Int = 0;
        var _SafeStr_18596:Int = 0;
        var _SafeStr_18597:String;
        var _SafeStr_18598:Int = 0;
        var _SafeStr_13149:Array<ASAny>;

        public function new(k:IMessageDataWrapper)
        {
            this._SafeStr_13149 = [];
            this._SafeStr_18565 = k.readInteger();
            this._SafeStr_18580 = k.readString();
            this._fieldId = k.readInteger();
            this._fieldName = k.readInteger();
            this._SafeStr_18581 = k.readInteger();
            this._SafeStr_18596 = k.readInteger();
            this._SafeStr_18597 = k.readString();
            this._SafeStr_18598 = k.readInteger();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._SafeStr_13149.push(new _SafeStr_4032(k));
                _local_3++;
            }
        }

        public var _SafeStr_13085(get,never):Int;
public function  get__SafeStr_13085():Int
        {
            return this._SafeStr_18565;
        }

        public var fieldId(get,never):Int;
public function  get_fieldId():Int
        {
            return this._fieldId;
        }

        public var fieldName(get,never):Int;
public function  get_fieldName():Int //_SafeStr_13230
        {
            return this._fieldName;
        }

        public var _SafeStr_13274(get,never):Int;
public function  get__SafeStr_13274():Int
        {
            return this._SafeStr_18581;
        }

        public var _SafeStr_13275(get,never):Int;
public function  get__SafeStr_13275():Int
        {
            return this._SafeStr_18596;
        }

        public var _SafeStr_18599(get,never):String;
public function  get__SafeStr_18599():String
        {
            return this._SafeStr_18597;
        }

        public var _SafeStr_18600(get,never):Int;
public function  get__SafeStr_18600():Int
        {
            return this._SafeStr_18598;
        }

        public var _SafeStr_13266(get,never):Array<ASAny>;
public function  get__SafeStr_13266():Array<ASAny>
        {
            return this._SafeStr_13149;
        }
    }

