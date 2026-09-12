package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class SharedGlobalPlaceholderList
    {
        static inline final MAX_PLACEHOLDERS= 16384;
        var _sharedPlaceholders:Array<ASAny>;

        public function new(k:IMessageDataWrapper)
        {
var index = 0;            this._sharedPlaceholders = [];
            var count= WiredMessageDataValidator.readCount(k, 8, MAX_PLACEHOLDERS,
                "SharedGlobalPlaceholderList entries");
            for (_tmp_ in 0...count)
            {
index= _tmp_;
                this._sharedPlaceholders.push(new SharedGlobalPlaceholder(k));
            }
        }

        public var sharedPlaceholders(get,never):Array<ASAny>;
public function  get_sharedPlaceholders():Array<ASAny> { return this._sharedPlaceholders; }
    }

