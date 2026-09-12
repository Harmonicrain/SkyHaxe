package com.sulake.habbo.communication.messages.incoming.newnavigator
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.habbo.communication.messages.incoming.navigator.GuestRoomData;

     class SearchResultSet 
    {
        var _searchCodeOriginal:String;
        var _filteringData:String;
        var _blocks:Vector<SearchResultList>;

        public function new(k:IMessageDataWrapper, _arg_2:SearchResultList=null)
        {
            var _local_3 = 0;
            var _local_4 = 0;
            this._blocks = new Vector<SearchResultList>(0);
            if (_arg_2 != null)
            {
                this._searchCodeOriginal = _arg_2.searchCode;
                this._filteringData = _arg_2.text;
                this._blocks.push(_arg_2);
            }
            else
            {
                this._searchCodeOriginal = k.readString();
                this._filteringData = k.readString();
                _local_3 = k.readInteger();
                _local_4 = 0;
                while (_local_4 < _local_3)
                {
                    this._blocks.push(new SearchResultList(k));
                    _local_4++;
                }
            }
        }

        public var searchCodeOriginal(get,never):String;
public function  get_searchCodeOriginal():String
        {
            return this._searchCodeOriginal;
        }

        public var filteringData(get,never):String;
public function  get_filteringData():String
        {
            return this._filteringData;
        }

        public var blocks(get,never):Vector<SearchResultList>;
public function  get_blocks():Vector<SearchResultList>
        {
            return this._blocks;
        }

        public function findGuestRoom(k:Int):GuestRoomData
        {
            var _local_2:SearchResultList = null;
            var _local_3:GuestRoomData = null;
            final _iter_ = this._blocks; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                _local_3 = _local_2.findGuestRoom(k);
                if (_local_3 != null)
                {
                    return _local_3;
                }
            }
            return null;
        }
    }

