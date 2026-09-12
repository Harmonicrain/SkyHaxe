package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

    /** July variable-diff request: count, then repeated variable-id/hash pairs. */
     class RequestVariablesDiffMessageComposer implements IMessageComposer implements  IDisposable
    {
        static inline final MAX_VARIABLES= 4096;

        var _array:Array<ASAny>;

        public function new(k:ASDictionary<ASAny,ASAny>)
        {
var id:String  = null;            this._array = [];
            var ids:Array<ASAny> = [];
            if (k != null)
            {
                if (checkNullIteratee(k)) for (_tmp_ in k.keys())
                {
id = _tmp_;
                    ids.push(id);
                }
            }
            if (ids.length > MAX_VARIABLES)
            {
                throw new ASError("Variable diff request exceeds " + Std.string(MAX_VARIABLES) + " entries");
            }

            // July permits any map order. Sorting makes retries byte-stable.
            ASCompat.ASArray.sortWithOptions(ids, ASCompat.ASArray.CASEINSENSITIVE);
            this._array.push(ids.length);
            if (checkNullIteratee(ids)) for (_tmp_ in ids)
            {
id = _tmp_;
                this._array.push(id);
                this._array.push(ASCompat.toInt(k[id]));
            }
        }

        public function getMessageArray():Array<ASAny>
        {
            return this._array;
        }

        public function dispose()
        {
            this._array = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._array == null;
        }
    }

