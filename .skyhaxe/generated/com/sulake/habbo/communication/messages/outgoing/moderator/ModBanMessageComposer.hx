package com.sulake.habbo.communication.messages.outgoing.moderator
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

     class ModBanMessageComposer implements IMessageComposer implements  IDisposable
    {
        public static inline final NO_ISSUE_ID= -1;

        var messageArray:Array<ASAny>;

        public function new(k:Int, _arg_2:String, _arg_3:Int, _arg_4:Int, _arg_5:Bool, _arg_6:Int)
        {
            this.messageArray = new Array<ASAny>();
            this.messageArray.push(k);
            this.messageArray.push(_arg_2);
            this.messageArray.push(_arg_3);
            this.messageArray.push(_arg_4);
            this.messageArray.push(_arg_5);
            if (_arg_6 != NO_ISSUE_ID)
            {
                this.messageArray.push(_arg_6);
            }
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

