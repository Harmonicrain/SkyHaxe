package com.sulake.habbo.communication.messages.parser.userdefinedroomevents
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredMessageDataValidator;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;

    /** Bounded July variable-diff chunk parser. */
     class AllVariablesDiffMessageParser implements IMessageParser
    {
        static inline final MAX_VARIABLES_PER_CHUNK= 4096;

        var _allVariablesHash:Int = 0;
        var _isLastChunk:Bool = false;
        var _removedVariables:Vector<String>;
        var _addedOrUpdated:ASDictionary<ASAny,ASAny>;

        public function flush():Bool
        {
            this._allVariablesHash = 0;
            this._isLastChunk = false;
            this._removedVariables = null;
            this._addedOrUpdated = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
var count = 0, removedIds:ASObject  = null, index = 0, removedId:String  = null, updatedIds:ASObject  = null, variableHash = 0, variable:WiredVariable  = null;            try
            {
                WiredMessageDataValidator.requireBytes(k, 13, "Variable diff chunk");
                this._allVariablesHash = k.readInteger();
                this._isLastChunk = k.readBoolean();
count= WiredMessageDataValidator.readCount(k, 2,
                    MAX_VARIABLES_PER_CHUNK, "Removed variables");
                this._removedVariables = new Vector<String>();
removedIds= {};
                for (_tmp_ in 0...count)
                {
index= _tmp_;
removedId= k.readString();
                    if (ASCompat.getDynamicProperty(removedIds, removedId)== true)
                    {
                        throw new ASError("Variable diff chunk: duplicate removed variable " + removedId);
                    }
ASCompat.setDynamicProperty(                    removedIds, removedId, true);
                    this._removedVariables.push(removedId);
                }

                count = WiredMessageDataValidator.readCount(k, 29,
                    MAX_VARIABLES_PER_CHUNK, "Updated variables");
                this._addedOrUpdated = new ASDictionary<ASAny,ASAny>();
updatedIds= {};
                for (_tmp_ in 0...count)
                {
index= _tmp_;
variableHash= k.readInteger();
variable= new WiredVariable(k);
                    if (ASCompat.getDynamicProperty(removedIds, variable.variableId)== true ||
ASCompat.getDynamicProperty(                        updatedIds, variable.variableId)== true)
                    {
                        throw new ASError("Variable diff chunk: conflicting variable " + variable.variableId);
                    }
ASCompat.setDynamicProperty(                    updatedIds, variable.variableId, true);
                    this._addedOrUpdated[variable] = variableHash;
                }
                return k.bytesAvailable == 0;
            }
catch (__as3Caught:Dynamic) { var error:ASError = ASError.caught(__as3Caught);             {
                this.flush();
                return false;
            }
 }            return false;
        }

        public var allVariablesHash(get,never):Int;
public function  get_allVariablesHash():Int { return this._allVariablesHash; }
        public var isLastChunk(get,never):Bool;
public function  get_isLastChunk():Bool { return this._isLastChunk; }
        public var removedVariables(get,never):Vector<String>;
public function  get_removedVariables():Vector<String> { return this._removedVariables; }
        public var addedOrUpdated(get,never):ASDictionary<ASAny,ASAny>;
public function  get_addedOrUpdated():ASDictionary<ASAny,ASAny> { return this._addedOrUpdated; }

	public function new() {}
    }

