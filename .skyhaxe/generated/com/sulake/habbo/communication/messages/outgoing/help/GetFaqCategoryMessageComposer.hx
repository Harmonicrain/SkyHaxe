package com.sulake.habbo.communication.messages.outgoing.help
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class GetFaqCategoryMessageComposer implements IMessageComposer
    {
        var _categoryId:Int = 0;

        public function new(k:Int)
        {
            this._categoryId = k;
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._categoryId];
        }

        public function dispose()
        {
        }
    }

