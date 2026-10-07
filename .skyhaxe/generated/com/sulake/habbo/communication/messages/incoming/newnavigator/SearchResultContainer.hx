package com.sulake.habbo.communication.messages.incoming.newnavigator
;
    import com.sulake.habbo.communication.messages.incoming.navigator.GuestRoomData;

     class SearchResultContainer
    {
        var _searchCodeOriginal:String;
        var _filteringData:String;
        var _resultSet:SearchResultSet;

        public function new(k:SearchResultSet)
        {
            this._searchCodeOriginal = k.searchCodeOriginal;
            this._filteringData = k.filteringData;
            this._resultSet = k;
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

        public var resultSet(get,never):SearchResultSet;
public function  get_resultSet():SearchResultSet
        {
            return this._resultSet;
        }

        public function findGuestRoom(k:Int):GuestRoomData
        {
            if (this._resultSet != null)
            {
                return this._resultSet.findGuestRoom(k);
            }
            return null;
        }
    }

