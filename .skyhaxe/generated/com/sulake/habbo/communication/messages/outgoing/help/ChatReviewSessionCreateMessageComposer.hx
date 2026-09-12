package com.sulake.habbo.communication.messages.outgoing.help
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

     class ChatReviewSessionCreateMessageComposer implements IMessageComposer implements  IDisposable
    {
        var messageArray:Array<ASAny>;

        public function new(k:Int, _arg_2:Int)
        {
            this.messageArray = [];
            this.messageArray = [k, _arg_2];
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
            return this.messageArray == null;
        }
    }

