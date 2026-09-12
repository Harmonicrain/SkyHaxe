package com.sulake.habbo.communication.messages.outgoing.inventory.badges
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class GetIsBadgeRequestFulfilledComposer implements IMessageComposer
    {
        var messageArray:Array<ASAny>;

        public function new(k:String)
        {
            this.messageArray = new Array<ASAny>();
            this.messageArray.push(k);
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

