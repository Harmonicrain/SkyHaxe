package com.sulake.habbo.communication.messages.incoming.navigator
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class OfficialRoomEntryData implements IDisposable
    {
        public static inline final _Str_14955= 1;
        public static inline final _Str_12025= 2;
        public static inline final _Str_16098= 4;

        var _index:Int = 0;
        var _Str_20260:String;
        var _Str_21337:String;
        var _Str_21113:Bool = false;
        var _picText:String;
        var _Str_6192:String;
        var _Str_22099:Int = 0;
        var _userCount:Int = 0;
        var _type:Int = 0;
        var _tag:String;
        var _Str_2567:GuestRoomData;
        var _open:Bool = false;
        var _disposed:Bool = false;

        public function new(k:IMessageDataWrapper)
        {
            this._index = k.readInteger();
            this._Str_20260 = k.readString();
            this._Str_21337 = k.readString();
            this._Str_21113 = (k.readInteger() == 1);
            this._picText = k.readString();
            this._Str_6192 = k.readString();
            this._Str_22099 = k.readInteger();
            this._userCount = k.readInteger();
            this._type = k.readInteger();
            if (this._type == _Str_14955)
            {
                this._tag = k.readString();
            }
            else
            {
                if (this._type == _Str_12025)
                {
                    this._Str_2567 = new GuestRoomData(k);
                }
                else
                {
                    this._open = k.readBoolean();
                }
            }
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            this._disposed = true;
            if (this._Str_2567 != null)
            {
                this._Str_2567.dispose();
                this._Str_2567 = null;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var type(get,never):Int;
public function  get_type():Int
        {
            return this._type;
        }

        public var index(get,never):Int;
public function  get_index():Int
        {
            return this._index;
        }

        public var _Str_9428(get,never):String;
public function  get__Str_9428():String
        {
            return this._Str_20260;
        }

        public var _Str_22426(get,never):String;
public function  get__Str_22426():String
        {
            return this._Str_21337;
        }

        public var _Str_5386(get,never):Bool;
public function  get__Str_5386():Bool
        {
            return this._Str_21113;
        }

        public var picText(get,never):String;
public function  get_picText():String
        {
            return this._picText;
        }

        public var _Str_10304(get,never):String;
public function  get__Str_10304():String
        {
            return this._Str_6192;
        }

        public var _Str_22186(get,never):Int;
public function  get__Str_22186():Int
        {
            return this._Str_22099;
        }

        public var tag(get,never):String;
public function  get_tag():String
        {
            return this._tag;
        }

        public var userCount(get,never):Int;
public function  get_userCount():Int
        {
            return this._userCount;
        }

        public var _Str_5019(get,never):GuestRoomData;
public function  get__Str_5019():GuestRoomData
        {
            return this._Str_2567;
        }

        public var open(get,never):Bool;
public function  get_open():Bool
        {
            return this._open;
        }

        public function _Str_16147()
        {
            this._open = (!this._open);
        }

        public var _Str_23003(get,never):Int;
public function  get__Str_23003():Int
        {
            if (this.type == _Str_14955)
            {
                return 0;
            }
            if (this.type == _Str_12025)
            {
                return this._Str_2567.maxUserCount;
            }
            return 0;
        }
    }

