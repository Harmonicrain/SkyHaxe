package com.sulake.habbo.communication.messages.outgoing.help
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

     class CallForHelpMessageComposer implements IMessageComposer implements  IDisposable
    {
        var messageArray:Array<ASAny>;

        public function new(k:String, _arg_2:Int, _arg_3:Int, _arg_4:Int, _arg_5:Array<ASAny>)
        {
            this.messageArray = new Array<ASAny>();
            this.messageArray.push(k);
            this.messageArray.push(_arg_2);
            this.messageArray.push(_arg_3);
            this.messageArray.push(_arg_4);
            this.messageArray.push((_arg_5.length / 2));
            this.messageArray = this.messageArray.concat(_arg_5);
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

