package com.sulake.habbo.communication.messages.outgoing.room.pets
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class BreedPetsMessageComposer implements IMessageComposer
    {
        public static inline final _Str_17533= 0;
        public static inline final _Str_8664= 1;
        public static inline final _Str_9186= 2;

        var _data:Array<ASAny>;

        public function new(k:Int, _arg_2:Int, _arg_3:Int)
        {
            this._data = [];
            this._data.push(k);
            this._data.push(_arg_2);
            this._data.push(_arg_3);
        }

        public function getMessageArray():Array<ASAny>
        {
            return this._data;
        }

        public function dispose()
        {
            this._data = null;
        }
    }

