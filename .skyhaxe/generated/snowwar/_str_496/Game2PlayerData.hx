package snowwar._str_496
;
	import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class Game2PlayerData implements IDisposable 
    {
        var _SafeStr_22185:Int = 0;
        var _userName:String;
        var _SafeStr_16162:String;
        var _gender:String;
        var _final:Int = 0;
        var _disposed:Bool = false;


        public function dispose()
        {
            this._userName = null;
            this._SafeStr_16162 = null;
            this._disposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function parse(k:IMessageDataWrapper)
        {
            this._SafeStr_22185 = k.readInteger();
            this._userName = k.readString();
            this._SafeStr_16162 = k.readString();
            this._gender = k.readString();
            this._final = k.readInteger();
        }

        public function toString():String
        {
            return (("[Game Player] " + Std.string(this._SafeStr_22185)) + ": ") + this._userName;
        }

        public var _SafeStr_22186(get,never):Int;
public function  get__SafeStr_22186():Int
        {
            return this._SafeStr_22185;
        }

        public var userName(get,never):String;
public function  get_userName():String
        {
            return this._userName;
        }

        public var _SafeStr_9044(get,never):String;
public function  get__SafeStr_9044():String
        {
            return this._SafeStr_16162;
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

        public var _SafeStr_22187(get,never):Bool;
public function  get__SafeStr_22187():Bool
        {
            return this._disposed;
        }
public function new(){}
    }











