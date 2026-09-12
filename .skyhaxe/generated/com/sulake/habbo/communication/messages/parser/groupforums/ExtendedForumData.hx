package com.sulake.habbo.communication.messages.parser.groupforums
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ExtendedForumData extends ForumData
    {
        var _Str_6730:Int = 0;
        var _Str_6541:Int = 0;
        var _Str_9497:Int = 0;
        var _Str_9468:Int = 0;
        var _Str_17602:String;
        var _Str_18223:String;
        var _Str_17180:String;
        var _Str_18661:String;
        var _Str_21185:String;
        var _Str_20626:Bool = false;
        var _Str_20847:Bool = false;


        public static function _Str_4933(k:IMessageDataWrapper):ExtendedForumData
        {
            var _local_2= Type.createInstance(ExtendedForumData, []);
            ForumData.fillFromMessage(_local_2, k);
            _local_2._Str_6730 = k.readInteger();
            _local_2._Str_6541 = k.readInteger();
            _local_2._Str_9497 = k.readInteger();
            _local_2._Str_9468 = k.readInteger();
            _local_2._Str_17602 = k.readString();
            _local_2._Str_18223 = k.readString();
            _local_2._Str_17180 = k.readString();
            _local_2._Str_18661 = k.readString();
            _local_2._Str_21185 = k.readString();
            _local_2._Str_20626 = k.readBoolean();
            _local_2._Str_20847 = k.readBoolean();
            return _local_2;
        }


        public var _Str_24871(get,never):Int;
public function  get__Str_24871():Int
        {
            return this._Str_6730;
        }

        public var _Str_25794(get,never):Int;
public function  get__Str_25794():Int
        {
            return this._Str_6541;
        }

        public var _Str_24408(get,never):Int;
public function  get__Str_24408():Int
        {
            return this._Str_9497;
        }

        public var _Str_24549(get,never):Int;
public function  get__Str_24549():Int
        {
            return this._Str_9468;
        }

        public var _Str_22865(get,never):Bool;
public function  get__Str_22865():Bool
        {
            return this._Str_17602.length == 0;
        }

        public var _Str_21331(get,never):Bool;
public function  get__Str_21331():Bool
        {
            return true;
        }

        public var _Str_20636(get,never):Bool;
public function  get__Str_20636():Bool
        {
            return this._Str_18223.length == 0;
        }

        public var _Str_23163(get,never):Bool;
public function  get__Str_23163():Bool
        {
            return this._Str_17180.length == 0;
        }

        public var _Str_7246(get,never):Bool;
public function  get__Str_7246():Bool
        {
            return this._Str_18661.length == 0;
        }

        public var _Str_25616(get,never):Bool;
public function  get__Str_25616():Bool
        {
            return this._Str_20626;
        }

        public var _Str_7449(get,never):Bool;
public function  get__Str_7449():Bool
        {
            return this._Str_20847;
        }

        public var _Str_24689(get,never):String;
public function  get__Str_24689():String
        {
            return this._Str_17602;
        }

        public var _Str_23527(get,never):String;
public function  get__Str_23527():String
        {
            return this._Str_18223;
        }

        public var _Str_22973(get,never):String;
public function  get__Str_22973():String
        {
            return this._Str_17180;
        }

        public var _Str_25440(get,never):String;
public function  get__Str_25440():String
        {
            return this._Str_18661;
        }

        public var _Str_26416(get,never):String;
public function  get__Str_26416():String
        {
            return this._Str_21185;
        }

	public function new() { super(); }
    }

