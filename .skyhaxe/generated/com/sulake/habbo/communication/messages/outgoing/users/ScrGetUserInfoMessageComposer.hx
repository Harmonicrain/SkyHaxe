package com.sulake.habbo.communication.messages.outgoing.users
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

     class ScrGetUserInfoMessageComposer implements IMessageComposer implements  IDisposable
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

