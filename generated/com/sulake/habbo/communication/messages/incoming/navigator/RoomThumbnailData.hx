package com.sulake.habbo.communication.messages.incoming.navigator
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class RoomThumbnailData implements IDisposable
    {
        var _Str_6284:Int = 0;
        var _Str_7862:Int = 0;
        var _Str_2549:Array<ASAny>;
        var _disposed:Bool = false;

        public function new(k:IMessageDataWrapper)
        {
            var _local_4:RoomThumbnailObjectData;
            this._Str_2549 = new Array<ASAny>();
            if (k == null)
            {
                return;
            }
            this._Str_6284 = k.readInteger();
            this._Str_7862 = k.readInteger();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                _local_4 = new RoomThumbnailObjectData();
                _local_4._Str_12651 = k.readInteger();
                _local_4._Str_13964 = k.readInteger();
                this._Str_2549.push(_local_4);
                _local_3++;
            }
            if (this._Str_6284 == 0)
            {
                this.setDefaults();
            }
        }

        public function setDefaults()
        {
            this._Str_6284 = 1;
            this._Str_7862 = 0;
            var k= new RoomThumbnailObjectData();
            k._Str_12651 = 4;
            k._Str_13964 = 1;
            this._Str_2549.push(k);
        }

        public function _Str_20539():RoomThumbnailData
        {
            var _local_2:RoomThumbnailObjectData;
            var k= new RoomThumbnailData(null);
            k._Str_6284 = this._Str_6284;
            k._Str_7862 = this._Str_7862;
            for (_tmp_ in this._Str_2549)
            {
_local_2  = _tmp_;
                k._Str_2549.push(_local_2._Str_20539());
            }
            return k;
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            this._disposed = true;
            this._Str_2549 = null;
        }

        public function _Str_22978():String
        {
            var _local_2:RoomThumbnailObjectData;
            var k:ASAny = (this._Str_7862 + ";");
            k = (k + (this._Str_6284 + ";"));
            for (_tmp_ in this._Str_2549)
            {
_local_2  = _tmp_;
                k = (k + (((_local_2._Str_13964 + ",") + _local_2._Str_12651) + ";"));
            }
            return k;
        }

        public var disposed(get,never):Bool;
function  get_disposed():Bool
        {
            return this._disposed;
        }

        
        public var _Str_22663(get,set):Int;
function  get__Str_22663():Int
        {
            return this._Str_6284;
        }

        
        public var _Str_25765(get,set):Int;
function  get__Str_25765():Int
        {
            return this._Str_7862;
        }

        public var _Str_26098(get,never):Array<ASAny>;
function  get__Str_26098():Array<ASAny>
        {
            return this._Str_2549;
        }
function  set__Str_22663(k:Int):Int        {
            return this._Str_6284 = k;
        }
function  set__Str_25765(k:Int):Int        {
            return this._Str_7862 = k;
        }
    }

