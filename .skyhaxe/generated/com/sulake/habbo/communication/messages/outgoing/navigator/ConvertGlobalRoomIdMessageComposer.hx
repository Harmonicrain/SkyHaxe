package com.sulake.habbo.communication.messages.outgoing.navigator
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

     class ConvertGlobalRoomIdMessageComposer implements IMessageComposer implements  IDisposable
    {
        var flatId:String;

        public function new(k:String)
        {
            this.flatId = k;
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this.flatId];
        }

        public function dispose()
        {
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return false;
        }
    }

