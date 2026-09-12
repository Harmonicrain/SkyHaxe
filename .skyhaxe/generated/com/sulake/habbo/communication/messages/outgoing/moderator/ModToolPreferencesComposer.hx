package com.sulake.habbo.communication.messages.outgoing.moderator
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

     class ModToolPreferencesComposer implements IMessageComposer implements  IDisposable
    {
        var messageArray:Array<ASAny>;

        public function new(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Int)
        {
            this.messageArray = new Array<ASAny>();
            this.messageArray.push(k);
            this.messageArray.push(_arg_2);
            this.messageArray.push(_arg_3);
            this.messageArray.push(_arg_4);
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
            return this.messageArray == null;
        }
    }

