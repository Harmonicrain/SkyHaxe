package com.sulake.habbo.communication.messages.outgoing.competition
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class ForwardToASubmittableRoomMessageComposer implements IMessageComposer
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

