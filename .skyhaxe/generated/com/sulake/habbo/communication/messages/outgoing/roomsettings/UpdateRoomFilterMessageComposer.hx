package com.sulake.habbo.communication.messages.outgoing.roomsettings
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

     class UpdateRoomFilterMessageComposer implements IMessageComposer implements  IDisposable 
    {
        public static var _Str_16408:Bool = true;
        public static var _Str_16962:Bool = false;

        var messageArray:Array<ASAny>;

        public function new(k:Int, _arg_2:Bool, _arg_3:String)
        {
            this.messageArray = new Array<ASAny>();
            this.messageArray.push(k);
            this.messageArray.push(_arg_2);
            this.messageArray.push(_arg_3);
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

