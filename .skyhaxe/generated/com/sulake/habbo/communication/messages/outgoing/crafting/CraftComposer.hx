package com.sulake.habbo.communication.messages.outgoing.crafting
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

     class CraftComposer implements IMessageComposer implements  IDisposable
    {
        var messageArray:Array<ASAny>;

        public function new(k:Int, _arg_2:String)
        {
            this.messageArray = new Array<ASAny>();
            this.messageArray.push(k);
            this.messageArray.push(_arg_2);
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

