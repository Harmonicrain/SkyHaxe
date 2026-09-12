package com.sulake.habbo.communication.messages.outgoing.inventory.badges
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class RequestABadgeComposer implements IMessageComposer
    {
        var _requestCode:String;

        public function new(k:String)
        {
            this._requestCode = k;
        }

        public function dispose()
        {
        }

        public function getMessageArray():Array<ASAny>
        {
            var k= new Array<ASAny>();
            k.push(this._requestCode);
            return k;
        }
    }

