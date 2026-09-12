package com.sulake.habbo.communication.messages.incoming.users
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.users._Str_9277;

     class UserTagsMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, _Str_9277);
        }

        public var tags(get,never):Array<ASAny>;
public function  get_tags():Array<ASAny>
        {
            return Std.downcast(_parser , _Str_9277).tags;
        }

        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return Std.downcast(_parser , _Str_9277).userId;
        }
    }

