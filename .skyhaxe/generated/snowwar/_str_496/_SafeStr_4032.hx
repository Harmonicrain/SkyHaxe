package snowwar._str_496
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class _SafeStr_4032 
    {
        public static var _SafeStr_19014:ASFunction = _SafeStr_19012;
        public static var _SafeStr_18802:ASFunction = _SafeStr_19013;

        var _userId:Int = 0;
        var _name:String;
        var _figure:String;
        var _gender:String;
        var _final:Int = 0;
        var _skillLevel:Int = 0;
        var _SafeStr_19017:Int = 0;
        var _SafeStr_19018:Int = 0;

        public function new(k:IMessageDataWrapper)
        {
            this._userId = k.readInteger();
            this._name = k.readString();
            this._figure = k.readString();
            this._gender = k.readString();
            this._final = k.readInteger();
            this._skillLevel = k.readInteger();
            this._SafeStr_19017 = k.readInteger();
            this._SafeStr_19018 = k.readInteger();
        }

        static function _SafeStr_19012(k:_SafeStr_4032, _arg_2:_SafeStr_4032):Float
        {
            var _local_3= k._SafeStr_17897;
            var _local_4= _arg_2._SafeStr_17897;
            if (_local_3 < _local_4)
            {
                return 1;
            }
            if (_local_3 == _local_4)
            {
                return 0;
            }
            return -1;
        }

        static function _SafeStr_19013(k:_SafeStr_4032, _arg_2:_SafeStr_4032):Float
        {
            var _local_3= k.skillLevel;
            var _local_4= _arg_2.skillLevel;
            if (_local_3 < _local_4)
            {
                return 1;
            }
            if (_local_3 == _local_4)
            {
                return 0;
            }
            return -1;
        }


        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return this._userId;
        }

        public var name(get,never):String;
public function  get_name():String
        {
            return this._name;
        }

        public var figure(get,never):String;
public function  get_figure():String
        {
            return this._figure;
        }

        public var gender(get,never):String;
public function  get_gender():String
        {
            return this._gender;
        }

        public var __as3_final(get,never):Int;
public function  get___as3_final():Int
        {
            return this._final;
        }

        public var skillLevel(get,never):Int;
public function  get_skillLevel():Int
        {
            return this._skillLevel;
        }

        public var _SafeStr_17897(get,never):Int;
public function  get__SafeStr_17897():Int
        {
            return this._SafeStr_19017;
        }

        public var _SafeStr_18803(get,never):Int;
public function  get__SafeStr_18803():Int
        {
            return this._SafeStr_19018;
        }
    }















