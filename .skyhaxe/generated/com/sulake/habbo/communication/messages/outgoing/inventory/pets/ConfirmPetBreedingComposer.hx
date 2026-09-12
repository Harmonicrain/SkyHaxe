package com.sulake.habbo.communication.messages.outgoing.inventory.pets
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class ConfirmPetBreedingComposer implements IMessageComposer
    {
        var _data:Array<ASAny>;

        public function new(k:Int, _arg_2:String, _arg_3:Int, _arg_4:Int)
        {
            this._data = [];
            this._data.push(k);
            this._data.push(_arg_2);
            this._data.push(_arg_3);
            this._data.push(_arg_4);
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

