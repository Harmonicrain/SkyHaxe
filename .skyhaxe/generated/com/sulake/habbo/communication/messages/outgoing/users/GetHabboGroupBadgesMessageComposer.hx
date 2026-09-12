package com.sulake.habbo.communication.messages.outgoing.users
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

     class GetHabboGroupBadgesMessageComposer implements IMessageComposer implements  IDisposable
    {


        public function getMessageArray():Array<ASAny>
        {
            return [];
        }

        public function dispose()
        {
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return false;
        }
public function new(){}
    }

