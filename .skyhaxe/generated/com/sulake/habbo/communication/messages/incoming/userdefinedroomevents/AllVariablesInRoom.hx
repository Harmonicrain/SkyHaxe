package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class AllVariablesInRoom
    {
        var _hash:Int = 0;
        var _variables:Array<ASAny>;

        public function new(k:IMessageDataWrapper)
        {
            WiredMessageDataValidator.requireBytes(k, 4, "AllVariablesInRoom");
            this._hash = k.readInteger();
        }

        public var variables(get,never):Array<ASAny>;
public function  get_variables():Array<ASAny> { return this._variables; }
        public var needsSynchronize(get,never):Bool;
public function  get_needsSynchronize():Bool { return this._variables == null; }
        public var hash(get,never):Int;
public function  get_hash():Int { return this._hash; }

        public function synchronize(k:Array<ASAny>)
        {
            this._variables = k != null ? k.copy() : [];
        }
    }

