package snowwar._str_496
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class SnowWarGameStageMessageParser 
    {
        var _width:Int = 0;
        var _height:Int = 0;
        var _model:String;
        var _fuseObjects:Array<ASAny>;

        public function new(k:IMessageDataWrapper)
        {
            this._fuseObjects = [];
            this.parse(k);
        }

        public var width(get,never):Int;
public function  get_width():Int
        {
            return this._width;
        }

        public var height(get,never):Int;
public function  get_height():Int
        {
            return this._height;
        }

        public var model(get,never):String;
public function  get_model():String
        {
            return this._model;
        }

        public var fuseObjects(get,never):Array<ASAny>;
public function  get_fuseObjects():Array<ASAny>
        {
            return this._fuseObjects;
        }

        public function parse(k:IMessageDataWrapper)
        {
            var i = 0;
            var object:SnowWarFurnitureObject = null;
            this._width = k.readInteger();
            this._height = k.readInteger();
            this._model = k.readString();
            var count= k.readInteger();
            i = 0;
            while (i < count)
            {
                object = new SnowWarFurnitureObject();
                object.parse(k);
                this._fuseObjects.push(object);
                i++;
            }
        }
    }

