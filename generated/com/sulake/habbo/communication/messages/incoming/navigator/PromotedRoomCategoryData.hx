package com.sulake.habbo.communication.messages.incoming.navigator
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class PromotedRoomCategoryData implements IDisposable
    {
        var _code:String;
        var _Str_21922:String;
        var _Str_10956:GuestRoomData;
        var _rooms:Array<ASAny>;
        var _open:Bool = false;
        var _Str_20192:Bool = false;
        var _disposed:Bool = false;

        public function new(k:IMessageDataWrapper)
        {
            this._rooms = new Array<ASAny>();
            this._code = k.readString();
            this._Str_21922 = k.readString();
            var _local_2= k.readInteger();
            this._Str_10956 = new GuestRoomData(k);
            var _local_3= 1;
            while (_local_3 < _local_2)
            {
                this._rooms.push(new GuestRoomData(k));
                _local_3++;
            }
        }

        public function dispose()
        {
            var k:GuestRoomData;
            if (this._disposed)
            {
                return;
            }
            this._disposed = true;
            if (this._Str_10956 != null)
            {
                this._Str_10956.dispose();
                this._Str_10956 = null;
            }
            for (_tmp_ in this.rooms)
            {
k  = _tmp_;
                k.dispose();
            }
            this._rooms = null;
        }

        public var disposed(get,never):Bool;
function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var code(get,never):String;
function  get_code():String
        {
            return this._code;
        }

        public var _Str_23315(get,never):String;
function  get__Str_23315():String
        {
            return this._Str_21922;
        }

        public var rooms(get,never):Array<ASAny>;
function  get_rooms():Array<ASAny>
        {
            return this._rooms;
        }

        
        public var open(get,set):Bool;
function  get_open():Bool
        {
            return this._open;
        }
function  set_open(k:Bool):Bool        {
            return this._open = k;
        }

        public function _Str_16147()
        {
            this._open = (!this._open);
        }

        public var _Str_7144(get,never):GuestRoomData;
function  get__Str_7144():GuestRoomData
        {
            return this._Str_10956;
        }

        
        public var _Str_24011(get,set):Bool;
function  get__Str_24011():Bool
        {
            return this._Str_20192;
        }
function  set__Str_24011(k:Bool):Bool        {
            return this._Str_20192 = k;
        }
    }

