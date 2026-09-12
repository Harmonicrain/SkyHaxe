package com.sulake.habbo.communication.messages.incoming.navigator
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class GuestRoomSearchResultData implements IDisposable implements  MsgWithRequestId
    {
        var _searchType:Int = 0;
        var _searchParam:String;
        var _rooms:Array<ASAny>;
        var _ad:OfficialRoomEntryData;
        var _disposed:Bool = false;

        public function new(k:IMessageDataWrapper)        {
            this._rooms = new Array<ASAny>();
            this._searchType = k.readInteger();
            this._searchParam = k.readString();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._rooms.push(new GuestRoomData(k));
                _local_3++;
            }
            var _local_4= k.readBoolean();
            if (_local_4)
            {
                this._ad = new OfficialRoomEntryData(k);
            }
        }

        public function dispose()
        {
            var k:GuestRoomData = null;
            if (this._disposed)
            {
                return;
            }
            this._disposed = true;
            if (this._rooms != null)
            {
                final _iter_ = this._rooms; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
k  = _tmp_;
                    k.dispose();
                }
            }
            if (this._ad != null)
            {
                this._ad.dispose();
                this._ad = null;
            }
            this._rooms = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var searchType(get,never):Int;
public function  get_searchType():Int
        {
            return this._searchType;
        }

        public var _Str_25185(get,never):String;
public function  get__Str_25185():String
        {
            return this._searchParam;
        }

        public var rooms(get,never):Array<ASAny>;
public function  get_rooms():Array<ASAny>
        {
            return this._rooms;
        }

        public var ad(get,never):OfficialRoomEntryData;
public function  get_ad():OfficialRoomEntryData
        {
            return this._ad;
        }

        public function releaseAd():OfficialRoomEntryData
        {
            var k= this._ad;
            this._ad = null;
            return k;
        }
    }

