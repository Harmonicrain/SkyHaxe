package com.sulake.habbo.communication.messages.outgoing.newnavigator
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class NewNavigatorSearchComposer implements IMessageComposer
    {
        var _Str_2907:Array<ASAny>;

        public function new(k:String, _arg_2:String)
        {
            this._Str_2907 = [];
            this._Str_2907.push(k);
            this._Str_2907.push(_arg_2);
        }

        public function getMessageArray():Array<ASAny>
        {
            return this._Str_2907;
        }

        public function dispose()
        {
            this._Str_2907 = null;
        }
    }

