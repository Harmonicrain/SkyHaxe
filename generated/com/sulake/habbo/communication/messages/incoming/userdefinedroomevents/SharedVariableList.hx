package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class SharedVariableList
    {
        static inline final MAX_SHARED_VARIABLES= 16384;

        var _sharedVariables:Array<ASAny>;
        var _variables:Array<ASAny>;

        public function new(k:IMessageDataWrapper)
        {
            this._sharedVariables = [];
            this._variables = [];
            var count= WiredMessageDataValidator.readCount(k, 31, MAX_SHARED_VARIABLES,
                "SharedVariableList entries");
            for (index in 0...count)
            {
                var shared= new SharedVariable(k);
                this._sharedVariables.push(shared);
                this._variables.push(shared.wiredVariable);
            }
        }

        public var variables(get,never):Array<ASAny>;
function  get_variables():Array<ASAny> { return this._variables; }
        public var sharedVariables(get,never):Array<ASAny>;
function  get_sharedVariables():Array<ASAny> { return this._sharedVariables; }
    }

