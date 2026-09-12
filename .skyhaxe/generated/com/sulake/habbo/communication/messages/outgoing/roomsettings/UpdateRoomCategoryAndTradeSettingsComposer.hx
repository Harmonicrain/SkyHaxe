package com.sulake.habbo.communication.messages.outgoing.roomsettings
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

     class UpdateRoomCategoryAndTradeSettingsComposer implements IMessageComposer implements  IDisposable 
    {
        var messageArray:Array<ASAny>;

        public function new(k:Int, _arg_2:Int, _arg_3:Int)
        {
            this.messageArray = new Array<ASAny>();
            this.messageArray = [k, _arg_2, _arg_3];
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

