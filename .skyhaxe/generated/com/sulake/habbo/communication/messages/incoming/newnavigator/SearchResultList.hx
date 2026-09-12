package com.sulake.habbo.communication.messages.incoming.newnavigator
;
    import com.sulake.habbo.communication.messages.incoming.navigator.GuestRoomData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class SearchResultList 
    {
        public static inline final _Str_20426= 0;
        public static inline final _Str_14200= 1;
        public static inline final _Str_15183= 2;

        var _searchCode:String;
        var _text:String;
        var _actionAllowed:Int = 0;
        var _forceClosed:Bool = false;
        var _viewMode:Int = 0;
        var _guestRooms:Vector<GuestRoomData>;

        public function new(k:IMessageDataWrapper)
        {
            this._guestRooms = new Vector<GuestRoomData>(0);
            this._searchCode = k.readString();
            this._text = k.readString();
            this._actionAllowed = k.readInteger();
            this._forceClosed = k.readBoolean();
            this._viewMode = k.readInteger();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._guestRooms.push(new GuestRoomData(k));
                _local_3++;
            }
        }

        public var guestRooms(get,never):Vector<GuestRoomData>;
public function  get_guestRooms():Vector<GuestRoomData>
        {
            return this._guestRooms;
        }

        public var searchCode(get,never):String;
public function  get_searchCode():String
        {
            return this._searchCode;
        }

        public var text(get,never):String;
public function  get_text():String
        {
            return this._text;
        }

        public var actionAllowed(get,never):Int;
public function  get_actionAllowed():Int
        {
            return this._actionAllowed;
        }

        public var _Str_25561(get,never):Bool;
public function  get__Str_25561():Bool
        {
            return this._forceClosed;
        }

        
        public var viewMode(get,set):Int;
public function  get_viewMode():Int
        {
            return this._viewMode;
        }
public function  set_viewMode(k:Int):Int        {
            return this._viewMode = k;
        }

        public function findGuestRoom(k:Int):GuestRoomData
        {
            var _local_2:GuestRoomData = null;
            final _iter_ = this._guestRooms; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.flatId == k)
                {
                    return _local_2;
                }
            }
            return null;
        }
    }

