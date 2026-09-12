package com.sulake.habbo.communication.messages.outgoing.help
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class SearchFaqsMessageComposer implements IMessageComposer
    {
        var _searchString:String;

        public function new(k:String)
        {
            this._searchString = k;
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._searchString];
        }

        public function dispose()
        {
        }
    }

