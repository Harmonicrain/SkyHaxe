package com.sulake.habbo.communication.messages.outgoing.newnavigator
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class NavigatorSetSearchCodeViewModeMessageComposer implements IMessageComposer
    {
        var _Str_2907:Array<ASAny>;

        public function new(k:String, _arg_2:Int)
        {
            this._Str_2907 = [];
            this._Str_2907 = [k, _arg_2];
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

