package com.sulake.habbo.communication.messages.outgoing.quest
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

     class GetConcurrentUsersRewardMessageComposer implements IMessageComposer implements  IDisposable
    {


        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return true;
        }

        public function getMessageArray():Array<ASAny>
        {
            return new Array<ASAny>();
        }

        public function dispose()
        {
        }
public function new(){}
    }

