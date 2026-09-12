package com.sulake.habbo.communication.messages.outgoing.moderator
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

     class ModeratorActionMessageComposer implements IMessageComposer implements  IDisposable
    {
        public static inline final ACTION_ALERT= 0;
        public static inline final ACTION_KICK= 1;
        public static inline final ACTION_MESSAGE= 3;
        public static inline final ACTION_MESSAGE_AND_SOFT_KICK= 4;

        var messageArray:Array<ASAny>;

        public function new(k:Int, _arg_2:String, _arg_3:String)
        {
            this.messageArray = new Array<ASAny>();
            this.messageArray.push(k);
            this.messageArray.push(_arg_2);
            this.messageArray.push(_arg_3);
        }

        public function getMessageArray():Array<ASAny>
        {
            return this.messageArray;
        }

        public function dispose()
        {
            this.messageArray = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return false;
        }
    }

