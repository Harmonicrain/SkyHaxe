package com.sulake.habbo.communication.messages.incoming.avatar
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.avatar.WardrobeMessageParser;

     class WardrobeMessageEvent extends MessageEvent implements IMessageEvent
    {
        public static inline final _Str_19210= 0;
        public static inline final _Str_19183= 1;

        public function new(k:ASFunction)
        {
            super(k, WardrobeMessageParser);
        }

        function getParser():WardrobeMessageParser
        {
            return Std.downcast(this._parser , WardrobeMessageParser);
        }

        public var _Str_17746(get,never):Array<ASAny>;
public function  get__Str_17746():Array<ASAny>
        {
            return this.getParser().outfits;
        }

        public var state(get,never):Int;
public function  get_state():Int
        {
            return this.getParser().state;
        }
    }

