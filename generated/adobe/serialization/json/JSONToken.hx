package adobe.serialization.json
;
     final class JSONToken 
    {
        @:allow(adobe.serialization.json) static final token:JSONToken = Type.createInstance(JSONToken, []);

        public var type:Int = 0;
        public var value:ASObject;

        public function new(_arg_1:Int=-1, value:ASObject=null)
        {
            this.type = _arg_1;
            this.value = value;
        }

        @:allow(adobe.serialization.json) static function create(_arg_1:Int=-1, value:ASObject=null):JSONToken
        {
            token.type = _arg_1;
            token.value = value;
            return token;
        }
    }
//package adobe.serialization.json
