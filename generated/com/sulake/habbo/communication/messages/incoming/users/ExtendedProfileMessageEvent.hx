package com.sulake.habbo.communication.messages.incoming.users
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.users.ExtendedProfileMessageParser;

     class ExtendedProfileMessageEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, ExtendedProfileMessageParser);
        }

        public var data(get,never):ExtendedProfileData;
function  get_data():ExtendedProfileData
        {
            return cast(_parser, ExtendedProfileMessageParser).data;
        }
    }

