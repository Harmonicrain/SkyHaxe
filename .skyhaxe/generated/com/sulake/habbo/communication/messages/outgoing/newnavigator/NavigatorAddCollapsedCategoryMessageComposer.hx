package com.sulake.habbo.communication.messages.outgoing.newnavigator
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class NavigatorAddCollapsedCategoryMessageComposer implements IMessageComposer
    {
        var _Str_2907:Array<ASAny>;

        public function new(k:String)
        {
            this._Str_2907 = [];
            this._Str_2907.push(k);
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

