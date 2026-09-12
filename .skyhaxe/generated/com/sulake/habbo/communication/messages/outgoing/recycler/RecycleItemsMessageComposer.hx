package com.sulake.habbo.communication.messages.outgoing.recycler
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class RecycleItemsMessageComposer implements IMessageComposer
    {
        var stripItemIds:Array<ASAny>;

        public function new(k:Array<ASAny>)
        {
            this.stripItemIds = new Array<ASAny>();
            this.stripItemIds.push(k.length);
            this.stripItemIds = this.stripItemIds.concat(k);
        }

        public function dispose()
        {
        }

        public function getMessageArray():Array<ASAny>
        {
            return this.stripItemIds;
        }
    }

