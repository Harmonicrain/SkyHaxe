package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class VariableInfoAndHolders
    {
        static inline final MAX_HOLDERS= 65535;

        var _variable:WiredVariable;
        var _holders:Array<ASAny>;

        public function new(k:IMessageDataWrapper)
        {
var index = 0;            WiredMessageDataValidator.requireBytes(k, 29, "VariableInfoAndHolders");
            this._variable = new WiredVariable(k);
            this._holders = [];
            var count= WiredMessageDataValidator.readCount(k, 8, MAX_HOLDERS,
                "VariableInfoAndHolders holders");
            for (_tmp_ in 0...count)
            {
index= _tmp_;
                this._holders.push(new ObjectIdAndValuePair(k));
            }
        }

        public var variable(get,never):WiredVariable;
public function  get_variable():WiredVariable { return this._variable; }
        public var holders(get,never):Array<ASAny>;
public function  get_holders():Array<ASAny> { return this._holders; }
    }

