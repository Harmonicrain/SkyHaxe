package com.sulake.habbo.communication.messages.outgoing.moderator
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

     class ModerateRoomMessageComposer implements IMessageComposer implements  IDisposable
    {
        var messageArray:Array<ASAny>;

        public function new(k:Int, _arg_2:Bool, _arg_3:Bool, _arg_4:Bool)
        {
            this.messageArray = new Array<ASAny>();
            this.messageArray.push(k);
            this.messageArray.push((_arg_2 ? 1 : 0));
            this.messageArray.push((_arg_3 ? 1 : 0));
            this.messageArray.push((_arg_4 ? 1 : 0));
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

