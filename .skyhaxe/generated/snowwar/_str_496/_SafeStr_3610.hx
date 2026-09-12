package snowwar._str_496
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import snowwar._str_62.SnowWarGameObjectData;

     class _SafeStr_3610 
    {
        var _SafeStr_12654:Array<ASAny>;

        public function new(k:IMessageDataWrapper)
        {
            this._SafeStr_12654 = [];
            this.parse(k);
        }

        public var _SafeStr_7508(get,never):Array<ASAny>;
public function  get__SafeStr_7508():Array<ASAny>
        {
            return this._SafeStr_12654;
        }

        public function parse(k:IMessageDataWrapper)
        {
            var _local_4 = 0;
            var _local_5 = 0;
            var _local_6:SnowWarGameObjectData = null;
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                _local_4 = k.readInteger();
                _local_5 = k.readInteger();
                _local_6 = SnowWarGameObjectData.create(_local_4, _local_5);
                _local_6.parse(k);
                this._SafeStr_12654.push(_local_6);
                _local_3++;
            }
        }
    }

