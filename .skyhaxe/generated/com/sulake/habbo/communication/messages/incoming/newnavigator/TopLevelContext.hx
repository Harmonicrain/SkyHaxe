package com.sulake.habbo.communication.messages.incoming.newnavigator
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class TopLevelContext 
    {
        var _searchCode:String;
        var _quickLinks:Vector<SavedSearch>;

        public function new(k:IMessageDataWrapper)
        {
            this._quickLinks = new Vector<SavedSearch>(0);
            this._searchCode = k.readString();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._Str_21438.push(new SavedSearch(k));
                _local_3++;
            }
        }

        public var searchCode(get,never):String;
public function  get_searchCode():String
        {
            return this._searchCode;
        }

        public var _Str_21438(get,never):Vector<SavedSearch>;
public function  get__Str_21438():Vector<SavedSearch>
        {
            return this._quickLinks;
        }
    }

