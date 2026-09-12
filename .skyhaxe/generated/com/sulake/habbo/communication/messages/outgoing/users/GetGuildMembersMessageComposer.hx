package com.sulake.habbo.communication.messages.outgoing.users
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class GetGuildMembersMessageComposer implements IMessageComposer
    {
        public static inline final _Str_13464= 0;
        public static inline final _Str_21687= 1;
        public static inline final _Str_17798= 2;

        var _array:Array<ASAny>;

        public function new(k:Int, _arg_2:Int, _arg_3:String, _arg_4:Int)
        {
            this._array = [];
            this._array.push(k);
            this._array.push(_arg_2);
            this._array.push(_arg_3);
            this._array.push(_arg_4);
        }

        public function getMessageArray():Array<ASAny>
        {
            return this._array;
        }

        public function dispose()
        {
            this._array = null;
        }
    }

