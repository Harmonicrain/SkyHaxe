package com.sulake.habbo.communication.messages.outgoing.room.furniture
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class SetYoutubeDisplayPlaylistMessageComposer implements IMessageComposer
    {
        var messageArray:Array<ASAny>;

        public function new(k:Int, _arg_2:String)
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

