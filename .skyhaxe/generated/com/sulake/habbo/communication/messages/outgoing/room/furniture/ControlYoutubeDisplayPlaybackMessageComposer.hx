package com.sulake.habbo.communication.messages.outgoing.room.furniture
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class ControlYoutubeDisplayPlaybackMessageComposer implements IMessageComposer
    {
        var messageArray:Array<ASAny>;

        public function new(k:Int, _arg_2:Int)
        {
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
    }

