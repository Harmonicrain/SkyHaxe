package adobe.serialization.json
;
     final class JSON 
    {


        public static function encode(o:ASObject):String
        {
            return new JSONEncoder(o).getString();
        }

        public static function decode(s:String, strict:Bool=true):ASAny
        {
            return new JSONDecoder(s, strict).getValue();
        }

	public function new() {}
    }
//package adobe.serialization.json
