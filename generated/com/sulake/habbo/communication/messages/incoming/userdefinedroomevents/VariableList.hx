package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class VariableList
    {
        static inline final MAX_VARIABLES= 16384;
        var _variables:Array<ASAny>;

        public function new(k:IMessageDataWrapper)
        {
            this._variables = [];
            var count= WiredMessageDataValidator.readCount(k, 25, MAX_VARIABLES,
                "VariableList entries");
            for (index in 0...count)
            {
                this._variables.push(new WiredVariable(k));
            }
        }

        public var variables(get,never):Array<ASAny>;
function  get_variables():Array<ASAny> { return this._variables; }
    }

