package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class VariableList
    {
        static inline final MAX_VARIABLES= 16384;
        var _variables:Array<ASAny>;

        public function new(k:IMessageDataWrapper)
        {
var index = 0;            this._variables = [];
            var count= WiredMessageDataValidator.readCount(k, 25, MAX_VARIABLES,
                "VariableList entries");
            for (_tmp_ in 0...count)
            {
index= _tmp_;
                this._variables.push(new WiredVariable(k));
            }
        }

        public var variables(get,never):Array<ASAny>;
public function  get_variables():Array<ASAny> { return this._variables; }
    }

