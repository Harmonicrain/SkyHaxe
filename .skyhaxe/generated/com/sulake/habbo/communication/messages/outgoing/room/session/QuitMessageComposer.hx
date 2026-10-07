package com.sulake.habbo.communication.messages.outgoing.room.session
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class QuitMessageComposer implements IMessageComposer
    {


        public function getMessageArray():Array<ASAny>
        {
            return new Array<ASAny>();
        }

        public function dispose()
        {
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return true;
        }
public function new(){}
    }

