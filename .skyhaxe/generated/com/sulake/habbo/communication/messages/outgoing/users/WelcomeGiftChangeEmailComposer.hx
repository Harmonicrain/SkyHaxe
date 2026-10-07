package com.sulake.habbo.communication.messages.outgoing.users
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class WelcomeGiftChangeEmailComposer implements IMessageComposer
    {
        var _newEmail:String;

        public function new(k:String)
        {
            this._newEmail = k;
        }

        public function dispose()
        {
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._newEmail];
        }
    }

