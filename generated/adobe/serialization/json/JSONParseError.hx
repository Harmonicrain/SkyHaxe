package adobe.serialization.json
;
     class JSONParseError extends ASError 
    {
        var _location:Int = 0;
        var _text:String;

        public function new(message:String="", location:Int=0, text:String="")
        {
            super(message);
            name = "JSONParseError";
            this._location = location;
            this._text = text;
        }

        public var location(get,never):Int;
function  get_location():Int
        {
            return this._location;
        }

        public var text(get,never):String;
function  get_text():String
        {
            return this._text;
        }
    }
//package adobe.serialization.json
