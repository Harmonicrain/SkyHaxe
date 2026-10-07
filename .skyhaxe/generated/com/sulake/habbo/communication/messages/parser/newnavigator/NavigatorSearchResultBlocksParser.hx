package com.sulake.habbo.communication.messages.parser.newnavigator
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.newnavigator.SearchResultSet;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class NavigatorSearchResultBlocksParser implements IMessageParser
    {
        var _searchResult:SearchResultSet;


        public function flush():Bool
        {
            this._searchResult = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._searchResult = new SearchResultSet(k);
            return true;
        }

        public var searchResult(get,never):SearchResultSet;
public function  get_searchResult():SearchResultSet
        {
            return this._searchResult;
        }

	public function new() {}
    }

