package com.sulake.habbo.communication.messages.outgoing.inventory.avatareffect
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class AvatarEffectActivatedComposer implements IMessageComposer
    {
        var _type:Int = 0;

        public function new(k:Int)
        {
            this._type = k;
        }

        public function dispose()
        {
        }

        public function getMessageArray():Array<ASAny>
        {
            var k= new Array<ASAny>();
            k.push(this._type);
            return k;
        }
    }

