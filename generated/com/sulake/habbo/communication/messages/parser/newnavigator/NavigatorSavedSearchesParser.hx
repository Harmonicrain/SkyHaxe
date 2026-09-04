package com.sulake.habbo.communication.messages.parser.newnavigator
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.newnavigator.SavedSearch;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class NavigatorSavedSearchesParser implements IMessageParser 
    {
        var _savedSearches:Vector<SavedSearch>;


        public function flush():Bool
        {
            this._savedSearches = new Vector<SavedSearch>(0);
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._savedSearches.push(new SavedSearch(k));
                _local_3++;
            }
            return true;
        }

        public var _Str_8597(get,never):Vector<SavedSearch>;
function  get__Str_8597():Vector<SavedSearch>
        {
            return this._savedSearches;
        }

	public function new() {}
    }

