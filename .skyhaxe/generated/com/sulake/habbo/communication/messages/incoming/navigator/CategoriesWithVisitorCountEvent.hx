package com.sulake.habbo.communication.messages.incoming.navigator
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.navigator.CategoriesWithVisitorCountParser;

     class CategoriesWithVisitorCountEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, CategoriesWithVisitorCountParser);
        }

        public function getParser():CategoriesWithVisitorCountParser
        {
            return Std.downcast(this._parser , CategoriesWithVisitorCountParser);
        }
    }

